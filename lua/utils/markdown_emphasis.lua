local M = {}

local function ordered_range(start_pos, end_pos)
  local srow = start_pos[2] - 1
  local scol = start_pos[3] - 1
  local erow = end_pos[2] - 1
  local ecol = end_pos[3]

  if srow > erow or (srow == erow and scol > ecol) then
    return erow, end_pos[3] - 1, srow, start_pos[3]
  end

  return srow, scol, erow, ecol
end

local function find_words(line, start_col, count)
  local words = {}
  local pos = 1

  while true do
    local first, last = line:find("[%w_]+", pos)
    if not first then
      break
    end

    table.insert(words, { first - 1, last })
    pos = last + 1
  end

  local first_index = nil
  for i, word in ipairs(words) do
    if start_col <= word[2] then
      first_index = i
      break
    end
  end

  if not first_index then
    return nil
  end

  local last_index = math.min(first_index + count - 1, #words)
  return words[first_index][1], words[last_index][2]
end

local function same_line_toggle(buf, row, start_col, end_col, marker)
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
  local marker_len = #marker
  local before_start = start_col - marker_len
  local after_end = end_col + marker_len

  if before_start >= 0
      and line:sub(before_start + 1, start_col) == marker
      and line:sub(end_col + 1, after_end) == marker then
    vim.api.nvim_buf_set_text(buf, row, end_col, row, after_end, {})
    vim.api.nvim_buf_set_text(buf, row, before_start, row, start_col, {})
    vim.api.nvim_win_set_cursor(0, { math.max(row + 1, 1), math.max(before_start, 0) })
    return
  end

  if end_col - start_col >= marker_len * 2
      and line:sub(start_col + 1, start_col + marker_len) == marker
      and line:sub(end_col - marker_len + 1, end_col) == marker then
    vim.api.nvim_buf_set_text(buf, row, end_col - marker_len, row, end_col, {})
    vim.api.nvim_buf_set_text(buf, row, start_col, row, start_col + marker_len, {})
    vim.api.nvim_win_set_cursor(0, { math.max(row + 1, 1), start_col })
    return
  end

  vim.api.nvim_buf_set_text(buf, row, end_col, row, end_col, { marker })
  vim.api.nvim_buf_set_text(buf, row, start_col, row, start_col, { marker })
  vim.api.nvim_win_set_cursor(0, { math.max(row + 1, 1), start_col + marker_len })
end

local function range_toggle(buf, srow, scol, erow, ecol, marker)
  if srow == erow then
    same_line_toggle(buf, srow, scol, ecol, marker)
    return
  end

  local marker_len = #marker
  local first_line = vim.api.nvim_buf_get_lines(buf, srow, srow + 1, false)[1] or ""
  local last_line = vim.api.nvim_buf_get_lines(buf, erow, erow + 1, false)[1] or ""

  if scol >= marker_len
      and first_line:sub(scol - marker_len + 1, scol) == marker
      and last_line:sub(ecol + 1, ecol + marker_len) == marker then
    vim.api.nvim_buf_set_text(buf, erow, ecol, erow, ecol + marker_len, {})
    vim.api.nvim_buf_set_text(buf, srow, scol - marker_len, srow, scol, {})
    vim.api.nvim_win_set_cursor(0, { math.max(srow + 1, 1), math.max(scol - marker_len, 0) })
    return
  end

  vim.api.nvim_buf_set_text(buf, erow, ecol, erow, ecol, { marker })
  vim.api.nvim_buf_set_text(buf, srow, scol, srow, scol, { marker })
  vim.api.nvim_win_set_cursor(0, { math.max(srow + 1, 1), scol + marker_len })
end

local function remove_span_at_cursor(buf, row, col, marker)
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
  local marker_len = #marker
  local search_start = 1

  while true do
    local open_first, open_last = line:find(marker, search_start, true)
    if not open_first then
      return false
    end

    local close_first, close_last = line:find(marker, open_last + 1, true)
    if not close_first then
      return false
    end

    local open_col = open_first - 1
    local close_col = close_first - 1
    local close_end_col = close_last

    if col >= open_col and col <= close_end_col then
      vim.api.nvim_buf_set_text(buf, row, close_col, row, close_col + marker_len, {})
      vim.api.nvim_buf_set_text(buf, row, open_col, row, open_col + marker_len, {})
      vim.api.nvim_win_set_cursor(0, { math.max(row + 1, 1), open_col })
      return true
    end

    search_start = close_last + 1
  end
end

function M.toggle_word(marker)
  local buf = vim.api.nvim_get_current_buf()
  local count = vim.v.count1
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
  local start_col, end_col = find_words(line, col, count)

  if not start_col then
    return
  end

  same_line_toggle(buf, row, start_col, end_col, marker)
end

function M.toggle_visual(marker)
  local buf = vim.api.nvim_get_current_buf()
  local srow, scol, erow, ecol = ordered_range(vim.fn.getpos("'<"), vim.fn.getpos("'>"))
  range_toggle(buf, srow, scol, erow, ecol, marker)
end

function M.remove_span_at_cursor(marker)
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]

  remove_span_at_cursor(buf, row, col, marker)
end

return M
