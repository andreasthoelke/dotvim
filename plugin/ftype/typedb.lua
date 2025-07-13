


-- ─   Schema selection                                 ──

vim.g.typedb_active_schema = "default"

function _G.Tdb_selectSchema()
  -- local options = {
  --   "default",
  --   "a_basic",
  --   "c_ai-tutorial",
  -- }
  
  local options = vim.fn.Tdb_listSchemaNames()

  -- Create a UI selection using vim.ui.select (available in Neovim 0.6+)
  vim.ui.select(options, {
    prompt = "TypeDB schema |" .. vim.g.typedb_active_schema .. "|:",
    format_item = function(item)
      return item
    end
  }, function(choice)
    if choice then
      -- Set the selected string to g:codex_cmd
      vim.g.typedb_active_schema = choice
      print("Selected: " .. choice)
    else
      -- print("No selection made")
    end
  end)

end


-- ─   Helpers                                          ──

function _G.Tdb_create_lineswise_maps()
  vim.keymap.set('n', 'ge', function()
    vim.g['tdb_schema_mode'] = 'define'
    _G.Tdb_linewise_func = Tdb_make_linewise_func()
    vim.go.operatorfunc = 'v:lua.Tdb_linewise_func'
    return 'g@'
  end, { expr = true, buffer = true, desc = "Operator to select lines for Tdb" })

  vim.keymap.set('n', ',ge', function()
    vim.g['tdb_schema_mode'] = 'undefine'
    _G.Tdb_linewise_func = Tdb_make_linewise_func()
    vim.go.operatorfunc = 'v:lua.Tdb_linewise_func'
    return 'g@'
  end, { expr = true, buffer = true, desc = "Operator to select lines for Tdb" })

end



-- Helper function for linewise operator-based selections
function Tdb_make_linewise_func()
  return function()
    -- Store registers
    local old_reg = vim.fn.getreg('z')
    local old_reg_type = vim.fn.getregtype('z')

    -- Get the exact position details
    local start_pos = vim.fn.getpos("'[")
    local end_pos = vim.fn.getpos("']")
    local start_line = start_pos[2]
    local end_line = end_pos[2]

    -- Use linewise visual mode to ensure we get complete lines
    vim.cmd(string.format('silent normal! %dGV%dG"zy', start_line, end_line))

    -- Get the yanked text
    local selected_text = vim.fn.getreg('z')
    

    local lines = vim.fn.split(selected_text, '\n')
    vim.fn.Tdb_runQueryShow(lines)

    -- Restore register
    vim.fn.setreg('z', old_reg, old_reg_type)
  end
end


