

## Homebrew
brew list | grep python
brew info python

## Git control of Config files

do-next
https://alexpearce.me/2016/02/managing-dotfiles-with-stow/


Old attemps bak:
Now using vcsh at ~/.config/vcsh/repo.d/vim.git/ to git-version control config files
Alternative: :! config  - to interact with git version control of dotfiles in ~/.cfg see: /Users/at/.zshrc#/#%20using%20'config' 
Run git commands, e.g.:
vcsh vim config --local status.showUntrackedFiles no
vcsh vim status

## Video
We now have 'mpv -h' and 'vlc -h' installed!
 -> test these!

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
CocList symbols  - allows to fuzzy-search and jump to all loaded symbols!
CocList commands
CocList sources  - how to prioritise completion sources!
CocList <c-i> - to see all useful! options
CocList extensions   https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions

## Kitty Terminal settings
cmd ,  - to open Kitty settings
crt cmd ,  - to refresh settings
c-z    - to suspend vim and go to the terminal - then if done in the terminal do fg ('foregr') to resume the vim session
c-s-t  - new tab in kitty! use ctrl+shift + arrows l/r to navigate tabs. see: https://sw.kovidgoyal.net/kitty/overview/ 

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
Note this does not work properly in .vim files!
leader ehs  - heading
leader ehe  - close section (does not include the header text in the end?)
leader ehr  - refresh heading/section (currently on this updates the end text)
leader ehd  - delete/strip heading/section


## Search & Docs
leader K    - Vim help. Use ':hg nnoremap'<cr> for a text search
gsR/r       - Grep search in the current repo! cursor-word editable.
              use { and } to navigate found contexts. 'o' to open an item in the left split. <cr> to close
              see  /Users/at/.vim/plugin/search.vim#/Vim%20Grepper.%20------------------------------
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


## Mac apps
tab '       - Mac app/task manager, next app
## Karabiner Key maps
~/.vim/keymaps-karabiner/rules-array-13-10-2018.json#/"description".%20"Left%20Control

## Window, Buffer Navigation
c-w n/N     - SymbolNext SplitTop
c-w i       - jump into float-win
leader wp[ap/af] - pin a function/paragraph (or imports) to the top
c-w dk      - close the window above
c-w \       - to jump to rightmost/mark/tag bar window
c-w p       - to jump back
\t]         - TabmoveRight /Left
leader wi/I - Pin [and jump to cword] Haskell imports
c-w I       - resize/fit floatwin height width
c-w x/S h/l/k/j - Swap with / Shift a window with the other adjacent window
  1<c-w>x     - swap window with the one above/at top of screen (2 is below)
go    - bufferlist:
  c-j/k, c-x - close a buffer in the ctrlP buffer list without opening it
  c-ov/h to open offer in split
\^ <c-^>     - to load the alternate (past) file or \e3 <c-^>

### Window scrolling
c-e/y       - up/down
zt/b        - bottom/top

## Files
\v \T       - browse-open file in new split/tab from the same project
:e %mynewfile - this creates a new buffer in the current Dirvish folder!
gp <c-o>v   - browse-open recent file in a split e.g. from a different project

## Dirvish
t           - open in new tab
leader of   - open file under cursor in float-win. curson is in float win so you can scroll right away.
P           - preview in float-win
p           - preview in (currently open?) split. only good if there is no other open split?
:e %mynewfile - this creates a new buffer in the current Dirvish folder!
g?          - show help
K           - file info/ dir size/ last write
.           - on a file, then 'rm' or 'mv %..' to delete, more file.
leader df   - delete file with relative path
vis-sel .   - doesn't insert the full path: https://github.com/justinmk/vim-dirvish/issues/188
:!touch %newFile  .. :!mkdir %newfolder
g;          - to get :!  in the vim command panel.
T           - expands a the folder under the cursor.

### Ranger-like setup
"Win navigate right to left and use 'p'"
\T          - new tab, go to a 'root' folder
c-w v c-w = - make 3 columns
c-w |       - go to the next 'last window', then c-w h/l, then 'p' to fill the previous win with the content of the node
TODO some simple maps/commands for 'p' could achieve a basic ranger functionality!?

### Filepaths Urls
c-w f       - (on filepath) preview file content in horz-split
leader of   - open filepath under cursor in float win
glc         - open Url in line in Chromium
leader fpc/C - :FilepathCopy[Abs]. also :PasteFilepath
### Arglist
,x          - toggle to from arglist (x, vis-sel, line-motion)
            - " Tip: can add popular folders as well, then CtrlP-v/t to open the dirvish pane
            leader oa   - show arglist in CtrlP. v/t to open. <c-s> to delete

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


## Command window
;           - then c-n and c-i and c-x c-f for completion.
            " - c-cr/return to commit in insert mode. leader se in normal mode

            mkCounter = component "Counter " \props -> Hooks.do

## Git
leader gg   - GitGutterToggle
]c [c       - GitGutter Next/Prev Hunk
GitGutter.. UndoHunk, ..PreviewHunk
leader leader gc - Quick git commit (opt with vis-sel text)
leader leader gp - or `Gitpush` to push to Github repo. ~/.vim/plugin/tools-external.vim#/Git
leader og   - Git magit. Also :GitcommitAuthor
            - use c-n/p to jump to hunks, `S` to stage hunk, go to file line to stage entire file, then `CC` to write a
            commit message, `:w` to commit.
leader oG   - Git Flog viewer (return on commit to view div, 'q' to close)

### Github integration
TODO `gh --help` - create GH issues: https://cli.github.com/manual/examples
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
\,l/j/}     - indent range of lines to current cursor-column
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
\>          - push / shift text to the right  ~/.vim/plugin/utils-align.vim#/Push%20shift%20text
leader sb/n - break line at cursor, indent to cursor col
\,l/}       - intent the line to the current cursor col
              TODO: use visual-sel to intent from a specific point of the line string. ~/.vim/plugin/utils-align.vim#/TODO.%20use%20visual-sel
Note: the custom indentexpr that is used: ~/.vim/indent/purescript.vim#/setlocal%20indentexpr=GetHaskellIndent..
yow         - to toggle line wrapping

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

## Tagbar
leader ot   - open
c-w \       - jump to it from leftmost win (c-w p to jump back to prev win)
? in win    - show help
p in win    - to jump to tag but cursor stays in tagbar

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
gz'M        - use empty floating win with marks jumps: e.g. gz'M

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

## Rename
leader lr/m - rename symbol with all it's live/active references
ga \raf     - highlight/search symbol, \r + range of the replace. leader-rb is a sortcut for a haskell function rename
leader rb   - to rename a binding and its occurences

# Vim
leader Sm   - :MessagesShow - show past vim echoed text (show messages) in preview window
            - output of any single command: RedirMessagesWin verb set comments?
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

Alacritty config file: .config/alacritty/alacritty.yml

## Python
### Installation
https://opensource.com/article/19/5/python-3-default-mac
Note we are using pyenv: /Users/at/.zshrc#/#%20Use%20pyenv
and: alias python=/opt/homebrew/bin/python3 to use the most current homebrew installed python 3 version as whenever 'python' is called
You can install Python packages with pip3 install <package> They will install into the site-package directory /opt/homebrew/lib/python3.9/site-packages



" Example of how to run a Python function:  ~/.vim/plugin/utils-stubs.vim#/Example%20of%20how

### Notes
~/.vim/plugin/notes-workflow.vim#/Defining%20Commands%20And

## Links / code links
glc         - open Url in line in Chromium
glb         - open URL in browser
leader ol   - open 'links' file in float-win, then glc to view in Chromium

gk          - follow rel-link
lead lg/lG  - go to definition/ in split
gd ,gd     - go to definition /in split

leader cl  - to copy a rel-link to the clipboard
~/.vim/plugin/general-helpers.vim#/func.%20LinkRefToClipBoard..
see g:rel_http nmap

leader fpc - copy current file path


### Shell / ZSH
Kitty uses the system shell which is set to zsh: echo $SHELL .. /bin/zsh
reload shell settings with 'exec $0' or 'source ~/.zshrc'
'which'/'type -a' <shell-cmd>   - shows info about a shell command

lead lead ls   - uses ShellReturn() to show the result of 'ls'  ~/.vim/plugin/tools-external.vim#/func.%20ShellReturn.%20cmd


### Terminal buffer
glT     - open a new terminal buffer in project root (also works in dirvish)
glt     - runs the current line text in a hidden terminal buffer. find it in buffer list by the command string!
gLt/T   - to prefill and edit line command string to running it in a hidden/visible term-buffer
:Term! npm run serve - run command in terminal buffer. (!) optionally opens the buffer in a split.
<ctl>\n      - to leave terminal insert mode but stay in buffer. to e.g. scroll/copy text
               need to keep control pressed for both successive key strokes: \ and n
c-w-c   - cancels the terminal process and deletes the terminal buffer
          when in terminal insert mode, else just closes the window.

#### Terminal maps
c-r     - to search through past commands in terminal. (use repeatedly)

## Spell Checking
Toggle with "yos" ":Spell"/ "SpellDE"/ "SpellEN" on. "set nospell" turns it off
" Navigate errors: "]s" - "[s", show suggestions: "z=", rather: "ea" to go to insert mode at the end of the word, then
" "c-x s" to open suggestion menu! TODO prevent proposing capitalized suggestions.
" add to dictionary: "zg" undo "zug"

## Scratch window
leader os  - ScratchWindow
<c-w>c     - just close the window / buffer will reopen after leader os
leader bd/D - delete the buffer. bD for :bd! is not needed
leader oS af/ip/\j or visSel - put lines into a scratch window
note this alternative:
leader wp af/ip ..

## Infos
leader2 lc[iB/ip] - count lines of code

### Todo
getnextscratchpath from project root + create that dir, count files
Ag search
list all autocmd mksession
search in :ChromeBookmarks
tabline should show dirvish foldername

highlight standalone 'state' and onClick. on(capital letter) - 'on' dark - but a lighter color for the rest
~/Documents/PS/A/TestsA/webpack-reload/src/App/RandNum.purs#/--%20TODO.%20highlight

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

