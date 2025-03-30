
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


-- DEFAULT CONFIG
-- ~/.config/nvim/plugged/codecompanion.nvim/lua/codecompanion/config.lua


_G.CodeCompanion_config = {

-- ─   GENERAL OPTIONS                                  ──
  opts = {
    log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
    language = "English", -- The language used for LLM responses

    -- If this is false then any default prompt that is marked as containing code
    -- will not be sent to the LLM. Please note that whilst I have made every
    -- effort to ensure no code leakage, using this is at your own risk
    ---@type boolean|function
    ---@return boolean
    send_code = true,

    job_start_delay = 1500, -- Delay in milliseconds between cmd tools
    submit_delay = 2000, -- Delay in milliseconds before auto-submitting the chat buffer

    ---This is the default prompt which is sent with every request in the chat
    ---strategy. It is primarily based on the GitHub Copilot Chat's prompt
    ---but with some modifications. You can choose to remove this via
    ---your own config but note that LLM results may not be as good
    ---@param opts table
    ---@return string

    system_prompt = function(opts)
      return "You are an AI assistant."
    end,
  },

  diff = {
    enabled = false,
    close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
    layout = "vertical", -- vertical|horizontal split for default provider
    opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
    provider = "default", -- default|mini_diff
  },
  inline = {
    -- If the inline prompt creates a new buffer, how should we display this?
    layout = "vertical", -- vertical|horizontal|buffer
  },


-- ─   -- DISPLAY OPTIONS                                ■
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ", -- Prompt used for interactive LLM calls
      provider = "default", -- default|telescope|mini_pick
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
      opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
      provider = "default", -- default|mini_diff
    },
    inline = {
      -- If the inline prompt creates a new buffer, how should we display this?
      layout = "vertical", -- vertical|horizontal|buffer
    },
  },


-- ─^  -- DISPLAY OPTIONS                                ▲


  strategies = {

    -- ─   Chat strategy                                    ──
    chat = {
      adapter = "anthropic",
      roles = {
        ---The header name for the LLM's messages
        ---@type string|fun(adapter: CodeCompanion.Adapter): string
        llm = function(adapter)
          -- return "CodeCompanion (" .. adapter.formatted_name .. ")"
          return "⌘"
        end,

        ---@type string
        user = "☼",
      },

      -- ─   Chat tools                                        ■
      tools = {
        groups = {
          ["full_stack_dev"] = {
            description = "Full Stack Developer - Can run code, edit code and modify files",
            system_prompt = "**DO NOT** make any assumptions about the dependencies that a user has installed. If you need to install any dependencies to fulfil the user's request, do so via the Command Runner tool. If the user doesn't specify a path, use their current working directory.",
            tools = {
              "cmd_runner",
              "editor",
              "files",
            },
          },
        },

        ["mcp"] = {
          -- calling it in a function would prevent mcphub from being loaded before it's needed
          callback = function() return require("mcphub.extensions.codecompanion") end,
          description = "Call tools and resources from the MCP Servers",
          opts = {
            requires_approval = true,
          }
        },

        ["cmd_runner"] = {
          callback = "strategies.chat.agents.tools.cmd_runner",
          description = "Run shell commands initiated by the LLM",
          opts = {
            requires_approval = false,
          },
        },
        ["editor"] = {
          callback = "strategies.chat.agents.tools.editor",
          description = "Update a buffer with the LLM's response",
        },
        ["files"] = {
          callback = "strategies.chat.agents.tools.files",
          description = "Update the file system with the LLM's response",
          opts = {
            requires_approval = false,
          },
        },
        opts = {
          auto_submit_errors = true, -- Send any errors to the LLM automatically?
          auto_submit_success = true, -- Send any successful output to the LLM automatically?

          system_prompt = [[## Tools Access and Execution Guidelines

### Overview
You have access to specialized tools that empower you to assist users with specific tasks.

### General Rules
- **Strict Schema Compliance:** Follow the exact XML schema provided when invoking any tool.
- **XML Format:** Always wrap your responses in a markdown code block designated as XML and within the `<tools></tools>` tags.
- **Valid XML Required:** Ensure that the constructed XML is valid and well-formed.
- **Multiple Commands:**
  - If issuing commands of the same type, combine them within one `<tools></tools>` XML block with separate `<action></action>` entries.
  - If issuing commands for different tools, ensure they're wrapped in `<tool></tool>` tags within the `<tools></tools>` block.
]],


          -- system_prompt = [[## Tools Access and Execution Guidelines

          -- ### Overview
          -- You now have access to specialized tools that empower you to assist users with specific tasks. These tools are available only when explicitly requested by the user.

          -- ### General Rules
          -- - **User-Triggered:** Only use a tool when the user explicitly indicates that a specific tool should be employed (e.g., phrases like "run command" for the cmd_runner).
          -- - **Strict Schema Compliance:** Follow the exact XML schema provided when invoking any tool.
          -- - **XML Format:** Always wrap your responses in a markdown code block designated as XML and within the `<tools></tools>` tags.
          -- - **Valid XML Required:** Ensure that the constructed XML is valid and well-formed.
          -- - **Multiple Commands:**
          -- - If issuing commands of the same type, combine them within one `<tools></tools>` XML block with separate `<action></action>` entries.
          -- - If issuing commands for different tools, ensure they're wrapped in `<tool></tool>` tags within the `<tools></tools>` block.
          -- - **No Side Effects:** Tool invocations should not alter your core tasks or the general conversation structure.]],
        },
      },


      -- ─^  Chat tools                                        ▲


      -- ─   Chat slash_commands                               ■

      slash_commands = {
        ["buffer"] = {
          callback = "strategies.chat.slash_commands.buffer",
          description = "Insert open buffers",
          opts = {
            contains_code = true,
            provider = "telescope", -- default|telescope|mini_pick|fzf_lua
          },
        },
        ["fetch"] = {
          callback = "strategies.chat.slash_commands.fetch",
          description = "Insert URL contents",
          opts = {
            adapter = "jina",
          },
        },
        ["file"] = {
          callback = "strategies.chat.slash_commands.file",
          description = "Insert a file",
          opts = {
            contains_code = true,
            max_lines = 1000,
            provider = "telescope", -- default|telescope|mini_pick|fzf_lua
          },
        },
        ["help"] = {
          callback = "strategies.chat.slash_commands.help",
          description = "Insert content from help tags",
          opts = {
            contains_code = false,
            max_lines = 128, -- Maximum amount of lines to of the help file to send (NOTE: Each vimdoc line is typically 10 tokens)
            provider = "telescope", -- telescope|mini_pick|fzf_lua
          },
        },
        ["now"] = {
          callback = "strategies.chat.slash_commands.now",
          description = "Insert the current date and time",
          opts = {
            contains_code = false,
          },
        },
        ["symbols"] = {
          callback = "strategies.chat.slash_commands.symbols",
          description = "Insert symbols for a selected file",
          opts = {
            contains_code = true,
            provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
          },
        },
        ["terminal"] = {
          callback = "strategies.chat.slash_commands.terminal",
          description = "Insert terminal output",
          opts = {
            contains_code = false,
          },
        },
        ["workspace"] = {
          callback = "strategies.chat.slash_commands.workspace",
          description = "Load a workspace file",
          opts = {
            contains_code = true,
          },
        },
      },

      -- ─^  Chat slash_commands                               ▲


    },

-- ─   Chat keymaps                                      ■

    keymaps = {
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
          n = { "<c-w><cr>" },
          -- n = { "<CR>", "<C-s>" },
          -- i = "<C-s>",
        },
        index = 2,
        callback = "keymaps.send",
        description = "Send",
      },
      regenerate = {
        modes = {
          n = "<c-g>r",
        },
        index = 3,
        callback = "keymaps.regenerate",
        description = "Regenerate the last response",
      },
      close = {
        modes = {
          n = "<c-w>c",
          -- i = "<C-c>",
        },
        index = 4,
        callback = "keymaps.close",
        description = "Close Chat",
      },
      stop = {
        modes = {
          n = "<c-g>c>",
        },
        index = 5,
        callback = "keymaps.stop",
        description = "Stop Request",
      },
      clear = {
        modes = {
          n = "<c-g>C",
        },
        index = 6,
        callback = "keymaps.clear",
        description = "Clear Chat",
      },
      codeblock = {
        modes = {
          n = "<c-g>b",
        },
        index = 7,
        callback = "keymaps.codeblock",
        description = "Insert Codeblock",
      },
      yank_code = {
        modes = {
          n = "<c-g>y",
        },
        index = 8,
        callback = "keymaps.yank_code",
        description = "Yank Code",
      },
      pin = {
        modes = {
          n = "<c-g>p",
        },
        index = 9,
        callback = "keymaps.pin_reference",
        description = "Pin Reference",
      },
      watch = {
        modes = {
          n = "<c-g>w",
        },
        index = 10,
        callback = "keymaps.toggle_watch",
        description = "Watch Buffer",
      },
      next_chat = {
        modes = {
          n = "<leader><c-l>",
        },
        index = 11,
        callback = "keymaps.next_chat",
        description = "Next Chat",
      },
      previous_chat = {
        modes = {
          n = "<leader><c-h>",
        },
        index = 12,
        callback = "keymaps.previous_chat",
        description = "Previous Chat",
      },
      next_header = {
        modes = {
          n = "]]",
        },
        index = 13,
        callback = "keymaps.next_header",
        description = "Next Header",
      },
      previous_header = {
        modes = {
          n = "[[",
        },
        index = 14,
        callback = "keymaps.previous_header",
        description = "Previous Header",
      },
      change_adapter = {
        modes = {
          n = "<c-g>a",
        },
        index = 15,
        callback = "keymaps.change_adapter",
        description = "Change adapter",
      },
      fold_code = {
        modes = {
          n = "<c-g>z",
        },
        index = 15,
        callback = "keymaps.fold_code",
        description = "Fold code",
      },
      debug = {
        modes = {
          n = "<c-g>D",
        },
        index = 16,
        callback = "keymaps.debug",
        description = "View debug info",
      },
      system_prompt = {
        modes = {
          n = "<c-g>S",
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


-- ─^  Chat keymaps                                      ▲

    opts = {
      register = "+", -- The register to use for yanking code
      yank_jump_delay_ms = 400, -- Delay in milliseconds before jumping back from the yanked code
    },

    -- ─   Inline strategy                                  ──
    -- ~/.config/nvim/plugged/codecompanion.nvim/lua/codecompanion/config.lua‖/INLINEˍSTRATEGYˍ----------

    -- variables: buffer, chat and clipboard
    inline = {
      adapter = "anthropic",
    },

    cmd = {
      adapter = "copilot",
      opts = {
        system_prompt = [[You are currently plugged in to the Neovim text editor on a user's machine. Your core task is to generate an command-line inputs that the user can run within Neovim. Below are some rules to adhere to:

- Return plain text only
- Do not wrap your response in a markdown block or backticks
- Do not use any line breaks or newlines in you response
- Do not provide any explanations
- Generate an command that is valid and can be run in Neovim
- Ensure the command is relevant to the user's request]],
      },
    },


  }


}

require("codecompanion").setup( CodeCompanion_config )

-- require("plugins.codecompanion.fidget-spinner"):init()








