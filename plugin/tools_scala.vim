" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_scala#bufferMaps()

  nnoremap <silent><buffer>         gew :call Scala_SetPrinterIdentif( v:false )<cr>
  nnoremap <silent><buffer>         gee :call Scala_SetPrinterIdentif( v:true )<cr>

  nnoremap <silent><buffer>         gep :call Scala_RunPrinter()<cr>
  nnoremap <silent><buffer>         gei :call Scala_RunPrinter()<cr>
  nnoremap <silent><buffer> <leader>gei :call Scala_RunPrinterInTerm()<cr>
  " nnoremap <silent><buffer>         gep :call Scala_RunPrinter()<cr>:call T_DelayedCmd( "call Scala_SyntaxInFloatWin()", 4000 )<cr>

  nnoremap <silent><buffer>         gss :call Scala_SetServerApp_ScalaCLI()<cr>
  " after changing the http app, this compiles and restarts the server *and* refetches the previous http client request
  " refetching is now triggered in the server callback
  nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>
  nnoremap <silent><buffer>         <leader>gsr :call Scala_ServerRestartTerm()<cr>
  nnoremap <silent><buffer>         gsS :call Scala_ServerStop()<cr>
  " nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>:call Scala_ServerClientRequest_rerun()<cr>
  " nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>:call T_DelayedCmd( "call Scala_ServerClientRequest_rerun()", 4000 )<cr>
  nnoremap <silent><buffer>         gsf :call Scala_ServerClientRequest()<cr>
  nnoremap <silent><buffer>         gsF :call Scala_ServerClientRequest2()<cr>

  nnoremap <silent><buffer> <c-p>         :call JS_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <leader><c-n> :call JS_MvEndOfBlock()<cr>
  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <c-n>         :call JS_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>


  nnoremap <silent><buffer> <leader>gek :call Scala_LspTopLevelHover()<cr>
  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_scala()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

endfunc


func! Scala_LspTopLevelHover()
  let [oLine, oCol] = getpos('.')[1:2]
  normal ^w
  if expand('<cword>') =~ '\v(val|def)'
    normal w
  endif
  lua vim.lsp.buf.hover()
  call setpos('.', [0, oLine, oCol, 0] )
endfunc

" NOTE: deleted several JS motions and commands. i might want to copy
" and adapt these to scala at one point
" other motions: ~/.config/nvim/plugin/HsMotions.vim#/Just%20a%20new

" Process: import identif into runPrinter.ts, build --watch will update runPrinter.js
" - source file:   packages/app/src/mySourceFile.ts
" - printer:       packages/app/src/runPrinter.ts
" - module:        @org/app/mySourceFile
" - printer (run): packages/app/build/esm/runPrinter.js

func! Scala_SetPrinterIdentif( forEffect )
  let printerFilePath = expand('%:h') . '/Printer.scala'
  if filereadable( printerFilePath )
    call Scala_SetPrinterIdentif_ScalaCLI( a:forEffect )
  else
    call Scala_SetPrinterIdentif_SBT( a:forEffect )
  endif
endfunc

func! Scala_SetPrinterIdentif_SBT( forEffect )

  let printerFilePath = 'src/main/scala/Main.scala'
  " is just the normal Main.scala for now

  let packageName = split( getline(1), ' ' )[1]
  " this will get e.g. 'azio.abbcc'. it's independent from the file/folder - scala handles this.

  let hostLn = searchpos( '\v^(lazy\s)?val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  call VirtualRadioLabel_lineNum( '«', hostLn )

  " this just allows to use the simple gew map more often.
  " let typeSign = matchstr( getline(hostLn), '\v(ZIO|Task|RIO|URIO|UIO|CAT)')
  " if len( typeSign )
  "   let forEffect = v:true
  " else
  "   let forEffect = a:forEffect
  " endif

  let forEffect = a:forEffect

  let importLine = "import " . packageName . "." . identif
  if forEffect
    let bindingLine = "val printVal = " . identif
  else
    let bindingLine = "val printVal = ZIO.succeed( " . identif . " )"
  endif

  let printerLines = readfile( printerFilePath, '\n' )
  let printerLines[0] = importLine
  let printerLines[1] = bindingLine

  call writefile( printerLines, printerFilePath )
endfunc

func! Scala_SetPrinterIdentif_ScalaCLI( forEffect )
  let printerFilePath = expand('%:h') . '/Printer.scala'

  let hostLn = searchpos( '\v^(lazy\s)?val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  call VirtualRadioLabel_lineNum( '«', hostLn )

  let forEffect = a:forEffect

  if forEffect
    let bindingLine = "val printVal = " . identif
  else
    let bindingLine = "val printVal = ZIO.succeed( " . identif . " )"
  endif

  let printerLines = readfile( printerFilePath, '\n' )
  let printerLines[1] = bindingLine

  call writefile( printerLines, printerFilePath )
endfunc

func! Scala_SetServerApp_ScalaCLI()
  let printerFilePath = expand('%:h') . '/PreviewServer.scala'

  let hostLn = searchpos( '\v^(lazy\s)?val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  call VirtualRadioLabel_lineNum( '✱', hostLn )

  let bindingLine = "val previewApp = " . identif

  let printerLines = readfile( printerFilePath, '\n' )
  let printerLines[1] = bindingLine

  call writefile( printerLines, printerFilePath )

endfunc




func! Scala_RunPrinter()
  let printerFilePath = expand('%:h') . '/Printer.scala'
  if !filereadable( printerFilePath )
    " Using the running sbt repl session
    call ScalaReplRun()
    return
  endif

  " Use scala-cli
  " let cmd = 'scala-cli ' . expand('%:h')
  let cmd = 'scala-cli ' . expand('%:h') . ' --main-class Printer'
  let resLines = systemlist( cmd )
  call Scala_showInFloat( resLines )
endfunc

func! Scala_filterCliLine( line, accum )
  if a:line =~ '\v(compil)'
    return a:accum
  else

    if a:line =~ '\v(RESULT|ERROR)'
      let filteredLineStr = matchstr( a:line, '\v(RESULT|ERROR)\zs.*' )
    else
      let filteredLineStr = a:line
    endif
    return add( a:accum, filteredLineStr )

  endif
endfunc

func! Scala_showInFloat( data )
  let lines = RemoveTermCodes( a:data )

  if !len( lines )
    return
  endif

  " let resultVal = matchstr( lines[0], '\v(RESULT)\zs.*' )

  " let result = functional#foldr( {line, accum -> accum . matchstr( line, '\v(RESULT|ERROR)\zs.*' ) }, "", lines )
  let result = functional#foldr( function("Scala_filterCliLine") , [], lines )

  silent let g:floatWin_win = FloatingSmallNew ( result )
  call ScalaSyntaxAdditions() 
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfun


func! Scala_RunPrinterInTerm()
  let cmd = 'scala-cli ' . expand('%:h') . ' --main-class Printer'
  call TermOneShot( cmd )
endfunc
" scala-cli . --main-class PreviewServer


" ─   " PreviewServer                                   ──
" async running process scala-cli . --main-class PreviewServer
" can be started in term (to debug) or as job (invisible)
" no need for callback handlers
" can be jobstop'ed and restarted with new compiled scala-cli . --main-class PreviewServer

func! Scala_ServerRestart ()
  if !exists('g:Scala_ServerID')
    call Scala_ServerStart()
  else
    call Scala_ServerStop()
    call Scala_ServerStart()
  endif
endfunc

func! Scala_ServerRestartTerm ()
  if !exists('g:Scala_ServerID')
    call Scala_ServerStartT()
  else
    call Scala_ServerStop()
    call Scala_ServerStartT()
  endif
endfunc


func! ScalaServerMainCallback(job_id, data, event)
  " call Scala_ServerClientRequest_rerun()
  " call T_DelayedCmd( "call Scala_ServerClientRequest_rerun()", 1000 )
  return
  let lines = RemoveTermCodes( a:data )
  if !len( lines )
    return
  endif
  silent let g:floatWin_win = FloatingSmallNew ( lines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


let g:Scala_ServerCmd = "scala-cli . --main-class PreviewServer"

let g:ScalaServerCallbacks = {
      \ 'on_stdout': function('ScalaServerMainCallback'),
      \ 'on_stderr': function('ScalaReplErrorCallback'),
      \ 'on_exit': function('ScalaReplExitCallback')
      \ }


func! Scala_ServerStart ()
  if exists('g:Scala_ServerID') | call T_echo( 'Scala_Server is already running' ) | return | endif
  silent let g:Scala_ServerID = jobstart( g:Scala_ServerCmd, g:ScalaServerCallbacks )
endfunc

func! Scala_ServerStartT ()
  if exists('g:Scala_ServerID') | call T_echo( 'Scala_Server is already running' ) | return | endif
  exec "8new"
  let g:Scala_ServerID = termopen( g:Scala_ServerCmd )
  silent wincmd p
endfunc


func! Scala_ServerStop ()
  if !exists('g:Scala_ServerID') | call T_echo( 'Scala_Server is not running' ) | return | endif
  silent call jobstop( g:Scala_ServerID )
  unlet g:Scala_ServerID
endfunc


func! Scala_ServerClientRequest()
  let urlExtension = GetLineFromCursor()
  let g:scala_serverRequestCmd = "curl " . "http://localhost:8002/" . urlExtension
  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines[3:] )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc

func! Scala_ServerClientRequest2()
  let urlExtension = GetLineFromCursor()
  let g:scala_serverRequestCmd = "http " . "GET :8002/" . urlExtension
  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


func! Scala_ServerClientRequest_rerun()
  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines[3:] )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc













