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
      adapter = "anthropic",
      roles = {
        ---The header name for the LLM's messages
        ---@type string|fun(adapter: CodeCompanion.Adapter): string
        llm = function(adapter)
          -- putt( adapter )
          -- return "(" .. adapter.formatted_name .. ")"
          return "(" .. adapter.parameters.model .. ")"
        end,

        ---The header name for your messages
        ---@type string
        user = "☼",
      },

      keymaps = {
        options = {
          modes = {
            n = "?",
          },
          callback = "keymaps.options",
          description = "Options",
          hide = true,
        },
        completion = {
          modes = {
            i = "<C-_>",
          },
          index = 1,
          callback = "keymaps.completion",
          description = "Completion Menu",
        },
        send = {
          modes = {
            n = { "<c-w><CR>" },
            i = "<c-w><CR>",
          },
          index = 2,
          callback = "keymaps.send",
          description = "Send",
        },
        regenerate = {
          modes = {
            n = "<leader>R",
          },
          index = 3,
          callback = "keymaps.regenerate",
          description = "Regenerate the last response",
        },
        close = {
          modes = {
            n = "q",
          },
          index = 4,
          callback = "keymaps.close",
          description = "Close Chat",
        },
        stop = {
          modes = {
            n = "<c-g>c",
            i = "<c-g>c",
          },
          index = 5,
          callback = "keymaps.stop",
          description = "Stop Request",
        },
        clear = {
          modes = {
            -- NOTE consistent with claude code ~/.config/nvim/plugin/config/ai-maps.lua‖/CLEARˍtextˍfieldˍbuffer
            n = "<c-g>C",
          },
          index = 6,
          callback = "keymaps.clear",
          description = "Clear Chat",
        },
        codeblock = {
          modes = {
            n = "<leader>gc",
          },
          index = 7,
          callback = "keymaps.codeblock",
          description = "Insert Codeblock",
        },
        yank_code = {
          modes = {
            n = "<leader>gy",
          },
          index = 8,
          callback = "keymaps.yank_code",
          description = "Yank Code",
        },
        pin = {
          modes = {
            n = "<leader>gp",
          },
          index = 9,
          callback = "keymaps.pin_reference",
          description = "Pin Reference",
        },
        watch = {
          modes = {
            n = "<leader>gw",
          },
          index = 10,
          callback = "keymaps.toggle_watch",
          description = "Watch Buffer",
        },
        next_chat = {
          modes = {
            n = "<leader>}",
          },
          index = 11,
          callback = "keymaps.next_chat",
          description = "Next Chat",
        },
        previous_chat = {
          modes = {
            n = "<leader>{",
          },
          index = 12,
          callback = "keymaps.previous_chat",
          description = "Previous Chat",
        },
        next_header = {
          modes = {
            n = "<leader>]",
          },
          index = 13,
          callback = "keymaps.next_header",
          description = "Next Header",
        },
        previous_header = {
          modes = {
            n = "<leader>[",
          },
          index = 14,
          callback = "keymaps.previous_header",
          description = "Previous Header",
        },
        change_adapter = {
          modes = {
            n = "<leader>ga",
          },
          index = 15,
          callback = "keymaps.change_adapter",
          description = "Change adapter",
        },
        fold_code = {
          modes = {
            n = "<leader>gf",
          },
          index = 15,
          callback = "keymaps.fold_code",
          description = "Fold code",
        },
        debug = {
          modes = {
            n = "<leader>gd",
          },
          index = 16,
          callback = "keymaps.debug",
          description = "View debug info",
        },
        system_prompt = {
          modes = {
            n = "<leader>gs",
          },
          index = 17,
          callback = "keymaps.toggle_system_prompt",
          description = "Toggle the system prompt",
        },
        auto_tool_mode = {
          modes = {
            n = "gta",
          },
          index = 18,
          callback = "keymaps.auto_tool_mode",
          description = "Toggle automatic tool mode",
        },
      },


    },
    inline = {
      adapter = "anthropic",
    },
    cmd = {
      adapter = "anthropic",
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
            -- default = "claude-3-7-sonnet-20250219",
            default = "claude-sonnet-4-20250514",
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
        -- Keymap to save the current chat manually (when auto_save is disabled)
        save_chat_keymap = "sc",
        -- Save all chats by default (disable to save only manually using 'sc')
        auto_save = true,
        -- Number of days after which chats are automatically deleted (0 to disable)
        expiration_days = 0,
        -- Picker interface (auto resolved to a valid picker)
        picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default") 
        ---Optional filter function to control which chats are shown when browsing
        chat_filter = nil, -- function(chat_data) return boolean end
        -- Customize picker keymaps (optional)
        picker_keymaps = {
          rename = { n = "r", i = "<M-r>" },
          delete = { n = "d", i = "<M-d>" },
          duplicate = { n = "<C-y>", i = "<C-y>" },
        },
        ---Automatically generate titles for new chats
        auto_generate_title = true,
        title_generation_opts = {
          ---Adapter for generating titles (defaults to current chat adapter) 
          adapter = nil, -- "copilot"
          ---Model for generating titles (defaults to current chat model)
          model = nil, -- "gpt-4o"
          ---Number of user prompts after which to refresh the title (0 to disable)
          refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
          ---Maximum number of times to refresh the title (default: 3)
          max_refreshes = 3,
          format_title = function(original_title)
            -- this can be a custom function that applies some custom
            -- formatting to the title.
            return original_title
          end
        },
        ---On exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = false,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = false,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---Enable detailed logging for history extension
        enable_logging = false,

        -- Summary system
        summary = {
          -- Keymap to generate summary for current chat (default: "gcs")
          create_summary_keymap = "gcs",
          -- Keymap to browse summaries (default: "gbs")
          browse_summaries_keymap = "gbs",

          generation_opts = {
            adapter = nil, -- defaults to current chat adapter
            model = nil, -- defaults to current chat model
            context_size = 90000, -- max tokens that the model supports
            include_references = true, -- include slash command content
            include_tool_outputs = true, -- include tool execution results
            system_prompt = nil, -- custom system prompt (string or function)
            format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
          },
        },

        -- Memory system (requires VectorCode CLI)
        memory = {
          -- Automatically index summaries when they are generated
          auto_create_memories_on_summary_generation = true,
          -- Path to the VectorCode executable
          vectorcode_exe = "vectorcode",
          -- Tool configuration
          tool_opts = { 
            -- Default number of memories to retrieve
            default_num = 10 
          },
          -- Enable notifications for indexing progress
          notify = true,
          -- Index all existing memories on startup
          -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
          index_on_startup = false,
        },
      }
    },

    --history = {
    --  enabled = true,
    --  opts = {
    --    -- Keymap to open history from chat buffer (default: gh)
    --    keymap = "gh",
    --    -- Automatically generate titles for new chats
    --    auto_generate_title = true,
    --    ---On exiting and entering neovim, loads the last chat on opening chat
    --    continue_last_chat = false,
    --    ---When chat is cleared with `gx` delete the chat from history
    --    delete_on_clearing_chat = false,
    --    -- Picker interface ("telescope" or "default")
    --    picker = "telescope",
    --    ---Enable detailed logging for history extension
    --    enable_logging = false,
    --    ---Directory path to save the chats
    --    dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
    --  }
    --},
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true,  -- Show mcp tool results in chat
        make_vars = true,            -- Convert resources to #variables
        make_slash_commands = true,  -- Add prompts as /slash commands
      }
    },
    -- todo: try out
    vectorcode = {
      opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
    },
  },
}

require("codecompanion").setup( CodeCompanion_config )



