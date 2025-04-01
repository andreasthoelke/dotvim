
local M = {}

-- ─   -- Maps                                          ──
-- old telescope Git_commits_picker maps
-- ~/.config/nvim/plugin/config/maps.lua‖*ˍˍˍGitˍpickerˍmaps

function M.GitDiff_BufferMaps()
  vim.keymap.set('n', '<leader><c-p>', function() M.TopLevBindingBackw() end, { silent = true, buffer = true })
  vim.keymap.set('n', '<c-p>', function() M.TopLevBindingBackw() end, { silent = true, buffer = true })
  vim.keymap.set('n', '<leader><c-n>', function() M.TopLevBindingForw() end, { silent = true, buffer = true })
  vim.keymap.set('n', '<c-n>', function() M.TopLevBindingForw() end, { silent = true, buffer = true })
end

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
  -- Kill previous terminal job if it exists
  if term_job_id then
    vim.fn.jobstop(term_job_id)
    term_job_id = nil
  end

  local current_win = vim.api.nvim_get_current_win()
  -- go to M.diff_win
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'
  if filepath then
    term_job_id = vim.fn.termopen('git diff ' .. commit_hash .. '^ ' .. commit_hash .. ' -- ' .. filepath)
  else
    term_job_id = vim.fn.termopen('git diff ' .. commit_hash .. '^ ' .. commit_hash)
  end
  M.GitDiff_BufferMaps()
  if prev_term_buf then
    -- delete prev_term_buf
    vim.api.nvim_buf_delete(prev_term_buf, { force = true })
  end
  prev_term_buf = vim.fn.bufnr('%')
  vim.api.nvim_set_current_win(current_win)
end

function M.UpdateDiffView_Untracked(filepath)
  -- Kill previous terminal job if it exists
  if term_job_id then
    vim.fn.jobstop(term_job_id)
    term_job_id = nil
  end

  local current_win = vim.api.nvim_get_current_win()
  -- go to M.diff_win
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  vim.bo.bufhidden = "hide"
  -- set a custom filetype of 'gitdiff'
  vim.bo.filetype = 'gitdiff'
  if filepath then
    term_job_id = vim.fn.termopen('git diff -- ' .. filepath)
  else
    term_job_id = vim.fn.termopen('git diff')
  end
  M.GitDiff_BufferMaps()
  if prev_term_buf then
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
    table.insert(files, "    " .. file)
  end

  return files
end
-- require'git_commits_viewer'.GetFilesInCommit('424ee27')

local function update_view_from_lines()
  local line = vim.api.nvim_get_current_line()
  
  -- Handle untracked changes header line
  if line:match("^untracked changes") then
    M.UpdateDiffView_Untracked()
    return
  end
  
  -- Handle indented file lines
  if line:match("^%s") then
    local filepath = line:match("^%s+(.+)")
    -- Find commit hash or untracked by searching backwards for the next unindented line
    local prev_word = M.get_prev_line_first_word()
    
    if prev_word == "untracked" then
      -- For untracked changes, run git diff without commit hash
      M.UpdateDiffView_Untracked(filepath)
    elseif prev_word then 
      -- For regular commits
      M.UpdateDiffView(prev_word, filepath)
    end
    return
  end
  
  -- Handle commit hash lines
  local commit_hash = line:match("^(%w+)")
  if commit_hash then
    M.UpdateDiffView(commit_hash)
  end
end


function M.Show(num_of_commits)
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
  vim.api.nvim_win_set_option(commits_win, 'wrap', false)
  -- Use GetCommitLines() to insert commit history into the lower buffer
  local commit_lines = M.GetCommitLines(num_of_commits)
  vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, commit_lines)

  -- Set a custom filetype
  vim.api.nvim_buf_set_option(commits_buf, 'filetype', 'markdown')

  -- Set buffer options
  vim.api.nvim_buf_set_option(commits_buf, 'modifiable', true)
  vim.api.nvim_buf_set_option(commits_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(commits_buf, 'bufhidden', 'wipe')

  -- Set up mapping for 'p' to show diff for commit hash
  vim.keymap.set('n', 'P', function()
    update_view_from_lines()
  end, { buffer = commits_buf, noremap = true })

  vim.keymap.set('n', 'p', function()
    update_view_from_lines()
    -- set cursor to diff window
    vim.api.nvim_set_current_win(M.diff_win)
  end, { buffer = commits_buf, noremap = true })

  M.set_highlights( commits_buf )

  -- Add autocmd to close both windows when either is closed
  local augroup = vim.api.nvim_create_augroup('GitCommitViewerGroup', { clear = true })
  vim.api.nvim_create_autocmd('WinClosed', {
    group = augroup,
    pattern = tostring(diff_win) .. ',' .. tostring(commits_win),
    callback = function()
      if vim.api.nvim_win_is_valid(diff_win) then
        vim.api.nvim_win_close(diff_win, true)
      end
      if vim.api.nvim_win_is_valid(commits_win) then
        vim.api.nvim_win_close(commits_win, true)
      end

      -- Clean up terminal job if it exists
      if term_job_id then
        vim.fn.jobstop(term_job_id)
        term_job_id = nil
      end
    end,
    once = true
  })
end
-- require'git_commits_viewer'.Show()

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
    -- Extract the file path from git status output
    local file = line:match("^.. (.+)$")
    if file then
      table.insert(files, "    " .. file)
    end
  end

  return files
end

function M.GetCommitLines(num_of_commits)
  local lines = {}
  
  -- Add untracked changes as a special first entry
  local untracked_files = M.GetUntrackedChanges()
  if #untracked_files > 0 then
    table.insert(lines, "untracked changes")
    for _, file in ipairs(untracked_files) do
      table.insert(lines, file)
    end
  end
  
  local handle = io.popen("git log --pretty=format:'%h|%cr|%s' -n " .. num_of_commits)
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

function M.set_highlights(bufnr)
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

-- function M.set_highlights_bak(bufnr) ■
--     local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--     for i = 0, #lines - 1 do
--         vim.api.nvim_buf_add_highlight(bufnr, -1, "HponLine", i, 0, -1)
--         local path = vim.split(lines[i + 1], "‖")[1]
--         local folder = vim.fn.fnamemodify(path, ":h:t")
--         local file = vim.fn.fnamemodify(path, ":t:r")
--         vim.fn.matchadd('HponFolder', folder .. "\\ze\\/", 11, -1)
--         vim.fn.matchadd('HponFile', file .. "\\ze\\.", 11, -1)
--     end
--     local curr_filepath = vim.g["curr_main_buffer"]
--     local curr_filename = vim.fn.fnamemodify(curr_filepath, ":t:r")
--     local curr_folder   = vim.fn.fnamemodify(curr_filepath, ":h:t")
--     vim.fn.matchadd('HponFolderSel', curr_folder .. "\\ze\\/", 11, -1)
--     vim.fn.matchadd('HponFileSel', curr_filename .. "\\ze\\.", 11, -1)
--     vim.cmd([[
--       syntax match Normal '/' conceal cchar= 
--     ]])
-- end ▲


return M




