
require'hop'.setup()

vim.api.nvim_set_keymap('n', ',j', "<cmd>HopLineStartAC<cr>", {noremap=true})
vim.api.nvim_set_keymap('n', ',k', "<cmd>HopLineStartBC<cr>", {noremap=true})

vim.api.nvim_set_keymap('n', 'f', "<cmd>HopChar1CurrentLineAC<cr>", {noremap=true})
vim.api.nvim_set_keymap('x', 'f', "<cmd>HopChar1CurrentLineAC<cr>", {noremap=true})
vim.api.nvim_set_keymap('o', 'f', "<cmd>HopChar1CurrentLineAC<cr>", {noremap=true})

vim.api.nvim_set_keymap('n', 'F', "<cmd>HopChar1CurrentLineBC<cr>", {noremap=true})
vim.api.nvim_set_keymap('x', 'F', "<cmd>HopChar1CurrentLineBC<cr>", {noremap=true})
vim.api.nvim_set_keymap('o', 'F', "<cmd>HopChar1CurrentLineBC<cr>", {noremap=true})

vim.api.nvim_set_keymap('n', ',f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('n', ',F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})

-- Operator pending map: yd "yank down"
vim.keymap.set('o', 'd', function()
    -- Set operator as linewise
    vim.cmd('normal! V')
    require'hop'.hint_lines({
        multi_windows = false,
        hint_position = require'hop.hint'.HintPosition.BEGIN,
        direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
        current_line_only = false
    })
end, {remap=true})


