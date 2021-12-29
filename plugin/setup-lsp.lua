
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

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_map(bnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_map(bnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_map(bnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(bnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map(bnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_map(bnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_map(bnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_map(bnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_map(bnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_map(bnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(bnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_map(bnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  buf_map(bnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  buf_map(bnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  buf_map(bnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  buf_map(bnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  buf_map(bnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

  buf_map(bnr, 'n', '<space>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

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
        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
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



local null_ls = require("null-ls")

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
    ['<Tab>'] = function(fallback)
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
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


-- ─^  nvim-cmp setup                                    ▲










