

function _G.ParrotBuf_GetMessages()
  local chat_utils = require("parrot.chat_utils")
  local result = chat_utils.get_chat_messages()
  return result
end

function _G.ParrotBuf_GetLatestUserMessage()
  local result = ParrotBuf_GetMessages()
  local latest_user_msg = nil

  -- Iterate through messages in reverse order to find the most recent significant user message
  for i = #result.messages, 1, -1 do
    local msg = result.messages[i]
    if msg.role == "user" then
      -- Strip newlines and check if content is not empty
      local stripped_content = msg.content:gsub("^\n+", ""):gsub("\n+$", "")
      if stripped_content ~= "" then
        latest_user_msg = stripped_content
        break
      end
    end
  end
  return latest_user_msg
end


-- Send text to agent terminal (found dynamically in current tab) or other AI windows (Magenta, Parrot, Avante)
function _G.Claude_send(text)
  local magenta_win = BufName_InThisTab_id("Magenta Input")
  -- local parrot_win = ParrotChat_InThisTab_id()
  local avante_win = Avante_InThisTab_id()
  local current_win = vim.api.nvim_get_current_win()
  local not_in_parrot_win = current_win ~= parrot_win
  local not_in_avante_win = current_win ~= avante_win
  local using_gemini_cli = vim.g.agent_cmd ~= 'gemini'

  if magenta_win then
    if text == "\r" then
      vim.cmd'Magenta send'
      return
    end
    local lines = vim.fn.split(text, "\n")
    -- jump to magenta input id
    vim.api.nvim_set_current_win(magenta_win)
    vim.api.nvim_put(lines, "l", false, false)
    vim.api.nvim_set_current_win(current_win)
    return
  end

  if parrot_win and not_in_parrot_win then
    local lines = vim.fn.split(text, "\n")
    -- jump to parrot_win id
    vim.api.nvim_set_current_win(parrot_win)
    vim.api.nvim_put(lines, "l", false, false)
    vim.api.nvim_set_current_win(current_win)
    return
  end

  if avante_win and not_in_avante_win then
    local lines = vim.fn.split(text, "\n")
    -- jump to parrot_win id
    vim.cmd'AvanteFocus'
    -- vim.api.nvim_set_current_win(avante_win)
    vim.api.nvim_put(lines, "l", false, false)
    vim.api.nvim_set_current_win(current_win)
    return
  end

  -- Find agent terminal in current tab dynamically
  local job_id = require('agents').find_agent_terminal_in_tab()

  -- Check if we found a job ID
  if not job_id then
    vim.api.nvim_echo({{
      "Error: No agent terminal found. Please start an agent first with <c-g>V",
      "ErrorMsg"
    }}, true, {})
    return false
  end

  -- see ~/.local/share/nvim/parrot/chats/2025-09-29.11-17-22.488.md
  if using_gemini_cli then
    local wrapped = "\x1b[200~" .. text .. "\x1b[201~"
    text = wrapped
  end

  -- vim.api.nvim_echo( {{ text }}, true, {} )

  vim.fn.chansend(job_id, text)

  return true
end

-- Claude_send("iab")
-- Claude_send( "\x1b[200~hi there!\x1b[201~" )
-- Claude_send( "\x1b[200~hi there!\x1b[201~\r" )

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


-- ─   Helpers                                          ──

-- Helper function to handle sending text to Claude with optional CodeBlockMarkup
local function claude_send_handler(text, use_markup)
  if use_markup then
    Claude_send(CodeBlockMarkup(text))
  else
    Claude_send(text)
  end
end


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


function _G.BufName_InThisTab_id(bufname_part)
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match(bufname_part) then
      return win
    end
  end
  return false
end
-- BufName_InThisTab_id("parrot/chats")
-- BufName_InThisTab_id("Magenta Input")


function _G.ParrotChat_InThisTab_id()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match("parrot/chats") then
      return win
    end
  end
  return false
end
-- ParrotChat_InThisTab_id()

function _G.Avante_InThisTab_id()
  local sidebar = require("avante").get()
  if not sidebar then return end
  if not sidebar:is_open() then return end
  return sidebar.input_container.winid
end
-- Avante_is_open()


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



