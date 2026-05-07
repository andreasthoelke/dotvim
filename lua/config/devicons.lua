local M = {}

local function copy_icon(icon)
  return vim.tbl_extend("force", {}, icon)
end

function M.setup()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return
  end

  -- local quiet_icon_color = "#9aa7ab"
  local quiet_icon_color = "#668793"
  local quiet_icon_color_sepcial = "#6b9ea6"
  local quiet_icon_cterm_color = "245"

  -- The upstream YAML glyph can render as a missing-character box in some
  -- Nerd Font versions. Use the older generic file icon used elsewhere here.
  local yaml_icon = {
    icon = "",
    color = quiet_icon_color_sepcial,
    cterm_color = quiet_icon_cterm_color,
    name = "Yaml",
  }
  local yml_icon = copy_icon(yaml_icon)
  yml_icon.name = "Yml"

  local markdown_icon = {
    icon = "",
    color = quiet_icon_color,
    cterm_color = quiet_icon_cterm_color,
    name = "Markdown",
  }
  local md_icon = {
    icon = "",
    color = quiet_icon_color,
    cterm_color = quiet_icon_cterm_color,
    name = "Md",
  }

  local astro_icon = {
    icon = "⩔",
    color = quiet_icon_color,
    cterm_color = quiet_icon_cterm_color,
    name = "Astro",
  }

  local prettier_config_icon = {
    icon = "⚙",
    color = "#f1e05a",
    cterm_color = "185",
    name = "PrettierConfig",
  }

  local overrides = {
    astro = astro_icon,
    markdown = markdown_icon,
    md = md_icon,
    yaml = yaml_icon,
    yml = yml_icon,
    [".prettierrc.js"] = prettier_config_icon,
  }

  if devicons.has_loaded and not devicons.has_loaded() then
    devicons.setup({
      override = overrides,
      override_by_extension = {
        astro = astro_icon,
        markdown = markdown_icon,
        md = md_icon,
        yaml = yaml_icon,
        yml = yml_icon,
      },
      override_by_filename = {
        [".prettierrc.js"] = prettier_config_icon,
      },
    })
  else
    devicons.set_icon(overrides)
  end
end

return M
