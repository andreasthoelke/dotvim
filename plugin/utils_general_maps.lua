

local opts_1 = { initial_mode = 'normal' }
local opts_2 = {
  sorting_strategy = 'ascending',
  -- default_text = [[(Seq|List)]],
}

local dir_a_scala3 = '/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/'
local dir_nvim = [[/Users/at/.config/nvim/plugin]]

local rgx_caps_tag = [[\s[A-Z]{3,}:]]
local rgx_comment = [[^(\s*)?(//|\*\s)]]
local rgx_main_symbol = [[(def\s|case\sclass|val\s[^e])]]
local rgx_main_symbol_vim = [[^(func!\s|function|command!)]]
-- local rgx_keymap_vimlua = [[keymap.*\n.*\n]]
local rgx_keymap_vim = [[(^\w(noremap\s|map\s)|keymap.*\n.*\n)]]
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


-- search in MAIN_SYMBOLS:
vim.keymap.set( 'n',
  'ge;', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_main_symbol,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  'ge:', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_main_symbol,
    glb_projs1,
    {'..'}
    ) end )

-- search in comment TAGS:
vim.keymap.set( 'n',
  ',st', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_caps_tag,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sT', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_caps_tag,
    glb_projs1,
    {'..'}
    ) end )

-- search in COMMENTS:
vim.keymap.set( 'n',
  ',sc', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_comment,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sC', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_comment,
    glb_projs1,
    {'..'}
    ) end )

-- search in HEADERS:
vim.keymap.set( 'n',
  ',sh', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_header,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sH', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_header,
    glb_projs1,
    {'..'}
    ) end )

-- search in SIGNATURES:
vim.keymap.set( 'n',
  ',ss', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_signature,
    {},
    {'.'}
    ) end )

vim.keymap.set( 'n',
  ',sS', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_signature,
    glb_patterns1,
    {'..'}
    ) end )

vim.keymap.set( 'n',
  ',si', function() require( 'utils_general' )
  .RgxSelect_Picker( {},
    rgx_signature .. '.*' .. rgx_collection,
    glb_projs1,
    {'..'}
    ) end )

vim.keymap.set( 'n',
  ',sz', function() require( 'utils_general' )
  .RgxSelect_Picker( opts_2,
    rgx_signature .. '.*?' .. [[ZIO]],
    glb_projs1,
    {'..'}
    ) end )

vim.keymap.set( 'n',
  '<leader>ogL', function() require( 'utils_general' )
  .Git_commits_picker( opts_1, vim.fn.expand('%') )
  end )

vim.keymap.set( 'n',
  '<leader><leader>ogL', function() require( 'utils_general' )
  .Git_commits_picker( opts_1 )
  end )


vim.keymap.set( 'n',
  '<leader>ogd', function() require( 'utils_general' )
  .Git_status_picker( opts_1 )
  end )


-- search in VIM_MAIN_SYMBOLS:
vim.keymap.set( 'n',
  '<leader>ge;', function() require( 'utils_general' )
  .RgxSelect_Picker(
    {},
    rgx_main_symbol_vim,
    {},
    { dir_nvim }
    ) end )


-- search in VIM_KEYMAPS:
vim.keymap.set( 'n',
  '<leader>vm', function() require( 'utils_general' )
  .RgxSelect_Picker(
    {},
    rgx_keymap_vim,
    {},
    { dir_nvim }
    ) end )









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












