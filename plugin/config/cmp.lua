-- ─   nvim-cmp setup                                    ■

-- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'noinsert,menuone,noselect'
-- vim.o.completeopt = 'menuone,noselect'
-- vim.o.completeopt = 'menu,menuone,noselect'
-- vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt_global.completeopt = { "menu", "menuone", "noselect" }

-- help completeopt

-- luasnip setup
-- local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup {
  completion = {
    -- autocomplete = false, -- disable auto-completion.
  },

  -- window = {
  --   completion = {
  --     winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
  --     col_offset = -3,
  --     side_padding = 0,
  --   },
  -- },
  -- formatting = {
  --   fields = { "kind", "abbr", "menu" },
  --   format = function(entry, vim_item)
  --     local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
  --     local strings = vim.split(kind.kind, "%s", { trimempty = true })
  --     kind.kind = " " .. (strings[1] or "") .. " "
  --     kind.menu = "    (" .. (strings[2] or "") .. ")"
  --     return kind
  --   end,
  -- },

  snippet = {
    expand = function(args)
      -- luasnip.lsp_expand(args.body)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-y>'] = cmp.mapping.scroll_docs(-2),
    ['<C-e>'] = cmp.mapping.scroll_docs(2),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-c>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      -- behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    -- ['<c-n>'] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end,
    -- ['<c-o>'] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'graphql' },
    -- { name = 'luasnip' }, -- For luasnip users.
  }, {
      {
        name = 'buffer',
        -- NOTE: this prevents long url-code strings to spam the completion suggestion. effectively they are shorter now
        option = {
          keyword_pattern = [[\k\+]],
        },

        -- note tested yet. 
        -- entry_filter = function(entry, ctx)
        --   return require('cmp.types').lsp.CompletionItemKind[ctx:get_kind()] ~= 'Text'
        -- end

      },
    })
  -- sources = {
  --   { name = 'nvim_lsp' },
  --   { name = 'luasnip' },
  -- },
}

require('cmp-graphql').setup({
  schema_path = 'graphql.schema.json', -- Path to generated json schema file in project
})



-- Set configuration for specific filetype.
cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    -- { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--       { name = 'cmdline' }
--     })
-- })

_G.vimrc = _G.vimrc or {}
_G.vimrc.cmp = _G.vimrc.cmp or {}
_G.vimrc.cmp.lsp = function()
  cmp.complete({
    config = {
      sources = {
        { name = 'nvim_lsp' }
      }
    }
  })
end

_G.vimrc.cmp.snippet = function()
  cmp.complete({
    config = {
      sources = {
        { name = 'vsnip' }
      }
    }
  })
end

-- inoremap <C-i> <Cmd>lua vimrc.cmp.lsp()<CR>

vim.cmd([[
inoremap <C-x><C-o> <Cmd>lua vimrc.cmp.lsp()<CR>
inoremap <C-x><C-s> <Cmd>lua vimrc.cmp.snippet()<CR>
]])

-- Other setup example: ~/.config/nvim.cam/lua/user/cmp.lua#/cmp.setup%20{

-- ─^  nvim-cmp setup                                    ▲

