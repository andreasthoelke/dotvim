
local M = {}

-- Maps
-- ~/.config/nvim/plugin/config/maps.lua‖/'<leader>gL',ˍfunction()

-- Store terminal buffer ID for cleanup
local term_job_id = nil

function M.UpdateDiffView(commit_hash)
  -- Kill previous terminal job if it exists
  if term_job_id then
    vim.fn.jobstop(term_job_id)
    term_job_id = nil
  end

  local current_win = vim.api.nvim_get_current_win()
  -- go to M.diff_win
  vim.api.nvim_set_current_win(M.diff_win)
  vim.cmd("enew")
  term_job_id = vim.fn.termopen('git diff ' .. commit_hash .. '^ ' .. commit_hash)
  -- return to current_win
  vim.api.nvim_set_current_win(current_win)
end

function M.Show()
  -- Create temporary window for diff view
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
  
  -- Use GetCommitLines() to insert commit history into the lower buffer
  local commit_lines = M.GetCommitLines()
  vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, commit_lines)
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(commits_buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(commits_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(commits_buf, 'bufhidden', 'wipe')
  
  -- Set up mapping for 'p' to show diff for commit hash
  vim.api.nvim_buf_set_keymap(commits_buf, 'n', 'p', '', {
    noremap = true,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local commit_hash = line:match("^(%w+)")
      if commit_hash then
        M.UpdateDiffView(commit_hash)
      end
    end
  })
  
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
-- commithash | time ago | files affected | commit message
-- line example:
-- 24ad3c1f | 4 days ago | 3 files | changed something 
function M.GetCommitLines()
  local lines = {}
  local handle = io.popen("git log --pretty=format:'%h|%cr|%s' -n 10")
  if not handle then return lines end

  local result = handle:read("*a")
  handle:close()
  
  for line in result:gmatch("[^\n]+") do
    local hash, time_ago, message = line:match("([^|]+)|([^|]+)|(.+)")
    if hash and time_ago and message then
      -- Get number of files affected by this commit
      local files_handle = io.popen("git show --pretty='' --name-only " .. hash .. " | wc -l")
      local files_count = "0 f"
      if files_handle then
        files_count = files_handle:read("*n") .. " f"
        files_handle:close()
      end
      
      -- Abbreviate time
      time_ago = time_ago:gsub("minutes?", "m"):gsub("hours?", "h"):gsub("days?", "d"):gsub("weeks?", "w"):gsub("months?", "mo"):gsub("years?", "y"):gsub("ago", "")
      time_ago = time_ago:gsub("seconds?", "s"):gsub("hours?", "h"):gsub("days?", "d"):gsub("weeks?", "w"):gsub("months?", "mo"):gsub("years?", "y"):gsub("ago", "")
      time_ago = time_ago:gsub("%s+$", "") -- Trim trailing spaces
      
      -- Format the line
      table.insert(lines, string.format("%s | %s | %s | %s", hash, time_ago, files_count, message))
    end
  end
  
  return lines
end
-- require'git_commits_viewer'.GetCommitLines()


return M




