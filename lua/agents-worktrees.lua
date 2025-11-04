
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


  local _, jobid = require('agents').open_agent( start_agent_cmd, 'vsplit')
  vim.cmd("wincmd p")

  vim.defer_fn(function()
    vim.fn.chansend(jobid, "respond with 'hi'")
    vim.defer_fn(function() vim.fn.chansend(jobid, "\r") end, 100)
  end, 5000)

  vim.defer_fn(function()
    vim.fn.chansend(jobid, "/exit")
    vim.defer_fn(function() vim.fn.chansend(jobid, "\r") end, 100)
    vim.defer_fn(function() vim.fn.chansend(jobid, "\r") end, 2000)
  end, 15000)

end

-- require('agents-worktrees').open_default_agent_worktree("claude")
-- require('agents-worktrees').open_default_agent_worktree("codex")

return M

