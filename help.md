
## help
More help/comments: ~/.vim/notes/notes-navigation.md#/#%20Navigate%20Containers
~/.vim/notes/releases.md#/##%20Release%20notes

## Homebrew
brew list
brew list | grep python
brew info python
brew ls
brew ls -t -l
brew ls ffmpeg
brew ls gh
brew ls --casks
brew ls --formulae --versions

brew install --HEAD luajit
brew install --HEAD neovim
to update: brew reinstall neovim


## Node
npm list -g
npm list -g --depth 0
sudo npm uninstall -g moment

## Git control of Config files
 ~/.vim/plugin/file-manage.vim#/Use.%20BLines,%20Lines.?.,
To use fzf in Vim, add the following line to your .vimrc:
  set rtp+=/opt/homebrew/opt/fzf

https://alexpearce.me/2016/02/managing-dotfiles-with-stow/

Old attemps bak:
Now using vcsh at ~/.config/vcsh/repo.d/vim.git/ to git-version control config files
Alternative: :! config  - to interact with git version control of dotfiles in ~/.cfg see: /Users/at/.zshrc#/#%20using%20'config'
Run git commands, e.g.:
vcsh vim config --local status.showUntrackedFiles no
vcsh vim status

## do-next
vs code command line options - jump to cursor lock in vscode and back to nvim
manage /Library/Application Support/ in source control?

## Fuzzy file selection
vim \**<TAB>       - Files under the current directory - You can select multiple items with TAB key
vim ../fzf**<TAB>  - Files under parent directory that match `fzf`
cd \**<TAB>        - Directories under current directory (single-selection)

'      - exact matches
.sh$   - match at the end of the string
!vim   - negate matching

Examples integrating with e.g. Chrome, NPM, etc https://github.com/junegunn/fzf/wiki/examples
More technical usecases https://github.com/junegunn/fzf/blob/master/README.md#advanced-topics


#### Unix pipe examples
echo 'one two three' | xargs mkdir
find . -name '*.txt' | xargs rm
fzf | xargs ls -l
nvim -l `fzf`                                                                                           main
cd **   or cd ../**
kill -9   .. then <c-i> .. e.g. 'textEdit'<cr> .. to end the app
find * -type f | fzf -m > selected

c-t     - use ctrl-t in terminal at an argument position in say 'cp myfile.txt <c-t>..' to fill in a path.

### 'fzf.vim'
Has simple commands that open in a split. see
help fzf-vim
Commands: Files, BLines, Lines(?), GFiles?, BCommits, Maps, Helptags ~/.vim/plugged/fzf.vim/doc/fzf-vim.txt#/Command%20|%20List
GFiles? - all changed files

### Multi-files lines search (grep & co)
Step1: Full text search using Rg (ripgrep) and Ag (silversearcher), Step 2: Preview & filter found lines with fzf.
FzfAg marks
FzfRg marks
vim /v\^gs.*web **
Ag divish /Users/at/.vim/**
Ag divish %**
FzfRg dirvish **
FzfAg dirvish **
FzfAg marks **
FzfAg marks 
FzfAg marks %**
GGrep marks **
!mv 'vimrc' vimrc.vim
FzfAg dirvish
FzfFiletypes
FzfFiles
FzfFiles!
FzfHelptags bang


### Seach syntax
sbtrkt	fuzzy-match
'wild	exact-match (quoted)             - use the --exact flag to invert the meaning of '!
^music	prefix-exact-match
.mp3$	suffix-exact-match
!fire	inverse-exact-match
!^music	inverse-prefix-exact-match
!.mp3$	inverse-suffix-exact-match
^core go$ | rb$ | py$     - start with core and end with either go, rb, or py.



### 'fzf preview'
Uses the floating-window. See
help fzf-preview-vim
CocCommand fzf-preview.ProjectFiles
CocCommand fzf-preview.GitStatus
CocCommand fzf-preview.GitActions
  CocCommand fzf-preview.VistaCtags
  CocCommand fzf-preview.CocReferences
CocCommand fzf-preview.Marks

### Preview a file in terminal/shell with cat -> bat
Note you can scroll and search like in vim.


## Markdown
help vim-markdown-folding
plugin config: ~/.vim/plugin/tools-markdown.vim#/let%20g.vim_markdown_follow_anchor%20=


## Video
see notes/video.md


## MySQL, H2
~/Documents/DBs/Projects1/mysqltest1/steps.md

## Android Studio / Kotlin
Path to Android Studio config files:
~ Library / ApplicationSupport / Google / AndroidStudioPreview2020.3  git add colors/Munsell-blue\ Kotlin.icls -f                                        master


## Language client
[g / ]g     - prev/next error/warning
ged         - show diagnostic message in float-win (Lang client)
gsi         - coc diagnostic - the same as above?
\gd ,gd/D   - go to definition in floating/split
lead lg/lG  - go to definition/ in split
lead lb     - show references of current symbol
lead ls/S Ls - list symbols
leader lk   - Symbol documentation
leader hK   - coc showDocumentation
leader la   - Code action → import symbol!
    all options:  ~/.vim/plugin/tools-langClientHIE-completion.vim#/nnoremap%20<leader>lm%20.call
insert c-i  - show completions with type sig!
insert c-p /n/p - open drop down list
insert c-xu - this shows language client type sigs!!
leader ld   - CocList diagnostics
gsd/D       - language client fuzzy search - with sources link
gsb/B       - browse module via :browse in psci. use 2leader ht, leader t[,c-l | ip | J] and leader as [ip | ect]
:set ft=text, leader sp - deactivate diagnostic in a buffer

### Types of bindings in scope
gw          - Coc hover type
get         - get types of in scope/context bindings at cursor position
geT         - get type of identifier under cursor in do-bind. also gst, gsT
~/.vim/plugin/tools-langClientHIE-completion.vim#/Get%20types%20and

### Coc
CocConfig
CocList symbols  - allows to fuzzy-search and jump to all loaded symbols!
CocList commands
CocList sources  - how to prioritise completion sources!
CocList <c-i> - to see all useful! options
CocList extensions
extensions are installed here: ~/.config/coc/extensions/node_modules/
note ~/.config/coc/

CocList marketplace  - search and install extensions. or use:
CocInstall coc-jedi  - install an extension
all extensions: https://www.npmjs.com/search?q=keywords%3Acoc.nvim
                https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions


## Fonts
Custom fonts
 https://www.nerdfonts.com/font-downloads

## Purs repl / Ghci/ Intero
leader io/l/k/h - intero open/load/kill/hide
leader il   - load just the current module
dr          - reload ghci
leader ic   - InteroCancelRunningProcessInGhci
gw, gW      - show instantiated type at/vis-sel / generic type
              guardP :: Alternative f => (a -> Bool) -> a        -> f a
              -> instantiated     ((a, [a]) -> Bool) -> (a, [a]) -> Maybe (a, [a])
              ~/Documents/Haskell/6/HsTrainingTypeClasses1/src/Patterns.hs#/utakeWhile%20p%20=
  not active:
  get         - show type of symbol or vis sel (also works when module not compiles)
,gw         - insert type above
gek         - kind at symbol or vis sel
gei         - run symbol
gei vis-sel - run expression!
gel }/iI/ip - run multiple lines, e.g. imports
      currently off
      gel/c/C     - show list of strings as lines
                    'gel' needs a list of strings, e.g. 'fmap (fmap show) $'
ger         - Curl send sting in line to localhost, show response
get/T       - type hole. at cursor/ in do block (Todo: should not affect undo)
leader cv   - VirtualtextClear
gen/N       - runs an top-level val/function with no args in NodeJS.


## Hs API Explore
gsd/D       - to edit vis-sel and search for it
gsk         - to insert info into buffer - using the module name (cursor on module shows module info!)
gsK         - show info in float-win
gsb/B       - browse module
leader t<motion> - tabularise type
  off? ,atip/iB    - to HsTabu Type-sig align a range: Use l, \j or 'v' visual-sel
2leader sm  - SplitModulesInLines
2leader jm  - JoinModulesFromLines
2leader ht  - HsTabu
2leader hT  - StripAligningSpaces
2leader sa  - StripAligningSpaces
2leader sw  - StripWhitespace
2leader hu  - HsUnicode
2leader hU  - HsUnUnicode

## Imports
### Haskell
leader Hii/I - (in HsAPI) import identifier
leader lHi  - import identifier via LClient
leader hfi  - format imports
### Purescript
leader hii/I - (in HsAPI) import identifier
leader lhi  - import identifier via LClient
leader hfi  - format imports

TODO make Stubs and Markup maps consistent
## Stubs
leader eu/U - anonymous binding /+ signature
leader es   - add signature type stub
leader eb   - add function to type-sig/ expand signature
leader eif  - add an index/num to the signature-symbol name
leader et   - create inline test stub
leader ea   - create assertion

## Code Markup
Note this does not work properly in .vim files! .. just tested it here and it worked: ~/.vim/plugin/search-replace.vim#/Operator%20And%20Movement
leader ehs  - heading
leader ehe  - close section (does not include the header text in the end?)
leader ehr  - refresh heading/section (currently on this updates the end text)
leader ehd  - delete/strip heading/section

### Motions & text-objects
q/Q         - Label/ Heading motion
ihc         - 'inside heading content' text object

## Search & Docs


gsR/r       - Grep search in the current repo! cursor-word editable.
              use { and } to navigate found contexts. 'o' to open an item in the left split. <cr> to close
Fhask, Frepo - search local haskell code exampes: /6/HsTraining1/** 6/HsTrainingBook2/** 
            - use single quotes for :Frepo 'multiple words'
}{          - jump files on search results
Fdeleted    - deleted code in repo
Lines, GFiles?, BCommits, Maps, Helptags
gso, gsO    - to search on websites e.g. pursuit.org
gsI         - (deprecated) :GithubSearch of word or visSel
gsi         - show coc diagnostic info of cursor position (cursor needs to be on the error or info)
gsd         - hoogle search word under cursor or vis-sel
gsD <c-f>   - hoogle edit vis-sel or wuc: gsD then <c-f> .. <c-c><cr> (?)
gsh         - search hoogle.org
gse         - explore definition (haskell-code-explorer.com)

### Search in project folder
Go to search root folder in Dirvish then
:Ag searchterm %**
<c-n/p> to navigate results quickfixlist

### Search in select files with vimgrep
vim dirvish **      -- seach for 'dirvish' in all files. then use :cw/copen and ]q[q
collect the files and folder in the arglist  ~/.vim/help.md#/###%20Arglist


## Karabiner Key maps
c-'         - Next Mac app. See definition here: ~/.config/karabiner/karabiner.json#/"description".%20"Left%20Control

Older config (with tab remap?) /Users/at/.config/karabiner/karabiner.json.bak


## Window, Buffer Navigation
c-w n/N     - SymbolNext SplitTop
c-w i       - jump into float-win
leader wp[ap/af] - pin a function/paragraph (or imports) to the top
c-w dk      - close the window above
c-w \       - to jump to rightmost/mark/tag bar window
c-w p       - to jump back
\t]         - TabmoveRight /Left (this works with . repeat command!)
leader wi/I - Pin [and jump to cword] Haskell imports
c-w I       - resize/fit floatwin height width
c-w x/S h/l/k/j - Swap with / Shift a window with the other adjacent window
  1<c-w>x     - swap window with the one above/at top of screen (2 is below)

### Buffers
go    - bufferlist: ~/.vim/plugin/file-manage.vim#/New%20file%20openers.
  c-j/k, c-x - close a buffer in the ctrlP buffer list without opening it
  c-ov/h to open offer in split
\^ <c-^>     - to load the alternate (past) file or \e3 <c-^>

:BufferDeleteInactive or :Bdi   - to wipe out all buffers not open in a window!

### Window scrolling
c-e/y       - up/down
zt/b        - bottom/top

## Files
\v \T       - browse-open file in new split/tab from the same project
:e %mynewfile - this creates a new buffer in the current Dirvish folder!
gp <c-o>v   - browse-open recent file in a split e.g. from a different project
~/.vim/plugin/file-manage.vim#/New%20file%20openers.

## Dirvish
a           - open file in right split, then use ]f [f to go back forth the files in the dir!
x           - add some files to the arglist that you want to work with. then open the first file (with a or i), then use
]a [a [A ]A - to go through the marked files (instead of opening tabs for all files)
2\.         - to go to Shdo! prompt
.           - on a file, then 'rm' or 'mv %..' to delete, more file.

t           - open in new tab
leader of   - open file under cursor in float-win. curson is in float win so you can scroll right away.
P           - preview in float-win
p           - preview in (currently open?) split. only good if there is no other open split?
:e %mynewfile - this creates a new buffer in the current Dirvish folder!
g?          - show help
K           - file info/ dir size/ last write
leader df   - delete file with relative path
vis-sel .   - doesn't insert the full path: https://github.com/justinmk/vim-dirvish/issues/188
:!touch %newFile  .. :!mkdir %newfolder
g;          - to get :!  in the vim command panel.
T           - expands a the folder under the cursor.
:vs ~/Doc.. - then use <c-i> to expand path
I           - edit divish buffer to execute shell commands with path
y$          - copy file name - note the cursor is at a specific pos in the *concealed* file path!
0y$         - yank abs file path! - note the cursor is now at the start of the (concealed) line

### Tricks
:cd %      - set working dir to the current dirvish folder
:%!ls       - to replace the text is the current buffer with 
:'<,>call delete(getline('.'))

Dirvish settings and custom maps: ~/.vim/plugin/file-manage.vim#/augroup%20dirvish_config

" TODO Currently trying out: set the a local current dir (lcd) for the Shdo buffer ~/.vim/plugged/vim-dirvish/autoload/dirvish.vim#/execute%20'silent%20split'

### Ranger-like setup
"Win navigate right to left and use 'p'"
\T          - new tab, go to a 'root' folder
c-w v c-w = - make 3 columns
c-w |       - go to the next 'last window', then c-w h/l, then 'p' to fill the previous win with the content of the node
TODO some simple maps/commands for 'p' could achieve a basic ranger functionality!?

## Using file-paths
c-i      - autocompeting filepaths only works at the beginning of the line. c-i is prefered as it allows fuzzy-filtering the suggested filenames. BTW the autocomplete menu shows the [F] at the end of the item.
c-x c-f  - works only on paths without space. but now testing :set isfname+=32 .
c-w c-f  - to open this path in dirvish. note this does not work with the "% 20" formatting of the whitespace in the second line
           vis-sel of the path text will also make the 3rd line (with the plain whitepace) work!
gk       - (rel-link) to open the second path in vertical divish. Note this *only* works with the "% 20" formatting of the whitespace!
/Users/at/Library/Application\ Support/
/Users/at/Library/Application%20Support/
/Users/at/Library/Application Support/Google/AndroidStudioPreview2021.2/plugins/IdeaVim/lib/
"/Users/at/Library/Application Support/"

  TODO test this option: :set isfname+=32 ~/.vim/vimrc#/Makes%20whitespace%20be
this lets me use spaces in paths! and complete with c-x c-f. but now paths have to start at the beginning of the line.

### Network volumes / Google Drive
:sp /Volumes/GoogleDrive/My\ Drive/Sample\ upload.txt   - load a Google Drive file with quoted spaces
/Volumes/GoogleDrive/My%20Drive/Sample%20upload.txt   - this line works with 'gk' map. Note the hidden % 20
The next line/path only works with <c-w>f  !
/Volumes/GoogleDrive/My\ Drive/Sample\ upload.txt

### Filepaths & Urls
c-w f       - (on path or vis-sel) preview file content in horz-split
leader P    - (on path or vis-sel) preview file or folder(!) in float-win
leader of   - open filepath under cursor in float win
glc         - open Url in line in Chromium
leader fpc/C - :FilepathCopy[Abs]. also :PasteFilepath (put =@%  and let @*=@% )


### Arglist
leader oa   - to show. or :ar<cr>
leader X    - to reset/clear arglist
dirvish x   - toggle to from arglist (x, vis-sel, line-motion)
            - " Tip: can add popular folders as well, then CtrlP-v/t to open the dirvish pane
            leader oa   - show arglist in CtrlP. v/t to open. <c-s> to delete

:arg *.html or :argadd \**/*md

help argument-list
[a     :previous
]a     :next
[A     :first
]A     :last

Populate Arglist: ~/.vim/plugin/notes-workflow.vim#/Populate%20Arglist.%20-

### Quickfixlist
copen  / cw[indow] / cclose   - to open/close the quickfix list

### Change Working Directory CWD Project Root
leader dpr ":lcd " . projectroot#guess() . "\n"
leader dpR ":cd "  . projectroot#guess() . "\n"
" Also consider using ":ProjectRootCD"
~/.vim/vimrc#/Change%20Working%20Directory.

### Move / Copy files
manual/low level:
  yy in Dirvish - copy the full file path
  navigate to the destination path in Dirvish then `glT` to open a terminal at that location
  mv or cp ("cp -r" to copy a folder) then <c-[> to go to normal mode then `p` to paste then insert and `.` to copy/move into current folder
assisted:
  - put two dirvish folders side by side. use e.g. \T\v
  - the win/folderpath that has the cursor is the source (other on is the target of the move) (left/right does not matter)
  - add files to the arglist (highlighted in red). use ,x(l/}/vis-sel)
    - reset arglist with leader X
    - show arglist with leader oa (CtrlPArgs)
  - run the shell command with leader mv
  - alternatively preview/edit the command with leader mV
  detailed description: ~/.vim/plugin/file-manage.vim#/Move%20Files

### Move / copy text (vim registers)
" Vim clipboard features: Delete is not yank, substitute operator, yank buffer.
vim-easyclip plugin: ~/.vim/vimrc#/Vim%20clipboard%20features.   https://github.com/svermeulen/vim-easyclip
help easyclip

https://www.brianstorti.com/vim-registers/
help reg
leader"         - show register bar (vim-peekaboo: https://github.com/junegunn/vim-peekaboo)
\"pyiw          - yank into the 'parameter'
put =@"         - put/refer to the content of a register
:@"             - execute the content of the register (needs two <cr><cr> .. don't know why)
:@0/1/2/a/b     - run a specific register
leader sr       - exec the string in the normal \" register

### Shell system clipbord
Simple usecase of how to use pbcopy:
cat .gitignore | pbcopy
pbpaste | bat
ls -l | fzf | pbcopy

## Command window
;           - then c-n and c-i and c-x c-f for completion.
            " - c-cr/return to commit in insert mode. leader se in normal mode

            mkCounter = component "Counter " \props -> Hooks.do

# Git

## Status & author commit
leader og   - FzfPreviewGitStatus allows quick staging per file
leader oG   - FzfGFiles? Now shows gread diffs. For review before commit: use tab to add. then c-q will show only the files in quickfix list. 
              but can use ]c [c to navigate hunks. also use leader gg / gutter.
,og         - Git magit can nicely stage Hunks. Also :GitcommitAuthor
            - use c-n/p to jump to hunks, `S` to stage hunk, go to file line to stage entire file (of F to stage file), then `CC` to write a
:G          - fugitive git status/autor. s to stage. cc to create commit.

## Git commit log
leader2 gl  - FzfCommits
leader2 gL  - now uses FzfPreviewGitLogs. Enter shows a diff.
:Flog (return on commit to view div, 'q' to close), <c-n/p> to see diffs. help Flog

### Quick save shortcuts
lead lead gS - git status in float win
lead lead gC - git commit -a (all changes! - not just staged)
lead lead gP - git push
leader leader gc - Quick git commit (opt with vis-sel text)
leader leader gp - or `Gitpush` to push to Github repo. ~/.vim/plugin/tools-external.vim#/Git

## Gutter
leader gg   - GitGutterToggle
]c [c       - GitGutter Next/Prev Hunk
GitGutter.. UndoHunk, ..PreviewHunk


## Diffs
windo diffoff  - to exit vimdiff mode
git-delta viewer config: ~/.gitconfig#/path%20=%20~/.config/git-delta/themes.gitconfig
                         https://github.com/dandavison/delta#choosing-colors-styles

### Useful git commands
git ls-remote  - to show the URL of the github repo

### Github integration
     search:  https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
     track local history: https://docs.github.com/en/desktop

## Intero Errors or Warnings
leader qq   - open QFL
[Q [q ]q    - go to first/prev/next error (while in main win)
c-n/p       - next/prev (while in QFL)
go (in QFL) - jump to line (but stay in QFL)
p           - to open file:loc in preview window, `c-w z` or `P` to close preview

## LC Warnings AND Errors
leader ll   - open Loclist
[L [l ]l    - go to first/prev/next error/warning (while in main win)
              important: do exactly as in above and below line!! this goes through errors and warnings - but not a big problem
              changes update right away in the LocList win!
Go (in LLi) - jump to line (but stay in LocList)
c-m/i       - next/prev in QFL
p           - does not work! .. could set up a split?
censor/filter warnings:  ~/.vim/plugin/tools-langClientHIE-completion.vim#/\%20,%20'censorWarnings'.

## Align, Indent, format
,,l/j/}     - indent range of lines to current cursor-column
              .. idea/todo: align/push only the vis-selected part of the line
dw          - align/pull inwards to the cursorH the first char to the right
`>ii`         - shift lines of indent block to the right
,a(motion)(sel) - run a multi-col align template on motion or vis sel
,aii=       - will align to "=" inside indent block
leader al   - easy align
leader a-ii - align a 'case' block! to '->'
leader t<motion> - tabularise type sig
  off? leader ha (+m/vs) - type-sig align (motion or vis-sel) 'aB'-> error?
                TODO leader haiB show missing function
leader hA   - type-sig align entire buffer. or "viB<space>ha<c-o>"
]e,[e       - move/shift line. (lines using vis-sel)
,>          - push / shift text to the right  ~/.vim/plugin/utils-align.vim#/Push%20shift%20text
leader sb/n - break line at cursor, indent to cursor col
,,l/}       - intent the line to the current cursor col
              TODO: use visual-sel to intent from a specific point of the line string. ~/.vim/plugin/utils-align.vim#/TODO.%20use%20visual-sel
Note: the custom indentexpr that is used: ~/.vim/indent/purescript.vim#/setlocal%20indentexpr=GetHaskellIndent..
yow         - to toggle line wrapping

Align templates using UserChoiceAction/ quickmenu: ~/.vim/plugin/utils-align.vim#/Align%20Templates


## Purs Browse Module


## Format
leader leader sm 'SplitModulesInLines'<cr>
leader leader jm 'JoinModulesFromLines'<cr>
leader leader ht 'HsTabu'<cr> in entire buffer
leader leader hT 'StripAligningSpaces'<cr>
leader leader sa 'StripAligningSpaces'<cr>
leader leader hu 'HsUnicode'<cr>
leader leader hU 'HsUnUnicode'<cr>

### JSON format
%!jq
or
%!python -m json.tool

# Motions
g;          - to revert the InsertLeave jump
gI^- <cr>   - to prefix the current line with a '- ' without moving the cursor
leader j    - break line (with indention)
<BS>        - Join line below with current line
imap <BS> "  - This 'undo's a line break while staying in insert mode
q/Q         - labels
tab/s-t/,t  - Headers next/prev /end of header
c-i/m       - ballparks
]b[b        - binding-type sig (incl where, let)
cib         - to change the binding name in consequtive lines
Y/I         - columns - based on unaligned syntax e.g do bindings
J/K         - Word column corners Forw/Backw (based on aligned visibleColumns)
t/T         - next/prev list item
]t/[t       - into next/prev inner list
]T          - end of list (to append new elements) brackets
  TODO - this got overwritten by coc diagnostic next/prev
[g ]g       - go back to last insert start/end. or native \`[ \`]
z] z[ zk    - beginning/end of current fold/prev fold
[c ]c       - prev/next git hunk (TODO: make ]c or c] consistent?)
,j/k        - beginning of next/prev line
,J/K        - end/start of indent block
g]/g[       - first/last char of prev yanked text
\e          - move to the end of the previous word

q/Q         - Label/ Heading motion
ihc         - 'inside heading content' text object

## Sneak & easymotion
f/F         - f<char> to jump to next char. L/H to next
              ~/.vim/vimrc.vim#/Sneak%20Code%20Navigation.
\j/k        - line motion
\f          - then type first char, then the label keys that show up. Use then when you have already found/read a particular word.
              ~/.vim/vimrc.vim#/Easymotion%20Code%20Navigation

## Text-objects
help text-objects
iB         - inside entire buffer  ~/.vim/plugin/HsMotions.vim#/Textobjects.%20

### Command Insert Mode Movement
c-f        - into command edit mode!! test with <leader>s$: call append('.', input('--: ', 'eins zwei'))
Use Fn Key + "h,j,k,l" to navigate in insert mode (see Karabiner setup: ). normal movement while in insert mode: use this prefix/leaderkeystroke: "<c-o>" then e.g. "$"/"0"/"b"
Insert Mode motions: - "c-x" - "c-w" - "c-g, c-k"


## Actions Changes Edits
S$          - substitute / replace to the end of the line
cs['"/{(]   - change surrounding quotes/brackets e.g. {these once} to "these"
<op>J/K     - yank, source lines to the end of the block. e.g.
,dJ (with cursor at start of line) - delete / cut into register
yip         - yank the paragraph
leader"     - show register bar (peekaboo)
c-r         - paste while in insert mode(!) using register bar

## Folds, Folding
`zf` `zd` create/delete fold markers via motions/vis select
`zk` `zj` to navigate
`]z` `[z` go to end/beginning of current fold
`zo` `zc` `z<space>` to open/close/toggle individual folds
`zM`  `zR` to close/open all folds
`zm`  `zr` progressively close/open the fold levels (of nested folds)
`zx` / `zX` update /re apply

## Tools
leader og   - Git magit. Also :GitcommitAuthor
leader oG   - Git gitV viewer
leader ot   - Tagbar
leader om   - Markbar
leader oU   - Undo tree (Mundo)
:StripWhitespace - removes whitespace

## Tags, Vista, Tagbar
leader /    - Search for tags
leader ?    - FzfPreviewBufferTags
leader2     - FzfTags - searches tags everywhere?!

leader ot/T  - open Vista / Tagbar
c-w \        - jump to it from leftmost win (c-w p to jump back to prev win)
? in win     - show help
p in win     - to jump to tag but cursor stays in tagbar


## Marks
leader om   - open Markbar
m[A-Z,a-z]  - create global,local mark
'[A-z]      - go to mark. \` jumps to cursor pos
M[A-z]      - delete mark
in markbar:
c-n/p       - next/prev mark
o           - open mark at cursor
c-x         - delete mark
DelLocalMarks, DelGlobalMarks
gz'M        - Open a mark position in a floating-win. Use empty floating win with marks jumps: e.g. gz'M

Todo: checkout  https://github.com/MattesGroeger/vim-bookmarks

### Jumplist
leader c-o   - FzfPreviewJumps

## Bookmarks Shortcuts / Popular links
~/.vim/plugin/file-manage.vim#/Shortcuts%20to%20popular
leader ou :tabe ~/.vim/utils
leader or :vnew ~/.vim/plugin
leader oR :tabe ~/.vim/plugin
leader on :vnew ~/.vim/notes
leader oN :tabe ~/.vim/notes
leader ov :vnew ~/.vim
leader oV :tabe ~/.vim
leader od :vnew ~/Documents
leader oD :tabe ~/Documents/
leader oh :vnew ~/Documents/Haskell/6/
leader oH :tabe ~/Documents/Haskell/6/
leader op :vnew ~/Documents/PS/A/
leader oP :tabe ~/Documents/PS/A/

noremap \v :exec "vnew " . expand('%:p:h')<cr>
nnoremap \T :exec "tabe " . expand('%:p:h')<cr>

## Rename, replace, substitute
<!-- '<,'>s/old/new/g -->
.+1,.+2s/old/new/g
eins old
old zwei
drei old
More tricks: ~/.vim/plugin/notes-workflow.vim#/Substitute%20Replace%20Text.

### Commandline-ranges
help cmdline-ranges
https://vim.fandom.com/wiki/Ranges

### Replace variable names
leader lr/m - rename symbol with all it's live/active references
ga \raf     - highlight/search symbol, \r + range of the replace. leader-rb is a sortcut for a haskell function rename
leader rb   - to rename a binding and its occurences


# Vim
:Help w<c-i> - complete help terms
leader K    - Vim help. Use :HelpGrep .. ':hg nnoremap'<cr> for a text search

leader Sm   - :MessagesShow - show past vim echoed text (show messages) in preview window
            - output of any single command: RedirMessagesWin verb set comments?
put =g:maplocalleader - put the content of a variable into the buffer!

## List of commands, maps and vim-sets (settings)
FzfMaps
:filter function *stat<c-i>   - just text seach in function names
    Find where a vim-command, function or map is defined

:set <c-i>    - list of vim settings: /Users/at/.vim/notes/vimdump-set.txt
:verb command [first letter: T] <c-i>  - list of commands: /Users/at/.vim/notes/vimdump-command.txt
:verb function [fist letter: S] <c-i>  - list of function: /Users/at/.vim/notes/vimdump-functions.txt
:verb map [first key: g]<c-i>      - list of vim-maps: /Users/at/.vim/notes/vimdump-map.txt
                                     then use <c-n/p> to navigate all mappings starting with e.g. 'g'
:scriptnames - List of vim-script files: ~/.vim/notes/vimdump-scriptnames.txt

:echo g:mapl<c-i>   - list of g:/global variable starting with mapl .. maplocalleader

### vimdump files updating
:RedirMessagesWin verb map  - put any vim command echo text into a new buffer
  Substitude vim echoed locations with rel-lins: %s/ line /#:/  e.g. ~/.vim/plugin/HsAPI-haddock.vim line 37 => ~/.vim/plugin/HsAPI-haddock.vim#:37
  Collapse two lines into one: %s/\n.*Last set from/ | /


toggle vim settings: ~/.vim/vimrc#/function.%20ToggleOption.option_name,%20....

## Vim-commands
leader .   - releat last command
verb command Colo<c-n> - get a list of commands and where they are defined
verb map Colo<c-n> - get a list of maps and where they are defined
\sm        - set syntax markdown - see  ~/.vim/plugin/notes-workflow.vim#/Set%20Syntax.
:Alacritty - open new terminal and then vim instance
c-g u      - will set an undo-mark
leader cv  - clear virtual text
leader cs  - clear signs column
leader vo/O - open current file/PS folder in new vim instance
~/.vim/plugin/syntax-color.vim#/STEP1.%20FIND%20THE
  Find color: nnoremap <leader><leader>hsc :call SyntaxColor()<CR>
  Find syntax: nnoremap <leader><leader>hhsg :call SyntaxStack()<CR>

## Sourcing vim files
leader so  - source the current file
leader se  - source/run the current line
leader leader sv - :so $MYVIMRC
leader saf/p     - source function or paragraph
~/.vim/plugin/utils-vimscript-tools.vim#/Sourcing%20Parts%20Of

### Vim Quickmenu / UserChoiceAction
~/.vim/plugin/ui-userChoiceAction.vim#/User%20Choice%20Menu

### Maps, Mappings, Expression maps
~/.vim/plugin/notes-workflow.vim#/Mappings.

#### Defining operator maps
help map-operator

Basic example: ~/.vim/plugin/utils-vimscript-tools.vim#/func.%20OpSourceVimL.%20motionType,   ~/.vim/plugin/search-replace.vim#/Operator%20Map.%20The
Examples with generic operator functions
* template for opfunc mappings (+vis-sel +command range) is here: ~/.vim/plugin/utils-align.vim#/command.%20-range=%%20StripAligningSpaces
* Gen_opfunc2: applying a function via an operator map, visual selection and command  ~/.vim/plugin/code-line-props.vim#/Vim%20Pattern.%20For



## Python
### Installation
https://opensource.com/article/19/5/python-3-default-mac
Note we are using pyenv: /Users/at/.zshrc#/#%20Use%20pyenv
and: alias python=/opt/homebrew/bin/python3 to use the most current homebrew installed python 3 version as whenever 'python' is called
You can install Python packages with pip3 install <package> They will install into the site-package directory /opt/homebrew/lib/python3.9/site-packages

Todo: there is still about the virtual env set in :checkhealth. see https://vi.stackexchange.com/questions/7644/use-vim-with-virtualenv/7654#7654
### Pyenv
https://github.com/pyenv/pyenv-virtualenv/blob/master/README.md
pyenv versions
show system version | set the global system version
pyenv global && pyenv global 3.10.0

Example from https://neovim.io/doc/user/provider.html
pyenv install 3.4.4
pyenv virtualenv 3.4.4 py3nvim
pyenv activate py3nvim
python3 -m pip install pynvim
pyenv which python  # Note the path
The last command reports the interpreter path, add it to your init.vim:
let g:python3_host_prog = '/path/to/py3nvim/bin/python'


" Example of how to run a Python function:  ~/.vim/plugin/utils-stubs.vim#/Example%20of%20how

### Notes
~/.vim/plugin/notes-workflow.vim#/Defining%20Commands%20And

## Links / code links / vim rel-link
glc         - open Url in line in Chromium
glb         - open URL in browser
leader ol   - open 'links' file in float-win, then glc to view in Chromium

gk          - follow rel-link
lead lg/lG  - go to definition/ in split
gd ,gd     - go to definition /in split

leader cl  - to copy a rel-link to the clipboard
~/.vim/plugin/general-helpers.vim#/func.%20LinkRefToClipBoard..
help Rel
Substitude vim echoed locations with rel-lins: %s/ line /#:/  e.g. ~/.vim/plugin/HsAPI-haddock.vim line 37 => ~/.vim/plugin/HsAPI-haddock.vim#:37
leader fpc - copy current file path


### Shell / ZSH
Kitty uses the system shell which is set to zsh: echo $SHELL .. /bin/zsh
reload shell settings with 'exec $0' or 'source ~/.zshrc'
'which'/'type -a' <shell-cmd>   - shows info about a shell command

lead lead ls   - uses ShellReturn() to show the result of 'ls'  ~/.vim/plugin/tools-external.vim#/func.%20ShellReturn.%20cmd

#### Zshrc & Oh-my-zsh
lst          - ls/list tee. Some alias's (e.g. for tree/lst) use 'exa': ~/.zshrc#/alias%20lst='exa%20--sort=type

Plugins are installed via git here: /Users/at/.oh-my-zsh/custom/plugins/

## Kitty Terminal settings
cmd ,  - to open Kitty settings
crt cmd ,  - to refresh settings
c-z    - to suspend vim and go to the terminal - then if done in the terminal do fg ('foregr') to resume the vim session
c-s-t  - new tab in kitty! use ctrl+shift + arrows l/r to navigate tabs. see: https://sw.kovidgoyal.net/kitty/overview/ 

### Terminal buffer
glt/T     - open a new terminal buffer in project root (also works in dirvish)
gLt/T     - to prefill and edit line command string to running it in a hidden/visible term-buffer
:Term! npm run serve - run command in terminal buffer. (!) optionally opens the buffer in a split.
<ctl>\n      - to leave terminal insert mode but stay in buffer. to e.g. scroll/copy text
               need to keep control pressed for both successive key strokes: \ and n
c-w-c   - cancels the terminal process and deletes the terminal buffer
          when in terminal insert mode, else just closes the window.

" TODO: Run commands in hidden buffers!
glt     - runs the current line text in a hidden terminal buffer. find it in buffer list by the command string!


#### Terminal maps
c-r     - to search through past commands in terminal. (use repeatedly! to search further)
          note: ~/.zsh_history
c-w h   - to delete the last word in insert mode. this is needed bc c-w jumps to buffer above

### Vim -> terminal commands
grt     - run command in terminal (command is string in line from cursor or vis-sel)
grT     - with editable command string

:%!     - execute all lines if the current buffer as shell commands!
:put =system('ls')<cr>   - put the return value of 'ls' into the current buffer!


## Spell Checking
Toggle with "yos" ":Spell"/ "SpellDE"/ "SpellEN" on. "set nospell" turns it off
" Navigate errors: "]s" - "[s", show suggestions: "z=", rather: "ea" to go to insert mode at the end of the word, then
" "c-x s" to open suggestion menu! TODO prevent proposing capitalized suggestions.
" add to dictionary: "zg" undo "zug"

## Scratch window, temp notes file
leader os  - ScratchWindow
<c-w>c     - just close the window / buffer will reopen after leader os
leader bd/D - delete the buffer. bD for :bd! is not needed
leader oS af/ip/\j or visSel - put lines into a scratch window
note this alternative:
leader wp af/ip ..

## Sessions
leader Sd   - load default session
leader Ss   - save to default session

## Infos
leader2 lc[iB/ip] - count lines of code

### Todo
getnextscratchpath from project root + create that dir, count files
Ag search
list all autocmd mksession
search in :ChromeBookmarks
tabline should show dirvish foldername

highlight standalone 'state' and onClick. on(capital letter) - 'on' dark - but a lighter color for the rest

### Todo:
highlight halogen and react-basic hooks functions
like 'state' and 'onClick'
this is overwriting my syntax-state matches?
~/.vim/syntax/purescript.vim#/syn%20match%20purescriptIdentifierDot1
should turn these into syntax statements  ~/.vim/syntax/purescript.vim#/call%20matchadd.'purescriptStateKey',%20'\vstate\.\zs\w{-}\ze\_s',
use 2leader hhsg - to show syntax groups
read the documentation here!: ~/.vim/plugin/syntax-color.vim#/STEP2A.%20If%20you

function argument highlighing ~/.vim/syntax/purescript.vim#/TODO%20rather%20highlight
https://github.com/pboettch/vim-highlight-cursor-words/blob/master/plugin/hicursorwords.vim
https://stackoverflow.com/questions/1551231/highlight-variable-under-cursor-in-vim-like-in-netbeans

Show purescript syntax in Coc completion menu

Markdown live preview
mdbook  https://rust-lang.github.io/mdBook/format/mdbook.html#including-portions-of-a-file

