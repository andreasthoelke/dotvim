
-- https://github.com/frankroeder/dotfiles/tree/5705713e66318e37a80d1060a458eaae2f1b6ff1/nvim/lua/plugins
-- https://github.com/frankroeder/dotfiles/blob/5705713e66318e37a80d1060a458eaae2f1b6ff1/nvim/lua/plugins/nvim_cmp.lua

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
  Misc = "",
  Command = "",  -- Added for vim commands
  Path = "󰉋",    -- Added for paths
}


local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

      -- For `mini.snippets` users:
      -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
      -- insert({ body = args.body }) -- Insert at cursor
      -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
      -- require("cmp.config").set_onetime({ sources = {} })
    end,
  },

  formatting = {
    format = function(entry, vim_item)
      -- Base kind determination on more specific properties
      if entry.source.name == 'cmdline' then
        -- For cmdline source, try to distinguish between different item types
        local item = entry:get_completion_item()

        -- Check for file/path patterns
        if vim_item.word:match('/') or vim_item.word:match('%.') then
          vim_item.kind = 'Path'
        elseif vim.fn.exists(':' .. vim_item.word) == 2 then
          -- Check if it's a Vim command
          vim_item.kind = 'Command'
        elseif vim_item.word:match('^%a+$') then
          -- Most single-word items without special chars are likely commands
          vim_item.kind = 'Command'
        else
          -- Default fallback
          vim_item.kind = 'Text'
        end
      elseif entry.source.name == 'path' then
        vim_item.kind = 'Path'
      end

      -- Add icons and source name
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or kind_icons.Misc, vim_item.kind)

      -- Add source name
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        path = "[Path]",
        cmdline = "[Cmd]",
      })[entry.source.name]

      return vim_item
    end,
  },

  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
        else
          fallback()
        end
      end,
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 3 },
    { name = "treesitter", keyword_length = 3 },
    { name = "async_path" },
    { name = "parrot" },
  }, {
      { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
      { name = 'buffer' },
    })
})
require("cmp_git").setup()


-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   }),
--   matching = { disallow_symbol_nonprefix_matching = false }
-- })

-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline({
--     ['<CR>'] = cmp.mapping({
--       i = function(fallback)
--         if cmp.visible() then
--           cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
--         else
--           fallback()
--         end
--       end,
--       c = function(fallback)
--         if cmp.visible() then
--           cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
--         else
--           fallback()
--         end
--       end
--     }),

--     ['<Tab>'] = cmp.mapping({
--       c = function(fallback)
--         if cmp.visible() then
--           cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
--           -- Add a space after insertion
--           vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(' ', true, false, true), 'n', false)
--         else
--           fallback()
--         end
--       end,
--     }),

--   }),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--       { name = 'cmdline' }
--     }),
--   matching = { disallow_symbol_nonprefix_matching = false }
-- })





-- Setup codecompanion filetype
-- cmp.setup.filetype('codecompanion', {
--   sources = cmp.config.sources({
--     { name = 'codecompanion' },
--   })
-- })

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }
