

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
      modified = gitsigns.added + gitsigns.changed + gitsigns.removed,
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
  }
  return {
    normal = {
      a = {bg = colors.gray, fg = colors.black, gui = 'bold'},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.darkgray, fg = colors.gray}
    },
    insert = {
      a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.lightgray, fg = colors.white}
    },
    visual = {
      a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.inactivegray, fg = colors.black}
    },
    replace = {
      a = {bg = colors.red, fg = colors.black, gui = 'bold'},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.black, fg = colors.white}
    },
    command = {
      a = {bg = colors.green, fg = colors.black, gui = 'bold'},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.inactivegray, fg = colors.black}
    },
    inactive = {
      a = {bg = colors.darkgray, fg = colors.gray, gui = 'bold'},
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
    -- theme = grbox,
  },

  sections = {
    lualine_a = { 'ProjectRootFolderName' },
    lualine_b = { 'CurrentRelativeFilePath' },
    lualine_c = {},
    lualine_x = { {'diff', source = git_diff_changeCount} },
    lualine_y = { '%3p' },
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

  tabline = {},

  winbar = {},
  inactive_winbar = {},

  extensions = { 'quickfix', 'fugitive', 'trouble', neo_tree }

}





