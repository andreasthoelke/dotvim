
require'hop'.setup()

vim.api.nvim_set_keymap('n', ',j', "<cmd>HopLineStartAC<cr>", {noremap=true})
vim.api.nvim_set_keymap('x', ',j', "<cmd>HopLineStartAC<cr>", {noremap=true})
-- testing these alternatives - see below
-- vim.api.nvim_set_keymap('n', ',q', "<cmd>HopLineStartAC<cr>", {noremap=true})
-- vim.api.nvim_set_keymap('n', ',m', "<cmd>HopLineStartAC<cr>", {noremap=true})

-- These select only the first char of the last line - see the versions below
-- vim.api.nvim_set_keymap('o', ',j', "<cmd>HopLineStartAC<cr>", {noremap=true})
-- vim.api.nvim_set_keymap('o', 'q', "<cmd>HopLineStartAC<cr>", {noremap=true})
-- vim.api.nvim_set_keymap('o', 'Q', "<cmd>HopLineStartBC<cr>", {noremap=true})

vim.api.nvim_set_keymap('n', ',k', "<cmd>HopLineStartBC<cr>", {noremap=true})

vim.api.nvim_set_keymap('n', 'f', "<cmd>HopChar1CurrentLineAC<cr>", {noremap=true})
vim.api.nvim_set_keymap('x', 'f', "<cmd>HopChar1CurrentLineAC<cr>", {noremap=true})
vim.api.nvim_set_keymap('o', 'f', "<cmd>HopChar1CurrentLineAC<cr>", {noremap=true})

vim.api.nvim_set_keymap('n', 'F', "<cmd>HopChar1CurrentLineBC<cr>", {noremap=true})
vim.api.nvim_set_keymap('x', 'F', "<cmd>HopChar1CurrentLineBC<cr>", {noremap=true})
vim.api.nvim_set_keymap('o', 'F', "<cmd>HopChar1CurrentLineBC<cr>", {noremap=true})


-- ─   Hop across lines                                  ■
-- Keep original maps as reference.
-- vim.api.nvim_set_keymap('n', ',f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
-- vim.api.nvim_set_keymap('n', ',F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})




-- ─^  Hop across lines                                  ▲


-- Operator pending map: "yank down"
-- vim.keymap.set('o', 'j', function()
--     -- Set operator as linewise
--     vim.cmd('normal! V')
--     -- Wrap the hop.hint_lines call in pcall to catch errors
--     pcall(function()
--         require'hop'.hint_lines({
--             multi_windows = false,
--             hint_position = require'hop.hint'.HintPosition.BEGIN,
--             direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
--             current_line_only = false
--         })
--     end)
-- end, {remap=true})

local op_hopdown = function()
    -- Set operator as linewise
    vim.cmd('normal! V')
    -- Wrap the hop.hint_lines call in pcall to catch errors
    pcall(function()
    require'hop'.hint_lines({
      multi_windows = false,
      hint_position = require'hop.hint'.HintPosition.BEGIN,
      direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
      current_line_only = false
    })
  end)
end

-- yq or gem seem ergonomic. while i can keep j for single line down
for _, key in ipairs({'q', 'm'}) do
  vim.keymap.set('o', key, op_hopdown)
end


-- Operator pending map: "yank up"
vim.keymap.set('o', 'Q', function()
    -- Set operator as linewise
    vim.cmd('normal! V')
    -- Wrap the hop.hint_lines call in pcall to catch errors
    pcall(function()
        require'hop'.hint_lines({
            multi_windows = false,
            hint_position = require'hop.hint'.HintPosition.BEGIN,
            direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
            current_line_only = false
        })
    end)
end, {remap=true})


-- Operator pending map: equivalent to Sneak's t mapping
vim.keymap.set('o', 't', function()
    require'hop'.hint_char1({
        multi_windows = false,
        hint_position = require'hop.hint'.HintPosition.BEGIN,
        direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1  -- Jump one character before the target
    })
end, {remap=true})

-- Operator pending map: similar to 't' but works across multiple lines
vim.keymap.set('o', ',t', function()
    require'hop'.hint_char1({
        multi_windows = false,
        hint_position = require'hop.hint'.HintPosition.BEGIN,
        direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
        current_line_only = false,
        hint_offset = -1  -- Jump one character before the target
    })
end, {remap=true})

-- Operator pending map: similar to 'f' but works across multiple lines
vim.keymap.set('o', ',f', function()
    require'hop'.hint_char1({
        multi_windows = false,
        hint_position = require'hop.hint'.HintPosition.BEGIN,
        direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
        current_line_only = false,
        hint_offset = 0  -- Jump on the target
    })
end, {remap=true})

