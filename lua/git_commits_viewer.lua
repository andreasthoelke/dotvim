
local M = {}

function M.Show()
  -- First check if buffers already exist and delete them
  local function buffer_exists(name)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_name(buf):match(name) then
        return buf
      end
    end
    return nil
  end
  
  -- Generate unique buffer names based on cwd and timestamp
  local timestamp = os.time()
  local details_buf_name = string.format('GitCommitDetails_%d', timestamp)
  local commits_buf_name = string.format('GitCommits_%d', timestamp)
  
  -- Show a disposable / temp buffer in a vertical split
  vim.cmd('vsplit')
  local main_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, main_buf)
  vim.api.nvim_buf_set_name(main_buf, details_buf_name)
  
  -- Show another disposable / temp buffer in a normal split below that buffer. Height 10 lines.
  vim.cmd('split')
  vim.cmd('resize 10')
  local commits_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, commits_buf)
  vim.api.nvim_buf_set_name(commits_buf, commits_buf_name)
  
  -- Use GetCommitLines() to insert max 20 lines into the lower buffer
  local commit_lines = M.GetCommitLines()
  vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, commit_lines)
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(commits_buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(commits_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(commits_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(main_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(main_buf, 'bufhidden', 'wipe')
end
-- require'git_commits_viewer'.Show()

-- Return one line per commit in the cwd. limit this to 20 lines.
-- line format:
-- commithash | time ago | files affected | commit message
-- line example:
-- 24ad3c1f | changed something | 3 files | 4 days ago
-- ..
function M.GetCommitLines()

end
-- require'git_commits_viewer'.GetCommitLines()


return M




