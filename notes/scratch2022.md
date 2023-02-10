
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
  " 1]_BOOKMARK_FILES_INTO_FOLDERS:
  <leader>lf :call LinkPathToFolder()<cr>

  " 2]_SET_SEARCH_FOLDER_PATH:
  ,,sf :call FolderSearch_setPath()<cr>

  " 3]_SEARCH_IN_FOLDER:
  ,sf :call FolderSearch_run("")<cr>
  <leader>of :call FolderSearch_run("^#")<cr>


# Vim-Works
/Users/at/Documents/Bookmarks/notes_1_2023/vim_works.md

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



