

-- ─   Helpers                                          ──

local function hello()
  return "hello"
end

local function diff_source()
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
    }
  },

  sections = {
    lualine_a = { 'ProjectRootFolderName' },
    lualine_b = { 'CurrentRelativeFilePath' },
    lualine_c = {},
    lualine_x = { {'diff', source = diff_source} },
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



