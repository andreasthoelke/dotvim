local M = {}

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
local easypick = require("easypick")

-- Note these default maps https://github.com/nvim-telescope/telescope.nvim\#default-mappings
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    path_display = { 'shorten' },
    initial_mode = 'normal',
    mappings = {
      i = {
        ["<c-o>"] = trouble.open_with_trouble
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<C-h>"] = "which_key"
      },
      n = {
        ["<c-o>"] = trouble.open_with_trouble
      },
    },
    layout_strategy = 'vertical',
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
require("telescope").load_extension( "file_browser" )
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








