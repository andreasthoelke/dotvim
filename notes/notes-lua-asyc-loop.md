
# Lua async and vim.loop

call v:lua.print( vim.fn.expand('%:t:r') )

lua put( vim.fn.expand('%:t:r') )

lua = vim.log
lua put( vim.log )

runtime utils_general.lua

call v:lua.print('hi there')

echo v:lua.string.rep('A', 10)

set statusline=%!v:lua.stline()


let g:vimsyn_embed = 'l'

lua print('hi there')

echo v:lua.print("test")
echo v:lua.print('eins zwei')

lua print(vim.api.nvim_eval( "[1, 2, 3]" ))

So this has created a lua table (in list form)
lua put(vim.api.nvim_eval( "[1, 2, 3]" ))

local result = vim.api.nvim_exec(
[[
let s:mytext = 'hello world'

function! s:MyFunction(text)
    echo a:text
endfunction

call s:MyFunction(s:mytext)
]],
true)

print(result) -- 'hello world'

https://neovim.io/doc/user/usr_41.html\#function-list


lua require'convert_markdown'.convertFile()

lua require'tools_external'.pandocMarkdownToHtml()
lua require'tools_external'.asyncGrep('m')
lua print( require'tools_external'.read_file('/Users/at/.config/nvim/rg-fzf-vim.sh') )

lua require'tools_external'.read_file('/Users/at/.config/nvim/rg-fzf-vim.sh')

lua put( require'utils_general'.abc() )
lua require'utils_general'
lua require'tools_external'

luafile ~/.config/nvim/lua/utils_general.lua

lua require'plenary.reload'.reload_module('tools_external')
lua require'plenary.reload'.reload_module('utils_general')

command! -nargs=+ -complete=dir -bar Grep lua require'tools'.asyncGrep(<q-args>)
command! -nargs=+ Rld lua require'plenary'.reload.reload_module(<q-args>)
Rld utils_general
Rld tools_external

lua print( vim.fn.expand( '%:h:r' ) )

lua put( package.loaded['tools_external'] )
lua put( package.loaded['utils_general'] )

ReloadModule expand('%:t:r')
echo expand('%:t:r')
https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/


## Global variables
let g:sometestvar = 'abc'
echo g:sometestvar

lua put( vim.g.sometestvar )
lua print( vim.g.sometestvar )
lua print( vim.g['sometestvar'] )

### Set shell environment vars
lua print( vim.env.FZF_DEFAULT_OPTS )
lua vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'

### calling functions
lua vim.fn['fzf#vim#files']('~/Documents', false)
lua vim.call('fzf#vim#files', '~/Documents', false)

### Plug example

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'wellle/targets.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

vim.call('plug#end')

### Maps
vim.api.nvim_set_keymap(
  'n',
  '<Leader>w',
  "<cmd>lua require('usermod').somefunction()<CR>",
  {noremap = true}
)











