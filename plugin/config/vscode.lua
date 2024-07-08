





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

  vim.g.clipboard = vim.g.vscode_clipboard




end




