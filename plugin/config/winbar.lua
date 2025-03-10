
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


-- ─   WinLeave Lsp state                                ■
local State_lastLsp = {}
function _G.Winbar_set_last_state( winid )
  State_lastLsp[ winid ] = LspSymbolsStack()
end

function _G.Winbar_get_last_state( winid )
  return State_lastLsp[ winid ]
end

-- Set the state when the cursor leaves a window
vim.api.nvim_exec([[
    augroup NavicState
        autocmd!
        autocmd WinLeave * lua Winbar_set_last_state( vim.fn.win_getid() )
    augroup END
]], false)

-- Set the winbar to use the last state
-- vim.api.nvim_set_option('winbar', '%{%v:lua.winbar_provider(vim.api.nvim_get_current_buf())%}')


-- ─^  WinLeave Lsp state                                ▲


function _G.LspSymbolsStack()
  local lspSymbolsStack = filterLspSymbolsStack( navic.get_data() )
  local lspSymbolStrs = vim.tbl_map( function( symb ) return symb.icon .. symb.name end, lspSymbolsStack )
  -- local joinedStrs = table.concat( lspSymbolStrs, " " .. icons.ui.ChevronLeft .. " " )
  local joinedStrs = table.concat( lspSymbolStrs, " " .. icons.ui.ChevronRight .. " " )
  -- note the <space> ensures that lua winbar uses the new highlight
  return joinedStrs == "" and " " or joinedStrs
end
-- lua vim.print( LspSymbolsStack() )
-- lua vim.print( require('nvim-navic').get_data() )
-- vim.print( LspSymbolsStack() )
-- 
-- This is using the WinLeave lsp cursor state. If I'd just use LspSymbolsStack
-- the winbar of inactive splits of the same buffer would update in sync with the current window.
function _G.LspSymbolsStack_inactive()
  local joinedStrs = _G.Winbar_get_last_state( vim.fn.win_getid() )
  return joinedStrs
end


function _G.formattedFileInfo()
  if utils.get_buf_option "mod" then
    local mod = icons.git.Mod
    return "%#WinBarFilename#" .. mod .. " " .. "%t" .. "%*"
  end
  -- return "%#WinBarFilename#" .. "%t" .. "%*"
  return "%#WinBarFilename#" .. vim.fn.expand('%:t:r') .. "%*"
end

function _G.Magenta_model()
  local ok, value = pcall(vim.api.nvim_win_get_var, 0, 'magenta_model')
  if ok then
    return value
  else
    return ""
  end
end

-- vim.api.nvim_win_get_option(0, 'wrap')
-- vim.api.nvim_win_get_option(0, 'winbar')
-- lua putt( vim.api.nvim_win_get_option(0, 'winbar') )
-- vim.api.nvim_win_set_var(0, 'abc', 'hi there')
-- vim.api.nvim_win_get_var(0, 'abc')
-- lua putt( vim.api.nvim_win_get_var(0, 'magenta_model') )


function _G.LspMeaningfulSymbol( bufnr )
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local symbStack = navic.get_data( bufnr )
  local candidateStack
  if vim.bo.filetype == 'scala' then
    candidateStack = fun.filter(
      -- function( el ) return el.type == "Method" or el.type == "Class" end,
      function( el ) return 0 == vim.fn.match( el.type, [[\v(Method|Function|Class|Interface)]] ) end,
      vim.fn.reverse(symbStack)
    )
  elseif vim.bo.filetype == 'typescript' then
    candidateStack = 
      vim.fn.reverse(symbStack)
  else
    candidateStack = fun.filter(
      -- function( el ) return el.type == "Function" or el.type == "Object" end,
      function( el ) return 0 == vim.fn.match( el.type, [[\v(Function|Object)]] ) end,
      symbStack
    )
  end
  local icon, name

  if candidateStack:length() > 0 then
    icon, name = fun.head( fun.map( function(el) return el.icon, el.name end, candidateStack ) )
  else
    icon, name = "", ""
  end
  return icon, name
end

-- lua putt( { LspMeaningfulSymbol( vim.fn.bufnr() ) } )
-- lua putt( { LspMeaningfulSymbol( 23 ) } )
-- LspMeaningfulSymbol( 23 ) 
-- vim.fn.match( "Function", [[\v(Method|Function|Class|Interface)]] )
-- vim.fn.match( "abcd", [[(c|f)]] )

-- ─   WinBar Lsp Symbol Stack                          ──
-- To explore datasource fields like 'type' and 'name' run this at cursor pos:
-- lua vim.print( require('nvim-navic').get_data() )

function _G.filterLspSymbolsStack( lspSymbolsStack )
  if lspSymbolsStack == nil then return {} end
  local lspSymbolsStack_filtered

  if vim.bo.filetype == 'scala' then
    local packagesDepth = fun.take_while(
      function( el ) return el.type == "Package" end,
      lspSymbolsStack
    ):length()
    -- NOTE: I'm still experimenting with this: packagesDepth + 2 shows the typical Object - def methodname() lsp-path
    lspSymbolsStack_filtered = fun.totable( fun.take_n( packagesDepth + 2, lspSymbolsStack ) )

    -- TYPESCRIPT:
  elseif vim.bo.filetype == 'typescript' and string.match(vim.fn.expand('%'), '%.spec') then
    lspSymbolsStack_filtered = vim.list_slice( lspSymbolsStack, 0, 1 )
  elseif vim.bo.filetype == 'typescript' then
    lspSymbolsStack_filtered = vim.list_slice( lspSymbolsStack, 0, 3 )

  else
    lspSymbolsStack_filtered = vim.list_slice( lspSymbolsStack, 0, 3 )
  end
  -- return vim.fn.reverse( lspSymbolsStack_filtered )
  return lspSymbolsStack_filtered
end

function _G.formatLspSymbolsStack( lspSymbolsStack )
  if vim.tbl_isempty( lspSymbolsStack ) then return "" end

  local lspStackFormatted = navic.format_data( lspSymbolsStack )
  return "%#WinBarContext#" .. lspStackFormatted .. " " .. icons.ui.ChevronLeft .. " " .. "%*"
end


-- NOTE: not using this, but lualine
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
-- use here: ~/.config/nvim/after/plugin/defaults.lua‖


return M








