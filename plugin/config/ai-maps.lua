

-- parrot
-- avante
-- codecompanion
-- magenta
-- claude code

-- ─   AVANTE                                            ■
-- ~/.config/nvim/plugin/config/avante.lua‖*ˍˍˍKeymaps

-- c-g m   - add file (neo tree)

-- AvanteAsk [question] [position]` | Ask AI about your code. Optional `position` set window position and `ask` enable/disable direct asking mode | `:AvanteAsk position=right Refactor this code here` |
-- AvanteBuild`                     | Build dependencies for the project                                                                          | |
-- AvanteChat`                      | Start a chat session with AI about your codebase. Default is `ask`=false                                    | |
-- AvanteClear`                     | Clear the chat history                                                                                      | |
-- AvanteEdit`                      | Edit the selected code blocks                                                                               | |
-- AvanteFocus`                     | Switch focus to/from the sidebar                                                                            | |
-- AvanteRefresh`                   | Refresh all Avante windows                                                                                  | |
-- AvanteStop`                      | Stop the current AI request                                                                                 | |
-- AvanteSwitchProvider`            | Switch AI provider (e.g. openai)                                                                            | |
-- AvanteShowRepoMap`               | Show repo map for project's structure                                                                       | |
-- AvanteToggle`                    | Toggle the Avante sidebar                                                                                   | |
-- AvanteModels`                    | Show model list                                                                                             | |


-- vim.keymap.set('n', '<c-g><leader>v', ':AvanteFocus<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g><leader>v', ':AvanteChatNew<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<c-g><leader>v', ':AvanteChat<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g><leader>M', ':AvanteModel<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g><leader>h', ':AvanteHistory<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g><leader>H', ':CodeCompanionHistory<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<c-g>l', ':AvanteFocus<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<c-g>v', ':AvanteToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g>c', ':AvanteStop<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<c-c>', ':AvanteStop<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g><leader>c', ':AvanteClear<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<c-g><leader>P', ':AvanteSwitchProvider ', { noremap = true, silent = true })

vim.keymap.set('n', '<c-g><leader>P', function()
  local feed    = vim.api.nvim_feedkeys
  local t       = vim.api.nvim_replace_termcodes
  feed(t(':AvanteSwitchProvider ', true, false, true), 'n', false)
  feed(t("<Tab>", true, false, true), 't', false)
end, { noremap = true, silent = true })


vim.keymap.set('n', '<c-g>h', ':MCPHub<CR>', { noremap = true, silent = true })

-- Avante_is_open()

-- HIGHLIGHTS
-- local hi = vim.api.nvim_set_hl
-- ~/.config/nvim/colors/munsell-blue-molokai_light_1.lua‖/hi(0,ˍ"NormalFloat",ˍ{ˍbgˍ=ˍ"#E
-- ~/.config/nvim/plugged/avante.nvim/lua/avante/highlights.lua‖/localˍHighlightsˍ=ˍ{

-- ─^  AVANTE                                            ▲



-- ─   CODECOMPANION                                     ■
-- In buffer keymaps: ~/.config/nvim/plugin/config/codecompanion.lua‖/keymapsˍ=ˍ{


vim.keymap.set('n', '<c-g><leader>V', function()
  local update = { display = { chat = { window = { layout = "vertical" } } } }
  local config_updated = vim.tbl_deep_extend("force", vim.deepcopy( CodeCompanion_config ), update )
  require("codecompanion").setup( config_updated )
  require("codecompanion").chat()
end, { noremap = true, silent = true })

-- Open codecompanion chat with horizontal layout
-- This keybinding changes the window layout configuration before opening the chat
vim.keymap.set('n', '<c-g><leader>C', function()
  local update = { display = { chat = { window = { layout = "horizontal" } } } }
  local config_updated = vim.tbl_deep_extend("force", vim.deepcopy( CodeCompanion_config ), update )
  require("codecompanion").setup( config_updated )
  require("codecompanion").chat()
end, { noremap = true, silent = true })


-- ─^  CODECOMPANION                                     ▲



-- ─   CLAUDE CODE                                       ■
-- ~/.config/nvim/plugin/config/parrot-claude-code.lua
-- ~/.config/nvim/plugged/aider.nvim/lua/aider.lua‖/functionˍM.AiderOpen(args,

vim.g.codex_cmd = "claude "

vim.keymap.set('n', '<c-g><c-g>o', function()
  local options = {
    "claude ",
    "claude --dangerously-skip-permissions ",
    "claude --debug ",
    "claude update ",
    "claude --resume ",
    "gemini ",
    "cd /Users/at/Documents/Proj/k_mindgraph/h_mcp/e_gemini && npm run start ",
    "opencode ",
    "codex --approval-mode full-auto ",
    "codex --full-auto ",
    "codex --full-auto --model gpt-4.1 ",
    "codex --full-auto --model o3 ",
    "codex --full-auto --model codex-mini-latest ",
    "node ~/Documents/Proj/k_mindgraph/h_mcp/_gh/c_codex/codex-cli/dist/cli.js --full-auto --model o3 ",
    "aider ",
  }
  
  -- Create a UI selection using vim.ui.select (available in Neovim 0.6+)
  vim.ui.select(options, {
    prompt = "Select command:",
    format_item = function(item)
      return item
    end
  }, function(choice)
    if choice then
      -- Set the selected string to g:codex_cmd
      vim.g.codex_cmd = choice
      print("Selected: " .. choice)
    else
      print("No selection made")
    end
  end)

end)


vim.keymap.set( 'n', '<c-g>V', function() vim.cmd('ClaudeCodeOpen ' .. vim.g['codex_cmd']) end )
vim.keymap.set( 'n', '<c-g>S', function() vim.cmd(require('claude_code').AiderOpen( vim.g['codex_cmd'], "hsplit")) end )
-- ~/.config/nvim/plugged/claude_code/lua/claude_code.lua‖/localˍcommandˍ=ˍargs

vim.keymap.set('n', '<c-g><c-j>', function()
  local user_msg_content_str = ParrotBuf_GetLatestUserMessage()
  Claude_send(user_msg_content_str)
end)

vim.keymap.set('n', '<c-g><c-j>', function()
  local user_msg_content_str = ParrotBuf_GetLatestUserMessage()
  Claude_send(user_msg_content_str)
end)

vim.keymap.set('n', '<c-g><c-s>', function()
  SaveChatBuffer()
end)

-- vim.keymap.set('n', '<c-g><c-s>', function()
--   local uniqueStr = vim.fn.GetRandNumberString4()
--   local filepath = "/Users/at/.local/share/nvim/parrot/chats/claude_code_" .. uniqueStr .. ".md"
--   local claude_buf = require('claude_code').aider_buf
--   -- Save text of claude buffer
--   local text = vim.api.nvim_buf_get_lines(claude_buf, 0, -1, false)
--   -- create file
--   local file = io.open(filepath, "w")
--   if file then
--     for _, line in ipairs(text) do
--       file:write(line .. "\n")
--     end
--     file:close()
--     print("Saved to " .. filepath)
--   else
--     print("Error saving to " .. filepath)
--   end
-- end)
-- require('claude_code').aider_buf

-- Lines breaks in claude-code and terminal buffers!
-- vim.api.nvim_set_keymap('t', '<C-CR>', '<A-CR>', {noremap = true})
-- vim.api.nvim_set_keymap('t', '<S-CR>', '<A-CR>', {noremap = true})
-- vim.api.nvim_set_keymap('t', '<c-CR>', '<C-\\><C-n>i[control-ENTER PRESSED]<C-\\><C-n>a', {noremap = true})
-- vim.api.nvim_set_keymap('t', '<S-CR>', '<C-\\><C-n>i[SHIFT-ENTER PRESSED]<C-\\><C-n>a', {noremap = true})

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

-- BUFFER
vim.keymap.set('n', '<c-g>b', function()
  -- 0 means "current buffer"
  -- 0      -> first line (0-indexed)
  -- -1     -> last line   (end index is *exclusive*)
  -- false  -> don't error if the range is out of bounds
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local lines_joined = table.concat(lines, "\n")
  claude_send_handler(lines_joined, false)
end)


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
  '<c-g>C', function()
    local magenta_win = BufName_InThisTab_id("Magenta Input")
    if magenta_win then
      local current_win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(magenta_win)
      -- delete all text in the current buffer:
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
      vim.api.nvim_set_current_win(current_win)
      return
    end
    vim.fn.chansend(vim.g.claude_job_id, string.char(3))
    -- Claude_send(string.char(3))
  end )

-- MAKE COMMIT .. thorough commit messages
vim.keymap.set( 'n',
  '<c-g>mc', function()
    print("Prefer ll gc!")
    Claude_send("Make a commit.")
    vim.defer_fn(function()
      Claude_send( "\r" )
    end, 100)
  end )

-- Clear chat
vim.keymap.set( 'n',
  '<c-g>,c', function()
    Claude_send("/clear")
    vim.defer_fn(function()
      Claude_send( "\r" )
    end, 100)
  end )


-- ─^  CLAUDE CODE                                       ▲


-- ─   Magenta                                           ■

-- NOTE claude_send consistent maps:
-- ~/.config/nvim/plugin/config/parrot-claude-code.lua‖/functionˍ_G.Claude_send(te

-- Commands
  -- "debug-prediction-message",
  -- "profile",
  -- "start-inline-edit",
  -- "replay-inline-edit",
  -- "toggle",
  -- "new-thread",
  -- "threads-overview",
  -- "predict-edit",
  -- "accept-prediction",
  -- "dismiss-prediction",
  -- local visual_commands = 
--   "start-inline-edit-selection",
--   "replay-inline-edit-selection",
--   "paste-selection",


vim.keymap.set('n', '<c-g>l', function()
  local magenta_win = BufName_InThisTab_id("Magenta Input")
  if magenta_win then
    vim.api.nvim_set_current_win(magenta_win)
  end
end, { desc = "Focus Magenta input" })


-- ─   NEP edit prediction                               ■
vim.keymap.set({'n', 'v'}, '<c-g><c-l><c-l>', function()
  vim.cmd "Magenta predict-edit"
end, { desc = "Magenta predict" })

vim.keymap.set({'n', 'v'}, '<c-g><c-l>l', function()
  vim.cmd "Magenta predict-edit"
end, { desc = "Magenta predict" })

vim.keymap.set('n', '<c-g><c-l><c-g>', function()
  vim.cmd "Magenta accept-prediction"
end, { desc = "Magenta accept" })

vim.keymap.set('n', '<c-g><c-l>g', function()
  vim.cmd "Magenta accept-prediction"
end, { desc = "Magenta accept" })

vim.keymap.set('n', '<c-g><c-l><cr>', function()
  vim.cmd "Magenta accept-prediction"
end, { desc = "Magenta accept" })

vim.keymap.set('n', '<c-g><c-l>c', function()
  vim.cmd "Magenta dismiss-prediction"
end, { desc = "Magenta dismiss prediction" })

vim.keymap.set('n', '<c-g><c-l><c-d>', function()
  vim.cmd "Magenta debug-prediction-message"
end, { desc = "Magenta debug prediction" })

vim.keymap.set('n', '<c-g><c-l>d', function()
  vim.cmd "Magenta debug-prediction-message"
end, { desc = "Magenta debug prediction" })


-- ─^  NEP edit prediction                               ▲


vim.keymap.set( 'n',
  ',sm', function()
    require( 'plenary.reload' ).reload_module(
      'magenta.nvim'
    )
    vim.cmd('luafile ~/.config/nvim/plugin/config/magenta.nvim.lua')
  end )


-- ─^  Magenta                                           ▲


-- ─   PARROT                                            ■

-- In buffer maps: ~/.config/nvim/plugin/config/parrot.lua‖/chat_chortcut_respondˍ=ˍ{ˍ

vim.keymap.set('n', '<c-g><leader>p', ':PrtProvider<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g><leader>m', ':PrtModel<CR>', { noremap = true, silent = true })

-- vim.keymap.set('n', '<c-g><leader>v', ':PrtChatNew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g>v', ':PrtChatNew<CR>', { noremap = true, silent = true })
-- NOTE 15split is hardcoded here ~/.config/nvim/plugged/parrot.nvim/lua/parrot/chat_handler.lua‖/vim.api.nvim_command("15sp
vim.keymap.set('n', '<c-g>s', ':PrtChatNew split<CR>', { noremap = true, silent = true })
vim.keymap.set("v", "<c-g>v", ":<c-u>'<,'>PrtChatNew<cr>", { desc = "Chat with file context" })
vim.keymap.set("v", "<c-g>s", ":<c-u>'<,'>PrtChatNew split<cr>", { desc = "Chat with file context" })



-- vim.keymap.set('n', '<c-g>C', ':PrtChatWithFileContext<CR>', { noremap = true, silent = true })
-- vim.keymap.set("v", "<c-g>C", ":<c-u>'<,'>PrtChatWithFileContext<cr>", { desc = "Chat with all buffers" })

vim.keymap.set('n', '<c-g><leader>C', ':PrtChatWithAllBuffers<CR>', { noremap = true, silent = true })
vim.keymap.set("v", "<c-g><leader>C", ":<c-u>'<,'>PrtChatWithAllBuffers<cr>", { desc = "Chat with all buffers" })

vim.keymap.set("v", "<c-g>r", ":<c-u>'<,'>PrtRewrite<cr>", { desc = "Chat with file context" })
vim.keymap.set("v", "<c-g>a", ":<c-u>'<,'>PrtAppend<cr>", { desc = "Chat with file context" })

vim.keymap.set("v", "<c-g><leader>r", ":<c-u>'<,'>PrtRewriteFullContext<cr>", { desc = "Chat with file context" })
vim.keymap.set("v", "<c-g><leader>a", ":<c-u>'<,'>PrtAppendFullContext<cr>", { desc = "Chat with file context" })


-- ─^  PARROT                                            ▲




