


" ─   SBT Repl                                           ■

nnoremap <silent> <leader><leader>ro :call ScalaReplStart()<cr>
nnoremap <silent> <leader><leader>rq :call ScalaReplStop()<cr>

func! ScalaReplStart ()
  if exists('g:ScalaReplID')
    echo 'ScalaRepl is already running'
    return
  endif
  exec "new"
  let g:ScalaRepl_bufnr = bufnr()
  let g:ScalaReplID = termopen('sbt', g:ScalaReplCallbacks)
  silent wincmd c
endfunc

" g:ScalaReplID
" g:ScalaRepl_bufnr

func! ScalaReplStop ()
  if !exists('g:ScalaReplID')
    echo 'ScalaRepl is not running'
    return
  endif
  call jobstop( g:ScalaReplID )
  unlet g:ScalaReplID
  unlet g:ScalaRepl_bufnr
endfunc


" ─^  SBT Repl                                           ▲



" ─   SBT Server Process                                 ■
" This allows to lauch a second sbt process. This might be a long running
" server app while the first sbt process above can be used for short calls and requests.

nnoremap <silent> <leader><leader>rO :call ScalaServerReplStart()<cr>
nnoremap <silent> <leader><leader>rQ :call ScalaServerReplStop()<cr>

func! ScalaServerReplStart ()
  if exists('g:ScalaServerReplID')
    echo 'ScalaServerRepl is already running'
    return
  endif
  exec "new"
  let g:ScalaServerRepl_bufnr = bufnr()
  let g:ScalaServerReplID = termopen('sbt --client', g:ScalaReplCallbacks)
  silent wincmd c
endfunc

" g:ScalaServerReplID
" g:ScalaServerRepl_bufnr

func! ScalaServerReplStop ()
  if !exists('g:ScalaServerReplID')
    echo 'ScalaServerRepl is not running'
    return
  endif
  call jobstop( g:ScalaServerReplID )
  unlet g:ScalaServerReplID
  unlet g:ScalaServerRepl_bufnr
endfunc


func! ScalaServerRepl_killJVMProcess( processName )
  let jvmProcesses = systemlist( 'jps' )
  let jvmProcesses = functional#map( {line -> split( line, " " ) }, jvmProcesses )
  let jvmProcesses = functional#filter( {line -> line[1] =~ a:processName }, jvmProcesses )
  " return jvmProcesses
  if !len( jvmProcesses )
    " echoe "JVM process not found: " . a:processName
    return
  endif
  let processId = jvmProcesses[0][0]
  call system( 'kill ' . processId )
endfunc

" ScalaServerRepl_killJVMProcess( 'runZioServerApp' )

func! ScalaServerRepl_isRunning()
  let jvmProcesses = systemlist( 'jps' )
  let jvmProcesses = functional#map( {line -> split( line, " " ) }, jvmProcesses )
  let jvmProcesses = functional#filter( {line -> line[1] =~ 'runZioServerApp' }, jvmProcesses )
  if len( jvmProcesses )
    return v:true
  else
    return v:false
  endif
endfunc
" ScalaServerRepl_isRunning()


" ─^  SBT Server Process                                 ▲



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

func! ScalaReplMainCallback(_job_id, data, _event)
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
    let lines = SubstituteInLines( lines, '_RES_multi_END', "" )
    let g:Repl_wait_multiline_received += lines[:idx]
    let resultVal = g:Repl_wait_multiline_received
    let g:Repl_wait_multiline = v:false
    let g:ReplReceive_open = v:false
    call T_DelayedCmd( "call ReplReceiveOpen_reset()", 2000 )

    let g:floatWin_win = FloatingSmallNew ( resultVal )
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

      let g:ReplReceive_open = v:false
      call T_DelayedCmd( "call ReplReceiveOpen_reset()", 2000 )

      let g:floatWin_win = FloatingSmallNew ( resultVal )
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
    let foundString1 = matchstr( searchString1, '\vRES_multi_\zs.*' )
    let foundList1 = split( foundString1, "※" )
    if !(len( foundList1 ) > 0) | return | endif
    " call v:lua.putt( foundList1 )
    let g:Repl_wait_multiline = v:true
    let g:Repl_wait_multiline_received = foundList1

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

    let g:floatWin_win = FloatingSmallNew ( resultVal )
    call ScalaSyntaxAdditions() 
    call FloatWin_FitWidthHeight()
    wincmd p

  else

    " call v:lua.putt( searchString1 )
    let foundString1 = matchstr( searchString1, '\v(Caused\sby:\s|RESULT_|Error:\s|Exception\sin\sthread|Exception:\s|ERROR:\s|Err\()\zs.*' )
    let foundList1 = split( foundString1, "※" )
    if !(len( foundList1 ) > 0) | return | endif

    " call v:lua.putt( foundList1 )
    if (len( foundList1 ) > 8) 
      let g:Repl_waitforanotherlargechunk = v:true
      let g:Repl_wait_receivedsofar = foundList1
      " just save, don't show
    else

      " this seems to allow to filter any line?!
      let foundList1 = functional#filter( {line -> !(line =~ 'sbt\:')}, foundList1 )
      let resultVal = foundList1

      let g:ReplReceive_open = v:false
      call T_DelayedCmd( "call ReplReceiveOpen_reset()", 2000 )

      let g:floatWin_win = FloatingSmallNew ( resultVal )
      call ScalaSyntaxAdditions() 
      call FloatWin_FitWidthHeight()
      wincmd p

    endif

  endif

endfunc

" ISSUE: TODO: with multiple print statements e.g. this currently produces two overlapping floatwindows
" ~/Documents/Server-Dev/effect-ts_zio/a_scala3/DDaSci_ex/src/main/scala/galliamedium/initech/A_Basics.scala#/lazy%20val%20e3_count
" there are two print events returned from the sbt-repl.

func! ScalaReplErrorCallback(job_id, data, event)
  echom a:data
endfunc

func! ScalaReplExitCallback(job_id, data, event)
  echom a:data
endfunc

func! ScalaReplPlain( message )
  call jobsend(g:ScalaReplID, a:message . "\n" )
endfunc

" call jobsend(g:ScalaReplID, "\n" )


let g:ScalaReplCallbacks = {
      \ 'on_stdout': function('ScalaReplMainCallback'),
      \ 'on_stderr': function('ScalaReplErrorCallback'),
      \ 'on_exit': function('ScalaReplExitCallback')
      \ }


func! ScalaReplRun()
  call jobsend(g:ScalaReplID, "run\n" )
  " call jobsend(g:ScalaReplID, "runMain Printer\n" )
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
  call jobsend(g:ScalaReplID, a:message . "\n" )
  let g:floatWin_win = FloatingSmallNew([])
  exec 'buffer' g:ScalaRepl_bufnr
  " call FloatWin_FitWidthHeight()
  call nvim_win_set_config( g:floatWin_win, { 'width' : 100, 'height': 20 } )
  normal G
endfunc







