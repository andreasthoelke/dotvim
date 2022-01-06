
-- https://jdhao.github.io/2021/09/09/nvim_use_virtual_text/#google_vignette

_G.VirtualTxShow = function( dispTxt, hlgroup )
  local linenr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local bnr = vim.fn.bufnr('%')
  local col_num = 0

  local padding1 = { ' ', 'Comment' }
  local icon = { '|', 'BlackBG' }
  local padding2 = { ' ', 'Comment' }
  local message = { dispTxt, hlgroup or 'Comment' }

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

-- lua VirtualTxShow( "[22, 33]" )


_G.VirtualTxClear = function()
  vim.api.nvim_buf_del_extmark( vim.fn.bufnr('%'), vim.g.nsid_def, 1)
end












