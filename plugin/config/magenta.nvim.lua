
require('magenta').setup()


vim.keymap.set( 'n',
  ',sm', function() 
    require( 'plenary.reload' ).reload_module(
      'magenta.nvim'
    )
    vim.cmd('luafile ~/.config/nvim/plugin/config/magenta.nvim.lua')
  end )







