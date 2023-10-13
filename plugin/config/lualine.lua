

-- ─   Helpers                                          ──

local function hello()
  return "hello"
end

local function git_diff_changeCount()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      -- added = gitsigns.added,
      -- modified = gitsigns.changed,
      -- removed = gitsigns.removed,
      -- Have only one number to indicate the amount of change in the file.
      added = gitsigns.added + gitsigns.changed + gitsigns.removed,
    }
  end
end

local function grbox()
  local colors = {
    black        = '#282828',
    white        = '#ebdbb2',
    red          = '#fb4934',
    green        = '#b8bb26',
    blue         = '#83a598',
    yellow       = '#fe8019',
    gray         = '#a89984',
    darkgray     = '#3c3836',
    lightgray    = '#504945',
    inactivegray = '#7c6f64',
    BlackBGsoft  = '#101010',
  }
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
end


-- ─   Config                                           ──

local neo_tree = { sections = { lualine_a = {'mode'} }, filetypes = {'neo-tree'} }


require('lualine').setup {

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
    theme = grbox,
    -- theme = 'auto',
  },

  sections = {
    lualine_a = { 'ProjectRootFolderName' },
    lualine_b = { 'CurrentRelativeFilePath' },
    lualine_c = {},
    lualine_x = { {'diff', source = git_diff_changeCount} },
    lualine_y = { "g:metals_status", 'vim.fn.line(".")' },
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

  -- tabline = {},
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2,
        max_length = vim.o.columns / 1.2, -- Maximum width of tabs component.
        tabs_color = {
          -- Same values as the general color option can be used here.
          active = 'lualine_a_normal',     -- Color for active tab.
          inactive = 'lualine_a_inactive', -- Color for inactive tab.
        },
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },

  winbar = {},
  -- winbar = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {'filename'},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {}
  -- },

  inactive_winbar = {},
  -- inactive_winbar = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {'filename'},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {}
  -- },

  -- extensions = { 'quickfix', 'fugitive', 'trouble', neo_tree }

}


