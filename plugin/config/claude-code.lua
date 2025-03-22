
-- Define the ClaudeCodeMcpAdd command
vim.api.nvim_create_user_command('ClaudeCodeMcpAdd', function(opts)
  local name = opts.args
  if name == "" then
    print("Error: Please provide a name for the MCP server")
    return
  end
  
  -- Execute the add command
  local add_cmd = string.format('claude mcp add-json %s -s user "$(jq -c \'.\' ~/.config/mcp/%s.json)"', name, name)
  vim.fn.system(add_cmd)
  
  -- Show confirmation by listing all MCPs
  print("MCP Servers:")
  local list_output = vim.fn.system('claude mcp list')
  print(list_output)
  
  -- Show details of the added MCP
  print("Added MCP details:")
  local get_output = vim.fn.system(string.format('claude mcp get %s', name))
  print(get_output)
end, {
  nargs = 1,
  desc = "Add Claude MCP server configuration"
})

-- Define the ClaudeCodeMcpRemove command
vim.api.nvim_create_user_command('ClaudeCodeMcpRemove', function(opts)
  local name = opts.args
  if name == "" then
    print("Error: Please provide a name for the MCP server to remove")
    return
  end
  
  -- Execute the remove command
  local remove_cmd = string.format('claude mcp remove "%s" -s user', name)
  vim.fn.system(remove_cmd)
  
  -- Show confirmation by listing remaining MCPs
  print("Remaining MCP Servers:")
  local list_output = vim.fn.system('claude mcp list')
  print(list_output)
end, {
  nargs = 1,
  desc = "Remove Claude MCP server configuration"
})



