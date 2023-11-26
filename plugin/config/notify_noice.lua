

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  routes = {
    {
      filter = {
        event = "Notify",
        kind = "",
        find = "clipboard"
      },
      opts = { skip = true },
    },
  },
})



require("notify").setup(
{
    background_colour = "NotifyBackground",
    fps = 3,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = ""
    },
    level = 2,
    minimum_width = 50,
    render = "simple",
    stages = "static",
    timeout = 4000,
    top_down = true,
  }
)

-- local banned_messages = { "clipboard" }

-- vim.notify = function (msg, ...)
--   for _, banned in ipairs(banned_messages) do
--     if msg == banned then
--       return
--     end
--   end
--   require("notify")("ab: " .. msg, ...)
-- end

-- local titles1 = { ['neo-tree'] = true}
-- local _old_notify = vim.notify
-- vim.notify = function(message, level, opts)
--   if titles1[opts.title] then
--     _old_notify("hi", level, opts)
--   else
--     _old_notify("ab", level, opts)
--   end
-- end


