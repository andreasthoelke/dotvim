



-- https://github.com/vscode-neovim/vscode-neovim?tab=readme-ov-file#%EF%B8%8F-api

if vim.g.vscode then

  local vscode = require('vscode')

  local function vscode_action(cmd, opts)
    return function()
      vscode.action(cmd, opts)
    end
  end

  vim.notify = vscode.notify
  -- vim.opt.timeoutlen = 150 -- To show whichkey without delay

  vim.keymap.set("n", "<leader>gs", vscode_action("workbench.view.explorer"))
  vim.keymap.set("n", "<leader>oa", vscode_action("workbench.action.toggleSidebarVisibility"))

  vim.g.clipboard = vim.g.vscode_clipboard


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
 
