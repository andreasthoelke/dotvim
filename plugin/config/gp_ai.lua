
-- require('gp')._chat_agents
-- require('gp')._command_agents

-- Add this to your config = function()
-- require( 'gp' ).setup( conf )

-- ─   Select Chat & Command Agent                       ■

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local f = require 'utils.functional'

function _G.Gp_SelectAgent_chat()
  opts = require('telescope.themes').get_dropdown { winblend = 15, previewer = false }
  opts = f.merge( opts, {initial_mode='normal'} )
  currentAgent = require('gp')._state.chat_agent
  pickers
  .new(opts, {
    prompt_title = 'Chat Agents [' .. currentAgent .. ']',
    finder = finders.new_table {
      results = require('gp')._chat_agents
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        map('n', 'o', function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            Gp_SetAgent_chat( selection[1] )
          end)
        map('n', '<cr>', function() print( "use o to select" ) end)
      -- end)
      return true
    end,
  })
  :find()
end
-- Gp_SelectAgent_chat()

function _G.Gp_SetAgent_chat( name )
  local agent_name = string.gsub(name, "^%s*(.-)%s*$", "%1")
  require('gp').refresh_state({ chat_agent = agent_name })
  print( "Chat Agent: " .. agent_name )
end

-- Gp_SetAgent_chat( 'ChatGPT4o-mini' )
-- Gp_SetAgent_chat( 'ChatGPT4o' )

vim.keymap.set('n', '<leader>gca', function()
  Gp_SelectAgent_chat()
end, {
  noremap = true,
  silent = false,
  nowait = true,
  desc = 'Select Chat Agent',
})


-- SELECT COMMAND AGENT

function _G.Gp_SelectAgent_command()
  opts = require('telescope.themes').get_dropdown { winblend = 15, previewer = false }
  opts = f.merge( opts, {initial_mode='normal'} )
  currentAgent = require('gp')._state.command_agent
  pickers
  .new(opts, {
    prompt_title = 'Command Agents [' .. currentAgent .. ']',
    finder = finders.new_table {
      results = require('gp')._chat_agents
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        map('n', 'o', function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            Gp_SetAgent_command( selection[1] )
          end)
        map('n', '<cr>', function() print( "use o to select" ) end)
      -- end)
      return true
    end,
  })
  :find()
end
-- Gp_SelectAgent_command()

function _G.Gp_SetAgent_command( name )
  local agent_name = string.gsub(name, "^%s*(.-)%s*$", "%1")
  require('gp').refresh_state({ command_agent = agent_name })
  print( "Command Agent: " .. agent_name )
end

-- Gp_SetAgent_chat( 'ChatGPT4o-mini' )
-- Gp_SetAgent_chat( 'ChatGPT4o' )

vim.keymap.set('n', '<leader>gco', function()
  Gp_SelectAgent_command()
end, {
  noremap = true,
  silent = false,
  nowait = true,
  desc = 'Select Command Agent',
})


-- ─^  Select Chat & Command Agent                       ▲



-- ─   Config                                           ──

-- os.getenv("OPENAI_API_KEY")
-- os.getenv("ANTHROPIC_API_KEY")

local conf = {
  openai_api_key = os.getenv("OPENAI_API_KEY"),

  providers = { -- ■
    openai = {
      disable = false,
      endpoint = "https://api.openai.com/v1/chat/completions",
      secret = os.getenv("OPENAI_API_KEY"),
    },
    azure = {
      disable = true,
      endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions",
      secret = os.getenv("AZURE_API_KEY"),
    },
    copilot = {
      disable = false,
      endpoint = "https://api.githubcopilot.com/chat/completions",
      secret = {
        "bash",
        "-c",
        "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
      },
    },
    ollama = {
      disable = false,
      endpoint = "http://localhost:11434/v1/chat/completions",
      secret = "dummy_secret",
    },
    lmstudio = {
      disable = true,
      endpoint = "http://localhost:1234/v1/chat/completions",
      secret = "dummy_secret",
    },
    googleai = {
      disable = true,
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
      secret = os.getenv("GOOGLEAI_API_KEY"),
    },
    pplx = {
      disable = true,
      endpoint = "https://api.perplexity.ai/chat/completions",
      secret = os.getenv("PPLX_API_KEY"),
    },
    anthropic = {
      disable = false,
      endpoint = "https://api.anthropic.com/v1/messages",
      secret = os.getenv("ANTHROPIC_API_KEY"),
    },
  },
 -- ▲

  agents = { -- ■
    {
      name = "ExampleDisabledAgent",
      disable = true,
    },
    {
      name = "ChatGPT4o",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "openai",
      name = "ChatGPT4o-mini",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "copilot",
      name = "ChatCopilot",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "googleai",
      name = "ChatGemini",
      disable = true,
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gemini-pro", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "pplx",
      name = "ChatPerplexityLlama3.1-8B",
      disable = true,
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "llama-3.1-sonar-small-128k-chat", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "ChatClaude-3-5-Sonnet",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-5-sonnet-20240620", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "ChatClaude-3-Haiku",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-haiku-20240307", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "ollama",
      name = "ChatOllamaLlama3.1-8B",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = {
        model = "llama3.1",
        temperature = 0.6,
        top_p = 1,
        min_p = 0.05,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.",
    },
    {
      provider = "lmstudio",
      name = "ChatLMStudio",
      disable = true,
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = {
        model = "dummy",
        temperature = 0.97,
        top_p = 1,
        num_ctx = 8192,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.",
    },
    {
      provider = "openai",
      name = "CodeGPT4o",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "openai",
      name = "CodeGPT4o-mini",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
    },
    {
      provider = "copilot",
      name = "CodeCopilot",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 0.8, top_p = 1, n = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "anthropic",
      name = "CodeClaude-3-5-Sonnet",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-5-sonnet-20240620", temperature = 0.8, top_p = 1 },
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "anthropic",
      name = "CodeClaude-3-Haiku",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-haiku-20240307", temperature = 0.8, top_p = 1 },
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "ollama",
      name = "CodeOllamaLlama3.1-8B",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = {
        model = "llama3.1",
        temperature = 0.4,
        top_p = 1,
        min_p = 0.05,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
  },
 -- ▲

  chat_dir = "/Users/at/Documents/Proj/j_edb_smithy/m/_data/chats/",

  chat_user_prefix = "💬:",

  chat_assistant_prefix = { "🤖:", "[{{agent}}]" },

  -- command config and templates below are used by commands like GpRewrite, GpEnew, etc.
  -- command prompt prefix for asking user for input (supports {{agent}} template variable)
  command_prompt_prefix_template = "🤖 {{agent}} ~ ",

  -- The banner shown at the top of each chat file.
  chat_template = require("gp.defaults").chat_template,
  -- chat_template = require("gp.defaults").short_chat_template,

  -- local shortcuts bound to the chat buffer
  -- (be careful to choose something which will work across specified modes)
  chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
  chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
  chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
  chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

  chat_finder_pattern = "",

  -- if true, finished ChatResponder won't move the cursor to the end of the buffer
  -- true cutted of the reponse in my first test
  chat_free_cursor = false,

  -- use prompt buftype for chats (:h prompt-buffer)
  -- TODO try
  chat_prompt_buf_type = false,

  image = { -- ■
    -- you can disable image generation logic completely by image = {disable = true}
    disable = false,
    -- openai api key (string or table with command and arguments)
    -- secret = { "cat", "path_to/openai_api_key" },
    -- secret = { "bw", "get", "password", "OPENAI_API_KEY" },
    -- secret =  "sk-...",
    -- secret = os.getenv("env_name.."),
    -- if missing openai_api_key is used
    secret = os.getenv("OPENAI_API_KEY"),
    -- image prompt prefix for asking user for input (supports {{agent}} template variable)
    prompt_prefix_template = "🖌️ {{agent}} ~ ",
    -- image prompt prefix for asking location to save the image
    prompt_save = "🖌️💾 ~ ",
    -- default folder for saving images
    -- store_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_images",
    store_dir = "/Users/at/Documents/Proj/j_edb_smithy/m/_data/gen_images/",
    -- default image agents (model + settings)
    -- to remove some default agent completely set it like:
    -- image.agents = {  { name = "DALL-E-3-1024x1792-vivid", disable = true, }, ... },
    agents = {
      {
        name = "ExampleDisabledAgent",
        disable = true,
      },
      {
        name = "DALL-E-3-1024x1024-vivid",
        model = "dall-e-3",
        quality = "standard",
        style = "vivid",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-vivid",
        model = "dall-e-3",
        quality = "standard",
        style = "vivid",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-vivid",
        model = "dall-e-3",
        quality = "standard",
        style = "vivid",
        size = "1024x1792",
      },
      {
        name = "DALL-E-3-1024x1024-natural",
        model = "dall-e-3",
        quality = "standard",
        style = "natural",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-natural",
        model = "dall-e-3",
        quality = "standard",
        style = "natural",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-natural",
        model = "dall-e-3",
        quality = "standard",
        style = "natural",
        size = "1024x1792",
      },
      {
        name = "DALL-E-3-1024x1024-vivid-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "vivid",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-vivid-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "vivid",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-vivid-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "vivid",
        size = "1024x1792",
      },
      {
        name = "DALL-E-3-1024x1024-natural-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "natural",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-natural-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "natural",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-natural-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "natural",
        size = "1024x1792",
      },
    },
  },

 -- ▲

}

require( 'gp' ).setup( conf )


local default_conf = {
  -- Please start with minimal config possible.
  -- Just openai_api_key if you don't have OPENAI_API_KEY env set up.
  -- Defaults change over time to improve things, options might get deprecated.
  -- It's better to change only things where the default doesn't fit your needs.

  -- required openai api key (string or table with command and arguments)
  -- openai_api_key = { "cat", "path_to/openai_api_key" },
  -- openai_api_key = { "bw", "get", "password", "OPENAI_API_KEY" },
  -- openai_api_key: "sk-...",
  -- openai_api_key = os.getenv("env_name.."),
  openai_api_key = os.getenv("OPENAI_API_KEY"),

  -- at least one working provider is required
  -- to disable a provider set it to empty table like openai = {}
  providers = {
    -- secrets can be strings or tables with command and arguments
    -- secret = { "cat", "path_to/openai_api_key" },
    -- secret = { "bw", "get", "password", "OPENAI_API_KEY" },
    -- secret : "sk-...",
    -- secret = os.getenv("env_name.."),
    openai = {
      disable = false,
      endpoint = "https://api.openai.com/v1/chat/completions",
      -- secret = os.getenv("OPENAI_API_KEY"),
    },
    azure = {
      disable = true,
      endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions",
      secret = os.getenv("AZURE_API_KEY"),
    },
    copilot = {
      disable = true,
      endpoint = "https://api.githubcopilot.com/chat/completions",
      secret = {
        "bash",
        "-c",
        "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
      },
    },
    ollama = {
      disable = true,
      endpoint = "http://localhost:11434/v1/chat/completions",
      secret = "dummy_secret",
    },
    lmstudio = {
      disable = true,
      endpoint = "http://localhost:1234/v1/chat/completions",
      secret = "dummy_secret",
    },
    googleai = {
      disable = true,
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
      secret = os.getenv("GOOGLEAI_API_KEY"),
    },
    pplx = {
      disable = true,
      endpoint = "https://api.perplexity.ai/chat/completions",
      secret = os.getenv("PPLX_API_KEY"),
    },
    anthropic = {
      disable = true,
      endpoint = "https://api.anthropic.com/v1/messages",
      secret = os.getenv("ANTHROPIC_API_KEY"),
    },
  },

  -- prefix for all commands
  cmd_prefix = "Gp",
  -- optional curl parameters (for proxy, etc.)
  -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
  curl_params = {},

  -- log file location
  log_file = vim.fn.stdpath("log"):gsub("/$", "") .. "/gp.nvim.log",
  -- write sensitive data to log file for	debugging purposes (like api keys)
  log_sensitive = false,

  -- directory for persisting state dynamically changed by user (like model or persona)
  state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",

  -- default agent names set during startup, if nil last used agent is used
  default_command_agent = nil,
  default_chat_agent = nil,

  -- default command agents (model + persona)
  -- name, model and system_prompt are mandatory fields
  -- to use agent for chat set chat = true, for command set command = true
  -- to remove some default agent completely set it like:
  -- agents = {  { name = "ChatGPT3-5", disable = true, }, ... },
  agents = {
    {
      name = "ExampleDisabledAgent",
      disable = true,
    },
    {
      name = "ChatGPT4o",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "openai",
      name = "ChatGPT4o-mini",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "copilot",
      name = "ChatCopilot",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "googleai",
      name = "ChatGemini",
      disable = true,
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gemini-pro", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "pplx",
      name = "ChatPerplexityLlama3.1-8B",
      disable = true,
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "llama-3.1-sonar-small-128k-chat", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "ChatClaude-3-5-Sonnet",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-5-sonnet-20240620", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "ChatClaude-3-Haiku",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-haiku-20240307", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "ollama",
      name = "ChatOllamaLlama3.1-8B",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = {
        model = "llama3.1",
        temperature = 0.6,
        top_p = 1,
        min_p = 0.05,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.",
    },
    {
      provider = "lmstudio",
      name = "ChatLMStudio",
      disable = true,
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = {
        model = "dummy",
        temperature = 0.97,
        top_p = 1,
        num_ctx = 8192,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.",
    },
    {
      provider = "openai",
      name = "CodeGPT4o",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "openai",
      name = "CodeGPT4o-mini",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
    },
    {
      provider = "copilot",
      name = "CodeCopilot",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 0.8, top_p = 1, n = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "anthropic",
      name = "CodeClaude-3-5-Sonnet",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-5-sonnet-20240620", temperature = 0.8, top_p = 1 },
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "anthropic",
      name = "CodeClaude-3-Haiku",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-haiku-20240307", temperature = 0.8, top_p = 1 },
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "ollama",
      name = "CodeOllamaLlama3.1-8B",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = {
        model = "llama3.1",
        temperature = 0.4,
        top_p = 1,
        min_p = 0.05,
      },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
  },

  -- directory for storing chat files
  -- chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
  chat_dir = "/Users/at/Documents/Proj/j_edb_smithy/m/_data/chats/",
  -- chat user prompt prefix
  chat_user_prefix = "💬:",
  -- chat assistant prompt prefix (static string or a table {static, template})
  -- first string has to be static, second string can contain template {{agent}}
  -- just a static string is legacy and the [{{agent}}] element is added automatically
  -- if you really want just a static string, make it a table with one element { "🤖:" }
  chat_assistant_prefix = { "🤖:", "[{{agent}}]" },
  -- The banner shown at the top of each chat file.
  chat_template = require("gp.defaults").chat_template,
  -- if you want more real estate in your chat files and don't need the helper text
  -- chat_template = require("gp.defaults").short_chat_template,
  -- chat topic generation prompt
  chat_topic_gen_prompt = "Summarize the topic of our conversation above"
    .. " in two or three words. Respond only with those words.",
  -- chat topic model (string with model name or table with model name and parameters)
  -- explicitly confirm deletion of a chat file
  chat_confirm_delete = true,
  -- conceal model parameters in chat
  chat_conceal_model_params = true,
  -- local shortcuts bound to the chat buffer
  -- (be careful to choose something which will work across specified modes)
  chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
  chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
  chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
  chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
  -- default search term when using :GpChatFinder
  chat_finder_pattern = "topic ",
  -- if true, finished ChatResponder won't move the cursor to the end of the buffer
  chat_free_cursor = false,
  -- use prompt buftype for chats (:h prompt-buffer)
  chat_prompt_buf_type = false,

  -- how to display GpChatToggle or GpContext: popup / split / vsplit / tabnew
  toggle_target = "vsplit",

  -- styling for chatfinder
  -- border can be "single", "double", "rounded", "solid", "shadow", "none"
  style_chat_finder_border = "single",
  -- margins are number of characters or lines
  style_chat_finder_margin_bottom = 8,
  style_chat_finder_margin_left = 1,
  style_chat_finder_margin_right = 2,
  style_chat_finder_margin_top = 2,
  -- how wide should the preview be, number between 0.0 and 1.0
  style_chat_finder_preview_ratio = 0.5,

  -- styling for popup
  -- border can be "single", "double", "rounded", "solid", "shadow", "none"
  style_popup_border = "single",
  -- margins are number of characters or lines
  style_popup_margin_bottom = 8,
  style_popup_margin_left = 1,
  style_popup_margin_right = 2,
  style_popup_margin_top = 2,
  style_popup_max_width = 160,

  -- in case of visibility colisions with other plugins, you can increase/decrease zindex
  zindex = 49,

  -- command config and templates below are used by commands like GpRewrite, GpEnew, etc.
  -- command prompt prefix for asking user for input (supports {{agent}} template variable)
  command_prompt_prefix_template = "🤖 {{agent}} ~ ",
  -- auto select command response (easier chaining of commands)
  -- if false it also frees up the buffer cursor for further editing elsewhere
  command_auto_select_response = true,

  -- templates
  template_selection = "I have the following from {{filename}}:"
    .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
  template_rewrite = "I have the following from {{filename}}:"
    .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
    .. "\n\nRespond exclusively with the snippet that should replace the selection above.",
  template_append = "I have the following from {{filename}}:"
    .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
    .. "\n\nRespond exclusively with the snippet that should be appended after the selection above.",
  template_prepend = "I have the following from {{filename}}:"
    .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
    .. "\n\nRespond exclusively with the snippet that should be prepended before the selection above.",
  template_command = "{{command}}",

  -- https://platform.openai.com/docs/guides/speech-to-text/quickstart
  -- Whisper costs $0.006 / minute (rounded to the nearest second)
  -- by eliminating silence and speeding up the tempo of the recording
  -- we can reduce the cost by 50% or more and get the results faster

  whisper = {
    -- you can disable whisper completely by whisper = {disable = true}
    disable = false,

    -- OpenAI audio/transcriptions api endpoint to transcribe audio to text
    endpoint = "https://api.openai.com/v1/audio/transcriptions",
    -- directory for storing whisper files
    store_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_whisper",
    -- multiplier of RMS level dB for threshold used by sox to detect silence vs speech
    -- decibels are negative, the recording is normalized to -3dB =>
    -- increase this number to pick up more (weaker) sounds as possible speech
    -- decrease this number to pick up only louder sounds as possible speech
    -- you can disable silence trimming by setting this a very high number (like 1000.0)
    silence = "1.75",
    -- whisper tempo (1.0 is normal speed)
    tempo = "1.75",
    -- The language of the input audio, in ISO-639-1 format.
    language = "en",
    -- command to use for recording can be nil (unset) for automatic selection
    -- string ("sox", "arecord", "ffmpeg") or table with command and arguments:
    -- sox is the most universal, but can have start/end cropping issues caused by latency
    -- arecord is linux only, but has no cropping issues and is faster
    -- ffmpeg in the default configuration is macos only, but can be used on any platform
    -- (see https://trac.ffmpeg.org/wiki/Capture/Desktop for more info)
    -- below is the default configuration for all three commands:
    -- whisper_rec_cmd = {"sox", "-c", "1", "--buffer", "32", "-d", "rec.wav", "trim", "0", "60:00"},
    -- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
    -- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},
    rec_cmd = nil,
  },

  -- image generation settings
  image = {
    -- you can disable image generation logic completely by image = {disable = true}
    disable = false,

    -- openai api key (string or table with command and arguments)
    -- secret = { "cat", "path_to/openai_api_key" },
    -- secret = { "bw", "get", "password", "OPENAI_API_KEY" },
    -- secret =  "sk-...",
    -- secret = os.getenv("env_name.."),
    -- if missing openai_api_key is used
    secret = os.getenv("OPENAI_API_KEY"),

    -- image prompt prefix for asking user for input (supports {{agent}} template variable)
    prompt_prefix_template = "🖌️ {{agent}} ~ ",
    -- image prompt prefix for asking location to save the image
    prompt_save = "🖌️💾 ~ ",
    -- default folder for saving images
    store_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_images",
    -- default image agents (model + settings)
    -- to remove some default agent completely set it like:
    -- image.agents = {  { name = "DALL-E-3-1024x1792-vivid", disable = true, }, ... },
    agents = {
      {
        name = "ExampleDisabledAgent",
        disable = true,
      },
      {
        name = "DALL-E-3-1024x1024-vivid",
        model = "dall-e-3",
        quality = "standard",
        style = "vivid",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-vivid",
        model = "dall-e-3",
        quality = "standard",
        style = "vivid",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-vivid",
        model = "dall-e-3",
        quality = "standard",
        style = "vivid",
        size = "1024x1792",
      },
      {
        name = "DALL-E-3-1024x1024-natural",
        model = "dall-e-3",
        quality = "standard",
        style = "natural",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-natural",
        model = "dall-e-3",
        quality = "standard",
        style = "natural",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-natural",
        model = "dall-e-3",
        quality = "standard",
        style = "natural",
        size = "1024x1792",
      },
      {
        name = "DALL-E-3-1024x1024-vivid-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "vivid",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-vivid-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "vivid",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-vivid-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "vivid",
        size = "1024x1792",
      },
      {
        name = "DALL-E-3-1024x1024-natural-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "natural",
        size = "1024x1024",
      },
      {
        name = "DALL-E-3-1792x1024-natural-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "natural",
        size = "1792x1024",
      },
      {
        name = "DALL-E-3-1024x1792-natural-hd",
        model = "dall-e-3",
        quality = "hd",
        style = "natural",
        size = "1024x1792",
      },
    },
  },

  -- example hook functions (see Extend functionality section in the README)
  hooks = {
    -- GpInspectPlugin provides a detailed inspection of the plugin state
    InspectPlugin = function(plugin, params)
      local bufnr = vim.api.nvim_create_buf(false, true)
      local copy = vim.deepcopy(plugin)
      local key = copy.config.openai_api_key or ""
      copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
      local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
      local params_info = string.format("Command params:\n%s", vim.inspect(params))
      local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      vim.api.nvim_win_set_buf(0, bufnr)
    end,

    -- GpInspectLog for checking the log file
    InspectLog = function(plugin, params)
      local log_file = plugin.config.log_file
      local buffer = plugin.helpers.get_buffer(log_file)
      if not buffer then
        vim.cmd("e " .. log_file)
      else
        vim.cmd("buffer " .. buffer)
      end
    end,

    -- GpImplement rewrites the provided selection/range based on comments in it
    Implement = function(gp, params)
      local template = "Having following from {{filename}}:\n\n"
      .. "```{{filetype}}\n{{selection}}\n```\n\n"
      .. "Please rewrite this according to the contained instructions."
      .. "\n\nRespond exclusively with the snippet that should replace the selection above."

      local agent = gp.get_command_agent()
      gp.logger.info("Implementing selection with agent: " .. agent.name)

      gp.Prompt(
        params,
        gp.Target.rewrite,
        agent,
        template,
        nil, -- command will run directly without any prompting for user input
        nil -- no predefined instructions (e.g. speech-to-text from Whisper)
      )
    end,

    -- your own functions can go here, see README for more examples like
    -- :GpExplain, :GpUnitTests.., :GpTranslator etc.

    -- -- example of making :%GpChatNew a dedicated command which
    -- -- opens new chat with the entire current buffer as a context
    -- BufferChatNew = function(gp, _)
    -- 	-- call GpChatNew command in range mode on whole buffer
    -- 	vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
    -- end,

    -- -- example of adding command which opens new chat dedicated for translation
    -- Translator = function(gp, params)
    -- 	local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
    -- 	gp.cmd.ChatNew(params, chat_system_prompt)
    --
    -- 	-- -- you can also create a chat with a specific fixed agent like this:
    -- 	-- local agent = gp.get_chat_agent("ChatGPT4o")
    -- 	-- gp.cmd.ChatNew(params, chat_system_prompt, agent)
    -- end,

    -- -- example of adding command which writes unit tests for the selected code
    -- UnitTests = function(gp, params)
    -- 	local template = "I have the following code from {{filename}}:\n\n"
    -- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
    -- 		.. "Please respond by writing table driven unit tests for the code above."
    -- 	local agent = gp.get_command_agent()
    -- 	gp.Prompt(params, gp.Target.enew, agent, template)
    -- end,

    -- -- example of adding command which explains the selected code
    -- Explain = function(gp, params)
    -- 	local template = "I have the following code from {{filename}}:\n\n"
    -- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
    -- 		.. "Please respond by explaining the code above."
    -- 	local agent = gp.get_chat_agent()
    -- 	gp.Prompt(params, gp.Target.popup, agent, template)
    -- end,
  },
}


-- vim.keymap.set({ "x" }, "<leader>gr", ":GpDiff ", { remap = true, desc = "GPT rewrite" })
-- vim.keymap.set({ "x" }, "<leader>gr", ":GpDiff ", { remap = true, desc = "GPT rewrite" })



local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local popup_options = {
  relative = "cursor",
  position = {
    row = 1,
    col = 0,
  },
  size = 20,
  border = {
    style = "rounded",
    text = {
      top = "[Input]",
      top_align = "left",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal",
  },
}


-- mount/open the component

-- local input = Input(popup_options, {
--   prompt = "> ",
--   default_value = "42",
--   on_close = function()
--     print("Input closed!")
--   end,
--   on_submit = function(value)
--     print("Value submitted: ", value)
--   end,
--   on_change = function(value)
--     print("Value changed: ", value)
--   end,
-- })

local function keymapOptions(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
end


-- ─   Diff custom command                              ──



vim.keymap.set("v", "<C-g>r", ":<C-u>lua _G.gp_diff_input(vim.fn.line(\"'<\"), vim.fn.line(\"'>\"))<CR>", { desc = "Diff selected lines" })

function _G.gp_diff_input(line1, line2)
  local input = Input({
    position = "50%",
    size = {
      width = 50,
    },
    border = {
      style = "single",
      text = {
        top = " Rewrite instruction ",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    prompt = " ",
    default_value = "",
    on_close = function()
      print("Input Closed!")
    end,
    on_submit = function(value)
      _G.gp_diff( value, line1, line2 )
    end,
  })

  -- unmount component when cursor leaves buffer
  input:on(event.BufLeave, function()
    input:unmount()
  end)

  input:mount()
end


function _G.gp_diff(instruction, line1, line2)
--   -- Grab all text/lines from the current buffer
  local contents = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false)

--   -- Create a new vert window and make the buffer temp.
  vim.cmd("vnew")
  local scratch_buf = vim.api.nvim_get_current_buf()
  vim.bo[scratch_buf].buftype = "nofile"
  vim.bo[scratch_buf].bufhidden = "wipe"

--   -- Put the lines in there
  vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, contents)

--   -- And run the Gp.rewrite command in that scratch buffer
  vim.cmd(line1 .. "," .. line2 .. "GpRewrite " .. instruction)

--   -- Then enter diff mode in the rewrite (right) and the original (left) window.
--   -- Apparently in this case vimdiff figures out how to diff the two buffers.
--   -- Also now the diff-put and diff-get maps work in the two buffers.
  vim.defer_fn(function()
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
  end, 1000)
end

vim.cmd("command! -range -nargs=+ GpDiff lua gp_diff(<line1>, <line2>)")


-- ─   Keymaps                                          ──


-- Chat commands
vim.keymap.set({"n", "i"}, "<C-g>c", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat"))
vim.keymap.set({"n", "i"}, "<C-g>t", "<cmd>GpChatToggle split<cr>", keymapOptions("Toggle Chat"))
vim.keymap.set({"n", "i"}, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New"))
vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle split<cr>", keymapOptions("Visual Toggle Chat"))

vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))

vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual Chat New vsplit"))
vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))

-- Prompt commands
-- vim.keymap.set({"n", "i"}, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
-- vim.keymap.set({"n", "i"}, "<C-g>r", "<cmd>GpDiff<cr>", keymapOptions("Inline Rewrite"))
vim.keymap.set({"n", "i"}, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set({"n", "i"}, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

-- vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpDiff<cr>", keymapOptions("Visual Rewrite"))
vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))

vim.keymap.set({"n", "i"}, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
vim.keymap.set({"n", "i"}, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions("GpEnew"))
vim.keymap.set({"n", "i"}, "<C-g>gn", "<cmd>GpNew<cr>", keymapOptions("GpNew"))
vim.keymap.set({"n", "i"}, "<C-g>gv", "<cmd>GpVnew<cr>", keymapOptions("GpVnew"))
vim.keymap.set({"n", "i"}, "<C-g>gt", "<cmd>GpTabnew<cr>", keymapOptions("GpTabnew"))

vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual GpEnew"))
vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", keymapOptions("Visual GpNew"))
vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual GpVnew"))
vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", keymapOptions("Visual GpTabnew"))

vim.keymap.set({"n", "i"}, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

vim.keymap.set({"n", "i", "v", "x"}, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
vim.keymap.set({"n", "i", "v", "x"}, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))

-- optional Whisper commands with prefix <C-g>w
vim.keymap.set({"n", "i"}, "<C-g>ww", "<cmd>GpWhisper<cr>", keymapOptions("Whisper"))
vim.keymap.set("v", "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", keymapOptions("Visual Whisper"))

vim.keymap.set({"n", "i"}, "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", keymapOptions("Whisper Inline Rewrite"))
vim.keymap.set({"n", "i"}, "<C-g>wa", "<cmd>GpWhisperAppend<cr>", keymapOptions("Whisper Append (after)"))
vim.keymap.set({"n", "i"}, "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", keymapOptions("Whisper Prepend (before) "))

vim.keymap.set("v", "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", keymapOptions("Visual Whisper Rewrite"))
vim.keymap.set("v", "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", keymapOptions("Visual Whisper Append (after)"))
vim.keymap.set("v", "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", keymapOptions("Visual Whisper Prepend (before)"))

vim.keymap.set({"n", "i"}, "<C-g>wp", "<cmd>GpWhisperPopup<cr>", keymapOptions("Whisper Popup"))
vim.keymap.set({"n", "i"}, "<C-g>we", "<cmd>GpWhisperEnew<cr>", keymapOptions("Whisper Enew"))
vim.keymap.set({"n", "i"}, "<C-g>wn", "<cmd>GpWhisperNew<cr>", keymapOptions("Whisper New"))
vim.keymap.set({"n", "i"}, "<C-g>wv", "<cmd>GpWhisperVnew<cr>", keymapOptions("Whisper Vnew"))
vim.keymap.set({"n", "i"}, "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", keymapOptions("Whisper Tabnew"))

vim.keymap.set("v", "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", keymapOptions("Visual Whisper Popup"))
vim.keymap.set("v", "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", keymapOptions("Visual Whisper Enew"))
vim.keymap.set("v", "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", keymapOptions("Visual Whisper New"))
vim.keymap.set("v", "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", keymapOptions("Visual Whisper Vnew"))
vim.keymap.set("v", "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", keymapOptions("Visual Whisper Tabnew"))

