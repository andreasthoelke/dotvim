

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

local render_c1 = function( line )
    local cwd = ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '

  return {

    line.tabs().foreach(
      function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep('_', hl, theme.fill),
        tab.is_current() and '' or '󰆣',
        tab.number(),
        tab.name(),
        line.sep('-', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),

    "hi there 2",

    {
      "hi there",
      hl = "Search",
    },


    -- hl = theme.fill,

    -- node 1
    -- {
    --   "tab1", 101,
    --   hl = "TabLineSel"
    -- },

    -- node 2
    -- {
    --   "text 1",
    --   {
    --     "text 2",
    --     hl = "Info",
    --   },
    --   "text3",
    --   hl = "Fill",
    -- },

  }
end


local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  -- current_tab = 'TabLineSel',
  current_tab = { fg = '#F8FBF6', bg = '#896a98', style = 'italic' },
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}

require('tabby.tabline').set(function(line)
  return {
    {
      { '  ', hl = theme.head },
      line.sep('', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep('', hl, theme.fill),
        tab.is_current() and '' or '',
        tab.number(),
        tab.name(),
        -- tab.close_btn(''), -- show a close button
        line.sep('', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    -- shows list of windows in tab
    -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
    --   return {
    --     line.sep('', theme.win, theme.fill),
    --     win.is_current() and '' or '',
    --     win.buf_name(),
    --     line.sep('', theme.win, theme.fill),
    --     hl = theme.win,
    --     margin = ' ',
    --   }
    -- end),
    {
      line.sep('', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
    },
    hl = theme.fill,
  }
end)



--- https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/presets.lua

local util = require('tabby.util')

local hl_tabline_fill = util.extract_nvim_hl('lualine_c_normal') -- 背景
local hl_tabline = util.extract_nvim_hl('lualine_b_normal')
local hl_tabline_sel = util.extract_nvim_hl('lualine_a_normal') -- 高亮

local function tab_label(tabid, active)
  local icon = active and '' or ''
  local number = vim.api.nvim_tabpage_get_number(tabid)
  local name = util.get_tab_name(tabid)
  return string.format(' %s %d: %s ', icon, number, name)
end

local presets = {
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

require('tabby').setup({
        tabline = presets
      })


-- require('tabby.tabline').set( render_c1, {} )






















