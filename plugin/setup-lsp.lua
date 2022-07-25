
local lspconfig = require 'lspconfig'

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
    noremap = true,
    silent = true,
  })
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local flags = {
  debounce_text_changes = 150,
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bnr)
  -- put( client )

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_map(bnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  -- buf_map(bnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- now in /Users/at/.config/nvim/plugin/setup-lsp.vim
  -- Now a buffer map in tools_rescript.vim
  -- buf_map(bnr, 'n', 'gek', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(bnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map(bnr, 'n', '<space><space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_map(bnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_map(bnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_map(bnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_map(bnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_map(bnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(bnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  -- Now a buffer map in tools_rescript.vim
  -- buf_map(bnr, 'n', 'ger', '<cmd>lua vim.lsp.buf.references()<CR>')
  buf_map(bnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  buf_map(bnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  buf_map(bnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  buf_map(bnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  buf_map(bnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

  buf_map(bnr, 'n', '<space>?', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

  vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]

  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
  -- buf_map(bnr, "n", "gd", ":LspDef<CR>")
  -- buf_map(bnr, "n", "gr", ":LspRename<CR>")
  -- buf_map(bnr, "n", "gy", ":LspTypeDef<CR>")
  -- buf_map(bnr, "n", "K", ":LspHover<CR>")
  -- buf_map(bnr, "n", "[a", ":LspDiagPrev<CR>")
  -- buf_map(bnr, "n", "]a", ":LspDiagNext<CR>")
  -- buf_map(bnr, "n", "ga", ":LspCodeAction<CR>")
  -- buf_map(bnr, "n", "<Leader>a", ":LspDiagLine<CR>")
  -- buf_map(bnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
  -- if client.resolved_capabilities.document_formatting then
  --     vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  -- end

end

-- vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]]
-- vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

-- highlight NormalFloat guibg=#1f2335
-- highlight FloatBorder guifg=white guibg=#1f2335

-- Float menu color
-- vim.cmd([[
--             highlight NormalFloat guibg=#151515
--             highlight FloatBorder guifg=#80A0C2 guibg=NONE
--         ]])

local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

local handler_filterDiagnSeverity = {
    ["textDocument/publishDiagnostics"] = function(_, result, ...)
        local min = vim.diagnostic.severity.INFO
        result.diagnostics = vim.tbl_filter(function(t)
            return t.severity <= min
        end, result.diagnostics)
        return vim.lsp.diagnostic.on_publish_diagnostics(_, result, ...)
    end,
}

-- ─   Diagnostics filter/disable rules /types of warnings──
-- ~/.config/nvim/help.md#/##%20How%20to

local handler_TS_filterDiagnCodes = {
    ["textDocument/publishDiagnostics"] = function(_, result, ...)
          result.diagnostics = vim.tbl_filter( function(t)
              return
                     t.code ~= 6133  -- defined but never used
                 and t.code ~= 7044  -- noImplicitAny
                 and t.code ~= 6196  -- declared but never used
                 and t.code ~= 6198  -- destructured elements unused
                 -- and t.code ~= 2307
          end, result.diagnostics )
        return vim.lsp.diagnostic.on_publish_diagnostics(_, result, ...)
    end,
}

local handler_JSON_filterDiagnCodes = {
    ["textDocument/publishDiagnostics"] = function(_, result, ...)
          result.diagnostics = vim.tbl_filter( function(t)
              return
                     t.code ~= 521  -- comments are not permitted in JSON
                 -- and t.code ~= 2307
          end, result.diagnostics )
        return vim.lsp.diagnostic.on_publish_diagnostics(_, result, ...)
    end,
}





-- handlers = {
--        ["textDocument/publishDiagnostics"] = vim.lsp.with(
--          vim.lsp.diagnostic.on_publish_diagnostics, {
--            -- Disable virtual_text
--            virtual_text = false
--          }
--        ),
--      }

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end


-- function FloatWin_ShowLines ( lines )
--   vim.lsp.util.open_floating_preview( lines )
-- end
--
-- function FloatWin_close ()
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local config = vim.api.nvim_win_get_config(win)
--     if config.relative ~= "" then
--       vim.api.nvim_win_close(win, false)
--       print('Closing window', win)
--     end
--   end
-- end

-- help vim.diagnostic.config()
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    -- prefix = '■',
    prefix = "|",
  },
  float = {
    -- source = "if_many",
    source = "always",
  },
  signs = false,
  underline = false,
  update_in_insert = false,
  severity_sort = false,
})

local signs = { Error = "•", Warn = "⚠", Hint = "➤", Info = "ℹ" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


-- ─   Individual server configs                        ──
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md


-- https://github.com/microsoft/pyright
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    on_attach(client)
  end,
  flags = flags,
  settings = {
    disableOrganizeImports = true,
  },
})


lspconfig.tsserver.setup({
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)
    buf_map(bufnr, "n", "gts", ":TSLspOrganize<CR>")
    buf_map(bufnr, "n", "gtf", ":TSLspRenameFile<CR>")
    buf_map(bufnr, "n", "gti", ":TSLspImportCurrent<CR>")
    buf_map(bufnr, "n", "gto", ":TSLspImportAll<CR>")
    on_attach(client, bufnr)
  end,
  -- handlers = handlers2,
  handlers = handler_TS_filterDiagnCodes,
  capabilities = capabilities,
  flags = flags,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  -- filetypes = { "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
})


lspconfig.purescriptls.setup ({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    purescript = {
      addSpagoSources = true, -- e.g. any purescript language-server config here
      censorWarnings = {"ShadowedName", "UnusedName", "UnusedDeclaration", "UnusedImport", "MissingTypeDeclaration"},
    }
  },
  flags = flags,
})
-- Options: https://github.com/nwolverson/vscode-ide-purescript/blob/master/package.json
-- https://github.com/purescript/purescript/blob/9534e24d3fb87d6c6b222c8b31d13b57cc5c3e04/src/Language/PureScript/Errors.hs


lspconfig.rescriptls.setup ({
  -- cmd = {"node", "/Users/at/.config/nvim/plugged/vim-rescript/server/out/server.js", "--stdio"},
  cmd = {"node", "/Users/at/.config/nvim/utils/rescript_vscode/server/out/server.js", "--stdio"},
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- https://github.com/ocaml/ocaml-lsp
lspconfig.ocamllsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})


-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#vimls
-- https://github.com/iamcco/vim-language-server
lspconfig.vimls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli
lspconfig.graphql.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- https://github.com/lighttiger2505/sqls
-- https://github.com/nanotee/sqls.nvim
-- mysql://root:PW@127.0.0.1:3306/pets
require('lspconfig').sqls.setup{
  on_attach = function(client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end,
  settings = {
    sqls = {
      connections = {
        {
          alias = 'mysql_pets',
          driver = 'mysql',
          dataSourceName = 'root:PW@127.0.0.1:3306/pets',
        },
        {
          alias = 'demo_world',
          driver = 'mysql',
          dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
        },

        {
          alias = 'pg_learn',
          driver = 'postgresql',
          dataSourceName = 'host=127.0.0.1 port=5432 user=postgres password=PW dbname=learn_dev',
        },
        {
          alias = 'pg_demo',
          driver = 'postgresql',
          dataSourceName = 'host=127.0.0.1 port=15432 user=postgres password=mysecretpassword1234 dbname=dvdrental sslmode=disable',
        },

      },
    },
  },
}


-- https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli
-- lspconfig.flow.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   flags = flags,
-- })


-- Todo: This works fine but i'd need to configure prettier e.g. to optionally let me use or not use semicolons/;
-- Todo: this duplicates messages of eslint_d
-- https://github.com/hrsh7th/vscode-langservers-extracted
lspconfig.eslint.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- https://github.com/hrsh7th/vscode-langservers-extracted
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- https://github.com/hrsh7th/vscode-langservers-extracted
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- https://github.com/bash-lsp/bash-language-server
lspconfig.bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- https://github.com/redhat-developer/yaml-language-server
lspconfig.yamlls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  settings = {
    yaml = {
      format = {
        printWidth = 100,
      },
    },
  },
})

-- https://github.com/hrsh7th/vscode-langservers-extracted
lspconfig.jsonls.setup({
  -- handlers = {
  --   ["textDocument/publishDiagnostics"] = vim.lsp.with(
  --     vim.lsp.diagnostic.on_publish_diagnostics, {
  --       -- Disable virtual_text
  --     virtual_text = true
  --     }
  --     ),
  -- },
  handlers = handler_JSON_filterDiagnCodes,
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
})


local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}


-- ─   null-ls                                          ──

-- vim.g.null_ls_disable = true
local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim
local diagnostics_format = "[#{c}] #{m} (#{s})"
local f = null_ls.builtins.formatting
local d = null_ls.builtins.diagnostics
null_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  sources = {
    -- codepell
    d.codespell.with({
      -- handlers = handlers,
      diagnostics_format = diagnostics_format,
    }),
    -- python
    d.flake8.with({
      diagnostics_format = diagnostics_format,
      prefer_local = ".venv/bin",
    }),
    f.isort.with({
      diagnostics_format = diagnostics_format,
      prefer_local = ".venv/bin",
      extra_args = { "--profile", "black" },
    }),
    f.black.with({
      diagnostics_format = diagnostics_format,
      prefer_local = ".venv/bin",
      extra_args = { "--fast" },
    }),
    -- javascript/typescript
    -- d.eslint_d.with({
    --   diagnostics_format = diagnostics_format,
    -- }),
    f.prettier.with({
      diagnostics_format = diagnostics_format,
      filetypes = { "html", "json", "yaml", "markdown" },
    }),
    -- sh/bash
    d.shellcheck.with({
      diagnostics_format = diagnostics_format,
    }),
    f.shfmt.with({
      diagnostics_format = diagnostics_format,
      extra_args = { "-i", "2" },
    }),
    -- lua
    f.stylua.with({
      diagnostics_format = diagnostics_format,
      extra_args = { "--indent-type", "Spaces" },
    }),
    -- json
    f.fixjson.with({
      diagnostics_format = diagnostics_format,
    }),
    -- yaml
    d.yamllint.with({
      diagnostics_format = diagnostics_format,
      extra_args = { "-d", "{extends: default, rules: {line-length: {max: 100}}}" },
    }),
    -- sql
    f.sqlformat.with({
      diagnostics_format = diagnostics_format,
    }),
    -- toml
    f.taplo.with({
      diagnostics_format = diagnostics_format,
    }),
    -- css/scss/sass/less
    f.stylelint.with({
      diagnostics_format = diagnostics_format,
    }),
  },
})



null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
  },
  on_attach = on_attach
})


-- ─   nvim-cmp setup                                    ■

-- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'noinsert,menuone,noselect'
vim.o.completeopt = 'menuone,noselect'
-- help completeopt

-- luasnip setup
local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup {
  completion = {
    autocomplete = false, -- disable auto-completion.
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<c-m>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
      { name = 'buffer' },
    })
  -- sources = {
  --   { name = 'nvim_lsp' },
  --   { name = 'luasnip' },
  -- },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
      { name = 'cmdline' }
    })
})

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








