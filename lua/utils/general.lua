
local f = require 'utils.functional'
local fun = require 'utils.fun'
local action_state = require "telescope.actions.state"



local M = {}
local api = vim.api

-- print( require'plenary.path':new(vim.fn.stdpath('data'), 'sessions1', 'abc') )

local test = vim.lsp.buf_request_sync

function M.makeScratch()
  api.nvim_command('enew') -- equivalent to :enew
  -- vim.bo[0].buftype=nofile -- set the current buffer's (buffer 0) buftype to nofile
  -- vim.bo[0].bufhidden=hide
  vim.bo[0].swapfile=false
end

function M.esc(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end
-- require'utils.general'.esc( vim.fn.getcwd() )


function _G.PrintMessages( cnt )
  local hist = require 'notify'.history()
  local recentHist = vim.list_slice( hist, #hist - cnt, #hist )
  local msgsFlat = vim.tbl_flatten( vim.tbl_map( function(el) return el.message end , recentHist ) )
  -- local reversedList = vim.fn.reverse( msgsFlat )
  -- local seperatedList = vim.fn.insert( reversedList, "_ ", 1 )
  local seperatedList = vim.fn.insert( msgsFlat, "_ ", 1 )
  vim.g['floatWin_win'] = vim.fn.FloatingSmallNew( seperatedList )
  vim.wo.wrap = true
  vim.fn.FloatWin_FitWidthHeight()
  vim.fn.Scala_bufferMaps_shared()
  vim.cmd( 'wincmd p' )
end
-- PrintMessages()

-- vim.wo.wrap = true

function _G.LuaModuleName()
  -- Get module name from current file path.
  vim.fs.basename( vim.fn.expand('%:p:t') )
  vim.fs.dirname( vim.fn.expand('%:p') )
  vim.iter( vim.fs.parents( vim.fn.expand('%:p') ) )
  return vim.fn.expand('%:t:r') 
end
-- LuaModuleName()

function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

function _G.iteratorToSting( it )
  local st = ""
  for v in it do
    st = st .. '\n' .. tostring( v )
  end
  return st
end

function _G.printToString( value )
  local pval
  if type( value ) == "function" then
    pval = iteratorToSting( value )
  elseif type( value ) == "number" then
    pval = tostring( value )
  elseif type( value ) == "boolean" then
    pval = tostring( value )
  elseif tostring( value ) == "<generator>" then
    pval = printToString( fun.totable( value ) )
  elseif vim.tbl_get( value, 'param' ) then
    pval = fun.foldl( function( acc, el ) return acc .. '\n' .. el end, "", value )
  elseif vim.tbl_get( value, '_head' ) then
    pval = printToString( value:totable() )
  elseif vim.tbl_get( value, 'next' ) then
    pval = printToString( value:totable() )
  elseif type( value ) == "table" then
    pval = #value .. '\n' .. vim.inspect( value )
  else
    pval = vim.inspect( value )
  end
  return pval
end

function _G.putt( value, title )
  local pval = printToString( value )
  vim.notify( pval, "info", {
    title = title or type( value ),
    timeout = 400000,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, "filetype", "lua")
    end,
  })
end

-- function _G.printTable( table )
--   local output = ""
--   for key, value in pairs( table ) do
--     -- add value to output
--     output = output .. key .. ": " .. value .. "\n"
--   end
--   vim.print(output)
-- end



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


function M.Tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


-- -- filtering the vim bufferlist
-- vim.api.nvim_list_bufs() 
-- unpack( vim.api.nvim_list_bufs() )
-- math.max( 4, 8, 1 )
-- math.max( unpack( vim.api.nvim_list_bufs() ) )
-- vim.tbl_filter(function(b) return 1 == vim.fn.buflisted(b) end, vim.api.nvim_list_bufs())
-- vim.fn.fnamemodify(vim.api.nvim_buf_get_name(4), ":p:t")

local my_make_entry = {}
local devicons = require"nvim-web-devicons"
local entry_display = require("telescope.pickers.entry_display")
local actions = require "telescope.actions"

local vfilter = vim.tbl_filter
local vmap = vim.tbl_map

function my_make_entry.gen_from_buffer_like_leaderf(opts)
  opts = opts or {}
  local default_icons, _ = devicons.get_icon("file", "", {default = true})

  local bufnrs = vfilter(function(b)
    return 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  local max_bufnr = math.max(unpack(bufnrs))
  local bufnr_width = #tostring(max_bufnr)

  local max_bufname = math.max(
    unpack(
      vmap(function(bufnr)
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



function M.fileView()
  require("telescope.builtin").buffers({
    entry_maker = my_make_entry.gen_from_buffer_like_leaderf(),
  })
end

-- require'utils.general'.fileView()




local action_set = require('telescope.actions.set')


function M.fileView1()
  local actions_state = require("telescope.actions.state")
  -- local opts = {}
  local opts = {
    attach_mappings = function(prompt_bufnr, map)

    action_set.select:replace( function()
        local entry = actions_state.get_selected_entry()
        -- put( entry )
        vim.pretty_print( entry )
      end
      )
      -- action_set.select:enhance {
      --     post = function()
      --       local selection = action_state.get_selected_entry()
      --       if not selection then
      --         return
      --       end
      --       put( selection )
      --       -- vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
      --     end,
      --   }

        -- replace( function()
        -- local entry = actions_state.get_selected_entry()
        -- put( entry.lnum )
      -- end
      -- )
    return true
    end
  }
  require("telescope.builtin").find_files(opts)
end
-- require'utils.general'.fileView1()



function M.fileViewB()
  require("telescope").extensions.file_browser.file_browser()
end
-- require'utils.general'.fileViewB()


function M.Search_greparg()
  require('telescope').extensions.live_grep_args.live_grep_args({
    -- default_text = [[def\s.*]],
    glob_pattern = scala_interest_files,
    cwd = scala_parent_dir,
    theme = 'dropdown',
  } )
end
-- require'utils.general'.Search_greparg()

-- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
-- https://docs.rs/regex/1.7.0/regex/#syntax



-- Focused search maps with presets/filters


-- use leader sr to reload/source this file!
local scala_parent_dir = '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/'
local scala_comments_rx = [[^(\s*)?(//|\*\s).*]]
local scala_header_rx = [[─.*]]
-- local scala_multilineSignatures = [[(def|extension).*(\n)?.*(\n)?.*(\n)?.*\s=\s]]
local scala_multilineSignatures = [[(def|extension).*=.*\n]]

local scala_patterns_files = {
  'BZioHttp/*_patterns.scala',
  'BZioHttp/utils.scala',
  'AZioHttp/TicTakToe.scala',
}

local scala_interest_files = {
  -- 'BZioHttp/*_patterns.scala',
  -- 'BZioHttp/utils.scala',
  -- 'BZioHttp/wcl_*.scala',
  'BZioHttp/*.scala',
  'AZioHttp/*.scala',
}

function M.Search_collection_full()
  require('telescope.builtin').live_grep({
    cwd = vim.g.FolderSearch_Path,
  } )
end

function M.Search_collection_md_headers()
  require('telescope.builtin').live_grep({
    default_text = "# .*" ,
    cwd = vim.g.FolderSearch_Path,
  } )
end


function M.Search_patternfiles()
  require('telescope.builtin').live_grep({
    glob_pattern = scala_patterns_files,
    cwd = scala_parent_dir,
  } )
end

function M.Search_comments()
  require('telescope.builtin').live_grep({
    default_text = scala_comments_rx,
    glob_pattern = scala_interest_files,
    cwd = scala_parent_dir,
    -- path_display = { "smart" },
  } )
end

function M.Search_headers()
  require('telescope.builtin').live_grep({
    default_text = scala_header_rx,
    glob_pattern = scala_interest_files,
    cwd = scala_parent_dir,
  } )
end

function M.Search_typeSign()
  require('telescope.builtin').live_grep({
    default_text = scala_multilineSignatures,
    glob_pattern = scala_interest_files,
    cwd = scala_parent_dir,
  } )
end


function M.Search_gs()
  require('telescope.builtin').live_grep({
    -- default_text = [[ab]],
    search = "List",
    glob_pattern = scala_interest_files,
    cwd = scala_parent_dir,
  } )
end

-- vim.keymap.set( 'n',
--   '<leader>ga', function() require( 'telescope.builtin' )
--   .current_buffer_fuzzy_find({
--       initial_mode = 'normal',
--       default_text = vim.fn.expand '<cword>'
--     })
--   end )



function _G.Search_gs()
  require('telescope.builtin').live_grep({
    -- default_text = [[ab]],
    search = "List",
    glob_pattern = scala_interest_files,
    cwd = scala_parent_dir,
  } )
end

function _G.Search_mainPatterns( searchScope, pattern, initCursorMode )
  local paths =
    searchScope == 'global'
      and { vim.fn.getcwd( vim.fn.winnr() ), "~/Documents/Notes/" }
      or searchScope == 'file'
         and { vim.fn.expand('%:p') }
         or  { vim.fn.getcwd( vim.fn.winnr() ) }

  if not pattern then
    if searchScope == 'global' then
      pattern = [[^(#|function|m|f\.|local\sfunc|-- ─ |local.*curry|func|comma|" ─ ).*]]
    elseif vim.fn.expand("%:e") == "lua" then
      -- pattern = [[^(function|local\s.*function|-- ─ ).*]]
      -- now including all top level local values. As I dont' know how to search *before* the function keyword (and after it).
      -- NOTE: i should use the lowercase version of capital chars like M and _G, else the typed regex would not be case insensitive
      -- pattern = [[^(#|function|m|f\.|local\sfunc|-- ─ |local.*curry).*]]
      pattern = [[^(#|function|m|f\.|local\s|-- ─ ).*]]
    elseif vim.fn.expand("%:e") == "vim" then
      pattern = [[^(#|.*\*|func|comma|" ─ ).*]]
    else
      pattern = [[(^#|\*).*]]
    end
  end

  Telesc_launch( 'live_grep', {
    initial_mode = initCursorMode or "insert",
    default_text = pattern,
    search_dirs = paths,
  } )

  -- require('telescope.builtin').live_grep({
  --   initial_mode = initCursorMode or "insert",
  --   default_text = pattern,
  --   search_dirs = paths,
  -- })

end
-- TODO: not working on this file: ~/.local/share/nvim/sessions/__Users__at__.config__nvim‖

-- Telesc_launch( 'live_grep', { default_text = 'hi' } )


function _G.Search_ast( pattern )
  require 'telescope'.extensions.ast_grep.ast_grep( Telesc_dynPosOpts_ext( {
    initial_mode = "normal",
    default_text = pattern,
    -- search_dirs = paths,
  }))
end
-- Search_ast( 'if $$$ then $$$ return {$$$} end' )


-- First picker: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md

-- ─   Rgx select picker                                ──

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

function M.Resources(opts)
  opts = opts or {}
  pickers.new {
    results_title = "Resources",
    -- Run an external command and show the results in the finder window
    finder = finders.new_oneshot_job({"terraform", "show"}),
    sorter = sorters.get_fuzzy_file(),
    previewer = previewers.new_buffer_previewer {
      define_preview = function(self, entry, status)
        -- Execute another command using the highlighted entry
        return require('telescope.previewers.utils').job_maker(
          {"terraform", "state", "list", entry.value},
          self.state.bufnr,
          {
            callback = function(bufnr, content)
              if content ~= nil then
                require('telescope.previewers.utils').regex_highlighter(bufnr, 'terraform')
              end
            end,
          })
      end
    },
  }:find()
end



function M.Git_diff_stat(opts)
  opts = opts or {}
  opts.entry_maker = function(entry)
      local split = vim.split(entry, [[|]])
      local rel_filepath = split[1]:gsub("%s+", "")
      local gstat = vim.F.if_nil( split[2], "" ):gsub("%s+", "")
      local abs_filepath = vim.fn.getcwd( vim.fn.winnr() ) .. "/" .. rel_filepath
      -- local wordCount = vim.fn.systemlist( 'wc ' .. abs_filepath .. " | awk '{print $1}'")[1]
      local wc_output = vim.fn.systemlist( "wc " .. abs_filepath .. " | awk {'print $1 \":\" $2'}" )[1]
      local wc_list = vim.split( wc_output, ":" )
      local line_num = tonumber(split[2])
      -- local gstat = vim.fn.systemlist( 'git diff HEAD --stat ' .. entry )[1]
      return {
        -- display = split[1] .. "|" .. split[2] .. "|" .. split[3].. "|" .. split[4]  ,
        value = abs_filepath,
        display = "li:" .. wc_list[1] .. " | wo:" .. wc_list[2] .. " | " .. rel_filepath .. " | " .. gstat,
        ordinal = rel_filepath, -- this is for sorting?
      }
    end

  pickers.new(opts, {
    prompt_title = "git diff --stat",

    finder = finders.new_oneshot_job({
      -- "git", "ls-files", "--exclude-standard", "--cached"
      -- 'git', 'diff', 'HEAD', '--stat'
      'git', 'diff', 'HEAD', '--stat'
    }, opts ),

    sorter = conf.generic_sorter(opts),
    -- previewer = conf.grep_previewer(opts),

    attach_mappings = function( prompt_bufnr )
      actions.select_default:replace(function()
        actions.close( prompt_bufnr )
        local selection = action_state.get_selected_entry()
        vim.pretty_print( selection )
      end)
      return true
    end,

  }):find()
end
-- require('utils.general').Git_diff_stat()



-- our picker function: colors
-- local colors = function(opts)
function M.Colors(opts)
  -- opts = opts or {}
  opts = {
    -- This is a working example of a custom entry_maker
    -- the arg "entry" is a line of text from the shell command in this case
    entry_maker = function(entry)
      local split = vim.split(entry, ":")
      local rel_filepath = split[1]
      local abs_filepath = vim.fn.getcwd( vim.fn.winnr() ) .. "/" .. rel_filepath
      local line_num = tonumber(split[2])
      return {
        value = 43,
        display = split[1] .. "|" .. split[2] .. "|" .. split[3].. "|" .. split[4]  ,
        ordinal = 4,
      }

      -- return {
      --   -- value = entry,
      --   value = split[1],
      --   display = function(display_entry)
      --     local hl_group
      --     local display = utils.transform_path({}, display_entry.value)

      --     display, hl_group = utils.transform_devicons(display_entry.path, display, false)

      --     if hl_group then
      --       return display, { { { 1, 3 }, hl_group } }
      --     else
      --       return display
      --     end
      --   end,
      --   ordinal = rel_filepath,
      --   filename = rel_filepath,
      --   path = abs_filepath,
      --   lnum = line_num,
      -- }
    end
    }

  pickers.new(opts, {
    prompt_title = "colors",

    -- finder = finders.new_table {
    --   results = { "red", "green", "blue" }
    -- },

    -- finder = finders.new_table {
    --   results = {
    --     { "red", "#ff0000" },
    --     { "green", "#00ff00" },
    --     { "blue", "#0000ff" },
    --   },
    --   entry_maker = function(entry)
    --     return {
    --       value = entry[0],
    --       display = entry[1],
    --       ordinal = entry[1],
    --     }
    --   end
    -- },

    -- finder = finders.new_oneshot_job({ "rg", "scala" }, opts ),
    finder = finders.new_oneshot_job({
      "rg", "scala", "--line-number", "--column", "--with-filename"
    }, opts ),

    sorter = conf.generic_sorter(opts),
    -- previewer = conf.grep_previewer(opts),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection))
        -- vim.api.nvim_echo({ selection[1] }, "", false, true)
        -- vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,

  }):find()
end

-- require('utils.general').Colors()

-- printing/inspecting a table object!
-- lua print( vim.inspect( vim.fn['bm#all_files']() ) )

-- local action_state = require "telescope.actions.state"

-- local actions1 = {}
-- actions1.do_stuff = function(prompt_bufnr)
--   local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
--   local entry = action_state.get_selected_entry()
-- end

-- local transform_mod = require("telescope.actions.mt").transform_mod

-- local mod = {}
-- mod.a1 = function(prompt_bufnr)
--   -- your code goes here
--   -- You can access the picker/global state as described above in (1).
-- end

-- mod.a2 = function(prompt_bufnr)
--   -- your code goes here
-- end
-- mod = transform_mod(mod)

-- Now the following is possible. This means that actions a2 will be executed
-- after action a1. You can chain as many actions as you want.
-- local action = mod.a1 + mod.a2
-- action(bufnr) 

local make_entry = require "telescope.make_entry"
local tpat = "plugin/*.vim"
-- local scapa = "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/"
local scglo = {
        "-g", "**/AZioHttp/*.md",
        "-g", "**/BZioHttp/*.scala",
}


function M.Concat(t1,t2)
  for i=1,#t2 do
    t1[#t1+1] = t2[i]
  end
  return t1
end

-- TODO: test this
-- rg --sort flag options:
-- none      (Default) Do not sort results. Fastest. Can be multi-threaded.
-- path      Sort by file path. Always single-threaded.
-- modified  Sort by the last modified time on a file. Always single-threaded.
-- accessed  Sort by the last accessed time on a file. Always single-threaded.
-- created   Sort by the creation time on a file. Always single-threaded.

-- require('utils.general').Concat({4,3}, {8, 9})  
-- require('plenary.tbl').apply_defaults( {1, 2}, {4, 5} )
-- vim.fn.join( {3,4}, 1 )
-- vim.g.FolderSearch_Path
-- vim.fn.systemlist( 'git diff HEAD --stat ' )
-- vim.fn..slice({2,3}, 0, 1)
-- {3,4}.1

-- M.abb = {3, 4, 5}
-- require'utils.general'.abb[1]

function _G.FocusLine_Delayed( lineNum )
  local lineCmd = "norm! " .. lineNum .. "gg"
  vim.fn.call( 'T_DelayedCmd', { lineCmd, 100 } )
  vim.fn.call( 'T_DelayedCmd', { "norm! zz", 110 } )
end

function _G.LoadAndFocusLine_Delayed( filePath, lineNum )
  local loadCmd = "edit " .. filePath
  local lineCmd = "norm! " .. lineNum .. "gg"
  -- vim.fn.call( 'T_DelayedCmd', { loadCmd, 2000 } )
  vim.cmd "edit /Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/effect_zio.md"
  -- vim.fn.call( 'T_DelayedCmd', { lineCmd, 800 } )
  -- vim.fn.call( 'T_DelayedCmd', { "norm! zz", 900 } )
end


function M.RgxSelect_Picker(opts, rgx_query, globs, paths)
  opts = opts or {}
  opts.entry_maker = make_entry.gen_from_vimgrep()
  -- opts.default_text = [[def\s.*]]
  local rg_baseArgs = { 'rg',
        rgx_query,
        '--line-number', '--column',
        -- '--with-filename',
        '--multiline', '--case-sensitive',
        -- '--max-depth', "1",
        '--sort', 'accessed', '-L', -- -L = traverse symlinks
        -- '--regexp', 'pcre2'
    }
  local rg_cmd = M.Concat( M.Concat( rg_baseArgs, globs ), paths )

  opts = Telesc_dynPosOpts_ext( opts )
  pickers.new(opts, {
    prompt_title = 'rx sel',
    finder    = finders.new_oneshot_job( rg_cmd, opts ),
    sorter    = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function( prompt_bufnr )
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd.edit( selection.filename )
         -- autocmd BufReadPost * lua require'nvim-tree'.refresh()
        -- workaround, see below
        FocusLine_Delayed( selection.lnum )
        -- LoadAndFocusLine_Delayed( selection.filename, selection.lnum )
        -- vim.pretty_print( selection )
      end)
      return true
    end,
  }):find()
end
-- ISSUE: -- i tried these to prevent "invlid buffer id" of first load
-- local bufid = vim.fn.bufadd( selection.filename )
--   vim.api.nvim_win_set_cursor( winHand, { selection.lnum, 0 })
--   vim.cmd "norm! zz"
-- vim.fn.bufloaded( bufid )


function M.RgxSelect_Picker_bak(opts, rgx_query, parent_dir, globs)
  opts = opts or {}
  opts.entry_maker = make_entry.gen_from_vimgrep()
  local rg_cmd = M.Concat(
    { "rg",
        rgx_query,
        "--line-number", "--column", "--with-filename",
        "--multiline", "--case-sensitive",
        parent_dir,
    }, globs )

  pickers.new(opts, {
    prompt_title = "rx sel",
    finder = finders.new_oneshot_job( rg_cmd, opts ),
    sorter = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection))
        -- vim.api.nvim_echo({ selection[1] }, "", false, true)
        -- vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,
  }):find()
end

function M.RgxSelect_Picker_testPaths(opts, rgx_query, globs)
  opts = opts or {}
  opts.entry_maker = make_entry.gen_from_vimgrep()
  local rg_cmd =
  -- CONCLUSION: i can search in multiple paths. i can have multiple globs, but they all search in all paths; i can't
  -- have a glob per path. globs in an abs path with from the command line ~/.config/nvim/notes/rg_test_globs.sh#/#%20this%20seems
  -- but not with this telescope lua syntax!
  -- having one parent dir with multiple sub-folder globs (like -- "-g", "**/AZioHttp/*.scala") almost(!) works; however
  -- a sub-folder glob referring to the current working dir returns no results.
    { "rg",
        rgx_query,
        "--line-number", "--column", "--with-filename",
        "--multiline", "--case-sensitive",
        -- "-g", "*Example.scala",
        "-g", "*s.scala",
        -- "-g", "**/AZioHttp/*.scala",
        -- "-g", "**/BZioHttp/*.scala",
        "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/AZioHttp/",
        "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/",
        -- "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/",
    }

  -- local rg_cmd = M.Concat(
  --   { "rg",
  --       rgx_query,
  --       "--line-number", "--column", "--with-filename",
  --       "--multiline", "--case-sensitive",
  --   }, globs )

  pickers.new(opts, {
    prompt_title = "rx sel",
    finder = finders.new_oneshot_job( rg_cmd, opts ),
    sorter = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection))
        -- vim.api.nvim_echo({ selection[1] }, "", false, true)
        -- vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,
  }):find()
end

local builtin = require("telescope.builtin")



local fwatch = require('fwatch')
M.fwatch_handle = nil

-- Keeps reloading the current window/buffer with the current filepath!
function M.WatchFile_start()
  local filename = vim.fn.expand('%')
  local winID = vim.fn.win_getid()
  vim.pretty_print( filename, winID )
  M.fwatch_handle = fwatch.watch( filename, {
    on_event = function()
      -- WARNING: vim.schedule is needed, else nvim will hand in a lua loop.
      vim.schedule( function ()
        vim.api.nvim_call_function('win_execute', { winID, 'edit' })
      end )
    end
  })
end
-- require('utils.general').WatchFile()
-- vim.api.nvim_get_current_win()
-- vim.fn.win_getid()
-- vim.api.nvim_call_function('win_execute', {1019, 'new'})

-- -- Calling VimScript functions
-- vim.fn.call( 'TestEcho', {'abbc'} )
-- vim.fn.call( 'StripString', {'abbc', 'bb'} )
-- vim.fn.call( 'T_DelayedCmd', {'echo "hi there"', 1000} )

function M.WatchFile_stop()
  fwatch.unwatch( M.fwatch_handle )
  print( 'Stopped watching file!' )
end


vim.keymap.set( 'n',
  '<leader>fw', function() require( 'utils.general' )
  .WatchFile_start()
  end )

vim.keymap.set( 'n',
  '<leader>fW', function() require( 'utils.general' )
  .WatchFile_stop()
  end )


-- ─   Git commits picker                               ──

-- Copies an old version of the file into the project folder using a new unique file name!
-- PATTERN: example of running a shell command on a filename or git commit id.
-- also an example of overriding/replacing an actions that is defined for a default picker.

-- we are replacing select_default the default action, which is mapped to <CR> by default. To do this we need to call actions.select_default:replace and pass in a new function.
-- In this new function we first close the picker with actions.close and then get the selection with action_state

local function GitCopyFileFromCommit_sel_action(prompt_bufnr, map)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local filename = vim.fn.expand('%')
    local filename_root = vim.fn.expand('%:r')
    local filename_extension = vim.fn.expand('%:e')
    local newfilename = filename_root.."_"..selection.value.."."..filename_extension
    -- git show 97853e3:z_patterns.scala > z_patterns_ab.scala
    -- TEMP: debug
    vim.pretty_print( selection )
    -- vim.cmd([[!git show ]]..selection.value.. [[:]]..filename..[[ > ]]..newfilename )
  end)
  return true
end

function M.Git_commits_picker( opts, filepath )
  opts = opts or {}
  opts.attach_mappings = GitCopyFileFromCommit_sel_action
  opts.previewer = {
    previewers.new_termopen_previewer {

      get_command = function(entry)
        return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!', filepath }
      end,

      dyn_title = function(_, entry)
        -- return vim.fn.systemlist( 'git diff HEAD --stat ' .. entry.path )[1]
        return entry.value
      end,

    },
    previewers.git_commit_message.new(opts),
  }

  -- TODO: this doesn't show anything. how to write an entry maker for the git_commits picker?
  -- could use git log --oneline
  -- opts.entry_maker = function(entry)
  --   return {
  --     value = entry.value,
  --     display = entry.value,
  --     ordinal = entry.value
  --   }
  -- end

  builtin.git_commits(opts)
  -- - `<cr>`: checks out the currently selected commit
  -- - `<C-r>m`: resets current branch to selected commit using mixed mode
  -- - `<C-r>s`: resets current branch to selected commit using soft mode
  -- - `<C-r>h`: resets current branch to selected commit using hard mode
end


local opts_1 = { initial_mode = 'normal' }

vim.keymap.set( 'n',
  ',gl', function() require( 'utils.general' )
  .Git_commits_picker( opts_1, vim.fn.expand('%') )
  end )

vim.keymap.set( 'n',
  ',gL', function() require( 'utils.general' )
  .Git_commits_picker( opts_1 )
  end )


-- ─   Keymap picker                                     ■

-- vim.fn.expand('%:p:h')
-- vim.api.nvim_get_keymap('i')
-- vim.api.nvim_exec("verb map <space>vm", true)

function M.IndexOf(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end


function _G.MapInfo(str)
  local mapInfo = vim.api.nvim_get_keymap('n')
  for _, mapping in ipairs(mapInfo) do
    -- print if it contains a string
    if mapping.lhs:find(str) then
      putt(mapping)
      break
    end
  end
end

-- note this has no definition infos!
-- MapInfo("tu")
-- Keymap_props( 'n', '<Space>st')

function _G.Keymap_props( mode, lhs_map_string )
  local cmd = "verbose " .. mode .. "map " .. lhs_map_string
  local propsstr = vim.api.nvim_exec( cmd, true )
  local propsstr_clean = propsstr:gsub("\n", " ")
  local propslist = vim.split( propsstr_clean, " " )
  -- vim.print( propslist )
  -- vim.print( M.IndexOf( propslist, "from" ) )

  -- n  <Space>tu   * <Lua 27185: ~/.config/nvim/plugin/config/tabline_tabby.lua:142>
  -- { "", "n", "", "<Space>tu", "", "", "*", "<Lua", "27185:", "~/.config/nvim/plugin/config/tabline_tabby.lua:142>", "\tLast", "set", "from", "Lua", "line", "4", "n", "", "<Space>t", "", "", "", "*", ":let", "g:opContFn='HsTabu'<CR>:let", "g:opContArgs=[g:pttnsTypeSigs4]<CR>:set", "opfunc=Gen_opfuncAc<CR>g@", "\tLast", "set", "from", "~/.config/nvim/plugin/utils-align.vim", "line", "21" }

  -- lua print(vim.api.nvim_get_keymap('n', '<Space>tu'))


  local fnameVal, lineVal
  local fromVal = propslist[ M.IndexOf( propslist, "from" ) + 1 ]
  if fromVal == "Lua" then
    local luaPath = propslist[ M.IndexOf( propslist, "<Lua" ) + 2 ]
    fnameVal, lineVal = table.unpack( vim.fn.split( luaPath, ":" ) )
    lineVal = lineVal:sub( 1, -2 )
  else
    fnameVal = fromVal
    lineVal = propslist[ M.IndexOf( propslist, "line" ) + 1 ]
  end

  return {
    filename = fnameVal,
    lnum = tonumber( lineVal )
  }
end
-- require('utils.general').Keymap_props("n", "<space>vm")
-- require('utils.general').Keymap_props("n", "gei")
-- vim.api.nvim_exec( "verbose ".."n".."map ".."gei", true )
-- vim.api.nvim_exec( 'verbose nmap gei', true )
-- vim.cmd( "verbose ".."n".."map ".."gei", true )
-- require'telescope.builtin'.live_grep({previewer = require'telescope.previewers'.vim_buffer_vimgrep, highlights = true})
-- require('telescope.config').values.grep_previewer

local function keymap_select_action( prompt_bufnr )
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    -- vim.pretty_print( selection )
    local keymap_props = Keymap_props( selection.mode, selection.lhs )
    -- vim.pretty_print( keymap_props )
    if keymap_props.filename ~= "lua" then
      vim.cmd( "vnew " .. keymap_props.filename )
    end
    if keymap_props.lnum ~= nil then
      vim.api.nvim_win_set_cursor(0, { keymap_props.lnum, 0 })
      vim.cmd "norm! zz"
    end
  end)
  return true
end

-- attach/overwrite an extra picker action map only for this picker/usecase
function M.examp_keymap_picker( opts )
  opts = opts or {}
  opts.attach_mappings = keymap_select_action
  require('telescope.builtin').keymaps( opts )
end

-- require('utils.general').examp_keymap_picker()

-- ─^  Keymap picker                                     ▲


-- ─   more examples                                     ■





function M.buffer_dir()
  return vim.fn.expand "%:p:h"
end

-- require'utils.general'.buffer_dir()
-- vim.api.nvim_win_get_cursor( 0 )
-- vim.api.nvim_win_set_cursor( 0, { 910, 10 } )


local function examp2( prompt_bufnr )
  actions.select_default:replace(function()
    -- actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    -- for key, value in pairs( selection ) do
    --   vim.fn.writefile( value, "output.txt" )
    -- end
    -- print( vim.inspect( selection ) )
    -- vim.fn.writefile( {vim.inspect( selection )}, "output2.txt" )
    -- vim.print( selection )
    -- vim.notify( vim.inspect( selection ) )
    putt( selection, 'selection' )

    -- write the contents of the selection table to a file output.txt in the cwd.
    -- printTable( selection )
  end)
  return true
end

-- require('utils.general').examp2()

function M.examp2( opts )
  opts = opts or {}
  opts.attach_mappings = examp2
  require('telescope.builtin').jumplist( opts )
end

-- print(vim.inspect(vim.api.nvim_get_mode()))
-- printTable(_G)

-- require("notify")("My super important message")


local Path = require "plenary.path"

function M.get_open_filelist(cwd)

  local bufnrs = vim.tbl_filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then
    return
  end

  local filelist = {}
  for _, bufnr in ipairs(bufnrs) do
    local file = vim.api.nvim_buf_get_name(bufnr)
    table.insert(filelist, Path:new(file):make_relative(cwd))
  end
  return filelist
end

-- require('utils.general').get_open_filelist( vim.loop.cwd() )

-- require('utils.general').get_open_filelist()

-- putt( require('utils.general').get_open_filelist( vim.loop.cwd() ) )

-- vim.loop.cwd()
-- require("telescope.config").values

-- require'trouble'.get_items()
-- vim.fn.NewBufCmds_templ()
-- require("telescope.actions.history").get_simple_history()
-- vim.api.nvim_feedkeys(" .. selection.value .. postfix, "n", true)
-- PATTERN: i can "preview" a command before running it.
-- vim.api.nvim_feedkeys( ":echo 'hi'", "n", true)


-- ─^  more examples                                     ▲


function M.Git_status_picker(opts)
  opts = opts or {}

  -- NOTE: By by default all commands should use the cwd of the current window!
  opts.cwd = vim.fn.getcwd( vim.fn.winnr() )

  opts.previewer = previewers.new_termopen_previewer({
    -- dyn_title = function(_, entry) return entry.value end,
    dyn_title = function(_, entry)
      -- PATTERN: run any synchronous shell command on a line entry.
      return vim.fn.systemlist( "git -C " .. opts.cwd .. " diff HEAD --stat " .. entry.path )[1]
      -- return entry.status
    end,
    get_command = function(entry)
      if entry.status == "D " then
        return { "git", "-C", opts.cwd, "show", "HEAD:" .. entry.value }
      elseif entry.status == "??" then
        return { "bat", "--style=plain", entry.value }
      end
      return { "git", "-C", opts.cwd, "-c", "core.pager=delta", "-c", "delta.pager=less -R", "diff", "HEAD", entry.path }
      -- return { "bat", entry.path }
      -- return { "bash", "-c", "ls -ls | bat" }
      -- return { "bash", "-c", "echo " .. entry.path .. "&& echo hi" }
      -- return { "bash", "-c", "echo 'hi there' " .. entry.path .. "| bat" }
      -- return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.path }
      -- return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!', '--', entry.current_file }
    end,
  })


  -- Use icons that resemble the `git status` command line.
  opts.git_icons = {
    added = "A",
    changed = "M",
    copied = "C",
    deleted = "-",
    renamed = "R",
    unmerged = "U",
    untracked = "?",
  }

  builtin.git_status(opts)
end


-- vim.fn.getcwd( vim.fn.winnr() )

function M.Git_status_picker_bak(opts)
  opts = opts or {}

  -- NOTE: By by default all commands should use the cwd of the current window!
  opts.cwd = vim.fn.getcwd( vim.fn.winnr() )

  opts.previewer = previewers.new_termopen_previewer({
    -- dyn_title = function(_, entry) return entry.value end,
    dyn_title = function(_, entry)
      -- PATTERN: run any synchronous shell command on a line entry.
      return vim.fn.systemlist( 'git diff HEAD --stat ' .. entry.path )[1]
      -- return entry.status
    end,
    get_command = function(entry)
      if entry.status == "D " then
        return { "git", "show", "HEAD:" .. entry.value }
      elseif entry.status == "??" then
        return { "bat", "--style=plain", entry.value }
      end
      return { "git", "-c", "core.pager=delta", "-c", "delta.pager=less -R", "diff", "HEAD", entry.path }
      -- return { "bat", entry.path }
      -- return { "bash", "-c", "ls -ls | bat" }
      -- return { "bash", "-c", "echo " .. entry.path .. "&& echo hi" }
      -- return { "bash", "-c", "echo 'hi there' " .. entry.path .. "| bat" }
      -- return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.path }
      -- return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!', '--', entry.current_file }
    end,
  })


  -- Use icons that resemble the `git status` command line.
  opts.git_icons = {
    added = "A",
    changed = "M",
    copied = "C",
    deleted = "-",
    renamed = "R",
    unmerged = "U",
    untracked = "?",
  }

  builtin.git_status(opts)
end

-- require('utils.general').Git_status_picker()

-- ─   Diff to main / master                            ──
-- Show a diff to the main/master branch

-- note this is just a poc/first version. "..master" inverts the git diff colors
-- would have to use 'main' if master does not exist.
function M.Git_diff_to_master(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer({
    -- dyn_title = function(_, entry) return entry.value end,
    dyn_title = function(_, entry)
      -- PATTERN: run any synchronous shell command on a line entry.
      return vim.fn.systemlist( 'git diff ..main --stat ' .. entry.path )[1]
      -- return entry.status
    end,
    get_command = function(entry)
      if entry.status == "D " then
        return { "git", "show", "main:" .. entry.value }
      elseif entry.status == "??" then
        return { "bat", "--style=plain", entry.value }
      end
      return { "git", "-c", "core.pager=delta", "-c", "delta.pager=less -R", "diff", "..main", entry.path }
    end,
  })

  -- Use icons that resemble the `git status` command line.
  opts.git_icons = {
    added = "A",
    changed = "M",
    copied = "C",
    deleted = "-",
    renamed = "R",
    unmerged = "U",
    untracked = "?",
  }

  builtin.git_files(opts)
end

-- require('utils.general').Git_diff_to_master()





-- ─   -- doesn't work currently                        ──
local delta2 = previewers.new_termopen_previewer {
  get_command = function(entry)
    -- this is for status
    -- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
    -- just do an if and return a different command
    if entry.status == '??' or 'A ' then
      return {'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.path}
    end
    -- note we can't use pipes
    -- this command is for git_commits and git_bcommits
    return {'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!'}
  end
}


M.git_status2 = function(opts)
  opts = opts or {}
  opts.previewer = delta2
  -- opts.cwd = '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/'
  -- opts.use_git_root = true
  builtin.git_status(opts)
  -- <tab> to stage/unstage file
  -- <cr> open file
end




return M













