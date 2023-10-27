
local f = require 'utils.functional'
local fun = require 'utils.fun'
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


function _G.Status_filename_noExtension( filename )
  local name, _ = table.unpack( vim.fn.split( filename, [[\.]] ) )
  return name
end

function _G.Status_icon_with_hl( filename )
end

-- ~/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala/com/softwaremill/realworld/articles/comments/api/CommentCreateRequest.scala
-- ~/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala/com/softwaremill/realworld/articles/comments/CommentAuthor.scala
-- ~/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala/com/softwaremill/realworld/articles/core/ArticleAuthor.scala

-- ~/Documents/Proj/_repos/8_zio_skunk_tradeIO/modules/core/src/main/scala/tradex/domain/api/common/ErrorInfo.scala
-- ~/Documents/Proj/_repos/8_zio_skunk_tradeIO/modules/core/src/main/scala/tradex/domain/api/endpoints/TradingServerEndpoints.scala
-- ~/Documents/Proj/_repos/8_zio_skunk_tradeIO/modules/core/src/main/scala/tradex/domain/api/common/CustomDecodeFailureHandler.scala
-- ~/Documents/Proj/_repos/8_zio_skunk_tradeIO/modules/core/src/main/scala/tradex/domain/service/live/FrontOfficeOrderParsingServiceLive.scala


-- -- it might be just one file in 2 wins - then show that filename

-- mixed type workspaces
-- if its an additional .md / sql / vim / docker / sbt file then add an additonal icon

-- Main Filename or lsp / function

function _G.Status_shortenFilename( filename )
  if #filename < 7 then return filename end

  -- Split the filename into components
  local components = {}
  for component in string.gmatch(filename, "([A-Z]?[a-z]+)") do
    table.insert(components, component)
  end

  -- Reduce each component to three or four representative characters and capitalize the first letter
  local shortenedComponents = {}
  for idx, component in ipairs(components) do
    local shortenedComponent = string.sub(component, 1, 4)
    if idx > 1 then
      shortenedComponent = string.upper(shortenedComponent:sub(1,1)) .. shortenedComponent:sub(2)
    end
    table.insert(shortenedComponents, shortenedComponent)
  end

  -- Reassemble the shortened components in camelCase
  local shortenedFilename = table.concat(shortenedComponents, "")

  -- If many components are involved, some components can be omitted in the result
  if #shortenedComponents > 3 then
    shortenedFilename = shortenedComponents[1] .. shortenedComponents[2] .. shortenedComponents[#shortenedComponents]
  end

  return shortenedFilename
end

-- string.gmatch("README", "([A-Z]?[a-z]*)")
-- Status_shortenFilename( "README" )
-- Status_shortenFilename( "NewBuf-direction-maps" )
-- Status_shortenFilename( "NewBuf-direction" )
-- Status_shortenFilename( "NewerBufferMapping" )
-- Status_shortenFilename( "FrontOfficeOrderParsingServiceLive" )
-- Status_shortenFilename( "CustomDecodeFailureHandler" )
-- Status_shortenFilename( "vim_works" )

-- Get the CWD of the first window in a tab
function _G.Tab_getCwd( tabid )
  local firstWinId = vim.api.nvim_tabpage_list_wins( tabid )[1]
  local tabNum = vim.api.nvim_tabpage_get_number( tabid )
  return vim.fn.getcwd( firstWinId, tabNum )
end
-- Tab_getCwd( 3 )


function _G.Status_icon_with_hl( filename )
  -- let icon, color = get_icon_color( filename )
end


function _G.FileNamesInTabHandle_( tab_handle )
  local win_buf_ids = fun.map( function(winid)
    return { wid = winid, bid = vim.api.nvim_win_get_buf( winid ) }
  end, vim.api.nvim_tabpage_list_wins( tab_handle ) )

  win_buf_ids = fun.filter( function(win)
    return vim.fn.win_gettype(win.wid) == ""
  end, win_buf_ids )

  local bufnames = fun.map( function(win)
    return vim.api.nvim_buf_get_name( win.bid )
  end, win_buf_ids)

  return vim.tbl_keys( fun.totable( bufnames ) )
end


local uniqueVals = function( acc, v )
  return vim.tbl_contains(acc, v)
    and acc
    or vim.list_extend(acc, {v})
end

function _G.FilesInTab( tabid )
  return vim.iter( vim.api.nvim_tabpage_list_wins( tabid ) )
    :map( function(winid)
      return { wid = winid, bid = vim.api.nvim_win_get_buf( winid ) }
    end)
    :filter( function(win)
      return     vim.fn.win_gettype(win.wid) == ""
        and vim.bo[win.bid].buftype == ""
        -- Allow only normal windows and normal buftypes.
    end)
    :map( function(win)
      return { fname = vim.api.nvim_buf_get_name( win.bid ), bufid = win.bid }
    end)
    :fold( {}, uniqueVals )
end

-- FilesInTab( vim.api.nvim_get_current_tabpage() )
-- FilesInTab( vim.api.nvim_list_tabpages()[ 1 ] )

function _G.FileNamesInTabNumber( tab_number )
  return vim.tbl_filter( function(fname) return "" ~= fname end,
    vim.tbl_map( function(bufid)
      return vim.api.nvim_buf_get_name( bufid )
    end, vim.fn.tabpagebuflist( tab_number ) )
  )
end

-- FileNamesInTabNumber( vim.fn.tabpagenr() )
-- FileNamesInTabNumber( 2 )
-- FileNamesInTabNumber( vim.api.nvim_tabpage_get_number( vim.api.nvim_get_current_tabpage() ) )
-- 
-- vim.bo[0].buftype
-- vim.bo[28].buftype

-- icon (no color) plus fileName (no extension)
function _G.Status_fileNameToIconPlusName( bufid )
  local buf_name = vim.fn.fnamemodify( ( vim.api.nvim_buf_get_name( bufid ) ), ':t' )
  local name, fext = table.unpack( vim.fn.split( buf_name, [[\.]] ) )
  if fext == nil then
    return name
  else
    local icon, _ = devicons.get_icon( buf_name )
    if icon == nil then
      return buf_name
    else
      return icon .. " " .. name
    end
  end
end

-- Status_fileNameToIconPlusName( "abc.de" )
-- Status_fileNameToIconPlusName( "abc" )


function _G.Status_git_diff_changeCount()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns and gitsigns.added then
    return {
      added = 0,
      removed = 0,
      -- Have only one number to indicate the amount of change in the file.
      modified = gitsigns.added + gitsigns.changed + gitsigns.removed,
    }
  end
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













