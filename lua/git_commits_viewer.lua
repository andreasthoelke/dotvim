
local M = {}

function M.Show()
  -- Show a disposable / temp buffer in a vertical split
  -- Show another disposable / temp buffer in a normal split below that buffer. Height 10 lines.
  -- Use GetCommitLines() to insert max 20 lines into the lower buffer

end


-- Using formatted output from git cli of the cwd this method should return e.g.:
--  M  9 files | 267  210 | 56e06e4b (HEAD -> main, origin/main) vim 0.11.0 ai-maps Andreas Thoelke, 2 days ago
--  M  6 files | 631    6 | a6bd0e09 avante Andreas Thoelke, 3 days ago
--  M  4 files | 66    12 | 24ad3c1f feat: Add LSP document and workspace symbol mappings Andreas Thoelke, 4 days ago
-- ..
function M.GetCommitLines()
end


return M




