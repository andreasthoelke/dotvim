local cmd = vim.api.nvim_create_user_command

-- ClaudeDesktopMcpAdd command - adds or updates a key in the JSON file
cmd("ClaudeDesktopMcpAdd", function(opts)
  -- Get the key from the command arguments
  local key = opts.args
  if key == "" then
    vim.notify("Key name required", vim.log.levels.ERROR)
    return
  end

  -- Hardcoded values
  -- local file_path = "~/.config/claude-desktop/test.json"
  local file_path = "~/.config/claude-desktop/claude_desktop_config.json"
  local host_key = "mcpServers"

  -- Read the value from the corresponding file
  local value_file_path
  if string.sub(key, 1, 1) == "~" then
    local home = os.getenv("HOME")
    value_file_path = home .. string.sub(key, 2)
  else
    local home = os.getenv("HOME")
    value_file_path = home .. "/.config/mcp/" .. key .. ".json"
  end

  local value_file = io.open(value_file_path, "r")
  if not value_file then
    vim.notify("Could not read file: " .. value_file_path, vim.log.levels.ERROR)
    return
  end

  local value = value_file:read("*all")
  value_file:close()

  -- Call the function to update the JSON file
  local status, err = pcall(require'tools_external'.JsonFileUpdateKey, file_path, host_key, key, value)
  if not status then
    vim.notify("Error updating JSON: " .. (err or "unknown error"), vim.log.levels.ERROR)
  else
    -- vim.notify("Added/updated key '" .. key .. "' in " .. file_path, vim.log.levels.INFO)
    local json_content = require'tools_external'.get_json_content(file_path)
    lines = vim.split(json_content, "\n")
    vim.g['floatWin_win'] = vim.fn.FloatingSmallNew( lines )
    vim.fn.FloatWin_FitWidthHeight()
    vim.cmd'wincmd p'
  end
end, {nargs = 1, desc = "Add MCP server to Claude Desktop config"})

-- ClaudeDesktopMcpRemove command - removes a key from the JSON file
cmd("ClaudeDesktopMcpRemove", function(opts)
  -- Get the key from the command arguments
  local key = opts.args
  if key == "" then
    vim.notify("Key name required", vim.log.levels.ERROR)
    return
  end

  -- Hardcoded values
  -- local file_path = "~/.config/claude-desktop/test.json"
  local file_path = "~/.config/claude-desktop/claude_desktop_config.json"
  local host_key = "mcpServers"

  -- Call the function to remove the key from the JSON file
  local status, err = pcall(require'tools_external'.JsonFileRemoveKey, file_path, host_key, key)
  if not status then
    vim.notify("Error removing JSON key: " .. (err or "unknown error"), vim.log.levels.ERROR)
  else
    -- vim.notify("Removed key '" .. key .. "' from " .. file_path, vim.log.levels.INFO)
    local json_content = require'tools_external'.get_json_content(file_path)
    lines = vim.split(json_content, "\n")
    vim.g['floatWin_win'] = vim.fn.FloatingSmallNew( lines )
    vim.fn.FloatWin_FitWidthHeight()
    vim.cmd'wincmd p'

  end
end, {nargs = 1, desc = "Remove MCP server from Claude Desktop config"})


-- ClaudeDesktopMcpAdd filesystem
-- ClaudeDesktopMcpAdd github
-- ClaudeDesktopMcpRemove filesystem
-- ClaudeDesktopMcpRemove github


