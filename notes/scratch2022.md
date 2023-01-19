
# Printer.scala todo:
ideally non zio values would not be printed with zio
as the error messages might look cleaner.

~/.config/nvim/plugin/tools_scala.vim#/echoe%20"currently%20not
also Printer should be a scala 2.13 syntax?!
~/Documents/Server-Dev/effect-ts_zio/a_scala3/DDaSci/Printer.scala#/object%20Print%20{


## topics crawler
/Users/at/.vim/scratch/853


# list/search headings or full text
with grep-rgx
- in current .md file
- in all past/history files
- in a list of fixed files

# bookmark the set of files to search
- i could `ln` them into a central 'to search' folder(s)
- recent files could show a column indicating
  and under which marker key e.g. `a` they are bookmarked

## other usecases
list, browse, search
### headers in ..
- current file!
- recent files (sorted)
- bookmarked files

# side navigator
would show a custom view list with
- main nav types (header, defs, case class)
- icon based on type
- colum for type-sig or documentation?
- past and bookmarked files ranked lower


from some repo have 2 new regex searches/maps in vim folder:
- for functions and commands vim/lua (only in vim folders)
- for nnoremap and keymap only in vim folders
leader vm  - regex approach
leader leader vm - telescope vim.keymaps approach (filenames maybe in the title)
leader vM  - fzf approach that sometimes shows the file name/linenum


# Git_commits_picker
- mapping
- test with empty string
- could it show the time ago?

this now uses a custom `previewer` filed in opts.
which is a list of two previewers? or do the function calls 'spred' new table fields?

## checkout file
- test checkout of entire commit
- checkout only that file (but then how to proceed?)
- checkout that one file out under a different name:
  -> there's now git_log
  -> this can also be done manually like this:
  git show 97853e3:z_patterns.scala > z_patterns_ab.scala

- put windows of different file versions side by side and use
    :set scrollbind
    :set noscrollbind




# verb map
needs to parse/get filename and line from the output.
find the builtin code

# gs maps
ergonomic and scalable?






find any git-repo in Documents/!  - leader tr
search help tags - leader th

# auto completion menue
c-d/f   - to scroll the docs buffer!
c-e     - to close the menue!
~/.config/nvim/plugin/setup-lsp.lua#/mapping%20=%20{

# new git workflow
leader ogs    - lines changed per file! via git diff HEAD --stat
leader ogd    - git status with delta diffs <tab> to stage/unstage
leader ogc    - git commit message via fugitive (use ,,w to save and close/ confirm commit)
leader oga    - stage all & commit message via fugitive
leader ogl/L  - list of git commits (with date ago/telescope)

- checkout older version of file out under a different name
- put windows of different file versions side by side and use
:set scrollbind
:set noscrollbind

### Telescope git_bcommits
This is a convienient alternative approach to see a diff via VimDiff in 
two vim buffers side by side:
Telescope git_bcommits    - Run this in the file/buffer you want to compare
                          - find the commit/version you want to compare compare compare to
                          - use <c-t> to open a new tab with two VimDiff buffers!
                          - use :q on the 'Original' buffer to close the tab!


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

\w   - easymotion wordmotion
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

# scala metals
feature list: https://github.com/scalameta/nvim-metals/discussions/279

### Quick floats
sp os - scratch
sp ol - links
sp ob - vim bookmarks

gdo - go to definition in float

npx edgedb-js
save in other folder
connect to dracula and instance?

### scala git process
TODO:
set up a lua map for Git_init_repo()
git init
touch .gitignore
echo .metals/ >> .gitignore
echo .bloop/ >> .gitignore
echo .bsp/ >> .gitignore
echo .scala-build/ >> .gitignore
git add *
(check with leader oG)
git commit -m 'initial commit'
git status






