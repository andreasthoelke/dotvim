
-- local Path = require('plenary.path')
-- print( Path:new(vim.fn.stdpath('data'), 'sessions1') )

local M = {}
local api = vim.api

function M.makeScratch()
  api.nvim_command('enew') -- equivalent to :enew
  -- vim.bo[0].buftype=nofile -- set the current buffer's (buffer 0) buftype to nofile
  -- vim.bo[0].bufhidden=hide
  vim.bo[0].swapfile=false
end


-- lua put( require'utils_general'.abc() )
function M.abc()
  return 'hi 5 there'
end

-- print('hi from utils-general')

function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

function _G.floatWinShow(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  vim.lsp.util.open_floating_preview(table.concat(objects, '\n'))
  return ...
end

function M.floatWinShow(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  vim.lsp.util.open_floating_preview(table.concat(objects, '\n'))
  return ...
end

function _G.stline()
  local filepath = '%f'
  local align_section = '%='
  local percentage_through_file = '%p%%'
  return string.format(
      '%s%s%s',
      filepath,
      align_section,
      percentage_through_file
  )
end

local my_make_entry = {}

local devicons = require"nvim-web-devicons"
local entry_display = require("telescope.pickers.entry_display")

local filter = vim.tbl_filter
local map = vim.tbl_map

function my_make_entry.gen_from_buffer_like_leaderf(opts)
  opts = opts or {}
  local default_icons, _ = devicons.get_icon("file", "", {default = true})

  local bufnrs = filter(function(b)
    return 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  local max_bufnr = math.max(unpack(bufnrs))
  local bufnr_width = #tostring(max_bufnr)

  local max_bufname = math.max(
    unpack(
      map(function(bufnr)
        return vim.fn.strdisplaywidth(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t"))
      end, bufnrs)
    )
  )

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = bufnr_width },
      { width = 4 },
      { width = vim.fn.strwidth(default_icons) },
      { width = max_bufname },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      {entry.bufnr, "TelescopeResultsNumber"},
      {entry.indicator, "TelescopeResultsComment"},
      {entry.devicons, entry.devicons_highlight},
      entry.file_name,
      {entry.dir_name, "Comment"}
    }
  end

  return function(entry)
    local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local changed = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. changed

    -- local dir_name = vim.fn.fnamemodify(bufname, ":p:h")
    -- TODO: how to show a relative path?
    local dir_name = vim.fn.fnamemodify(bufname, ":h")
    local file_name = vim.fn.fnamemodify(bufname, ":p:t")

    local icons, highlight = devicons.get_icon(bufname, string.match(bufname, "%a+$"), { default = true })

    -- TODO this has a specific return shape for builtin.buffers field. find which shape 'oldfiles' expects.
    return {
      valid = true,

      value = bufname,
      ordinal = entry.bufnr .. " : " .. file_name,
      display = make_display,

      bufnr = entry.bufnr,

      lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1,
      indicator = indicator,
      devicons = icons,
      devicons_highlight = highlight,

      file_name = file_name,
      dir_name = dir_name,
    }
  end
end

-- doesn't work
function M.fileView1()
  local actions_state = require("telescope.actions.state")

  local opts = {
    attach_mappings = function(prompt_bufnr, map)
      local entry = actions_state.get_selected_entry()
      require("telescope.actions.set").selected:replace( function()
        put( entry )
      end
      )
    end
  }
  require("telescope.builtin").find_files(opts)
end
-- lua put( require'utils_general'.fileView1() )


function M.fileView()
  require("telescope.builtin").buffers({
    entry_maker = my_make_entry.gen_from_buffer_like_leaderf(),
  })
end

function M.fileViewB()
  require("telescope").extensions.file_browser({ previewer = true } )
end


return M













