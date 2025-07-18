local Utils = require("magenta.utils")
local M = {}

-- NOTE
-- These maps ( ~/.config/nvim/lua/config/mga_m.lua ) are analogous to:
-- ~/Documents/Proj/k_mindgraph/h_mcp/b_mga/lua/magenta/init.lua
-- They call the simplified / alt version of magenta "mga_m" (for mini)
-- ~/Documents/Proj/k_mindgraph/h_mcp/b_mga/node/mga-m.ts
--
-- Could also put maps here: ~/.config/nvim/plugin/config/magenta.nvim.lua

M.defaults = {
  provider = "anthropic",
  openai = {
    model = "gpt-4o"
  },
  anthropic = {
    model = "claude-3-5-sonnet-20241022"
  }
}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  vim.api.nvim_set_keymap(
    "n",
    "<leader>Mc",
    ":Mga clear<CR>",
    {silent = true, noremap = true, desc = "Clear Mga state"}
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>Ma",
    ":Mga abort<CR>",
    {silent = true, noremap = true, desc = "Abort current Mga operation"}
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>Mt",
    ":Mga toggle<CR>",
    {silent = true, noremap = true, desc = "Toggle Mga window"}
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>Mi",
    ":Mga start-inline-edit<CR>",
    {silent = true, noremap = true, desc = "Inline edit"}
  )
  vim.api.nvim_set_keymap(
    "v",
    "<leader>Mi",
    ":Mga start-inline-edit-selection<CR>",
    {silent = true, noremap = true, desc = "Inline edit selection"}
  )
  vim.api.nvim_set_keymap(
    "v",
    "<leader>Mp",
    ":Mga paste-selection<CR>",
    {silent = true, noremap = true, desc = "Send selection to Mga"}
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>Mb", -- like "magenta buffer"?
    "",
    {
      noremap = true,
      silent = true,
      desc = "Add current buffer to Mga context",
      callback = function()
        local current_file = vim.fn.expand("%:p")
        vim.cmd("Mga context-files " .. vim.fn.shellescape(current_file))
      end
    }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>Mf",
    "",
    {
      noremap = true,
      silent = true,
      desc = "Select files to add to Mga context",
      callback = function()
        local success, fzf = pcall(require, "fzf-lua")
        if not success then
          Utils.log_job("error", "fzf-lua is not installed")
        end

        fzf.files(
          {
            raw = true, -- return just the raw path strings
            actions = {
              ["default"] = function(selected)
                local escaped_files = {}
                for _, entry in ipairs(selected) do
                  table.insert(escaped_files, vim.fn.shellescape(fzf.path.entry_to_file(entry).path))
                end
                vim.cmd("Mga context-files " .. table.concat(escaped_files, " "))
              end
            }
          }
        )
      end
    }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>Mp",
    "",
    {
      noremap = true,
      silent = true,
      desc = "Select provider and model",
      callback = function()
        local success, fzf = pcall(require, "fzf-lua")
        if not success then
          Utils.log_job("error", "fzf-lua is not installed")
        end

        local items = {
            'openai gpt-4o',
            'openai o1',
            'openai o1-mini',
            'anthropic claude-3-5-sonnet-latest'
        }

        fzf.fzf_exec(items, {
            prompt = 'Select Model > ',
            actions = {
                ['default'] = function(selected)
                    -- selected[1] contains the selected line
                    -- Your code here to handle the selection
                    -- For example:
                    vim.cmd("Mga provider " .. selected[1] )
                end
            }
        })
      end
    }
  )

end

M.testSetup = function()
  -- do not start. The test runner will start the process for us.
  vim.api.nvim_set_keymap(
    "n",
    "<leader>M",
    ":Mga toggle<CR>",
    {silent = true, noremap = true, desc = "Toggle Mga window"}
  )
end


-- sets up lua usercmds/autocmds, a dynamic buffer keymap and a method to be used as an async callback.
-- these global (generic) commands, keymaps and callback handlers all use rpcnotif(channelId, eventkey, ..
-- to send vim events into the magenta-TS app, which receives the events via its nvim.onNotification(MAGENTA_KEY, (args) => {
-- handlers.
M.bridge = function(channelId)

  vim.api.nvim_create_user_command(
    "SomeEventA",
    function()
      vim.rpcnotify(channelId, "some_event_a", {})
    end,
    {}
  )


  vim.api.nvim_create_user_command(
    "Mga",
    function(opts)
      vim.rpcnotify(channelId, "magentaCommand", opts.args)
    end,
    {
      nargs = "+",
      range = true,
      desc = "Execute Mga command"
    }
  )

  vim.api.nvim_create_user_command(
    "MgaClose",
    function(opts)
      vim.rpcnotify(channelId, "mgaClose", opts.args)
    end,
    {}
  )

  -- vim.api.nvim_create_autocmd(
  --   "WinClosed",
  --   {
  --     pattern = "*",
  --     callback = function()
  --       vim.rpcnotify(channelId, "magentaWindowClosed", {})
  --     end
  --   }
  -- )

  M.listenToBufKey = function(bufnr, vimKey)
    vim.keymap.set(
      "n",
      vimKey,
      function()
        vim.rpcnotify(channelId, "magentaKey", vimKey)
      end,
      {buffer = bufnr, noremap = true, silent = true}
    )
  end

  M.lsp_response = function(requestId, response)
    vim.rpcnotify(channelId, "magentaLspResponse", {requestId, response})
  end

  return M.options
end

M.wait_for_lsp_attach = function(bufnr, capability, timeout_ms)
  -- Default timeout of 1000ms if not specified
  timeout_ms = timeout_ms or 1000

  return vim.wait(
    timeout_ms,
    function()
      local clients = vim.lsp.get_active_clients({bufnr = bufnr})
      for _, client in ipairs(clients) do
        if client.server_capabilities[capability] then
          return true
        end
      end
      return false
    end
  )
end

M.lsp_hover_request = function(requestId, bufnr, row, col)
  local success = M.wait_for_lsp_attach(bufnr, "hoverProvider", 1000)
  if not success then
    M.lsp_response(requestId, "Timeout waiting for LSP client with hoverProvider to attach")
    return
  end

  vim.lsp.buf_request_all(
    bufnr,
    "textDocument/hover",
    {
      textDocument = {
        uri = vim.uri_from_bufnr(bufnr)
      },
      position = {
        line = row,
        character = col
      }
    },
    function(responses)
      M.lsp_response(requestId, responses)
    end
  )
end

M.lsp_references_request = function(requestId, bufnr, row, col)
  local success = M.wait_for_lsp_attach(bufnr, "referencesProvider", 1000)
  if not success then
    M.lsp_response(requestId, "Timeout waiting for LSP client with referencesProvider to attach")
    return
  end

  vim.lsp.buf_request_all(
    bufnr,
    "textDocument/references",
    {
      textDocument = {
        uri = vim.uri_from_bufnr(bufnr)
      },
      position = {
        line = row,
        character = col
      },
      context = {
        includeDeclaration = true
      }
    },
    function(responses)
      M.lsp_response(requestId, responses)
    end
  )
end

return M

