----------------------------------------------------
# Navigate Containers & Objects
   Tag, Folds, Marks
   * Files, Foders
   * vim-Buffers
   * vim-Wins   → vim-Tabs
   * tmux-Panes → tmux-Windows
   * OS-Wins    → OS-Apps
----------------------------------------------------

## New vim-Window:
  'split' current buffer
    * `<c-w>s` `:sp` below
    * `<c-w>S`(v?) `:vs` left
  launch 'new' buffer
    * `<c-w>n` `:new` below
    * `<c-w>N` `:vnew` left
  with existing buffer/file
    * CtrlP `o` + `h/v`
    * TODO / Issue: above still does not force a split with exsisting buffer

  from selection
    * `c-w gss` or `.. gsa` for split above
    * Pin a paragraph to the top: `vip<c-w>gsa`

## New vim-Tab
  with current buffer
    * `:tabe` or `:tabe somename` for a new/temp buffer
    * `<c-w>t` or `:tabe %` to zoom/duplicate the current buffer in the tab
    * `<c-w>T` to spin off a window to a tab
  with other buffer/file
    * ctrlP `o` + `t`

### Close vim-Window
  * `<c-w>c`
  * `:q`
  window and buffer
    * `:bd` the buffer (when last window)

### Close vim-Tab
  * `gx` and go to prev Tab
  * `:tabc`
#### tab and buffer
     * `:bd` the buffer (when last window)

### Nav vim-Tabs
  * go next / prev `<c-d>` / `<c-f>`
#### Arrage Tabs
  * move tab left/right `[t` `]t`

### Nav vim-Windows
  * go left, right, up, down `<c-w>h/j/k/l`
#### Arrange Windows
  * zoom to (temp) tab `<c-w>t` then `gx`
  * swap `<c-w>r`
  * `<c-w>HJKL` push window to left/down/up/right
#### Resize Windows
  * expand left/down `<c-.>` / `<c-,>`
  * equal size `<c-w>=`


## Files
  States:
  1. **created**: by saving the content of a buffer
  2. **loaded**: in a buffer


## Folders
how about folders?
relation to files/buffer/tabs?
create/remove
ctrlP navigate


## Arglist

  * `args \cat files.txt\` get arglist from a file using backtick expression

### Argdo
  substitute in a selection of files:
  `vim /<c-r>// **/*.txt` previous search pattern in txt files in subfolders
  `QfToArgs | argdo %s//abc/g | update` run a command on all file in the quickfix list

## Registers
* `qaq` to clear


## Cmdline
  `:find a<tab>` (e.g. in Haskell project folder) allows to:
  * Reach into subfolders (usind `set path+=**`, but this includes other folders)
  * autocompl menu
  * fuzzy complete (e.g. `:find *hs<c-i>` will show all haskell files)
  (https://www.kwyse.com/posts/twid-vim-minimalism/)
  * `cd .vim/plugged`, `:tabf[ind] *.md<tab>` to show all readme files

### Cmdline Menu
  (with setting `set wildmode=longest:list,full`)
  * `c-i` to start command line auto completion (or tab)
  * looking at the grid displayed options:
      * type the first char, then hit `c-i` again to expand the filtered options
  * `c-n/p` will suffle through in horz menu


## Summary of native vim file exploring
   https://vimways.org/2018/death-by-a-thousand-files/
   * `e **/*`
      set wildcharm =<C-z>
      `nnoremap ,e :e **/*<C-z><S-Tab>`
      `nnoremap ,f :find **/*.md<C-z><S-Tab>`
      `nnoremap ,f :find .**/*<C-z>` then c-c then type 'note' .. <tab> to get fuzzy searching


## Dirvish
  * `g?` to show help (note `o, a` c-n/p to preview and visual selection)
  * `-` open / up/parent folder
  * `gq` close
  * use 'filepath' of dirvish in command:
    * `cd %` set working dir
    * `edit %/foo.txt` create a file **TODO** how to save a temp/unsaved buffer by navigating to a folder, then `w #/filesname`
    * `]f/[f` next/prev file through all sub folders!
    * on a file name (which is a full file path under conceil):
      * `gf` or `<cr>` to `:e ` that file
      * `c-w f` to split view that file below
    * `yy` the path, then:
      * go to buffer and `:read <c-r>" the content of the yanked path`


## Arglist
  * use `x` and `dax` for arglist
  * `c-w v` then `[A`, `]a` to have a window (`c-w t` or tab) with this group of files!


## Buffers
  States:
  1. **listed**: in the bufferlist (~in memory)
  2. **displayed**: in some window (or be hidden but still listed)
  3. *active*: displayed in the current window


## Insert mode

  `c-r <reg>` to paste while in insert mode

  `c-x c-f` to start filename browse mode!
  `c-x c-n` for completion. what the difference to just `c-n`?
  use `c-w` to delete a word at the prompt
  use the `*` to get fuzzy suggestions NOTE/TODO: this isn't *on the fly* fuzzy/ while you type - but completion plugins have this.

  use `gi` to resume insert mode where last exited


## Completion

> Plug 'neoclide/coc.nvim', {'branch': 'release'}
now via haskell-language-server and coc.nvim
old: via HIE and decomplete
  https://github.com/mhinz/vim-galore#completion
but may want to ckeck out coc.nvim and
  https://github.com/voldikss/coc-browser

> Tab navigate the file system while in insert mode
inoremap <Tab> <c-x><c-f>
" In command mode use <c-d> and Tab
  Example path: `Documents/PS/2/pux-todo/README.md`
  this works nicely with <c-j/k/l> nav
  ⇒ maybe mapping to produce, then copy and delete the path from insert/normal mode and past it to command?
In command mode (see `:h cmdline-completion`) after `:e `
 1. `c-d` to show all options
 2. then (optionally) type a char or two
 3. then `c-n` (or `c-i` or Tab) and `c-p` to go back and forth through the options
 (1.) `c-d` selects/locks-in the currently selected element and displays child options
 ⇒ `c-d` - `c-p/n` in alternation
 * `c-w` to delete a word back


Navigate in scrollback history:
  * <c-p> to go back in command history, <c-n> to go forward in history.

code auto completion:
now using CoC nvim

## Buffers
  Create New (File)
    **Current Win**
      * `:e <new path/name>` create in the curr win
    **New Win**
      * `<c-w>n/N` create below or left
      * CtrlP `<new path/name> <c-y>` create left
    **New Tab**
      * CtrlP `<new path/name> <c-y>` create left && `<c-w>T`

  From File
    **Current Win**
      * `:e <filename>` list a buffer and display it in the curr win. (currently no use to list but not display buffer)
      * CtrlP `o` + `r` (in file, mru) to list a buffer and display it in the curr window (no matter if buffer is displayed in other wins)

### Unlist Buffers

### Nav Buffers
  * **Reveal:** CtrlP `<c-v>` to reveal/go to buffer if it's **shown** in a tab-window somewhere
    * otherwise **open/load** buffer in a vertical split. can then `<c-w>c` that split or close the original or use
        `<c-w>T` to move it out of this tab into its own tab.

### Load Open Buffer
  * **New Tab:** CtrlP `o` + `t` to load buffer into new tab (no matter if buffer is shown somewhere

alternate between prev and current buffer: `:e #` `,`

  * `\tc` for tabc[lose]
  * `\bd` for `:bd`
  * `\tm[`

" Select multiple files with <c-z> then do <c-o> to load the first into the current window (r) and
to then hide the splits (undo the visual), <c-o> on the first win and <c-w>D or <c-w>o to close the splits
to undo

use <c-o> open menu?

### New vim-Buffer
  in the same window:
    new/temp file
      * `:e temp1` this needs a (temp?) filename
    existing file or buffer
      * shuffle with airline menu? `<c-d/f>`
      * ctrlP `c-o`, `r` (replace)
      * `:e <tab>` complete from files in the workingdir
      * `:bu <tab>` complete from open offers!
  in new window:
      * `:new` / `<c-w>n` new buffer below
      * `:vnew` new buffer to the right

### close buffer
  * `gx` leaves window open
  * `:bd` closes window/tab


## MacOS App windows
  * `<c-s-w>` next app window (within the current workspace/desktop)
    (defined in `System preferences/Keyboard/Shortcuts/Keyboard` )

### navigate MacOS Apps
  * `<cmd-c-[/]>` prev/next app (showing open apps menu)
    (use to select the app to toggle with) ISSUE: difficult to put thump on cmd
  * `<c-'>` toggle between second app (in apps menu)
    Defined in  `~/.config/karabiner/karabiner.json`
      "description": "Left Control + ' to cycle through running applications (like command+tab).",


## Code navigation

### Tags
    * `:tags`
        `set tags?`
        `c-]` to nav, `c-t` to go back

    * see [Preview window](#Preview window)

[Config](../../.vimrc#Tags:)

### Changes
    * `:changes`
    * back to last change (e.g. paste) `\`.`
    * `g;` `g,` shuffle through changes`

### Inserts
    * back to last insert

### Jumps
    * `:jumps`
    * could use CursorHold + updatetime (500 now → 1000) to add more to the jumplist? TODO
    * jumps are currently not centering the view - which might cause less view jumping but makes it harder to find
    cursor. 

## Marks

  * Deleting marks:
  `delm G-Z` to clear a range of marks
  `c-x` in markbar to delete selected mark
  :DelGlobalMarks

[config](../../.vimrc#Marks:)

## Folds, Folding
  `zf` `zd` create/delete fold markers via motions/vis select
  `zk` `zj` to navigate
  `]z` `[z` go to end/beginning of current fold
  `zo` `zc` `z<space>` to open/close/toggle individual folds
  `zM`  `zR` to close/open all folds
  `zm`  `zr` progressively close/open the fold levels (of nested folds)
  `zx` / `zX` update /re apply
  http://learnvimscriptthehardway.stevelosh.com/chapters/48.html
  " What actions automatically open folds?
  improve performance of autofolding https://github.com/Konfekt/FastFold

*v:foldstart* *foldstart-variable*
in tutor docs

### set foldmethod=marker
integrate fold chars into comments: `fold-create-marker`
             from "Compos.hs": displayWR ∷ Float → App String -- { { { 1

### set foldmethod=syntax
see :syn-fold

### set foldmethod=manual
autohide/expand `foldcolum`? .. or just have a shortcut to toggle

`yofc`


## Align

* Align maps:
`leader al` + [motion, textobject: e.g. `ii` "inside indent block"] 
              + speperatorId (<space>, 2<space>, "," )
* Tabularize 1st and 2nd column of a motion or selected range of lines based on <space>
`leader at` + [range]

Example: Align the 3 lines below to the ':tabe' word:
 - visually select the lines
 then align to ' -' e.g. when having "ab  - cd" and "ef  - gh"
 0. <,>EasyAlign / -/
 or
 1. `:Tabularize /:tabe/`
 or
 2. `:Easyalign`<cr> then `6 ` <cr> to align to the 6th space

command! -nargs=1 Frepo :tabe % | Grepper -tool git -side -query <args>
" Open buffers:
command! -nargs=1 Fbuffers :tabe % | Grepper           -side -buffers -query <args>

 * `:Tabularize / /` to align to `" "`
     * uses smart paragraph

see examples here: ~/.vim/utils/utils-align.vim#/Align%20Example.

## Repl

Repl format: `gew` does just append all repl returned lines
`gel` "eval list" on a Haskell identifier will insert a resulting list as lines. see PasteListAsLines()
`get` "eval table": After "eval list", it then aligns the first two columns (column separator is <space>)
`geT` "tabularizes" the output

* `\tw` or `\tt` to get the type of the identifier

## Code Navigation
  * how to navigate header like this:?
  SOME *|*
  let g:nnoremap = {"]t": "", "[t": ""}
  how can I list/find/browse (ctrlp?, tagbar, quicklist) doc tags in e.g. .vimrc?
  examples:
    " Git Workflow: ------
    " Windows: --------
  * make Links in vimscript

  document |bracket-navigation|
  *)* next open
  |%| or *]}* closing pair
  *[{* parent
  NOTE this is not complete - research full solution?
  * does not move to "[" as parent → vim navigate json file

  * jump to start/end of inserted/pasted text `\`[ \`]
  * jump to start/end of previous selection \`< \`>

  * Using seach to navigate
    You can get an empty line with /^$; or if you dont want to select the empty line itself you can use \n\n to put the cursor at the end of the line before the first blank line:
    * <S-v>/^$<CR>
    * <S-v>/\n\n<CR>

  * go to the end of a comment: ]/ , end of parant ])
  * use `gv` to reactive the prev selection or a selection created with `m<`, `m>`

  * nav in markdown (and other langs?) with text objects/motions: https://github.com/coachshea/vim-textobj-markdown

## Quickfix Locationlist Navigation
  * `leader qq`
  * `]q` with cursor in code,
  * `c-n/p` and `go` with cursor in quickfix list
  * `cnf[ile]` to go the first item in the next file
  * `:cdo {cmd}` run cmd on all qf entries, `cfdo cmd` runs on the files (?)
  * use `p` to open file:loc in preview window, `c-w z` or `P` to close preview
### LC Warnings AND Errors
leader ll   - open Loclist
[L [l ]l    - go to first/prev/next error/warning (while in main win)
Go (in LLi) - jump to line (but stay in LocList)
c-m/i       - next/prev in QFL
p           - does not work! .. could set up a split?


### Examples
  * lvim /vimium/ .vim/notes/** load vimseach results into location list

  * Grep to vim quickfix via process substitution: `nvim -q <(grep -rsni todo .vim/notes/**)` or `vim -q<(!!)`
  * Use this to debug Jumplist `autocmd CursorHold * call JumpsToQuickfix()`


## Sessions
save and restore a session with windows and tabs

----------------------------------------------------

## Tags
document hasktags workflow:
  in stack.yaml add this: `extra-deps: [hasktags-0.71.2]`

Tag screenshot featuring ctrlp and tagbar:
  ~/.vim/screenshots/tags-tagbar-haskell-ctrlp.png

run python that script, does this have --help?
produce ctags as a text file - where is this put?

optimize and document in vim-worksteps progressively:
  * generate `ctags` file
 ~  .vim  notes  python ~/.vim/plugged/markdown2ctags/markdown2ctags.py notes29-09.md
 (could just get to command history in terminal buffer - it now seems to be the same shell(zsh)
 instance??!)
  * ctrlP needed to be cced into that folder .vim/notes, to pick up the 'tags' file

current termina questions. see screenshot:
  how to get to command history how to copy this?
  how to copy/edit/get into vim a command I ran?
  same re the markdown2ctags.py --help output


## Tabline Statusline

## Working modes


### Focused implementation of one code part

  Say you are starting at a clean slate
  * your code will start spanning more than the screen size
  * you will have to jump back and forth between multible code locations
  * you will create multiple files

location could be a
  * win split
  * mark
  * arglist entry


#### Permanent available
 * REPL
 * Tests

#### On demand available
 * doc access
 * notes access
 * git control
 * file explorer
 * launch/ transistion to the modes below

### Quick browse
 * want to explore/insight/confirm related code
### Tags
 - `gf`, `c-w` `f/gf` to open tab/split?

## Search

 1. Grepper search
    * Frepo, Fbuffers, Fnotes, Fhask, Fvim, Fplug
    * only in git files in case of repo, notes
    * on sidebar, with context
    * in new tab
    * based on project root
    * use single quotes when searching :Frepo 'multiple words'
    * visual select two words and then `gsr` does the same
    * use regex: `:Frepo 'leader.*oc\s' `

    see ~/.vimrc#/Search%20Config:

    Use `}`and `{` to jump to contexts. `o` opens the current context in the
    last window. `<cr>` opens the current context in the last window, but closes the current window first.

 2. search vimconf and notes
    `vim /andreasthoelke/ ~/.vimrc ~/.vim/utils/** ~/.vim/notes/**`
    `Ag andreasthoelke ~/.vimrc ~/.vim/utils/** ~/.vim/notes/**`
    TODO preconfigure search across notes

 3. Search in Dirvish folder
  * `c-w v-` to get into Dirvish
  * navigate to the folder you want to search in
  * `:vim /searchterm/ %**`
    * use quickfixlist to navigate search results
  * `:Ag searchterm %**`
    * use `c-n/p`, not in new tab but in the split that was originally opened

 4. the fastest way to seach an entire project folder:
    `nvim -q<(ag "new BrowserWindow" **)`
    → use quickfix to navigate results

  * a recursive grep + fzf
  `grep -r nyaovim ~/.vim | fzf` or `grep -r nyaovim . | fzf`
  then type "init Plug" and `j/k` select this path
  /Users/andreas.thoelke/.vim/init.vim:Plug 'andreasthoelke/nyaovim-markdown-preview'

  * `q/` search history
  * `HelpGrep` to seach vim help (rename?)

  " This works pretty well. could reuse for other purposes
  command! Todo Grepper -tool git -query -E '(TODO|FIXME|XXX):'

  Populate arglist with Dirvish, then use `##` special symbol to search through these files
  read: Tip 13: Searching Files with Grep-Alikes

  document regex/wildcards in search. e.g. "/eins.*zwei"
  how is this consistent with ctrlp filename search?
  → there is a note about globs already
  Regex example:
  `/(^cr|exe$)/gm`
  1. the global and multiline expression flags are on
  2. `^` defines that the `cr` string is only matched at a *beginning* of a line
  3. `$` is only matched if it's at the end of a line.
  http://regexr.com/40v3p

### Search Examples
* Match at beginning of line with optional whitespace
/\v^(\s+)?read
  note that there are other 'read's, see:
  read

* AND: matches in a line containing both "co" and "fi"
/.*co\&.*fi
* OR: match 'co' or 'fi'
/co\|fi

* Lookarounds
  are just asserting the presense of groups, they dont consume/return the characters
This will match 'e's when followed by a space, but dont match the space
/\ve(\s)@=
/\ve(\s)@!
/\ve(\s)
/e

call matchadd('Error', 'e', -1, -1 )
call matchadd('Error', '\vAPPLE([A-Z\s]*\))\@!', -1, -1 )
call matchadd('MatchParen', '\vAPPLE', -1, -1 )
call matchadd('MatchParen', '\vstate\.\zs\w{-}\ze\_s', -1, -1 )
call clearmatches()


APPLE (BANANA) APPLE (ORANGE)
(BANANA APPLE APPLE ORANGE)
APPLE APPLE APPLE
(APPLE ORANGE BANANA)
APPLE (APPLE)
PINEAPPLE
(BANANA APPLE)
() APPLE ()
(ORANGE KIWI
APPLE
KIWI)
(ORANGE APPLE) APPLE

/\v'([^']*)'
call matchadd('MatchParen', "\v'([^']*)'", -1, -1 )

* ignore text in brackets
Note there is a solution now:
let g:pttnArrowOutsideParan = '\(([^)]*\)\@<!->\([^(]*)\)\@!'
let g:pttnArrowOutsideParanUnicode = '\(([^)]*\)\@<!→\([^(]*)\)\@!'
call matchadd('MatchParen', '\(([^)]*\)\@<!->\([^(]*)\)\@!', -1, -1 )
" TODO replicate this with PatternToMatchOutsideOfParentheses()

/\ve([\[\]].*\])@!

call search('on\@!')

call search('on\@!')

aon bo cdf

/\ve[{]*\@=

ae  ase  fde
ae { ase } fde

 some elem <in elim br> and end elem

 some elem (in elem br) and end elem

 some elem [in elem br] and end elem

 some elem [in elem br] aTd end elem


* Testing with `matchadd` test
  this only highlights the 'e's not the following (obligatory!) space!
call matchadd('MatchParen', '\ve(\s)@=', -1, -1 )
* prevent matches (in brackets) - but not outsider (other) -- [this e actually works!!]
call matchadd('MatchParen', '\ve(.*\])@!', -1, -1 )
call matchadd('MatchParen', "\(T.*\)\@_!e", -1, -1 )

### Negative Lookaheads / lookbacks
* does not match before a ")" .. see?!
call matchadd('MatchParen', '\ve(.*\))@!', -1, -1 )
call matchadd('MatchParen', 'e\(.*)\)\@!', -1, -1 )

* does not match after a "(" .. see?!
call matchadd('MatchParen', '\((.*\)\@<!e', -1, -1 )

* does not match after a "(" and before ")" ... see!? (my biggest regex achievement .. ) - as of june 2019
call matchadd('MatchParen', '\(([^)]*\)\@<!e\([^(]*)\)\@!', -1, -1 )

                                     | ← this does not seem needed but logically belongs here
call matchadd('MatchParen', '\(([^)]*(\)\@<!e\([^(]*)\)\@!', -1, -1 )

* does → not match → after a "(" and → before ")" ... → see!? (my biggest regex → achievement .. ) - as of → june 2019
call matchadd('MatchParen', '\(([^)]*\)\@<!→\([^(]*)\)\@!', -1, -1 )

func! PatternToMatchOutsideOfParentheses( searchStr )
  return '\(([^)]*\)\@<!' . a:searchStr . '\([^(]*)\)\@!'
endfunc

func! PatternToMatchOutsideOfParentheses( searchStr, openStr, closeStr )
  return '\(([^' . a:closeStr . ']*' . a:openStr . '\)\@<!' . a:searchStr . '\([^' . a:openStr . ']*' . a:closeStr . '\)\@!'
endfunc
" prevent matches (in brackets) - but not outsider (other) -- [this e actually works!!] (elems)
call matchadd('MatchParen', PatternToMatchOutsideOfParentheses( 'e', '(', ')' ), -1, -1 )
call matchadd('MatchParen', PatternToMatchOutsideOfParentheses( 'e', '\[', '\]' ), -1, -1 )


call matchadd('MatchParen', '[^(]', -1, -1 )

call clearmatches()

* Set start of match with `\sz` [use `\se` to set end of match]
call matchadd('MatchParen', '\v^\s*\zs(t|r|a)', -1, -1 )
call clearmatches()

* Search Motion Examples
Move cursor to +2 chars after the end of the match
exec "normal! /hi/e+2\r"
Move cursor to the end of the match and return the line num
echo search( 'get', 'e' )
Jump to a line/column - this does not work with exec normal
echo search( '\%79l\%18c...' )
* Pre-selection: This will highlight a block! Do "/" <esc> before to make sure searchhighlight is on
exec '/\%>500l\%<510l\%>15c'
* Search in block/selecton: This will find 'a's *only* in this block
exec '/\%>500l\%<510l\%>15ca'
but it works in a map
nnoremap <leader>abb /\%79l\%18c...<cr>
match only in a range of columns!
echo search( '\%>10c.\%<20cab' )
ab ab xx ab xx xx ab ab
ab ab xx ab xx xx ab ab
Replace within a range of columns
.+2s/\%>7caa/XX/g
.+1s/\%>2c\%<7caa/XX/g
xx aa cc aa xx

* Limit matches by line and column
let abc = matchadd( 'MatchParen', '\(\s\)\@<=\S\%'.line('.').'l\%>'.(col('.')).'c' )
let abc = matchadd( 'MatchParen', '\(\s\)\@<=\S' )
call matchdelete( abc )
call clearmatches()

* match multiline between div
let abc = matchadd( 'MatchParen', '<div>\_.\{-}</div>' )
note that \_.* would match all text till the end of the buffer!
instead use \{-} after a multiline atom to match asap

<div>
Test if char is space OR '-'
  if getline('.')[0] =~ '\v(\s|-)'
  echo match( 'y', '\v(x|y)')
</div>

two empty lines/ three consecutive \n:
/\v\n{3,}



Consecutive alphanumeric chars
/\v\w{4}
exec "normal! " '/\v\w{4}'

* Lines that NOT/Don't contain/start with a pattern
/\v^(\s*\*)@!
find lines that don't start with this pattern: ^( )@!
any number of spaces \s* followed by either * or >
and then still have a non empty char after that
/\v^(\s*(\*|\>))@!.
/\v^(\s*\*)@!(\s*\>)@!


read/learn about regex in vim
help pattern.txt
http://vimdoc.sourceforge.net/htmldoc/pattern.html

match 
\v\s\zs\w{-}\ze\:\s

  do abc { eins: "some"
         , zwei: 123
         }

"  "\_s" matches space OR newline!

### Demo Seachpair
Skip to the next 'e' when on a lowercase 'e'
   a E b e a (f E a e d) d E a e f E
nnoremap <leader>bb :echo searchpair('(', 'e', ')', 'W', 'IsE()')<cr>
func! IsE()
  return GetCharAtCursor() ==# 'e'
endfunc


#### CtrlP - Args, Buffers, other visit workspaces?
  * how to go back and/or pin/reference the code found?
#### File explorer
#### Exteral Info
  * Documentation
  * Google, websites/ browsertabs
  * Issues, stackoverflow, blogposts

  * most could be brought into vim?
  * otherwise
    * need to copy code via clipboard
    * need separate tab/workspace management

  → a google search for a specific problem produces
    * 3 - 8 tabs
    * several articles that take
      * time to scan
      * need to be re-read after/while implemetation
    * code copy paste
    * captured/ saved with comment with source url/search so it can be found later


### Side by side
#### working simultaniously
 * working back and forth between 2 or more source-code locs
   implementation of code that spans 2 or more distant source-locations (in some or other file)

#### show reference code
 * keep a code example visible/accessible
 * documentation, complementary code

## suspend / resume a task
documentation / multile parts of docs
overview - spin off
taking notes
keep as reference

Search and Explore should produce
  → little splits/ reminders that can be overseen then turned into
    1. a side-by-side/ split
    2. a todo (categorized and prioritised)
    3. a note (categorized and searchable)

### fuzzy file or directory browsing
  * want to preview file before selecting

### code search
  * want to preview/explore sourrounding code before
    * marking/pinning

this includes code search in past commits/ may result in checking out a file


* searching/ browsing/ scanning
then
* pinning to resume later
then
  * arrange in workspace - for side by side work
  * make todo or note

search and file explore is a progressive filtering process

marking/ pinning should have references (not copies) and previews

I might need/want
## a drawer/ stack of
   * previews
   * notes
   * references (urls, code)

## Preview window
  * `h preview-window`
  * `psearch <tagname>` opens a preview win with the target of the tag under the cursor
  * `c-w z` closes the preview window
  * see [Tags](#Tags), [Notes: Tags](notes29-09.md#Tags)


## Navigating markdown files
see/align with Github wiki repository
  * `]]` `[[` next/prev header
  * `to`, `to` to open and go to tagbar toc (use instead of `:Toc` command)
    * then `p` on a heading to focus the heading in the editor window while staying in tagbar
    * the `q` to close tagbar and have the cursor on the heading in the left window

### Create hyperlink to header
now there is:
* `LinkRefToClipBoard` command using rel.vim: ~/.vim/utils/utils-general-helpers.vim#/LinkRefToClipBoard%20call


TODO - links don't work any more?
  Use `h rel.txt` to link
    * mapping is `gk`
    * path is relative to the current file or absolute e.g. 
      * `git%20process.md#/Git%20Reset`
      * `~/.vim/notes/git%20process.md#/Git%20Reset`
      * `~/.vim/notes/chrome-cli.js` - `gk` still works here

from any filetype to any search-word: ~/.vimrc#/set whitespace escape: help:rel.txt#/should%20refer
text commit-nts1.txt#/#%20Vimium%20workflow

text [link to header in other .md file](notes29-09.md# Rich Text) next text

use `c-]` (not `ge`) on the link text to navigate hyperlinks and `c-o` to jump back
  text [link to header in other .md file](notes29-09.md# Rich Text) next text
    * note the space after `#` and that only the beginning of the (case sensitive?) header text needs to match
      text [link to header in same file](# Navigating markdown) next text
      text [link to an .md file](notes29-09.md) next text
      text [link to website](http://purescript.org) next text
    * have to use `gx` on either the link text or the url
      text [link to string in other file type](commit-nts1.txt#Command) next text text [link to string in other file type](commit-nts1.txt#Vimium) next text text [link to string in other file type](../utils/termin1.vim#PURESCRIPT) next text
  jump to [Repl eval docs in termin1.vim file](../utils/termin1.vim#Repl Eval Insert:) using relative-back path, not having to escape white space


## Folding
have the entire file (auto)folded, sort of archieves a similar effect? it can highlight (expand) several parts of an
otherwise collapsed [#Preview window] file. and bring some relavant code parts to attention/ mark them by having them open/ active.
- it requires constant expanding collapsing?
- it can't span different files?

explore/search/notes might feed into this

* copy a selection of code (or text)
* include file location or url+header
* add notes
* add tags
* add prio/reminder

this could be one long buffer that can be filtered easily

arglists and marks:
 * allow to swap content of splits
 * may want to have a stack with name/label/line-preview visible
 * want more destinct select than [a ]a? or is this 'a 'b 'c?

     marks would allow to include exact locs
     ideally would want to be per tab
     but allow to pull in marks from other tabs



## Code Movement, Motions, Editing

### CodeMarkup & HsMotions

#### Headings & Labels
T s-T Heading
q s-q Label

#### Paragraph
c-l h Paragraph| ParagVim }{
z-j k Fold

#### Toplevel-fn & Area
c-n p Toplevel
c-m i Area

#### Column, Comma & Line
I Y ColumnRight
t s-t Comma| ,t ,s-t IntoComma
J K LineStart

#### Small & Big Hs Words
W B Expression
w b HsWord


### Line
  * line text object `al` `il`

### Targets
  * Pairwise: `i)` `a)` `I)` `A)`
  * Next/Last pairwise: `in)` `c2in)` change 2 inside next parentheses
  * Seek: `vI)` selects "eins" from here: X
    > ( eins ), ( zwei ), ( drei)
  * Separator: `i,` `a,` `I,` `A,`
  * Arguments: `ia` `aa` `Ia` `Aa`

### CamelCaseMotion
  Use e.g. `v2i,w`, `vi,e`, `v,b,b,b`
  Example:
    > script_31337_path_and_name_without_extension_11
    > set Script31337PathAndNameWithoutExtension11=%~dpn0
    > v3iw selects script_31337_path_and_[name_without_extension_]11
    > v3ib selects script_31337_[path_and_name]_without_extension_11
    > v3ie selects script_31337_path_and_[name_without_extension]_11
    > Note there are no "around" textobjects

### Deleting parts of a line
  * delete till end of the line `C` or `d$`
  * delete all chars `cc` or `dD`
  * delete line `dd`


### EasyClip notes
  * delete does not change clipboard, but <localleader>d does
  * `S` substitute motion
  * yank stack use with <leader>"<regnum>
    * persisted and shared with vim instances

> Exercise: Sort these arguments
fnName( drei, zwei, eins, vier)
fnName( eins, zwei, drei, vier)
fnName( drei, zwei, eins, vier)
> Solution:
let @r='yIaWWyw"1SwBBSw0j'
nmap <leader>ab :normal yIaWWyw"1SwBBSw0j<cr>
> use @@ to rerun the macro


