
local M = {}

-- ─   Configuration                                     ──

-- Enabled agents for multi-agent execution
-- Modify this table to enable/disable specific agents
-- Example: M.enabled_agents = {"claude", "codex"}  -- disable gemini
M.enabled_agents = {"claude", "codex", "gemini"}

-- ─^  Configuration                                     ▲


-- ─   Usage Examples                                   ──

-- Setup worktree only (without running agent):
-- require('agents-worktrees').setup_worktree("claude")

-- Run single agent:
-- require('agents-worktrees').run_agent_worktree("claude", "respond with 'hi'.")
-- require('agents-worktrees').run_agent_worktree("codex", "respond with 'hi'.")

-- Run multiple agents in parallel:
-- require('agents-worktrees').run_agents_worktrees("respond with 'hi'.")

-- Disable specific agents at runtime:
-- require('agents-worktrees').enabled_agents = {"claude", "codex"}  -- only claude + codex
-- require('agents-worktrees').enabled_agents = {"gemini"}           -- only gemini

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

  -- Strip agent suffix if we're already in a worktree
  -- (e.g., co-vis_claude -> co-vis)
  project_name = project_name:gsub('_claude$', ''):gsub('_codex$', ''):gsub('_gemini$', '')

  local root_path = parent_dir .. '/' .. project_name

  return {
    name = project_name .. '_' .. agent_key,
    path = parent_dir .. '/' .. project_name .. '_' .. agent_key,
    branch = 'agent/' .. agent_key,
    agent = agent_key,
    root_path = root_path,
  }
end

local function get_root_main_commit(worktree)
  if not worktree.root_path or vim.fn.isdirectory(worktree.root_path) == 0 then
    return nil
  end

  local root = vim.fn.shellescape(worktree.root_path)
  local cmd = string.format("git -C %s rev-parse main", root)
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return nil
  end

  return vim.trim(result)
end

local function run_rebase_via_worktrees_script(worktree)
  local script_path = worktree.root_path .. "/process/scripts/agents/worktrees.sh"
  if vim.fn.filereadable(script_path) == 0 then
    return nil
  end

  local function run_once()
    local cmd = string.format(
      "cd %s && %s rebase %s",
      vim.fn.shellescape(worktree.root_path),
      vim.fn.shellescape(script_path),
      vim.fn.shellescape(worktree.path)
    )
    local result = vim.fn.system(cmd)
    local output = vim.trim(result)
    local needs_retry = output:find("Rebase failed for", 1, true) ~= nil
    return vim.v.shell_error == 0, needs_retry, output
  end

  local success, needs_retry, output = run_once()
  local combined_output = output

  if needs_retry then
    local success_retry, _, retry_output = run_once()
    combined_output =
      (#combined_output > 0 and (combined_output .. "\n") or "") .. vim.trim(retry_output)
    success = success_retry
  end

  return {
    success = success,
    message = combined_output
  }
end

local function align_worktree_to_commit(worktree, commit, opts)
  if not commit or commit == '' then
    return false
  end

  local shell_path = vim.fn.shellescape(worktree.path)
  local head_result = vim.fn.system(string.format("git -C %s rev-parse HEAD", shell_path))

  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("Error: Failed to read HEAD for %s:\n%s", worktree.name, head_result),
      vim.log.levels.ERROR
    )
    return false
  end

  local head_commit = vim.trim(head_result)
  if head_commit == commit then
    return true
  end

  if opts and opts.backup then
    local tag_name =
      string.format("%s-backup-%s", worktree.branch:gsub('/', '-'), os.date("%Y%m%d-%H%M%S"))
    local tag_cmd = string.format("git -C %s tag %s %s", shell_path, tag_name, head_commit)
    local tag_result = vim.fn.system(tag_cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify(
        string.format(
          "Warning: Failed to create backup tag %s for %s:\n%s",
          tag_name,
          worktree.name,
          tag_result
        ),
        vim.log.levels.WARN
      )
    else
      vim.notify(
        string.format("Created backup tag %s for %s", tag_name, worktree.name),
        vim.log.levels.INFO
      )
    end
  end

  local reset_cmd = string.format("git -C %s reset --hard %s", shell_path, commit)
  local reset_result = vim.fn.system(reset_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("Error: Failed to align %s to %s:\n%s", worktree.name, commit, reset_result),
      vim.log.levels.ERROR
    )
    return false
  end

  return true
end

-- Prune stale worktree entries (directories that no longer exist)
-- @return boolean: true if prune was successful
local function prune_stale_worktrees()
  local result = vim.fn.system("git worktree prune")
  if vim.v.shell_error ~= 0 then
    vim.notify(
      string.format("Warning: Failed to prune stale worktrees:\n%s", result),
      vim.log.levels.WARN
    )
    return false
  end
  return true
end

-- Create worktree if it doesn't exist
-- @param worktree table: Output from compute_worktree_paths
-- @return boolean: true if successful or already exists, false on error
local function ensure_worktree_exists(worktree)
  if vim.fn.isdirectory(worktree.path) ~= 0 then
    return true  -- Already exists
  end

  -- Prune stale worktree entries before creating new ones
  -- This handles cases where worktree directories were deleted but still registered
  prune_stale_worktrees()

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
  local script_result = run_rebase_via_worktrees_script(worktree)
  if script_result then
    local level = script_result.success and vim.log.levels.INFO or vim.log.levels.WARN
    local message = script_result.message ~= "" and script_result.message
      or "worktrees.sh rebase completed"
    vim.notify(message, level)

    if script_result.success then
      local main_commit = get_root_main_commit(worktree)
      if main_commit then
        align_worktree_to_commit(worktree, main_commit, { backup = true })
      end
      return
    end
    -- Fall through to legacy flow if the helper script reported a failure despite running.
  end

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

    local main_commit = get_root_main_commit(worktree)
    if main_commit then
      if align_worktree_to_commit(worktree, main_commit, { backup = true }) then
        vim.notify(
          string.format(
            "Aligned %s with local main (%s)",
            worktree.name,
            main_commit:sub(1, 7)
          ),
          vim.log.levels.INFO
        )
      end
    else
      vim.notify(
        string.format("Warning: Could not determine local main commit for %s", worktree.name),
        vim.log.levels.WARN
      )
    end
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

  local main_commit = get_root_main_commit(worktree)
  if not main_commit then
    vim.notify(
      string.format("Error: Could not determine local main commit for %s", worktree.name),
      vim.log.levels.ERROR
    )
    return false
  end

  if align_worktree_to_commit(worktree, main_commit, { backup = true }) then
    vim.notify(
      string.format("Reset %s to main (%s)", worktree.name, main_commit:sub(1, 7)),
      vim.log.levels.INFO
    )
    return true
  end

  return false
end

-- Reset all agent worktrees to main (with backup)
function M.reset_all_worktrees_to_main()
  -- Prune stale worktree entries first
  prune_stale_worktrees()

  local agents = {"claude", "codex", "gemini"}
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

-- Check if an agent is enabled in configuration
-- @param agent_key string: Agent identifier
-- @return boolean: true if agent is in enabled_agents list
local function is_agent_enabled(agent_key)
  for _, enabled in ipairs(M.enabled_agents) do
    if enabled == agent_key then
      return true
    end
  end
  return false
end

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
    gemini = "gemini --yolo ",
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
-- @param skip_rebase boolean: If true, skip rebasing (resume existing work)
function M.run_agents_worktrees(prompt, skip_rebase)
  -- Check enabled and running status for each agent
  local claude_enabled = is_agent_enabled("claude")
  local codex_enabled = is_agent_enabled("codex")
  local gemini_enabled = is_agent_enabled("gemini")

  local claude_running = claude_enabled and is_agent_running("claude")
  local codex_running = codex_enabled and is_agent_running("codex")
  local gemini_running = gemini_enabled and is_agent_running("gemini")

  -- Check if all enabled agents are already running
  local all_enabled_running = true
  if claude_enabled and not claude_running then all_enabled_running = false end
  if codex_enabled and not codex_running then all_enabled_running = false end
  if gemini_enabled and not gemini_running then all_enabled_running = false end

  if all_enabled_running then
    vim.notify("Sending prompt to existing agents", vim.log.levels.INFO)
    if claude_enabled then send_to_existing_agent("claude", prompt) end
    if codex_enabled then send_to_existing_agent("codex", prompt) end
    if gemini_enabled then send_to_existing_agent("gemini", prompt) end
    return
  end

  -- Send to existing enabled agents
  if claude_running then
    vim.notify("Sending to existing Claude agent", vim.log.levels.INFO)
    send_to_existing_agent("claude", prompt)
  end

  if codex_running then
    vim.notify("Sending to existing Codex agent", vim.log.levels.INFO)
    send_to_existing_agent("codex", prompt)
  end

  if gemini_running then
    vim.notify("Sending to existing Gemini agent", vim.log.levels.INFO)
    send_to_existing_agent("gemini", prompt)
  end

  -- Save the original tab to return to it between agent creations
  local original_tab = vim.api.nvim_get_current_tabpage()

  -- Create enabled agents that aren't running
  local created_claude = false
  if claude_enabled and not claude_running then
    require('agents-worktrees').run_agent_worktree("claude", prompt, skip_rebase)
    created_claude = true
  end

  -- Create Codex after a delay (if enabled)
  if codex_enabled and not codex_running then
    vim.defer_fn(function()
      -- If we didn't just create Claude, create Codex next to the original tab
      -- Otherwise, stay on the Claude tab so Codex is created to its right
      if not created_claude then
        pcall(vim.api.nvim_set_current_tabpage, original_tab)
      end

      require('agents-worktrees').run_agent_worktree("codex", prompt, skip_rebase)
    end, 1000)
  end

  -- Create Gemini after another delay (if enabled)
  if gemini_enabled and not gemini_running then
    vim.defer_fn(function()
      -- Return to original tab before creating Gemini
      -- This ensures consistent tab ordering
      if not created_claude and not (codex_enabled and not codex_running) then
        pcall(vim.api.nvim_set_current_tabpage, original_tab)
      end

      require('agents-worktrees').run_agent_worktree("gemini", prompt, skip_rebase)

      -- Return to original tab after setting up all agents
      vim.defer_fn(function()
        pcall(vim.api.nvim_set_current_tabpage, original_tab)
      end, 500)
    end, 2000)
  elseif not (codex_enabled and not codex_running) and not (claude_enabled and not claude_running) then
    -- If no agents were created, no need to return
    return
  elseif (codex_enabled and not codex_running) or (claude_enabled and not claude_running) then
    -- Return to original tab after creating one or two agents
    vim.defer_fn(function()
      pcall(vim.api.nvim_set_current_tabpage, original_tab)
    end, 1500)
  end
end


return M
