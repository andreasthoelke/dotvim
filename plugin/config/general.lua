

-- tempoary!
_G.vim.deprecate = function() end

if vim.g.neovide then
  -- vim.o.guifont = "Source Code Pro:h10.5" -- text below applies for VimScript
  vim.o.guifont = "MonoLisa Nerd Font:h10.5" -- text below applies for VimScript

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 3
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 1

  vim.g.neovide_remember_window_size = true

  vim.g.neovide_cursor_animation_length = 0.0021

  -- vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i:ver25-Cursor/lCursor,r-cr:hor20,o:hor50"
  vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
  -- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
  -- vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
  -- vim.cmd[[highlight Cursor guifg=NONE guibg=NONE gui=reverse]]

  vim.g.neovide_position_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.1

  vim.g.neovide_hide_mouse_when_typing = true
  -- vim.g.neovide_scroll_animation_far_lines = 1

  -- vim.g.neovide_position_animation_length = 0
  -- vim.g.neovide_cursor_trail_size = 0
  -- vim.g.neovide_cursor_animate_in_insert_mode = false
  -- vim.g.neovide_cursor_animate_command_line = false
  -- vim.g.neovide_scroll_animation_far_lines = 0
  -- vim.g.neovide_scroll_animation_length = 0.00

end


-- if vim.g.vscode then
-- print('this runs?')
-- vim.api.nvim_exec([[
--   augroup CustomSilentErrors
--     autocmd!
--     autocmd TextChangedI * lua << EOF
--       local original_notify = vim.notify
--       function vim.notify(msg, level, opts)
--         if msg:match("Error executing lua callback") then
--           return
--         end
--         original_notify(msg, level, opts)
--       end
--       -- Your original autocommand logic here
--     EOF
--   augroup END
-- ]], false)
-- end

-- Example usage:
-- Instead of using :execute, use :SilentExecute
-- :SilentExecute 'echo "This will not throw an error"'


-- https://github.com/nvim-tree/nvim-tree.lua
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- call the global vim function NewBuf_fromLine

-- vim.fn.NewBuf_fromLine("right")
-- .gitignore

-- i don't this this is needed:
vim.opt.shell = "/bin/zsh"
vim.opt.shellcmdflag = "-l -c"

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



require('browser_bookmarks').setup({
 selected_browser = "chrome"
})

require('telescope').load_extension('bookmarks')

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


-- ─   Markdown                                          ■



local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap

-- using 
function MarkdownBufferMapsLua()
  -- follow md links
  -- nvim_buf_set_keymap(0, 'n', '<c-]>', ':lua require("follow-md-links").follow_link()<cr>', {noremap = true, silent = true})
  -- nvim_buf_set_keymap(0, 'n', 'H', ':edit #<cr>', {noremap = true, silent = true})
end



-- use :Glow to preview a markdown file. or rather 'glow' in the terminal for a .md file explorer!
require('glow').setup({
  glow_path = "/opt/homebrew/bin/glow", -- will be filled automatically with your glow bin in $PATH, if any
  -- install_path = "/opt/homebrew/bin/glow", -- default path for installing glow binary
  border = "shadow", -- floating window border config
  style = "dark", -- filled automatically with your current editor background, you can override using glow json style
  pager = false,
  width = 80,
  height = 100,
  width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
  height_ratio = 0.7,
})






-- ─^  Markdown                                          ▲



-- make a map!
-- require'notify'.history()
    -- message = { "Failed to modify settings", "", "Please modify following settings manually:", "* `Lua.workspace.checkThirdParty`: set to `false` ;", "" },
    -- render = <function 2>,
    -- time = 1697216734,
    -- title = { "LSP Message (lua_ls)", "19:05:34" }

-- vim.cmd([[command! Notifications :lua require("notify")._print_history( { } )<CR>]])

-- require("notify")._print_history( { } )<CR>]])


-- vim.keymap.set( 'n',
--   '<leader>sm', function()
--     local hist = require( 'notify' ).history()
--     putt( hist )
--   end
-- )














