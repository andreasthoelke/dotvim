
find any git-repo in Documents/!  - leader tr
search help tags - leader th

*  - previous line start
c-o - any non-reversible jump should use "normal! m'" to add to the jump list

## end of block motion
J  - when at the beginning of the block, can just use the indent level motions
leader)  - this jumps to the end of the block from any place inside the block. (reversible via c-o)

[op]ii  - inside indent block (linewise delete, change, yank)
[op]ai  - outer indent block (linewise delete, change, yank)

leader od  - open dirvish in float!

,,sr  - search in repo (previously leader gsr)
,,sr :call SearchRepo( GetInputStr('Search in repo: ') )<cr>
,,sR :call SearchRepo( "─.*" . GetInputStr('Search in repo: ') )<cr>
,,<leader>sr :call SearchRepo( "\/\/.*" . GetInputStr('Search in repo: ') )<cr>
also:
leader fg - and then can use regex like //.*List to search in comments

# Scala references with Trouble
ged  - show workspace errors
ge]/[ - next/prev error
ger   - show references of symbol under cursor
]q [q - next/prev reference in workspace

# Scala Printer

## SBT support
1. needs this printer file as Main
    fpcourse/
    src/main/scala/Main.scala

`gew` `gee` this then namspace imports the indentif into Main/Printer

2. start the sbt terminal with `space ro`

`gei` does `runMain Printer`

interactive programms can be seen in the running terminal

## Scala-cli support

1. needs this printer file as Printer.scala
     /Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/scala-cli-zio1/Printer.scala
   in the same folder as the source file
     /Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/scala-cli-zio1/a_effects.scala

`gew` `gee` again just imports the identif into the Printer.scala

`gei` does `scala-cli .`
`space gei` does `scala-cli .` in a new/temp terminal


## Telescope useful maps

<leader>tt <cmd>lua require('telescope.builtin').resume()<cr>
leader>ts Telescope sessions<cr>
> finding a git repo on disk!
leader>tr Telescope repo list layout_strategy=vertical<cr>
leader>tp Telescope project<cr>
leader>ff Telescope find_files<cr>
leader>fo Telescope oldfiles<cr>
leader>fg Telescope live_grep<cr>
leader>fb Telescope buffers<cr>
leader>fh Telescope help_tags<cr>

treesitter syntax
nnoremap <leader><leader>ts <cmd>Telescope highlights<cr>
nnoremap <leader><leader>tS <cmd>TSHighlightCapturesUnderCursor<cr>


### Telescope project maps
d	delete currently selected project
r	rename currently selected project
c	create a project*
s	search inside files within your project
b	browse inside files within your project
w	change to the selected project's directory without opening it
R	find a recently opened file within your project
f	find a file within your project (same as <CR>)
Default mappings (insert mode):
Key	Description
<c-d>	delete currently selected project
<c-v>	rename currently selected project
<c-a>	create a project*
<c-s>	search inside files within your project
<c-b>	browse inside files within your project
<c-l>	change to the selected project's directory without opening it
<c-r>	find a recently opened file within your project
<c-f>	find a file within your project (same as <CR>)

~/.config/nvim/help.md#/###%20telescope%20project

### Gist
Telescopt gh gist

# Scratch
git add *
degit https://github.com/hayes/pothos

type Tags
are just arrays on Posts .. not connections

use the Comment implement (not the node) version
the add a custom Node type to the interface [Node]

i might make manually unique string ids in data.ts.

# Vim explore
h Floaterm
https://github.com/voldikss/vim-floaterm
leader te h<tab>   - Telescope heading
leader te gl<tab>  - Telescope glyph
leader te sp - spell_suggest (on a word to replace)



## Vim to learn

nnoremap <leader>oh :call FloatingBuffer( '~/.config/nvim/help.md' )<cr>
nnoremap <leader>oH :tabe ~/.config/nvim/help.md<cr>


)  - MvNextLineStart
(  - this line (useful!) start

ctrl g  - echo filepath and scroll position (in zen mode)
space ]t  - bracket end forward
leader leader ]t   - BufferInnerBracket()
space os - open scratch file in float
space ob - search for bookmarks

new js/ts 'yank around {} block' map: y<leader>ab

space s; - strip semicolon .. and the af/ap/,j

gsw - sets a test-printer expression in /scratch/.testPrinter.ts
gsp - prints/call this (exported) identifier (cursor can be in a different place)

sp qa - add cursor pos to quickfix list
leader qq - toggle quickfix list

## regex vim pattern
[A-Z]{4}:  - find comment tags like: // NOTE:  , TODO:

rust regex docs:
https://docs.rs/regex/1.7.0/regex/#syntax

### Lsp
sp ca - code action
gti   - import identifier under cursor
~/.config/nvim/plugin/setup-lsp.lua#/buf_map.bufnr,%20"n",%20"gts",
https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils

TODO:
Telescope dynamic_workspace_symols
this currently only works within the .metals project folder!?

### Quick floats
sp os - scratch
sp ol - links
sp ob - vim bookmarks

gdo - go to definition in float

npx edgedb-js
save in other folder
connect to dracula and instance?







