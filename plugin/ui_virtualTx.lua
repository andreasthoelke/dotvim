
-- https://jdhao.github.io/2021/09/09/nvim_use_virtual_text/#google_vignette

_G.VirtualTxShow_test = function( dispTxt, hlgroup )
  local linenr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local bnr = vim.fn.bufnr('%')
  local col_num = 0

  local padding1 = { ' ', 'CommentSection' }
  local icon = { '|', 'BlackBG' }
  local padding2 = { ' ', 'CommentSection' }
  local message = { dispTxt, hlgroup or 'CommentSection' }

  local opts = {
    -- end_line = 10,
    id = 1,
    virt_text = { padding1, icon, padding2, message },
    -- virt_text_pos = 'overlay',
    -- virt_text_pos = 'right_align',
    virt_text_pos = 'eol',
    -- virt_text_win_col = 20,

  }

  -- local mark_id = vim.api.nvim_buf_set_extmark(bnr, vim.g.nsid_def, lineNum, 0, opts)
  return vim.api.nvim_buf_set_extmark(bnr, vim.g.nsid_def, linenr, col_num, opts)
end

-- VirtualTxShow( "[22, 33]" )


_G.VirtualTxClear = function()
  vim.api.nvim_buf_del_extmark( vim.fn.bufnr('%'), vim.g.nsid_def, 1)
end
-- VirtualTxClear()

-- vim.fn.getftime("/Users/at/.config/nvim/plugin/file-manage.vim")
-- vim.fn.getftime("/Users/at/.config/nvim/plugin/functional.vim")
-- vim.fn.getftime("/Users/at/.config/nvim/plugin/functional.vim") + vim.fn.getftime("/Users/at/.config/nvim/plugin/file-manage.vim")
-- vim.fn.getftime("/Users/at/.config/nvim/plugin/file-manage.vim") - vim.fn.getftime("/Users/at/.config/nvim/plugin/functional.vim")
-- vim.fn.strftime("%d:%H:%M", vim.fn.getftime("/Users/at/.config/nvim/plugin/functional.vim"))
-- vim.loop.fs_stat("/Users/at/.config/nvim/plugin/functional.vim").mtime.sec
-- vim.loop.fs_stat("/Users/at/.config/nvim/plugin/functional.vim").size
-- vim.loop.fs_stat("/Users/at/.config/nvim/plugin/syntax")
-- vim.loop.fs_stat("/Users/at/.config/nvim/plugin/test1").size
-- vim.fn.getftime("/Users/at/.config/nvim/plugin/functional.vim")

function _G.VirtualTxShow( linenr, dispTxt, align )
  local opts = {
    id = linenr + 1, -- just a unique id in this case
    virt_text = { { dispTxt, 'CommentSection' } },
    virt_text_pos = align or 'eol',
  }
  return vim.api.nvim_buf_set_extmark(0, vim.g.nsid_def, linenr, 0, opts)
end

-- VirtualTxShow( 0, 'eins2' )
-- VirtualTxShow( 50, 'eins2', 'right_align' )


function _G.DirvishShowModified()
  local lines = vim.api.nvim_buf_get_lines( 0, 0, -1, true )
  for ln, fp in ipairs( lines ) do
    local timeModifiedInSec = vim.loop.fs_stat( fp ).mtime.sec
    local msg = TimeAgoStr( timeModifiedInSec )
    -- VirtualTxShow( ln -1, msg, 'right_align' )
    VirtualTxShow( ln -1, '  ' .. msg )
  end
end
-- DirvishShowModified()

-- Show size of files as <n> lines
-- Show size of folders as <n> files <n> lines (in total)
function _G.DirvishShowSize()
  local lines = vim.api.nvim_buf_get_lines( 0, 0, -1, true )
  for ln, fp in ipairs( lines ) do
    local linesCount = vim.fn.LinesCountOfPath( fp )
    local isDir = vim.loop.fs_stat( fp ).type == "directory"
    local msg = ""
    if isDir then
      local filesCount = vim.fn.FilesCountOfFolder( fp )
      msg = linesCount .. " l " .. filesCount .. " f"
    else
      msg = linesCount .. " l"
    end
    VirtualTxShow( ln -1, '  ' .. msg )
  end
end
-- DirvishShowModified()
-- vim.fn.LinesCountOfPath( "plugin/" )
-- vim.fn.FilesCountOfFolder( "plugin/" )
-- vim.fn.LinesCountOfPath( "plugin/" )
-- vim.fn.FilesCountOfFolder( "plugin/file-manage.vim" )
-- vim.loop.fs_stat( "plugin/file-manage.vim" )
-- vim.loop.fs_stat( "plugin/" ).type

-- from: https://github.com/f-person/lua-timeago/blob/master/init.lua
local function round(num) return math.floor(num + 0.5) end

function _G.TimeAgoStr( timeInSec )
    local now = os.time()
    local diff_seconds = os.difftime(now, timeInSec)
    -- print( diff_seconds )

    if diff_seconds < 59.5 then
      return round(diff_seconds) .. ' s'
    end


    local diff_minutes = diff_seconds / 60
    if diff_minutes < 59.5 then
        return round(diff_minutes) .. ' m'
    end

    local diff_hours = diff_minutes / 60
    if diff_hours < 23.5 then
        return round(diff_hours) .. ' h'
    end

    local diff_days = diff_hours / 24
    if diff_days < 7.5 then
        return round(diff_days) .. ' d'
    end

    local diff_weeks = diff_days / 7
    if diff_weeks < 4.5 then
        return round(diff_weeks) .. ' w'
    end

    local diff_months = diff_days / 30
    if diff_months < 11.5 then
        return round(diff_months) .. ' M'
    end

    local diff_years = diff_days / 365.25
    return round(diff_years) .. ' y'

end
-- TimeAgoStr( 0 )
-- TimeAgoStr( vim.fn.getftime("/Users/at/.config/nvim/plugin/file-manage.vim") )
-- TimeAgoStr( vim.fn.getftime("/Users/at/.config/nvim/plugin/functional.vim") )






