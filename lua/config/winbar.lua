
local M = {}

local colors = require "config.colors"
local navic = require "nvim-navic"
local utils = require "utils"
local icons = require "config.icons"

vim.api.nvim_set_hl(0, "WinBarSeparator", { fg = colors.CommentSection })
vim.api.nvim_set_hl(0, "WinBarFilename", { fg = colors.Comment, bg = colors.CommentSection })
vim.api.nvim_set_hl(0, "WinBarContext", { fg = colors.Comment, bg = colors.CommentSection })

M.winbar_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "packer",
  "neogitstatus",
  "NvimTree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
}

local excludes = function()
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

local function get_modified()
  if utils.get_buf_option "mod" then
    local mod = icons.git.Mod
    return "%#WinBarFilename#" .. mod .. " " .. "%t" .. "%*"
  end
  -- return "%#WinBarFilename#" .. "%t" .. "%*"
  return "%#WinBarFilename#" .. vim.fn.expand('%:t:r') .. "%*"
end

local function get_location()
  -- local location = navic.get_location()
  local depth
  if vim.bo.filetype == 'scala' then
    depth = 2
  else
    depth = 1
  end
  local location = navic.format_data( vim.fn.reverse( vim.list_slice( navic.get_data() or {}, 0, depth ) ) )
  if not utils.is_empty(location) then
    -- return "%#WinBarContext#" .. " " .. icons.ui.ChevronRight .. " " .. location .. "%*"
    return "%#WinBarContext#" .. location .. " " .. icons.ui.ChevronLeft .. " " .. "%*"
  end
  return ""
end

function M.get_winbar()
  if excludes() then
    return ""
  end
  if navic.is_available() then
    return "%#WinBarSeparator#"
      .. "%="
      .. ""
      .. "%*"
      .. get_location()
      .. get_modified()
      .. "%#WinBarSeparator#"
      .. ""
      .. "%*"
  else
    return "%#WinBarSeparator#" .. "%=" .. "" .. "%*" .. get_modified() .. "%#WinBarSeparator#" .. "" .. "%*"
  end
end
-- lua putt( require 'config.winbar'.get_winbar() )

return M



-- fun = require 'fun'
-- lua for _k, a in require('luafun_neovim').range(3) do print(a) end





