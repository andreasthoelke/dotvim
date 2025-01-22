

local opts_1 = { initial_mode = 'normal' }
local opts_2 = {
  sorting_strategy = 'ascending',
  -- default_text = [[(Seq|List)]],
}

local dir_a_scala3 = '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/'
local dir_nvim = [[/Users/at/.config/nvim/plugin]]
local dirs_nvim = { [[/Users/at/.config/nvim/plugin]], [[/Users/at/.config/nvim/lua]]}

local rgx_caps_tag = [[\s[A-Z]{3,}:]]
local rgx_comment = [[^(\s*)?(//|\*\s)]]
local rgx_main_symbol = [[(def\s|case\sclass|enum\s|val\s[^e])]]
local rgx_main_symbol_vimLua = [[^(func|local\sfunction|command!)]]
-- local rgx_keymap_vimlua = [[keymap.*\n.*\n]]
local rgx_keymap_vim = [[((noremap\s|map\s)|keymap.*\n.*\n)]]
local rgx_header = [[─.*]]
-- local rgx_signature = [[(def|extension).*(\n)?.*(\n)?.*(\n)?.*\s=\s]]
-- local rgx_signature = [[(def\s|extension).*?(\n)?.*?(\n)?.*?(\n)?.*?\s=\s]]
-- local rgx_signature = [[(?:(def\s|extension).*?(\n)?.*?(\n)?.*?(\n)?.*?\s=(\s|$)).*(List|Seq)]]
-- local rgx_signature = [[(?:(def\s|extension).*?(\n)?.*(\n)?.*(\n)?.*\s=\s).*(List|Seq|Iterable)]]
local rgx_signature = [[(?:(def\s|extension).*?(\n)?.*?(\n)?.*?(\n)?.*?\s=\s)]]
local rgx_collection = [[(List|Seq|Iterable)]]

local glb_projs1 = {
  '-g', '**/AZioHttp/*.scala',
  '-g', '**/BZioHttp/*.scala'
}

local glb_patterns1 = {
  '-g', '**/*pattern*.scala',
  '-g', '**/*utils*.scala',
}

local glb_vim = {
  '-g', '**/plugin/*.vim',
  '-g', '**/plugin/*.lua',
  '-g', '**/lua/*.lua',
}

local paths_projs1 = {
  '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/AZioHttp/',
  '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/',
}

local paths_patterns1 = {
  '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/',
}


-- function M.RgxSelect_Picker(opts, rgx_query, globs, paths)

-- now using regular live grep
-- ~/.config/nvim/plugin/utils-fileselect-telescope.vim#/Find%20files%20using
-- search in [A]ll scala code:
-- vim.keymap.set( 'n',
--   ',sa', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     "",
--     {"-g", "*.scala"},
--     {'.'}
--     ) end )

-- vim.keymap.set( 'n',
--   ',sA', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     "",
--     {"-g", "*.scala"},
--     {'/Users/at/Documents/Proj/b_expl_stack/'}
--     ) end )

vim.keymap.set( 'n',
  ',sA', function() Telesc_launch( 'live_grep', {
    initial_mode = 'insert',
    -- default_text = pattern,
    search_dirs = {'/Users/at/Documents/Proj/b_expl_stack/'},
  } )
  end )


vim.keymap.set( 'n',
  ',sA', function() Telesc_launch( 'live_grep', {
    initial_mode = 'insert',
    -- default_text = pattern,
    search_dirs = {'/Users/at/Documents/Proj/b_expl_stack/'},
  } )
  end )


-- search in scala [S]ymbols:
-- (also note gel for the lsp symbols in the current file)
vim.keymap.set( 'n',
  ',ss', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_main_symbol,
    {"-g", "*.scala"},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sS', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_main_symbol,
    {"-g", "*.scala"},
    {'/Users/at/Documents/Proj/b_expl_stack/'}
    ) end )

-- search in [A]ll scala code:
vim.keymap.set( 'n',
  'ge;', function() require( 'utils.general' )
    .RgxSelect_Picker( {},
      "",
      {"-g", "*.scala"},
      {'.'}
    ) end )

vim.keymap.set( 'n',
  'ge:', function() require( 'utils.general' )
    .RgxSelect_Picker( {},
      "",
      {"-g", "*.scala"},
      {'/Users/at/Documents/Proj/b_expl_stack/'}
    ) end )



-- search in comment TAGS:
vim.keymap.set( 'n',
  ',st', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_caps_tag,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sT', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_caps_tag,
    glb_projs1,
    {'..'}
    ) end )

-- search in COMMENTS:
-- vim.keymap.set( 'n',
--   ',sc', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_comment,
--     {},
--     {'.'}
--     ) end )

-- vim.keymap.set( 'n',
--   ',sC', function() require( 'utils.general' )
--   .RgxSelect_Picker( {},
--     rgx_comment,
--     glb_projs1,
--     {'..'}
--     ) end )

-- search in HEADERS:
vim.keymap.set( 'n',
  ',sh', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_header,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sH', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_header,
    glb_projs1,
    {'..'}
    ) end )

-- search in SIGNATURES:
vim.keymap.set( 'n',
  ',sg', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_signature,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sG', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_signature,
    glb_patterns1,
    {'..'}
    ) end )

vim.keymap.set( 'n',
  ',si', function() require( 'utils.general' )
  .RgxSelect_Picker( {},
    rgx_signature .. '.*' .. rgx_collection,
    glb_projs1,
    {'..'}
    ) end )

vim.keymap.set( 'n',
  ',sz', function() require( 'utils.general' )
  .RgxSelect_Picker( opts_2,
    rgx_signature .. '.*?' .. [[ZIO]],
    glb_projs1,
    {'..'}
    ) end )

-- ─   Git picker maps                                  ──
-- NOTE these maps: ~/.config/nvim/plugin/utils/utils-git.vim‖*GitˍTools

-- These work well!

opts_gitstat = {
  layout_config = {
    height=0.99, 
    width=0.82,
    horizontal = {
      preview_width = 0.6,  -- Takes up 60% of the window width
    },
    vertical = {
      preview_height = 0.8,  -- Takes up 70% of the window height
    },
  },
  initial_mode='normal',
}


-- A benefit of using Github-style Delta based diffs is that small changes within lines
-- are highlighted using green and red bg-colors. But in some cases I still prefer DiffviewFileHistory 
vim.keymap.set( 'n',
  '<leader>ogl', function() require( 'utils.general' )
  .Git_commits_picker( opts_gitstat, vim.fn.expand('%') )
  end )

vim.keymap.set( 'n',
  '<leader>ogL', function() require( 'utils.general' )
  .Git_commits_picker( opts_gitstat )
  end )

-- NOTE: gg.. maps conflict with gg - go to top of page!
-- vim.keymap.set( 'n',
--   'ggl', function() require( 'utils.general' )
--   .Git_commits_picker( opts_gitstat, vim.fn.expand('%') )
--   end )

-- vim.keymap.set( 'n',
--   'ggL', function() require( 'utils.general' )
--   .Git_commits_picker( opts_gitstat )
--   end )


-- DiffviewFileHistory shows new code blocks in the normal editor with normal syntax highlight.
vim.keymap.set('n', '<leader><leader>ogl', ':DiffviewFileHistory %<CR>', { noremap = true, silent = true, desc = "Open Git log for current file" })
vim.keymap.set('n', '<leader><leader>ogL', ':DiffviewFileHistory<CR>',   { noremap = true, silent = true, desc = "Open Git log: Involved files per commit." })


-- vim.keymap.set( 'n',
--   '<leader>ogs', function() require( 'utils.general' )
--   .Git_status_picker( opts_1 )
--   end )


vim.keymap.set( 'n',
  '<leader>ogs', function() require( 'utils.general' )
  .Git_status_picker( opts_gitstat )
  end )

-- vim.keymap.set( 'n',
--   'ggs', function() require( 'utils.general' )
--   .Git_status_picker( opts_gitstat )
--   end )


-- no nice styling of diffs
vim.keymap.set( 'n',
  '<leader>ogS', function() Telesc_launch( 'git_status', {
    initial_mode = 'normal',
    cwd = vim.fn.getcwd( vim.fn.winnr() ),
  } )
  end )

-- no nice styling of diffs
-- vim.keymap.set( 'n',
--   'ggS', function() Telesc_launch( 'git_status', {
--     initial_mode = 'normal',
--     cwd = vim.fn.getcwd( vim.fn.winnr() ),
--   } )
--   end )

-- ─   Gitsigns                                          ■

-- Maps:
-- l gh    - Gitsigns change_base ~1
-- l gH    - Gitsigns change_base
-- l g1    - Gitsigns change_base ~1
-- l g2    - Gitsigns change_base ~2
-- l g3    - Gitsigns change_base ~3
-- l g4    - Gitsigns change_base ~4

vim.keymap.set( 'n',
  '<leader>gd', function()
    MiniDiff.toggle_overlay()
    vim.cmd 'Gitsigns toggle_signs'
    -- potential alterative:
    -- vim.cmd 'set number'
    -- vim.cmd 'set nonumber'
  end )

vim.keymap.set('n', '<leader>gh', ':Gitsigns change_base ~1<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gH', ':Gitsigns change_base<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g1', ':Gitsigns change_base ~1<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g2', ':Gitsigns change_base ~2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g3', ':Gitsigns change_base ~3<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g4', ':Gitsigns change_base ~4<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g5', ':Gitsigns change_base ~5<CR>', { noremap = true, silent = true })

-- ─^  Gitsigns                                          ▲

vim.keymap.set( 'n',
  '<leader>ogd', function() require( 'utils.general' )
  .Git_diff_to_master( opts_1 )
  end )

-- search in VIM_MAIN_SYMBOLS:
vim.keymap.set( 'n',
  ',svs', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    rgx_main_symbol_vimLua,
    {},
    dirs_nvim
    ) end )


-- search in VIM_KEYMAPS:
vim.keymap.set( 'n',
  ',svm', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    rgx_keymap_vim,
    {},
    dirs_nvim
    ) end )


-- search in entire vim code:
vim.keymap.set( 'n',
  ',svv', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    "",
    {},
    dirs_nvim
    ) end )

-- search in entire vim headers:
vim.keymap.set( 'n',
  ',svh', function() require( 'utils.general' )
  .RgxSelect_Picker(
    {},
    rgx_header,
    {},
    dirs_nvim
    ) end )

-- search in VIM_HELP:
vim.keymap.set( 'n',
  'gsH', function()
  Telesc_launch( 'help_tags', {
    default_text = vim.fn.expand '<cword>',
    initial_mode = 'normal',
  } ) end )


function vim.getVisualSelection()
   vim.cmd('noau normal! "vy"')
   local text = vim.fn.getreg('v')
   vim.fn.setreg('v', {})
   text = string.gsub(text, "\n", "")
   if #text > 0 then
       return text
   else
       return ''
   end
end


vim.keymap.set( 'v',
  'gsh', function()
  Telesc_launch( 'help_tags', {
    default_text = vim.getVisualSelection(),
    initial_mode = 'normal',
  } ) end )



-- local file_ignore_patterns = {
--   '^.git/', '^target/', '^node%_modules/', '^.npm/', '^modules', 'dev.js', '^build/', '%[Cc]ache/', '%-cache',
--   '^scala-doc/',
--   '%.sql', '%.tags', 'tags', '%.gemtags',
-- }


-- Just the oldfiles map
-- vim.keymap.set( 'n',
--   'gp', function() require( 'telescope.builtin' )
--     .oldfiles(
--       {
--         file_ignore_patterns = file_ignore_patterns
--       }
--     ) end )








local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

local theme_opts = {
    -- theme = "cursor",
    sorting_strategy = "ascending",
    results_title = false,
    layout_strategy = "cursor",
    layout_config = { width = 0.95, height = 25 },
  }

-- vim.keymap.set( 'n', 'ger',        function() builtin.lsp_references(themes.get_cursor()) end )
vim.keymap.set( 'n', '<leader>fr', function() builtin.lsp_references(themes.get_cursor( theme_opts )) end )
-- require('telescope.builtin').lsp_references(require('telescope.themes').get_cursor())




-- ─   Lsp maps                                         ──
-- also at:
-- ~/.config/nvim/plugin/tools_scala.vim#/Lsp%20maps

-- vim.keymap.set( 'n',
--   'gD', function()
--     vim.lsp.buf.declaration()
--   end )

vim.keymap.set( 'n',
  ']d', function()
    vim.diagnostic.goto_next()
  end )

vim.keymap.set( 'n',
  '[d', function()
    vim.diagnostic.goto_prev()
  end )


-- note I'm overriding this in python.vim to use lspimport
vim.keymap.set( 'n',
  '<leader>cA', function()
    vim.lsp.buf.code_action()
  end )

-- this uses Plug 'stevanmilic/nvim-lspimport' specifically for pyright
vim.keymap.set( 'n',
  '<leader>ca', 
  require("lspimport").import 
)




  -- buf_map(bnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  -- -- buf_map(bnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- -- now in /Users/at/.config/nvim/plugin/setup-lsp.vim
  -- -- Now a buffer map in tools_rescript.vim
  -- -- buf_map(bnr, 'n', 'gek', '<cmd>lua vim.lsp.buf.hover()<CR>')
  -- buf_map(bnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- buf_map(bnr, 'n', '<space><space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- buf_map(bnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  -- buf_map(bnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  -- buf_map(bnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  -- buf_map(bnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  -- buf_map(bnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- buf_map(bnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  -- -- Now a buffer map in tools_rescript.vim
  -- -- buf_map(bnr, 'n', 'ger', '<cmd>lua vim.lsp.buf.references()<CR>')
  -- buf_map(bnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  -- buf_map(bnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  -- buf_map(bnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  -- buf_map(bnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  -- buf_map(bnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

  -- buf_map(bnr, 'n', '<space>?', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

  -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]

  -- vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  -- vim.cmd("command! LspDocSymbols lua require('telescope.builtin').lsp_document_symbols()")
  -- vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  -- vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  -- vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  -- vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  -- vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  -- vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  -- vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  -- vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  -- vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  -- vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
  -- vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")









