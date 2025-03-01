
-- https://github.com/frankroeder/parrot.nvim

-- example hooks / prompts: nvim/lua/jack/plugins/parrot-ai.lua

-- os.getenv("OPENAI_API_KEY")
-- os.getenv("ANTHROPIC_API_KEY")

vim.keymap.set('n', '<c-g>c', ':PrtChatNew<CR>', { noremap = true, silent = true })

-- require("parrot").setup(
--   {
--     providers = {
--       anthropic = {
--         api_key = os.getenv "ANTHROPIC_API_KEY",
--       },
--     },
--   }
-- )

require("parrot").setup(
  {

    providers = {
      anthropic = {
        api_key = os.getenv "ANTHROPIC_API_KEY",
        topic_prompt = "You only respond with up to 5 words to summarize the past conversation.",
        topic = {
          -- model = "claude-3-haiku-20240307",
          -- model = "claude-3-5-haiku-20241022",
          model = "claude-3-5-haiku-latest",
          params = { max_tokens = 32 },
        },
      },
      openai = {
        api_key = os.getenv("OPENAI_API_KEY"),
      },
      github = {
        api_key = os.getenv "GITHUB_TOKEN",
      },
      pplx = {
        api_key = os.getenv "PERPLEXITY_API_KEY",
      },
    },

    system_prompt = {
      chat = "You are an AI assistant",
      command = "You are an AI assistant",
    },

    -- cmd_prefix = "P",
    -- chat_user_prefix = "☼ ",
    -- llm_prefix = "⌘ ",
    chat_user_prefix = "☼:",
    llm_prefix = "⌘:",

    chat_confirm_delete = false,
    online_model_selection = true,

    -- chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
    -- chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
    -- chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
    -- chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

    chat_free_cursor = true,

    -- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
    -- values: popup / split / vsplit / tabnew
    toggle_target = "vsplit",

    -- The interactive user input appearing when can be "native" for
    -- vim.ui.input or "buffer" to query the input within a native nvim buffer
    -- (see video demonstrations below)
    -- user_input_ui = "native",
    user_input_ui = "buffer",

    -- Popup window layout
    -- border: "single", "double", "rounded", "solid", "shadow", "none"
    style_popup_border = "single",

    -- margins are number of characters or lines
    style_popup_margin_bottom = 8,
    style_popup_margin_left = 1,
    style_popup_margin_right = 2,
    style_popup_margin_top = 2,
    style_popup_max_width = 160,

    -- Prompt used for interactive LLM calls like PrtRewrite where {{llm}} is
    -- a placeholder for the llm name
    -- command_prompt_prefix_template = "🤖 {{llm}} ~ ",
    command_prompt_prefix_template = "⌘ ",

    -- auto select command response (easier chaining of commands)
    -- if false it also frees up the buffer cursor for further editing elsewhere
    command_auto_select_response = true,

    -- fzf_lua options for PrtModel and PrtChatFinder when plugin is installed
    fzf_lua_opts = {
      ["--ansi"] = true,
      ["--sort"] = "",
      ["--info"] = "inline",
      ["--layout"] = "reverse",
      ["--preview-window"] = "nohidden:right:75%",
    },

    -- Enables the query spinner animation 
    enable_spinner = true,
    -- Type of spinner animation to display while loading
    -- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
    spinner_type = "star",

    hooks = {

      CodeConsultant = function(prt, params)
        local chat_prompt = [[
          Your task is to analyze the provided {{filetype}} code and suggest
          improvements.
          I generally prefer a functional style of programming.

          Here is the code
          ```{{filetype}}
          {{filecontent}}
          ```
        ]]
        prt.ChatNew(params, chat_prompt)
      end,

      CompleteFullContext = function(prt, params)
        local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{filecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        ]]
        local model_obj = prt.get_model("command")
        prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
      end,

      SpellCheck = function(prt, params)
        local chat_prompt = [[
          Your task is to take the text provided and rewrite it into a clear,
          grammatically correct version while preserving the original meaning
          as closely as possible. Correct any spelling mistakes, punctuation
          errors, verb tense issues, word choice problems, and other
          grammatical mistakes.
        ]]
        prt.ChatNew(params, chat_prompt)
      end,
    }


  }
)


-- require("parrot").setup({
local conf =({
  -- The provider definitions include endpoints, API keys, default parameters,
  -- and topic model arguments for chat summarization, with an example provided for Anthropic.
  providers = {
    anthropic = {
      api_key = os.getenv("ANTHROPIC_API_KEY"),
      -- OPTIONAL: Alternative methods to retrieve API key
      -- Using GPG for decryption:
      -- api_key = { "gpg", "--decrypt", vim.fn.expand("$HOME") .. "/anthropic_api_key.txt.gpg" },
      -- Using macOS Keychain:
      -- api_key = { "/usr/bin/security", "find-generic-password", "-s anthropic-api-key", "-w" },
      -- endpoint = "https://api.anthropic.com/v1/messages",
      -- topic_prompt = "You only respond with 3 to 4 words to summarize the past conversation.",
      topic_prompt = "You only respond with up to 7 words to summarize the past conversation.",
      -- usually a cheap and fast model to generate the chat topic based on
      -- the whole chat history
      topic = {
        -- model = "claude-3-haiku-20240307",
        -- model = "claude-3-5-haiku-20241022",
        model = "claude-3-5-haiku-latest",
        params = { max_tokens = 32 },
      },
      -- default parameters for the actual model
      -- params = {
      --   chat = { max_tokens = 4096 },
      --   command = { max_tokens = 4096 },
      -- },
    },

    openai = {
      api_key = os.getenv("OPENAI_API_KEY"),
    },
    github = {
      api_key = os.getenv "GITHUB_TOKEN",
    },
    pplx = {
      api_key = os.getenv "PERPLEXITY_API_KEY",
    },

  },

  -- default system prompts used for the chat sessions and the command routines
  -- ~/.config/nvim/plugged/parrot.nvim/lua/parrot/config.lua‖/localˍsystem_chat_promptˍ=
  system_prompt = {
    chat = [[
      You are an AI assistant
      ]],
    command = [[
      You are an AI assistant
      ]]
  },

  -- the prefix used for all commands
  cmd_prefix = "P",

  -- optional parameters for curl
  curl_params = {},

  -- The directory to store persisted state information like the
  -- current provider and the selected models
  state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",

  -- The directory to store the chats (searched with PrtChatFinder)
  chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",

  -- Chat user prompt prefix
  -- chat_user_prefix = "✼ ",
  chat_user_prefix = "☼ ",

  -- llm prompt prefix
  -- llm_prefix = "ᑓ ",
  llm_prefix = "⌘ ",

  -- Explicitly confirm deletion of a chat file
  chat_confirm_delete = false,

  -- When available, call API for model selection
  online_model_selection = true,

  -- Local chat buffer shortcuts
  chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
  chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
  chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
  chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

  -- Option to move the cursor to the end of the file after finished respond
  chat_free_cursor = true,

  -- use prompt buftype for chats (:h prompt-buffer)
  chat_prompt_buf_type = false,

  -- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
  -- values: popup / split / vsplit / tabnew
  toggle_target = "vsplit",

  -- The interactive user input appearing when can be "native" for
  -- vim.ui.input or "buffer" to query the input within a native nvim buffer
  -- (see video demonstrations below)
  -- user_input_ui = "native",
  user_input_ui = "buffer",

  -- Popup window layout
  -- border: "single", "double", "rounded", "solid", "shadow", "none"
  style_popup_border = "single",

  -- margins are number of characters or lines
  style_popup_margin_bottom = 8,
  style_popup_margin_left = 1,
  style_popup_margin_right = 2,
  style_popup_margin_top = 2,
  style_popup_max_width = 160,

  -- Prompt used for interactive LLM calls like PrtRewrite where {{llm}} is
  -- a placeholder for the llm name
  -- command_prompt_prefix_template = "🤖 {{llm}} ~ ",
  command_prompt_prefix_template = "⌘ ",

  -- auto select command response (easier chaining of commands)
  -- if false it also frees up the buffer cursor for further editing elsewhere
  command_auto_select_response = true,

  -- fzf_lua options for PrtModel and PrtChatFinder when plugin is installed
  fzf_lua_opts = {
    ["--ansi"] = true,
    ["--sort"] = "",
    ["--info"] = "inline",
    ["--layout"] = "reverse",
    ["--preview-window"] = "nohidden:right:75%",
  },

  -- Enables the query spinner animation 
  -- enable_spinner = true,
  -- Type of spinner animation to display while loading
  -- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
  -- spinner_type = "star",

  hooks = {

    CodeConsultant = function(prt, params)
      local chat_prompt = [[
          Your task is to analyze the provided {{filetype}} code and suggest
          improvements.
          I generally prefer a functional style of programming.

          Here is the code
          ```{{filetype}}
          {{filecontent}}
          ```
        ]]
      prt.ChatNew(params, chat_prompt)
    end,

    CompleteFullContext = function(prt, params)
      local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{filecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        ]]
      local model_obj = prt.get_model("command")
      prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
    end,

    SpellCheck = function(prt, params)
      local chat_prompt = [[
          Your task is to take the text provided and rewrite it into a clear,
          grammatically correct version while preserving the original meaning
          as closely as possible. Correct any spelling mistakes, punctuation
          errors, verb tense issues, word choice problems, and other
          grammatical mistakes.
        ]]
      prt.ChatNew(params, chat_prompt)
    end,
  }


})



