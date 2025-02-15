
require('mini.colors').setup({})
-- require('mini.colors').interactive()

local hi = vim.api.nvim_set_hl
-- hi(0, "Function", { ctermfg = 14, fg = "#017ea4" })
-- hi(0, "Function", { ctermfg = 14, fg = "#006B8B" })
-- hi(0, "CommentMinus", { fg = "#acc1c9" })

-- + readability of light theme
-- hi(0, "CommentMinus", { fg = "#809CA7" })
-- hi(0, "@spell.markdown", { fg = "#557680" })

hi(0, "htmlBold", { fg = "#35758a" })


local cs = MiniColors.get_colorscheme()

-- cs:write()

-- Invert dark/light color scheme to be light/dark
-- cs:chan_invert('lightness', { gamut_clip = 'cusp' }):apply()

-- Play with these two:
-- cs:chan_invert('temperature'):apply()
-- cs:chan_invert('pressure'):apply()

-- cs:chan_add('lightness', -10, { filter = 'fg' }):apply()

-- cs:chan_add('pressure', 20,  { filter = 'fg' }):apply()
-- cs:chan_add('pressure', -20,  { filter = 'fg' }):apply()

-- Generally add more color.
-- cs:chan_add('saturation', 10,  { filter = 'fg' }):apply()
-- cs:chan_set('hue', 135):add_cterm_attributes():apply()
-- cs:chan_add('hue', -10):add_cterm_attributes():apply()


-- cs:chan_set('lightness', 15, { filter = 'bg' }):apply()
-- cs:chan_set('lightness', 85, { filter = 'fg' }):apply()
-- cs:chan_set('saturation', 0):apply()



-- Ensure constant contrast ratio
-- -- Higher contrast but too harsh, seems loose all colors.
-- cs:chan_set('lightness', 35, { filter = 'fg' }):apply()
-- cs:chan_set('lightness', 15, { filter = 'bg' }):apply()



