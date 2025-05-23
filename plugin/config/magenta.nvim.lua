
-- require('magenta').setup()

require('magenta').setup({
  -- profiles = {
  --   {
  --     name = "claude-3-7",
  --     provider = "anthropic",
  --     model = "claude-3-7-sonnet-latest",
  --     apiKeyEnvVar = "ANTHROPIC_API_KEY"
  --   },
  --   {
  --     name = "gpt-4o",
  --     provider = "openai",
  --     model = "gpt-4o",
  --     apiKeyEnvVar = "OPENAI_API_KEY"
  --   }
  -- },
  -- open chat sidebar on left or right side
  sidebarPosition = "right",
  -- can be changed to "telescope" or "snacks"
  picker = "fzf-lua",
  -- enable default keymaps shown below
  defaultKeymaps = true,
  -- keymaps for the sidebar input buffer
  sidebarKeymaps = {
    normal = {
      ["<CR>"] = ":Magenta send<CR>",
    }
  },
  -- keymaps for the inline edit input buffer
  -- if keymap is set to function, it accepts a target_bufnr param
  inlineKeymaps =  {
    normal = {
      ["<CR>"] = function(target_bufnr)
        vim.cmd("Magenta submit-inline-edit " .. target_bufnr)
      end,
    },
  }
})

-- Other custom maps:
-- ~/.config/nvim/lua/config/mga_m.lua
-- Default maps:
-- ~/Documents/Proj/k_mindgraph/h_mcp/b_mga/lua/magenta/init.lua

vim.keymap.set( 'n',
  ',sm', function()
    require( 'plenary.reload' ).reload_module(
      'magenta.nvim'
    )
    vim.cmd('luafile ~/.config/nvim/plugin/config/magenta.nvim.lua')
  end )







