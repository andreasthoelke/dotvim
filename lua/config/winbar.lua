
local M = {}

local colors = require "config.colors"
local navic = require "nvim-navic"
local utils = require "utils.basic1"
local icons = require "config.icons"
local fun = require 'utils.fun'

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

local function formattedFileInfo()
  if utils.get_buf_option "mod" then
    local mod = icons.git.Mod
    return "%#WinBarFilename#" .. mod .. " " .. "%t" .. "%*"
  end
  -- return "%#WinBarFilename#" .. "%t" .. "%*"
  return "%#WinBarFilename#" .. vim.fn.expand('%:t:r') .. "%*"
end


function _G.filterLspSymbolsStack( lspSymbolsStack )
  if lspSymbolsStack == nil then return {} end
  local lspSymbolsStack_filtered

  if vim.bo.filetype == 'scala' then
    local packagesDepth = take_while(
      function( el ) return el.type == "Package" end,
      lspSymbolsStack
    ):length()
    lspSymbolsStack_filtered = totable( take_n( packagesDepth + 1, lspSymbolsStack ) )
  else
    lspSymbolsStack_filtered = vim.list_slice( lspSymbolsStack, 0, 1 )
  end
  return vim.fn.reverse( lspSymbolsStack_filtered )
end

function _G.formatLspSymbolsStack( lspSymbolsStack )
  if vim.tbl_isempty( lspSymbolsStack ) then return "" end

  local lspStackFormatted = navic.format_data( lspSymbolsStack )
  return "%#WinBarContext#" .. lspStackFormatted .. " " .. icons.ui.ChevronLeft .. " " .. "%*"
end


-- vim.tbl_isempty()

function M.get_winbar()
  if excludes() then
    return ""
  end
  if navic.is_available() then
    return "%#WinBarSeparator#"
      .. "%="
      .. ""
      .. "%*"
      .. formatLspSymbolsStack( filterLspSymbolsStack( navic.get_data() ) )
      .. formattedFileInfo()
      .. "%#WinBarSeparator#"
      .. ""
      .. "%*"
  else
    return "%#WinBarSeparator#" .. "%=" .. "" .. "%*" .. formattedFileInfo() .. "%#WinBarSeparator#" .. "" .. "%*"
  end
end
-- lua putt( require 'config.winbar'.get_winbar() )
-- lua putt( formatLspSymbolsStack( filterLspSymbolsStack( require('nvim-navic').get_data() ) ) )

return M



-- fun = require 'fun'
-- lua for _k, a in require('luafun_neovim').range(3) do print(a) end





