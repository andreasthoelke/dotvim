

local function hello()
  return "hello"
end

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
    lualine_x = { 'diff' },
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



