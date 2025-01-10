
" nnoremap <silent> dr         :call AdbReplReload()<cr>

" nnoremap <silent> ,gei      :silent call AdbReplPost( GetLineFromCursor() )<cr>
" vnoremap <silent> ,gei :<c-u>call AdbReplPost( Get_visual_selection() )<cr>

func! AdbStart ()
  if exists('g:AdbID')
    echo 'Adb is already running'
    return
  endif
  exec "5new"
  let g:Adb_bufnr = bufnr()
  let g:AdbID = termopen('arangod')
  wincmd p
endfunc

func! AdbStop ()
  if !exists('g:AdbID')
    echo 'arangosh is not running'
    return
  endif
  call jobsend(g:AdbID, "exit\n" )
  call jobstop( g:AdbID )
  unlet g:AdbID
endfunc


func! AdbReplStart ()
  if exists('g:AdbReplID')
    echo 'AdbRepl is already running'
    return
  endif
  exec "5new"
  let g:AdbRepl_bufnr = bufnr()
  " let g:AdbReplID = termopen('arangosh --server.database ' . g:arangodb_db, g:AdbReplCallbacks)
  " let g:AdbReplID = termopen('arangosh --console.colors false --console.pretty-print false --server.database ' . g:arangodb_db, g:AdbReplCallbacks)
  " let g:AdbReplID = jobstart('arangosh --quiet true --console.colors false --console.pretty-print false --server.database ' . g:arangodb_db, g:AdbReplCallbacks)
  " let g:AdbReplID = termopen('arangosh --quiet true --console.colors false --console.pretty-print false --server.database ' . g:arangodb_db, g:AdbReplCallbacks)
  " let g:AdbReplID = termopen('arangosh --log.use-json-format true --log.file "arangosh_log.txt" --quiet true --console.colors false --console.pretty-print false --server.database ' . g:arangodb_db, g:AdbReplCallbacks)
  let g:AdbReplID = termopen('arangosh --log.file "arangosh_log.txt" --quiet true --console.colors true --console.pretty-print true --server.database ' . g:arangodb_db, g:AdbReplCallbacks)
  call jobsend(g:AdbReplID, "\n" )
  wincmd p
endfunc

func! AdbReplStop ()
  if !exists('g:AdbReplID')
    echo 'arangosh is not running'
    return
  endif
  call jobsend(g:AdbReplID, "exit\n" )
  call jobstop( g:AdbReplID )
  unlet g:AdbReplID
  " bdelete g:AdbRepl_bufnr
  exec 'bdelete' g:AdbRepl_bufnr
endfunc

" func! AdbReplReload ()
"   call jobsend(g:AdbReplID, "%run " . expand('%') . "\n")
" endfunc

func! AdbReplMainCallback(job_id, data, event)
  " Todo: returns are inconsistent
  " return
  " echoe a:event
  " let l:lines = RemoveTermCodes( a:data )
  " echoe l:lines[-3:-2]
  " echoe a:data[-1]
  " echoe len( a:data )

  " " ISSUE: deactivated this bc/ with many returned lines only a random last portion of the lines
  " " is received here.
  " echoe a:data
  " return
  call AdbReplSimpleResponseHandler (a:data)
  " call AdbRepl_ShowTerm (a:data)
endfunc

func! AdbReplErrorCallback(job_id, data, event)
  echom a:data
endfunc

func! AdbReplExitCallback(job_id, data, event)
  echom a:data
endfunc

func! AdbReplPlain( message )
  call jobsend(g:AdbReplID, a:message . "\n" )
endfunc


let g:AdbReplCallbacks = {
      \ 'on_stdout': function('AdbReplMainCallback'),
      \ 'on_stderr': function('AdbReplErrorCallback'),
      \ 'on_exit': function('AdbReplExitCallback')
      \ }

let g:Adb_lastmessage = "default off"

func! AdbReplPost( message )
  let g:Adb_lastmessage = a:message
  call jobsend(g:AdbReplID, a:message . "\n" )
endfunc

  " NOTE: This shows the actual terminal buffer in a float!
  " let g:floatWin_win = FloatingSmallNew([])
  " exec 'buffer' g:AdbRepl_bufnr
  " call FloatWin_FitWidthHeight()
  " call nvim_win_set_config( g:floatWin_win, { 'width' : 100, 'height': 20 } )
  " normal G

let g:Adbshblock = v:false

func! Adb_blockreset()
  let g:Adbshblock = v:false
endfunc


" This shows the actual terminal buffer in a float!
func! AdbRepl_ShowTerm( resp )
  if g:Adbshblock
    " occasionally the terminal sends two empty lines shortly after the main chunk. the timer avoids this
    " echoe a:resp
    return
  else
    " echoe len( a:resp )
  endif

  if len(a:resp) > 1
    let resp = a:resp
    if resp[-1] =~ "8529\@"

      let g:Adbshblock = v:true
      call T_DelayedCmd( "call Adb_blockreset()", 500 )
      let g:floatWin_win = FloatingSmallNew([])
      exec 'buffer' g:AdbRepl_bufnr
      set ft=scala
      " call TsSyntaxAdditions()
      call ScalaSyntaxAdditions()
      " call FloatWin_FitWidthHeight()
      call nvim_win_set_config( g:floatWin_win, { 'width' : 70, 'height': 30 } )
      normal G
    endif

  endif

endfunc

func! AdbReplSimpleResponseHandler( resp )
  let resp = a:resp
  " echoe len(a:resp)
  " if a:resp[0] =~ g:Adb_lastmessage
  " if a:resp[0] =~ shellescape( g:Adb_lastmessage)
  " if RemoveTermCodes(a:resp)[0] =~ "_collections"
  " if RemoveTermCodes(a:resp)[0] =~ g:Adb_lastmessage
  if RemoveTermCodes(a:resp)[0] == g:Adb_lastmessage . g:Adb_lastmessage
    " echoe "yes" RemoveTermCodes(a:resp)
    let resp = resp[1:]
    " echoe "and.." RemoveTermCodes(resp)
    " return
  endif
  " echoe RemoveTermCodes(a:resp)
  " return
  if g:Adbshblock
    " occasionally the terminal sends two empty lines shortly after the main chunk. the timer avoids this
    " echoe a:resp
    return
  else
    " echoe len( a:resp )
  endif

  " if len(resp) > 1
  if resp[-1] =~ "8529\@"

    let g:Adbshblock = v:true
    call T_DelayedCmd( "call Adb_blockreset()", 500 )

    let startLine = g:Adb_queryLinesCount - 1

    let resp = resp[startLine:-2]
    let resp = RemoveTermCodes( resp )

    let resultVal = matchstr( join( resp, "※" ), '\v(stacktrace\:\sArangoError\:\s)\zs.*' )
    let resultVal = split( resultVal, "※" )
    if len( resultVal )
      " let resp = [resultVal[0]] + ["", ""] + resp 
      let resp = [ "Error " . resultVal[0] ]  
    endif

    let g:floatWin_win = FloatingSmallNew ( resp )
    " silent exec "%!jq"
    set ft=json
    " call TsSyntaxAdditions()
    set syntax=typescript
    call ScalaSyntaxAdditions()
    call FloatWin_FitWidthHeight()
    wincmd p
  endif
  " endif
endfunc


  " let lines = a:lines
  " " echoe a:lines
  " " return
  " if len(lines) < 2 | return | endif
  " if !(lines[-1] =~ "8529\@") | return | endif

  " " let lines = lines[1:-3]

  " " let lines = RemoveTermCodes( lines )

  " let resultVal = matchstr( join( lines, "※" ), '\v(stacktrace\:\sArangoError\:\s)\zs.*' )
  " let resultVal = split( resultVal, "※" )
  " if len( resultVal )
  "   " let lines = [resultVal[0]] + ["", ""] + lines 
  "   let lines = [ "Error " . resultVal[0]]  
  " endif

  " let g:floatWin_win = FloatingSmallNew ( lines )
  " set ft=typescript
  " " set syntax=scala
  " call ScalaSyntaxAdditions()
  " call FloatWin_FitWidthHeight()
  " wincmd p
" endfunc





" Separates 3 output types:
" - Forwards multi-line repl-outputs
" - Splits a list of strings into lines
" - Forwards other values
func! AdbReplSimpleResponseHand( lines )
  " echo a:lines
  " return
  let l:lines = a:lines
  let l:lines = RemoveTermCodes( l:lines )
  echo len( l:lines )
  echo l:lines 
  return
  " let g:floatWin_win = FloatingSmallNew ( l:lines )
  " call FloatWin_FitWidthHeight()
  " return

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
    " AdbRepl returned the typlical one value
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
    echo "AdbRepl returned 0 lines"
  " elseif len( l:lines ) > 15
  "   call PsShowLinesInBuffer( l:lines )
  else
    " call FloatWin_ShowLines( l:lines )
    let g:floatWin_win = FloatingSmallNew ( l:lines )
    " call VirtualtextShowMessage( join(l:lines[:1]), 'CommentSection' )
  endif

  call FloatWin_FitWidthHeight()
endfunc
" AdbReplSimpleResponseHand (["eins", "zwei"])








