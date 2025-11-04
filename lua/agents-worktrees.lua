
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

  -- Save current working directory to compute absolute path
  local current_cwd = vim.fn.getcwd()
  local parent_dir = vim.fn.fnamemodify(current_cwd, ':h')
  local worktree_path = parent_dir .. '/' .. agent_key

  -- Create new tab with empty buffer
  vim.fn.NewBuf_self("tab")

  -- Set tab-local directory to the worktree (absolute path)
  vim.cmd("tcd " .. vim.fn.fnameescape(worktree_path))

  -- Open agent in vsplit
  local _, jobid = require('agents').open_agent(start_agent_cmd, 'vsplit')

  -- Move focus back to the left window (non-terminal)
  -- vim.cmd("wincmd p")

  -- Send prompt after agent has initialized
  vim.defer_fn(function()
    vim.fn.chansend(jobid, prompt)
    local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    vim.defer_fn(function() vim.fn.chansend(jobid, enter) end, 200)
  end, 5000)

end

-- require('agents-worktrees').run_agent_worktree("claude", "respond with 'hi'.")
-- require('agents-worktrees').run_agent_worktree("codex", "respond with 'hi'.")

function M.run_agents_worktrees(prompt)
  -- Save the original tab to return to it between agent creations
  local original_tab = vim.api.nvim_get_current_tabpage()

  require('agents-worktrees').run_agent_worktree("claude", prompt)

  vim.defer_fn(function()
    -- Switch back to original tab before creating next agent
    pcall(vim.api.nvim_set_current_tabpage, original_tab)

    require('agents-worktrees').run_agent_worktree("codex", prompt)

    -- Return to original tab after setting up all agents
    vim.defer_fn(function()
      pcall(vim.api.nvim_set_current_tabpage, original_tab)
    end, 500)
  end, 1000)
end



return M

