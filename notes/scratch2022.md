
# ─   Telescope Rgx search                           ──
ge;       - main (scala) symbols/bindings in this repo
ge:       - main (scala) symbols/bindings in selected (parent-based) repos
,st       - tags (NOTE:) in current project
,sT       - tags (NOTE:) in selected projects
,sc       - comments in current project
,sC       - comments in selected projects
,sh       - headings in current project
,sH       - headings in selected projects
,ss       - signatures in current project
,sS       - signatures in selected projects
,si       - signatures with collection types in selected projects
,si       - signatures with Zio types in selected projects

maps, regexes and glob definitions:
~/.config/nvim/plugin/utils_general_maps.lua#/--%20search%20in

# ─   Dirvish 'newWin' maps                          ──
==>> file in parent folder || project root folder <<==
,v         :call Dirvish_newWin( "vnew" )<cr>
,,v        :exec "vnew ."<cr>
,V         :call Dirvish_newWin( "leftabove 30vnew" )<cr>
,,V        :exec "leftabove 30vnew ."<cr>
,tn        :call Dirvish_newWin( "tabe" )<cr>
,,tn       :exec "tabe ."<cr>
,sn        :call Dirvish_newWin( "new" )<cr>
,,sn       :exec "new ."<cr>


## Nvim Tree

l no   - toggle nvim-tree open
l nf   - find current buffer in tree
b      - set base/root dir
B      - show only open paths!
<>     - sibling moves
P      - parent node

settings: ~/.config/nvim/plugin/setup-general.lua#/--%20Nvim%20Tree
maps: ~/.config/nvim/plugin/file-manage.vim#/nnoremap%20<silent>%20<leader>nf
highlights: ~/.config/nvim/colors/munsell-blue-molokai.vim#/Nvim%20Tree

TODO/Issues:
  can not have different roots in different tabs/wins

cleanup buffers:
 - telescope buffers (go) can 'm' multiselect and <c-d> to delete buffers
 - nvim tree's preview (p) doesn't keep the buffers in the list
 - or there 'leader bd' when closing a window

### Marks/bookmarks workflow
m     - mark files in the tree
]g[g  - load next/prev marked files in buffer (will ask if there a multiple wins)
        this works with zen mode only if the tree gets reloaded with leader nf
B     - in tree will filter to only the list of marked/open files



## vim DBUI
:DBUI  needs to :DBUIFindBuffer of a .sql file
`gei` evaluates paragraphs
initially the DB is empty. you first need to create data with ->
localhost:8080/docs
try -> execute to create party, then vote and find the person, vote and party in the DB!

more maps and scripts: 
/.config/nvim/plugin/tools_db.vim#/nnoremap%20<silent>%20<leader>du


## DirvishSortByModified
  <leader><leader>dm :call DirvishSortByModified()<cr>
  ,,dm :lua DirvishShowModified()<cr>
## DirvishSortBySize
  <leader><leader>ds :call DirvishSortBySize()<cr>
  ,,ds :lua DirvishShowSize()<cr>


# Link files to Bookmark folder & search
new: all notes go to Documents/Notes folder, only *hard* links go to Documents/Bookmark folders

"Collections of file links"

  "add to collection" - "collection add" => ,ca
  "point to collection" - "collection point" => ,cp
  "collection search header" => ,csh
  "collection search all" => ,csj
  "collection search signatures" => ,css (todo)

set a default/start collection here: ~/.config/nvim/plugin/general-helpers.vim#/let%20g.FolderSearch_Path%20=
.. currently its "notes_stack"

# Vim-Works
/Users/at/Documents/Bookmarks/notes_1_2023/vim_works.md

find any git-repo in Documents/!  - leader tr
search help tags - leader th

# auto completion menue
c-d/f   - to scroll the docs buffer!
c-e     - to close the menue!
~/.config/nvim/plugin/setup-lsp.lua#/mapping%20=%20{

# new git workflow
l ogs    - 'status' by showing diffs of all hunks
l ogS    - just the lines count changed per file! via git diff HEAD --stat
l ogc    - git commit message via fugitive (use ,,w to save and close/ confirm commit)
l oga    - stage all & commit message via fugitive
l ogl/L  - list of git commits (with date ago/telescope)
           maps: ~/.config/nvim/plugin/utils_general_maps.lua#/--%20Git%20picker
l l gg   - git gutter, only for unstaged changes
]c[c          - navigate hunks
l ogg    - fugitive main. use 's' to stage and 'u' to unstage. 'cc' to commit
l G/I    - nvim-tree: show ignored/git status files

can stage/unstage files in dirvish
<l><l>ga :<c-u>call Dirvish_git_add( getline('.') )<cr>
<l><l>gA :<c-u>call Dirvish_git_unstage( getline('.') )<cr>

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

### word motions
#### forward
w/W    - beginning of word/Word
e/E    - end word/Word
#### backward
b/B    - beginning of word/Word
\e    - end of word
,ge   - end of word


[op]ii  - inside indent block (linewise delete, change, yank)
[op]ai  - outer indent block (linewise delete, change, yank)

leader od  - open dirvish in float!


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


### Quick floats
sp os - scratch
sp ol - links
sp ob - vim bookmarks

gdo - go to definition in float

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

















