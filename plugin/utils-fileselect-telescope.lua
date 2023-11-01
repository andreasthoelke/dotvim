local M = {}

local actions = require("telescope.actions")
local resume = require("telescope.builtin").resume
local action_set = require "telescope.actions.set"
local trouble = require("trouble.providers.telescope")
local easypick = require("easypick")
local f = require 'utils.functional'
local s = require 'utils.string'

-- ─   Helpers                                          ──

local action_state = require "telescope.actions.state"

local function get_path_link()
  local selection = action_state.get_selected_entry()
  -- putt( selection )

  local path, link

  -- CASE: Keymaps picker
  if     vim.tbl_get( selection, 'mode' ) ~= nil and vim.tbl_get( selection, 'lhs' ) ~= nil then
    -- local keymap_props = require 'utils.general'.Keymap_props( selection.mode, selection.lhs )
    local keymap_props = Keymap_props( selection.mode, selection.lhs )
    path = keymap_props.filename
    link = {
      lnum = keymap_props.lnum,
      col = 1
    }

    -- CASE: Vim help tags. This picker provides a search command field(?!) ~/.config/nvim/plugged/telescope.nvim/lua/telescope/builtin/__internal.lua‖/cmdˍ=ˍfield
    --                      An alternative approach would be to change the NewBuf command to include "help" like here: ~/.config/nvim/plugged/telescope.nvim/lua/telescope/builtin/__internal.lua‖/elseifˍcmdˍ
  elseif vim.tbl_get( selection, 'cmd' ) ~= nil then
    path = vim.tbl_get( selection, 'filename' )
    link = {
      searchTerm = vim.tbl_get( selection, 'cmd' )
    }

    -- CASE: Filename pickers with optional linenum and cursor column
  elseif vim.tbl_get( selection, 'filename' ) ~= nil then
    path = vim.tbl_get( selection, 'filename' )
    link = {
      lnum = vim.tbl_get( selection, 'lnum' ),
      col  = vim.tbl_get( selection, 'col' )
    }

  else
    path = vim.tbl_get( selection, 'value' )
    link = {
      lnum = vim.tbl_get( selection, 'lnum' ),
      col  = vim.tbl_get( selection, 'col' )
    }
  end
  return path, link
end

function _G.Defer_cmd( cmd, timeout )
  vim.defer_fn( vim.cmd( cmd ), timeout )
end


local NewBuf = f.curry( function( adirection, pbn )
  -- We always temp-close the prompt, then run the NewBuf action and link focus
  actions.close( pbn )
  -- Closing the picker before we process the path_link, brings the cursor and focus back to the previous buffer, which allows to e.g. run "verb map" and perhaps access some buffer vars(?)

  local fpath, maybeLink = get_path_link()
  local direction, maybe_back = table.unpack( vim.fn.split( adirection, [[_]] ) )
  local cmd = vim.fn.NewBufCmds( fpath, vim.fn.winnr '#' )[ direction ]

  -- putt( adirection )
  -- putt( cmd )
  -- putt( maybeLink )

  -- Open the new buffer
  vim.cmd( cmd )

  if maybeLink ~= nil and vim.tbl_get( maybeLink, 'lnum' ) then
    vim.api.nvim_win_set_cursor( 0, {maybeLink.lnum, maybeLink.col -1})
    vim.cmd 'normal zz'
  elseif maybeLink ~= nil and vim.tbl_get( maybeLink, 'searchTerm' ) then
    vim.fn.search( s.tail( maybeLink.searchTerm ), "cw" )
  end

  if     adirection == 'tab_bg' then     -- opened to the right in the background
    vim.cmd 'tabprevious'
  elseif adirection == 'tab_back' then --   open and go to new tab, then jump *back* to prompt
    -- nothing needed, resume will open in new tab.
  end

  if maybe_back then
    resume()
  end

end)



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
        ["<c-j>"] = function() vim.fn.feedkeys( ".*" ) end,


-- ─   NewBuf maps i                                    ──
        -- NewBuf is consistent with ~/.config/nvim/plugin/NewBuf-direction-maps.vim‖/LINE-WORD

        ['<c-w>p'] = NewBuf 'preview_back',
        ['<c-w>o'] = NewBuf 'float',
        ['<c-w>i'] = NewBuf 'full',
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



        ["<leader><c-o>"] = trouble.open_with_trouble,
        ["<c-q>"] = actions.send_selected_to_qflist,
        ["<c-d>"] = actions.delete_buffer,
        ["<C-p>"] = actions.cycle_previewers_next,
        ["m"] = { actions.toggle_selection, type = "action", opts = { nowait = true } },
        [",m"] = actions.select_all,
        [",M"] = actions.drop_all,
        -- ["uu"] = { "<cmd>echo \"Hello, World!\"<cr>", type = "command" },

        -- ["<esc>"] = actions.close,
        -- ["<CR>"] = actions.select_default,
        -- ["s"] = actions.select_horizontal,
        -- ["v"] = actions.select_vertical,
        -- ["t"] = actions.select_tab,
        ["<c-y>"] = actions.preview_scrolling_up,
        ["<c-e>"] = actions.preview_scrolling_down,
        -- ["n"] = actions.cycle_history_next,
        -- ["p"] = actions.cycle_history_prev,
        -- ["j"] = actions.move_selection_next,
        -- ["k"] = actions.move_selection_previous,
        -- ["c"] = actions.close,
        -- ["q"] = actions.send_to_qflist + actions.open_qflist,
        -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

      },
    },
    layout_strategy = 'vertical',
    sorting_strategy = 'ascending',
    scroll_strategy = 'limit',
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
        width = 0.47,
        height = 0.68,
        anchor = 'E',
        dynamic_preview_title = true,
        prompt_position = 'top',
        sorting_strategy = 'ascending',
        scroll_speed = 1,
        preview_height = 0.5,
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


return M








