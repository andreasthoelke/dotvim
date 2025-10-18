-- ─   Agent Terminal Management                        ──
--
-- This module manages terminal buffers for CLI coding agents (Claude Code, Codex, Gemini, etc.)
--
-- Design:
-- - Each tab can have one active agent terminal
-- - Agent terminals are marked with vim.b.is_agent_terminal = true
-- - Always creates NEW terminal (no resume logic)
-- - Finds terminals dynamically by searching current tab
--
-- Usage:
--   require('agents').open_agent('claude ', 'vsplit')
--   require('agents').send_to_agent('Some text')

local M = {}

-- ─   Terminal Opening                                  ──

-- Opens a new agent terminal buffer
-- @param command string: Command to run (e.g., 'claude ', 'codex ', 'gemini ')
-- @param window_type string: Window split type ('vsplit', 'hsplit', 'tabnew')
-- @return number, number: buffer number and job ID
function M.open_agent(command, window_type)
  window_type = window_type or "vsplit"

  -- Open window based on type
  if window_type == "vsplit" then
    vim.cmd("vsplit")
  elseif window_type == "hsplit" then
    vim.cmd("split")
  elseif window_type == "tabnew" then
    vim.cmd("tabnew")
  else
    vim.cmd("vsplit")  -- default to vsplit
  end

  -- Create a new empty buffer and switch to it
  -- This prevents converting the original buffer to a terminal
  local buf = vim.api.nvim_create_buf(false, true)  -- not listed, scratch buffer
  vim.api.nvim_win_set_buf(0, buf)

  -- Open terminal with command
  local job_id = vim.fn.termopen(command, {
    on_exit = function(job_id, exit_code, event_type)
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          local message = exit_code == 0
            and "Agent process completed successfully."
            or "Agent process exited with code: " .. exit_code
          vim.notify(message, vim.log.levels.INFO)
        end
      end)
    end
  })

  -- Mark this buffer as an agent terminal
  vim.b[buf].is_agent_terminal = true

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

  return buf, job_id
end

-- ─   Terminal Finding                                  ──

-- Finds the agent terminal in the current tab
-- @return number|nil: job ID of the agent terminal, or nil if not found
function M.find_agent_terminal_in_tab()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(current_tab)

  for _, win in ipairs(windows) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)

      -- Check if this is a terminal buffer marked as an agent terminal
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      local is_agent = vim.b[buf].is_agent_terminal

      if buftype == "terminal" and is_agent then
        -- Get the job ID from the terminal buffer
        local job_id = vim.b[buf].terminal_job_id
        if job_id then
          return job_id
        end
      end
    end
  end

  return nil
end

-- ─   Text Sending                                      ──

-- Sends text to the agent terminal in the current tab
-- @param text string: Text to send to the agent
-- @return boolean: true if successful, false otherwise
function M.send_to_agent(text)
  local job_id = M.find_agent_terminal_in_tab()

  if not job_id then
    vim.api.nvim_echo({
      { "Error: No agent terminal found in current tab. Open one first with <c-g>V", "ErrorMsg" }
    }, true, {})
    return false
  end

  -- Check if using gemini CLI (needs special escape code wrapping)
  local using_gemini = vim.g.agent_cmd and vim.g.agent_cmd:match('gemini')

  if using_gemini then
    -- Wrap text with bracketed paste escape codes for gemini
    text = "\x1b[200~" .. text .. "\x1b[201~"
  end

  -- Send text to terminal
  vim.fn.chansend(job_id, text)
  return true
end

-- ─   Utility Functions                                 ──

-- Check if an agent terminal exists in current tab
-- @return boolean: true if an agent terminal exists
function M.has_agent_terminal()
  return M.find_agent_terminal_in_tab() ~= nil
end

-- Get list of all agent terminals (for debugging)
-- @return table: List of {bufnr, job_id, winid} for each agent terminal in current tab
function M.list_agent_terminals()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(current_tab)
  local terminals = {}

  for _, win in ipairs(windows) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      local is_agent = vim.b[buf].is_agent_terminal

      if buftype == "terminal" and is_agent then
        local job_id = vim.b[buf].terminal_job_id
        table.insert(terminals, {
          bufnr = buf,
          job_id = job_id,
          winid = win
        })
      end
    end
  end

  return terminals
end

return M
