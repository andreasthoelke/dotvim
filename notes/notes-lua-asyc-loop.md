
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
h function-list

lua require'convert_markdown'.convertFile()

lua require'tools_external'.pandocMarkdownToHtml()
lua require'tools_external'.asyncGrep('m')
lua print( require'tools_external'.read_file('/Users/at/.config/nvim/rg-fzf-vim.sh') )

lua require'tools_external'.read_file('/Users/at/.config/nvim/rg-fzf-vim.sh')

lua put( require'utils_general'.abc() )
lua require'utils_general'
lua require'tools_external'

luafile ~/.config/nvim/lua/utils_general.lua

### Plenary reload
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

## Running / Sourcing lua testlines
" I can run the following lines with vip<space>ss
lua << EOF
local abb = 'zwei'
print('hi')
print(abb)
EOF


# Plenary features

## Read file

lua << EOF
local a = require 'plenary.async'
local te = require 'tools_external'
local path = '/Users/at/.config/nvim/notes/do-next'
a.run(function() put( te.read_file(path) ) end)
EOF

## Curl

lua << EOF
local query = { name = "Jane Doe", key = "123456" }
local te = require 'tools_external'
put( te.curlTest(query).args.name )
EOF

lua require'tools_external'.curlTestFile()


/tmp

## Timer
https://neovim.io/doc/user/lua.html\#lua-loop

Create a timer handle (implementation detail uv_timer_t).

local timer = vim.loop.new_timer()
local i = 0
-- Waits 1000ms, then repeats every 750ms until timer:close().
timer:start(1000, 750, function()
  print('timer invoked! i='..tostring(i))
  if i > 4 then
    timer:close()  -- Always close handles to avoid leaks.
  end
  i = i + 1
end)
print('sleeping');


## Popup

lua << EOF
local col = vim.fn.col(".")
local line = vim.fn.line(".")
local te = require 'tools_external'
te.popup( "Some test message [2, a, b, C]", line, col )
EOF

lua require'tools_external'.popup('test this')
lua require'tools_external'.popup1()
lua require'tools_external'.popup2()
lua put( require'tools_external'.curlTest() )

lua print( vim.fn.line('.') )
lua print( vim.fn.col('.') )

lua vim.fn.browse()

help function-list










