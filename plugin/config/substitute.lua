

-- Configuration for substitute.nvim (replacement for EasyClip)
-- See: https://github.com/gbprod/substitute.nvim

-- Main substitution mappings (replaces EasyClip's substitute functionality)
vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- Mimic EasyClip's SS mapping
vim.keymap.set("n", "SS", require('substitute').line, { noremap = true })

require('substitute').setup({
  on_substitute = nil,
  yank_substituted_text = true, -- Similar to EasyClip behavior
  preserve_cursor_position = true, -- Replaces EasyClip's `[` behavior
  modifiers = nil,
  highlight_substituted_text = {
    enabled = true,
    timer = 700, -- Matches highlightedyank_highlight_duration
  },
  range = {
    prefix = "s",
    prompt_current_text = false,
    confirm = false,
    complete_word = false,
    subject = nil,
    range = nil,
    group_substituted_text = false, -- Required option from plugin source
    suffix = "",
    auto_apply = false,
    cursor_position = "beginning", -- Similar to EasyClip's `[
  },
  exchange = {
    motion = true, -- Enable motion for exchange functionality
    use_esc_to_cancel = true,
    preserve_cursor_position = true,
  },
})

-- Additional mappings for exchange functionality
-- This can be used as an alternative to EasyClip's move functionality
local exchange = require('substitute.exchange')
vim.keymap.set("n", "cx", exchange.operator, { noremap = true })
vim.keymap.set("n", "cxx", exchange.line, { noremap = true })
vim.keymap.set("x", "X", exchange.visual, { noremap = true })

