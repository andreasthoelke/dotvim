
require('magenta').setup()

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







