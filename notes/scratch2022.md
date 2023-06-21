how to find a healine in vim code?
what is filtering the tree / target folder??
# scaladex
l si
1. search for a keyword ("cats")
2. select specific lib and org
3. select sublib
4. <c-s> will open this lib in the browser
   then go to version in the browser and copy e.g. the sbt string
4. <cr> copies to the clipboard.
5. do ""P to ouput the ivy string! (it's in a weired register)
   import $ivy.`org.typelevel::cats-core:2.9.0`
   (don't know how to get the sbt string)



# open from dirvish float
I - full
U - up
A - right
X - down
Y - left
T - tab

requirements:
1. "server"
long running app
there should be a separate (permannent) visible sbt session running
there'll be an sbt:<package>run call for the server app to start
the thin server app file will not have routes as input but rather refer to services
i need to research/test a sequence of keystrokes to stop and restart the server app
so without restarting the terminal or even sbt!

2. "printer"
the same as above (with similar infrastructure, commands?) but will 
end after a value is printed

3. "test"
zio test may provide me with modular infrastructure
~testQuick incrementally build the project (in this sbt session)
i could also print in tests

## sbt printerzio repl
l ro :call ScalaReplStart()<cr>
l rq :call ScalaReplStop()<cr>

this will do 'project core'
see 8_zio_skunk_tradeIO project
works in this multi module sbt project
but i need to put the PrinterZio.scala file into the modules/core/ folder

todos:
- cats compliant
- automate the project / module selection a bit?


## TODO:

consider metals docu here:
https://github.com/keynmol/dot/blob/master/nvim/init.lua

to update sbt build
MetalsImportBuild

TODO:
word motions, `cw` should not include the ','
  ???, "eins"
  qe, "eins"
  q, "eins"

## vista tag bar outline
l ot - to open vista outline for .md files and lsp
l k  - now jumps to the marker whils the cursor is staying in the vista window

~/.config/nvim/plugin/setup-general.vim#/nnoremap%20<silent>%20<leader>k
note the buffer map in vista window didn't work.

# vim maps

NOTE: the new 'gei' = SourcePrintCommented!
to run vimscript/lua commands in .md

# ─   Telescope Rgx regex search                           ──

,sa       - all scala code
            (note this one now works with live regex! ~/.config/nvim/plugin/utils-fileselect-telescope.vim#/nnoremap%20,sa%20<cmd>Telescope
            ^enum.*\(  vs ^enum.*\[
,sA       - all scala code in selected projects
,ss(ge;)  - all scala symbols
,sS(ge:)  - all scala symbols in selected projects

,scr      - full text in active 'collection folder' use over ,csj
,sch      - header prefixed full text in active 'collection folder' use over ,csh
,csj/h    - these include searching for filenames

,svs      - search vim symbols
,svm      - search vim maps
,svv      - search vim all code

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
/Users/at/.config/nvim/plugin/utils_general_maps.lua


new telescope select maps
<c-s>b  - select below
<c-s>u  - select up
          -- TODO: might want to make these consistent with: ~/.config/nvim/plugin/utils-fileselect-telescope.lua#/["<c-s><c-u>"]%20=%20open_above,
          -- TODO: might want to make these consistent with: ~/.config/nvim/plugin/file-manage.vim#/Dirvish%20'newWin'%20maps

~/.config/nvim/plugin/utils-fileselect-telescope.vim#/nnoremap%20,sa%20<cmd>Telescope

# ─   Dirvish 'newWin' maps                          ──
==>> file in parent folder || project root folder <<==
,o         dirvish float in parent folder
,,o        dirvish float in project root folder
,v         :call Dirvish_newWin( "vnew" )<cr>
,,v        :exec "vnew ."<cr>
l, v       :"vnew " . getline('.')
,V         :call Dirvish_newWin( "leftabove 30vnew" )<cr>
,,V        :exec "leftabove 30vnew ."<cr>
,tn        :call Dirvish_newWin( "tabe" )<cr>
,,tn       :exec "tabe ."<cr>
,sn        :call Dirvish_newWin( "new" )<cr>
,,sn       :exec "new ."<cr>

window move is now e.g.:
nnoremap <leader><c-w>L <c-w>L

window resize (quick expand) horiz  = c-.
window resize (quick expand) verti  = c-.
window resize        exp     horiz  = c-w >
window resize        shrink  horiz  = c-w <
window resize        exp     verti  = c-w +
window resize        shrink  verti  = c-w -

## file view 2023-04
view a file path:
  right, below and float
c-w l v :exec "vnew " . getline('.')<cr>
c-w l s :exec "new " . getline('.')<cr>
c-w l t :exec "tabedit " . getline('.')<cr>

c-w l o :call FloatingBuffer( getline('.') )<cr>

## dovish
l to <Plug>(dovish_create_file)
l mk <Plug>(dovish_create_directory)
l dd <Plug>(dovish_delete)
l re <Plug>(dovish_rename)
l yy <Plug>(dovish_yank)
l yy <Plug>(dovish_yank)
l pp <Plug>(dovish_copy) -- need to first yank
l mv <Plug>(dovish_move) -- need to first yank

https://github.com/roginfarrer/vim-dirvish-dovish/blob/main/README.md

## Nvim Tree

    5-2023 file views
    <leader>gs <cmd>NvimTreeFindFile<cr><c-w>p
    <leader>go <cmd>NvimTreeToggle<cr><c-w>p
    ,gs <cmd>NvimTreeFindFile<cr>
    ,go <cmd>NvimTreeToggle<cr>
    <leader>gp <cmd>Telescope find_files<cr>
    ,gp        <cmd>Telescope file_browser<cr>

l go   - toggle nvim-tree open
l gs   - find current buffer in tree
l b    - set base/root dir
B      - show only open paths!
<>     - sibling moves
P      - parent node

i", action = "edit" },
p", action = "preview" },
<leader>dd", action = "trash" },
<leader>yy", action = "copy" },
<leader>re", action = "rename" },

<leader>I", action = "toggle_git_ignored" },
<leader>G", action = "toggle_git_clean" },

    *nvim-tree.filters.git_clean*
    Do not show files with no git status. This will show ignored files when
    |nvim-tree.git.ignore| is set, as they are effectively dirty.
    Toggle via the `toggle_git_clean` action, default mapping `C`.
      Type: `boolean`, Default: `false`


<leader>/", action = "search_node" }, -- can use regex and expand child folders!
<leader>rf", action = "run_file_command" }, -- vim shell with the abs file path
<leader>so", action = "system_open" }, -- opens finder explorer

<leader>re", action = "rename" },
<leader>pp", action = "paste_file", action_cb = tree_api.fs.paste },
<leader>pP", action = "paste_cut_file", action_cb = tree_api.fs.paste },

<leader>o", action = "dirvish_folder", action_cb = tree_openFolderDirvish },
<leader>i", action = "dirvish_folder", action_cb = tree_viewPathInPrevWin },
<leader>b", action = "base_dir", action_cb = tree_setBaseDir },
T", action = "open_tab_silent", action_cb = open_tab_silent },


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



## vim tools_db / DBUI
now prefer using psql within tools_db.vim
1. set postgres db name using 'l ss'
let g:dbname = 'zio_skunk_tradeIO'
2. use gej in .sql file paragraph

/Users/at/.config/nvim/plugin/tools_db.vim|94

for DBUI:
ll du   - toggle open the DBUI panel
ll df   - to link a .sql buffer to a database connection
A       - in panel to create a new connection (using a connection string like:
          postgresql://at:at@localhost:5432/zio_skunk_tradeIO
ll d}   - eval a motion. ll dib /ip should also work? 
:DBRun  - for file or visSel

:DBUI  needs to :DBUIFindBuffer of a .sql file
`gei` evaluates paragraphs

more maps and scripts: 
/.config/nvim/plugin/tools_db.vim#/nnoremap%20<silent>%20<leader>du


## info & sort in Dirvish / SortBy Modified and size
  <leader><leader>im :call DirvishSortByModified()<cr>
  ,,im :lua DirvishShowModified()<cr>
## DirvishSortBySize lines count
  <leader><leader>is :call DirvishSortBySize()<cr>
  ,,is :lua DirvishShowSize()<cr>


# Link files to Bookmark folder & search
new: all notes go to Documents/Notes folder, only *hard* links go to Documents/Bookmark folders

"Collections of file links"

  "add to collection" - "collection add" => ,ca
  "point to collection" - "collection point" => ,cp or ,ce
  "collection search header" => ,csh
  "collection search all" => ,csj
  "collection search signatures" => ,css (todo)

  "show notes folder sorted by last modified" => ,cm

set a default/start collection here: ~/.config/nvim/plugin/general-helpers.vim#/let%20g.FolderSearch_Path%20=
.. currently its "notes_stack"

## new collection regex search 30.05.2023
    simple full live regex:
,scr <cmd>Telescope live_grep search_dirs=/Users/at/Documents/Notes<cr>

    searches in current collection folder! with a regex (for header) default text
,sch <cmd>lua require('utils_general').Search_collection_md_headers()<cr>

~/.config/nvim/lua/utils_general.lua#/function%20M.Search_collection_md_headers..

CONCLUSION:
use ,scr over ,csj
use ,sch over ,csh


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

## git removing files
git rm -r --cached .bloop/
git rm -r --cached .metals/


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
(,ge   - end of word) .. shadowed


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

,cm  - show Notes folder sorted by date modified
       use dirvish map to open a file, (t, s, ?)


<leader>oh :call FloatingBuffer( '~/.config/nvim/help.md' )<cr>
<leader>oH :tabe ~/.config/nvim/help.md<cr>

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

## vim bookmarks

L bb BookmarkToggle
L ba BookmarkAnnotate
L bs BookmarkShowAll
L bn BookmarkNext
L bp BookmarkPrev
L bc BookmarkClear
LLbd BookmarkClear
L bk BookmarkMoveUp
L bj BookmarkMoveDown

'i', '<C-x>', delete_selected_or_at_cursor
'n', 'dd', delete_selected_or_at_cursor

## Chrome Bookmark search
l fb
~/.config/nvim/plugin/utils-fileselect-telescope.vim#/nnoremap%20<leader>fb%20<cmd>lua
Telescope bookmarks initial_mode=normal default_text=Scala/Ref-Projs/

could also search (and edit!?) the (json) file:
/Users/at/Library/Application Support/Google/Chrome/Default/Bookmarks


# Scala references with Trouble (lsp based)
ged  - show workspace errors
ge]/[ - next/prev error
ger   - show references of symbol under cursor
]q [q - next/prev reference in workspace

# lsp 
l lgr :Glance references<cr>
l lgd :Glance definitions<cr>
l lgt :Glance type_definitions<cr>
l lgi :Glance implementations<cr>
https://github.com/DNLHC/glance.nvim/blob/master/README.md

## git fetch an update from the remote repo
https://github.com/git-guides/git-pull
git remote update
git status -uno
git pull
git config pull.rebase false
git pull

# Java JDK JVM version management
see
j/Documents/Bookmarks/notes_tools/vim_works.md#/##%20Managing%20the
~/Documents/Bookmarks/notes_tools/vim_works.md#/CONSLUSION.

## monitor / watch / tail a file
leader fw / W
  Keeps reloading the current window/buffer with the current filepath!
function M.WatchFile_start()


## Http requests curl
 gsf :call Scala_ServerClientRequest('', 'float')<cr>
,gsf :call Scala_ServerClientRequest( 'POST', 'float' )<cr>
 gsF :call Scala_ServerClientRequest('', 'term')<cr>
,gsF :call Scala_ServerClientRequest( 'POST', 'term' )<cr>

## Http requests httpie
use 'gej' for simple GET requests
use ',gej' for POST requests
http -v get localhost:8080/cities/127/weather
http -v post localhost:8080/cities city=London country=UK
http post localhost:8080/cities city=London country=UK

### httpie shortform requests!
  use 'gsf' for get requests
cities/127/weather
  use ',gsf' for post requests!
cities city=London country=UK
cities city=London country=UK -v
  note how the --verbose option can still be passed!
  also ',gsF' or 'gsF' runs in an term for e.g. streaming responses

let g:httpport = 8080
func! Scala_ServerClientRequest( args, mode )
- json formats, uses TSSyntaxadditions


## test an httpApp / routes in http4s ember server
gss :call Scala_SetServerApp_ScalaCLI()<cr>
gsr :call Scala_ServerRestart()<cr>
,,gsr :call Scala_ServerRestartTerm()<cr>
gsS :call Scala_ServerStop()<cr>


## thin fonts 
~/Documents/Notes/vim_works.md#/#%20alacritty%20fork

ok, i have now decided to use
=> thin & pale fonts in alacritty 0.12.0 rc2
    using this terminal command: 
    defaults write org.alacritty AppleFontSmoothing -int 0
instead of
- thicker, blorred and bright/fresh colored fonts in alacritty 0.10.0

# search websites (Google, Github, Scaladex?)
l gso/O    - on visSel or cword or input() works well for Gitub repos, code, Google, etc?
~/.config/nvim/plugin/HsAPI-searchSites.vim#/Search%20Params

## github search
i made some scripts
general pattern:
https://github.com/search?q=user%3Araquo+duplicate+ids&type=issues

## vim substitute replace text
\r<motion>   - replaces last pattern (set with visual select //)   ~/.config/nvim/plugin/search-replace.vim#/func.%20ReplaceLastPattern.%20motionType,
.+1,127substitute/\.scala//g


## PrinterZio.scala in sbt
10.6.2023
create printer/PrinterZio.scala
put into sbt and adjust dependencies:
    lazy val printer =
      project
        .in(file("printer"))
        .settings(Seq(
          libraryDependencies ++= zioLibs
         ))
        .dependsOn(arango, http, docker, velocypack)

~/.config/nvim/plugin/tools_scala.vim#/let%20printerFilePath%20=

/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio2/PrinterZio.scala
this works though its attempting to "project core" to
support muli projects like in the tradeIO project:
/Users/at/Documents/Proj/_repos/8_zio_skunk_tradeIO/modules/core/PrinterZio.scala|2

only rough support in these two files:
~/.config/nvim/plugin/tools_scala.vim#/let%20printerFilePath%20=
~/.config/nvim/plugin/repl_scala.vim#/TODO.%20this%20throws

# syntax treesitter semantic hightlights inspect
" use :Inspect 
nnoremap ll ti :Inspect<CR>
nnoremap ll tI :Inspect!<CR>
" NOTE there's also ll ts/S for treesitter syntax inspect

ll bn :echo GetSyntaxIDAtCursor()<cr>

## 






