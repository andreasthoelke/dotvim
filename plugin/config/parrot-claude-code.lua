

-- Lines breaks in claude-code and terminal buffers!
vim.api.nvim_set_keymap('t', '<C-CR>', '<A-CR>', {noremap = true})
-- See ~/.local/share/nvim/parrot/chats/2025-03-23.17-25-57.276.md

-- vim.keymap.set('v', '<c-g>p', ':Mga paste-selection_claude<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('x', '<leader><leader>bn', ':<C-u>lua PrintVisualSelection()<CR>', {noremap = true, silent = true})


vim.keymap.set( 'n',
  '<c-g>p', function()
    local lines = GetParagraphLines()
    local lines_joined = table.concat(lines, "\n")
    Claude_send( lines_joined )
  end )

vim.keymap.set( 'v',
  '<c-g>p', function()
    local lines = GetVisualSelection()
    local lines_joined = table.concat(lines, "\n")
    Claude_send( lines_joined )
  end )

vim.keymap.set( 'n',
  "<c-g>'", function()
    local clipboard_text = vim.fn.getreg('"')
    Claude_send( clipboard_text )
  end )

vim.keymap.set( 'n',
  '<c-g>i', function()
    -- OTHER_EVENTS:
    -- Trigger other commands in the claude repl:
    -- Send escape: (\<Esc> in vimscript)
    -- Claude_send(string.char(27))
    -- Enter insert mode (i actually need to send this before sending text! Rather <esc>i to make sure we were in normal mode)
    -- Claude_send( "i" )
    Claude_send( "\r" )
  end )


function _G.Claude_send(text)
  -- Get the Claude job ID from the global Vim variable
  local job_id = vim.g.claude_job_id
  -- echo b:terminal_job_id
  -- local job_id = 116

  -- Check if the job ID exists
  if not job_id then
    vim.api.nvim_echo({{
      "Error: g:claude_job_id is not set. Please start Claude first.",
      "ErrorMsg"
    }}, true, {})
    return false
  end
  
  -- Send the text on the channel
  vim.fn.chansend(job_id, text)
  return true
end

-- Claude_send("hi there")

-- c-g i   - run / execute current buffer
-- c-g p   - paste paragraphppj


function _G.GetParagraphLines()
  -- Save cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1]

  -- Find paragraph boundaries
  local start_line = current_line
  local end_line = current_line
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find the start of the paragraph by moving up until an empty line or buffer start
  while start_line > 1 and lines[start_line-1]:match("^%s*[^%s]") do
    start_line = start_line - 1
  end

  -- Find the end of the paragraph by moving down until an empty line or buffer end
  while end_line < #lines and lines[end_line+1]:match("^%s*[^%s]") do
    end_line = end_line + 1
  end
  
  -- Get the paragraph lines (convert 1-based indices to 0-based for nvim_buf_get_lines)
  local paragraph_lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)

  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)

  return paragraph_lines
end


vim.api.nvim_create_user_command("PrintParagraph", function()
  local lines = GetParagraphLines()
  vim.print(lines)
end, {})


function _G.GetVisualSelection()
  -- Get the line and column of the start of the visual selection
  local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
  -- Get the line and column of the end of the visual selection
  local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))
  
  -- Adjust for 0-indexing in the nvim_buf_get_lines function
  start_line = start_line - 1
  end_line = end_line - 1
  
  -- Get the lines of the visual selection
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
  
  -- If there's only one line in the selection, trim it based on start and end columns
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col + 1, end_col + 1)
  else
    -- Otherwise, trim the first and last lines
    lines[1] = string.sub(lines[1], start_col + 1)
    lines[#lines] = string.sub(lines[#lines], 1, end_col + 1)
  end
  
  return lines
end

vim.api.nvim_set_keymap('x', '<leader><leader>bn', ':<C-u>lua PrintVisualSelection()<CR>', {noremap = true, silent = true})

function PrintVisualSelection()
  local selected_lines = GetVisualSelection()
  -- Do something with the selected lines, e.g., print them
  print(vim.inspect(selected_lines))
end





