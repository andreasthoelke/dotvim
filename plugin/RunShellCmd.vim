

" ─   Operater Map Example                              ──
" A very typical use case in a text editor is to run an action on a selection of text. In Vim a selection
" of text can be a visual selection or a motion or text object. The following is an example of how to
" set up the related maps in a reusable way.

" These maps save the selected text to a "CmdArg" global variable. The first map expects motion or text-object
" keystrokes (e.g. <leader>raf "around function", <leader>ri" "inside quotes").
nnoremap <leader>R    m':let g:opContFn='SaveToCmdArgVar'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
vnoremap <leader>R :<c-u>let g:opContFn='SaveToCmdArgVar'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>

" This function is used as a generic opfunc (a function that runs in an operator map).
" It copies the text of the motion or visual selection and applies the g:opContFn continuation function to it.
" g:opContArgs is a list of (optional) additional arguments to be applied to g:opContFn function.
func! OperateOnSelText( motionType, ...)
  " Use either the vis-select or the motion marks
  let [startMark, endMark] = a:0 ? ["'<", "'>"] : ["'[", "']"]
  " Line and column of start+end of either vis-sel or motion
  let [startLine, startColumn] = getpos( startMark )[1:2]
  let [endLine,   endColumn]   = getpos( endMark )[1:2]
  " echo a:motionType . ' ' . startLine . ' ' . startColumn . ' ' . endLine . ' ' . endColumn
  let [startColumn, endColumn] = (a:motionType == 'line') ? [1, 200] : [startColumn, endColumn]
  let selectedText = GetTextWithinLineColumns_asLines( startLine, startColumn, endLine, endColumn )
  " call append( line('.'), GetTextWithinLineColumns_asLines( startLine, startColumn, endLine, endColumn ) )
  call call( g:opContFn, g:opContArgs + [selectedText] )
  " Flash the sourced text for 500ms
  call highlightedyank#highlight#add( 'HighlightedyankRegion', getpos(startMark), getpos(endMark), a:motionType, 500)
endfunc

" The side-effecting function (action)
func! SaveToCmdArgVar ( listOfStrings )
  let g:commandArgument1 = a:listOfStrings
  " call FloatWinAndVirtText( a:listOfStrings )
endfunc

" Clear the "CmdArg"
nnoremap <leader><leader>R :unlet g:commendArgument1<cr>

" ─^  Operater Map Example                              ▲




nnoremap <leader>r    m':let g:opContFn='SaveToCmdArgVar'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
vnoremap <leader>r :<c-u>let g:opContFn='SaveToCmdArgVar'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>



  " if exists('g:commandArgument1')
  " unlet g:commandArgument1

" Syc & show: Run terminal command and show result in float-win
" - return result of command to float win. example 'ls -a'
" Async launch: Launch an app/service. Pass params, no return vals, no interaction
" - vs code, mpv
" - ytdl, youtube-dl  - they should notify when done. but may take a long time to finish. and there may be a list. - progress indicator in terminal
" Interactive:
" - node repl

" Input param: (visible in menu)
" a single path, url or strings
" - vis sel
" - from cursor to end of line

" Commands:
" i'll list all commands (including tricky options).
" most commands will only have one useful mode - syc with return, asyn (with progress or without),
" interactive - so this will be encoded in the menu option


" TODO the RunShellCommand function can have option flags with if test and then get this param by input()

" func! HsAlignUC( ... )
"   let startLine = a:0 ? a:1 : 1
"   let endLine = a:0 ? a:2 : line('$')
"   call UserChoiceAction('Align to:', {}, g:alignTempl, function('HsAlignAp'), [startLine, endLine])
" endfunc

" func! HsAlignAp( startLine, endLine, ucProps )
"   call HsAlign( a:ucProps.pttns, a:startLine, a:endLine )
" endfunc

" let g:alignTempl = [
"       \  {'label':'_space',     'pttns': ['/ / {"left_margin": 0, "right_margin": 0}']}
"       \, {'label':'_= equal',   'pttns': ['=']}
"       \, {'label':'_, comma',   'pttns': ['/\,/']}
"       \, {'label':'_<- bind',   'pttns': ['/<-/']}
"       \, {'label':'_> case',   'pttns': ['/->/']}
"       \, {'label':'_type sigs', 'pttns': g:pttnsTypeSigs4}
"       \]

" Run %{expand('%:t')}"

" let g:quickmenu_options = "LH"
" call quickmenu#toggle(0)

" let content = [
"             \ [ 'echo 1', 'echo 100' ],
"             \ [ 'echo 2', 'echo 200' ],
"             \ [ 'echo 3', 'echo 300' ],
"             \ [ 'echo 4' ],
"             \ [ 'echo 5', 'echo 500' ],
"             \]
" let opts = {'title': 'select one'}
" call quickui#listbox#open(content, opts)
"
" let linelist = [
"             \ "line &1",
"             \ "line &2",
"             \ "line &3",
"             \ ]
" " restore last position in previous listbox
" let opts = {'index':g:quickui#listbox#cursor, 'title': 'select'}
" echo quickui#listbox#inputlist(linelist, opts)
"
" call quickui#menu#install('&File', [
"             \ [ "&New File\tCtrl+n", 'echo 0' ],
"             \ [ "&Open File\t(F3)", 'echo 1' ],
"             \ [ "&Close", 'echo 2' ],
"             \ [ "--", '' ],
"             \ [ "&Save\tCtrl+s", 'echo 3'],
"             \ [ "Save &As", 'echo 4' ],
"             \ [ "Save All", 'echo 5' ],
"             \ [ "--", '' ],
"             \ [ "E&xit\tAlt+x", 'echo 6' ],
"             \ ])
"
" call quickui#menu#install('&Edit', [
"             \ [ '&Copy', 'echo 1', 'help 1' ],
"             \ [ '&Paste', 'echo 2', 'help 2' ],
"             \ [ '&Find', 'echo 3', 'help 3' ],
"             \ ])
"
" call quickui#menu#open()
" let g:quickui_show_tip = 1
"
" call quickui#tools#list_buffer('tabedit')
" call quickui#tools#list_function()
" call quickui#tools#display_help('index')
" call quickui#tools#display_help('window')
" nnoremap <F3> :call quickui#tools#preview_tag('')<cr>
"
" let g:quickui_border_style = 3
" let g:quickui_color_scheme = 'munsell-blue-molokai'
"
" function! TermExit(code)
"     echom "terminal exit code: ". a:code
" endfunc
" let opts = {'w':60, 'h':8, 'callback':'TermExit'}
" let opts.title = 'Terminal Popup'
" call quickui#terminal#open('ls -a', opts)


" Run query on site
"
" → {'identifier': 'UserChoiceAction'}
"
" Docs
"
" [s]  Stackage
" [h]  Hoogle
" [p]  Pursuit
" [t]  T Starsuit Pursuit
"
" Web help/ posts
"
" [b]  Book Purscript
" [m]  M Jordan Reference
" [g]  Google
" [r]  Redit Haskell
" [1]  Github code
" [2]  Github package (repo)
" [3]  Github issues
" [4]  Hs Code Explorer (Hackage search + browse)
" [5]  Aelve (Hackage code search)
"
" [0]  <close>



" ─   Config Shell Commands                              ■

let g:shellCmdsCfg =  [ {'section':'Docs'} ]

let g:shellCmdsCfg += [ {'label':'_Stackage',   'baseUrl':'https://www.stackage.org/lts-14.1/'
      \, 'module_mainTerm':'hoogle?q='
      \}]

let g:shellCmdsCfg += [ {'section':'Web help/ posts'} ]



" ─^  Config Shell Commands                              ▲



