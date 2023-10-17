

-- ─   Helpers                                          ──

local colors = require 'config.colors'

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end


local function git_diff_changeCount()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns and gitsigns.added then
    return {
      -- added = gitsigns.added,
      -- modified = gitsigns.changed,
      -- removed = gitsigns.removed,
      -- Have only one number to indicate the amount of change in the file.
      added = gitsigns.added + gitsigns.changed + gitsigns.removed,
    }
  end
end

-- note that this path is not relative when in an inactive window.
function _G.ShortenedFilePath()
  local fpath = vim.fn.pathshorten( vim.fn.fnamemodify( vim.fn.expand("%"), ":~:."),
    2
  )
  -- return fpath
  return vim.fn.substitute( fpath, "/", " ", "g" )
end



local devicons = require'nvim-web-devicons'
function _G.getDevIcon(filename, filetype, extension)
  local icon, color
  local devhl = filetype
  if filetype == 'TelescopePrompt' then
    icon, color = devicons.get_icon_color('telescope', { default = true })
  elseif filetype == 'fugitive' then
    icon, color =  devicons.get_icon_color('git', { default = true })
  elseif filetype == 'vimwiki' then
    icon, color =  devicons.get_icon_color('markdown', { default = true })
  elseif buftype == 'terminal' then
    icon, color =  devicons.get_icon_color('zsh', { default = true })
  else
    icon, color =  devicons.get_icon_color(filename, extension, { default = true })
    _, devhl =  devicons.get_icon(filename, extension, { default = true })
  end
  return icon, color, devhl
end


local function grbox2()
  return {

    normal = {
      a = {bg = colors.gray, fg = colors.black, gui = 'bold'},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.darkgray, fg = colors.gray},
      x = {bg = colors.gray, fg = colors.white},
      y = {bg = colors.lightgray, fg = colors.white},
      z = {bg = colors.gray, fg = colors.black},
    },

    inactive = {
    }
  }
end


local function grbox1() -- ■
  return {
    normal = {
      a = {bg = colors.gray, fg = colors.black, gui = 'bold'},
      -- a = {bg = colors.gray, fg = colors.black},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.darkgray, fg = colors.gray},
      x = {bg = colors.gray, fg = colors.white},
      y = {bg = colors.lightgray, fg = colors.white},
      z = {bg = colors.gray, fg = colors.black},
    },
    inactive = {
      a = {bg = colors.BlackBGsoft, fg = colors.gray, gui = 'bold'},
      b = {bg = colors.darkgray, fg = colors.gray},
      c = {bg = colors.darkgray, fg = colors.gray}
    }
  }
end -- ▲


local lualine_highlight = require'lualine.highlight'

-- from: https://github.com/Slotos/vimrc/blob/do-05-upgrade/lua/settings/lualine.lua
local function tabs_formatting_withIcon( fname, context )
  local win_handle = vim.api.nvim_tabpage_get_win(context.tabId)
  local buf_handle = vim.api.nvim_win_get_buf(win_handle)

  -- sequential tab number
  -- local status = {'' .. context.tabnr .. '.'}
  local status = {}

  -- devicon (extremely hacky, and definitely slow, but with lualine
  --          not exposing handy highlight caching functions, I'll need
  --          to deal with caching myself, but I'm lazy and this too shall pass)
  local filename = vim.fn.expand('#'..buf_handle..':t')
  local filetype = vim.api.nvim_buf_get_option(buf_handle, 'filetype')
  local extension = vim.fn.expand('#'..buf_handle..':e')
  local devicon, fg, devhl = getDevIcon(filename, filetype, extension)
  if devicon then
    local h = require'utils.color_helpers'
    local tab_hlgroup = lualine_highlight.component_format_highlight(context.highlights[(context.current and 'active' or 'inactive')])
    local bg = h.extract_highlight_colors(tab_hlgroup:sub(3, -2), 'bg')

    -- can't use this due to a bug - https://github.com/nvim-lualine/lualine.nvim/pull/677
    -- one day I will figure out why tests fail on master for me locally (probably they load local config, saw that in other places)
    -- and I will get that code covered and merged; meanwhile, deal with it Gordian knot style
    -- local highlight = lualine_highlight.create_component_highlight_group({fg = fg, bg = bg}, "", context, false)

    local hl = h.create_component_highlight_group({bg = bg, fg = fg}, "local_" .. devhl .. "_tab_" .. (context.current and 'active' or 'inactive'))
    table.insert(
      status,
      -- '%#' .. hl .. '#' .. devicon .. tab_hlgroup
      {highlight = "%#" .. hl .. "#", text = devicon .. " "}
    )
  end

  local name, _ = table.unpack( vim.fn.split( fname, [[\.]] ) )

  -- table.insert(status, {text = context.tabId .. " " .. name})
  table.insert(status, {text = name})

  -- modified and modifiable symbols
  -- if vim.api.nvim_buf_get_option(buf_handle, 'modified') then table.insert(status, {text = ' \u{f448} '}) end
  -- if not vim.api.nvim_buf_get_option(buf_handle, 'modifiable') then table.insert(status, {text = ' \u{e672} '}) end

  return status
end


-- ─   Config                                           ──


local neo_tree = { sections = { lualine_a = {'mode'} }, filetypes = {'neo-tree'} }


local lualine_config = {

  options = {
    icons_enabled = true,
    section_separators = "",
    component_separators = "",
    disabled_filetypes = {
      -- statusline = {'purescript_scratch'},
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
    theme = grbox1,
    -- theme = 'auto',
  },


-- ─   Sections                                         ──

  sections = {
    lualine_a = { 'ProjectRootFolderName' },
    lualine_b = { 'CurrentRelativeFilePath' },
    lualine_c = {},
    lualine_x = { search_result, { 'diff', source = git_diff_changeCount } },
    -- lualine_y = { "lsp_progress", "g:metals_status", 'vim.fn.line(".")' },
    lualine_y = { 'vim.fn.line(".")' },
    lualine_z = { 'LightlineScrollbar' },
  },
  inactive_sections = {
    lualine_a = { 'LightlineLocalRootFolder' },
    lualine_b = { 'LightlineRelativeFilePathOfWin' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },



-- ─   Tabline                                          ──

  -- tabline = {},
  tabline = {

    lualine_a = {
      {
        'tabs',
        mode = 1,
        icons_enabled = true, -- Enables the display of icons alongside the component.
        max_length = vim.o.columns, -- Maximum width of tabs component.

        colored = true,   -- Displays filetype icon in color if set to true
        icon_only = true, -- Display only an icon for filetype
        icon = {
          use_default = true,
          align = 'right',
        }, -- Display filetype icon on the right hand side

        tabs_color = {
          -- Same values as the general color option can be used here.
          active = 'lualine_a_normal',     -- Color for active tab.
          inactive = 'lualine_a_inactive', -- Color for inactive tab.
        },

        -- fmt = function(filename, context)
        --   -- Show + if buffer is modified in tab
        --   -- local buflist = vim.fn.tabpagebuflist(context.tabnr)
        --   -- local winnr = vim.fn.tabpagewinnr(context.tabnr)
        --   -- local bufnr = buflist[winnr]
        --   -- local mod = vim.fn.getbufvar(bufnr, '&mod')
        --   local name, ext = table.unpack( vim.fn.split( filename, [[\.]] ) )
        --   local icon = require("nvim-web-devicons").get_icon_by_filetype( ext )
        --   -- return name .. " " .. icon
        --   return (icon or "") .. " " .. name
        -- end,

        fmt = tabs_formatting_withIcon,

      }
    },

    -- lualine_a = {
    --   {
    --     'tabs',
    --     max_length = vim.o.columns,
    --     mode = 2,
    --     icons_enabled = true,
    --     modification_icons_enabled = true,
    --     icon = {
    --       align = 'right',
    --       use_default = true
    --     },
    --   }
    -- },

    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "lsp_progress", "g:metals_status" },
    lualine_z = {}
  },


-- ─   Winbar                                           ──

  -- winbar = {},
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "LspSymbolsStack()" },
    lualine_z = { 'filename' }
  },

  -- inactive_winbar = {},
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "LspSymbolsStack_inactive()" },
    lualine_z = {'filename'},
  },


-- ─   Extensions                                       ──

  extensions = { 'quickfix', 'fugitive', 'trouble', neo_tree }

}


require('lualine').setup( lualine_config )


