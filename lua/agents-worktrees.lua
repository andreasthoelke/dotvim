
local M = {}

-- @param agent_key string: Command to run (currently only 'claude', 'codex', 'gemini' are supported)
function M.open_default_agent_worktree(agent_key)

  local start_agent_cmd = nil
  if agent_key == 'claude' then
    start_agent_cmd = "env -u ANTHROPIC_API_KEY claude --dangerously-skip-permissions "
  elseif agent_key == 'codex' then
    start_agent_cmd = "codex --dangerously-bypass-approvals-and-sandbox "
  elseif agent_key == 'gemini' then
    start_agent_cmd = "gemini -m gemini-flash-latest "
  end

  vim.fn.NewBuf_self("tab")

  local tcd_cmd = "../" .. agent_key
  vim.cmd("tcd " .. tcd_cmd)


  local bufnr, jobid = require('agents').open_agent( start_agent_cmd, 'vsplit')
  vim.cmd("wincmd p")

  -- vim.defer_fn(function()
  --   vim.fn.chansend(jobid, "respond with 'hi'")
  --   vim.defer_fn(function() vim.fn.chansend(jobid, "\r") end, 100)
  -- end, 5000)

  -- this shuts down claude code and then closes the buffer
  -- vim.defer_fn(function()
  --   vim.fn.chansend(jobid, "/exit")
  --   vim.defer_fn(function()
  --     local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
  --     vim.fn.chansend(jobid, enter)
  --   end, 100)

  --   -- Wait longer for graceful shutdown, then check if it's still alive
  --   vim.defer_fn(function()
  --     -- Only force kill if the job is still running after 5 seconds
  --     if vim.fn.jobwait({jobid}, 0)[1] == -1 then
  --       -- Job still running, something went wrong
  --       vim.fn.jobstop(jobid)
  --     end
  --   end, 5000)
  -- end, 5000)

end

-- require('agents-worktrees').open_default_agent_worktree("claude")
-- require('agents-worktrees').open_default_agent_worktree("codex")

return M

