local colors = {

  Comment           = '#344B53',
  CommentMinus      = '#273A40',
  CommentMinusMinus = '#1D2B2F',
  CommentSection    = '#0E0E0E',
  BlackBGsoft       = '#101010',

  white = "#D3C6AA",
  darker_black = "#272f35",
  black = "#2b3339", --  nvim bg
  black2 = "#323a40",
  one_bg = "#333b41",
  one_bg2 = "#363e44",
  one_bg3 = "#3a4248",
  telescope_bg = "#3a4248",
  grey = "#4a5258",
  grey_fg = "#50585e",
  grey_fg2 = "#5e666c",
  light_grey = "#61696f",
  telescope_prompt = "#4a5258",
}

-- function _G.Tabs_active()
--   -- local f = io.open('tabsevent.txt', 'a')
--   -- f:write(vim.inspect(section) .. '\n')
--   return 'LuLine_c'
-- end

-- function _G.Tabs_inactive()
--   -- NOTE i could highlight inactive depending on e.g. their type?
--   return 'LuLine_c_i'
-- end

-- require('lualine').refresh()

-- ─   Theme                                            ──

function _G.Theme_grbox2()
  return {

    normal = {
      a = 'LuLine_a',
      b = 'LuLine_b',
      c = 'LuLine_c',
      x = 'LuLine_x',
      y = 'LuLine_y',
      z = 'LuLine_z',
    },

    inactive = {
      a = 'LuLine_a_i',
      b = 'LuLine_b_i',
      c = 'LuLine_c_i',
      x = 'LuLine_x_i',
      y = 'LuLine_y_i',
      z = 'LuLine_z_i',
    }
  }
end


function _G.Theme_grbox1() -- ■
  return {
    normal = {
      a = {bg = colors.gray, fg = colors.black, gui = 'bold'},
      -- a = {bg = colors.gray, fg = colors.black},
      b = {bg = colors.lightgray, fg = colors.white},
      c = {bg = colors.darkgray, fg = colors.gray},
      x = {bg = colors.gray, fg = colors.white},
      y = {bg = colors.lightgray, fg = colors.white},
      z = {bg = colors.gray, fg = colors.black},
    },
    inactive = {
      a = {bg = colors.BlackBGsoft, fg = colors.gray, gui = 'bold'},
      b = {bg = colors.darkgray, fg = colors.gray},
      c = {bg = colors.darkgray, fg = colors.gray}
    }
  }
end -- ▲



return colors
