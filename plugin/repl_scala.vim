
nnoremap <silent> <leader>ro :call ScalaReplStart()<cr>
nnoremap <silent> <leader>rq :call ScalaReplStop()<cr>
" nnoremap <silent> dr         :call ScalaReplReload()<cr>

" nnoremap <silent> ,gei      :silent call ScalaReplPost( GetLineFromCursor() )<cr>
" vnoremap <silent> ,gei :<c-u>call ScalaReplPost( Get_visual_selection() )<cr>

"    \lt
func! ScalaReplStart ()
  if exists('g:ScalaReplID')
    echo 'ScalaRepl is already running'
    return
  endif

  " call tools_edgedb#startInstance ()

  exec "new"
  let g:ScalaRepl_bufnr = bufnr()
  let g:ScalaReplID = termopen('sbt', g:ScalaReplCallbacks)
  " TODO: this throws an error in sbt if there no project "core". but then works with root project for e.g. realworld tapir
  " call jobsend(g:ScalaReplID, "project printer\n" )
  silent wincmd p
endfunc


func! ScalaReplStop ()
  if !exists('g:ScalaReplID')
    echo 'ScalaRepl is not running'
    return
  endif
  call jobstop( g:ScalaReplID )
  unlet g:ScalaReplID
endfunc

" func! ScalaReplReload ()
"   call jobsend(g:ScalaReplID, "%run " . expand('%') . "\n")
" endfunc

let g:ReplReceive_open = v:true
let g:ReplReceive_additional = []
let g:Repl_waitforanotherlargechunk = v:false
let g:Repl_wait_receivedsofar = []

func! ReplReceiveOpen_reset()
  let g:ReplReceive_open = v:true
  let g:Repl_waitforanotherlargechunk = v:false
  let g:Repl_wait_receivedsofar = []
  echo "receive open. unseen info lines: " . len( g:ReplReceive_additional )
  " echo g:ReplReceive_additional
  let g:ReplReceive_additional = []
endfunc

func! ScalaReplMainCallback(job_id, data, event)
  let lines = RemoveTermCodes( a:data )
  if !len( lines ) | return | endif

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
    echo "add info lines: " . len( g:ReplReceive_additional )
    return 
  endif


  let searchString1 = join( lines, "※" )

  if searchString1 =~ "(error|Exception)"
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

    let foundString1 = matchstr( searchString1, '\v(Caused\sby:\s|RESULT_|Error:\s|Exception\sin\sthread|Exception:\s|ERROR:\s|Err\()\zs.*' )
    let foundList1 = split( foundString1, "※" )
    if !(len( foundList1 ) > 0) | return | endif

    if (len( foundList1 ) > 8) 
      let g:Repl_waitforanotherlargechunk = v:true
      let g:Repl_wait_receivedsofar = foundList1
      " just save, don't show
    else

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

func! ScalaSbtSession_RunMain( main_path )
  let cmd = "runMain " . a:main_path . "\n"
  call jobsend(g:ScalaReplID, cmd )
endfunc


func! ScalaReplPost( message )
  call jobsend(g:ScalaReplID, a:message . "\n" )
  let g:floatWin_win = FloatingSmallNew([])
  exec 'buffer' g:ScalaRepl_bufnr
  " call FloatWin_FitWidthHeight()
  call nvim_win_set_config( g:floatWin_win, { 'width' : 100, 'height': 20 } )
  normal G
endfunc

" Separates 3 output types:
" - Forwards multi-line repl-outputs
" - Splits a list of strings into lines
" - Forwards other values
" NOTE: not used!?
func! ScalaReplSimpleResponseHandler( lines )
  " echo a:lines
  " return
  let l:lines = a:lines
  let l:lines = RemoveTermCodes( l:lines )
  let g:floatWin_win = FloatingSmallNew ( l:lines )

  call FloatWin_FitWidthHeight()
  echoe 'done'
  return

  " Not sure why there is sometimes an additional one line return value.
  " if len( a:lines ) == 1 | return | endif
  " echom len(a:lines)
  " if (type(a:lines) != type(v:t_list))
  "   echom a:lines
  "   " call FloatWin_ShowLines( [a:lines] )
  "   return
  " endif
  " let l:lines = RemoveTermCodes( l:lines )

  if len( l:lines ) == 3
    " ScalaRepl returned the typlical one value
    " call VirtualtextShowMessage( l:lines[0], 'CommentSection' )
    let hsReturnVal = l:lines[0]
    if hsReturnVal[0:1] == '["'
      " Detected list of strings: To split the list into lines, convert to vim list of line-strings!
      " call FloatWin_ShowLines( eval ( hsReturnVal ) )
      let g:floatWin_win = FloatingSmallNew ( [hsReturnVal] )
    else
      " call FloatWin_ShowLines( [hsReturnVal] )
      let g:floatWin_win = FloatingSmallNew ( [hsReturnVal] )
    endif
  elseif len( l:lines ) == 0
    echo "ScalaRepl returned 0 lines"
  " elseif len( l:lines ) > 15
  "   call PsShowLinesInBuffer( l:lines )
  else
    " call FloatWin_ShowLines( l:lines )
    let g:floatWin_win = FloatingSmallNew ( l:lines )
    " call VirtualtextShowMessage( join(l:lines[:1]), 'CommentSection' )
  endif

  call FloatWin_FitWidthHeight()
endfunc
" call ScalaReplSimpleResponseHandler (["eins", "zwei"])



