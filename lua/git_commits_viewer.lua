
local M = {}

-- Store last valid refs for fallback
local last_valid_refs = nil

-- ─   -- Maps                                          ──
-- ~/.config/nvim/plugin/config/maps.lua‖/'<leader>gd',ˍfunction()
-- ~/.config/nvim/plugin/config/maps.lua‖*ˍˍˍGitˍpickerˍmaps

function M.GitDiff_BufferMaps()
  vim.keymap.set('n', '<leader><c-p>', function() M.TopLevBindingBackw() end, { silent = true, buffer = true })
  vim.keymap.set('n', '<c-p>', function() M.TopLevBindingBackw() end, { silent = true, buffer = true })
  vim.keymap.set('n', '<leader><c-n>', function() M.TopLevBindingForw() end, { silent = true, buffer = true })
  vim.keymap.set('n', '<c-n>', function() M.TopLevBindingForw() end, { silent = true, buffer = true })
  vim.keymap.set('n', 'q', function() M.close_cleanup() end, { silent = true, buffer = true })
end

-- A command for GitDiffBufferMaps
vim.api.nvim_create_user_command('GitDiffBufferMaps', function()
  M.GitDiff_BufferMaps()
end, { force = true })

vim.api.nvim_create_user_command('GitDiffFiles', function(args)
  if #args.fargs ~= 2 then
    vim.notify("GitDiffFiles requires exactly 2 arguments", vim.log.levels.ERROR)
    return
  end
  M.Show( { diff_file1 = args.fargs[1], diff_file2 = args.fargs[2] } )
end, {
  force = true,
  nargs = '+',
  desc = "Compare two files with git diff"
})

vim.api.nvim_create_user_command('GitDiffBranches', function(args)
  if #args.fargs ~= 2 then
    vim.notify("GitDiffBranches requires exactly 2 arguments", vim.log.levels.ERROR)
    return
  end
  M.ShowBranches(args.fargs[1], args.fargs[2])
end, {
  force = true,
  nargs = '+',
  desc = "Compare two git refs (branches, commits, HEAD, HEAD~1, tags, etc.)"
})


local top_level_patterns = {
  "•",
  "-----"
}

local top_level_patterns_str = '\\v' .. table.concat(top_level_patterns, "|")

function M.TopLevBindingForw()
  -- print(top_level_patterns_str)
  vim.fn.search( top_level_patterns_str, 'W' )
  vim.fn.ScrollOff(25)
end
-- vim.fn.search( 'local', 'W' )

function M.TopLevBindingBackw()
  vim.fn.search( top_level_patterns_str, 'bW' )
  vim.fn.ScrollOff(10)
end


-- Store terminal buffer ID for cleanup per tab
local term_jobs = {}
local prev_term_bufs = {}

-- Helper to get current tab's window references
local function get_tab_windows()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local tab_wins = vim.t[tabpage]
  if not tab_wins then
    vim.t[tabpage] = {}
    tab_wins = vim.t[tabpage]
  end
  return tab_wins, tabpage
end

function M.UpdateDiffView(commit_hash, filepath)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  -- go to diff_win
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'
  local tab_wins, tabpage = get_tab_windows()
  if filepath then
    -- Escape filepath for shell to handle brackets and special characters
    local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
    -- Use git show which handles both regular and initial commits (no parent)
    term_jobs[tabpage] = vim.fn.termopen('git show ' .. commit_hash .. ' -- ' .. escaped_filepath)
  else
    -- Show all changes in the commit
    term_jobs[tabpage] = vim.fn.termopen('git show ' .. commit_hash)
  end
  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    -- delete prev_term_buf
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_Untracked(filepath)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  -- go to diff_win
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'
  local tab_wins, tabpage = get_tab_windows()
  if filepath then
    -- Escape filepath for shell to handle brackets and special characters
    local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
    -- For completely new untracked files, use git diff against /dev/null to show as additions
    -- For modified tracked files, use regular git diff
    term_jobs[tabpage] = vim.fn.termopen('git diff --no-index /dev/null ' .. escaped_filepath .. ' 2>/dev/null || git diff -- ' .. escaped_filepath)
  else
    -- Show git diff for all tracked changes
    term_jobs[tabpage] = vim.fn.termopen('git diff HEAD')
  end
  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    -- delete prev_term_buf
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.GetFilesInCommit(commit_hash)
  local files = {}

  -- Get status info (including renames) - skip numstat for speed
  local status_handle = io.popen("git show --pretty='' --name-status " .. commit_hash .. " 2>/dev/null")
  if not status_handle then return files end
  local status_result = status_handle:read("*a")
  status_handle:close()

  -- Process status output (no line counts for speed)
  for line in status_result:gmatch("[^\n]+") do
    local status = line:match("^(%S+)")
    if status then
      local filepath, oldpath
      -- Handle renamed files (R100, R095, etc.)
      if status:match("^R") then
        oldpath, filepath = line:match("^%S+%s+(%S+)%s+(%S+)")
        if filepath and oldpath then
          table.insert(files, string.format("    %s %s -> %s", status, oldpath, filepath))
        end
      else
        filepath = line:match("^%S+%s+(.+)$")
        if filepath then
          table.insert(files, string.format("    %s %s", status, filepath))
        end
      end
    end
  end

  return files
end
-- require'git_commits_viewer'.GetFilesInCommit('424ee27')

-- Find common path prefix and return shortened paths
local function shorten_paths(path1, path2)
  -- Split paths into components
  local parts1 = vim.split(path1, "/", { plain = true })
  local parts2 = vim.split(path2, "/", { plain = true })

  -- Find common prefix
  local common_idx = 0
  for i = 1, math.min(#parts1, #parts2) do
    if parts1[i] == parts2[i] then
      common_idx = i
    else
      break
    end
  end

  -- If we found a common root (at least one level), start from there
  if common_idx > 0 then
    local short1 = table.concat(vim.list_slice(parts1, common_idx, #parts1), "/")
    local short2 = table.concat(vim.list_slice(parts2, common_idx, #parts2), "/")
    return short1, short2
  end

  -- No common root, return as-is
  return path1, path2
end

function M.GetFilesBetweenDirectories(dir1, dir2)
  local files = {}

  -- Use diff with recursive flag to compare directories
  local cmd = string.format("diff -qr %s %s 2>/dev/null || true",
    vim.fn.shellescape(dir1),
    vim.fn.shellescape(dir2))
  local handle = io.popen(cmd)
  if not handle then return files end

  local result = handle:read("*a")
  handle:close()

  -- Parse diff output
  for line in result:gmatch("[^\n]+") do
    if line:match("^Files .* and .* differ$") then
      -- Modified file
      local file1, file2 = line:match("^Files (.-) and (.-) differ$")
      if file1 and file2 then
        local rel_path = file2:gsub("^" .. vim.pesc(dir2) .. "/?", "")
        -- Get line count for this file
        local line_count = M.get_changed_lines_count_between_dirs(file1, file2)
        table.insert(files, string.format("    M %s %s", rel_path, line_count))
      end
    elseif line:match("^Only in " .. vim.pesc(dir1)) then
      -- Deleted file (exists in dir1 but not dir2)
      local subdir, filename = line:match("^Only in (.-): (.+)$")
      if subdir and filename then
        local rel_path = subdir:gsub("^" .. vim.pesc(dir1) .. "/?", "")
        if rel_path ~= "" then
          rel_path = rel_path .. "/" .. filename
        else
          rel_path = filename
        end
        table.insert(files, string.format("    D %s 0", rel_path))
      end
    elseif line:match("^Only in " .. vim.pesc(dir2)) then
      -- Added file (exists in dir2 but not dir1)
      local subdir, filename = line:match("^Only in (.-): (.+)$")
      if subdir and filename then
        local rel_path = subdir:gsub("^" .. vim.pesc(dir2) .. "/?", "")
        if rel_path ~= "" then
          rel_path = rel_path .. "/" .. filename
        else
          rel_path = filename
        end
        table.insert(files, string.format("    A %s 0", rel_path))
      end
    end
  end

  return files
end

function M.GetFilesBetweenBranches(branch1, branch2)
  local files = {}

  -- Get committed differences
  local handle = io.popen("git diff --name-status " .. branch1 .. ".." .. branch2)
  if not handle then return files end

  local result = handle:read("*a")
  handle:close()

  for line in result:gmatch("[^\n]+") do
    local status = line:match("^(%S+)")
    if status then
      local filepath, oldpath
      -- Handle renamed files (R100, R095, etc.)
      if status:match("^R") then
        oldpath, filepath = line:match("^%S+%s+(%S+)%s+(%S+)")
        if filepath and oldpath then
          local line_count = M.get_changed_lines_count_between_branches(filepath, branch1, branch2)
          table.insert(files, string.format("    %s %s -> %s %s", status, oldpath, filepath, line_count))
        end
      else
        filepath = line:match("^%S+%s+(.+)$")
        if filepath then
          local line_count = M.get_changed_lines_count_between_branches(filepath, branch1, branch2)
          table.insert(files, string.format("    %s %s %s", status, filepath, line_count))
        end
      end
    end
  end

  -- Get uncommitted changes from branch1 worktree
  local worktree1 = M.get_worktree_path(branch1)
  if worktree1 then
    local uncommitted1 = M.get_uncommitted_changes_from_worktree(worktree1)
    if #uncommitted1 > 0 then
      table.insert(files, "")
      table.insert(files, "  • uncommitted in " .. branch1 .. ":")
      for _, change in ipairs(uncommitted1) do
        table.insert(files, string.format("    %s %s %s", change.status, change.file, change.line_count))
      end
    end
  end

  -- Get uncommitted changes from branch2 worktree
  local worktree2 = M.get_worktree_path(branch2)
  if worktree2 then
    local uncommitted2 = M.get_uncommitted_changes_from_worktree(worktree2)
    if #uncommitted2 > 0 then
      table.insert(files, "")
      table.insert(files, "  • uncommitted in " .. branch2 .. ":")
      for _, change in ipairs(uncommitted2) do
        table.insert(files, string.format("    %s %s %s", change.status, change.file, change.line_count))
      end
    end
  end

  return files
end
-- require'git_commits_viewer'.GetFilesBetweenBranches('main', 'feature-branch')


function M.UpdateDiffView_FilesDiff(opts)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  -- go to diff_win
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'

  local tab_wins, tabpage = get_tab_windows()
  -- Escape filepaths for shell to handle brackets and special characters
  local escaped_file1 = "'" .. opts.diff_file1:gsub("'", "'\\'''") .. "'"
  local escaped_file2 = "'" .. opts.diff_file2:gsub("'", "'\\'''") .. "'"
  term_jobs[tabpage] = vim.fn.termopen('git diff --no-index -- ' .. escaped_file1 .. ' ' .. escaped_file2)

  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    -- delete prev_term_buf
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_BranchFile(branch1, branch2, filepath, status)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  vim.bo.filetype = 'gitdiff'

  local tab_wins, tabpage = get_tab_windows()
  local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
  term_jobs[tabpage] = vim.fn.termopen('git diff ' .. branch1 .. '..' .. branch2 .. ' -- ' .. escaped_filepath)

  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_BranchAll(branch1, branch2)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  vim.bo.filetype = 'gitdiff'

  local tab_wins, tabpage = get_tab_windows()
  term_jobs[tabpage] = vim.fn.termopen('git diff ' .. branch1 .. '..' .. branch2)

  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_WorktreeFile(worktree_path, filepath)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  vim.bo.filetype = 'gitdiff'

  local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
  local tab_wins, tabpage = get_tab_windows()
  local cmd = string.format(
    'git -C %s diff -- %s',
    vim.fn.shellescape(worktree_path),
    escaped_filepath
  )
  term_jobs[tabpage] = vim.fn.termopen(cmd)

  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_DirectoryFile(dir1, dir2, filepath, status)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  vim.bo.filetype = 'gitdiff'

  local tab_wins, tabpage = get_tab_windows()
  local file1 = dir1 .. "/" .. filepath
  local file2 = dir2 .. "/" .. filepath
  local escaped_file1 = "'" .. file1:gsub("'", "'\\'''") .. "'"
  local escaped_file2 = "'" .. file2:gsub("'", "'\\'''") .. "'"

  -- Handle deleted/added files
  if status == "D" then
    -- File only exists in dir1
    term_jobs[tabpage] = vim.fn.termopen('echo "File deleted: ' .. filepath .. '" && cat ' .. escaped_file1)
  elseif status == "A" then
    -- File only exists in dir2
    term_jobs[tabpage] = vim.fn.termopen('echo "File added: ' .. filepath .. '" && cat ' .. escaped_file2)
  else
    -- Normal diff
    term_jobs[tabpage] = vim.fn.termopen('git diff --no-index -- ' .. escaped_file1 .. ' ' .. escaped_file2)
  end

  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_DirectoryAll(dir1, dir2)
  local tab_wins = get_tab_windows()
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(tab_wins.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  vim.bo.filetype = 'gitdiff'

  local tab_wins, tabpage = get_tab_windows()
  local escaped_dir1 = "'" .. dir1:gsub("'", "'\\'''") .. "'"
  local escaped_dir2 = "'" .. dir2:gsub("'", "'\\'''") .. "'"
  term_jobs[tabpage] = vim.fn.termopen('git diff --no-index -- ' .. escaped_dir1 .. ' ' .. escaped_dir2)

  M.GitDiff_BufferMaps()
  if prev_term_bufs[tabpage] and vim.api.nvim_buf_is_valid(prev_term_bufs[tabpage]) then
    vim.api.nvim_buf_delete(prev_term_bufs[tabpage], { force = true })
  end
  prev_term_bufs[tabpage] = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end


-- Helper to find the uncommitted branch context by searching backwards
local function get_uncommitted_context()
  local current_line_num = vim.fn.line('.')
  for i = current_line_num - 1, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if line and line:match("^  • uncommitted in (.+):$") then
      return line:match("^  • uncommitted in (.+):$")
    end
    -- Stop if we hit a non-indented line that's not an uncommitted header
    if line and not line:match("^%s") and not line:match("^$") then
      break
    end
  end
  return nil
end

local function update_view_from_lines(opts)
  local tab_wins, tabpage = get_tab_windows()

  -- Kill previous terminal job if it exists
  if term_jobs[tabpage] then
    vim.fn.jobstop(term_jobs[tabpage])
    term_jobs[tabpage] = nil
  end


  if opts.diff_file1 then
    M.UpdateDiffView_FilesDiff(opts)
    return
  end

  if opts.diff_dir1 then
    local line = vim.api.nvim_get_current_line()
    -- Handle indented file lines
    if line:match("^%s") and not line:match("^  •") then
      local filepath, status
      -- Extract status (first non-whitespace word after indentation)
      status = line:match("^%s+(%S+)")
      -- Regular files (format: "    M file.lua")
      filepath = line:match("^%s+%S+%s+(.+)$")
      if filepath then
        M.UpdateDiffView_DirectoryFile(opts.diff_dir1, opts.diff_dir2, filepath, status)
      end
      return
    end
    -- Handle directory header line
    M.UpdateDiffView_DirectoryAll(opts.diff_dir1, opts.diff_dir2)
    return
  end

  if opts.diff_branch1 then
    local line = vim.api.nvim_get_current_line()
    -- Handle indented file lines
    if line:match("^%s") and not line:match("^  •") then
      local filepath, status
      -- Extract status (first non-whitespace word after indentation)
      status = line:match("^%s+(%S+)")
      -- Check for renamed files (format: "    R100 old.lua -> new.lua")
      if line:match("->") then
        filepath = line:match("->%s+(.+)$")
      else
        -- Regular files (format: "    M file.lua")
        filepath = line:match("^%s+%S+%s+(.+)$")
      end
      if filepath then
        -- Check if this is an uncommitted change
        local uncommitted_branch = get_uncommitted_context()
        if uncommitted_branch then
          -- This is an uncommitted file, show diff from worktree
          local worktree_path = M.get_worktree_path(uncommitted_branch)
          if worktree_path then
            M.UpdateDiffView_WorktreeFile(worktree_path, filepath)
          end
        else
          -- This is a committed diff between branches
          M.UpdateDiffView_BranchFile(opts.diff_branch1, opts.diff_branch2, filepath, status)
        end
      end
      return
    end
    -- Handle branch header line
    M.UpdateDiffView_BranchAll(opts.diff_branch1, opts.diff_branch2)
    return
  end

  local line = vim.api.nvim_get_current_line()

  -- Handle untracked changes header line
  if line:match("^untracked changes") then
    M.UpdateDiffView_Untracked()
    return
  end

  -- Handle indented file lines
  if line:match("^%s") then
    local filepath
    -- Check for renamed files (format: "    R100 old.lua -> new.lua")
    if line:match("->") then
      filepath = line:match("->%s+(.+)$")
    else
      -- Regular files (format: "    M file.lua")
      filepath = line:match("^%s+%S+%s+(.+)$")
    end
    if filepath then
      -- Find commit hash or untracked by searching backwards for the next unindented line
      local prev_word = M.get_prev_line_first_word()

      if prev_word == "untracked" then
        -- For untracked changes, run git diff without commit hash
        M.UpdateDiffView_Untracked(filepath)
      elseif prev_word then
        -- For regular commits
        M.UpdateDiffView(prev_word, filepath)
      end
    end
    return
  end

  -- Handle commit hash lines
  local commit_hash = line:match("^(%w+)")
  if commit_hash then
    M.UpdateDiffView(commit_hash)
  end
end


-- Validate if git refs are valid
local function validate_refs(ref1, ref2)
  -- Check if empty or whitespace only
  if not ref1 or ref1:match("^%s*$") or not ref2 or ref2:match("^%s*$") then
    return false
  end

  -- Try running git command to validate refs
  local handle = io.popen("git rev-parse " .. ref1 .. " " .. ref2 .. " 2>&1")
  if not handle then return false end

  local result = handle:read("*a")
  local success = handle:close()

  -- If git command succeeded and output doesn't contain "fatal"
  return success and not result:match("fatal")
end

-- Wrapper for branch/ref comparison with fallback
function M.ShowBranches(branch1, branch2)
  local using_fallback = false

  -- Validate provided refs
  if not validate_refs(branch1, branch2) then
    -- Try fallback to last valid refs
    if last_valid_refs then
      branch1 = last_valid_refs.branch1
      branch2 = last_valid_refs.branch2
      using_fallback = true
      vim.notify(
        string.format("Invalid refs, using fallback: %s..%s", branch1, branch2),
        vim.log.levels.WARN
      )
    else
      vim.notify("Invalid git refs and no previous refs to fall back to", vim.log.levels.ERROR)
      return
    end
  else
    -- Store valid refs for future fallback
    last_valid_refs = { branch1 = branch1, branch2 = branch2 }
  end

  M.Show({ diff_branch1 = branch1, diff_branch2 = branch2 })
end

-- function M.Show(num_of_commits, diff_file1, diff_file2)
function M.Show( opts )
  -- Create temporary window for diff view
  vim.g["curr_main_buffer"] = vim.fn.expand('%:p')
  vim.cmd('vsplit')
  local diff_win = vim.api.nvim_get_current_win()
  local diff_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(diff_win, diff_buf)

  -- Show another temp buffer below for commits list
  vim.cmd('split')
  vim.cmd('resize 10')
  local commits_buf = vim.api.nvim_create_buf(false, true)
  local commits_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(commits_win, commits_buf)

  -- Store window references in tab-local storage
  local tab_wins, tabpage = get_tab_windows()
  tab_wins.diff_win = diff_win
  tab_wins.commits_win = commits_win
  vim.api.nvim_win_set_option(commits_win, 'wrap', false)

  if opts.diff_file1 then
    local info_lines = { opts.diff_file1, opts.diff_file2 }
    vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, info_lines)
  elseif opts.diff_dir1 then
    -- Shorten paths by finding common root
    local short1, short2 = shorten_paths(opts.diff_dir1, opts.diff_dir2)
    local dir_lines = { short1, short2 }
    local files = M.GetFilesBetweenDirectories(opts.diff_dir1, opts.diff_dir2)
    for _, file in ipairs(files) do
      table.insert(dir_lines, file)
    end
    vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, dir_lines)
  elseif opts.diff_branch1 then
    -- Use two lines instead of ".." concatenation
    local branch_lines = { opts.diff_branch1, opts.diff_branch2 }
    local files = M.GetFilesBetweenBranches(opts.diff_branch1, opts.diff_branch2)
    for _, file in ipairs(files) do
      table.insert(branch_lines, file)
    end
    vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, branch_lines)
  else
    -- Use GetCommitLines() to insert commit history into the lower buffer
    local commit_lines = M.GetCommitLines(opts.num_of_commits or 5, opts.file)
    vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, commit_lines)
  end

  -- Set a custom filetype
  vim.api.nvim_buf_set_option(commits_buf, 'filetype', 'markdown')

  -- Set buffer options
  vim.api.nvim_buf_set_option(commits_buf, 'modifiable', true)
  vim.api.nvim_buf_set_option(commits_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(commits_buf, 'bufhidden', 'wipe')

  -- Set up mapping for 'p' to show diff for commit hash
  vim.keymap.set('n', 'P', function()
    update_view_from_lines(opts)
  end, { buffer = commits_buf, noremap = true })

  vim.keymap.set('n', 'p', function()
    update_view_from_lines(opts)
    -- set cursor to diff window
    local tab_wins = get_tab_windows()
    vim.api.nvim_set_current_win(tab_wins.diff_win)
  end, { buffer = commits_buf, noremap = true })

  -- Navigate and preview: move cursor down and update diff view
  vim.keymap.set('n', '<c-j>', function()
    vim.cmd('normal! j')
    update_view_from_lines(opts)
  end, { buffer = commits_buf, noremap = true, desc = 'Next item and preview diff' })

  -- Navigate and preview: move cursor up and update diff view
  vim.keymap.set('n', '<c-k>', function()
    vim.cmd('normal! k')
    update_view_from_lines(opts)
  end, { buffer = commits_buf, noremap = true, desc = 'Previous item and preview diff' })

  -- Add 'q' mapping to close both windows
  vim.keymap.set('n', 'q', function()
    M.close_cleanup()
  end, { buffer = commits_buf, noremap = true })

  M.set_highlights()

  -- Show initial diff view
  update_view_from_lines(opts)

  -- Add autocmd to close both windows when either is closed
  local augroup = vim.api.nvim_create_augroup('GitCommitViewerGroup', { clear = true })

  -- Monitor window closed events for either window
  vim.api.nvim_create_autocmd('WinClosed', {
    group = augroup,
    pattern = tostring(diff_win),
    callback = function()
      -- If the diff window was closed, close everything else
      M.close_cleanup()
    end,
    once = true
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    group = augroup,
    pattern = tostring(commits_win),
    callback = function()
      -- If the commits window was closed, close everything else
      M.close_cleanup()
    end,
    once = true
  })
end
-- require'git_commits_viewer'.Show(2, 0, 0)

-- Show the history of the current file
function M.ShowCurrentFile(num_of_commits)
  local current_file = vim.fn.expand('%:p')
  if current_file == '' then
    vim.notify("No file currently open", vim.log.levels.WARN)
    return
  end
  M.Show({ num_of_commits = num_of_commits or 5, file = current_file })
end
-- require'git_commits_viewer'.ShowCurrentFile(5)

-- Return one line per commit in the cwd. limit this to 10 lines.
-- line format:
-- commithash | time ago | author abbrev | commit message
-- line example:
-- 24ad3c1f | 4 days ago | AT | changed something
function M.GetUntrackedChanges()
  local files = {}
  local handle = io.popen("git status --short")
  if not handle then return files end

  local result = handle:read("*a")
  handle:close()

  for line in result:gmatch("[^\n]+") do
    -- Extract the status and file path from git status output
    local status, file = line:match("^(..) (.+)$")
    if file then
      local line_count
      -- If status starts with '??', it's a new untracked file or directory
      if status and status:match("^%?%?") then
        -- Check if this is a directory (ends with /)
        if file:match("/$") then
          -- Expand directory to show individual files
          local dir_handle = io.popen("find " .. vim.fn.shellescape(file) .. " -type f 2>/dev/null")
          if dir_handle then
            local dir_result = dir_handle:read("*a")
            dir_handle:close()
            for filepath in dir_result:gmatch("[^\n]+") do
              table.insert(files, string.format("    %s %s", "??", filepath))
            end
          end
        else
          -- Regular file (no line counts for speed)
          local status_abbrev = status:gsub("%s", "")
          table.insert(files, string.format("    %s %s", status_abbrev, file))
        end
      else
        -- Tracked but modified files (no line counts for speed)
        local status_abbrev = status:gsub("%s", "")
        table.insert(files, string.format("    %s %s", status_abbrev, file))
      end
    end
  end

  return files
end

function M.GetCommitLines(num_of_commits, file_filter)
  local lines = {}

  -- Add untracked changes as a special first entry
  local untracked_files = M.GetUntrackedChanges()
  if #untracked_files > 0 then
    table.insert(lines, "untracked changes")
    for _, file in ipairs(untracked_files) do
      table.insert(lines, file)
    end
  end

  local git_cmd = "git log --pretty=format:'%h|%cr|%s' -n " .. num_of_commits
  if file_filter then
    -- Add file filter and --follow to track renames
    git_cmd = git_cmd .. " --follow -- '" .. file_filter:gsub("'", "'\\'''") .. "'"
  end
  local handle = io.popen(git_cmd)
  if not handle then return lines end

  local result = handle:read("*a")
  handle:close()

  for line in result:gmatch("[^\n]+") do
    local hash, time_ago, message = line:match("([^|]+)|([^|]+)|(.+)")
    if hash and time_ago and message then
      -- Get number of files affected by this commit
      -- local files_handle = io.popen("git show --pretty='' --name-only " .. hash .. " | wc -l")
      -- local files_count = "0 f"
      -- if files_handle then
      --   files_count = files_handle:read("*n") .. " f"
      --   files_handle:close()
      -- end

      local author_abbrev = ""
      local author_handle = io.popen("git show -s --format='%an' " .. hash)
      if author_handle then
        author_abbrev = author_handle:read("*a")
        -- only keep the first two chars of the author str
        author_abbrev = author_abbrev:sub(1, 2)
        author_handle:close()
      end

      -- Abbreviate time
      time_ago = time_ago:gsub("minutes?", "m"):gsub("hours?", "h"):gsub("days?", "d"):gsub("weeks?", "w"):gsub("months?", "mo"):gsub("years?", "y"):gsub("ago", "")
      time_ago = time_ago:gsub("seconds?", "s"):gsub("hours?", "h"):gsub("days?", "d"):gsub("weeks?", "w"):gsub("months?", "mo"):gsub("years?", "y"):gsub("ago", "")
      -- remove spaces
      time_ago = time_ago:gsub("%s+", "")

      -- Format the line
      table.insert(lines, string.format("%s %s %s | %s", hash, time_ago, author_abbrev, message))
      local additional_lines = M.GetFilesInCommit( hash )

      -- Limit files per commit to prevent performance issues with large commits
      local max_files = 100
      local file_count = 0
      for _, file in ipairs(additional_lines) do
        if file_count >= max_files then
          table.insert(lines, string.format("    ... and %d more files", #additional_lines - max_files))
          break
        end
        table.insert(lines, file)
        file_count = file_count + 1
      end
    end
  end

  return lines
end
-- require'git_commits_viewer'.GetCommitLines(2)

-- ─   Worktree Helpers                                ──

-- Find the worktree path for a given branch
function M.get_worktree_path(branch)
  local handle = io.popen("git worktree list --porcelain")
  if not handle then return nil end

  local result = handle:read("*a")
  handle:close()

  local current_worktree = nil
  for line in result:gmatch("[^\n]+") do
    if line:match("^worktree ") then
      current_worktree = line:match("^worktree (.+)$")
    elseif line:match("^branch ") and current_worktree then
      local worktree_branch = line:match("^branch refs/heads/(.+)$")
      if worktree_branch == branch then
        return current_worktree
      end
      current_worktree = nil
    end
  end

  return nil
end

-- Get uncommitted changes from a specific worktree
function M.get_uncommitted_changes_from_worktree(worktree_path)
  local files = {}
  local handle = io.popen("git -C " .. vim.fn.shellescape(worktree_path) .. " status --short")
  if not handle then return files end

  local result = handle:read("*a")
  handle:close()

  for line in result:gmatch("[^\n]+") do
    local status, file = line:match("^(..) (.+)$")
    if file then
      local line_count
      if status and status:match("^%?%?") then
        line_count = "N"
      else
        -- Get line count for modified files
        local cmd = string.format(
          "git -C %s diff --numstat -- %s",
          vim.fn.shellescape(worktree_path),
          vim.fn.shellescape(file)
        )
        local count_handle = io.popen(cmd)
        if count_handle then
          local count_result = count_handle:read("*a")
          count_handle:close()
          local added, deleted = count_result:match("(%d+)%s+(%d+)")
          if added and deleted then
            line_count = tostring(tonumber(added) + tonumber(deleted))
          else
            line_count = "0"
          end
        else
          line_count = "0"
        end
      end
      table.insert(files, {
        status = status:match("^(%S+)"),
        file = file,
        line_count = line_count
      })
    end
  end

  return files
end

-- ─   Helpers                                          ──

function M.get_changed_lines_count(filepath, githash)
  -- NOTE: This is now only used for untracked files and special cases
  -- Regular commits use the batch processing in GetFilesInCommit()

  -- Escape filepath for shell to handle brackets and special characters
  local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"

  local cmd
  if githash and githash ~= "untracked" then
    -- For initial commits (no parent), compare against empty tree
    -- Use git show which handles both regular and root commits
    cmd = string.format("git show --numstat --format='' %s -- %s 2>/dev/null", githash, escaped_filepath)
  else
    -- For untracked changes
    cmd = string.format("git diff --numstat -- %s 2>/dev/null", escaped_filepath)
  end

  local handle = io.popen(cmd)
  if not handle then return "0" end

  local result = handle:read("*a")
  handle:close()

  -- Parse the numstat output: <added>\t<deleted>\t<file>
  local added, deleted = result:match("(%d+)%s+(%d+)")
  if added and deleted then
    -- Return sum of added and deleted lines
    return tostring(tonumber(added) + tonumber(deleted))
  end

  return "0"
end

function M.get_changed_lines_count_between_branches(filepath, branch1, branch2)
  local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
  local cmd = string.format("git diff --numstat %s..%s -- %s 2>/dev/null", branch1, branch2, escaped_filepath)

  local handle = io.popen(cmd)
  if not handle then return "0" end

  local result = handle:read("*a")
  handle:close()

  local added, deleted = result:match("(%d+)%s+(%d+)")
  if added and deleted then
    return tostring(tonumber(added) + tonumber(deleted))
  end

  return "0"
end

function M.get_changed_lines_count_between_dirs(file1, file2)
  local escaped_file1 = "'" .. file1:gsub("'", "'\\'''") .. "'"
  local escaped_file2 = "'" .. file2:gsub("'", "'\\'''") .. "'"
  local cmd = string.format("git diff --no-index --numstat -- %s %s 2>/dev/null || true", escaped_file1, escaped_file2)

  local handle = io.popen(cmd)
  if not handle then return "0" end

  local result = handle:read("*a")
  handle:close()

  local added, deleted = result:match("(%d+)%s+(%d+)")
  if added and deleted then
    return tostring(tonumber(added) + tonumber(deleted))
  end

  return "0"
end

function M.close_cleanup()
  local tab_wins, tabpage = get_tab_windows()

  -- Close both windows
  if tab_wins.diff_win and vim.api.nvim_win_is_valid(tab_wins.diff_win) then
    vim.api.nvim_win_close(tab_wins.diff_win, true)
  end
  if tab_wins.commits_win and vim.api.nvim_win_is_valid(tab_wins.commits_win) then
    vim.api.nvim_win_close(tab_wins.commits_win, true)
  end

  -- Clean up terminal job if it exists
  if term_jobs[tabpage] then
    vim.fn.jobstop(term_jobs[tabpage])
    term_jobs[tabpage] = nil
  end

  -- Clean up tab-local storage
  tab_wins.diff_win = nil
  tab_wins.commits_win = nil
end

function M.set_highlights()
  local curr_filepath = vim.g["curr_main_buffer"]
  local curr_filename = vim.fn.fnamemodify(curr_filepath, ":t:r")
  local curr_folder   = vim.fn.fnamemodify(curr_filepath, ":h:t")
  -- Indented lines
  -- vim.fn.matchadd('Comment', '^    .\\+$', 11, -1)
  vim.fn.matchadd('Comment', '.\\+$', 11, -1)
  -- Text after a |
  vim.fn.matchadd('NeoTreeDirectoryName', '| .\\+$', 11, -1)
  vim.fn.matchadd('HponFolderSel', curr_folder .. "\\ze\\/", 11, -1)
  vim.fn.matchadd('HponFileSel', curr_filename .. "\\ze\\.", 11, -1)

  -- File lines are lighlighted as comments
  vim.fn.matchadd('Comment', '.\\+$', 11, -1)
  -- Text after a |
  vim.fn.matchadd('NeoTreeDirectoryName', '| .\\+$', 11, -1)
  vim.fn.matchadd('HponFolderSel', curr_folder .. "\\ze\\/", 11, -1)
  vim.fn.matchadd('HponFileSel', curr_filename .. "\\ze\\.", 11, -1)

  -- NOTE: caution! this cmd needs " " at the end! so don't run "ll c l" ClearSpaces in this file!!
  vim.cmd([[
      syntax match Normal '/' conceal cchar= 
      ]])
end

function M.get_prev_line_commit_hash()
  -- search backwards for an unindented line
  local lineNum = vim.fn.searchpos( [[^\S]], 'bnW' )[1]
  local firstWord = vim.api.nvim_buf_get_lines(0, lineNum - 1, lineNum, false)[1]:match( [[^%w+]] )
  return firstWord
end

function M.get_prev_line_first_word()
  -- search backwards for an unindented line
  local lineNum = vim.fn.searchpos( [[^\S]], 'bnW' )[1]
  local line = vim.api.nvim_buf_get_lines(0, lineNum - 1, lineNum, false)[1]
  local firstWord = line:match("^(%S+)")
  return firstWord
end
  -- eins (uncomment these lines to test)
-- zwei vier
  -- drei
-- require'git_commits_viewer'.get_prev_line_commit_hash()


return M




