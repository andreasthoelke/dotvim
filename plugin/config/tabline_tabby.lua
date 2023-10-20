

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
local tab_name_get = require('tabby.feature.tab_name').get

local hl_tabline_fill = extract( 'lualine_c_normal' )
local hl_tabline = extract( 'lualine_b_normal' )
local hl_tabline_b_i = extract( 'lualine_b_inactive' )
local hl_c1 = extract( 'LuLine_Tabs_in' )
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


local render_c1 = function( line )
    local cwd = ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '

  return {
    -- { cwd, hl = hl_tabline_sel }
    { " ", hl = hl_tabline_fill }
    ,
    line.tabs().foreach(
      function(tab)
        -- local hl = tab.is_current() and hl_tabline_sel or hl_c1
        -- local hl = tab.is_current() and hl_tabline_sel or hl_tabline_fill
        -- local hl = tab.is_current() and hl_tabline or hl_tabline_fill
        local hl = tab.is_current() and Tabby_Tabs_ac or Tabby_Tabs_in
      return {
        line.sep('', hl, hl_tabline_fill),
        -- tab.is_current() and '' or '󰆣',
        -- tab.number(),
        tab.name(),
        line.sep('', hl, hl_tabline_fill),
        hl = hl,
        margin = " ",
      }
    end),
    line.spacer(),
    {
      line.sep('', hl_tabline_fill, hl_tabline_fill),
      vim.g["metals_status"],
      hl = hl_tabline_fill,
    },
    {
      line.sep('', hl_tabline_fill, hl_tabline_fill),
      "hi5",
      hl = hl_tabline_fill,
    },
    { " ", hl = hl_tabline_fill },

  }
end

  --   lualine_y = { "lsp_progress", "g:metals_status" },
  --   -- lualine_z = { function () return _G.WeatherStatus end },


require('tabby.tabline').set( render_c1, {} )


local api = require('tabby.module.api')


local function load()
  local ok, names_to_number = pcall(vim.json.decode, vim.g.TabbyTabNames)
  if not (ok and type(names_to_number) == 'table') then
    return
  end
  for _, tabid in ipairs(api.get_tabs()) do
    local tab_num = api.get_tab_number(tabid)
    local name = names_to_number[tostring(tab_num)]
    if name ~= nil then
      tab_names[tostring(tabid)] = name
    end
  end
end


-- require('tabby.feature.tab_name').get(1)
-- require('tabby.feature.tab_name').load()
-- TabRename aber3
-- vim.g.TabbyTabNames
-- vim.json.decode( vim.g.TabbyTabNames )
-- require('tabby.module.api').get_tabs()
-- require('tabby.module.api').get_tab_number(2)













