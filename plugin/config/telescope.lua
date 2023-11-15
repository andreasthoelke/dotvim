local M = {}

local actions = require("telescope.actions")
local action_state = require "telescope.actions.state"
local resume = require("telescope.builtin").resume
local action_set = require "telescope.actions.set"
local trouble = require("trouble.providers.telescope")
local easypick = require("easypick")
local f = require 'utils.functional'
local s = require 'utils.string'

-- -- NOTE: getting some additional state details:
-- local prompt_title = action_state.get_current_picker( pbn ).prompt_title
-- { "__cycle_layout_list", "__scrolling_limit", "_selection_row", "_on_lines", "tiebreak", "window", "original_win_id", "get_status_text", "file_ignore_patterns", "prompt_bufnr", "_original_mode", "stats", "_multi", "preview_win", "push_cursor_on_edit", "preview_border", "layout_strategy", "prompt_win", "max_results", "manager", "scroller", "prompt_title", "layout", "_selection_entry", "initial_mode", "highlighter", "get_window_options", "prompt_border", "results_border", "sorting_strategy", "previewer", "push_tagstack_on_edit", "selection_strategy", "cache_picker", "scroll_strategy", "results_win", "results_bufnr", "create_layout", "preview_bufnr", "layout_config", "get_selection_window", "sorter", "results_title", "attach_mappings", "wrap_results", "multi_icon", "prompt_prefix", "_finder_attached", "preview_title", "selection_caret", "_on_input_filter_cb", "entry_prefix", "finder", "all_previewers", "current_previewer_index", "_find_id", "_completion_callbacks", "track" }


-- ─   Helpers                                          ──

local append_to_history = function(prompt_bufnr)
  action_state
    .get_current_history()
    :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
end


local function move_selection_next_with_space()
  return   actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
end

local function selection_center()
  return   actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
end

local function move_selection_previous_with_space()
  return   actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
end


local function get_path_link( prompt_title, search_term )
  local selection = action_state.get_selected_entry()

  -- putt( prompt_title )
  -- putt( selection )
  -- putt( search_term )

  local path, link

  -- CASE: Keymaps picker
  -- ISSUE: preview only partially works, sometimes gets a folder as filepath?
  if     prompt_title == "Key Maps" then
    local keymap_props = Keymap_props( selection.mode, selection.lhs )
    -- putt(selection)
    -- using keymap_props.filename and lnum to get that lineText
    local lineText = vim.fn.readfile( vim.fn.fnamemodify( keymap_props.filename, ':p' ) )[ keymap_props.lnum ]
    local start_index = vim.fn.match( lineText, search_term )
    local end_index = start_index + search_term:len() -1
    if start_index == -1 then
      -- if the search term can not be found by simple match, guess a possible fuzzy match by pointing to a match of the first char.
      start_index = vim.fn.match( selection.text, s.head( search_term ) )
      end_index = start_index
    end

    path = keymap_props.filename
    link = {
      lnum = keymap_props.lnum,
      col  = start_index,
      col_end = end_index,
    }

    -- CASE: Vim help tags. This picker provides a search command field(?!) ~/.config/nvim/plugged/telescope.nvim/lua/telescope/builtin/__internal.lua‖/cmdˍ=ˍfield
    --                      An alternative approach would be to change the NewBuf command to include "help" like here: ~/.config/nvim/plugged/telescope.nvim/lua/telescope/builtin/__internal.lua‖/elseifˍcmdˍ
  elseif prompt_title == "Help" then
  -- elseif vim.tbl_get( selection, 'cmd' ) ~= nil then
    path = vim.tbl_get( selection, 'filename' )
    link = {
      searchTerm = vim.tbl_get( selection, 'cmd' )
    }


    -- CASE: LIVE GREP
  elseif prompt_title == "Live Grep" then
    -- putt(selection)
    local mt = getmetatable(selection)
    local cwdOfFile = vim.tbl_get( mt, 'cwd' ) or ""
    local filePath = selection.filename
    local isAbsFilePath = filePath ~= nil and filePath:sub(1,1) == '/'
    filePath = not isAbsFilePath and cwdOfFile .. "/" .. filePath or filePath
    local start_index = vim.fn.match( selection.text, search_term )
    local end_index = start_index + search_term:len() -1
    if start_index == -1 then
      -- if the search term can not be found by simple match, guess a possible fuzzy match by pointing to a match of the first char.
      start_index = vim.fn.match( selection.text, s.head( search_term ) )
      end_index = start_index
    end
    path = filePath
    link = {
      lnum = selection.lnum,
      col  = start_index,
      col_end = end_index,
    }

  elseif prompt_title == "rx sel" then
    -- putt(selection)
    local mt = getmetatable(selection)
    local cwdOfFile = vim.tbl_get( mt, 'cwd' ) or ""
    local filePath = selection.filename
    local isAbsFilePath = filePath ~= nil and filePath:sub(1,1) == '/'
    filePath = not isAbsFilePath and cwdOfFile .. "/" .. filePath or filePath
    local start_index = vim.fn.match( selection.text, search_term )
    local end_index = start_index + search_term:len() -1
    if start_index == -1 then
      -- if the search term can not be found by simple match, guess a possible fuzzy match by pointing to a match of the first char.
      start_index = vim.fn.match( selection.text, s.head( search_term ) )
      end_index = start_index
    end
    path = filePath
    link = {
      lnum = selection.lnum,
      col  = start_index,
      col_end = end_index,
    }


    -- CASE: FUZZY BUFFER
  elseif prompt_title == "Current Buffer Fuzzy" then
    local start_index = vim.fn.match( selection.text, search_term )
    local end_index = start_index + search_term:len() -1
    if start_index == -1 then
      -- if the search term can not be found by simple match, guess a possible fuzzy match by pointing to a match of the first char.
      start_index = vim.fn.match( selection.text, s.head( search_term ) )
      end_index = start_index
    end
    path = selection.filename
    link = {
      lnum = selection.lnum,
      col  = start_index,
      col_end = end_index,
    }

    -- CASE: AST GREP
  elseif prompt_title == "Ast Grep" then
    path = selection.filename
    link = {
      lnum = selection.lnum,
      col  = selection.col - 1,
      col_end = selection.colend - 2
    }


    -- CASE: Filename pickers with optional linenum and cursor column
  elseif vim.tbl_get( selection, 'filename' ) ~= nil then
    path = vim.tbl_get( selection, 'filename' )
    link = {
      lnum = vim.tbl_get( selection, 'lnum' ) or 1,
      col  = vim.tbl_get( selection, 'col' ) or 1
    }

  else
    path = vim.tbl_get( selection, 'value' )
    link = {
      lnum = vim.tbl_get( selection, 'lnum' ) or 1,
      col  = vim.tbl_get( selection, 'col' ) or 1
    }
  end
  return path, link
end

function _G.Defer_cmd( cmd, timeout )
  vim.defer_fn( vim.cmd( cmd ), timeout )
end

local function closeAndResetPreview( pbn )
  append_to_history( pbn )
  actions.close( pbn )
  ReverseColors_clear()

  if not vim.tbl_isempty( _G.TelescPreview_resetPos ) then
    -- Go gack to original position before using preview
    -- local col = _G.TelescPreview_resetPos.col == 0 and 0 or _G.TelescPreview_resetPos.col - 1
    local col = _G.TelescPreview_resetPos.col
    vim.cmd.edit( _G.TelescPreview_resetPos.filename )
    vim.api.nvim_win_set_cursor( 0, {_G.TelescPreview_resetPos.lnum, col})
    vim.cmd 'normal zz'
    _G.TelescPreview_resetPos = {}
  end
end

-- TelescPreview_resetPos

local function closeAndUpdateHighlight( pbn )
  local search_term = action_state.get_current_picker( pbn ):_get_prompt()
  local prompt_title = action_state.get_current_picker( pbn ).prompt_title

  actions.close( pbn )

  local _, maybeLink = get_path_link( prompt_title, search_term )

  if maybeLink ~= nil and vim.tbl_get( maybeLink, 'lnum' ) then
    -- local col_offset = vim.api.nvim_get_mode().mode == 'i' and 1 or 0
    -- vim.api.nvim_win_set_cursor( 0, {maybeLink.lnum, maybeLink.col + col_offset})
    -- vim.cmd 'normal zz'
    ReverseColors_clear()
    if vim.tbl_get( maybeLink, 'col' ) then
      HighlightRange( 'Search', maybeLink.lnum -1, maybeLink.col or 1, maybeLink.col_end or maybeLink.col or 1 )
    end

    if search_term ~= nil then
      vim.cmd( 'let @/ = "' .. search_term .. '"' )
      vim.cmd( 'set hlsearch' )
    end
  end
end



local NewBuf = f.curry( function( adirection, pbn )

  -- 1. GET CURRENT PROMPT DATA
  local search_term = action_state.get_current_picker( pbn ):_get_prompt()
  search_term = f.last( vim.fn.split( search_term, [[\*]] ) )
  local prompt_title = action_state.get_current_picker( pbn ).prompt_title
  -- putt( title )

  if
    prompt_title == "Spelling Suggestions" or
    prompt_title == "Registers" or
    prompt_title == "Symbols"
  then
    actions.select_default( pbn )
    return
  end

  -- 2. DO SOME RESETS / PERSISTS AND CLOSE THE PROMPT
  append_to_history( pbn )
  _G.TelescPreview_resetPos = {}

  -- We always temp-close the prompt, then run the NewBuf action and link focus
  actions.close( pbn )
  -- closeAndUpdateHighlight( pbn )
  -- Closing the picker before we process the path_link, brings the cursor and focus back to the previous buffer, which allows to e.g. run "verb map" and perhaps access some buffer vars(?)

  ReverseColors_clear()

  -- 3. GET LINK DATA
  local fpath, maybeLink = get_path_link( prompt_title, search_term )
  local direction, maybe_back = table.unpack( vim.fn.split( adirection, [[_]] ) )
  local cmd = vim.fn.NewBufCmds( fpath )[ direction ]

  -- 4. OPEN NEW BUFFER (if needed)
  if vim.fn.expand '%:p' ~= fpath or adirection ~= 'full' then
    vim.cmd( cmd )
  end

  -- 5. FOCUS & HIGHLIGHT LINE & KEYWORD
  if     maybeLink ~= nil and vim.tbl_get( maybeLink, 'col' ) then
    local col_offset = vim.api.nvim_get_mode().mode == 'i' and 1 or 0
    vim.api.nvim_win_set_cursor( 0, {maybeLink.lnum, maybeLink.col + col_offset})
    vim.cmd 'normal zz'

    -- HighlightRange( 'Search', maybeLink.lnum -1, maybeLink.col or 1, maybeLink.col_end or maybeLink.col or 1 )
    if search_term ~= nil then
      local search_term_with_quotes_removed = search_term:gsub( '"', '' )
      vim.cmd( 'let @/ = "' .. search_term_with_quotes_removed .. '"' )
      vim.cmd( 'set hlsearch' )
    end

  elseif maybeLink ~= nil and vim.tbl_get( maybeLink, 'lnum' ) then
    vim.api.nvim_win_set_cursor( 0, {maybeLink.lnum, 1})

  elseif maybeLink ~= nil and vim.tbl_get( maybeLink, 'searchTerm' ) then
    vim.fn.search( s.tail( maybeLink.searchTerm ), "cw" )
  end

  -- 6. HANDLE TAB BACK
  if     adirection == 'tab_bg' then     -- opened to the right in the background
    vim.cmd 'tabprevious'
  elseif adirection == 'tab_back' then --   open and go to new tab, then jump *back* to prompt
    -- nothing needed, resume will open in new tab.
  end

  -- 7. BRING BACK THE PROMPT
  if maybe_back then
    resume()
  end

end)


function _G.HighlightRange(HlGroup, lineNumber, startColumn, endColumn)
  local buf = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace('reverseColors')
  local opts = {
    end_col = endColumn + 1,
    hl_group = HlGroup,
    -- hl_group = 'Search',
    priority = 100
  }
  vim.api.nvim_buf_set_extmark(buf, ns_id, lineNumber, startColumn, opts)
  vim.cmd('redraw')
end

-- ReverseColors( 139, 14, 26 )

function _G.ReverseColors_clear()
 local buf = vim.api.nvim_get_current_buf()
 local ns_id = vim.api.nvim_create_namespace('reverseColors')
 vim.api.nvim_buf_clear_namespace(buf, ns_id, 1, -1)
end

-- ReverseColors_clear()

_G.TelescPreview_resetPos = {}


local preview = f.curry( function( next_previous, mode, pbn )

  -- 1. MOVE SELECTION (potentially)
  if     next_previous == 'next' then
    actions.move_selection_next( pbn )
  elseif next_previous == 'previous' then
    actions.move_selection_previous( pbn )
  elseif next_previous == 'current' then
    -- don't move
  end

  local search_term = action_state.get_current_picker( pbn ):_get_prompt()
  search_term = f.last( vim.fn.split( search_term, [[\*]] ) )
  local prompt_title = action_state.get_current_picker( pbn ).prompt_title

  -- 2. CLOSE PROMPT (tempoarily)
  actions.close( pbn )

  -- 2a. BACKUP ORG POS BEFORE USING PREVIEW
  if vim.tbl_isempty( _G.TelescPreview_resetPos ) then
    _G.TelescPreview_resetPos = {
      filename = vim.fn.expand '%:p',
      lnum = vim.api.nvim_win_get_cursor(0)[1],
      col = vim.api.nvim_win_get_cursor(0)[2],
    }
  end

  local fpath, maybeLink = get_path_link( prompt_title, search_term )

  -- 3. OPEN NEW BUFFER (if needed)
  if vim.fn.expand '%:p' ~= fpath then
    vim.cmd.edit( fpath )
  end

  -- 4. FOCUS & HIGHLIGHT LINE & KEYWORD
  if     maybeLink ~= nil and vim.tbl_get( maybeLink, 'col' ) then
    local col_offset = vim.api.nvim_get_mode().mode == 'i' and 1 or 0
    vim.api.nvim_win_set_cursor( 0, {maybeLink.lnum, maybeLink.col + col_offset})
    vim.cmd 'normal zz'

    ReverseColors_clear()
    HighlightRange( 'Reverse', maybeLink.lnum -1, maybeLink.col or 1, maybeLink.col_end or maybeLink.col or 1 )

  elseif maybeLink ~= nil and vim.tbl_get( maybeLink, 'lnum' ) then
    vim.api.nvim_win_set_cursor( 0, {maybeLink.lnum, 1})

  elseif maybeLink ~= nil and vim.tbl_get( maybeLink, 'searchTerm' ) then
    vim.fn.search( s.tail( maybeLink.searchTerm ), "cw" )
  end


  -- 5. BRING BACK THE PROMPT
  resume( { initial_mode = mode } )
end )

-- vim.api.nvim_win_get_cursor(0)[2]
-- vim.api.nvim_win_get_cursor(0)[1]
-- ("eins"):len()

-- string.find( "  if     lineZio && lineCats", "Zio" )
-- vim.fn.match( "  if     lineZio && lineCats", "zio" )

-- local entry_display = require "telescope.pickers.entry_display"
-- vim.fn.split( 'eins_zwei', '_' )
-- vim.fn.split( 'einszwei', '_' )

-- NOTE: there's
-- lua/utils_general.lua
-- with custom pickers. also this example: ~/.config/nvim/plugged/telescope.nvim/lua/telescope/builtin/__files.lua#/pickers
-- require("telescope.builtin").find_files({hidden=true, layout_config={prompt_position="top"}})


-- ─   Config                                            ■

-- Note these default maps https://github.com/nvim-telescope/telescope.nvim\#default-mappings
Telesc = require('telescope').setup{
  defaults = {
    -- config_key = value,
    path_display = { 'shorten' },
    hidden = true,  -- ISSUE: this doesn't have an effect. to show files like .gitignore use nnoremap <silent> go <cmd>Telescope find_files hidden=true<cr>
    file_ignore_patterns = {
            '^.git/', '^node%_modules/', '^.npm/', 'dev.js', '%[Cc]ache/', '%-cache',
            '^scala-doc/',
    --         '%.py[co]', '%.sw?', '%~', '%.a', "%.npz", "^.vscode",
            '%.tags', 'tags', '%.gemtags',
            -- '%.csv', '%.tsv', '%.tmp',
            -- '%.exe', "%.dat", "^dist",
    --         '%.old', '%.plist', '%.pdf', '%.log', '%.jpg', '%.jpeg', '%.png', "%.obj", "^release",
    --         '%.tar.gz', '%.tar', '%.zip', '%.class', '%.pdb', '%.dll', '%.bak', "%.lib", "^.idea",
    --         '%.scan', '%.mca', '__pycache__', '^.mozilla/', '^.electron/', '%.bin', "^debug",
    --         '^.vpython-root/', '^.gradle/', '^.nuget/', '^.cargo/', '^.evernote/', "^Debug",
    --         '^.azure-functions-core-tools/', '^yay/', '%.class', '%.o', '%.so', "^Release",
        },
    -- prompt_prefix = "➔ ",
    prompt_prefix = "  ",
    -- selection_caret = "⇾ ",
    selection_caret = "⠰ ",
    -- initial_mode = 'normal',

-- ─   Mappings                                         ──
    mappings = {
      i = {
        ["<c-l>"] = function() vim.fn.feedkeys( ".*" ) end,
        ["<c-space>"] = function(pbn)
          local prompt_title = action_state.get_current_picker( pbn ).prompt_title
          if prompt_title == "Key Maps" then
            vim.fn.feedkeys( "<space>" )
          elseif prompt_title == "rx sel" then
            vim.fn.feedkeys( "<leader>" )
          end
        end,

        ["<c-j>"] = move_selection_next_with_space(),
        ["<c-k>"] = move_selection_previous_with_space(),

        ["<c-n>"] = preview 'next' 'insert',
        ["<c-p>"] = preview 'previous' 'insert',
        ["<c-i>"] = preview 'current' 'insert',

        ["<c-o>"] = actions.cycle_history_prev,
        ["µ"]     = actions.cycle_history_next,


-- ─   NewBuf maps i                                    ──
        -- NewBuf is consistent with ~/.config/nvim/plugin/NewBuf-direction-maps.vim‖/LINE-WORD

        ['<c-w>p'] = NewBuf 'preview_back',
        ['<c-w>o'] = NewBuf 'float',
        ['<c-w>i'] = NewBuf 'full',
        ["<cr>"] = NewBuf 'full',
        -- ['<cr>']   = actions.select_default,
        ['<c-w>t'] = { '<cmd>echo "use tn, tt or T"<cr>', type = 'command' },
        ['<c-w>tn'] = NewBuf 'tab',
        ['<c-w>tt'] = NewBuf 'tab_back',
        ['<c-w>T'] = NewBuf 'tab_bg',
        -- _
        ['<c-w>v'] = NewBuf 'right',
        ['<c-w>V'] = NewBuf 'right_back',
        ['<c-w>a'] = NewBuf 'left',
        ['<c-w>u'] = NewBuf 'up',
        ['<c-w>U'] = NewBuf 'up_back',
        ['<c-w>s'] = NewBuf 'down',
        ['<c-w>S'] = { NewBuf 'down_back', type = 'action', opts = { nowait = true } },

      },
      n = {


-- ─   NewBuf maps n                                    ──

        ['<c-w>p'] = NewBuf 'preview_back',
        ['<c-w>o'] = NewBuf 'float',
        ['<c-w>i'] = NewBuf 'full',
        ["<cr>"] = NewBuf 'full',
        -- ['<cr>']   = actions.select_default,
        ['<c-w>t'] = { '<cmd>echo "use tn, tt or T"<cr>', type = 'command' },
        ['<c-w>tn'] = NewBuf 'tab',
        ['<c-w>tt'] = NewBuf 'tab_back',
        ['<c-w>T'] = NewBuf 'tab_bg',
        -- _
        ['<c-w>v'] = NewBuf 'right',
        ['<c-w>V'] = NewBuf 'right_back',
        ['<c-w>a'] = NewBuf 'left',
        ['<c-w>u'] = NewBuf 'up',
        ['<c-w>U'] = NewBuf 'up_back',
        ['<c-w>s'] = NewBuf 'down',
        ['<c-w>S'] = { NewBuf 'down_back', type = 'action', opts = { nowait = true } },

        -- ['<cr>']   = actions.select_default,
        -- ["<esc>"] = function() vim.print 'hi' end,
        -- ["<cr>"] = function() vim.print 'hi' end,
        ["<esc>"] = closeAndResetPreview,

-- ─   Exchange                                         ──

        ["<leader>dd"] = actions.delete_buffer,
        ["<leader><c-o>"] = trouble.open_with_trouble,

        ["<c-q>"] = actions.send_selected_to_qflist,

        ["m"] = { actions.toggle_selection, type = "action", opts = { nowait = true } },
        [",m"] = actions.select_all,
        [",M"] = actions.drop_all,

        -- ["uu"] = { "<cmd>echo \"Hello, World!\"<cr>", type = "command" },

-- ─   View                                             ──
        ["<c-y>"] = actions.preview_scrolling_up,
        ["<c-e>"] = actions.preview_scrolling_down,

        ["n"]     = preview 'next' 'normal',
        ["p"]     = preview 'previous' 'normal',
        ["<c-n>"] = preview 'next' 'insert',
        ["<c-p>"] = preview 'previous' 'insert',
        ["<c-i>"] = preview 'current' 'insert',

        ["<c-o>"] = actions.cycle_history_prev,
        ["µ"]     = actions.cycle_history_next,

        ["j"]     = move_selection_next_with_space(),
        ["k"]     = move_selection_previous_with_space(),
        ["<c-j>"] = move_selection_next_with_space(),
        ["<c-k>"] = move_selection_previous_with_space(),

        ["zz"] = selection_center(),

        [",,b"] = function(pbn)
          local out = action_state.get_current_picker( pbn )
          -- local out = action_state.get_selected_entry( )
          -- putt(vim.tbl_keys(out))

          local selection = action_state.get_selected_entry()

          local mt = getmetatable(selection)
          -- putt(out.highlighter)
          putt(mt)
        end,


      },
    },


-- ─   Layout                                           ──

    layout_strategy = 'vertical',
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    dynamic_preview_title = true,
    scroll_speed = 1,
    -- sort_lastused = true,
    -- selection_strategy = 'closest',
    -- selection_strategy = 'reset',
    -- default_selection_index = 3,
    layout_config = {
      horizontal = {
        width = 0.72,
        height = 0.72,
        anchor = 'NW',
        prompt_position = 'top',
        sorting_strategy = 'ascending',
        scroll_speed = 1,
        preview_height = 0.5,
      },

      vertical = {
        width = 100,
        height = 0.78,
        anchor = 'E',
        dynamic_preview_title = true,
        prompt_position = 'top',
        sorting_strategy = 'ascending',
        scroll_speed = 1,
        preview_height = 0.47,
      },

      center = {
        width = 0.92,
        height = 0.52,
        -- anchor = 'S',
        -- prompt_position = 'top',
        sorting_strategy = 'ascending',
        scroll_speed = 1,
        preview_height = 0.5,
      },
      cursor = { width = 80, height = 20 },
    },
  },
  -- pickers = {
  --   -- Default configuration for builtin pickers goes here:
  --   -- picker_name = {
  --   --   picker_config_key = value,
  --   --   ...
  --   -- }
  --   -- Now the picker_config_key will be applied every time you call this
  --   -- builtin picker
  --   -- find_files = {
  --   -- }
  -- },

  extensions = {
    bookmarks = {
      selected_browser = 'chrome',
    },

    frecency = {
      -- db_root = "/home/my_username/path/to/db_root",
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
      disable_devicons = false,
      db_safe_mode = false,
      auto_validate = true,
      workspaces = {
        ["conf"]    = "/Users/at/.config",
        -- ["data"]    = "/home/my_username/.local/share",
        ["proj"] = "/Users/at/Documents/Proj",
        -- ["wiki"]    = "/home/my_username/wiki"
      }
    },

    ast_grep = {
      command = {
        "sg",
        "--json=stream",
      }, -- must have --json=stream
      grep_open_files = false, -- search in opened files
      lang = nil, -- string value, specify language for ast-grep `nil` for default
    }


    -- ['ui-select'] = {
    --   -- require('telescope.themes').get_dropdown {
    --   --   layout_config = {
    --   --     width = 0.8,
    --   --     height = 0.8,
    --   --   }
    --   -- },
    --   specific_opts = {
    --     ['browser-bookmarks'] = {
    --       make_displayer = function()
    --         return entry_display.create {
    --           separator = ' ',
    --           items = {
    --             { width = 0.5 },
    --             { remaining = true },
    --           },
    --           -- Use this instead if `buku_include_tags` is true:
    --           -- items = {
    --           --   { width = 0.3 },
    --           --   { width = 0.2 },
    --           --   { remaining = true },
    --           -- },
    --         }
    --       end,
    --       make_display = function(displayer)
    --         return function(entry)
    --           return displayer {
    --             entry.value.text.name,
    --             -- Uncomment if `buku_include_tags` is true:
    --             -- { entry.value.text.tags, 'Special' },
    --             { entry.value.text.url, 'Comment' },
    --           }
    --         end
    --       end,
    --     },
    --   },
    -- },
   },

  -- extensions = {
  --   heading = {
  --       treesitter = true,
  --     },
  --   bookmarks = {
  --       selected_browser = "chrome",
  --     },
  --   -- Your extension configuration goes here:
  --   -- extension_name = {
  --   --   extension_config_key = value,
  --   -- }
  --   -- please take a look at the readme of the extension you want to configure

  -- }
}


-- ─^  Config                                            ▲


-- ─   Telescope extensions                              ■

require'telescope'.load_extension('project')
require('telescope').load_extension('vim_bookmarks')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('heading')
require('telescope').load_extension('glyph')
require('telescope').load_extension('scaladex')
require('telescope').load_extension('env')
require('telescope').load_extension('ag')
-- This hooks up telescope to be used when noice / nvim-ui ui-select actions are issued.
-- require('telescope').load_extension('ui-select')
require('telescope').load_extension('bookmarks')
require('telescope').load_extension('frecency')
require('telescope').load_extension('ast_grep')
require('telescope').load_extension('possession')


vim.api.nvim_set_keymap('n',
  '<leader>si',
  [[<cmd>lua require('telescope').extensions.scaladex.scaladex.search()<cr>]],
  { noremap = true, silent = true }
)

-- require("telescope").load_extension( "live-grep-args" )

local bookmark_actions = require('telescope').extensions.vim_bookmarks.actions

function _G.TelBookmarks()
  require('telescope').extensions.vim_bookmarks.all {
    -- width_line=0,
    -- width_text=40,
    -- shorten_path=true,
    attach_mappings = function(_, map)
      map('i', '<C-x>', bookmark_actions.delete_selected_or_at_cursor)
      map('n', 'dd', bookmark_actions.delete_selected_or_at_cursor)
      return true
    end
  }
end
-- require("telescope").extensions.bookmarks.bookmarks({ filter = "Scala" })
-- vim.fs.dirname("plugged/cmp-buffer/LICENSE")

local base_branch = "eins"

-- TODO test with :Easypick
easypick.setup({
  pickers = {
    -- add your custom pickers here
    -- below you can find some examples of what those can look like

    -- list files inside current folder with default previewer
    {
      -- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
      name = "ls",
      -- the command to execute, output has to be a list of plain text entries
      command = "ls",
      -- specify your custom previwer, or use one of the easypick.previewers
      previewer = easypick.previewers.default()
    },

    -- diff current branch with base_branch and show files that changed with respective diffs in preview
    {
      name = "changed_files",
      command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
      previewer = easypick.previewers.branch_diff({base_branch = base_branch})
    },


    {
      name = "rg",
      -- command = [[rg -U '(def|extension).*(\n)?.*(\n)?.*(\n)?.*\s=\s' -g 'utils.scala' --line-number --column --with-filename --no-heading]],
      command = "rg List --line-number --column --with-filename --no-heading",
      -- ISSUE: the previewer doesn't work
      -- previewer = telescope.defaults.grep_previewer,
      -- previewer = easypick.previewers.default(),
      -- previewer = easypick.previewers.file_diff(),
      -- action = easypick.actions.nvim_command( "echo " )
    },
  }
})
    -- vimgrep_arguments =  {
    --   "rg",
    --     "--color=never",
    --     "--no-heading",
    --     "--with-filename",
    --     "--line-number",
    --     "--column",
    --     "--smart-case"
    -- }
-- lua put( require'utils_general'.abc() )
-- nnoremap ,ss <cmd>lua require('utils_general').Rg_RegexSelect_Picker({}, [[\s[A-Z]{3,}:]], {"-g", "**/AZioHttp/*.md", "-g", "**/BZioHttp/*.scala"})<cr>


-- ─^  Telescope extensions                              ▲



function _G.WinIsLeftSplit()
  local win_position = vim.api.nvim_win_get_position(0)
  local screen_width = vim.api.nvim_get_option('columns')
  local threshold = screen_width / 2 - 0
  return win_position[2] < threshold
end
-- WinIsLeftSplit()
-- lua putt( WinIsLeftSplit() )


function _G.Telesc_dynPosOpts( opts )
  opts = opts or {}
  local tabHasVerticalSplitWindows = vim.fn.tabpagewinnr( vim.fn.tabpagenr(), '$' ) > 1
  local neovim_full_client_width = vim.api.nvim_get_option('columns')
  local anchor = WinIsLeftSplit() and 'E' or 'W'
  local layout_opts
  -- putt( anchor )
  -- if anchor == 'W' and not tabHasVerticalSplitWindows then
  if neovim_full_client_width < 160 then
    layout_opts = {}
  elseif anchor == 'W' then
    local win_width = vim.api.nvim_win_get_position(0)[2] - 2
    -- win_width = win_width < 60 and 60 or win_width
    win_width = win_width
    layout_opts = {
      layout_config = {
        vertical = {
          anchor = anchor,
          width = win_width,
        }
      },
    }
  else
    layout_opts = { layout_config = { vertical = { anchor = anchor } } }
  end
  -- type assert that this will be a table
  return vim.tbl_extend( 'keep', opts, layout_opts )
end

-- vim.api.nvim_get_option('columns')

function _G.Telesc_launch( picker_name, opts )
  opts = Telesc_dynPosOpts( opts )
  require('telescope.builtin')[ picker_name ]( opts )
end

-- Telesc_launch 'live_grep'
-- Telesc_launch 'current_buffer_fuzzy_find'

vim.keymap.set( 'n',
  '<leader>ga', function() Telesc_launch( 'current_buffer_fuzzy_find', {
    initial_mode = 'normal',
    default_text = vim.fn.expand '<cword>'
  })
  end )


-- require('telescope.builtin')['find_files'](
--   {
--     layout_config = {
--       vertical = {
--         anchor = 'W'
--       }
--     }
--   }
-- )




return M





