

function _G.ParrotBuf_GetMessages()
  local chat_utils = require("parrot.chat_utils")
  local result = chat_utils.get_chat_messages()
  return result
end

function _G.ParrotBuf_GetLatestUserMessage()


end

vim.keymap.set('n', '<c-g><c-j>', function()
  local msgs = ParrotBuf_GetMessages()
  putt( msgs )
  -- Claude_send(text)
end)


-- Lines breaks in claude-code and terminal buffers!
vim.api.nvim_set_keymap('t', '<C-CR>', '<A-CR>', {noremap = true})
-- See ~/.local/share/nvim/parrot/chats/2025-03-23.17-25-57.276.md

-- vim.keymap.set('v', '<c-g>p', ':Mga paste-selection_claude<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('x', '<leader><leader>bn', ':<C-u>lua PrintVisualSelection()<CR>', {noremap = true, silent = true})

-- Helper function to handle sending text to Claude with optional CodeBlockMarkup
local function claude_send_handler(text, use_markup)
  if use_markup then
    Claude_send(CodeBlockMarkup(text))
  else
    Claude_send(text)
  end
end

-- PARAGRAPHS
vim.keymap.set('n', '<c-g>p', function()
  local lines = GetParagraphLines()
  local lines_joined = table.concat(lines, "\n")
  claude_send_handler(lines_joined, false)
end)

-- PARAGRAPHS with markup
vim.keymap.set('n', '<leader><c-g>p', function()
  local lines = GetParagraphLines()
  local lines_joined = table.concat(lines, "\n")
  claude_send_handler(lines_joined, true)
end)

-- VISUAL SELECTIONS
vim.keymap.set('x', '<c-g>p', ":<C-u>lua _G.SendVisualSelectionToClaude(false)<CR>", { noremap = true, silent = true })

-- VISUAL SELECTIONS with markup
vim.keymap.set('x', '<leader><c-g>p', ":<C-u>lua _G.SendVisualSelectionToClaude(true)<CR>", { noremap = true, silent = true })

-- LINEWISE SELECTIONS
vim.keymap.set('n', '<c-g>o', function()
  _G.Claude_linewise_func = Create_linewise_func(false)
  vim.go.operatorfunc = 'v:lua.Claude_linewise_func'
  return 'g@'
end, { expr = true, desc = "Operator to send text to Claude" })

-- LINEWISE SELECTIONS with markup
vim.keymap.set('n', '<leader><c-g>o', function()
  _G.Claude_linewise_func = Create_linewise_func(true)
  vim.go.operatorfunc = 'v:lua.Claude_linewise_func'
  return 'g@'
end, { expr = true, desc = "Operator to send text to Claude with markup" })


-- Function to handle sending visual selection to Claude
function _G.SendVisualSelectionToClaude(use_markup)
  -- Store the current register content
  local old_reg = vim.fn.getreg('z')
  local old_reg_type = vim.fn.getregtype('z')
  
  -- Yank the current visual selection into the z register
  vim.cmd('normal! gv"zy')
  
  -- Get the text from the register
  local selected_text = vim.fn.getreg('z')
  
  -- Send to Claude with optional markup
  claude_send_handler(selected_text, use_markup)
  
  -- Restore register
  vim.fn.setreg('z', old_reg, old_reg_type)
end

-- CLIPBOARD
vim.keymap.set('n', "<c-g>'", function()
  local clipboard_text = vim.fn.getreg('"')
  claude_send_handler(clipboard_text, false)
end)

-- CLIPBOARD with markup
vim.keymap.set('n', "<leader><c-g>'", function()
  local clipboard_text = vim.fn.getreg('"')
  claude_send_handler(clipboard_text, true)
end)

-- RUN claude code text field buffer
vim.keymap.set( 'n',
  '<c-g><cr>', function()
    -- OTHER_EVENTS:
    -- Trigger other commands in the claude repl:
    -- Send escape: (\<Esc> in vimscript)
    -- Claude_send(string.char(27))
    -- Enter insert mode (i actually need to send this before sending text! Rather <esc>i to make sure we were in normal mode)
    -- Claude_send( "i" )
    Claude_send( "\r" )
  end )

-- CLEAR text field buffer
vim.keymap.set( 'n',
  '<c-g>c', function()
    Claude_send(string.char(3))
  end )

-- MAKE COMMIT .. thorrow commit messages
vim.keymap.set( 'n',
  '<c-g>mc', function()
    print("Prefer ll gc!")
    Claude_send("Make a commit.")
    vim.defer_fn(function()
      Claude_send( "\r" )
    end, 100)
  end )


-- Send to claude code terminal or parrot window if visible.
function _G.Claude_send(text)
  local parrot_win = ParrotChat_InThisTab_id()
  local current_win = vim.api.nvim_get_current_win()
  local not_in_parrot_win = current_win ~= parrot_win

  if parrot_win and not_in_parrot_win then
    local lines = vim.fn.split(text, "\n")
    -- jump to parrot_win id
    vim.api.nvim_set_current_win(parrot_win)
    vim.api.nvim_put(lines, "l", false, false)
    vim.api.nvim_set_current_win(current_win)
    return
  end

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

  vim.fn.chansend(job_id, text)
  return true
end

-- Claude_send("hi there")

function _G.CodeBlockMarkup( inputStr )
  local filePathRelToCWD = vim.fn.expand('%')
  local fileType = vim.bo.filetype
  local wrapped = "```" .. fileType .. "\n" .. inputStr .. "\n```\n"
  return "\nHere is a snipped from " .. filePathRelToCWD .. ":\n" .. wrapped
end
-- CodeBlockMarkup( "function abc( cd ) return cd end")


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

-- Helper function for operator-based Claude selections
local function create_operator_func(use_markup)
  return function()
    -- Store the current register content
    local old_unnamed_reg = vim.fn.getreg('"')
    local old_unnamed_reg_type = vim.fn.getregtype('"')

    -- Use a temporary register to avoid conflicts
    local temp_reg = 'z'
    local old_temp_reg = vim.fn.getreg(temp_reg)
    local old_temp_reg_type = vim.fn.getregtype(temp_reg)

    -- Execute the yank operation using the temporary register
    vim.cmd(string.format('normal! `[' .. '"' .. temp_reg .. 'y`]'))

    -- Get the yanked text and its type
    local selected_text = vim.fn.getreg(temp_reg)
    local reg_type = vim.fn.getregtype(temp_reg)
    
    -- Send to Claude with optional markup
    claude_send_handler(selected_text, use_markup)

    -- Restore registers
    vim.fn.setreg(temp_reg, old_temp_reg, old_temp_reg_type)
    vim.fn.setreg('"', old_unnamed_reg, old_unnamed_reg_type)
  end
end

-- INNER SELECTIONS
vim.keymap.set('n', '<c-g>i', function()
  _G.Claude_operator_func = create_operator_func(false)
  vim.go.operatorfunc = 'v:lua.Claude_operator_func'
  return 'g@'
end, { expr = true, desc = "Operator to send text to Claude" })

-- INNER SELECTIONS with markup
vim.keymap.set('n', '<leader><c-g>i', function()
  _G.Claude_operator_func = create_operator_func(true)
  vim.go.operatorfunc = 'v:lua.Claude_operator_func'
  return 'g@'
end, { expr = true, desc = "Operator to send text to Claude with markup" })



-- ─   Helpers                                          ──

-- Helper function for linewise operator-based Claude selections
function Create_linewise_func(use_markup)
  return function()
    -- Store registers
    local old_reg = vim.fn.getreg('z')
    local old_reg_type = vim.fn.getregtype('z')

    -- Get the exact position details
    local start_pos = vim.fn.getpos("'[")
    local end_pos = vim.fn.getpos("']")
    local start_line = start_pos[2]
    local end_line = end_pos[2]

    -- Use linewise visual mode to ensure we get complete lines
    vim.cmd(string.format('normal! %dGV%dG"zy', start_line, end_line))

    -- Get the yanked text
    local selected_text = vim.fn.getreg('z')
    
    -- Send to Claude with optional markup
    claude_send_handler(selected_text, use_markup)

    -- Restore register
    vim.fn.setreg('z', old_reg, old_reg_type)
  end
end


function _G.ParrotChat_InThisTab_id()
  -- Get all windows in the current tab
  local windows = vim.api.nvim_tabpage_list_wins(0)

  -- Check each window
  for _, win in ipairs(windows) do
    -- Get the buffer for this window
    local buf = vim.api.nvim_win_get_buf(win)
    
    -- Get the buffer name
    local bufname = vim.api.nvim_buf_get_name(buf)
    
    -- Check if buffer name contains "parrot/chats"
    if bufname:match("parrot/chats") then
      return win
    end
  end

  -- No matching window found
  return false
end
-- ParrotChat_InThisTab_id()

-- ─   Range param usage examples                       ──
-- ⏺ The range parameter in the get_chat_messages function allows you to limit which part of a chat
--   file is parsed for messages. Here are some examples of how to use it:

--   1. Basic usage to extract messages from a specific range of lines:

--   local chat_utils = require("parrot.chat_utils")

--   -- Extract messages from lines 10-20 only
--   local result = chat_utils.get_chat_messages(0, nil, {
--     range = 2,  -- Indicates a range is being used
--     line1 = 10, -- Start line (1-based index)
--     line2 = 20  -- End line (1-based index)
--   })

--   2. Using it with Neovim's range commands:

--   -- In a Vim command that receives range parameters
--   vim.api.nvim_create_user_command("ChatExtract", function(params)
--     local chat_utils = require("parrot.chat_utils")

--     -- Pass the range info directly from the command
--     local result = chat_utils.get_chat_messages(0, nil, {
--       range = params.range,
--       line1 = params.line1,
--       line2 = params.line2
--     })

--     -- Do something with the extracted messages
--     print("Extracted " .. #result.messages .. " messages")
--   end, { range = true })

--   3. Extracting only the last few messages:

--   local function get_last_messages(count)
--     local chat_utils = require("parrot.chat_utils")
--     local buf = vim.api.nvim_get_current_buf()
--     local line_count = vim.api.nvim_buf_line_count(buf)

--     -- Get all messages first to find header end
--     local all_result = chat_utils.get_chat_messages(buf)

--     -- Calculate approx. lines needed per message (rough estimate)
--     local header_end = all_result.metadata.start_line - 1
--     local content_lines = line_count - header_end
--     local avg_lines_per_msg = content_lines / #all_result.messages

--     -- Extract only the last X messages by estimating line range
--     local start_line = math.max(header_end + 1, line_count - (count * avg_lines_per_msg))
--     local result = chat_utils.get_chat_messages(buf, nil, {
--       range = 2,
--       line1 = start_line,
--       line2 = line_count
--     })

--     return result.messages
--   end

--   -- Get approximately the last 3 messages
--   local last_messages = get_last_messages(3)

--   4. Using it with visual selection:

--   -- In a mapping that works on visual selection
--   vim.keymap.set('v', '<leader>ce', function()
--     -- Get visual selection range
--     local start_line = vim.fn.line("'<")
--     local end_line = vim.fn.line("'>")

--     local chat_utils = require("parrot.chat_utils")
--     local result = chat_utils.get_chat_messages(0, nil, {
--       range = 2,
--       line1 = start_line,
--       line2 = end_line
--     })

--     -- Now you have just the messages from the selected range
--     vim.notify("Selected messages: " .. vim.inspect(result.messages))
--   end, { noremap = true, desc = "Extract chat messages from selection" })



