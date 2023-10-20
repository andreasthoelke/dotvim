
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


function _G.Status_search_result()
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


-- ─   Tabs custom formatting                           ──

local lualine_highlight = require'lualine.highlight'

-- from: https://github.com/Slotos/vimrc/blob/do-05-upgrade/lua/settings/lualine.lua
function _G.tabs_formatting_withIcon( fname, context )
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


-- _G.WeatherStatus = ''
-- -- WeatherStatus
-- local function update_weather()
--   _G.WeatherStatus = vim.trim(vim.fn.system([[curl -s wttr.in/Berlin\?format=3]]))
-- end
-- if _G.Update_weather_timer == nil then
--   _G.Update_weather_timer = vim.loop.new_timer()
-- else
--   _G.Update_weather_timer:stop()
-- end
-- _G.Update_weather_timer:start(0,             -- never timeout
--                              10*60*1000,          -- repeat every 10 minutes
--                              vim.schedule_wrap(update_weather))

-- note that this path is not relative when in an inactive window.
function _G.ShortenedFilePath()
  local fpath = vim.fn.pathshorten( vim.fn.fnamemodify( vim.fn.expand("%"), ":~:."),
    2
  )
  -- return fpath
  return vim.fn.substitute( fpath, "/", " ", "g" )
end


-- ─   Custom filetype                                  ──

local component = require('lualine.component')

function _G.Status_filename_icon()
  local icon, icon_highlight_group = devicons.get_icon( vim.fn.expand('%:t') )
  local h = require'utils.color_helpers'
  local highlight_color = h.extract_highlight_colors(icon_highlight_group, 'fg')
  return icon
end

-- Status_filename_icon()













