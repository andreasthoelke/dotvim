
local M = {}

-- ─   Worktree Setup                                    ──

-- Compute worktree paths for an agent
-- @param agent_key string: Agent identifier ('claude', 'codex', 'gemini')
-- @return table: {name, path, branch} or nil on error
local function compute_worktree_paths(agent_key)
  local current_cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(current_cwd, ':t')
  local parent_dir = vim.fn.fnamemodify(current_cwd, ':h')

  return {
    name = project_name .. '_' .. agent_key,
    path = parent_dir .. '/' .. project_name .. '_' .. agent_key,
    branch = 'agent/' .. agent_key,
  }
end

-- Create worktree if it doesn't exist
-- @param worktree table: Output from compute_worktree_paths
-- @return boolean: true if successful or already exists, false on error
local function ensure_worktree_exists(worktree)
  if vim.fn.isdirectory(worktree.path) ~= 0 then
    return true  -- Already exists
  end

  vim.notify(
    string.format("Creating worktree %s on branch %s...", worktree.name, worktree.branch),
    vim.log.levels.INFO
  )

  -- Check if branch already exists
  local branch_exists_cmd = string.format("git show-ref --verify --quiet refs/heads/%s", worktree.branch)
  vim.fn.system(branch_exists_cmd)

  local worktree_cmd
  if vim.v.shell_error == 0 then
    -- Branch exists, use it
    worktree_cmd = string.format("git worktree add %s %s", vim.fn.shellescape(worktree.path), worktree.branch)
  else
    -- Create new branch from main
    worktree_cmd = string.format("git worktree add %s -b %s main", vim.fn.shellescape(worktree.path), worktree.branch)
  end

  local result = vim.fn.system(worktree_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify(string.format("Failed to create worktree:\n%s", result), vim.log.levels.ERROR)
    return false
  end

  vim.notify(string.format("Created worktree %s", worktree.name), vim.log.levels.INFO)
  return true
end

-- Rebase worktree against main
-- @param worktree table: Output from compute_worktree_paths
local function rebase_worktree(worktree)
  local rebase_cmd = string.format("git -C %s rebase main", vim.fn.shellescape(worktree.path))
  local rebase_result = vim.fn.system(rebase_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("Warning: Failed to rebase %s against main:\n%s", worktree.name, rebase_result),
      vim.log.levels.WARN
    )
    -- Abort the rebase to leave worktree in clean state
    vim.fn.system(string.format("git -C %s rebase --abort", vim.fn.shellescape(worktree.path)))
  end
end

-- Setup worktree for an agent (create if needed, rebase against main)
-- @param agent_key string: Agent identifier ('claude', 'codex', 'gemini')
-- @return table|nil: Worktree info {name, path, branch} or nil on error
function M.setup_worktree(agent_key)
  local worktree = compute_worktree_paths(agent_key)

  if not ensure_worktree_exists(worktree) then
    return nil
  end

  rebase_worktree(worktree)

  return worktree
end

-- ─   Agent Execution                                   ──

-- Get command string for an agent
-- @param agent_key string: Agent identifier
-- @return string|nil: Command to start agent, or nil if unknown
local function get_agent_command(agent_key)
  local commands = {
    claude = "env -u ANTHROPIC_API_KEY claude --dangerously-skip-permissions ",
    codex = "codex --dangerously-bypass-approvals-and-sandbox ",
    gemini = "gemini -m gemini-flash-latest ",
  }
  return commands[agent_key]
end

-- Run an agent in its worktree
-- @param agent_key string: Agent identifier ('claude', 'codex', 'gemini')
-- @param prompt string: The prompt to send to the agent
function M.run_agent_worktree(agent_key, prompt)
  local start_agent_cmd = get_agent_command(agent_key)
  if not start_agent_cmd then
    vim.notify(string.format("Unknown agent: %s", agent_key), vim.log.levels.ERROR)
    return
  end

  -- Setup worktree (create if needed, rebase)
  local worktree = M.setup_worktree(agent_key)
  if not worktree then
    return  -- Error already notified
  end

  -- Create new tab with empty buffer
  vim.fn.NewBuf_self("tab")

  -- Set tab-local directory to the worktree
  vim.cmd("tcd " .. vim.fn.fnameescape(worktree.path))

  -- Open agent in vsplit
  local _, jobid = require('agents').open_agent(start_agent_cmd, 'vsplit')

  -- Move focus back to the left window (non-terminal)
  vim.cmd("wincmd p")

  -- Send prompt after agent has initialized
  vim.defer_fn(function()
    vim.fn.chansend(jobid, prompt)
    local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    vim.defer_fn(function() vim.fn.chansend(jobid, enter) end, 200)
  end, 5000)
end

-- ─   Multi-Agent Execution                            ──

-- Run multiple agents in parallel with the same prompt
-- @param prompt string: The prompt to send to all agents
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

-- ─   Usage Examples                                   ──

-- Setup worktree only (without running agent):
-- require('agents-worktrees').setup_worktree("claude")

-- Run single agent:
-- require('agents-worktrees').run_agent_worktree("claude", "respond with 'hi'.")
-- require('agents-worktrees').run_agent_worktree("codex", "respond with 'hi'.")

-- Run multiple agents in parallel:
-- require('agents-worktrees').run_agents_worktrees("respond with 'hi'.")

return M

