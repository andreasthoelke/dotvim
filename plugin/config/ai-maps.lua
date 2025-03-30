

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


-- vim.keymap.set('n', '<c-g>v', ':AvanteFocus<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<c-g>v', ':AvanteChat<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g>v', ':AvanteToggle<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<c-g>c', ':AvanteStop<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-c>', ':AvanteStop<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g>c', ':AvanteClear<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<c-g>h', ':MCPHub<CR>', { noremap = true, silent = true })

-- Avante_is_open()

-- HIGHLIGHTS
-- local hi = vim.api.nvim_set_hl
-- ~/.config/nvim/colors/munsell-blue-molokai_light_1.lua‖/hi(0,ˍ"NormalFloat",ˍ{ˍbgˍ=ˍ"#E
-- ~/.config/nvim/plugged/avante.nvim/lua/avante/highlights.lua‖/localˍHighlightsˍ=ˍ{

-- ─^  AVANTE                                            ▲



-- ─   CODECOMPANION                                     ■
-- ~/.config/nvim/plugin/config/codecompanion.lua‖*ˍˍˍChatˍkeymaps

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
-- ~/.config/nvim/plugin/config/parrot-claude-code.lua‖*ˍˍˍkeymaps
-- ~/.config/nvim/plugin/config/parrot-claude-code.lua‖*ˍˍˍClaudeˍcodeˍactionˍmaps

vim.keymap.set( 'n', '<c-g>V', function() vim.cmd('ClaudeCodeOpen') end )
vim.keymap.set( 'n', '<c-g>S', function() vim.cmd(require('claude_code').AiderOpen("", "hsplit")) end )

vim.keymap.set('n', '<c-g><c-j>', function()
  local user_msg_content_str = ParrotBuf_GetLatestUserMessage()
  Claude_send(user_msg_content_str)
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
    Claude_send(string.char(3))
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



-- ─   PARROT                                            ■

-- In buffer maps: ~/.config/nvim/plugin/config/parrot.lua‖/chat_shortcut_respondˍ=ˍ{ˍ

vim.keymap.set('n', '<c-g><leader>p', ':PrtProvider<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-g><leader>m', ':PrtModel<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<c-g><leader>v', ':PrtChatNew<CR>', { noremap = true, silent = true })
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




