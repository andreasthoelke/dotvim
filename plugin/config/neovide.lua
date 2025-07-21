
vim.opt.linespace = 5

if not vim.g.neovide then
  return
end

-- vim.g.neovide_scale_factor = 1.0
vim.g.neovide_scale_factor = 0.99
-- vim.g.neovide_scale_factor = 1.01
-- vim.g.neovide_scale_factor = 1.035
local change_scale_factor = function(delta)
  -- vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
  print( vim.g.neovide_scale_factor )
end
vim.keymap.set( "n", "<C-=>", function()
  -- change_scale_factor( 1.01 )
  change_scale_factor( 0.0025 )
end )
vim.keymap.set("n", "<C-->", function()
  -- change_scale_factor( 1/1.01 )
  change_scale_factor( -0.0025 )
end)

-- vim.o.guifont = "Source Code Pro:h10.5" -- text below applies for VimScript
-- vim.o.guifont = "MonoLisa Nerd Font:h10.5" -- text below applies for VimScript
vim.o.guifont = "MonoLisa Nerd Font:h11" -- text below applies for VimScript

-- vim.g.neovide_text_gamma = 0.0
-- vim.g.neovide_text_contrast = 0.5

vim.g.neovide_text_gamma = 0.8
vim.g.neovide_text_contrast = 0.1

-- vim.g.neovide_frame = "buttonless"
-- vim.g.neovide_title_hidden = true

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 3
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 1

vim.g.neovide_remember_window_size = true

-- vim.g.neovide_cursor_animation_length = 0.0021
vim.g.neovide_cursor_animation_length = 0

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

