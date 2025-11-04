
local M = {}

-- @param agent_key string: Command to run (currently only 'claude', 'codex', 'gemini' are supported)
-- @param prompt string: The agent prompt to commit
function M.run_agent_worktree(agent_key, prompt)

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

  vim.defer_fn(function()
    vim.fn.chansend(jobid, prompt)
    local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    vim.defer_fn(function() vim.fn.chansend(jobid, enter) end, 200)
  end, 5000)


end

-- require('agents-worktrees').run_agent_worktree("claude", "respond with 'hi'.")
-- require('agents-worktrees').run_agent_worktree("codex", "respond with 'hi'.")

function M.run_agents_worktrees(prompt)
  require('agents-worktrees').run_agent_worktree("claude", prompt)
  require('agents-worktrees').run_agent_worktree("codex", prompt)
end



return M

