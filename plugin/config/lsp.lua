
local lspconfig = require 'lspconfig'
local Path = require "plenary.path"

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
  --   noremap = true,
  --   silent = true,
  -- })
end


-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local flags = {
  debounce_text_changes = 150,
}

-- these are currently not used for scala or null_ls. see maps here
-- ~/.config/nvim/plugin/utils_general_maps.lua#/--%20also%20at.

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bnr)
  -- put( client )

  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
  -- buf_map(bnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(bnr, 'n', '<space>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
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
  vim.cmd("command! LspDocSymbols lua require('telescope.builtin').lsp_document_symbols()")
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


  if client.server_capabilities.document_formatting then
      vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end

  if client.server_capabilities.documentSymbolProvider then
    local navic = require "nvim-navic"
    navic.attach(client, bnr)
  end

end

-- setting a global (for all lsp clients) handler. seems to work!
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = false,
    -- reportUnusedVariable = false,
    -- disableSelfClsNotAccessed = true,
  }
)

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


-- LSP[pyright]: Error ON_ATTACH_ERROR: "/Users/at/.vim/plugged/nvim-navic/lua/nvim-navic/init.lua:311: bad argument #3 to '__index' (string expected, got nil)"


-- Import "langchain_core.documents" could not be resolved [reportMissingImports]
-- python 1
-- https://github.com/microsoft/pyright
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
    on_attach(client, bufnr)
  end,
  flags = flags,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
    },
    disableOrganizeImports = true,
    -- TODO: this seems to have no effect?
    -- reportUnusedVariable = false,
    -- disableSelfClsNotAccessed = true,
  },

  before_init = function(_params, config)
  -- Check if CONDA_PREFIX environment variable is set
  local conda_prefix = os.getenv('CONDA_PREFIX')
  if conda_prefix then
    -- Construct the path to the Python interpreter in the Conda environment
    local python_path = Path:new(conda_prefix):joinpath("bin", "python")
    if python_path:is_file() then
      -- Set the Python interpreter path in Pyright settings
      config.settings.python.pythonPath = tostring(python_path)
      return
    end
  end

  -- Fallback to .venv or system Python if no active Conda environment
  local dotvenv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
  local venv_bin = vim.fn.getcwd() .. "/venv/bin"
  if dotvenv:joinpath("bin"):is_dir() then
    config.settings.python.pythonPath = tostring(dotvenv:joinpath("bin", "python"))
  elseif vim.fn.isdirectory(venv_bin) then
    config.settings.python.pythonPath = venv_bin
  else
    config.settings.python.pythonPath = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
  end
  end,

  -- .venv/bin/python
  -- before_init = function(_params, config)
  --   local dotvenv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
  --   -- local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), "venv")
  --   local venv_bin = vim.fn.getcwd() .. "/venv/bin"
  --   if dotvenv:joinpath("bin"):is_dir() then
  --     -- putt( "pyright using poetry .venv" )
  --     config.settings.python.pythonPath = tostring(dotvenv:joinpath("bin", "python"))
  --   elseif vim.fn.isdirectory( venv_bin ) then
  --     -- putt( "pyright using local venv" )
  --     config.settings.python.pythonPath = venv_bin
  --   else
  --     putt( "venv folder not found" )
  --     config.settings.python.pythonPath = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
  --   end
  -- end,

  -- from https://www.reddit.com/r/neovim/comments/wls43h/pyright_lsp_configuration_for_python_poetry/

  -- before_init = function(_, config)
  --   config.settings.python.pythonPath = "/Users/at/.venv/bin/python"
  -- end,

})



-- NOTE these also find this local env paths! but only when source venv/bin/activate was run!?
-- vim.fn.exepath("python3")
-- "/Users/at/Documents/Proj/e_ds/py_oai_plg/venv/bin/python3"
-- vim.fn.exepath("python")
-- vim.fn.isdirectory("venv" .. "/bin")

-- Custom handler to filter out interface definitions
local function custom_handler_filter_interfaceDefs(err, result, ctx, config)
  if err then
    vim.notify('Error: ' .. err.message, vim.log.levels.ERROR)
    return
  end

  if not result or vim.tbl_isempty(result) then
    vim.notify('No location found', vim.log.levels.INFO)
    return
  end

  -- Filter out interface definitions
  local locations = vim.tbl_filter(function(item)
    return not string.match(item.uri, '%.ts$')
  end, result)

  if vim.tbl_isempty(locations) then
    vim.notify('No 1 implementation found', vim.log.levels.INFO)
    return
  end

  vim.lsp.util.jump_to_location(locations[1], 'utf-8')
end


lspconfig.tsserver.setup({
  settings = {
    typescript = {
      symbolInfo = {
        memberSymbols = true,
        classSymbols = true
      }
    }
  },
  on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)
    buf_map(bufnr, "n", "gts", ":TSLspOrganize<CR>")
    buf_map(bufnr, "n", "gtf", ":TSLspRenameFile<CR>")
    buf_map(bufnr, "n", "gti", ":TSLspImportCurrent<CR>")
    buf_map(bufnr, "n", "gto", ":TSLspImportAll<CR>")
    vim.keymap.set('n', 'gtg', function() vim.lsp.buf_request(0, 'textDocument/implementation', vim.lsp.util.make_position_params(), custom_handler_filter_interfaceDefs) end, bufopts)
    on_attach(client, bufnr)
  end,
  -- handlers = handlers2,
  handlers = handler_TS_filterDiagnCodes,
  capabilities = capabilities,
  flags = flags,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  -- filetypes = { "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
})


-- lspconfig.purescriptls.setup ({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   settings = {
--     purescript = {
--       addSpagoSources = true, -- e.g. any purescript language-server config here
--       censorWarnings = {"ShadowedName", "UnusedName", "UnusedDeclaration", "UnusedImport", "MissingTypeDeclaration"},
--     }
--   },
--   flags = flags,
-- })
-- -- Options: https://github.com/nwolverson/vscode-ide-purescript/blob/master/package.json
-- -- https://github.com/purescript/purescript/blob/9534e24d3fb87d6c6b222c8b31d13b57cc5c3e04/src/Language/PureScript/Errors.hs


-- lspconfig.rescriptls.setup ({
--   -- cmd = {"node", "/Users/at/.config/nvim/plugged/vim-rescript/server/out/server.js", "--stdio"},
--   cmd = {"node", "/Users/at/.config/nvim/utils/rescript_vscode/server/out/server.js", "--stdio"},
--   capabilities = capabilities,
--   on_attach = on_attach,
--   flags = flags,
-- })

-- https://github.com/ocaml/ocaml-lsp
-- lspconfig.ocamllsp.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   flags = flags,
-- })


-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#vimls
-- https://github.com/iamcco/vim-language-server
lspconfig.vimls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  update_in_insert = false,
  flags = flags,
  init_options = {
    diagnostic = {
      enable = true
    },
    indexes = {
      count = 3,
      gap = 100,
      projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
      runtimepath = true
    },
    isNeovim = true,
    iskeyword = "@,48-57,_,192-255,-#",
    runtimepath = "",
    suggest = {
      fromRuntimepath = true,
      fromVimruntime = true
    },
    vimruntime = ""
  }
})


-- NOTE this doesn't seem to be needed to get vim diagnostic messages. delete this? ■
-- local diagnosticls = require("diagnosticls-configs")
-- require'lspconfig'.diagnosticls.setup{
--   capabilities = capabilities,
--   on_attach = on_attach,
--   flags = flags,
--   filetypes = {
--     "vim",
--   },
--   init_options = {
--     linters = diagnosticls.linters,
--     filetypes = {
--       vim = "vint",
--     },
--   },
-- }
-- lspconfig.diagnosticls.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   flags = flags,
--   filetypes = {
--     "vim",
--   },
--   init_options = {
--     linters = diagnosticls.linters,
--     filetypes = {
--       vim = "vint",
--     },
--   },
-- }) ▲


-- https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli
lspconfig.graphql.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  filetypes = { "vim" },
})

-- https://github.com/lighttiger2505/sqls
-- https://github.com/nanotee/sqls.nvim
-- mysql://root:PW@127.0.0.1:3306/pets
-- lspconfig.sqlls.setup{
--   on_attach = function(client, bufnr)
--     require('sqlls').on_attach(client, bufnr)
--   end,
--   settings = {
--     sqlls = {
--       connections = {
--         -- {
--         --   alias = 'mysql_pets',
--         --   driver = 'mysql',
--         --   dataSourceName = 'root:PW@127.0.0.1:3306/pets',
--         -- },

--         -- {
--         --   alias = 'demo_world',
--         --   driver = 'mysql',
--         --   dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
--         -- },

--         -- {
--         --   alias = 'pg_learn',
--         --   driver = 'postgresql',
--         --   dataSourceName = 'host=127.0.0.1 port=5432 user=postgres password=PW dbname=learn_dev',
--         -- },

--         -- {
--         --   alias = 'pg_demo',
--         --   driver = 'postgresql',
--         --   dataSourceName = 'host=127.0.0.1 port=15432 user=postgres password=mysecretpassword1234 dbname=dvdrental sslmode=disable',
--         -- },

--         {
--           alias = 'muse',
--           -- driver = 'postgresql',
--           adapter = 'postgres',
--           dataSourceName = 'host=0.0.0.0 port=5432 user=postgres password=password dbname=muse',
--         },


--       },
--     },
--   },
-- }

-- /Users/at/.config/sql-language-server/.sqllsrc.json
-- sql-language-server up --help


require'lspconfig'.dockerls.setup{}

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

-- Works. .. but after some say 5 mins raises an error in js files.
-- lspconfig.tailwindcss.setup{}
-- Lazy vim config
-- https://gist.github.com/nguyenyou/2d7327e3d03b4e0b493e8e9d9063c872

-- https://github.com/hrsh7th/vscode-langservers-extracted
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})


local handler_BASH_filterDiagnCodes = {
    ["textDocument/publishDiagnostics"] = function(_, result, ...)
          result.diagnostics = vim.tbl_filter( function(t)
              return
                     t.code ~= 2154  -- comments are not permitted in JSON
                 -- and t.code ~= 2307
          end, result.diagnostics )
        return vim.lsp.diagnostic.on_publish_diagnostics(_, result, ...)
    end,
}


-- https://github.com/bash-lsp/bash-language-server
-- -- TODO: filter all the warnings about double quotes, ect.
-- this is now done via ~/.shellcheckrc
-- npm i -g bash-language-server
lspconfig.bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  -- no effect?
  -- handlers = handler_filterDiagnSeverity,
  -- handlers = handler_BASH_filterDiagnCodes,
  -- not sure if this has an effect either?
  handlers = {
   ["textDocument/publishDiagnostics"] = vim.lsp.with(
     vim.lsp.diagnostic.on_publish_diagnostics, {
       severity_sort = true,
     }
   ),
 },
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
      -- untested! https://itnext.io/better-kubernetes-yaml-editing-with-neo-vim-af7da9a1b150
      schemas = {
        kubernetes = "k8s-*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
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


-- local runtime_path = vim.split(package.path, ';')
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")


-- TODO: lua_ls works nicely as is. however there are a lot of warnings in my config which spam the trouble list which i don't know how to filter.
-- lspconfig.lua_ls.setup {
--   capabilities = capabilities,
--   on_attach = function(client, bufnr)
--     on_attach(client, bufnr)
--   end,
--   settings = {
--     Lua = {
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = { 'vim' },
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--         checkThirdParty = true,
--       },
--       window = {
--         progressBar = false
--       },
--     },
--   },
-- }

  -- settings = {
  --   Lua = {
  --     runtime = {
  --       -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
  --       version = 'LuaJIT',
  --       -- Setup your lua path
  --       path = runtime_path,
  --     },
  --     diagnostics = {
  --       -- Get the language server to recognize the `vim` global
  --       globals = {'vim'},
  --     },
  --     workspace = {
  --       -- Make the server aware of Neovim runtime files
  --       library = vim.api.nvim_get_runtime_file("", true),
  --     },
  --   },
  -- },

-- ─   Smithy                                           ──

-- https://github.com/keynmol/dot/blob/0736187795fd65f84072ed0831681aa3aaf74906/nvim/init.lua#L482
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.smithy" },
      callback = function() vim.cmd("setfiletype smithy") end
    })

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#smithy_ls

lspconfig.smithy_ls.setup ({
  -- cmd = { 'cs', 'launch', 'com.disneystreaming.smithy:smithy-language-server:latest.release', '--', '0' },
  cmd = { "cs", "launch", "com.disneystreaming.smithy:smithy-language-server:0.0.21", "--", "0" },
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
})

-- require'lspconfig'.smithy_ls.setup{
--   capabilities = capabilities,
--   on_attach = on_attach,
--   flags = flags,
-- }

-- ─   null-ls                                          ──

-- vim.g.null_ls_disable = true
local null_ls = require("null-ls")


-- https://github.com/jose-elias-alvarez/null-ls.nvim
-- local diagnostics_format = "[#{c}] #{m} (#{s})"
local f = null_ls.builtins.formatting
local d = null_ls.builtins.diagnostics
null_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  sources = {
    -- codepell
    -- d.codespell.with({
    --   -- handlers = handlers,
    --   diagnostics_format = diagnostics_format,
    --   extra_args = { "--ignore-words=~/.config/nvim/spell/codespell-ignore.txt" },
    -- }),
    -- python 2
    -- d.flake8.with({
    --   diagnostics_format = diagnostics_format,
    --   prefer_local = ".venv/bin",
    -- }),
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
      filetypes = { "html", "json", "yaml" },
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



-- null_ls.setup({
--   sources = {
--     null_ls.builtins.diagnostics.eslint_d,
--     null_ls.builtins.code_actions.eslint_d,
--     null_ls.builtins.formatting.prettier,
--     null_ls.builtins.completion.spell,
--     null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
--   },
--   on_attach = on_attach
-- })


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

-- WARNING - TODO: need to clean up the duplication ~/.config/nvim/plugin/config/cmp.lua‖*nvim-cmpˍsetup
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

  view = {
    selection_order = 'bottom_up', -- This will start the completion menu from the bottom
  },

  sorting = {
     comparators = {
      -- cmp.config.compare.order, -- This will sort by the order in which they were added
      cmp.config.compare.score, -- This will sort by the match score
      -- cmp.config.compare.kind, -- This will sort by the kind of the completion item
      -- cmp.config.compare.sort_text, -- This will sort by the sort text provided by the LSP
      -- cmp.config.compare.length, -- This will sort by the length of the completion item
      -- cmp.config.compare.offset, -- This will sort by the offset of the completion item
    
      -- -- cmp.config.compare.offset,
      -- -- cmp.config.compare.exact,
      -- -- cmp.config.compare.score,
      -- -- cmp.config.compare.kind,
      -- -- -- cmp.config.compare.sort_text, -- Commented out to disable LSP's sort_text sorting
      -- -- cmp.config.compare.length,
      -- -- cmp.config.compare.order,

     }
   },

  formatting = {
    format = function(entry, vim_item)
      -- if vim.tbl_contains({ 'path' }, entry.source.name) then
      --   local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
      --   if icon then
      --     vim_item.kind = icon
      --     vim_item.kind_hl_group = hl_group
      --     return vim_item
      --   end
      -- end
      return require('lspkind').cmp_format({ 
        with_text = false,
        -- WORKS! with ~/Documents/Proj/l_local_fst/m/js_simple/esbuild/index.html‖/<divˍclass=
        before = require("tailwind-tools.cmp").lspkind_format,
        -- mode = "symbol_text",
        menu = ({
          buffer = "B",
          -- nvim_lsp = "[LSP]",
          luasnip = "snip",
        })
      })(entry, vim_item)
    end
  },

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


-- ─   Scala                                            ──

local api = vim.api
-- local cmd = vim.cmd

-- local function map(mode, lhs, rhs, opts)
--   local options = { noremap = true }
--   if opts then
--     options = vim.tbl_extend("force", options, opts)
--   end
--   api.nvim_set_keymap(mode, lhs, rhs, options)
-- end


----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
-- vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
-- vim.opt_global.shortmess:remove("F"):append("c")

-- LSP mappings
-- map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>")
-- map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
-- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
-- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
-- map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
-- map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
-- map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
-- map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
-- map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
-- map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
-- map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
-- map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
-- map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
-- map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
-- map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
-- map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
-- map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

-- -- Example mappings for usage with nvim-dap. If you don't use that, you can
-- -- skip these
-- map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
-- map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
-- map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
-- map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
-- map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
-- map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
-- map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

-- completion related settings
-- This is almost a duplicate from above.
-- local cmp = require("cmp")
-- cmp.setup({
--   sources = {
--     { name = "nvim_lsp" },
--     { name = "vsnip" },
--   },
--   snippet = {
--     expand = function(args)
--       -- Comes from vsnip
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert({
--     -- None of this made sense to me when first looking into this since there
--     -- is no vim docs, but you can't have select = true here _unless_ you are
--     -- also using the snippet stuff. So keep in mind that if you remove
--     -- snippets you need to remove this select
--     ["<CR>"] = cmp.mapping.confirm({ select = true }),
--     -- I use tabs... some say you should stick to ins-completion but this is just here as an example
--     ["<Tab>"] = function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         fallback()
--       end
--     end,
--     ["<S-Tab>"] = function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       else
--         fallback()
--       end
--     end,
--   }),
-- })

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  -- TODO 12-23: test these
  showImplicitArguments = false,
  showImplicitConversionsAndClasses = false,
  showInferredType = true,
  superMethodLensesEnabled = true,
  enableSemanticHighlighting = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- codeLens issue 2024-05: method textDocument/codeLens is not supported by any of the servers registered
-- similar to https://github.com/elixir-tools/elixir-tools.nvim/issues/211
-- ~/.config/nvim/plugged/nvim-metals/lua/metals/handlers.lua‖/lsp.codelen

-- metals_config.settings = {
--     superMethodLensesEnabled = false,  -- Disable navigation to parent classes
--     showImplicitArguments = false,     -- Disable implicit arguments
--     showInferredType = false,          -- Disable inferred types
--     enableSemanticHighlighting = true,
--   }

-- metals_config.init_options = {
--   statusBarProvider = "on",
--   isHttpEnabled = true,
--   compilerOptions = {
--     completion = {
--       enable = true
--     }
--   }
-- }


-- this doesn't exist, delete
vim.g['metals_autoImport'] = false

-- vim.highlight.priorities.semantic_tokens
vim.highlight.priorities.semantic_tokens = 125
-- vim.highlight.priorities.semantic_tokens = 22

metals_config.init_options.statusBarProvider = "on"
-- metals_config.init_options.statusBarProvider = "off"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)


-- DEACTIVATED: COQ
-- it only needs this line to work, even together with nvim-cmp.
-- capabilities = require('coq').lsp_ensure_capabilities( capabilities )


metals_config.capabilities = capabilities

metals_config.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local navic = require "nvim-navic"
    navic.attach(client, bufnr)
  end
end


-- Autocmd that will actually be in charge of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- lua vim.lsp.handlers["textDocument/codeLens"] = function() end


