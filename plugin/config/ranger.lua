
local ranger_nvim = require("ranger-nvim")
local f = require "utils.functional"

local config = {
  enable_cmds = true,
  keybinds = {
    oh = "split",
    ["or"] = "rifle",
    ot = "tabedit",
    ov = "vsplit"
  },
  replace_netrw = false,
  ui = {
    border = "rounded",
    height = 0.6,
    width = 0.56410256410256,
    x = 0,
    y = 0.5
  }
}

ranger_nvim.setup( config )


function ranger_launch()
  local posOpts = Telesc_dynPosOpts()
  local width = (posOpts.width - 1) / vim.api.nvim_get_option('columns')
  local layout_opts =
    posOpts.anchor == 'E'
    and { ui = { x = 1, width = width } }
    or  { ui = { x = 0, width = width } }
  local lconf = vim.tbl_deep_extend( 'keep', layout_opts, config )
  ranger_nvim.setup( lconf )
  ranger_nvim.open( true )
end

vim.keymap.set( 'n', 'gr', ranger_launch )






