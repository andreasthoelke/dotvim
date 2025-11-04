
local M = {}

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
  M.Show( { diff_branch1 = args.fargs[1], diff_branch2 = args.fargs[2] } )
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


-- Store terminal buffer ID for cleanup
local term_job_id = nil
local prev_term_buf = nil

function M.UpdateDiffView(commit_hash, filepath)

  local current_win = vim.api.nvim_get_current_win()
  -- go to M.diff_win
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'
  if filepath then
    -- Escape filepath for shell to handle brackets and special characters
    local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
    term_job_id = vim.fn.termopen('git diff ' .. commit_hash .. '^ ' .. commit_hash .. ' -- ' .. escaped_filepath)
  else
    term_job_id = vim.fn.termopen('git diff ' .. commit_hash .. '^ ' .. commit_hash)
  end
  M.GitDiff_BufferMaps()
  if prev_term_buf and vim.api.nvim_buf_is_valid(prev_term_buf) then
    -- delete prev_term_buf
    vim.api.nvim_buf_delete(prev_term_buf, { force = true })
  end
  prev_term_buf = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_Untracked(filepath)

  local current_win = vim.api.nvim_get_current_win()
  -- go to M.diff_win
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'
  if filepath then
    -- Escape filepath for shell to handle brackets and special characters
    local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
    term_job_id = vim.fn.termopen('git diff -- ' .. escaped_filepath)
  else
    term_job_id = vim.fn.termopen('git diff')
  end
  M.GitDiff_BufferMaps()
  if prev_term_buf and vim.api.nvim_buf_is_valid(prev_term_buf) then
    -- delete prev_term_buf
    vim.api.nvim_buf_delete(prev_term_buf, { force = true })
  end
  prev_term_buf = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.GetFilesInCommit(commit_hash)
  local files = {}
  local handle = io.popen("git show --pretty='' --name-only " .. commit_hash)
  if not handle then return files end

  local result = handle:read("*a")
  handle:close()

  for file in result:gmatch("[^\n]+") do
    local line_count = M.get_changed_lines_count(file, commit_hash)
    table.insert(files, string.format("    %s %s", file, line_count))
  end

  return files
end
-- require'git_commits_viewer'.GetFilesInCommit('424ee27')

function M.GetFilesBetweenBranches(branch1, branch2)
  local files = {}
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

  return files
end
-- require'git_commits_viewer'.GetFilesBetweenBranches('main', 'feature-branch')


function M.UpdateDiffView_FilesDiff(opts)

  local current_win = vim.api.nvim_get_current_win()
  -- go to M.diff_win
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'

  -- Escape filepaths for shell to handle brackets and special characters
  local escaped_file1 = "'" .. opts.diff_file1:gsub("'", "'\\'''") .. "'"
  local escaped_file2 = "'" .. opts.diff_file2:gsub("'", "'\\'''") .. "'"
  term_job_id = vim.fn.termopen('git diff --no-index -- ' .. escaped_file1 .. ' ' .. escaped_file2)

  M.GitDiff_BufferMaps()
  if prev_term_buf and vim.api.nvim_buf_is_valid(prev_term_buf) then
    -- delete prev_term_buf
    vim.api.nvim_buf_delete(prev_term_buf, { force = true })
  end
  prev_term_buf = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_BranchFile(branch1, branch2, filepath, status)
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  vim.bo.filetype = 'gitdiff'

  local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"
  term_job_id = vim.fn.termopen('git diff ' .. branch1 .. '..' .. branch2 .. ' -- ' .. escaped_filepath)

  M.GitDiff_BufferMaps()
  if prev_term_buf and vim.api.nvim_buf_is_valid(prev_term_buf) then
    vim.api.nvim_buf_delete(prev_term_buf, { force = true })
  end
  prev_term_buf = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_BranchAll(branch1, branch2)
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  vim.bo.filetype = 'gitdiff'

  term_job_id = vim.fn.termopen('git diff ' .. branch1 .. '..' .. branch2)

  M.GitDiff_BufferMaps()
  if prev_term_buf and vim.api.nvim_buf_is_valid(prev_term_buf) then
    vim.api.nvim_buf_delete(prev_term_buf, { force = true })
  end
  prev_term_buf = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end


local function update_view_from_lines(opts)

  -- Kill previous terminal job if it exists
  if term_job_id then
    vim.fn.jobstop(term_job_id)
    term_job_id = nil
  end


  if opts.diff_file1 then
    M.UpdateDiffView_FilesDiff(opts)
    return
  end

  if opts.diff_branch1 then
    local line = vim.api.nvim_get_current_line()
    -- Handle indented file lines
    if line:match("^%s") then
      local filepath, status
      -- Extract status (first non-whitespace word after indentation)
      status = line:match("^%s+(%S+)")
      -- Check for renamed files (format: "    R100 old.lua -> new.lua 42")
      if line:match("->") then
        filepath = line:match("->%s+(.-)%s+%d+$")
      else
        -- Regular files (format: "    M file.lua 42")
        filepath = line:match("^%s+%S+%s+(.-)%s+%d+$")
      end
      if filepath then
        M.UpdateDiffView_BranchFile(opts.diff_branch1, opts.diff_branch2, filepath, status)
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
    -- Extract filepath without the line count at the end
    local filepath = line:match("^%s+([^%d]+)")
    if filepath then
      -- Remove trailing whitespace
      filepath = filepath:match("^(.-)%s*$")
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


-- function M.Show(num_of_commits, diff_file1, diff_file2)
function M.Show( opts )
  -- Create temporary window for diff view
  vim.g["curr_main_buffer"] = vim.fn.expand('%:p')
  vim.cmd('vsplit')
  local diff_win = vim.api.nvim_get_current_win()
  local diff_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(diff_win, diff_buf)

  -- Store window reference for later use
  M.diff_win = diff_win

  -- Show another temp buffer below for commits list
  vim.cmd('split')
  vim.cmd('resize 10')
  local commits_buf = vim.api.nvim_create_buf(false, true)
  local commits_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(commits_win, commits_buf)

  -- Store window reference for later use
  M.commits_win = commits_win
  vim.api.nvim_win_set_option(commits_win, 'wrap', false)

  if opts.diff_file1 then
    local info_lines = { opts.diff_file1, opts.diff_file2 }
    vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, info_lines)
  elseif opts.diff_branch1 then
    local branch_lines = { opts.diff_branch1 .. ".." .. opts.diff_branch2 }
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
    vim.api.nvim_set_current_win(M.diff_win)
  end, { buffer = commits_buf, noremap = true })

  -- Add 'q' mapping to close both windows
  vim.keymap.set('n', 'q', function()
    M.close_cleanup()
  end, { buffer = commits_buf, noremap = true })

  M.set_highlights()

  -- Initially show untracked changes if there are any
  -- local untracked_files = M.GetUntrackedChanges()
  -- if #untracked_files > 0 then
    -- M.UpdateDiffView_Untracked()
  -- end

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
      -- If status starts with '??', it's a new untracked file
      if status and status:match("^%?%?") then
        line_count = "N"
      else
        line_count = M.get_changed_lines_count(file, "untracked")
      end
      table.insert(files, string.format("    %s %s", file, line_count))
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
      for _, file in ipairs(additional_lines) do
        table.insert(lines, file)
      end
    end
  end

  return lines
end
-- require'git_commits_viewer'.GetCommitLines(2)

-- ─   Helpers                                          ──

function M.get_changed_lines_count(filepath, githash)
  -- Escape filepath for shell to handle brackets and special characters
  local escaped_filepath = "'" .. filepath:gsub("'", "'\\'''") .. "'"

  local cmd
  if githash and githash ~= "untracked" then
    -- For regular commits
    cmd = string.format("git diff --numstat %s^ %s -- %s", githash, githash, escaped_filepath)
  else
    -- For untracked changes
    cmd = string.format("git diff --numstat -- %s", escaped_filepath)
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
  local cmd = string.format("git diff --numstat %s..%s -- %s", branch1, branch2, escaped_filepath)

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
  -- Close both windows
  if vim.api.nvim_win_is_valid(M.diff_win) then
    vim.api.nvim_win_close(M.diff_win, true)
  end
  if vim.api.nvim_win_is_valid(M.commits_win) then
    vim.api.nvim_win_close(M.commits_win, true)
  end

  -- Clean up terminal job if it exists
  if term_job_id then
    vim.fn.jobstop(term_job_id)
    term_job_id = nil
  end
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




