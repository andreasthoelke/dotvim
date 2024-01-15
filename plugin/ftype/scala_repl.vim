


" ─   SBT Printer                                        ■

nnoremap <silent> <leader><leader>sp :call SbtPrinterStart()<cr>
nnoremap <silent> <leader><leader>sP :call SbtPrinterStop()<cr>
nnoremap <silent> <leader><leader>sb :call SbtPrinterReload()<cr>
nnoremap <silent> <leader><leader>si :MetalsImportBuild<cr>

" ex g:ScalaReplID


func! SbtPrinterStart ()
  if exists('g:SbtPrinterID')
    echo 'SbtPrinter is already running'
    return
  endif
  exec "new"
  let g:SbtPrinter_bufnr = bufnr()

  let opts = { 'cwd': getcwd( -1, -1 ) }
  let opts = extend( opts, g:SbtPrinterCallbacks )
  let g:SbtPrinterID = termopen('sbt', opts)
  silent wincmd c
endfunc

func! SbtPrinterReload ()
  if !exists('g:SbtPrinterID')
    echo 'SbtPrinter is not running'
    return
  else
    echo 'reloading ..'
  endif
  let cmd = "reload" . "\n"
  call ScalaSbtSession_RunMain( g:SbtPrinterID, cmd )

  " .. perhaps not needed(?)
  if exists('g:SbtLongrunID')
    call ScalaSbtSession_RunMain( g:SbtLongrunID, cmd )
  endif
endfunc

" g:SbtPrinterID
" g:SbtPrinter_bufnr

func! SbtPrinterStop ()
  if !exists('g:SbtPrinterID')
    echo 'SbtPrinter is not running'
    return
  endif
  call jobstop( g:SbtPrinterID )
  unlet g:SbtPrinterID
  unlet g:SbtPrinter_bufnr
endfunc



" ─^  SBT Printer                                        ▲



" ─   SBT long-running                                   ■
" This allows to lauch a second sbt process. This might be a long running
" server app while the first sbt process above can be used for short calls and requests.

" ex g:ScalaServerReplID

nnoremap <silent> <leader><leader>sl :call SbtLongrunStart()<cr>
nnoremap <silent> <leader><leader>sL :call SbtLongrunStop()<cr>

func! SbtLongrunStart ()
  if exists('g:SbtLongrunID')
    echo 'SbtLongrun is already running'
    return
  endif
  exec "new"
  let g:SbtLongrun_bufnr = bufnr()

  let opts = { 'cwd': getcwd( -1, -1 ) }
  let opts = extend( opts, g:SbtPrinterCallbacks )

  let g:SbtLongrunID = termopen('sbt --client', opts)
  silent wincmd c
endfunc

" g:SbtLongrunID
" g:SbtLongrun_bufnr

func! SbtLongrunStop ()
  if !exists('g:SbtLongrunID')
    echo 'SbtLongrun is not running'
    return
  endif
  call jobstop( g:SbtLongrunID )
  unlet g:SbtLongrunID
  unlet g:SbtLongrun_bufnr
endfunc

" This approach of manually killing the JVM process is now no longer used. I'm moving to using Sbt-revolver.
" Note the needed sbt setup below.
" Also note the reStart command without the ~ tilde here: ~/.config/nvim/plugin/ftype/scala.vim‖/cmdˍ=ˍ"printer/reStar

func! SbtLongrun_killJVMProcess( processName )
  let jvmProcesses = systemlist( 'jps' )
  let jvmProcesses = functional#map( {line -> split( line, " " ) }, jvmProcesses )
  let jvmProcesses = functional#filter( {line -> line[1] =~ a:processName }, jvmProcesses )
  " return jvmProcesses
  if !len( jvmProcesses )
    echo "JVM process not found: " . a:processName
    return
  endif
  let processId = jvmProcesses[0][0]
  call system( 'kill ' . processId )
endfunc

" systemlist( 'jps' )
" SbtLongrun_killJVMProcess( 'runZioServerApp' )
" SbtLongrun_killJVMProcess( 'Server' )

func! SbtLongrun_isRunning()
  let jvmProcesses = systemlist( 'jps' )
  let jvmProcesses = functional#map( {line -> split( line, " " ) }, jvmProcesses )
  let jvmProcesses = functional#filter( {line -> line[1] =~ 'runServerApp' }, jvmProcesses )
  if len( jvmProcesses )
    return v:true
  else
    return v:false
  endif
endfunc
" SbtLongrun_isRunning()


" ─^  SBT long-running                                   ▲



" ─   SBT Reloader                                       ■

nnoremap <silent> <leader><leader>sr :call SbtReloaderStart()<cr>
nnoremap <silent> <leader><leader>sR :call SbtReloaderStop()<cr>

" ### sbt revolver reStart
" in project/plugins.sbt add this line:
" addSbtPlugin("io.spray"                    % "sbt-revolver"             % "0.10.0")

" note this line in the printer project:
"       reStart / mainClass := Some("printerserver.runServerApp"),

" lazy val printer = project
"   .in( file( "m/_printer" ) )
"   .dependsOn( h4s_simple )
"   .settings(
"       commonSettings,
"       reStart / mainClass := Some("printerserver.runServerApp"),
"       libraryDependencies ++= L.zio ++ L.cats ++ L.pprint,
"    )


func! SbtReloaderStart ()
  if exists('g:SbtReloaderID')
    echo 'SbtReloader is already running'
    return
  endif
  exec "new"
  let g:SbtReloader_bufnr = bufnr()

  let opts = { 'cwd': getcwd( -1, -1 ) }
  let opts = extend( opts, g:SbtPrinterCallbacks )

  let g:SbtReloaderID = termopen('sbt --client', opts)
  silent wincmd c


  let cmd = "~printer/reStart" . "\n"
  call ScalaSbtSession_RunMain( g:SbtReloaderID, cmd )
endfunc

" g:SbtReloaderID
" g:SbtReloader_bufnr

func! SbtReloaderStop ()
  if !exists('g:SbtReloaderID')
    echo 'SbtReloader is not running'
    return
  endif
  call jobstop( g:SbtReloaderID )
  unlet g:SbtReloaderID
  unlet g:SbtReloader_bufnr
endfunc


" ─^  SBT Reloader                                       ▲


" ─   SBT JS terms                                       ■

nnoremap <silent> <leader><leader>sj :call SbtJsStart()<cr>
nnoremap <silent> <leader><leader>sJ :call SbtJsStop()<cr>

let g:SbtJs_projectName = "js_simple"
" " for Laminar-fullstack example, set to:
" let g:SbtJs_projectName = "client"

let g:SbtJsVite_cmd = "cd m/js_vite && npm run dev"


func! SbtJsStart ()
  if exists('g:SbtJsID')
    echo 'SbtJs is already running'
    return
  endif
  let opts = { 'cwd': getcwd( -1, -1 ) }
  let opts = extend( opts, g:SbtPrinterCallbacks )

  exec "new"
  let g:SbtJs_bufnr = bufnr()
  let g:SbtJsID = termopen('sbt --client', opts)
  silent wincmd c

  exec "new"
  let g:SbtJsVite_bufnr = bufnr()
  let g:SbtJsViteID = termopen( g:SbtJsVite_cmd, opts)
  silent wincmd c

endfunc

" g:SbtJsID
" g:SbtJs_bufnr

func! SbtJsStop ()
  if !exists('g:SbtJsID')
    echo 'SbtJs is not running'
    return
  endif
  call jobstop( g:SbtJsID )
  unlet g:SbtJsID
  unlet g:SbtJs_bufnr
  call jobstop( g:SbtJsViteID )
  unlet g:SbtJsViteID
  unlet g:SbtJsVite_bufnr
endfunc

func! SbtJs_compile ()
  " let cmd = "client/fastLinkJS" . "\n"
  let cmd = g:SbtJs_projectName . "/fastLinkJS" . "\n"
  call ScalaSbtSession_RunMain( g:SbtJsID, cmd )
endfunc


" ─^  SBT JS terms                                       ▲



" let g:ReplReceive_open
let g:ReplReceive_open = v:true
let g:ReplReceive_additional = []
let g:Repl_waitforanotherlargechunk = v:false
let g:Repl_wait_receivedsofar = []
let g:Repl_wait_multiline = v:false
let g:Repl_wait_multiline_received = []

func! ReplReceiveOpen_reset()
  let g:ReplReceive_open = v:true
  let g:Repl_waitforanotherlargechunk = v:false
  let g:Repl_wait_receivedsofar = []
  let g:Repl_wait_multiline = v:false
  let g:Repl_wait_multiline_received = []
  " echo "receive open. unseen info lines: " . len( g:ReplReceive_additional )
  " echo g:ReplReceive_additional
  let g:ReplReceive_additional = []
endfunc

func! SbtTerms_MainCallback(_job_id, data, _event)
  let lines = RemoveTermCodes( a:data )
  if !len( lines ) | return | endif


  " RES_multi_ case part 2: 
  " This code run when the Repl_wait_multiline mode was activated (see below)
  " Currently is only runs once on the second multiline repl event. (there may be more for longer multiline values)
  if g:Repl_wait_multiline
    "
    " { "[info]   value = Character(", '[info]     name = "aa",', "[info]     age = 12", "[info]   )", "[info] )_RES_multi_END", "[success] Total time: 2 s, completed 8 Dec 2023, 21:12:07", "=sbt:edb_gql> " }
    let idx = functional#findP( lines, {x-> x =~ '_RES_multi_END'} )

    let lines = SubstituteInLines( lines, '\[info\] ', "" )
    let lines = SubstituteInLines( lines, '"""', "" )

    if idx == -1
      let g:Repl_wait_multiline_received += lines
      " echoe "_RES_multi_END not found in chunk"
      return
    endif

    let lines = SubstituteInLines( lines, '_RES_multi_END', "" )
    let g:Repl_wait_multiline_received += lines[:idx]
    let resultVal = g:Repl_wait_multiline_received
    let g:Repl_wait_multiline = v:false
    let g:ReplReceive_open = v:false
    call T_DelayedCmd( "call ReplReceiveOpen_reset()", 2000 )

    " let g:floatWin_win = FloatingSmallNew ( resultVal )
    let g:floatWin_win = FloatingSmallNew ( resultVal, "otherWinColumn" )
    call ScalaSyntaxAdditions() 
    call FloatWin_FitWidthHeight()
    wincmd p
    return
  endif


  if g:Repl_waitforanotherlargechunk

    if (len( lines ) > 8) 
      let g:Repl_waitforanotherlargechunk = v:true
      let g:Repl_wait_receivedsofar[-1] = g:Repl_wait_receivedsofar[-1] . lines[0]
      let g:Repl_wait_receivedsofar += lines[2:]
      return
    else

      let g:Repl_waitforanotherlargechunk = v:false

      let g:Repl_wait_receivedsofar[-1] = g:Repl_wait_receivedsofar[-1] . lines[0]
      let g:Repl_wait_receivedsofar += lines[2:]

      let resultVal = g:Repl_wait_receivedsofar

      let resultVal = functional#filter( {line -> !(line =~ 'hikari')}, resultVal )

      let resultVal = functional#filter( {line -> !(line =~ 'sbt\:')}, resultVal )
      let resultVal = functional#filter( {line -> !(line =~ 'sbt\sserver')}, resultVal )
      let resultVal = functional#filter( {line -> !(line =~ "enter \'cancel")}, resultVal )
      " Tested with ~/Documents/Proj/g_edb_gql/m/h4s_simple/os_lib/a_oslib.scala‖/e2_vimfˍ=

      let resultVal = SubstituteInLines( resultVal, '\[error\]', "" )


      let g:ReplReceive_open = v:false
      call T_DelayedCmd( "call ReplReceiveOpen_reset()", 2000 )

      " let g:floatWin_win = FloatingSmallNew ( resultVal )
      let g:floatWin_win = FloatingSmallNew ( resultVal, "otherWinColumn" )
      call ScalaSyntaxAdditions() 
      call FloatWin_FitWidthHeight()
      wincmd p

      return
    endif
  endif


  if !g:ReplReceive_open 
    let g:ReplReceive_additional += lines
    " echo "add info lines: " . len( g:ReplReceive_additional )
    " echo g:ReplReceive_additional
    " call v:lua.putt( g:ReplReceive_additional )
    return 
  endif

  let searchString1 = join( lines, "※" )

  " RES_multi_ case part 1: This case if for when the result value (e.g. a list or pprint'ed val) is broken up into
  " several lines *by the scala output* (vs the approach to put most info into one long (potentially wrapped) line.
  " This case is now marked by a new replTab and also a replEndTag when setting the printer val.
  " It seems only the first line of this multi-line output is received in the first repl event.
  " So the code below only activates the Repl_wait_multiline mode, and records the first line.
  " Btw I can simply add these lines to activate this mode per Lsp Type in the setPrinter map: ~/.config/nvim/plugin/ftype/scala.vim‖/elseifˍtypeModeˍ==ˍ'z
    " let _replTag    = '"RES_multi_"'
    " let _replEndTag = '"_RES_multi_END"'


  if searchString1 =~ "RES_multi_"
    " call v:lua.putt( searchString1 )

    let foundString1 = matchstr( searchString1, '\vRES_multi_\zs.*\ze_RES_multi_END' )
    " call v:lua.putt( foundString1 )
    if len( foundString1 ) > 0
      let g:floatWin_win = FloatingSmallNew ( [foundString1], "otherWinColumn" )
      call ScalaSyntaxAdditions() 
      call FloatWin_FitWidthHeight()
      wincmd p
    else

      let foundString1 = matchstr( searchString1, '\vRES_multi_\zs.*' )
      let foundList1 = split( foundString1, "※" )
      let foundList1 = SubstituteInLines( foundList1, '"""', "" )
      let foundList1 = SubstituteInLines( foundList1, '\[info\]', "" )
      " let lines = SubstituteInLines( lines, '\[info\] ', "" )
      if !(len( foundList1 ) > 0) | return | endif
      " call v:lua.putt( foundList1 )
      let g:Repl_wait_multiline = v:true
      let g:Repl_wait_multiline_received = foundList1
    endif


  elseif searchString1 =~ "(error|Exception)"
    let foundString1 = matchstr( searchString1, '\v(Caused\sby:\s|RESULT_|Error:\s|Exception\sin\sthead|Exception:\s|ERROR:\s|Err\()\zs.*' )
    let foundList1 = split( foundString1, "※" )
    if !(len( foundList1 ) > 0) | return | endif

    let foundList1[0] = matchstr( foundList1[0], '\v(error:\s|Err)\zs.*' )

    let foundList1 = SubstituteInLines( foundList1, '\[error\]', "" )
    let foundList1 = StripLeadingSpaces( foundList1 )
    " "at " indicates WHERE the error occured. -> skip these lines
    let foundList1 = functional#filter( {line -> !(line =~ '^at\s')}, foundList1 )
    let foundList1 = functional#filter( {line -> !(line =~ '^stack\s')}, foundList1 )

    " it seems errors are sent twice by the repl. and only the second one occurences
    " has the Details: line in the same batch of lines.
    if !(len( foundList1 ) > 1) | return | endif

    let resultVal = foundList1


    let g:ReplReceive_open = v:false
    call T_DelayedCmd( "call ReplReceiveOpen_reset()", 2000 )

    " let g:floatWin_win = FloatingSmallNew ( resultVal )
    let g:floatWin_win = FloatingSmallNew ( resultVal, "otherWinColumn" )
    call ScalaSyntaxAdditions() 
    call FloatWin_FitWidthHeight()
    wincmd p

  else

    " call v:lua.putt( searchString1 )
    let foundString1 = matchstr( searchString1, '\v(Caused\sby:\s|RESULT_|Error:\s|Exception\sin\sthread|Exception:\s|ERROR:\s|Err\()\zs.*' )
    let foundString2 = matchstr( searchString1, '\v(Caused\sby:\s|RESULT_)\zs.*' )
    let foundList1 = split( foundString1, "※" )
    let foundList2 = split( foundString2, "※" )

    " if !( len( foundList1 ) > 0 || len( foundList2 ) > 0 ) 
    if !(len( foundList1 ) > 0)
      if !(len( foundList2 ) > 0)
        return 
      endif
    endif

    " call v:lua.putt( foundList2 )
    if 1 " (len( foundList1 ) > 8) 
      let g:Repl_waitforanotherlargechunk = v:true
      let g:Repl_wait_receivedsofar = foundList1
      " just save, don't show
    else

      " this seems to allow to filter any line?!
      let foundList1 = functional#filter( {line -> !(line =~ 'sbt\:')}, foundList1 )
      " let foundList2 = functional#filter( {line -> !(line =~ 'sbt\:')}, foundList2 )

      let foundList2 = SubstituteInLines( foundList2, '\[error\]', "" )

      let resultVal = foundList1 + foundList2


      let g:ReplReceive_open = v:false
      call T_DelayedCmd( "call ReplReceiveOpen_reset()", 2000 )

      " let g:floatWin_win = FloatingSmallNew ( resultVal )
      let g:floatWin_win = FloatingSmallNew ( resultVal, "otherWinColumn" )
      call ScalaSyntaxAdditions() 
      call FloatWin_FitWidthHeight()
      wincmd p

    endif

  endif

endfunc

" ISSUE: TODO: with multiple print statements e.g. this currently produces two overlapping floatwindows
" ~/Documents/Server-Dev/effect-ts_zio/a_scala3/DDaSci_ex/src/main/scala/galliamedium/initech/A_Basics.scala#/lazy%20val%20e3_count
" there are two print events returned from the sbt-repl.

func! SbtTerms_ErrorCallback(job_id, data, event)
  echom a:data
endfunc

func! SbtTerms_ExitCallback(job_id, data, event)
  echom a:data
endfunc

func! ScalaReplPlain( message )
  call jobsend(g:SbtPrinterID, a:message . "\n" )
endfunc

" call jobsend(g:SbtPrinterID, "\n" )


let g:SbtPrinterCallbacks = {
      \ 'on_stdout': function('SbtTerms_MainCallback'),
      \ 'on_stderr': function('SbtTerms_ErrorCallback'),
      \ 'on_exit': function('SbtTerms_ExitCallback')
      \ }


func! ScalaReplRun()
  call jobsend(g:SbtPrinterID, "run\n" )
  " call jobsend(g:SbtPrinterID, "runMain Printer\n" )
  " let g:floatWin_win = FloatingSmallNew([])
  " exec 'buffer' g:ScalaRepl_bufnr
  " call FloatWin_FitWidthHeight()
  " call nvim_win_set_config( g:floatWin_win, { 'width' : 100, 'height': 20 } )
  " normal G
endfunc

func! ScalaSbtSession_RunMain( terminalId, cmd )
  call jobsend( a:terminalId, a:cmd )
endfunc


func! ScalaReplPost( message )
  call jobsend(g:SbtPrinterID, a:message . "\n" )
  let g:floatWin_win = FloatingSmallNew([])
  exec 'buffer' g:ScalaRepl_bufnr
  " call FloatWin_FitWidthHeight()
  call nvim_win_set_config( g:floatWin_win, { 'width' : 100, 'height': 20 } )
  normal G
endfunc







