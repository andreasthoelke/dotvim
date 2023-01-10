



local M = {}
local api = vim.api

-- print( require'plenary.path':new(vim.fn.stdpath('data'), 'sessions1', 'abc') )


function M.makeScratch()
  api.nvim_command('enew') -- equivalent to :enew
  -- vim.bo[0].buftype=nofile -- set the current buffer's (buffer 0) buftype to nofile
  -- vim.bo[0].bufhidden=hide
  vim.bo[0].swapfile=false
end


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

local action_set = require('telescope.actions.set')


function M.fileView1()
  local actions_state = require("telescope.actions.state")
  -- local opts = {}
  local opts = {
    attach_mappings = function(prompt_bufnr, map)
      local entry = actions_state.get_selected_entry()
      action_set.select:replace( function()
        put( entry )
      end
      )
      return true
    end
  }
  require("telescope.builtin").find_files(opts)
end
-- require'utils_general'.fileView1()


function M.fileView()
  require("telescope.builtin").buffers({
    entry_maker = my_make_entry.gen_from_buffer_like_leaderf(),
  })
end
-- require'utils_general'.fileView()

function M.fileViewB()
  require("telescope").extensions.file_browser.file_browser()
end
-- require'utils_general'.fileViewB()


function M.Search_greparg()
  require('telescope').extensions.live_grep_args.live_grep_args({
    -- default_text = [[def\s.*]],
    glob_pattern = scala_interest_files,
    cwd = scala_parent_dir,
    theme = 'dropdown',
  } )
end
-- require'utils_general'.Search_greparg()

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


-- First picker: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md

-- ─   Rgx select picker                                ──

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"

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
  -- opts = opts or {}
  opts = {
    -- "entry" is a line from "git diff --stat"
    entry_maker = function(entry)
      local split = vim.split(entry, [[|]])
      local rel_filepath = split[1]:gsub("%s+", "")
      local gstat = vim.F.if_nil( split[2], "" ):gsub("%s+", "")
      local abs_filepath = vim.fn.getcwd() .. "/" .. rel_filepath
      -- local wordCount = vim.fn.systemlist( 'wc ' .. abs_filepath .. " | awk '{print $1}'")[1]
      local wc_output = vim.fn.systemlist( "wc " .. abs_filepath .. " | awk {'print $1 \":\" $2'}" )[1]
      local wc_list = vim.split( wc_output, ":" )
      local line_num = tonumber(split[2])
      -- local gstat = vim.fn.systemlist( 'git diff HEAD --stat ' .. entry )[1]
      return {
        -- display = split[1] .. "|" .. split[2] .. "|" .. split[3].. "|" .. split[4]  ,
        value = abs_filepath,
        display = "l:" .. wc_list[1] .. " | w:" .. wc_list[2] .. " | " .. rel_filepath .. " | " .. gstat,
        ordinal = rel_filepath, -- this is for sorting?
      }

    end
  }

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
-- require('utils_general').Git_diff_stat()



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
      local abs_filepath = vim.fn.getcwd() .. "/" .. rel_filepath
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

-- require('utils_general').Colors()

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

-- require('utils_general').Concat({4,3}, {8, 9})  
-- require('plenary.tbl').apply_defaults( {1, 2}, {4, 5} )
-- vim.fn.join( {3,4}, 1 )
-- vim.fn.systemlist( 'git diff HEAD --stat ' )
-- vim.fn..slice({2,3}, 0, 1)
-- {3,4}.1

-- M.abb = {3, 4, 5}
-- require'utils_general'.abb[1]


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
        '--sort', 'accessed',
        -- '--regexp', 'pcre2'
    }
  local rg_cmd = M.Concat( M.Concat( rg_baseArgs, globs ), paths )

  pickers.new(opts, {
    prompt_title = 'rx sel',
    finder    = finders.new_oneshot_job( rg_cmd, opts ),
    sorter    = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function( prompt_bufnr )
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd( "e " .. selection.filename )
        vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
        vim.cmd "norm! zz"
        -- vim.pretty_print( selection )
      end)
      return true
    end,
  }):find()
end

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


-- ─   Custom actions command                           ──

-- Copies an old version of the file intot the project folder using a new unique file name!
-- PATTERN: example of running a shell command on a filename or git commit id.
-- also an example of overriding/replacing an actions that is defined for a default picker.

-- we are replacing select_default the default action, which is mapped to <CR> by default. To do this we need to call actions.select_default:replace and pass in a new function.
-- In this new function we first close the picker with actions.close and then get the selection with action_state

local function run_selection(prompt_bufnr, map)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    -- vim.pretty_print( selection )
    -- vim.pretty_print( vim.fn.expand('%') )
    -- vim.cmd([[!git log ]]..selection[1])
    -- git show 97853e3:z_patterns.scala > z_patterns_ab.scala
    local filename = vim.fn.expand('%')
    local filename_root = vim.fn.expand('%:r')
    local filename_extension = vim.fn.expand('%:e')
    local newfilename = filename_root.."_"..selection.value.."."..filename_extension
    vim.cmd([[!git show ]]..selection.value.. [[:]]..filename..[[ > ]]..newfilename )

  end)
  return true
end

function M.Git_log_picker( opts, filepath )
  opts = opts or {}
  opts.attach_mappings = run_selection

  -- require('telescope.builtin').find_files(opts)
  -- require('telescope.builtin').git_bcommits(opts)
  M.Git_commits_picker( opts, filepath )
end

-- vim.fn.expand('%:r')
-- vim.fn.expand('%:e')


local opts_1 = { initial_mode = 'normal' }

vim.keymap.set( 'n',
  ',gl', function() require( 'utils_general' )
  .Git_log_picker( opts_1, vim.fn.expand('%') )
  end )


function M.Git_commits_picker( opts, filepath )
  opts = opts or {}
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
  builtin.git_commits(opts)
  -- - `<cr>`: checks out the currently selected commit
  -- - `<C-r>m`: resets current branch to selected commit using mixed mode
  -- - `<C-r>s`: resets current branch to selected commit using soft mode
  -- - `<C-r>h`: resets current branch to selected commit using hard mode
end


-- ─   Keymap picker                                     ■

-- vim.fn.expand('%')
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

function M.Keymap_props( mode, lhs_map_string )
  local propsstr = vim.api.nvim_exec( "verbose "..mode.."map "..lhs_map_string, true )
  local propslist = vim.split( propsstr, " " )
  -- vim.pretty_print( propslist )
  -- vim.pretty_print( M.IndexOf( propslist, "from" ) )
  local fni = M.IndexOf( propslist, "from" ) + 1
  local lni = M.IndexOf( propslist, "line" ) + 1
  return {
    filename = propslist[fni],
    lnum = tonumber( propslist[lni] )
  }
end
-- require('utils_general').Keymap_props("n", "<space>vm")
-- require('utils_general').Keymap_props("n", "gei")


local function keymap_select_action( prompt_bufnr )
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    -- vim.pretty_print( selection )
    local keymap_props = M.Keymap_props( selection.mode, selection.lhs )
    -- vim.pretty_print( keymap_props )
    vim.cmd( "vnew " .. keymap_props.filename )
    vim.api.nvim_win_set_cursor(0, { keymap_props.lnum, 0 })
    vim.cmd "norm! zz"
  end)
  return true
end

function M.Keymap_picker( opts )
  opts = opts or {}
  opts.attach_mappings = keymap_select_action

  require('telescope.builtin').keymaps( opts )
  -- require('telescope.builtin').find_files( opts )
end

vim.keymap.set( 'n',
  ',,vm', function() require( 'utils_general' )
  .Keymap_picker( opts_1 )
  end )





-- ─^  Keymap picker                                     ▲



M.Git_status_picker = function(opts)
  opts = opts or {}
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













