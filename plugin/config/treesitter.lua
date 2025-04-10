
vim.opt.foldlevel = 99     -- High value ensures all folds are open

-- Enable treesitter folding
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"markdown"},
  callback = function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- Optional: start with all folds open
    vim.wo.foldenable = true
    vim.wo.foldlevel = 99
  end
})

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {

  fold = { enable = true },

  -- A list of parser names, or "all". These parsers should always be installed.
  -- ensure_installed = { "scala", "typescript", "python", "sql", "bash", "just" },
  ensure_installed = "all",

  -- queries = {
  --   scala = {
  --     -- Path to your query file relative to the Neovim config directory
  --     sql_in_triple_quotes = "queries/scala.scm"
  --   }
  -- },

  -- Install parsers synchronously. This is only applied to `ensure_installed`.
  sync_install = false,

  -- Automatically install missing parsers when entering buffer.
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally.
  auto_install = true,

  autotag = {
    enable = true,
  },

  -- List of parsers to ignore installing (or "all").
  ignore_install = {},

  highlight = {
    enable = true, -- false will disable the whole extension
    -- additional_vim_regex_highlighting = true,
    -- below doesn't work! .. so i currently use ~/.config/nvim/plugin/HsSyntaxAdditions.vim‖/autocmdˍFil
    -- NOTE: this actually works! but the parser still needs to be installed
    disable = {"graphql", "sass", "zsh"},
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
      -- init_selection = 'gnn',
      -- init_selection = 'yst',
      -- i think in visual mode these maps would slow the normal "y" yank to copy?
      -- node_incremental = 'ysn',
      scope_incremental = 'grc',
      -- node_decremental = 'ysd',
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

        -- Add markdown heading textobjects
        -- ['aH'] = '@section.outer', -- This corresponds to a heading and its content
        -- ['iH'] = '@section.inner', -- This might capture just the heading text
        -- These don't seem to work. See this alternative approach
        -- ~/.config/nvim/plugin/basics/CodeMarkup.vim‖/Markdown_Heading_VisSel_AroundContent(scope)

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
      set_jumps = false, -- whether to set jumps in the jumplist
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



-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.just = {
--   install_info = {
--     url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
--     files = {"src/parser.c"}, -- adjust according to your parser's source files
--   },
--   filetype = "just", -- if filetype does not match the parser name
-- }

-- git clone https://github.com/IndianBoy42/tree-sitter-just ~/.local/share/nvim/site/pack/tree-sitter-queries/start/tree-sitter-just
-- git clone https://github.com/serenadeai/tree-sitter-scss ~/.local/share/nvim/site/pack/tree-sitter-queries/start/tree-sitter-sass

require('tree-sitter-just').setup({})
-- require('tree-sitter-scss').setup({})
-- require('tree-sitter-sass').setup({})

-- Function to disable Tree-sitter for a specific buffer
local function disable_treesitter_for_sass()
 if vim.api.nvim_buf_get_option(0, 'filetype') == 'sass' then
    vim.treesitter.stop()
 end
end

-- Autocommand to call the function when entering a buffer
vim.api.nvim_create_autocmd("BufEnter", {
 pattern = "*",
 callback = disable_treesitter_for_sass,
})

-- local ft_to_lang = require('nvim-treesitter.parsers').ft_to_lang
-- require('nvim-treesitter.parsers').ft_to_lang = function(ft)
--     if ft == 'zsh' then
--         return 'bash'
--     end
--     return ft_to_lang(ft)
-- end

vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("css", "sass")
-- Add a mapping to select the entire buffer in visual mode
vim.keymap.set('n', '<leader>vab', 'ggVG', { noremap = true, silent = true, desc = "Select entire buffer" })

-- require("plugins.markdown-fold")

