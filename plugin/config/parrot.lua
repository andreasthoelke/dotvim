

-- example hooks / prompts: https://github.com/jackfranklin/dotfiles/blob/90a88677f197705ac3381fd07d2d4772a5e2b92d/nvim/lua/jack/plugins/parrot-ai.lua#L4
-- Full default config: ~/.config/nvim/plugged/parrot.nvim/lua/parrot/config.lua

-- os.getenv("OPENAI_API_KEY")
-- os.getenv("ANTHROPIC_API_KEY")
-- os.getenv("PERPLEXITY_API_KEY")

-- MAPS:
-- Search in aichats folder: ~/.local/share/nvim/parrot/chats
-- l sfc   - AI Chats topics
-- l sfC   - full text
-- old:
-- Rather use ,scc ~/.config/nvim/plugin/config/telescope.vim‖/nnoremapˍ,sccˍ<cmd>luaˍreq
-- vim.keymap.set('n', '<leader>gsP', ':PrtChatFinder<CR>', { noremap = true, silent = true })

-- TODO show the current model selected in the winbar? lua putt( require("parrot.config").get_status_info() )

local OPENAI_PRIMARY_MODEL = "gpt-5.1"
local OPENAI_REASONING_DEFAULT = "medium"
local OPENAI_REASONING_SYMBOLS = {
  low = "L",
  medium = "M",
  high = "H",
}

local function refresh_winbar()
  vim.schedule(function()
    local ok, lualine = pcall(require, "lualine")
    if ok and type(lualine.refresh) == "function" then
      pcall(lualine.refresh, { place = { "winbar" } })
    end
  end)
end

-- The Parrot plugin persists the last selected model in state.json and will
-- continue using that value even after the config is updated. This helper pins
-- the OpenAI provider back to our preferred GPT-5.1 model whenever Neovim
-- starts, so the UI and requests consistently use the intended model.
local function pin_openai_models(model_name)
  vim.schedule(function()
    local ok, parrot_config = pcall(require, "parrot.config")
    if not ok then
      return
    end
    local handler = parrot_config.chat_handler
    if not handler or not handler.state then
      return
    end
    local state = handler.state
    local provider = "openai"
    if not state._state or not state._state[provider] then
      return
    end

    local changed = false
    for _, model_type in ipairs({ "chat", "command" }) do
      local ok_get, current = pcall(state.get_model, state, provider, model_type)
      if ok_get and current ~= model_name then
        state:set_model(provider, model_name, model_type)
        if state.file_state and state.file_state[provider] then
          state.file_state[provider][model_type .. "_model"] = model_name
        end
        changed = true
      end
    end

    if changed then
      state:save()
      if parrot_config.logger and parrot_config.logger.debug then
        parrot_config.logger.debug(
          string.format("Pinned %s chat/command models to %s via config override", provider, model_name)
        )
      end
    end
  end)
end

local function force_openai_provider()
  vim.schedule(function()
    local ok, parrot_config = pcall(require, "parrot.config")
    if not ok then
      return
    end
    local handler = parrot_config.chat_handler
    if not handler or type(handler.switch_provider) ~= "function" then
      return
    end
    for _, is_chat in ipairs({ true, false }) do
      local ok_switch, err = pcall(handler.switch_provider, handler, "openai", is_chat)
      if not ok_switch and parrot_config.logger and parrot_config.logger.debug then
        parrot_config.logger.debug("Failed to set openai provider", { chat = is_chat, error = err })
      end
    end
  end)
end

local function get_parrot_openai_context()
  local ok, parrot_config = pcall(require, "parrot.config")
  if not ok then
    return nil
  end
  local handler = parrot_config.chat_handler
  if not handler or not handler.providers or not handler.providers.openai then
    return nil
  end
  return parrot_config, handler
end

local function get_openai_reasoning_level()
  local parrot_config, handler = get_parrot_openai_context()
  if not parrot_config then
    return OPENAI_REASONING_DEFAULT
  end
  local params = handler.providers.openai.params
  if not params or not params.chat then
    return OPENAI_REASONING_DEFAULT
  end
  return params.chat.reasoning_effort or OPENAI_REASONING_DEFAULT
end

local function set_openai_reasoning(level)
  local parrot_config, handler = get_parrot_openai_context()
  if not parrot_config then
    return false
  end

  local changed = false
  local containers = {}
  if handler.providers and handler.providers.openai then
    table.insert(containers, handler.providers.openai)
  end
  if parrot_config.providers and parrot_config.providers.openai then
    table.insert(containers, parrot_config.providers.openai)
  end

  for _, provider in ipairs(containers) do
    if provider.params then
      for _, mode in ipairs({ "chat", "command" }) do
        provider.params[mode] = provider.params[mode] or {}
        if provider.params[mode].reasoning_effort ~= level then
          provider.params[mode].reasoning_effort = level
          changed = true
        end
      end
    end
  end

  if changed then
    local msg = string.format("OpenAI reasoning effort set to %s", level)
    if parrot_config.logger and parrot_config.logger.info then
      parrot_config.logger.info(msg)
    else
      vim.notify(msg, vim.log.levels.INFO)
    end
    refresh_winbar()
  end
  return changed
end

local function toggle_openai_reasoning()
  local current = get_openai_reasoning_level()
  if current == "high" then
    return set_openai_reasoning(OPENAI_REASONING_DEFAULT)
  end
  return set_openai_reasoning("high")
end

local function get_openai_reasoning_indicator()
  local level = get_openai_reasoning_level()
  return OPENAI_REASONING_SYMBOLS[level] or (level and level:sub(1, 1):upper()) or nil
end

local function format_llm_label(model_name, provider_name)
  if provider_name == "openai" then
    local indicator = get_openai_reasoning_indicator()
    if indicator then
      return string.format("%s:%s", model_name, indicator)
    end
    return model_name
  end
  return string.format("%s - %s", model_name, provider_name)
end

function _G.Parrot_chat_status_label()
  local ok, parrot_config = pcall(require, "parrot.config")
  if not ok or type(parrot_config.get_status_info) ~= "function" then
    return ""
  end

  local ok_status, status_info = pcall(parrot_config.get_status_info)
  if not ok_status or not status_info or not status_info.model then
    return ""
  end

  local provider
  if status_info.prov then
    if status_info.is_chat then
      provider = status_info.prov.chat
    else
      provider = status_info.prov.command
    end
  end

  if provider and provider.name then
    return format_llm_label(status_info.model, provider.name)
  end

  return status_info.model or ""
end

local function register_reasoning_commands()
  if vim.g.parrot_reasoning_commands_registered then
    return
  end

  local function wrap(cb)
    return function()
      local ok = cb()
      if not ok then
        vim.notify("Parrot reasoning controls unavailable", vim.log.levels.ERROR)
      end
    end
  end

  vim.api.nvim_create_user_command(
    "PrtReasoningHigh",
    wrap(function()
      return set_openai_reasoning("high")
    end),
    { desc = "Parrot: set OpenAI reasoning effort to high" }
  )
  vim.api.nvim_create_user_command(
    "PrtReasoningMedium",
    wrap(function()
      return set_openai_reasoning(OPENAI_REASONING_DEFAULT)
    end),
    { desc = "Parrot: set OpenAI reasoning effort to medium" }
  )
  vim.api.nvim_create_user_command(
    "PrtReasoningToggle",
    wrap(function()
      return toggle_openai_reasoning()
    end),
    { desc = "Parrot: toggle OpenAI reasoning effort between medium and high" }
  )

  vim.g.parrot_reasoning_commands_registered = true
end

require("parrot").setup(
  {
    providers = {
      anthropic = {
        name = "anthropic",
        endpoint = "https://api.anthropic.com/v1/messages",
        model_endpoint = "https://api.anthropic.com/v1/models",
        params = {
          chat = { max_tokens = 4096 },
          command = { max_tokens = 4096 },
        },
        topic = {
          model = "claude-haiku-4-5-20251001",
          params = { max_tokens = 32 },
        },
        headers = function(self)
          return {
            ["Content-Type"] = "application/json",
            ["x-api-key"] = self.api_key,
            ["anthropic-version"] = "2023-06-01",
          }
        end,
        preprocess_payload = function(payload)
          for _, message in ipairs(payload.messages) do
            message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
          end
          if payload.messages[1] and payload.messages[1].role == "system" then
            -- remove the first message that serves as the system prompt as anthropic
            -- expects the system prompt to be part of the API call body and not the messages
            payload.system = payload.messages[1].content
            table.remove(payload.messages, 1)
          end
          return payload
        end,

        api_key = os.getenv "ANTHROPIC_API_KEY",
        -- model = "claude-opus-4-20250514",
        model = "claude-opus-4-1-20250805",
        models = {
          "claude-opus-4-1-20250805",
          "claude-opus-4-20250514",
          "claude-sonnet-4-20250514",
          "claude-haiku-4-5-20251001",
        },
        topic_prompt = "You only respond with up to 5 words to summarize the past conversation.",
      },
      openai = {
        -- NOTE: When adding new models, be aware that the model picker may not correctly save
        -- the full model name (e.g., selecting "gpt-5.1" may save as "gpt-5" in state file).
        -- The persisted state file (~/.local/share/nvim/parrot/persisted/state.json) contains
        -- chat_model and command_model that override config defaults. You may need to manually
        -- edit the state file or delete it entirely to force using config defaults.
        name = "openai",
        api_key = os.getenv("OPENAI_API_KEY"),
        endpoint = "https://api.openai.com/v1/chat/completions",
        model_endpoint = "https://api.openai.com/v1/models",
        model = OPENAI_PRIMARY_MODEL,
        models = {
          OPENAI_PRIMARY_MODEL,
          "gpt-5-mini",
          "gpt-4o",
          "gpt-4o-mini",
        },
        params = {
          chat = { max_completion_tokens = 4096, reasoning_effort = OPENAI_REASONING_DEFAULT },
          command = { max_completion_tokens = 4096, reasoning_effort = OPENAI_REASONING_DEFAULT },
        },
        topic = {
          -- Use a fast non-reasoning model for topic summaries to avoid GPT-5 spinner issues
          model = "gpt-4o-mini",
          params = { max_completion_tokens = 100, temperature = 0.2 },
        },
        preprocess_payload = function(payload)
          for _, message in ipairs(payload.messages) do
            message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
          end
          -- Handle GPT-5 reasoning models
          if payload.model and string.match(payload.model, "^gpt%-5") then
            -- Remove system prompt (not supported by GPT-5)
            if payload.messages[1] and payload.messages[1].role == "system" then
              table.remove(payload.messages, 1)
            end
            -- Use reasoning_effort from params if provided, otherwise default to "high"
            payload.reasoning_effort = payload.reasoning_effort or "high"
            -- Set fixed values for unsupported parameters
            payload.temperature = 1
            payload.top_p = 1
            payload.presence_penalty = 0
            payload.frequency_penalty = 0
            payload.logprobs = nil
            payload.logit_bias = nil
            payload.top_logprobs = nil
          end
          -- Handle o1/o3/o4 models
          if payload.model and string.match(payload.model, "^o[134]") then
            if payload.messages[1] and payload.messages[1].role == "system" then
              table.remove(payload.messages, 1)
            end
            payload.temperature = 1
            payload.top_p = 1
            payload.presence_penalty = 0
            payload.frequency_penalty = 0
            payload.logprobs = nil
            payload.logit_bias = nil
            payload.top_logprobs = nil
          end
          return payload
        end,
      },
      -- NOTE: needs GITHUB_TOKEN which somehow conflicts with the 'gh' app.
      -- github = {
      --   name = "github",
      --   api_key = os.getenv "GITHUB_TOKEN",
      --   endpoint = "https://models.inference.ai.azure.com/chat/completions",
      --   model = "gpt-4o",
      --   models = {
      --     "gpt-4o",
      --     "gpt-4o-mini",
      --     "ai21-jamba-1.5-mini",
      --     "ai21-jamba-1.5-large",
      --     "cohere-command-r",
      --     "cohere-command-r-plus",
      --     "meta-llama-3.1-8b-instruct",
      --     "meta-llama-3.1-70b-instruct",
      --     "meta-llama-3.1-405b-instruct",
      --     "mistral-large-2407",
      --     "mistral-nemo",
      --     "mistral-small",
      --     "phi-3.5-mini-128k-instruct",
      --     "phi-3.5-moe-128k-instruct",
      --     "phi-3-medium-128k-instruct",
      --   },
      -- },
      pplx = {
        name = "pplx",
        api_key = os.getenv "PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai/chat/completions",
        model = "sonar-medium-online",
        models = {
          "sonar-small-online",
          "sonar-medium-online",
          "sonar-small-chat",
          "sonar-medium-chat",
        },
      },
      gemini = {
        name = "gemini",
        api_key = os.getenv "GEMINI_API_KEY",
        model = "gemini-2.5-pro",
        models = {
          "gemini-2.5-pro",
          "gemini-2.5-flash",
        },
        endpoint = function(self)
          return "https://generativelanguage.googleapis.com/v1beta/models/"
            .. self._model
            .. ":streamGenerateContent?alt=sse"
        end,
        model_endpoint = function(self)
          return { "https://generativelanguage.googleapis.com/v1beta/models?key=" .. self.api_key }
        end,
        params = {
          chat = { temperature = 1.1, topP = 1, topK = 10, maxOutputTokens = 8192 },
          command = { temperature = 0.8, topP = 1, topK = 10, maxOutputTokens = 8192 },
        },
        topic = {
          model = "gemini-1.5-flash",
          params = { maxOutputTokens = 64 },
        },
        headers = function(self)
          return {
            ["Content-Type"] = "application/json",
            ["x-goog-api-key"] = self.api_key,
          }
        end,
        preprocess_payload = function(payload)
          local contents = {}
          local system_instruction = nil
          for _, message in ipairs(payload.messages) do
            if message.role == "system" then
              system_instruction = { parts = { { text = message.content } } }
            else
              local role = message.role == "assistant" and "model" or "user"
              table.insert(
                contents,
                { role = role, parts = { { text = message.content:gsub("^%s*(.-)%s*$", "%1") } } }
              )
            end
          end
          local gemini_payload = {
            contents = contents,
            generationConfig = {
              temperature = payload.temperature,
              topP = payload.topP or payload.top_p,
              maxOutputTokens = payload.max_tokens or payload.maxOutputTokens,
            },
          }
          if system_instruction then
            gemini_payload.systemInstruction = system_instruction
          end
          return gemini_payload
        end,
        process_stdout = function(response)
          if not response or response == "" then
            return nil
          end
          local success, decoded = pcall(vim.json.decode, response)
          if
            success
            and decoded.candidates
            and decoded.candidates[1]
            and decoded.candidates[1].content
            and decoded.candidates[1].content.parts
            and decoded.candidates[1].content.parts[1]
          then
            return decoded.candidates[1].content.parts[1].text
          end
          return nil
        end,

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
    llm_label_formatter = function(model_name, provider_name)
      return format_llm_label(model_name, provider_name)
    end,

    chat_confirm_delete = false,
    online_model_selection = true,

-- ─   Keymaps buffer                                   ──
    chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<c-w><cr>" },
    chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
    chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
    -- Chat clear
    -- chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>C" },

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
      ["--sort"] = true,
      ["--info"] = "inline",
      ["--layout"] = "reverse",
      ["--preview-window"] = "nohidden:right:75%",
    },

    -- Enables the query spinner animation 
    enable_spinner = true,
    -- Type of spinner animation to display while loading
    -- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
    spinner_type = "star",

-- ─      Hooks                                        ──
    hooks = {

      Status = function(prt, _)
        local status_info = prt.get_status_info()
        local provider = status_info.is_chat and status_info.prov.chat or status_info.prov.command
        local provider_name = provider and provider.name or "?"
        local model_label = provider and format_llm_label(status_info.model, provider.name) or status_info.model
        prt.logger.info(string.format("Current provider: %s (%s)", provider_name, model_label))
      end,

      ChatWithFileContext = function(prt, params)
        local chat_prompt = [[
        Let us talk about this code in file {{filename}}
        ```{{filetype}}
        {{filecontent}}
        ```
        ]]
        prt.ChatNew(params, chat_prompt)
      end,

      ChatWithAllBuffers = function(prt, params)
        local chat_prompt = [[
        For this conversation, I have the following context.

        These are the files I currently have open.

        {{multifilecontent}}

        I'm currently in file {{filename}}
        ]]
        prt.ChatNew(params, chat_prompt)
      end,

      RewriteFullContext = function(prt, params)
        local chat_prompt = [[
        I have the following selection from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        This is the full file for context:

        ```{{filetype}}
        {{filecontent}}
        ```

        {{command}}
        Respond exclusively with the snippet that should replace the selection above.
        DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
        ]]
        local model_obj = prt.get_model("command")
        prt.Prompt(params, prt.ui.Target.rewrite, model_obj, "☼: ", chat_prompt)
      end,

      AppendFullContext = function(prt, params)
        local chat_prompt = [[
        I have the following selection from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        This is the full file for context:

        ```{{filetype}}
        {{filecontent}}
        ```

        {{command}}
        Respond exclusively with the snippet that should appended the selection above.
        DO NOT RESPOND WITH ANY TYPE OF COMMENTS, JUST THE CODE!!!
        ]]
        local model_obj = prt.get_model("command")
        prt.Prompt(params, prt.ui.Target.rewrite, model_obj, "☼: ", chat_prompt)
      end,


      CodeConsultant = function(prt, params)
        local chat_prompt = [[
          Your task is to analyze the provided {{filetype}} code and suggest
          improvements.

          Here is the code
          ```{{filetype}}
          {{filecontent}}
          ```
        ]]
        prt.ChatNew(params, chat_prompt)
      end,

      Complete = function(prt, params)
        local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted."
        ]]
        local model_obj = prt.get_model "command"
        prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
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

      CompleteMultiContext = function(prt, params)
        local template = [[
        I have the following code from {{filename}} and other realted files:

        ```{{filetype}}
        {{multifilecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        ]]
        local model_obj = prt.get_model "command"
        prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
      end,

      Explain = function(prt, params)
        local template = [[
        Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
        Break down the code's functionality, purpose, and key components.
        The goal is to help the reader understand what the code does and how it works.

        ```{{filetype}}
        {{selection}}
        ```

        Use the markdown format with codeblocks and inline code.
        Explanation of the code above:
        ]]
        local model = prt.get_model "command"
        prt.logger.info("Explaining selection with model: " .. model.name)
        prt.Prompt(params, prt.ui.Target.new, model, nil, template)
      end,

      FixBugs = function(prt, params)
        local template = [[
        You are an expert in {{filetype}}.
        Fix bugs in the below code from {{filename}} carefully and logically:
        Your task is to analyze the provided {{filetype}} code snippet, identify
        any bugs or errors present, and provide a corrected version of the code
        that resolves these issues. Explain the problems you found in the
        original code and how your fixes address them. The corrected code should
        be functional, efficient, and adhere to best practices in
        {{filetype}} programming.

        ```{{filetype}}
        {{selection}}
        ```

        Fixed code:
        ]]
        local model_obj = prt.get_model "command"
        prt.logger.info("Fixing bugs in selection with model: " .. model_obj.name)
        prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
      end,

      UnitTests = function(prt, params)
        local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please respond by writing table driven unit tests for the code above.
        ]]
        local model_obj = prt.get_model "command"
        prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
        prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
      end,

      ImplementWithFileCtx = function(parrot, params)
        local template = [[
        Consider the following content from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please rewrite this according to the contained instructions.
        Respond exclusively with the snippet that should replace the selection above.
        ]]
        local model_obj = parrot.get_model("command")
        parrot.logger.info("Implementing selection with model: " .. model_obj.name)
        parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, nil, template)
      end,

      SpellCheck1 = function(prt, params)
        local chat_prompt = [[
          Your task is to take the text provided and rewrite it into a clear,
          grammatically correct version while preserving the original meaning
          as closely as possible. Correct any spelling mistakes, punctuation
          errors, verb tense issues, word choice problems, and other
          grammatical mistakes.
        ]]
        prt.ChatNew(params, chat_prompt)
      end,

      SpellCheck = function(prt, params)
        local template = [[
        Your task is to look through the code provided in the file and list any
        potential spelling mistakes. Quote each part that you think is
        incorrect. Suggest the correct
        spelling. Correct any spelling mistakes, punctuation
        errors, verb tense issues, word choice problems, and other
        grammatical mistakes. Return your answer as a formatted markdown list.
        The start of each item should follow the format "Line X", replacing "X"
        with the actual line number, and make the "Line X" part bold. Return
        the lines sorted in ascending order.

        Here is the input to check:
        ```{{filetype}}
        {{filecontent}}
        ```
        ]]
        local model_obj = prt.get_model("command")
        prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
      end,

      Outline = function(prt, params)
        local template = [[
        I want you to act as {{filetype}} expert.
        Review the entire code in this file, carefully examine it, and then
        report an outline of the core parts of the code.
        Keep your explanation short and to the point and format it using markdown:

        ```{{filetype}}
        {{filecontent}}
        ```
        ]]
        local model_obj = prt.get_model("command")
        prt.logger.info("Outlining file with model: " .. model_obj.name)
        prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
      end,


      Debug = function(prt, params)
        local template = [[
        I want you to act as {{filetype}} expert.
        Review the following code, carefully examine it, and report potential
        bugs and edge cases alongside solutions to resolve them.
        Keep your explanation short and to the point:

        ```{{filetype}}
        {{selection}}
        ```
        ]]
        local model_obj = prt.get_model("command")
        prt.logger.info("Debugging selection with model: " .. model_obj.name)
        prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
      end,
      DebugFile = function(prt, params)
        local template = [[
        I want you to act as {{filetype}} expert.
        Review the following code, carefully examine it, and report potential
        bugs alongside solutions to resolve them.
        Keep your explanation short and to the point:

        ```{{filetype}}
        {{filecontent}}
        ```
        ]]
        local model_obj = prt.get_model("command")
        prt.logger.info("Debugging selection with model: " .. model_obj.name)
        prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
      end,
      CommitMsg = function(prt, params)
        local futils = require("parrot.file_utils")
        if futils.find_git_root() == "" then
          prt.logger.warning("Not in a git repository")
          return
        else
          local template = [[
          I want you to act as a commit message generator. I will provide you
          with information about the task and the prefix for the task code, and
          I would like you to generate an appropriate commit message.

          IMPORTANT: do not use the conventional commit format or any other format that prefixes the commit message.
          Do not write any explanations or other words, just reply with the commit message.
          Start with a short headline as summary and then list the individual changes in more detail.

          Here are the changes that should be considered by this message:
          ]] .. vim.fn.system("git diff --no-color --no-ext-diff --staged")
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
        end
      end,

      ProofReader = function(prt, params)
        local chat_prompt = [[
        I want you to act as a proofreader. I will provide you with texts and
        I would like you to review them for any spelling, grammar, or
        punctuation errors. Once you have finished reviewing the text,
        provide me with any necessary corrections or suggestions to improve the
        text. Highlight the corrected fragments (if any) using markdown backticks.

        When you have done that subsequently provide me with a slightly better
        version of the text, but keep close to the original text.

        Finally provide me with an ideal version of the text.

        Whenever I provide you with text, you reply in this format directly:

        ## Corrected text:

        {corrected text, or say "NO_CORRECTIONS_NEEDED" instead if there are no corrections made}

        ## Slightly better text

        {slightly better text}

        ## Ideal text

        {ideal text}
        ]]
        prt.ChatNew(params, chat_prompt)
      end,

    }


  }
)

-- Suppress "Switched to provider" startup messages
local parrot_logger = require("parrot.logger")
local original_info = parrot_logger.info
parrot_logger.info = function(msg)
  if not msg:match("^Switched to provider:") then
    original_info(msg)
  end
end

pin_openai_models(OPENAI_PRIMARY_MODEL)
force_openai_provider()
register_reasoning_commands()
refresh_winbar()


      -- openai = {
      --   name = "openai",
      --   api_key = os.getenv("OPENAI_API_KEY"),
      --   endpoint = "https://api.openai.com/v1/chat/completions",
      --   model_endpoint = "https://api.openai.com/v1/models",
      --   model = "gpt-5",
      --   models = {
      --     "gpt-5",
      --     "gpt-5-mini",
      --     "gpt-4o",
      --   },
      --   params = {
      --     chat = { max_completion_tokens = 4096 },
      --     command = { max_completion_tokens = 4096 },
      --   },
      --   --   Claude: .. | /Users/at/.local/share/nvim/parrot/chats/2025-10-07.21-24-16.md
      --   -- ADD THIS: Custom preprocessing for GPT-5
      --   preprocess_payload = function(payload)
      --     for _, message in ipairs(payload.messages) do
      --       message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
      --     end
      --     -- Handle GPT-5 reasoning models (same restrictions as o1/o3/o4)
      --     if payload.model and string.match(payload.model, "^gpt%-5") then
      --       -- Remove system prompt (not supported by GPT-5)
      --       if payload.messages[1] and payload.messages[1].role == "system" then
      --         table.remove(payload.messages, 1)
      --       end
      --       -- Set extended thinking
      --       payload.reasoning_effort = "high"
      --       -- Set fixed values for unsupported parameters
      --       payload.temperature = 1
      --       payload.top_p = 1
      --       payload.presence_penalty = 0
      --       payload.frequency_penalty = 0
      --       payload.logprobs = nil
      --       payload.logit_bias = nil
      --       payload.top_logprobs = nil
      --     end
      --     -- Handle o1/o3/o4 models (from plugin defaults)
      --     if payload.model and string.match(payload.model, "^o[134]") then
      --       if payload.messages[1] and payload.messages[1].role == "system" then
      --         table.remove(payload.messages, 1)
      --       end
      --       payload.temperature = 1
      --       payload.top_p = 1
      --       payload.presence_penalty = 0
      --       payload.frequency_penalty = 0
      --       payload.logprobs = nil
      --       payload.logit_bias = nil
      --       payload.top_logprobs = nil
      --     end
      --     return payload
      --   end,
      -- },
