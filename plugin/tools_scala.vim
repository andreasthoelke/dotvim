" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_scala#bufferMaps()

  nnoremap <silent><buffer>         gew :call Scala_SetPrinterIdentif( v:false )<cr>
  nnoremap <silent><buffer>         gee :call Scala_SetPrinterIdentif( v:true )<cr>

  nnoremap <silent><buffer>         gep :call Scala_RunPrinter()<cr>
  nnoremap <silent><buffer>         gei :call Scala_RunPrinter()<cr>
  nnoremap <silent><buffer> <leader>gei :call Scala_RunPrinterInTerm()<cr>
  " nnoremap <silent><buffer>         gep :call Scala_RunPrinter()<cr>:call T_DelayedCmd( "call Scala_SyntaxInFloatWin()", 4000 )<cr>

  nnoremap <silent><buffer>         gss :call Scala_SetServerApp_ScalaCLI()<cr>
  nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>
  nnoremap <silent><buffer>         <leader>gsr :call Scala_ServerRestartTerm()<cr>
  nnoremap <silent><buffer>         gsS :call Scala_ServerStop()<cr>
  " nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>:call Scala_ServerClientRequest_rerun()<cr>
  " nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>:call T_DelayedCmd( "call Scala_ServerClientRequest_rerun()", 4000 )<cr>
  nnoremap <silent><buffer>         gsf :call Scala_ServerClientRequest('', 'float')<cr>
  nnoremap <silent><buffer>        ,gsf :call Scala_ServerClientRequest( 'POST', 'float' )<cr>
  nnoremap <silent><buffer>         gsF :call Scala_ServerClientRequest('', 'term')<cr>
  nnoremap <silent><buffer>        ,gsF :call Scala_ServerClientRequest( 'POST', 'term' )<cr>

  nnoremap <silent><buffer> <c-p>         :call Scala_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>
  " nnoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>
  " onoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>
  nnoremap <silent><buffer> <leader>(     :call Scala_MvStartOfBlock()<cr>
  onoremap <silent><buffer> <leader>(     :call Scala_MvStartOfBlock()<cr>
  nnoremap <silent><buffer> <leader>)     :call Scala_MvEndOfBlock()<cr>
  onoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>
  vnoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>
  onoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>
  vnoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>

  nnoremap <silent><buffer> * :call MvPrevLineStart()<cr>
  nnoremap <silent><buffer> ( :call MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call MvNextLineStart()<cr>

  nnoremap <silent><buffer> I :call Scala_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Scala_ColonBackw()<cr>

  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <c-n>         :call Scala_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>


  nnoremap <silent><buffer> <leader>gek :call Scala_LspTopLevelHover()<cr>
  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>
  nnoremap <silent><buffer>         gej :lua vim.lsp.buf.signature_help()<cr>
  " this works super nice. there's another (default?) mapping for leader ?
  nnoremap <silent><buffer> <leader>/   :lua require('telescope.builtin').lsp_document_symbols()<cr>
  nnoremap <silent><buffer> ,sl :lua require('telescope.builtin').lsp_document_symbols()<cr>
  " nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({layout_config={vertical={sorting_strategy="ascending"}}})<cr>
  nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({initial_mode='insert'})<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer> ,ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  nnoremap <silent><buffer> ger :lua require('telescope.builtin').lsp_references(require('telescope.themes').get_cursor({initial_mode='normal', layout_config={width=0.95, height=25}}))<cr>
  nnoremap <silent><buffer> geR <cmd>TroubleToggle lsp_references<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  nnoremap <silent><buffer> ge] :lua require("trouble").next({skip_groups = true, jump = true})<cr>
  nnoremap <silent><buffer> ge[ :lua require("trouble").previous({skip_groups = true, jump = true})<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_scala()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

endfunc


func! Scala_LspTopLevelHover()
  let [oLine, oCol] = getpos('.')[1:2]
  normal ^
  call SkipScalaSkipWords()
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

  " /Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/DDaSci_ex/src/main/scala/Printer.scala
  let printerFilePath = 'src/main/scala/Printer.scala'
  " is just the normal Main.scala for now

  " let packageName = split( getline(1), ' ' )[1]
  let packageName = Scala_GetPackageName()

  let hostLn = searchpos( '\v(lazy\s)?val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  let hostLnObj = searchpos( '\v^object\s', 'cnbW' )[0]
  let objName = matchstr( getline( hostLnObj ), '\vobject\s\zs\i*\ze\W' )

  if len( objName )
    let identif = packageName . "." . objName . "." . identif
  endif

  call VirtualRadioLabel_lineNum( '«', hostLn )

  " this just allows to use the simple gew map more often.
  " let typeSign = matchstr( getline(hostLn), '\v(ZIO|Task|RIO|URIO|UIO|CAT)')
  " if len( typeSign )
  "   let forEffect = v:true
  " else
  "   let forEffect = a:forEffect
  " endif

  let forEffect = a:forEffect

  " let importLine = "import " . packageName . "." . identif
  if forEffect
    let bindingLine = "  val printVal = " . identif
  else
    let bindingLine = "  val printVal = ZIO.succeed( " . identif . " )"
  endif

  let printerLines = readfile( printerFilePath, '\n' )
  " let printerLines[0] = importLine
  let printerLines[5] = bindingLine

  call writefile( printerLines, printerFilePath )
endfunc

func! Scala_GetPackageName()
  let hostLn = searchpos( '\v^package\s', 'cnbW' )[0]
  if !hostLn
    return ""
  endif
  " let identif = matchstr( getline(hostLn ), '\vpackage\s\zs\i*\ze\W' )
  let packageName = split( getline( hostLn ), ' ' )[1]
  return packageName
endfunc

func! Scala_SetPrinterIdentif_ScalaCLI( forEffect )
  let printerFilePath = expand('%:h') . '/Printer.scala'

  let hostLn = searchpos( '\v^(lazy\s)?val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  call VirtualRadioLabel_lineNum( '«', hostLn )

  let forEffect = a:forEffect

  let packageName = Scala_GetPackageName()
  if len( packageName )
    let identif = packageName . "." . identif
  endif

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


let g:Scala_ServerCmd = "scala-cli . --main-class PreviewServer --class-path resources"
let g:Scala_PrinterCmd = "scala-cli . --main-class Printer --class-path resources -nowarn"


func! Scala_RunPrinter()
  " let printerFilePath = expand('%:h') . '/Printer.scala'
  let printerFilePath = expand('%:h') . 'src/main/scala/Printer.scala'
  if !filereadable( printerFilePath )
    " Using the running sbt repl session
    call ScalaReplRun()
    return
  endif

  " Use scala-cli
  " let cmd = 'scala-cli ' . expand('%:h')
  " let cmd = 'scala-cli ' . expand('%:h') . ' --main-class Printer --class-path resources'
  let cmd = g:Scala_PrinterCmd
  let resLines = systemlist( cmd )
  call Scala_showInFloat( resLines )
endfunc

func! Scala_filterCliLine( line, accum )
  " filter all lines that contain these words:
  if a:line =~ '\v(compil|warn)'
    return a:accum
  else

    if a:line =~ '\v(RESULT|ERROR)'
      " clean up / select from all lines that contain these words:
      let filteredLineStr = matchstr( a:line, '\v(RESULT|ERROR)\zs.*' )
    else
      " keep all other lines as they are!
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
  " let cmd = 'scala-cli ' . expand('%:h') . ' --main-class Printer'
  let cmd = g:Scala_PrinterCmd
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


" func! Scala_ServerClientRequest( args )
"   let urlExtension = GetLineFromCursor()
"   let g:scala_serverRequestCmd = "curl " . a:args . "http://localhost:8002/" . urlExtension
"   let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
"   silent let g:floatWin_win = FloatingSmallNew ( resultLines[3:] )
"   silent call FloatWin_FitWidthHeight()
"   silent wincmd p
" endfunc

func! Scala_ServerClientRequest( args, mode )
  if GetLineFromCursor() =~ '\v^(val|\/\/)'
    normal w
  endif
  let urlExtension = GetLineFromCursor() 
  " let urlExtension = shellescape( urlExtension, 1)
  let g:scala_serverRequestCmd = "http " . a:args . " :8002/" . urlExtension . " --ignore-stdin --stream"
  if a:mode == 'term'
    call TermOneShot( g:scala_serverRequestCmd )
  else
    let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
    silent let g:floatWin_win = FloatingSmallNew ( resultLines )
    silent call FloatWin_FitWidthHeight()
  endif
  silent wincmd p
endfunc
" http --help
" echo system( "http localhost:8002/fruits/a eins=zwei --ignore-stdin" )
" echo system( "http localhost:8002/users name=zwei age=44 --ignore-stdin" )
" echo system( "curl -X POST localhost:8002/fruits/a --raw eins=zwei" )


func! Scala_ServerClientRequest_rerun()
  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc

let g:Scala_TopLevPattern = '\v^((\s*)?\zs(final|trait|override\sdef|val\s|lazy\sval|case\sclass|enum|final|object|class|def)\s|val)'

func! Scala_TopLevBindingForw()
  normal! }
  call search( g:Scala_TopLevPattern, 'W' )
endfunc

func! Scala_TopLevBindingBackw()
  normal! {
  call search( g:Scala_TopLevPattern, 'bW' )
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc

" call search('\v^(\s*)?call', 'W')

func! Scala_MvStartOfBlock()
  normal! k
  exec "silent keepjumps normal! {"
  normal! j^
endfunc


func! Scala_MvEndOfBlock()
  normal! j
  exec "silent keepjumps normal! }"
  normal! k^
endfunc

func! BlockStart_VisSel()
  normal! m'
  normal! V
  call Scala_MvStartOfBlock()
  normal! o
endfunc


func! BlockEnd_VisSel()
  normal! m'
  normal! V
  call Scala_MvEndOfBlock()
  normal! o
endfunc


let g:Scala_MvStartLine_SkipWords = '\v(val|def|lazy|private|final|override)'
" echo "private" =~ g:Scala_MvStartLine_SkipWords

func! SkipScalaSkipWords()
  let cw = expand('<cword>')
  if cw =~ g:Scala_MvStartLine_SkipWords
    normal! w
    call SkipScalaSkipWords()
  endif
endfunc

func! MvLineStart()
  normal! m'
  normal! ^
  call SkipScalaSkipWords()
endfunc

func! MvNextLineStart()
  normal! m'
  normal! j^
  call SkipScalaSkipWords()
endfunc

func! MvPrevLineStart()
  normal! m'
  normal! k^
  call SkipScalaSkipWords()
endfunc

let g:Scala_colonPttn = MakeOrPttn( ['\:\s', '\/\/', '*>', '-', '=', 'yield', 'then', 'else', '\$'] )

func! Scala_ColonForw()
  call SearchSkipSC( g:Scala_colonPttn, 'W' )
  normal w
endfunc

func! Scala_ColonBackw()
  normal bh
  call SearchSkipSC( g:Scala_colonPttn, 'bW' )
  normal w
endfunc





