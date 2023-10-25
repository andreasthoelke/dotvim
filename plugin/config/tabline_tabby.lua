
local f = require 'utils.functional'
local s = require 'utils.string'
local fun = require 'utils.fun'
local api = require('tabby.module.api')
local devicons = require'nvim-web-devicons'

-- https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/presets.lua

local extract = require('tabby.module.highlight').extract
local tab_name = require('tabby.feature.tab_name')

local hl_tabline_fill = extract( 'lualine_c_normal' )
local Normal = extract( 'Normal' )
local hl_tabline = extract( 'lualine_b_normal' )
local hl_tabline_b_i = extract( 'lualine_b_inactive' )
local hl_c1 = extract( 'LuLine_Tabs_in' )
local hl_tabline_sel = extract( 'lualine_a_normal' )

local Tabby_Tabs_ac = extract( 'Tabby_Tabs_ac' )
local Tabby_Tabs_in = extract( 'Tabby_Tabs_in' )



-- ─   Persist tab names to session                      ■
vim.api.nvim_create_autocmd({ "SessionLoadPost" }, { callback = tab_name.load })
vim.api.nvim_create_autocmd({ "TabNew", "TabClosed" }, { callback = tab_name.save })
-- vim.g.TabbyTabNames
-- NOTES: I had to disable the internal load() and save() call in Tabby: ~/.config/nvim/plugged/tabby.nvim/lua/tabby/feature/tab_name.lua‖/functionˍtab_name.pre
-- TabId vs. TabNumber: Vim starts-up with TabNumbers and then uses them as TabIDs throughout the session.
-- As tabs are closed, opened and moved, and TabID are lost when vim closes, the tab names need to be saved buy tab-number.
-- neovim doesn't jet have a TabModed event so there's a tab_name.save() call in the \t] maps.

-- ─   User set tab label / name                        ──
local function label_set( value )
  if value == nil then return end
  tab_name.set( 0, value )
  tab_name.save()
end

local function label_get( tabid )
  local given_name = tab_name.get_raw( tabid ) --  empty if label was set by user
  local label = not is_empty( given_name ) and given_name or Tab_GenLabel( tabid )
  return label
end

function _G.Tab_UserSetName()
  vim.ui.input(
    {
      prompt = "",
      default = label_get( vim.api.nvim_get_current_tabpage() ),
      completion = "customlist,Tab_complete_label",
    }, label_set )
end

vim.keymap.set( 'n', '<leader>ts', Tab_UserSetName )
vim.keymap.set( 'n', '<leader>tS', function() label_set("") end )

-- Note i needed a vimscript proxy for this here: ~/.config/nvim/plugin/tools-tab-status-lines.vim‖/currentCompl,ˍfu
-- TODO: show abbreviations of other windows in tab?
function _G.Tab_complete_label( currentCompl, fullLine, pos )
  return {currentCompl .. '|' .. 'eins', currentCompl .. '|' .. 'zwei'}
end


-- ─   Auto generate label text                         ──

function _G.Tab_GenLabel( tabid )
  local filePaths = FileNamesInTabId( tabid )
  local currentPath = vim.fn.expand('%:r')
  if #filePaths == 0 then return currentPath end
  local mainFile = filePaths[1]
  local icon, color = devicons.get_icon_color( mainFile )

  local mainFile_shortName = Status_shortenFilename( vim.fn.fnamemodify( mainFile, ':t:r' ) )
  local mainFile_folder = vim.fn.fnamemodify( vim.fs.dirname( mainFile ) or "", ':t' )
  return icon .. " " .. mainFile_folder .. " " .. mainFile_shortName
end

-- Tab_GenLabel( vim.api.nvim_get_current_tabpage()  )
-- require('tabby.module.api').get_current_tab()
-- vim.api.nvim_get_current_tabpage()
-- require('tabby.feature.tab_name').get_raw( vim.api.nvim_get_current_tabpage() )


function _G.Tab_render( tab, line )
   local label = label_get( tab.id )

  -- lspIcon, lspName = LspMeaningfulSymbol( bufnr )
  -- local shortLspName = Status_shortenFilename( lspName )

  -- vim.fs.dirname( vim.fn.getcwd() )

  -- win.buf_name()
  -- tab.current_win().file_icon(),
  -- lsp common package
  -- a rep icon for the project or a unique filetype open

  local Tab_ac_inac = tab.is_current() and Tabby_Tabs_ac or Tabby_Tabs_in


  label = tab.is_current() and label or _G.Status_fileNameToIconPlusName( tab.current_win().buf().id )

  return {
    line.sep('', Tab_ac_inac, Normal),

    -- { sicon, hl = { fg = Tab_ac_inac.fg, bg = Tab_ac_inac.bg } },
    label,

    line.sep('', Tab_ac_inac, Normal),

    hl = Tab_ac_inac,
    margin = " ",
  }
end

-- vim.api.nvim_tabpage_list_wins(2)
-- vim.fn.tabpagebuflist()

local render = function( line )


  return {
    { " ", hl = hl_tabline_fill },

    line.tabs().foreach( function(tab) return Tab_render(tab, line) end ),

    line.spacer(),

    { " ", hl = hl_tabline_fill },
  }
end



require('tabby.tabline').set( render, {} )

















