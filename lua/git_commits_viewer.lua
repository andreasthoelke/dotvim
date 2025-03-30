
local M = {}

function M.Show()
  -- Show a disposable / temp buffer in a vertical split
  vim.cmd('vsplit')
  local main_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, main_buf)
  vim.api.nvim_buf_set_name(main_buf, 'GitCommitDetails')
  
  -- Show another disposable / temp buffer in a normal split below that buffer. Height 10 lines.
  vim.cmd('split')
  vim.cmd('resize 10')
  local commits_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, commits_buf)
  vim.api.nvim_buf_set_name(commits_buf, 'GitCommits')
  
  -- Use GetCommitLines() to insert max 20 lines into the lower buffer
  local commit_lines = M.GetCommitLines()
  vim.api.nvim_buf_set_lines(commits_buf, 0, -1, false, commit_lines)
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(commits_buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(commits_buf, 'buftype', 'nofile')
end
-- require'git_commits_viewer'.Show()

-- Using formatted output from git cli of the cwd this method should return e.g.:
--  M  9 files | 267  210 | 56e06e4b (HEAD -> main, origin/main) vim 0.11.0 ai-maps Andreas Thoelke, 2 days ago
--  M  6 files | 631    6 | a6bd0e09 avante Andreas Thoelke, 3 days ago
--  M  4 files | 66    12 | 24ad3c1f feat: Add LSP document and workspace symbol mappings Andreas Thoelke, 4 days ago
-- ..
function M.GetCommitLines()
  local cmd = "git log --pretty=format:'%h (%D) %s %an, %cr' --numstat -n 20"
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  
  local lines = {}
  local current_commit = {}
  local stats = { files = 0, added = 0, removed = 0 }
  
  for line in result:gmatch("[^\r\n]+") do
    if line:match("^%x+%s") then
      -- This is a commit line, start a new commit entry
      if current_commit.line then
        -- Add formatted previous commit to lines
        table.insert(lines, string.format("M %2d files | %3d %3d | %s", 
          stats.files, stats.added, stats.removed, current_commit.line))
        -- Reset stats for new commit
        stats = { files = 0, added = 0, removed = 0 }
      end
      current_commit = { line = line }
    elseif line:match("^%d+%s+%d+%s+%S+") then
      -- This is a numstat line with additions/deletions
      local added, removed = line:match("^(%d+)%s+(%d+)")
      stats.files = stats.files + 1
      stats.added = stats.added + tonumber(added)
      stats.removed = stats.removed + tonumber(removed)
    end
  end
  
  -- Add the last commit if exists
  if current_commit.line then
    table.insert(lines, string.format("M %2d files | %3d %3d | %s", 
      stats.files, stats.added, stats.removed, current_commit.line))
  end
  
  return lines
end
-- require'git_commits_viewer'.GetCommitLines()


return M




