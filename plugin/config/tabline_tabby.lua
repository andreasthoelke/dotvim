
local fun = require 'utils.fun'
local api = require('tabby.module.api')

local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}


local render_default = function( line )
  return {
    {
      { '  ', hl = theme.head },
      line.sep('', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep('', hl, theme.fill),
        tab.is_current() and '' or '󰆣',
        tab.number(),
        tab.name(),
        tab.close_btn(''),
        line.sep('', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      return {
        line.sep('', theme.win, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        line.sep('', theme.win, theme.fill),
        hl = theme.win,
        margin = ' ',
      }
    end),
    {
      line.sep('', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
    },
    hl = theme.fill,
  }
end

local render_cwd = function(line)
  local cwd = ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
  return {
    {
      { cwd, hl = theme.head },
      line.sep('', theme.head, theme.line),
    },
    ".....",
  }
end


-- local theme = {
--   fill = 'TabLineFill',
--   -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
--   head = 'TabLine',
--   -- current_tab = 'TabLineSel',
--   current_tab = { fg = '#F8FBF6', bg = '#896a98', style = 'italic' },
--   tab = 'TabLine',
--   win = 'TabLine',
--   tail = 'TabLine',
-- }

-- require('tabby.tabline').set(function(line)
--   return {
--     {
--       { '  ', hl = theme.head },
--       line.sep('', theme.head, theme.fill),
--     },
--     line.tabs().foreach(function(tab)
--       local hl = tab.is_current() and theme.current_tab or theme.tab
--       return {
--         line.sep('', hl, theme.fill),
--         tab.is_current() and '' or '',
--         tab.number(),
--         tab.name(),
--         -- tab.close_btn(''), -- show a close button
--         line.sep('', hl, theme.fill),
--         hl = hl,
--         margin = ' ',
--       }
--     end),
--     line.spacer(),
--     -- shows list of windows in tab
--     -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
--     --   return {
--     --     line.sep('', theme.win, theme.fill),
--     --     win.is_current() and '' or '',
--     --     win.buf_name(),
--     --     line.sep('', theme.win, theme.fill),
--     --     hl = theme.win,
--     --     margin = ' ',
--     --   }
--     -- end),
--     {
--       line.sep('', theme.tail, theme.fill),
--       { '  ', hl = theme.tail },
--     },
--     hl = theme.fill,
--   }
-- end)


--- https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/presets.lua

local extract = require('tabby.module.highlight').extract
local tab_name_get = require('tabby.feature.tab_name').get_raw
local tab_name_set = require('tabby.feature.tab_name').set

local hl_tabline_fill = extract( 'lualine_c_normal' )
local Normal = extract( 'Normal' )
local hl_tabline = extract( 'lualine_b_normal' )
local hl_tabline_b_i = extract( 'lualine_b_inactive' )
local hl_c1 = extract( 'LuLine_Tabs_in' )
-- local hl_sc = extract( 'DevIconScala' )
local hl_tabline_sel = extract( 'lualine_a_normal' )

local Tabby_Tabs_ac = extract( 'Tabby_Tabs_ac' )
local Tabby_Tabs_in = extract( 'Tabby_Tabs_in' )

local function tab_label(tabid, active)
  -- local icon = active and 'i' or ''
  local icon = ""
  -- local number = vim.api.nvim_tabpage_get_number(tabid)
  local number = ""
  local name = tab_name_get(tabid)
  -- return string.format(' %s %d: %s ', icon, number, name)
  return name
end

local bubbles_preset = {
  hl = 'lualine_c_normal',
  layout = 'tab_only',
  active_tab = {
    label = function(tabid)
      return {
        tab_label(tabid, true),
        hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
      }
    end,
    left_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    right_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
  },
  inactive_tab = {
    label = function(tabid)
      return {
        tab_label(tabid, false),
        hl = { fg = hl_tabline.fg, bg = hl_tabline_fill.bg },
      }
    end,
    left_sep = { ' ', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    right_sep = { ' ', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
  },
}

-- require('tabby.tabline').set( render_c1, {} )

-- require('tabby.tabline').use_preset( 'tab_only' )


-- require('tabby.tabline').use_preset( 'tab_only',
--   {
--     theme = {
--       fill = 'TabLineFill', -- tabline background
--       head = 'TabLine', -- head element highlight
--       current_tab = 'TabLineSel', -- current tab label highlight
--       tab = 'TabLine', -- other tab label highlight
--       win = 'TabLine', -- window highlight
--       tail = 'TabLine', -- tail element highlight
--     },
--     nerdfont = false, -- whether use nerdfont
--     lualine_theme = nil, -- lualine theme name
--     tab_name = {
--       name_fallback = function(tabid) return 'hi there'end,
--     },
--     buf_name = {
--       mode = 'relative',
--     }
--   }
-- )

local tabby = require('tabby')

-- tabby.setup({ tabline = bubbles_preset })

-- require('tabby').tab_rename( "hi there" )

local devicons = require'nvim-web-devicons'

local sicon = devicons.get_icon( "abc.scala" )

local function set_label( value )
  if value == nil then return end
  tab_name_set( 0, value )
end

function _G.Tab_UserSetName()
  vim.ui.input(
    {
      prompt = "",
      completion = "customlist,Tab_complete_label",
    }, set_label )
end

-- vim.cmd 'TabRename aber4'
-- require('tabby.feature.tab_name').set( 0, 'hi' )
-- require('tabby.feature.tab_name').set( 0, '' )

vim.keymap.set( 'n', '<leader>ts', Tab_UserSetName )

-- Note i needed a vimscript proxy for this here: ~/.config/nvim/plugin/tools-tab-status-lines.vim‖/currentCompl,ˍfu
function _G.Tab_complete_label( currentCompl, fullLine, pos )
  return {currentCompl .. '|' .. 'eis', currentCompl .. '|' .. 'zwei'}
end


function _G.Tab_GenLabel( tabid )
end

function _G.Tab_render( tab, line )
  local given_name = tab_name_get( tab.id ) --  empty if label was set by user
  local label = not is_empty( given_name ) and given_name or Tab_GenLabel()

  -- lspIcon, lspName = LspMeaningfulSymbol( bufnr )
  -- local shortLspName = Status_shortenFilename( lspName )

  -- vim.fs.dirname( vim.fn.getcwd() )

  -- win.buf_name()
  -- tab.current_win().file_icon(),
  -- lsp common package
  -- a rep icon for the project or a unique filetype open
  -- no win count, ect

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

local render_c1 = function( line )

    local cwd = ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '

  return {
    { " ", hl = hl_tabline_fill },

    line.tabs().foreach( function(tab) return Tab_render(tab, line) end ),

    line.spacer(),

    { " ", hl = hl_tabline_fill },
  }
end

  --   lualine_y = { "lsp_progress", "g:metals_status" },
  --   -- lualine_z = { function () return _G.WeatherStatus end },

-- vim.fn.split( "eins.ab", [[\.]] )
-- vim.fn.split( "eins", [[\.]] )

require('tabby.tabline').set( render_c1, {} )


local api = require('tabby.module.api')

_G.TLtab_names = {}

function _G.TLload()
  -- local names_to_number = vim.json.decode( vim.g.SomeGlobal )
  -- if not (type(names_to_number) == 'table') then
  local ok, names_to_number = pcall(vim.json.decode, vim.g.SomeGlobal)
  if not (ok and type(names_to_number) == 'table') then
    return
  -- else
  --   return names_to_number
  end
  -- return names_to_number

  for _, tabid in ipairs(api.get_tabs()) do
    local tab_num = api.get_tab_number(tabid)
    local name = names_to_number[tostring(tab_num)]
    if name ~= nil then
      _G.TLtab_names[tostring(tabid)] = name
    end
  end
end

-- _G.TLload()
-- _G.TLtab_names


function _G.TLsave()
  local names_to_number = {} ---@type table<string, string>
  for tabid, name in pairs(_G.TLtab_names) do
    local ok, tab_num = pcall(api.get_tab_number, tonumber(tabid))
    if ok then
      names_to_number[tostring(tab_num)] = name
    end
  end
  vim.g.TabbyTabNames = vim.json.encode(names_to_number)
end

-- require('tabby.feature.tab_name').get(4)
-- require('tabby.feature.tab_name').pre_render()
-- require('tabby.feature.tab_name').get_raw(2)
-- require('tabby.feature.tab_name').get_raw(4)
-- require('tabby.feature.tab_name').get_raw()


-- table.pack( pcall(vim.json.decode, vim.g.TabbyTabNames) )
vim.json.encode( vim.g.TabbyTabNames )
-- vim.g.TabbyTabNames
-- '{"8":"aber4"}'

-- table.pack( pcall(vim.json.decode, vim.g.TabbyTabNames3) )
-- vim.g.TabbyTabNames3

-- vim.fn.SessionSaveSelectedGlobals()


-- require('tabby.feature.tab_name').get(1)
-- require('tabby.feature.tab_name').load()
-- vim.cmd "TabRename aber7"


-- vim.json.decode( vim.g.TabbyTabNames )
-- require('tabby.module.api').get_tabs()
-- require('tabby.module.api').get_tab_number(2)













