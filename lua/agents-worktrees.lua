
local M = {}


-- ─   Usage Examples                                   ──

-- Setup worktree only (without running agent):
-- require('agents-worktrees').setup_worktree("claude")

-- Run single agent:
-- require('agents-worktrees').run_agent_worktree("claude", "respond with 'hi'.")
-- require('agents-worktrees').run_agent_worktree("codex", "respond with 'hi'.")

-- Run multiple agents in parallel:
-- require('agents-worktrees').run_agents_worktrees("respond with 'hi'.")

-- Reset single agent worktree to main (with backup):
-- require('agents-worktrees').reset_worktree_to_main("claude")

-- Reset all agent worktrees to main (with backup):
-- require('agents-worktrees').reset_all_worktrees_to_main()



-- ─   Worktree Setup                                    ■

-- Global storage for worktree agents
-- Structure: { [agent_key] = { tabnr = N, job_id = N, bufnr = N } }
M.worktree_agents = {}

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

-- Rebase worktree against main (auto-commits WIP if needed)
-- @param worktree table: Output from compute_worktree_paths
local function rebase_worktree(worktree)
  local path = vim.fn.shellescape(worktree.path)

  -- Check if worktree has uncommitted changes
  local status_cmd = string.format("git -C %s status --porcelain", path)
  local status = vim.fn.system(status_cmd)

  if status ~= "" then
    -- Auto-commit WIP changes before rebasing
    vim.notify(
      string.format("Auto-committing WIP changes in %s before rebase", worktree.name),
      vim.log.levels.INFO
    )

    local commit_cmd = string.format(
      "git -C %s add -A && git -C %s commit -m 'WIP: auto-commit before rebase'",
      path, path
    )
    local commit_result = vim.fn.system(commit_cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify(
        string.format("Warning: Failed to commit WIP changes in %s:\n%s", worktree.name, commit_result),
        vim.log.levels.WARN
      )
      return
    end
  end

  -- Now rebase against main
  local rebase_cmd = string.format("git -C %s rebase main", path)
  local rebase_result = vim.fn.system(rebase_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("Warning: Failed to rebase %s against main:\n%s", worktree.name, rebase_result),
      vim.log.levels.WARN
    )
    -- Abort the rebase to leave worktree in clean state
    vim.fn.system(string.format("git -C %s rebase --abort", path))
  else
    vim.notify(
      string.format("Rebased %s against main", worktree.name),
      vim.log.levels.INFO
    )
  end
end

-- Reset worktree to main (backs up current work to a tag first)
-- @param agent_key string: Agent identifier ('claude', 'codex', 'gemini')
-- @return boolean: true if successful
function M.reset_worktree_to_main(agent_key)
  local worktree = compute_worktree_paths(agent_key)

  if vim.fn.isdirectory(worktree.path) == 0 then
    vim.notify(string.format("Worktree %s doesn't exist", worktree.name), vim.log.levels.WARN)
    return false
  end

  local path = vim.fn.shellescape(worktree.path)
  local timestamp = os.date("%Y%m%d-%H%M%S")
  local tag_name = "backup-" .. timestamp

  -- Create backup tag
  local tag_cmd = string.format("git -C %s tag %s", path, tag_name)
  vim.fn.system(tag_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("Warning: Failed to create backup tag in %s", worktree.name),
      vim.log.levels.WARN
    )
  else
    vim.notify(
      string.format("Created backup tag '%s' in %s", tag_name, worktree.name),
      vim.log.levels.INFO
    )
  end

  -- Reset hard to main
  local reset_cmd = string.format("git -C %s reset --hard main", path)
  local reset_result = vim.fn.system(reset_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("Error: Failed to reset %s to main:\n%s", worktree.name, reset_result),
      vim.log.levels.ERROR
    )
    return false
  end

  vim.notify(
    string.format("Reset %s to main", worktree.name),
    vim.log.levels.INFO
  )
  return true
end

-- Reset all agent worktrees to main (with backup)
function M.reset_all_worktrees_to_main()
  local agents = {"claude", "codex"}
  local success_count = 0

  for _, agent_key in ipairs(agents) do
    if M.reset_worktree_to_main(agent_key) then
      success_count = success_count + 1
    end
  end

  vim.notify(
    string.format("Reset %d/%d agent worktrees to main", success_count, #agents),
    vim.log.levels.INFO
  )
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


-- ─^  Worktree Setup                                    ▲


-- ─   Agent Tracking                                    ■

-- Check if an agent is currently running
-- @param agent_key string: Agent identifier
-- @return boolean: true if agent is running and valid
local function is_agent_running(agent_key)
  local agent_info = M.worktree_agents[agent_key]
  if not agent_info then
    return false
  end

  -- Verify tab and buffer still exist
  if not vim.api.nvim_tabpage_is_valid(agent_info.tabnr) then
    M.worktree_agents[agent_key] = nil
    return false
  end

  if not vim.api.nvim_buf_is_valid(agent_info.bufnr) then
    M.worktree_agents[agent_key] = nil
    return false
  end

  -- Verify job is still running
  local job_pid = vim.fn.jobpid(agent_info.job_id)
  if job_pid == -1 then
    M.worktree_agents[agent_key] = nil
    return false
  end

  return true
end

-- Send prompt to existing agent without switching tabs
-- @param agent_key string: Agent identifier
-- @param prompt string: The prompt to send
-- @return boolean: true if successful
local function send_to_existing_agent(agent_key, prompt)
  local agent_info = M.worktree_agents[agent_key]
  if not agent_info then
    return false
  end

  -- Send prompt after a short delay
  vim.defer_fn(function()
    vim.fn.chansend(agent_info.job_id, prompt)
    local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    vim.defer_fn(function()
      vim.fn.chansend(agent_info.job_id, enter)
    end, 200)
  end, 500)

  return true
end


-- ─^  Agent Tracking                                    ▲



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

-- Create session log for agent
-- @param agent_key string: Agent identifier ('claude', 'codex', 'gemini')
-- @param prompt string: The prompt/text being sent
-- @param worktree table: Worktree info {name, path, branch}
function M.create_session_log(agent_key, prompt, worktree)
  local timestamp = os.date("%Y%m%d-%H%M%S")
  local session_file = worktree.path .. "/.agent-work/sessions/"
                       .. agent_key .. "-" .. timestamp .. ".json"

  -- Ensure directory exists
  vim.fn.system(string.format("mkdir -p %s",
    vim.fn.shellescape(worktree.path .. "/.agent-work/sessions")))

  -- Create minimal session log
  local session_data = vim.fn.json_encode({
    agent = agent_key,
    branch = worktree.branch,
    task = prompt,
    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    commits = {}
  })

  local file = io.open(session_file, "w")
  if file then
    file:write(session_data)
    file:close()
    -- vim.notify(
    --   string.format("Created session log for %s", agent_key),
    --   vim.log.levels.INFO
    -- )
  end
end

-- Run an agent in its worktree
-- @param agent_key string: Agent identifier ('claude', 'codex', 'gemini')
-- @param prompt string: The prompt to send to the agent
-- @param skip_rebase boolean: If true, skip rebasing (for existing agents)
function M.run_agent_worktree(agent_key, prompt, skip_rebase)
  local start_agent_cmd = get_agent_command(agent_key)
  if not start_agent_cmd then
    vim.notify(string.format("Unknown agent: %s", agent_key), vim.log.levels.ERROR)
    return
  end

  -- Compute worktree paths
  local worktree = compute_worktree_paths(agent_key)

  -- Ensure worktree exists (but don't rebase yet)
  if not ensure_worktree_exists(worktree) then
    return  -- Error already notified
  end

  -- Only rebase if explicitly requested (for fresh starts)
  if not skip_rebase then
    rebase_worktree(worktree)
  end

  -- Create session log
  M.create_session_log(agent_key, prompt, worktree)

  -- Create new tab with empty buffer
  vim.fn.NewBuf_self("tab")

  -- Set tab-local directory to the worktree
  vim.cmd("tcd " .. vim.fn.fnameescape(worktree.path))

  -- Open agent in vsplit
  local bufnr, jobid = require('agents').open_agent(start_agent_cmd, 'vsplit')

  -- Store agent info for future use
  M.worktree_agents[agent_key] = {
    tabnr = vim.api.nvim_get_current_tabpage(),
    job_id = jobid,
    bufnr = bufnr,
  }

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
  local claude_running = is_agent_running("claude")
  local codex_running = is_agent_running("codex")

  -- If both agents are already running, just send prompts without switching tabs
  if claude_running and codex_running then
    vim.notify("Sending prompt to existing agents", vim.log.levels.INFO)
    send_to_existing_agent("claude", prompt)
    send_to_existing_agent("codex", prompt)
    return
  end

  -- If only some agents are running, send to existing and create new ones
  if claude_running then
    vim.notify("Sending to existing Claude agent", vim.log.levels.INFO)
    send_to_existing_agent("claude", prompt)
  end

  if codex_running then
    vim.notify("Sending to existing Codex agent", vim.log.levels.INFO)
    send_to_existing_agent("codex", prompt)
  end

  -- Save the original tab to return to it between agent creations
  local original_tab = vim.api.nvim_get_current_tabpage()

  -- Create agents that aren't running
  local created_claude = false
  if not claude_running then
    require('agents-worktrees').run_agent_worktree("claude", prompt)
    created_claude = true
  end

  if not codex_running then
    vim.defer_fn(function()
      -- If we didn't just create Claude, create Codex next to the original tab
      -- Otherwise, stay on the Claude tab so Codex is created to its right
      if not created_claude then
        pcall(vim.api.nvim_set_current_tabpage, original_tab)
      end

      require('agents-worktrees').run_agent_worktree("codex", prompt)

      -- Return to original tab after setting up all agents
      vim.defer_fn(function()
        pcall(vim.api.nvim_set_current_tabpage, original_tab)
      end, 500)
    end, 1000)
  elseif not claude_running then
    -- If only claude was created, return to original tab
    vim.defer_fn(function()
      pcall(vim.api.nvim_set_current_tabpage, original_tab)
    end, 500)
  end
end


return M
