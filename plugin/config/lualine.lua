


vim.o.showtabline = 2


local function Theme_grbox2()
  return {
    normal = { a = 'LuLine_a', b = 'LuLine_b', c = 'LuLine_c', x = 'LuLine_x', y = 'LuLine_y', z = 'LuLine_z', },
    inactive = { a = 'LuLine_a_i', b = 'LuLine_b_i', c = 'LuLine_c_i', x = 'LuLine_x_i', y = 'LuLine_y_i', z = 'LuLine_z_i', }
  }
end

-- ─   Helpers                                          ──


local function fname_noExt()
  return vim.fn.expand( '%:t:r' )
end

-- Return line number only for normal buffer types, else return empty string.
local function lineNum()
  local buftype = vim.bo.buftype
  if buftype == "" then
    return vim.fn.line('.')
  end
  return ''
end

local function inactiveWinbarColor()
  local buftype = vim.bo.buftype
  if buftype == "" then
    return 'LuLine_Winbar_b_in'
  end
  return 'LuLine_c'
end


local virtual_env = function()
  -- only show virtual env for Python
  if vim.bo.filetype ~= 'python' then
    return ""
  end
  local conda_env = os.getenv('CONDA_DEFAULT_ENV')
  local venv_path = os.getenv('VIRTUAL_ENV')
  local poetry_venv_path = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h') .. '/.venv'
  if venv_path == nil then
    if conda_env == nil and vim.fn.isdirectory(poetry_venv_path) == 0 then
      return ""
    elseif vim.fn.isdirectory(poetry_venv_path) == 1 then
      -- local venv_name = vim.fn.fnamemodify(poetry_venv_path, ':t')
      -- return string.format("%s ", venv_name)
      return ""
    else
      return string.format("%s co", conda_env)
    end
  else
    local venv_name = vim.fn.fnamemodify(venv_path, ':t')
    return string.format("%s ", venv_name)
  end
end

-- os.getenv('VIRTUAL_ENV')
-- os.getenv('CONDA_DEFAULT_ENV')
-- vim.fn.system("poetry env info -p 2>/dev/null")
-- vim.fn.isdirectory( vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h') .. '/.venv' )
-- require"nvim-web-devicons".get_icon("file", "", {default = true})
-- require"nvim-web-devicons".get_icon("scala")
-- require"nvim-web-devicons".get_icon("toml")


-- ─   Custom filetype with icon                         ■


local lualine_require = require('lualine_require')
local modules = lualine_require.lazy_require {
  highlight = 'lualine.highlight',
  utils = 'lualine.utils.utils',
}


local custom_ftype = require('lualine.components.filetype'):extend()


function custom_ftype:apply_icon()
  if not self.options.icons_enabled then
    return
  end

  local icon, icon_highlight_group
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if ok then
    icon, icon_highlight_group = devicons.get_icon(vim.fn.expand('%:t'))
    if icon == nil then
      icon, icon_highlight_group = devicons.get_icon_by_filetype(vim.bo.filetype)
    end

    if icon == nil and icon_highlight_group == nil then
      icon = ''
      icon_highlight_group = 'DevIconDefault'
    end
    if self.options.colored then
      local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, 'fg')
      if highlight_color then
        local default_highlight = self:get_default_hl()
        local icon_highlight = self.icon_hl_cache[highlight_color]
        if not icon_highlight or not modules.highlight.highlight_exists(icon_highlight.name .. '_normal') then
          icon_highlight = self:create_hl({ fg = highlight_color }, icon_highlight_group)
          self.icon_hl_cache[highlight_color] = icon_highlight
        end

        icon = self:format_hl(icon_highlight) .. icon .. default_highlight
      end
    end
  else
    ok = vim.fn.exists('*WebDevIconsGetFileTypeSymbol')
    if ok ~= 0 then
      icon = vim.fn.WebDevIconsGetFileTypeSymbol()
    end
  end

  if not icon then
    return
  end

  if self.options.icon_only then
    self.status = icon
  elseif type(self.options.icon) == 'table' and self.options.icon.align == 'right' then
    self.status = self.status .. ' ' .. icon
  else
    -- NOTE apply_icon is a literal copy, I only changed to show the filename instead of the extension (which resided in self.status)
    self.status = icon .. ' ' .. vim.fn.expand('%:t:r')
  end
end


-- ─^  Custom filetype with icon                         ▲




-- ─   neo tree extension                               ──

local neo_tree = {
  sections = {
    lualine_a = {
      {
        'LightlineLocalRootFolder',
        separator = { left = '', right = '' },
      }
    },
    lualine_c = { 'AlternateFileLoc_info' },
  },
  winbar = {
    lualine_a = {
      { 'Rpi_normal1', color = 'LuLine_c' }, { 'Rpi_cwd1' },
      { 'Rpi_normal2', color = 'LuLine_c' }, { 'Rpi_troot', color = 'LuLine_b' },
      { 'Rpi_normal3', color = 'LuLine_c' }, { 'Rpi_cwd2' },
      { function() return " " end, color = 'LuLine_c' }
    }
  },
  filetypes = { 'neo-tree', 'dirvish' }
}


-- ─   Config                                           ──

local lualine_config = {

  options = {
    icons_enabled = true,
    section_separators = "",
    -- section_separators = { left = '', right = '' },
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
    theme = Theme_grbox2,
    -- theme = 'auto',
  },


-- ─   Sections                                         ──

  sections = {
    lualine_a = {
      {
        'LightlineLocalRootFolder',
        separator = { left = '' },
      }
    },
    lualine_b = { 'CurrentRelativeFolderPath_shorten' },
    lualine_c = { custom_ftype },
    lualine_x = {
      {
        'diff',
        source = function() return _G.Status_git_diff_changeCount() end,
      },
      { "lsp_progress" },
      { "g:metals_status" },
      virtual_env,
    },
    lualine_y = { lineNum },
    lualine_z = { 'LightlineScrollbar' },
  },
  inactive_sections = {
    lualine_a = {
      {
        'LightlineLocalRootFolder',
        separator = { left = '' },
      }
    },
    lualine_b = {
      'CurrentRelativeFolderPath_shorten',
      {
        custom_ftype,
        separator = { right = '' },
      }
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { lineNum },
    -- lualine_y = {},
    lualine_z = {}
  },



-- ─   Tabline                                           ■

  tabline = {},
  -- tabline = {

  --   lualine_a = {
  --     {
  --       'tabs',
  --       mode = 1,
  --       icons_enabled = true, -- Enables the display of icons alongside the component.
  --       max_length = vim.o.columns, -- Maximum width of tabs component.

  --       colored = true,   -- Displays filetype icon in color if set to true
  --       icon_only = true, -- Display only an icon for filetype
  --       icon = {
  --         use_default = true,
  --         align = 'right',
  --       }, -- Display filetype icon on the right hand side

  --       tabs_color = {
  --         active   = 'LuLine_Tabs_ac',
  --         inactive = 'LuLine_Tabs_in',
  --         -- NOTE i could highlight inactive depending on e.g. their type?
  --         -- active   = Tabs_active,
  --         -- inactive = Tabs_inactive,
  --       },

  --       -- fmt = function(filename, context)
  --       --   -- Show + if buffer is modified in tab
  --       --   -- local buflist = vim.fn.tabpagebuflist(context.tabnr)
  --       --   -- local winnr = vim.fn.tabpagewinnr(context.tabnr)
  --       --   -- local bufnr = buflist[winnr]
  --       --   -- local mod = vim.fn.getbufvar(bufnr, '&mod')
  --       --   local name, ext = table.unpack( vim.fn.split( filename, [[\.]] ) )
  --       --   local icon = require("nvim-web-devicons").get_icon_by_filetype( ext )
  --       --   -- return name .. " " .. icon
  --       --   return (icon or "") .. " " .. name
  --       -- end,

  --       fmt = function (fname, context) return _G.tabs_formatting_withIcon(fname, context) end,

  --     }
  --   },

  --   -- lualine_a = {
  --   --   {
  --   --     'tabs',
  --   --     max_length = vim.o.columns,
  --   --     mode = 2,
  --   --     icons_enabled = true,
  --   --     modification_icons_enabled = true,
  --   --     icon = {
  --   --       align = 'right',
  --   --       use_default = true
  --   --     },
  --   --   }
  --   -- },

  --   lualine_c = {},
  --   lualine_b = {},
  --   lualine_x = {},
  --   lualine_y = { "lsp_progress", "g:metals_status" },
  --   -- lualine_z = { function () return _G.WeatherStatus end },
  --   lualine_z = {},
  --   -- lualine_z = {}
  -- },


-- ─^  Tabline                                           ▲


-- ─   Winbar                                           ──

  -- winbar = {},
  winbar = {
    lualine_a = {
      {
        custom_ftype,
        separator = { left = '', right = '' },
      }
    },
    lualine_b = {
      {
        'LspSymbolsStack()',
        color = 'LuLine_Winbar_b_in'
      }
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    -- lualine_y = {
    --   "LspSymbolsStack()",
    --   -- color = 'LuLine_Winbar_y_ac',
    -- },
    lualine_z = {},
    -- lualine_z = {
    --   {
    --     fname_noExt,
    --     color = 'LuLine_Winbar_z_ac',
    --   }
    -- }
  },

  -- inactive_winbar = {},
  inactive_winbar = {
    lualine_a = {
      {
        custom_ftype,
        separator = { left = '', right = '' },
      }
    },
    lualine_b = {
      {
        'LspSymbolsStack_inactive()',
        color = inactiveWinbarColor
      }
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },


-- ─   Extensions                                       ──

  extensions = { 'quickfix', 'fugitive', 'trouble', neo_tree }

}


require('lualine').setup( lualine_config )


