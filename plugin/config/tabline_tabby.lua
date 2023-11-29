
-- ─   Imports                                          ──

local f = require 'utils.functional'
local s = require 'utils.string'
local fun = require 'utils.fun'
local api = require('tabby.module.api')
local devicons = require'nvim-web-devicons'

-- https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/presets.lua


-- ─   Colors                                           ──
-- Note: ~/.config/nvim/colors/munsell-blue-molokai.vim‖*Lualine

local extract = require('tabby.module.highlight').extract
local tab_name = require('tabby.feature.tab_name')

local hl_tabline_fill = extract( 'lualine_c_normal' )
local Normal = extract( 'Normal' )
local hl_tabline = extract( 'lualine_b_normal' )
local hl_tabline_b_i = extract( 'lualine_b_inactive' )
local hl_c1 = extract( 'LuLine_Tabs_in' )
local hl_tabline_sel = extract( 'lualine_a_normal' )

local Hl_Tabby_Tabs_ac = extract( 'Tabby_Tabs_ac' )
local Hl_Tabby_Tabs_in = extract( 'Tabby_Tabs_in' )
local Hl_Tabby_Tabs_icon_ac = extract( 'Tabby_Tabs_icon_ac' )
local Hl_Tabby_Tabs_icon_in = extract( 'Tabby_Tabs_icon_in' )


-- ─   Persist tab names to session                      ■
vim.api.nvim_create_autocmd({ "SessionLoadPost" }, { callback = tab_name.load })
vim.api.nvim_create_autocmd({ "TabNew", "TabClosed" }, { callback = tab_name.save })
-- vim.g.TabbyTabNames
-- NOTES: I had to disable the internal load() and save() call in Tabby: ~/.config/nvim/plugged/tabby.nvim/lua/tabby/feature/tab_name.lua‖/functionˍtab_name.pre
-- TabId vs. TabNumber: Vim starts-up with TabNumbers and then uses them as TabIDs throughout the session.
-- As tabs are closed, opened and moved, and TabID are lost when vim closes, the tab names need to be saved buy tab-number.
-- neovim doesn't jet have a TabModed event so there's a tab_name.save() call in the \t] maps.

-- require('tabby.feature.tab_name').get_raw( vim.api.nvim_get_current_tabpage() )
-- require('tabby.feature.tab_name').set( 3, "test" )
-- vim.api.nvim_tabpage_get_number( vim.api.nvim_get_current_tabpage() )
-- vim.api.nvim_get_current_tabpage()

-- ─   User set tab label / name                        ──


local function persist_set( iconKey, rest )
  local value = iconKey .. "$" .. rest
  tab_name.set( 0, value )
  tab_name.save()
end

local function persist_reset()
  tab_name.set( 0, "" )
  tab_name.save()
end

local function persist_get( tabid )
  local persisted = tab_name.get_raw( tabid )
  if persisted == "" then
    return nil, nil
  else
    return table.unpack( vim.fn.split( persisted, [[\$]] ) )
  end
end

-- E.g. Account.scala$config Acco|ErroInfo
-- TODO: can the users edit-remove the icon?
local function user_set( fullUserStr )
  if fullUserStr == "" then
    persist_reset()
  else
    local iconKey, rest = table.unpack( vim.fn.split( fullUserStr, [[\$]] ) )
    persist_set( iconKey, rest )
  end
end

-- vim.fn.split( 'eins$zwei', [[\$]] )

local function user_get()
  local tabid = vim.api.nvim_get_current_tabpage()
  local iconKey, rest = persist_get( tabid )
  local fullUserStr
  if iconKey ~= nil then
    fullUserStr = iconKey .. "$" .. rest
  else
    local iconKy, folder, fileWins = Tab_GenLabel( tabid )
    fullUserStr = iconKy .. "$" .. folder .. " " .. fileWins
  end
  return fullUserStr
end

-- Takes a fresh GenLabel, replaces folder with the current lsp symbol. Then makes a persist.
-- So an lsp-sym header is always loaded from persist. Edits can be made to the persist as usual but updating (calling user_set_lspsym again) will overwrite them.
local function user_set_lspsym()
  local iconKey, _folder, fileWins = Tab_GenLabel( vim.api.nvim_get_current_tabpage()  )
  local lspIcon, lspName = LspMeaningfulSymbol()
  if lspIcon == nil then return end
  local lspName_short = Status_shortenFilename( lspName )
  -- local rest = lspIcon .. lspName_short .. " " .. fileWins
  -- local rest = lspName_short .. lspIcon .. fileWins
  local rest = lspName_short .. " " .. fileWins
  persist_set( iconKey, rest )
end

function _G.Tablabel_set_folder( folderPath )
  local iconKey, _folder, fileWins = Tab_GenLabel( vim.api.nvim_get_current_tabpage()  )
  local folderName = vim.fn.fnamemodify( folderPath, ':t' )
  local rest = folderName .. " " .. fileWins
  persist_set( iconKey, rest )
end

function _G.Tab_UserSetName()
  vim.ui.input(
    {
      prompt = "",
      default = user_get(),
      completion = "customlist,Tab_user_completion_fn",
    }, user_set )
end


-- ─   Hide Tabs                                         ■

_G.Tabs_hidden = {}
_G.Tabs_show_hidden = true

function _G.Tabs_all_toggle_hide()
  _G.Tabs_show_hidden = true

  if #Tabs_hidden == 0 then
    _G.Tabs_hidden = vim.api.nvim_list_tabpages()
    Tab_toggle_hide()
  else
    _G.Tabs_hidden = {}
    require('tabby').update()
  end
end

function _G.Tab_toggle_hide()
  local tabid = vim.api.nvim_get_current_tabpage()
  if f.contains( tabid, Tabs_hidden ) then
    Tabs_hidden = f.filter( function( id ) return id ~= tabid end, Tabs_hidden )
  else
    Tabs_hidden = f.concat( Tabs_hidden, { tabid } )
  end
  require('tabby').update()
end
-- Note that closed tabs can just stay in the hidden list bc/ tab-ids are unique per vim session

function _G.Tab_hide_removeFromHidden()
  local tabid = vim.api.nvim_get_current_tabpage()
  if f.contains( tabid, Tabs_hidden ) then
    Tabs_hidden = f.filter( function( id ) return id ~= tabid end, Tabs_hidden )
  end
end

function _G.Tabs_hidden_indexs()
  return f.map( function( id )
      local tabIndex = vim.fn.index( vim.api.nvim_list_tabpages(), id ) + 1
      return tabIndex
    end, Tabs_hidden )
end

-- Tab_toggle_hide()
-- vim.api.nvim_get_current_tabpage()
-- Tabs_hidden

function _G.Tabs_toggle_show_hidden()
  if Tabs_show_hidden then
    Tabs_show_hidden = false
  else
    Tabs_show_hidden = true
  end
  require('tabby').update()
end

function _G.Tab_go_tabnum( tabnr )
  local tabId = vim.api.nvim_list_tabpages()[ tabnr ]
  vim.api.nvim_set_current_tabpage( tabId )
end

-- Tab_go_tabnum( 3 )

function _G.Tab_go_tabnum_consider_hidden( visibleTabIdx )
  vim.api.nvim_set_current_tabpage( Tab_id_fromVisIdx( visibleTabIdx ) )
end

function _G.Tabs_visibleIds()
  local allTabIds = vim.api.nvim_list_tabpages()
  if Tabs_show_hidden then return allTabIds end
  return f.filter( function(tabId)
    return not f.contains( tabId, Tabs_hidden )
  end, allTabIds )
end

function _G.Tab_id_fromVisIdx( visibleTabIdx )
  return Tabs_visibleIds()[ visibleTabIdx ]
end

-- Tab_go_tabnum_consider_hidden( 3 )

-- Returns 0 if not visible
function _G.Tab_visIdx( tabId )
  return vim.fn.index( Tabs_visibleIds(), tabId ) + 1
end
-- Tab_visIdx( 12 )

function _G.Tab_visIdx_label( tabId )
  local visIdx = Tab_visIdx( tabId )
  return visIdx >= 6 and tostring( visIdx ) or ""
end


-- function _G.Tab_go_offset( offset )
--   if #Tabs_visibleIds() <= 1 then return end
--   local nextTabIndex = vim.fn.tabpagenr() + offset
--   nextTabIndex = nextTabIndex <= vim.fn.tabpagenr('$') and nextTabIndex     or 1
--   nextTabIndex = nextTabIndex < 1                 and vim.fn.tabpagenr('$') or nextTabIndex

--   local proposedNextTabId = vim.api.nvim_list_tabpages()[ nextTabIndex ]

--   if not f.contains( proposedNextTabId, Tabs_visibleIds() ) then
--     Tab_go_offset( offset + offset )
--   else
--     vim.api.nvim_set_current_tabpage( proposedNextTabId )
--   end
-- end

function _G.Tab_go_offset( offset )
  local visTabsCnt = #Tabs_visibleIds()
  if visTabsCnt <= 1 then return end

  local curVisTabIdx = Tab_visIdx( vim.api.nvim_get_current_tabpage() )

  local nextTabIndex = curVisTabIdx + offset
  nextTabIndex = nextTabIndex <= visTabsCnt and nextTabIndex     or 1
  nextTabIndex = nextTabIndex < 1           and visTabsCnt or nextTabIndex

  local nextId = Tabs_visibleIds()[ nextTabIndex ]
  vim.api.nvim_set_current_tabpage( nextId )
end

-- vim.fn.tabpagenr()
-- vim.fn.tabpagenr()
-- Tabs_hidden
-- Tabs_visibleIds()
-- vim.api.nvim_get_current_tabpage()
-- vim.fn.index( vim.api.nvim_list_tabpages(), 1 )


-- ─^  Hide Tabs                                         ▲


-- ─   Mappings                                          ■
vim.keymap.set( 'n', '<leader>ts', Tab_UserSetName )
vim.keymap.set( 'n', '<leader>tS', persist_reset )
vim.keymap.set( 'n', '<leader>tu', Tab_toggle_hide )
vim.keymap.set( 'n', '<leader>tU', Tabs_all_toggle_hide )
vim.keymap.set( 'n', '<leader>ty', Tabs_toggle_show_hidden )

-- Note i needed a vimscript proxy for this here: ~/.config/nvim/plugin/tools-tab-status-lines.vim‖/currentCompl,ˍfu
-- TODO: show abbreviations of other windows in tab?
function _G.Tab_user_completion_fn( currentCompl, fullLine, pos )
  return {currentCompl .. '|' .. 'eins', currentCompl .. '|' .. 'zwei'}
end

local tab_go = function( tabnr )
  return function() Tab_go_tabnum_consider_hidden( tabnr ) end
end

vim.keymap.set( 'n', '<c-f>', function() Tab_go_offset(  1 ) end )
vim.keymap.set( 'n', '<c-d>', function() Tab_go_offset( -1 ) end )

vim.keymap.set( 'n', '<leader>1', tab_go(1) )
vim.keymap.set( 'n', '<leader>2', tab_go(2) )
vim.keymap.set( 'n', '<leader>3', tab_go(3) )
vim.keymap.set( 'n', '<leader>4', tab_go(4) )
vim.keymap.set( 'n', '<leader>5', tab_go(5) )
vim.keymap.set( 'n', '<leader>6', tab_go(6) )
vim.keymap.set( 'n', '<leader>7', tab_go(7) )
vim.keymap.set( 'n', '<leader>8', tab_go(8) )
vim.keymap.set( 'n', '<leader>9', tab_go(9) )


-- ─^  Mappings                                          ▲


-- ─   Auto generate label text                         ──

local utils = require("neo-tree.utils")

-- Icon , parentFolder/cwd or lsp , fileWins
-- Return a string with the first and potentially secondary file name with a bar in between.
-- If the type of the secondary file differs from the first it will be preceded a b/w icon.
-- show parent folder if file is in cwd
-- ↑ show local cwd if window has one
-- ↗ outer repo: show local repo root folder if file is outside of cwd
-- ↘ inner repo: show local repo root folder if file is inside of cwd and inside of an inner repo

function _G.Tab_GenLabel( tabid )
  local tabFiles = FilesInTab( tabid )
  if #tabFiles == 0 then return vim.fn.expand('%:r') end
  local mainFile  = tabFiles[1].fname
  local mainWinNum = tabFiles[1].winnr 
  local iconKey = vim.fn.fnamemodify( mainFile, ':t' )

  local tabNum = vim.api.nvim_tabpage_get_number( tabid )
  -- local hasLocalCwd = vim.fn.haslocaldir( mainWinNum, tabNum )
  local tabCwd = vim.fn.getcwd( mainWinNum, tabNum )
  local globalCwd = vim.fn.getcwd( -1, -1 )

  local  mainFile_isInCwd = utils.is_subpath( globalCwd, mainFile )
  local  mainFile_projectRoot = vim.fn.FindProjectRootFolder( mainFile )

  local folderStr
  if tabCwd ~= globalCwd then
    folderStr = "↑ " .. Status_shortenFilename( vim.fn.fnamemodify( tabCwd, ':t' ) )
  elseif not mainFile_isInCwd then
    local _, folderName = utils.split_path( mainFile_projectRoot )
    folderStr = "↗ " .. Status_shortenFilename( folderName )
  elseif mainFile_projectRoot ~= globalCwd then
    local _, folderName = utils.split_path( mainFile_projectRoot )
    folderStr = "↘ " .. Status_shortenFilename( folderName )
  else
    folderStr = vim.fn.fnamemodify( vim.fs.dirname( mainFile ) or "", ':t' )
  end

  local mainFile_shortName = Status_shortenFilename( vim.fn.fnamemodify( mainFile, ':t:r' ) )
  local fileWins = mainFile_shortName or ""
  if #tabFiles > 1 then
    local secondFile_shortName = Status_shortenFilename( vim.fn.fnamemodify( tabFiles[#tabFiles].fname, ':t:r' ) )
    fileWins = fileWins .. "▕ " .. secondFile_shortName
  end

  return iconKey, folderStr, fileWins, mainFile_projectRoot
end

-- vim.api.nvim_tabpage_get_number( 2 )
-- vim.fn.getcwd( 1, 1 )
-- table.pack( Tab_GenLabel( 1 ) )
-- table.pack( Tab_GenLabel( vim.api.nvim_get_current_tabpage()  ) )
-- vim.api.nvim_get_current_tabpage()

-- Icon , parentFolder/cwd or lsp , fileWins
-- Return a string with the first and potentially secondary file name with a bar in between.
-- If the type of the secondary file differs from the first it will be preceded a b/w icon.
-- show parent folder if file is in cwd
-- ∪
-- show local repo root folder
--   if window has a local cwd
-- ∩
-- show local repo root folder
--   if window has no local cwd
--   but file is outside of cwd


-- function _G.Tab_GenLabel_test( tabid )
--   local tabFiles = FilesInTab( tabid )
--   if #tabFiles == 0 then return vim.fn.expand('%:r') end
--   local mainFile  = tabFiles[1].fname
--   local mainWinNum = tabFiles[1].winnr
--   local iconKey = vim.fn.fnamemodify( mainFile, ':t' )

--   local tabNum = vim.api.nvim_tabpage_get_number( tabid )
--   -- local hasLocalCwd = vim.fn.haslocaldir( mainWinNum, tabNum )
--   local tabCwd = vim.fn.getcwd( mainWinNum, tabNum )

--   return { tabCwd, mainWinNum, tabNum, tabFiles }
-- end

-- Tab_GenLabel_test( 1 )

function _G.Tab_GenLabel_bak( tabid )
  local tabFiles = FilesInTab( tabid )
  if #tabFiles == 0 then return vim.fn.expand('%:r') end
  local mainFile = tabFiles[1].fname
  local iconKey = vim.fn.fnamemodify( mainFile, ':t' )

  local cwd = Tab_getCwd( tabid )
  local folder =
    cwd ~= vim.fn.getcwd(-1)  --  show the cwd if divergent or the parent folder
    and Status_shortenFilename( vim.fn.fnamemodify( cwd, ':t' ) )
    or  vim.fn.fnamemodify( vim.fs.dirname( mainFile ) or "", ':t' )

  local mainFile_shortName = Status_shortenFilename( vim.fn.fnamemodify( mainFile, ':t:r' ) )
  local fileWins = mainFile_shortName or ""
  if #tabFiles > 1 then
    local secondFile_shortName = Status_shortenFilename( vim.fn.fnamemodify( tabFiles[#tabFiles].fname, ':t:r' ) )
    fileWins = fileWins .. "▕ " .. secondFile_shortName
  end

  return iconKey, folder, fileWins
end

-- local iconKey, folder, fileWins = Tab_GenLabel( vim.api.nvim_get_current_tabpage()  )
-- table.pack( Tab_GenLabel( vim.api.nvim_get_current_tabpage()  ) )

-- ─   Render                                           ──

function _G.Tab_render( tab, line )

  local isHidden = f.contains( tab.id, Tabs_hidden )
  if isHidden and not Tabs_show_hidden then return end

  local hiddenPrefix = isHidden and "ˍ" or ""

  local iconKey, labelRest
  iconKey, labelRest = persist_get( tab.id )

  if iconKey == nil then
    local folder, fileWins
    iconKey, folder, fileWins = Tab_GenLabel( tab.id )
    -- TODO this catches the situation when telescope help opens lua.txt in a new tab.
    labelRest = (folder or "") .. " " .. (fileWins or "")
  end

  labelRest = Tab_visIdx_label( tab.id ) .. " " .. labelRest or labelRest
  labelRest = labelRest .. hiddenPrefix

  local icon, iconColor = devicons.get_icon_color( iconKey )
  local Hl_Tab_ac_inac = tab.is_current() and Hl_Tabby_Tabs_ac or Hl_Tabby_Tabs_in
  -- local Hl_Tab_icon_ac_inac = tab.is_current() and Hl_Tabby_Tabs_icon_ac or Hl_Tabby_Tabs_icon_in
  local Hl_Tab_icon_ac_inac = tab.is_current() and { fg = iconColor, bg = Hl_Tabby_Tabs_icon_ac.bg } or Hl_Tabby_Tabs_icon_in

  -- local colorIcon = { icon, hl = { fg = iconColor, bg = Hl_Tab_ac_inac.bg } }
  local colorIcon = { icon, hl = { fg = Hl_Tab_icon_ac_inac.fg, bg = Hl_Tab_ac_inac.bg } }

  return {
    line.sep('', Hl_Tab_ac_inac, Normal),

    colorIcon,
    labelRest,

    line.sep('', Hl_Tab_ac_inac, Normal),

    hl = Hl_Tab_ac_inac,
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

















