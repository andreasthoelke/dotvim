

-- Table to store command-specific keymaps
local terminal_keymaps = {
  ["tail%-f.*%.logs?"] = {
    -- Log navigation
    { 'n', '<leader>e', '/ERROR<CR>', { desc = "Find ERROR" } },
    { 'n', '<leader>w', '/WARN<CR>', { desc = "Find WARN" } },
    { 'n', '<leader>d', '/DEBUG<CR>', { desc = "Find DEBUG" } },
    { 'n', '<c-n>', '/\\d\\{2\\}:\\d\\{2\\}:\\d\\{2\\}<CR>', { desc = "Find timestamp" } },
    { 'n', '<leader>n', 'n', { desc = "Next match" } },
    { 'n', '<leader>N', 'N', { desc = "Previous match" } },
  },
  ["docker logs"] = {
    { 'n', '<leader>c', '/container<CR>', { desc = "Find container mentions" } },
    { 'n', '<leader>s', '/started<CR>', { desc = "Find started events" } },
  },
}

-- Function to get the running command in a terminal buffer
function _G.Get_terminal_command()
  -- Try to get the command from the buffer name
  local bufname = vim.api.nvim_buf_get_name(0)
  
  -- Extract command from the buffer name
  -- Format: term://path//PID:command
  local pid, cmd = bufname:match("//(%d+):(.+)$")
  if cmd then
    return cmd
  end
  
  -- Alternative: try to get from the first line of the buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
  if #lines > 0 then
    return lines[1]
  end
  
  return nil
end

-- Set up the autocommand
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Small delay to ensure the terminal is fully initialized
    vim.defer_fn(function()
      local cmd = Get_terminal_command()
      print("Get_terminal_command: " .. cmd)
      if not cmd then return end
      
      -- Check each pattern in our keymap table
      for pattern, keymaps in pairs(terminal_keymaps) do
        print("for pattern: " .. pattern)
        if cmd:match(pattern) then
          print("matched pattern: " .. pattern)

          -- Apply all keymaps for this pattern
          for _, keymap in ipairs(keymaps) do
            local mode, lhs, rhs, opts = unpack(keymap)
            opts = opts or {}
            opts.buffer = true
            opts.silent = opts.silent ~= false
            vim.keymap.set(mode, lhs, rhs, opts)
          end
          
          -- Set a buffer variable to indicate which keymaps are active
          vim.b.terminal_keymap_pattern = pattern
          
          -- Optional: Show a notification
          vim.notify("Terminal keymaps loaded for: " .. pattern, vim.log.levels.INFO)
          break
        end
      end
    end, 100)
  end
})

