## Release notes v1.2
Initial Purescript setup:
- Coc-nvim
- PsAPI browse
- sparo repl
  * getting types of variables via type holes into floating window
- fuzzy search via language server call (gsD map)

see documentation/notes here:
  .vim/notes/notes-commands-nav.md
  .vim/notes/purs-setup.md


## Release notes v1.1.2
* syn match infixBacktick with enclosed conceals
* J/K map - Word column corners Forw/Backw (based on aligned visibleColumns)
* Gen_opfunc2: applying a function via an operator map, visual selection and command  ~/.vim/plugin/code-line-props.vim#/Vim%20Pattern.%20For
* sort (type-sig HsAPI) columns with c-v Vissort
* command: CabalInfo 'these-0.7.6'
* StripAligningSpaces
* echo pyeval('getHSPackageDependencies()')
* Start moving files & refactoring to use runtimepath/.vim/plugin/ & .vim/autoload/
* Template for simple range/operator/line-motion support: ~/.vim/plugin/file-manage.vim#/Toggle%20arglist%20items.
* Arglist can be shown in CtrlP. Files can be opened and items deleted with <c-s>
* AlignTypeSig opfunc ~/.vim/utils/utils-align.vim#/func.%20AlignTypeSigs_op.%20motionType,
* Show (synchronous) shell commands in FloatingWin: <leader>Sgs :call ShellReturn( 'git status' )
* Hpack workflow doc: ~/.vim/notes/notes-workflow.vim#/Use%20Hpack%20to
* InsertLeave jumps to insert-start. Revert this with `g;` - jumps to end of last insert
* Conealed anonymous toplevel (test-) binds: ~/.vim/plugged/purescript-vim/syntax/purescript.vim#/Concealed%20TL-Binds
* Hlint ignore warning comment conceal: ~/.vim/plugged/purescript-vim/syntax/purescript.vim#/syntax%20match%20concealHlintComment
* `LinkRefToClipBoard` command using rel.vim: ~/.vim/utils/utils-general-helpers.vim#/command.*%20LinkRefToClipBoard%20call
* Syntax highlighting for rel links: ~/.vim/utils/HsSyntaxAdditions.vim#/func.*%20VimScriptSyntaxAdditions
* document updating HIE: ~/.vim/notes/notes-workflow.vim#/Update%20HIE%20■
* `glm`/`gsm` to start/stop iamcco/markdown-preview.nvim
* `ged` for LanguageClient diagnostics (hlint, ghcmod). see ShowLC_Diagnostics() ~/.vim/utils/tools-langClientHIE-completion.vim#/func.%20s.showLC_Diagnostics.%20stateJSON
* `\,` + motion (or vis-sel with "v") indents the lines to the current cursor-horz position. `\,l`/`j`/`}` to indent the current line/two lines/block
* zsh syntax highlight colors
* zsh consistent `ls` and completion ANSI colors
* Intero ShowList_asLines() in floating window with column alignment (`gec`, `geC`, `gel`)
* `leader lm` to open LanguageClient menu, `leader la` to show the available code actions
* Shortcuts to popular folders <leader>o .. `n` notes, `u` utils, `h` haskell, `c` current
* Indent motions: `,j` `,k` to move to end/start of indent block. IndentBlockEnd() HsMotions
*                 `,J` `,K` to move to the next/prev same level indent
*                `vii` to visually select inside indent block
* Align maps:
`leader al` + [motion, textobject: e.g. `ii` "inside indent block"]
              + speperatorId (<space>, 2<space>, "," )
              see: ~/.vim/notes/notes-navigation.md#/##%20Align
* Tabularize 1st and 2nd column of a motion or selected range of lines based on <space>
`leader at` + [range]
* Repl format: `gew` does just append all repl returned lines
* `gel` "eval list" on a Haskell identifier will insert a resulting list as lines. see PasteListAsLines()
* `get` "eval table": After "eval list", it then aligns the first two columns (column separator is <space>)
* `geT` "tabularizes" the output
* `gek` to inset the `Kind` (visual-sel and word at cursor)
* `\tw` or `\tt` to get the type of the identifier
* `localleader hs` creates a haskell top level function stub with a random and indexed name (used for quick tests). `\hS` also add a type-sig stub
* Use feedkeys to activate modes: e.g. call feedkeys("\<c-v>", 'x') see VisualBlockMode()
* `]b`, `[b` for next/prev binding
* `cib` to change the binding name in consequtive lines
* `<leader>rb` to rename a binding and its occurences
* `iB` "inside buffer" textobject
* `iv` "inside viewable" area in window textobj
* `leader hsi` "Haskell style imports" (fromatting import lines using stylish-haskell)
* `<c-x>f` in a file path, in insert mode browses files (vim native!)
* createHeading `\ch`, closeSection `\cs`, delete/strip Heading `\cd`, refreshHeading `\cr`
* conceal unicode symbols: `⫩ ⫦ ◇ ⟐` for `<$> >>= <> <*>`

## Release notes v1.1.1 (2019-04-20)
* Command to search in deleted code: `Fdeleted someString`
* Search in groups of files: `Frepo Fbuffers Fvim Flug Fhask Fnotes Fdeleted`
* restucture vimrc into separate files
* easymotion for paragraph: `<localleader><c-h/l>`
* `,L` `,H` to jump bottom/top of visible area
* `Viv` selects the visual area, `yis` copies the visual area. See Textobjects
* so a regex search then `\r`+`ie``iv``if` to replace matches with prompted text. see ReplaceLastPattern
* `ga` on a word and then `\riv` replaces that word with prompted text
* end of paragraph motion/OpPending `,<c-h/l`
* next/pre arguments movement with `,a`, `,A` - localleader for current arg
* show no-scrollbar-vim in lightline
* set foldtext=DefaultFoldtext()
* SourceVimL Operator function allows e.g.
  * <leader>saf "source around function"
  * <leader>si" "source inside quotes"
* `glt` in dirvish buffers cds new terminal into dirvish folder
* conceal character indicating hs-function foldmarkers
* `<leader>pe` does PasteLastEchoText
* fix bug in easyclip that scrolled buffer to the top
* `c-n/p` jumps to main haskell definitions applying a useful scrolloffset
* `zH` `zL` shifts cursor line to the top/bottom of visible area

## Release notes v1.1.0
* Skip cursor-rest jump if cursor hasn't moved (unfortunate fix)
* add to jumplist on updatetime and ex-command (;/:)
* camelCaseMotion use `,` leader e.g. `v2i,w`, `vi,e`, `v,b,b,b`
* go to insert start at InsertLeave (deactivated now), save insert end to jumplist
* `,ti` to insert type hole to get the type of a do bind. `,tu` to undo
* intero neovim custom functions e.g. `InsertEvalExpressionRes` are now in forked repo

## Release notes v1.0.5
* close win above, below, left, right with `<c-w>d`: `k/j/h/l`
* Pinning paragraphs and visual selections with `<leader>wp` (visual-split plugin)
* Indenting settings
* CamelCaseMotion plugin. Use e.g. `v2iw`, `vie`, `vbbb`
* Add every yank position to the jumplist. In EasyClip with tag "AT tweak:"
* Add start of visual mode (`v`) to jumplist
* Add line motions to jumplist
* Only the start of 'select word' `ga` next and search adds to the jumplist
* line text object `al` `il`
*  (HEAD -> master) Note taking, jumplist, indention                                                                                                          5 hours ago   Andreas Thoelke  [d24bfe4]

## Release notes v1.0.4
* doc vim-targets, substitute motion
* vim-better-whitespace plugin
* easyclip:
  * delete does not change clipboard, but <localleader>d does
  * `S` substitute motion
  * yank stack use with <leader>"<regnum>
  * persisted and shared with vim instances
* close all Markbar wins on VimLeave [cleanup](../../.vimrc#Cleanup:)
* include file-local marks
* refresh shada to avoid deleted global marks re-apear after vim-restart
* ctrlP MRU map to `gp`
* dont jump to markbar win on open
* use `c-w \ ` to jump to rightmost/mark/tag bar window and `c-w p` to jump back
* defining links in code with `h rel-links` like ~/.vimrc#/Rel%20Links: using `gk`

old: .vim/notes/commit-nts1.txt
