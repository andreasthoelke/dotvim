
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

vim.keymap.set( 'n', '<leader>ts', Tab_UserSetName )
vim.keymap.set( 'n', '<leader>tS', persist_reset )
vim.keymap.set( 'n', '<leader>tl', user_set_lspsym )

-- Note i needed a vimscript proxy for this here: ~/.config/nvim/plugin/tools-tab-status-lines.vim‖/currentCompl,ˍfu
-- TODO: show abbreviations of other windows in tab?
function _G.Tab_user_completion_fn( currentCompl, fullLine, pos )
  return {currentCompl .. '|' .. 'eins', currentCompl .. '|' .. 'zwei'}
end


-- ─   Auto generate label text                         ──

-- Icon , parentFolder/cwd or lsp , fileWins
-- Return a string with the first and potentially secondary file name with a bar in between.
-- If the type of the secondary file differs from the first it will be preceded a b/w icon.
function _G.Tab_GenLabel( tabid )
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
-- Tab_GenLabel( vim.api.nvim_get_current_tabpage()  )

-- ─   Render                                           ──

function _G.Tab_render( tab, line )

  local iconKey, labelRest
  iconKey, labelRest = persist_get( tab.id )

  if iconKey == nil then
    local folder, fileWins
    iconKey, folder, fileWins = Tab_GenLabel( tab.id )
    -- TODO this catches the situation when telescope help opens lua.txt in a new tab.
    labelRest = (folder or "") .. " " .. (fileWins or "")
  end

  labelRest = tab.number() >= 6 and tostring( tab.number() ) .. " " .. labelRest or labelRest

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

















