
local ranger_nvim = require("ranger-nvim")
local f = require "utils.functional"

local config = {
  enable_cmds = true,
  replace_netrw = false,
  keybinds = {
    ["ov"] = ranger_nvim.OPEN_MODE.vsplit,
    ["oh"] = ranger_nvim.OPEN_MODE.split,
    ["ot"] = ranger_nvim.OPEN_MODE.tabedit,
    ["or"] = ranger_nvim.OPEN_MODE.rifle,
  },
  ui = {
    border = "rounded",
    height = 0.6,
    width = 0.45,
    x = 0.5,
    y = 0.5,
  }
}

ranger_nvim.setup( config )


function ranger_launch()
  local layout_opts = 
    WinIsLeftSplit()
    and { ui = { x = 1 } }
    or  { ui = { x = 0 } }
  local lconf = vim.tbl_extend( 'keep', layout_opts, config )
  ranger_nvim.setup( lconf ) 
  ranger_nvim.open( true )
end

vim.keymap.set( 'n', 'gr', ranger_launch )







