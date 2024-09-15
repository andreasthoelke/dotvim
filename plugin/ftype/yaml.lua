
function ViewYamlAsJson()
  -- Get the current buffer's name (YAML file)
  local yaml_bufname = vim.fn.expand('%:t')
  local json_bufname = yaml_bufname .. '.json'

  -- Get the current buffer's content
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local yaml_content = table.concat(lines, "\n")
  
  -- Use Python to convert YAML to JSON
  local json_content = vim.fn.system(
    "python -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read()), indent=2))'",
    yaml_content
  )
  
  -- Check if the conversion was successful
  if vim.v.shell_error ~= 0 then
    print("Error: Failed to convert YAML to JSON. Make sure the YAML is valid.")
    return
  end

  -- Check if a related JSON buffer already exists
  local existing_bufnr = vim.fn.bufnr(json_bufname)
  local json_winnr = vim.fn.bufwinnr(existing_bufnr)

  if json_winnr ~= -1 then
    -- If the buffer is visible in a window, switch to that window
    vim.cmd(json_winnr .. 'wincmd w')
  else
    -- If the buffer exists but is not visible, or doesn't exist, create a new split
    vim.cmd('vsplit')
  end

  -- Create or switch to the JSON buffer
  local ok, err = pcall(vim.cmd, 'buffer ' .. vim.fn.fnameescape(json_bufname))
  if not ok then
    -- If there was an error, create a new buffer with a unique name
    local unique_bufname = json_bufname .. '_' .. os.time()
    vim.cmd('enew')
    vim.api.nvim_buf_set_name(0, unique_bufname)
    print("Created new buffer: " .. unique_bufname)
  end
  
  -- Clear the buffer content
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  
  -- Set the new content of the buffer to the JSON
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(json_content, "\n"))
  
  -- Set the filetype to JSON for syntax highlighting
  vim.bo.filetype = "json"
  
  -- Set buffer options to make it temporary
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
  
  vim.cmd('wincmd p')
end

function ViewYamlAsJson_2()
  -- Get the current buffer's name (YAML file)
  local yaml_bufname = vim.fn.expand('%:t')
  local json_bufname = yaml_bufname .. '.json'

  -- Check if a related JSON buffer already exists
  local existing_bufnr = vim.fn.bufnr(json_bufname)
  
  if existing_bufnr ~= -1 then
    -- If the buffer exists, close it
    vim.api.nvim_buf_delete(existing_bufnr, { force = true })
  end

  -- Get the current buffer's content
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local yaml_content = table.concat(lines, "\n")
  
  -- Use Python to convert YAML to JSON
  local json_content = vim.fn.system(
    "python -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read()), indent=2))'",
    yaml_content
  )
  
  -- Check if the conversion was successful
  if vim.v.shell_error ~= 0 then
    print("Error: Failed to convert YAML to JSON. Make sure the YAML is valid.")
    return
  end
  
  -- Create a new split window
  vim.cmd('vnew ' .. json_bufname)
  
  -- Set the content of the new buffer to the JSON
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(json_content, "\n"))
  
  -- Set the filetype to JSON for syntax highlighting
  vim.bo[buf].filetype = "json"
  
  -- Set buffer options to make it temporary
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  -- Jump back to previous window
  vim.cmd('wincmd p')
end

function ViewYamlAsJson_simple()
  -- Get the current buffer's content
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local yaml_content = table.concat(lines, "\n")

  -- Use Python to convert YAML to JSON
  local json_content = vim.fn.system(
    "python -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read()), indent=2))'",
    yaml_content
  )

  -- Check if the conversion was successful
  if vim.v.shell_error ~= 0 then
    print("Error: Failed to convert YAML to JSON. Make sure the YAML is valid.")
    return
  end

  -- Create a new split window
  vim.cmd('vnew')

  -- Set the content of the new buffer to the JSON
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(json_content, "\n"))

  -- Set the filetype to JSON for syntax highlighting
  vim.bo[buf].filetype = "json"

  -- print("YAML converted to JSON successfully.")
end

-- Create a command to call this function
vim.api.nvim_create_user_command("YamlToJson", ViewYamlAsJson, {})

-- Create a keymap
vim.api.nvim_set_keymap("n", "gly", ":YamlToJson<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "glj", ":YamlToJson<CR>", { noremap = true, silent = true })

