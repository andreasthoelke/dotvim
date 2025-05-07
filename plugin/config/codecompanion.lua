-- https://github.com/olimorris/codecompanion.nvim

-- #buffer is the origin (opened from) buffer, vs /buffer let's you select (multiple!! using 'm') via telescope.
-- 'gd' shows the current settings
-- CodeCompanionActions shows a palette: https://codecompanion.olimorris.dev/usage/action-palette.html 
-- /files /buffer allows to share multiple files using 'm' in telescope.
-- #buffer and #viewport autocomplete .. check if viewport considers window layout .. might be super useful
-- @cmd_runner looks interesting. NOTE: the confirmation dialog requires TWO taps: 'Y' & <cr>!  https://codecompanion.olimorris.dev/usage/chat-buffer/agents.html#cmd-runner
-- @editor actually works! use /buffer, after it's loaded you can 'gw' on the xml tag to 'watch' it: 👀 <buf>plugin/config/codecompanion.lua</buf>
-- => diff view: 'dp' in the left window, in the right / middle window: ',do' for 'diff-off'. this keeps the prev buffer.
-- maps } and ]] are working

-- This extensions lives in lua/plugins/codecompanion_spinner.lua
local spinner = require 'plugins.codecompanion_spinner'
spinner:init()

-- DEFAULT CONFIG
-- ~/.config/nvim/plugged/codecompanion.nvim/lua/codecompanion/config.lua

local providers = require("codecompanion.providers")

-- https://github.com/ravitemer/codecompanion-history.nvim
-- local history = require("codecompanion").extensions.history
-- Get all saved chats metadata
-- local chats = history.get_chats()
-- Load a specific chat
-- local chat_data = history.load_chat("some_save_id")

-- ~/.config/nvim/plugged/codecompanion.nvim/doc/codecompanion.txt‖/AUTOMATICˍTOOLˍMODE
vim.g['codecompanion_auto_tool_mode'] = true

_G.CodeCompanion_config = {


-- ─   Strategies                                       ──

  strategies = {
    chat = {
      adapter = "gemini",
      roles = {
        ---The header name for the LLM's messages
        ---@type string|fun(adapter: CodeCompanion.Adapter): string
        llm = function(adapter)
          return "(" .. adapter.formatted_name .. ")"
        end,

        ---The header name for your messages
        ---@type string
        user = "Me",
      },

    },
    inline = {
      adapter = "anthropic",
    },
    cmd = {
      adapter = "gemini",
    }
  },

-- ─   Adapters                                         ──
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        schema = {
          model = {
            default = "o3",
          },
        },
      })
    end,

    gemini = function()
      return require("codecompanion.adapters").extend("gemini", {
        schema = {
          model = {
            -- default = "gemini-2.5-pro-exp-03-25",
            default = "gemini-2.5-pro-preview-05-06",
          },
        },
      })
    end,

    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        schema = {
          model = {
            default = "claude-3-7-sonnet-20250219",
          },
        },
      })
    end,


  },

-- ─   DISPLAY OPTIONS                                  ──
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ", -- Prompt used for interactive LLM calls
      provider = providers.pickers, -- default|telescope|mini_pick|fzf_lua|snacks
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
    chat = {
      icons = {
        pinned_buffer = " ",
        watched_buffer = "👀 ",
      },
      debug_window = {
        ---@return number|fun(): number
        width = vim.o.columns - 5,
        ---@return number|fun(): number
        height = vim.o.lines - 2,
      },
      window = {
        layout = "vertical", -- float|vertical|horizontal|buffer
        position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
        border = "single",
        height = 0.8,
        width = 0.45,
        relative = "editor",
        full_height = true,
        opts = {
          breakindent = true,
          cursorcolumn = false,
          cursorline = false,
          foldcolumn = "0",
          linebreak = true,
          list = false,
          numberwidth = 1,
          signcolumn = "no",
          spell = false,
          wrap = true,
        },
      },
      auto_scroll = true, -- Automatically scroll down and place the cursor at the end
      intro_message = "Welcome to CodeCompanion ✨! Press ? for options",

      show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
      separator = "─", -- The separator between the different messages in the chat buffer

      show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
      show_settings = false, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      start_in_insert_mode = false, -- Open the chat buffer in insert mode?

      ---@param tokens number
      ---@param adapter CodeCompanion.Adapter
      token_count = function(tokens, adapter) -- The function to display the token count
        return " (" .. tokens .. " tokens)"
      end,
    },
    diff = {
      enabled = true,
      close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
      layout = "vertical", -- vertical|horizontal split for default provider
      opts = {
        "internal",
        "filler",
        "closeoff",
        "algorithm:histogram", -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
        "indent-heuristic", -- https://blog.k-nut.eu/better-git-diffs
        "followwrap",
        "linematch:120",
      },
      provider = providers.diff, -- default|telescope|mini_pick|fzf_lua|snacks
    },
    inline = {
      -- If the inline prompt creates a new buffer, how should we display this?
      layout = "vertical", -- vertical|horizontal|buffer
    },
  },
  -- EXTENSIONS ------------------------------------------------------
  extensions = {
    history = {
      enabled = true,
      opts = {
        -- Keymap to open history from chat buffer (default: gh)
        keymap = "gh",
        -- Automatically generate titles for new chats
        auto_generate_title = true,
        ---On exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = false,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = false,
        -- Picker interface ("telescope" or "default")
        picker = "telescope",
        ---Enable detailed logging for history extension
        enable_logging = false,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
      }
    },
    -- todo: try out
    vectorcode = {
      opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
    },
  },
}

require("codecompanion").setup( CodeCompanion_config )



