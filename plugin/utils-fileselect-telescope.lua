local M = {}

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")


-- Note these default maps https://github.com/nvim-telescope/telescope.nvim\#default-mappings
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
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
    }
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




-- lua put( require'utils_general'.abc() )


return M








