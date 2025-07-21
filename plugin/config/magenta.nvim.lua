
-- require('magenta').setup({})


print("magenta setup called!")

require('magenta').setup({
  profiles = {
    {
      name = "claude-opus",
      provider = "anthropic",
      model = "claude-opus-4-20250514",
      fastModel = "claude-3-5-haiku-latest", -- optional, defaults provided
      apiKeyEnvVar = "ANTHROPIC_API_KEY"
    },
    {
      name = "claude-sonnet",
      provider = "anthropic",
      model = "claude-sonnet-4-20250514",
      fastModel = "claude-3-5-haiku-latest", -- optional, defaults provided
      apiKeyEnvVar = "ANTHROPIC_API_KEY"
    },
    {
      name = "o3",
      provider = "openai",
      model = "o3",
      apiKeyEnvVar = "OPENAI_API_KEY"
    },
    {
      name = "gpt-4.1",
      provider = "openai",
      model = "gpt-4.1",
      fastModel = "gpt-4o-mini", -- optional, defaults provided
      apiKeyEnvVar = "OPENAI_API_KEY"
    },
    {
      name = "copilot-claude",
      provider = "copilot",
      model = "claude-3.7-sonnet",
      fastModel = "claude-3-5-haiku-latest", -- optional, defaults provided
      -- No apiKeyEnvVar needed - uses existing Copilot authentication
    }
  },
  -- open chat sidebar on left or right side
  sidebarPosition = "right",
  -- can be changed to "telescope" or "snacks"
  -- picker = "fzf-lua",
  picker = "telescope",
  -- enable default keymaps shown below
  defaultKeymaps = true,
  -- maximum number of sub-agents that can run concurrently (default: 3)
  maxConcurrentSubagents = 3,
  -- glob patterns for files that should be auto-approved for getFile tool
  -- (bypasses user approval for hidden/gitignored files matching these patterns)
  getFileAutoAllowGlobs = { "node_modules/*" }, -- default includes node_modules
  -- keymaps for the sidebar input buffer
  sidebarKeymaps = {
    normal = { ["<c-w><cr>"] = ":Magenta send<CR>", },
    insert = { ["<c-w><cr>"] = ":Magenta send<CR>", }
  },
  -- keymaps for the inline edit input buffer
  -- if keymap is set to function, it accepts a target_bufnr param
  inlineKeymaps =  {
    normal = {
      ["<c-w><cr>"] = function(target_bufnr)
        vim.cmd("Magenta submit-inline-edit " .. target_bufnr)
      end,
    },
  },
  mcpServers = {
    mcphub = {
      url = "http://localhost:37373/mcp"
    },
    -- playwright = {
    --   command = "npx",
    --   args = {
    --     "@playwright/mcp@latest"
    --   }
    -- }
  },
  -- configure MCP servers for external tool integrations
  -- mcpServers = {
  --   fetch = {
  --     command = "uvx",
  --     args = { "mcp-server-fetch" }
  --   },
  --   playwright = {
  --     command = "npx",
  --     args = {
  --       "@playwright/mcp@latest"
  --     }
  --   },
  --   -- HTTP-based MCP server example
  --   httpServer = {
  --     url = "http://localhost:8000/mcp",
  --     requestInit = {
  --       headers = {
  --         Authorization = "Bearer your-token-here",
  --       },
  --     },
  --   }
  -- }
})




-- require('magenta').setup({
--   -- profiles = {
--   --   {
--   --     name = "claude-3-7",
--   --     provider = "anthropic",
--   --     model = "claude-3-7-sonnet-latest",
--   --     apiKeyEnvVar = "ANTHROPIC_API_KEY"
--   --   },
--   --   {
--   --     name = "gpt-4o",
--   --     provider = "openai",
--   --     model = "gpt-4o",
--   --     apiKeyEnvVar = "OPENAI_API_KEY"
--   --   }
--   -- },
--   -- open chat sidebar on left or right side
--   sidebarPosition = "right",
--   -- can be changed to "telescope" or "snacks"
--   picker = "fzf-lua",
--   -- enable default keymaps shown below
--   defaultKeymaps = true,
--   -- keymaps for the sidebar input buffer
--   sidebarKeymaps = {
--     normal = {
--       ["<CR>"] = ":Magenta send<CR>",
--     }
--   },
--   -- keymaps for the inline edit input buffer
--   -- if keymap is set to function, it accepts a target_bufnr param
--   inlineKeymaps =  {
--     normal = {
--       ["<CR>"] = function(target_bufnr)
--         vim.cmd("Magenta submit-inline-edit " .. target_bufnr)
--       end,
--     },
--   }
-- })

-- Other custom maps:
-- ~/.config/nvim/lua/config/mga_m.lua
-- Default maps:
-- ~/Documents/Proj/k_mindgraph/h_mcp/b_mga/lua/magenta/init.lua

vim.keymap.set( 'n',
  ',sm', function()
    require( 'plenary.reload' ).reload_module(
      'magenta.nvim'
    )
    vim.cmd('luafile ~/.config/nvim/plugin/config/magenta.nvim.lua')
  end )







