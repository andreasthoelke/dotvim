


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



vim.keymap.set("n", "]g", bookmNext)
vim.keymap.set("n", "[g", bookmPrev)
vim.keymap.set("n", "<leader>ms", require("nvim-tree.api").marks.navigate.select)


Nvim_tree = require("nvim-tree").setup({
  -- sort_by = "case_sensitive",
  hijack_netrw = false,
  git = {
    enable = true,
  },
  remove_keymaps = {"<C-k>", "<C-j>"},
  view = {
    width = 28,
    signcolumn = "yes", -- i might need this for `m`- marks
    mappings = {
      list = {
        -- ~/.config/nvim/plugged/nvim-tree.lua/doc/nvim-tree-lua.txt#/view.mappings.list%20=%20{
        { key = "i", action = "edit" },
        { key = "p", action = "preview" },
        { key = "<leader>b", action = "base_dir", action_cb = tree_setBaseDir },
        { key = "T", action = "open_tab_silent", action_cb = open_tab_silent },
      },
    },
  },
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





