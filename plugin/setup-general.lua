


-- Using buffer maps here: ~/.config/nvim/plugin/tools_scala.vim‖/nnoremapˍ<silent><buffer>ˍgedˍ:TroubleToggleˍworkspace_diagnostics<cr>:callˍT_DelayedCmd(ˍ"wincmdˍp",ˍ50ˍ)<cr>
-- nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
-- Todo: make these maps general per languge and put them here or
-- ~/.config/nvim/plugin/setup-lsp.vim#/nnoremap%20<silent><buffer>%20ger

-- ─   Trouble diagnostics                              ──

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
    hover = "<leader>K", -- opens a small popup with the full multiline message
    preview = "p", -- preview the diagnostic location
    close_folds = {"zM", "zm"}, -- close all folds
    open_folds = {"zR", "zr"}, -- open all folds
    toggle_fold = {"zA", "za", "zo"}, -- toggle fold of current file
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

-- require'trouble'.open()

-- https://github.com/nvim-tree/nvim-tree.lua
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- call the global vim function NewBuf_fromLine

-- vim.fn.NewBuf_fromLine("right")
-- .gitignore


-- This function toggles between Lua and Vim filetypes
function ToggleFileType()
  if vim.bo.filetype == 'lua' then
    -- vim.bo.filetype = 'vim'
    vim.bo.filetype = 'purescript_scratch'
    vim.bo.syntax = 'purescript1'
    -- vim.fn.VimScriptSyntaxAdditions()
    -- print 'ft: vim'
    print 'ft: scratch'
  else
    vim.bo.filetype = 'lua'
    vim.fn.LuaSyntaxAdditions()
    print 'ft: lua'
  end
  vim.fn.VScriptToolsBufferMaps()
end
-- set filetype=purescript_scratch
-- set syntax=purescript1

vim.api.nvim_set_keymap('n', '<localleader><localleader>sf', ':lua ToggleFileType()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<localleader><localleader>sc', ':set filetype=purescript_scratch<cr>:set syntax=purescript1<cr>', { noremap = true, silent = true })





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


-- ─   noice & notify                                   ──

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  -- routes = {
  --   {
  --       filter = {
  --         event = "msg_show",
  --         kind = "",
  --       },
  --       opts = { skip = false },
  --   },
  -- },
})



require("notify").setup(
{
    background_colour = "NotifyBackground",
    fps = 3,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = ""
    },
    level = 2,
    minimum_width = 50,
    render = "simple",
    stages = "static",
    timeout = 4000,
    top_down = true,
  }
)


-- use :Glow to preview a markdown file. or rather 'glow' in the terminal for a .md file explorer!
require('glow').setup({
  glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
  install_path = "~/.local/bin", -- default path for installing glow binary
  border = "shadow", -- floating window border config
  style = "dark", -- filled automatically with your current editor background, you can override using glow json style
  pager = false,
  width = 80,
  height = 100,
  width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
  height_ratio = 0.7,
})

-- make a map!
-- require'notify'.history()
    -- message = { "Failed to modify settings", "", "Please modify following settings manually:", "* `Lua.workspace.checkThirdParty`: set to `false` ;", "" },
    -- render = <function 2>,
    -- time = 1697216734,
    -- title = { "LSP Message (lua_ls)", "19:05:34" }

-- vim.cmd([[command! Notifications :lua require("notify")._print_history( { } )<CR>]])

-- require("notify")._print_history( { } )<CR>]])


vim.keymap.set( 'n',
  '<leader>sm', function()
    local hist = require( 'notify' ).history()
    putt( hist )
  end
)














