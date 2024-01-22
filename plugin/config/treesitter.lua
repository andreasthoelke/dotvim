

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {

  -- A list of parser names, or "all". These parsers should always be installed.
  ensure_installed = { "scala", "typescript", "python", "sql", "bash" },


  -- Install parsers synchronously. This is only applied to `ensure_installed`.
  sync_install = false,

  -- Automatically install missing parsers when entering buffer.
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally.
  auto_install = true,

  -- List of parsers to ignore installing (or "all").
  ignore_install = {},

  highlight = {
    enable = true, -- false will disable the whole extension
    -- disable = {"txt"},  -- list of languages that will be disabled
    -- additional_vim_regex_highlighting = true,
    -- below doesn't work! .. so i currently use ~/.config/nvim/plugin/HsSyntaxAdditions.vim‖/autocmdˍFil
    -- disable = { "less", "clojure" },
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    ["foo.bar"] = "Identifier",
    },
  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  -- context_commentstring = {
  --   enable = true
  -- },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['<leader>ab'] = '@block.outer',
        ['av'] = '@frame.outer',
        -- Temp: disabled this in favour of vim-targets (which works for function args)
        -- ['aa'] = '@parameter.outer',
        -- ['ia'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        -- Todo:
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects 
        -- ['<c-m>'] = '@function.outer',
        -- [']a'] = '@block.inner',
        -- [']b'] = '@block.outer',
        -- [']c'] = '@call.inner',
        -- [']d'] = '@call.outer',
        -- [']e'] = '@scopename.inner',
        -- [']f'] = '@statement.outer',
        -- [']g'] = '@frame.inner',
        -- [']h'] = '@frame.outer',
        -- [',w'] = '@parameter.inner',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']P'] = '@parameter.outer',
        -- [',e'] = '@parameter.inner',
      },
      goto_previous_start = {
        -- ['<c-i>'] = '@function.outer',
        ['<space>b'] = '@frame.outer',
        ['[p'] = '@parameter.outer',
        -- [',b'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[P'] = '@parameter.outer',
        -- [',ge'] = '@parameter.inner',
      },
    },
  },
}

require('ts_context_commentstring').setup {}
vim.g.skip_ts_context_commentstring_module = true

-- old
-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
--   sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
--   ignore_install = { "c" }, -- List of parsers to ignore installing
--   highlight = {
--     enable = true,              -- false will disable the whole extension
--     disable = { "c", "rust" },  -- list of language that will be disabled
--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = false,
--   },
-- }








