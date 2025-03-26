-- CodeCompanion configuration - Sets up the AI assistant with custom adapters, slash commands, and layouts

-- /files /buffer allows to share multiple files using 'm' in telescope.
-- #buffer and #viewport autocomplete .. check if viewport considers window layout .. might be super useful
-- @cmd_runner looks interesting. NOTE: the confirmation dialog requires TWO taps: 'Y' & <cr>!  https://codecompanion.olimorris.dev/usage/chat-buffer/agents.html#cmd-runner

local config = {
  strategies = {
    chat = {
      adapter = "anthropic",

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


    },
    inline = {
      adapter = "anthropic",
    },
  },
  display = {
    chat = {
      window = {
        layout = "vertical", -- float|vertical|horizontal|buffer
        width = 0.3, -- Width for vertical split
        height = 0.3, -- Height for horizontal split
      },
    },
  },
}

require("codecompanion").setup( config )


vim.keymap.set('n', '<leader>kv', function()
  local update = { display = { chat = { window = { layout = "vertical" } } } }
  local config_updated = vim.tbl_deep_extend("force", vim.deepcopy( config ), update )
  require("codecompanion").setup( config_updated )
  require("codecompanion").chat()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ks', function()
  local update = { display = { chat = { window = { layout = "horizontal" } } } }
  local config_updated = vim.tbl_deep_extend("force", vim.deepcopy( config ), update )
  require("codecompanion").setup( config_updated )
  require("codecompanion").chat()
end, { noremap = true, silent = true })








