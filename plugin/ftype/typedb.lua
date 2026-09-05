


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

-- Choose one owned attribute from the contextual panel preview.  The preview
-- remains read-only until the common single confirmation in Vimscript.
function _G.Tdb_select_remove_attribute()
  local origin_panel = vim.fn.expand('%:p')
  local origin_line = vim.fn.line('.')
  local preview = vim.fn.Tdb_remove_panel_preview('')
  if not preview or vim.tbl_isempty(preview) then return end
  local attrs = preview.attributes or {}
  if #attrs == 0 then
    vim.notify('No owned attributes on the selected record', vim.log.levels.INFO)
    return
  end
  local labels = {}
  for _, attr in ipairs(attrs) do
    table.insert(labels, attr.label or attr.iid or '?')
  end
  vim.ui.select(labels, { prompt = 'Detach attribute:' }, function(_, index)
    if index then
      local selected = attrs[index]
      if vim.fn.expand('%:p') ~= origin_panel or vim.fn.line('.') ~= origin_line or vim.bo.modified then
        vim.notify('Removal canceled: panel, line, or buffer changed while choosing an attribute', vim.log.levels.WARN)
        return
      end
      local attr_preview = vim.fn.Tdb_remove_panel_preview(selected.iid or '')
      if attr_preview and not vim.tbl_isempty(attr_preview) then
        attr_preview.attribute_iid = selected.iid or ''
        vim.fn.Tdb_remove_confirm_and_apply(attr_preview, origin_panel, origin_line)
      end
    end
  end)
end
