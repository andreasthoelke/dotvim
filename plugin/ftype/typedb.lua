


-- ─   Schema selection                                 ──

vim.g.typedb_active_schema = "default"

vim.keymap.set('n', '<leader><leader>glt', function()
  local options = {
    "default",
    "a_basic",
    "c_ai-tutorial",
  }
  
  -- Create a UI selection using vim.ui.select (available in Neovim 0.6+)
  vim.ui.select(options, {
    prompt = "Select TypeDB schema:",
    format_item = function(item)
      return item
    end
  }, function(choice)
    if choice then
      -- Set the selected string to g:codex_cmd
      vim.g.typedb_active_schema = choice
      print("Selected: " .. choice)
    else
      print("No selection made")
    end
  end)

end)


