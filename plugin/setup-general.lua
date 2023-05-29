


-- Using buffer maps here: ~/.config/nvim/plugin/tools_rescript.vim#/nnoremap%20<silent><buffer>%20ged
-- nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
-- Todo: make these maps general per languge and put them here or
-- ~/.config/nvim/plugin/setup-lsp.vim#/nnoremap%20<silent><buffer>%20ger


local trouble = require("trouble").setup {
  position = "bottom", -- position of the list can be: bottom, top, left, right
  height = 8, -- height of the trouble list when position is top or bottom
  width = 50, -- width of the list when position is left or right
  icons = true, -- use devicons for filenames
  mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  fold_open = "", -- icon used for open folds
  fold_closed = "", -- icon used for closed folds
  group = true, -- group results by file
  padding = false, -- add an extra new line on top of the list
  action_keys = { -- key mappings for actions in the trouble list
    -- map to {} to remove a mapping, for example:
    -- close = {},
    close = "q", -- close the list
    cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
    refresh = "r", -- manually refresh
    jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
    open_split = { "<c-x>" }, -- open buffer in new split
    open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
    open_tab = { "<c-t>" }, -- open buffer in new tab
    jump_close = {"o"}, -- jump to the diagnostic and close the list
    toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
    toggle_preview = "P", -- toggle auto_preview
    hover = "K", -- opens a small popup with the full multiline message
    preview = "p", -- preview the diagnostic location
    close_folds = {"zM", "zm"}, -- close all folds
    open_folds = {"zR", "zr"}, -- open all folds
    toggle_fold = {"zA", "za"}, -- toggle fold of current file
    previous = "k", -- preview item
    next = "j" -- next item
  },
  indent_lines = false, -- add an indent guide below the fold icons
  auto_open = false, -- automatically open the list when you have diagnostics
  auto_close = false, -- automatically close the list when you have no diagnostics
  auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
  auto_fold = false, -- automatically fold a file trouble list at creation
  auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
  signs = {
    -- icons / text used for a diagnostic
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "﫠"
  },
  use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}

-- https://github.com/nvim-tree/nvim-tree.lua
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true


-- ─   Nvim Tree                                        ──

-- maps: ~/.config/nvim/plugin/file-manage.vim#/nnoremap%20<silent>%20<leader>nf
-- highlights: ~/.config/nvim/colors/munsell-blue-molokai.vim#/Nvim%20Tree

local lib = require("nvim-tree.lib")

function _G.TreeNode()
  vim.pretty_print( require("nvim-tree.lib").get_node_at_cursor().absolute_path )
end

local tree_setBaseDir = function()
  local api = require("nvim-tree.api")
  -- local dir = vim.fn.expand('%:p:h')
  local dir = lib.get_node_at_cursor().absolute_path
  -- put( dir )
  api.tree.change_root(dir)
end

local tree_openFolderDirvish = function()
  -- local api = require("nvim-tree.api")
  local dir = lib.get_node_at_cursor().absolute_path
  vim.cmd "wincmd p"
  vim.cmd.edit( dir )
end

local tree_viewPathInPrevWin = function()
  -- local api = require("nvim-tree.api")
  local dir = lib.get_node_at_cursor().absolute_path
  vim.cmd "wincmd p"
  vim.cmd.edit( dir )
  vim.cmd "wincmd p"
end



local tree_root_folder_label = function(path)
  -- return ".../" .. vim.fn.fnamemodify(path, ":t")
  local lpath = vim.split( path, [[/]] )
  local dir = lpath[ #lpath ]
  local parentDir = lpath[ #lpath -1 ]
  local parentStr = vim.fn.strpart( parentDir, 0, 4 )
  -- return parentStr .. " /" .. dir
  -- return dir .. " (" .. parentStr .. ")"
  return dir .. " |" .. parentDir
end
-- vim.split( "/User/at/Docs/eins", [[/]] )[2]
-- vim.fn.strpart("einszwei", 1, 2)


local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local function open_tab_silent(node)
  local api = require("nvim-tree.api")
  api.node.open.tab(node)
  vim.cmd.tabprev()
end


-- command! -nargs=1 DirvishFloat1 call Dirvish_Float( <args> )
vim.cmd("command! -nargs=1 NvimTreeRevealFile lua NvimTree_find_file( <args> )")



--
-- This function has been generated from your
--   view.mappings.list
--   view.mappings.custom_only
--   remove_keymaps
--
-- You should add this function to your configuration and set on_attach = on_attach in the nvim-tree setup call.
--
-- Although care was taken to ensure correctness and completeness, your review is required.
--
-- Please check for the following issues in auto generated content:
--   "Mappings removed" is as you expect
--   "Mappings migrated" are correct
--
-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
--


local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  -- vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  -- see the custom maps for these: <leader>G in this case
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  -- vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH


  -- Mappings removed via:
  --   remove_keymaps
  --   OR
  --   view.mappings.list..action = ""
  --
  -- The dummy set before del is done for safety, in case a default mapping does not exist.
  --
  -- You might tidy things by removing these along with their default mapping.
  vim.keymap.set('n', 'd', '', { buffer = bufnr })
  vim.keymap.del('n', 'd', { buffer = bufnr })
  vim.keymap.set('n', 'e', '', { buffer = bufnr })
  vim.keymap.del('n', 'e', { buffer = bufnr })
  vim.keymap.set('n', '.', '', { buffer = bufnr })
  vim.keymap.del('n', '.', { buffer = bufnr })
  vim.keymap.set('n', 's', '', { buffer = bufnr })
  vim.keymap.del('n', 's', { buffer = bufnr })
  vim.keymap.set('n', 'c', '', { buffer = bufnr })
  vim.keymap.del('n', 'c', { buffer = bufnr })
  vim.keymap.set('n', 'D', '', { buffer = bufnr })
  vim.keymap.del('n', 'D', { buffer = bufnr })
  vim.keymap.set('n', '<C-k>', '', { buffer = bufnr })
  vim.keymap.del('n', '<C-k>', { buffer = bufnr })
  vim.keymap.set('n', '<C-j>', '', { buffer = bufnr })
  vim.keymap.del('n', '<C-j>', { buffer = bufnr })


  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'i', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'p', api.node.open.preview, opts('Open Preview'))
  vim.keymap.set('n', '<leader>dd', api.fs.trash, opts('Trash'))
  vim.keymap.set('n', '<leader>yy', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', '<leader>re', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', '<leader>I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
  vim.keymap.set('n', '<leader>G', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
  vim.keymap.set('n', '<leader>/', api.tree.search_node, opts('Search'))
  vim.keymap.set('n', '<leader>rf', api.node.run.cmd, opts('Run Command'))
  vim.keymap.set('n', '<leader>so', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', '<leader>re', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', '<leader>pp', function()
    local node = api.tree.get_node_under_cursor()
    -- your code goes here
    node.fs.paste()
  end, opts('paste_file'))

  vim.keymap.set('n', '<leader>pP', function()
    local node = api.tree.get_node_under_cursor()
    -- your code goes here
    node.fs.paste_cut_file()
  end, opts('paste_cut_file'))

  vim.keymap.set('n', '<leader>o', function()
    -- local node = api.tree.get_node_under_cursor()
    -- your code goes here
    tree_openFolderDirvish()
  end, opts('dirvish_folder'))

  vim.keymap.set('n', '<leader>i', function()
    -- local node = api.tree.get_node_under_cursor()
    -- your code goes here
    tree_viewPathInPrevWin()
  end, opts('dirvish_folder'))

  vim.keymap.set('n', '<leader>b', function()
    -- local node = api.tree.get_node_under_cursor()
    -- your code goes here
    local dir = lib.get_node_at_cursor().absolute_path
    api.tree.change_root(dir)

  end, opts('base_dir'))

  vim.keymap.set('n', 'T', function()
    local node = api.tree.get_node_under_cursor()
    -- your code goes here
    api.node.open.tab(node)
    vim.cmd.tabprev()
  end, opts('open_tab_silent'))


end



-- First expands the tree, jumps back to the original win, then highlights the path
function _G.NvimTree_find_file( path )
  local api = require("nvim-tree.api")
  api.tree.focus()
  vim.cmd('wincmd p')
  api.tree.find_file( path )
end
-- NvimTreeRevealFile "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/H_Cats.scala"
-- NvimTreeRevealFile "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/resources/day03.in"
-- NvimTreeRevealFile "/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/resources"

local function bookmNext()
  local api = require("nvim-tree.api")
  api.marks.navigate.next()
  api.marks.navigate.next()
end

local function bookmPrev()
  local api = require("nvim-tree.api")
  api.marks.navigate.prev()
  api.marks.navigate.prev()
end


local tree_api = require("nvim-tree.api")

vim.keymap.set("n", "]g", bookmNext)
vim.keymap.set("n", "[g", bookmPrev)
vim.keymap.set("n", "<leader>ms", require("nvim-tree.api").marks.navigate.select)

-- local aa = require("nvim-tree.api").fs.copy.


Nvim_tree = require("nvim-tree").setup({
  -- sort_by = "case_sensitive",
  hijack_netrw = false,
  git = {
    enable = true,
  },
  on_attach = on_attach,
  -- remove_keymaps = {"d", "e", ".", "s", "c", "D", "<C-k>", "<C-j>"},
  -- view = {
  --   width = 22,
  --   preserve_window_proportions = true,
  --   signcolumn = "yes", -- i might need this for `m`- marks
  --   mappings = {
  --     list = {
  --       -- ~/.config/nvim/plugged/nvim-tree.lua/doc/nvim-tree-lua.txt#/view.mappings.list%20=%20{
  --       { key = "i", action = "edit" },
  --       { key = "p", action = "preview" },
  --       { key = "<leader>dd", action = "trash" },
  --       { key = "<leader>yy", action = "copy" },
  --       { key = "<leader>re", action = "rename" },

  --       { key = "<leader>I", action = "toggle_git_ignored" },
  --       { key = "<leader>G", action = "toggle_git_clean" },

  --       { key = "<leader>/", action = "search_node" }, -- can use regex and expand child folders!
  --       { key = "<leader>rf", action = "run_file_command" }, -- vim shell with the abs file path
  --       -- { key = "<leader>ti", action = "toggle_file_info" }, -- errors after closing the float win
  --       { key = "<leader>so", action = "system_open" }, -- opens finder explorer

  --       { key = "<leader>re", action = "rename" },
  --       { key = "<leader>pp", action = "paste_file", action_cb = tree_api.fs.paste },
  --       { key = "<leader>pP", action = "paste_cut_file", action_cb = tree_api.fs.paste },

  --       { key = "<leader>o", action = "dirvish_folder", action_cb = tree_openFolderDirvish },
  --       { key = "<leader>i", action = "dirvish_folder", action_cb = tree_viewPathInPrevWin },
  --       { key = "<leader>b", action = "base_dir", action_cb = tree_setBaseDir },
  --       { key = "T", action = "open_tab_silent", action_cb = open_tab_silent },
  --     },
  --   },
  -- },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "name",
    -- highlight_modified = "name",
    indent_width = 1,
    root_folder_label = tree_root_folder_label,
    icons = {
      show = {
        file = true,
        folder = false,
        folder_arrow = false,
      },
      glyphs = {
        bookmark = "⠰",
        git = {
          unstaged = "₊",
          staged = "ˆ",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    }
  },
  diagnostics = {
    enable = false,
    -- show_on_dirs = true,
    -- show_on_open_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  hijack_directories = {
    enable = false,
  },
  filters = {
    dotfiles = false,
  },
  -- sync_root_with_cwd = true,
  -- update_focused_file = {
  -- enable = true,
  -- update_root = true,
  -- ignore_list = {},
  -- },
})

-- source
-- /Users/at/.config/nvim/plugged/nvim-tree.lua/

-- API
-- ~/.config/nvim/plugged/nvim-tree.lua/doc/nvim-tree-lua.txt#/-%20api.fs.%20*nvim-tree.api.fs*
-- ~/.config/nvim/plugged/nvim-tree.lua/lua/nvim-tree/actions/dispatch.lua#/--%20Tree%20modifiers

-- https://github.com/dhruvmanila/browser-bookmarks.nvim
-- local bookmlib = require('browser-bookmarks').setup({
--   -- override default configuration values
--   selected_browser = 'chrome',
-- })

-- vim.keymap.set(
--   'n', '<leader>fb',
--   require('browser-bookmarks').select, {
--     desc = 'Fuzzy search browser bookmarks',
--   })

local telescLib = require('telescope').load_extension('bookmarks')

-- vim.keymap.set(
--   'n', '<leader>tb',
--     require('telescope').extensions.bookmarks.bookmarks()
--   )








