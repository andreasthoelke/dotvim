

local config = {
      -- Default AI popup type
      -- popup_type = "popup" | "horizontal" | "vertical",
      popup_type = "horizontal",
      openai_api_key = vim.fn.readfile("/Users/at/.config/nvim/openai_key.txt")[1],
      -- ChatGPT Model
      -- openai_model_id = "gpt-3.5-turbo",
      openai_model_id = "gpt-4",
      -- Send code as well as diagnostics
      context = true,
      -- Set your preferred language for the response
      language = "english",
      -- Any additional instructions
      additional_instructions = "Start the reply with 'OH HAI THERE'",
      -- Default search engine, can be overridden by passing an option to WtfSeatch
      -- search_engine = "google" | "duck_duck_go" | "stack_overflow" | "github",
      search_engine = "github",
      -- Callbacks
      hooks = {
          request_started = nil,
          request_finished = nil,
      },
      -- Add custom colours
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
  }


require('wtf').setup( config )

-- vim.fn.readfile("/Users/at/.config/nvim/openai_key.txt")[1]










