

-- local config = {
--   -- Required options
--   port = 3000,  -- Port for MCP Hub server
--   config = vim.fn.expand("~/.config/mcphub/servers.json"),  -- Absolute path to config file
--   -- Optional options
--   on_ready = function(hub)
--     -- Called when hub is ready
--   end,
--   on_error = function(err)
--     -- Called on errors
--   end,
--   log = {
--     level = vim.log.levels.WARN,
--     to_file = false,
--     file_path = nil,
--     prefix = "MCPHub"
--   },
-- }

local config = {
  port = 37373, -- Default port for MCP Hub
  config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to config file location (will create if not exists)
  native_servers = {}, -- add your native servers here

  auto_approve = true, -- Auto approve mcp tool calls
  auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
  -- Extensions configuration
  extensions = {
    avante = {
      make_slash_commands = true, -- make /slash commands from MCP server prompts
    },
    codecompanion = {
      show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
      make_vars = true, -- make chat #variables from MCP server resources
      make_slash_commands = true, -- make /slash commands from MCP server prompts
    },
  },


  -- Default window settings
  ui = {
    window = {
      width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      relative = "editor",
      zindex = 50,
      border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
    },
    wo = { -- window-scoped options (vim.wo)
    },
  },

  -- Event callbacks
  on_ready = function(hub)
    -- Called when hub is ready
  end,
  on_error = function(err)
    -- Called on errors
  end,

  --set this to true when using build = "bundled_build.lua"
  use_bundled_binary = false, -- Uses bundled mcp-hub script instead of global installation

  --WARN: Use the custom setup if you can't use `npm install -g mcp-hub` or cant have `build = "bundled_build.lua"`
  -- Custom Server command configuration
  --cmd = "node", -- The command to invoke the MCP Hub Server
  --cmdArgs = {"/path/to/node_modules/mcp-hub/dist/cli.js"},    -- Additional arguments for the command
  -- In cases where mcp-hub server is hosted somewhere, set this to the server URL e.g `http://mydomain.com:customport` or `https://url_without_need_for_port.com`
  -- server_url = nil, -- defaults to `http://localhost:port`
  -- Multi-instance Support
  shutdown_delay = 600000, -- Delay in ms before shutting down the server when last instance closes (default: 10 minutes)

  -- Logging configuration
  log = {
    level = vim.log.levels.WARN,
    to_file = false,
    file_path = nil,
    prefix = "MCPHub",
  },
}


require("mcphub").setup( config )
-- require("mcphub").setup({})



