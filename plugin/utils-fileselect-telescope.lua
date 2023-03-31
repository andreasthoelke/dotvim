local M = {}

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
local easypick = require("easypick")


local function open_above(promtbufnr)
 return require("telescope.actions.set").edit( promtbufnr, "leftabove 13new")
end

local function open_below(promtbufnr)
 return require("telescope.actions.set").edit( promtbufnr, "20new")
end


-- NOTE: there's 
-- lua/utils_general.lua
-- with custom pickers. also this example: ~/.config/nvim/plugged/telescope.nvim/lua/telescope/builtin/__files.lua#/pickers

-- Note these default maps https://github.com/nvim-telescope/telescope.nvim\#default-mappings
Telesc = require('telescope').setup{
  defaults = {
    -- config_key = value,
    path_display = { 'shorten' },
    file_ignore_patterns = {
            '^.git/', '^target/', '^node%_modules/', '^.npm/', '^modules', 'dev.js', '%[Cc]ache/', '%-cache',
            '^scala-doc/',
    --         '%.py[co]', '%.sw?', '%~', '%.a', "%.npz", "^.vscode",
            '%.tags', 'tags', '%.gemtags',
            -- '%.csv', '%.tsv', '%.tmp',
            '%.exe', "%.dat", "^dist",
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
    mappings = {
      i = {
          -- TODO: might want to make these consistent with: ~/.config/nvim/plugin/utils-fileselect-telescope.lua#/["<c-s><c-u>"]%20=%20open_above,
          -- TODO: might want to make these consistent with: ~/.config/nvim/plugin/file-manage.vim#/Dirvish%20'newWin'%20maps
        ["<c-s><c-u>"] = open_above,
        ["<c-s><c-b>"] = open_below,
        ["<c-o>"] = trouble.open_with_trouble,
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<C-h>"] = "which_key"
      },
      n = {
        ["<c-s><c-u>"] = open_above,
        ["<c-s><c-b>"] = open_below,
        ["<c-o>"] = trouble.open_with_trouble,
        ["<c-a>"] = actions.send_selected_to_qflist,
        ["<c-d>"] = actions.delete_buffer,
        ["<C-p>"] = actions.cycle_previewers_next,
        ["m"] = { actions.toggle_selection, type = "action", opts = { nowait = true, silent = true } },
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
        width = 0.92,
        height = 0.92,
        anchor = 'NW',
        prompt_position = 'top',
        sorting_strategy = 'ascending',
        scroll_speed = 1,
        preview_height = 0.5,
      },
      vertical = {
        width = 0.92,
        height = 0.92,
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
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    -- find_files = {
    -- }


  },
  extensions = {
    heading = {
      treesitter = true,
    },
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure

  }
}

require'telescope'.load_extension('project')
require('telescope').load_extension('vim_bookmarks')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('heading')
require('telescope').load_extension('glyph')
require('telescope').load_extension('scaladex')
require('telescope').load_extension('env')
require('telescope').load_extension('ag')

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



local base_branch = "eins"

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
      command = [[rg -U '(def|extension).*(\n)?.*(\n)?.*(\n)?.*\s=\s' -g 'utils.scala' --line-number --column --with-filename --no-heading]],
      -- command = "rg List --line-number --column --with-filename --no-heading",
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



return M








