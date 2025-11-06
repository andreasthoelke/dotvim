

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



-- ─   AGENTS                                            ■
-- Agent terminal management using lua/agents.lua
-- Commands available: claude, codex, gemini, aider, etc.

vim.g.agent_cmd = "env -u ANTHROPIC_API_KEY claude --dangerously-skip-permissions "

vim.keymap.set('n', '<c-g><c-g>o', function()
  local options = {
    "codex --dangerously-bypass-approvals-and-sandbox ",
    "env -u ANTHROPIC_API_KEY claude --dangerously-skip-permissions ",
    "cat -v ",
    "gemini ",
    "gemini -m gemini-flash-latest ",
    "gemini -m gemini-2.5-flash-image-preview ",
    "cd /Users/at/Documents/Proj/k_mindgraph/h_mcp/e_gemini && npm start ",
    "cd /Users/at/Documents/Proj/k_mindgraph/h_mcp/e_gemini && npm start -m gemini-flash-latest ",
    "opencode ",
    "node ~/Documents/Proj/k_mindgraph/h_mcp/_gh/c_codex/codex-cli/dist/cli.js --full-auto --model o3 ",
    "aider ",
  }

  -- Create a UI selection using vim.ui.select (available in Neovim 0.6+)
  vim.ui.select(options, {
    prompt = "Select agent command:",
    format_item = function(item)
      return item
    end
  }, function(choice)
    if choice then
      -- Set the selected string to g:agent_cmd
      vim.g.agent_cmd = choice
      require('agents').open_agent(vim.g['agent_cmd'], 'vsplit')
      print("Selected agent: " .. choice)
    else
      print("No selection made")
    end
  end)
end)




-- ─   Agents Terminal Management                        ──
-- Opens terminal buffers for CLI coding agents (Claude Code, Codex, Gemini, etc.)
-- Uses the unified 'agents' module: lua/agents.lua
-- Each tab can have one active agent terminal, found dynamically by searching the current tab
-- Always creates NEW terminal (no resume logic)

vim.keymap.set( 'n', '<c-g>V', function()
  require('agents').open_agent(vim.g['agent_cmd'], 'vsplit')
end )

vim.keymap.set( 'n', '<c-g>S', function()
  require('agents').open_agent(vim.g['agent_cmd'], 'hsplit')
end )

-- Restore agent terminal window if accidentally closed
vim.keymap.set( 'n', '<c-g><c-v>', function()
  require('agents').restore_agent_window('vsplit')
end )

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


-- ─   Send to Worktree Agents                          ──

-- Helper function to send text to worktree agents
local function send_to_worktree_agents(text)
  require('agents-worktrees').run_agents_worktrees(text)
end

-- Helper to get visual selection text for worktrees
function _G.SendVisualSelectionToWorktrees()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return
  end

  -- Adjust first and last line for partial selections
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local text = table.concat(lines, "\n")
  send_to_worktree_agents(text)
end

-- Helper to create operator function for worktrees
local function create_worktree_operator_func()
  return function(type)
    local start_pos, end_pos
    if type == 'char' then
      start_pos = vim.fn.getpos("'[")
      end_pos = vim.fn.getpos("']")
    elseif type == 'line' then
      start_pos = vim.fn.getpos("'[")
      end_pos = vim.fn.getpos("']")
    else
      return
    end

    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    if #lines == 0 then
      return
    end

    local text = table.concat(lines, "\n")
    send_to_worktree_agents(text)
  end
end

-- PARAGRAPHS to worktree agents
vim.keymap.set('n', '<c-g>wp', function()
  local lines = GetParagraphLines()
  local text = table.concat(lines, "\n")
  send_to_worktree_agents(text)
end, { desc = "Send paragraph to worktree agents" })

-- VISUAL SELECTIONS to worktree agents
vim.keymap.set('x', '<c-g>wp', ":<C-u>lua _G.SendVisualSelectionToWorktrees()<CR>",
  { noremap = true, silent = true, desc = "Send visual selection to worktree agents" })

-- LINEWISE SELECTIONS to worktree agents
vim.keymap.set('n', '<c-g>wo', function()
  _G.Worktree_linewise_func = create_worktree_operator_func()
  vim.go.operatorfunc = 'v:lua.Worktree_linewise_func'
  return 'g@'
end, { expr = true, desc = "Operator to send text to worktree agents" })

-- CLIPBOARD to worktree agents
vim.keymap.set('n', "<c-g>w'", function()
  local clipboard_text = vim.fn.getreg('"')
  send_to_worktree_agents(clipboard_text)
end, { desc = "Send clipboard to worktree agents" })

-- INNER SELECTIONS to worktree agents
vim.keymap.set('n', '<c-g>wi', function()
  _G.Worktree_operator_func = create_worktree_operator_func()
  vim.go.operatorfunc = 'v:lua.Worktree_operator_func'
  return 'g@'
end, { expr = true, desc = "Operator to send text to worktree agents" })


-- ─   Worktree Agent Commands                          ──

-- Run agents with prompt
vim.api.nvim_create_user_command('AgentsWorktreesRun', function(opts)
  if opts.args == "" then
    vim.notify("Error: Prompt required. Usage: :AgentsWorktreesRun <prompt>", vim.log.levels.ERROR)
    return
  end
  require('agents-worktrees').run_agents_worktrees(opts.args)
end, { nargs = '+', desc = "Run all worktree agents with prompt" })

vim.api.nvim_create_user_command('AgentsWorktreesRunClaude', function(opts)
  if opts.args == "" then
    vim.notify("Error: Prompt required. Usage: :AgentsWorktreesRunClaude <prompt>", vim.log.levels.ERROR)
    return
  end
  require('agents-worktrees').run_agent_worktree("claude", opts.args)
end, { nargs = '+', desc = "Run Claude worktree agent with prompt" })

vim.api.nvim_create_user_command('AgentsWorktreesRunCodex', function(opts)
  if opts.args == "" then
    vim.notify("Error: Prompt required. Usage: :AgentsWorktreesRunCodex <prompt>", vim.log.levels.ERROR)
    return
  end
  require('agents-worktrees').run_agent_worktree("codex", opts.args)
end, { nargs = '+', desc = "Run Codex worktree agent with prompt" })

-- Reset worktrees to main
vim.api.nvim_create_user_command('AgentsWorktreesResetAll', function()
  require('agents-worktrees').reset_all_worktrees_to_main()
end, { desc = "Reset all agent worktrees to main (with backup)" })

vim.api.nvim_create_user_command('AgentsWorktreesResetClaude', function()
  require('agents-worktrees').reset_worktree_to_main("claude")
end, { desc = "Reset Claude worktree to main (with backup)" })

vim.api.nvim_create_user_command('AgentsWorktreesResetCodex', function()
  require('agents-worktrees').reset_worktree_to_main("codex")
end, { desc = "Reset Codex worktree to main (with backup)" })

-- Setup worktrees (without running agents)
vim.api.nvim_create_user_command('AgentsWorktreesSetupClaude', function()
  require('agents-worktrees').setup_worktree("claude")
end, { desc = "Setup Claude worktree (create if needed, rebase)" })

vim.api.nvim_create_user_command('AgentsWorktreesSetupCodex', function()
  require('agents-worktrees').setup_worktree("codex")
end, { desc = "Setup Codex worktree (create if needed, rebase)" })

-- ─^  Worktree Agent Commands                          ▲


-- RUN/ENTER - Send Enter key to agent terminal in current tab
vim.keymap.set( 'n',
  '<c-g><cr>', function()
    -- Find agent terminal job ID in current tab
    local job_id = require('agents').find_agent_terminal_in_tab()

    if not job_id then
      vim.notify("No agent terminal found in current tab", vim.log.levels.WARN)
      return
    end

    local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    vim.fn.chansend(job_id, enter)

    -- Send Enter directly via channel (works for all agents)
    -- vim.fn.chansend(job_id, "\r")
  end )

-- CLEAR/CANCEL - Send Ctrl-C to agent terminal in current tab
vim.keymap.set( 'n',
  '<c-g>C', function()
    local magenta_win = BufName_InThisTab_id("Magenta Input")

    -- Handle Magenta input window separately
    if magenta_win then
      local current_win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(magenta_win)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
      vim.api.nvim_set_current_win(current_win)
      return
    end

    -- Find agent terminal job ID in current tab
    local job_id = require('agents').find_agent_terminal_in_tab()
    if not job_id then
      vim.notify("No agent terminal found in current tab", vim.log.levels.WARN)
      return
    end

    -- Send Ctrl-C directly via channel (works for all agents)
    vim.fn.chansend(job_id, string.char(3))
  end )


vim.keymap.set( 'n',
  '<c-g>D', function()
    -- print("Closing / deleting agent!")
    -- Claude_send("/exit")

    local job_id, bufnr = require('agents').find_agent_terminal_in_tab()
    if not job_id or not bufnr then
      vim.notify("No agent terminal found in current tab", vim.log.levels.WARN)
      return
    end

    vim.fn.chansend(job_id, "/exit")

    vim.defer_fn(function()
      local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
      vim.fn.chansend(job_id, enter)
    end, 100)

    -- Wait longer for graceful shutdown, then check if it's still alive
    vim.defer_fn(function()
      -- Only force kill if the job is still running after 5 seconds
      if vim.fn.jobwait({job_id}, 0)[1] == -1 then
        -- Job still running, something went wrong
        vim.fn.jobstop(job_id)
      end

      -- After job has exited (or been killed), delete the buffer
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          pcall(vim.api.nvim_buf_delete, bufnr, {force = true})
        end
      end, 500)
    end, 4000)

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


-- ─   Worktree Directory Navigation                     ──
-- Change tab directory to agent worktree paths

local function tcd_to_worktree(agent_key)
  local current_cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(current_cwd, ':t')
  local parent_dir = vim.fn.fnamemodify(current_cwd, ':h')

  -- Handle 'main' as special case - go to project root without suffix
  local worktree_path
  if agent_key == 'main' then
    -- Remove agent suffix if currently in a worktree
    if project_name:match('_claude$') or project_name:match('_codex$') then
      project_name = project_name:gsub('_[^_]+$', '')
    end
    worktree_path = parent_dir .. '/' .. project_name
  else
    worktree_path = parent_dir .. '/' .. project_name .. '_' .. agent_key
  end

  if vim.fn.isdirectory(worktree_path) == 0 then
    vim.notify(string.format("Worktree not found: %s", worktree_path), vim.log.levels.ERROR)
    return
  end

  vim.cmd('tcd ' .. vim.fn.fnameescape(worktree_path))
  vim.notify(string.format("worktree %s", agent_key), vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>cdC', function()
  tcd_to_worktree('claude')
end, { silent = true, desc = "tcd to claude worktree" })

vim.keymap.set('n', '<leader>cdO', function()
  tcd_to_worktree('codex')
end, { silent = true, desc = "tcd to codex worktree" })

vim.keymap.set('n', '<leader>cdM', function()
  tcd_to_worktree('main')
end, { silent = true, desc = "tcd back to main from agent worktree" })

-- ─^  Worktree Directory Navigation                     ▲


-- ─^  AGENTS                                            ▲


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
vim.keymap.set('n', '<c-g>t', ':PrtChatNew tabnew<CR>', { noremap = true, silent = true })
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


-- ─   LLM Visual Selection Integration                  ──
-- Quick LLM operations on visual selections using the ai.lua module

-- Main LLM menu (using <c-g>L to avoid conflict with Magenta's <c-g>l)
vim.keymap.set('v', '<c-g>L', ':LLMMenu<CR>', { desc = 'LLM prompt menu', silent = true })

-- Quick access commands with <c-g>l prefix (two-key combos)
vim.keymap.set('v', '<c-g>lt', ':LLMTopic<CR>', { desc = 'LLM topic summary', silent = true })
vim.keymap.set('v', '<c-g>le', ':LLMExplain<CR>', { desc = 'LLM explain code', silent = true })
vim.keymap.set('v', '<c-g>li', ':LLMImprove<CR>', { desc = 'LLM suggest improvements', silent = true })
vim.keymap.set('v', '<c-g>lb', ':LLMBugs<CR>', { desc = 'LLM find bugs', silent = true })
vim.keymap.set('v', '<c-g>ld', ':LLMDocs<CR>', { desc = 'LLM generate docs', silent = true })

-- Custom prompts with provider selection (using <leader><c-g>l prefix)
vim.keymap.set('v', '<leader><c-g>l', ':LLMVisual<CR>', { desc = 'LLM custom prompt', silent = true })
vim.keymap.set('v', '<leader><c-g>lg', ':LLMVisualGemini<CR>', { desc = 'LLM Gemini', silent = true })
vim.keymap.set('v', '<leader><c-g>lc', ':LLMVisualClaude<CR>', { desc = 'LLM Claude', silent = true })

-- Alternative single-key access for your most used operation (topic summary)
vim.keymap.set('v', '<c-g>T', ':LLMTopic<CR>', { desc = 'Quick topic summary', silent = true })

-- ─^  LLM Visual Selection Integration                  ▲



