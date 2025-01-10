

" deactivated these maps as currently not in use.
" nnoremap <silent> <leader>ro :call WsReplStart()<cr>
" nnoremap <silent> <leader>rq :call WsReplStop()<cr>
" nnoremap <silent> dr         :call WsReplReload()<cr>

" nnoremap <silent> gei      :silent call WsReplPost( GetLineFromCursor() )<cr>
" vnoremap <silent> gei :<c-u>call WsReplPost( Get_visual_selection() )<cr>


func! WsReplStart ()
  if exists('g:WsReplID_S')
    echo 'WsRepl is already running'
    return
  endif

  exec "new"
  let g:WsReplID_S = termopen("websocat -t ws-l:127.0.0.1:1240 broadcast:mirror:", g:WsReplCallbacks)
  " let g:WsReplID_S = jobstart("websocat -t ws-l:127.0.0.1:1240 broadcast:mirror:", g:WsReplCallbacks)

  exec "new"
  let g:WsReplID_C = termopen("websocat ws://127.0.0.1:1240", g:WsReplCallbacks)
  " let g:WsReplID_C = termopen("websocat ws://127.0.0.1:1240 --jsonrpc", g:WsReplCallbacks)
  " let g:WsReplID_C = jobstart("websocat ws://127.0.0.1:1240", g:WsReplCallbacks)
endfunc


func! WsReplStop ()
  if !exists('g:WsReplID_S')
    echo 'WsRepl is not running'
    return
  endif
  call jobstop( g:WsReplID_S )
  unlet g:WsReplID_S
  call jobstop( g:WsReplID_C )
  unlet g:WsReplID_C
endfunc

" func! WsReplReload ()
"   call jobsend(g:WsReplID, "%run " . expand('%') . "\n")
" endfunc

func! WsReplMainCallback(job_id, data, event)
  echo a:data[0]
  " call WsReplSimpleResponseHandler (a:data)
endfunc

func! WsReplErrorCallback(job_id, data, event)
  echom a:data
endfunc

func! WsReplExitCallback(job_id, data, event)
  echom a:data
endfunc


let g:WsReplCallbacks = {
      \ 'on_stdout': function('WsReplMainCallback'),
      \ 'on_stderr': function('WsReplErrorCallback'),
      \ 'on_exit': function('WsReplExitCallback')
      \ }

func! WsReplPost( message )
  call jobsend(g:WsReplID_C, JS_json_stringify( a:message ) )
  " call jobsend(g:WsReplID_C, JS_json_stringify( a:message ) . "\n")
  " call jobsend(g:WsReplID_C, a:message . "\n")
endfunc

" Separates 3 output types:
" - Forwards multi-line repl-outputs
" - Splits a list of strings into lines
" - Forwards other values
func! WsReplSimpleResponseHandler( lines )
  echo a:lines
  return
  let l:lines = a:lines
  " Not sure why there is sometimes an additional one line return value.
  " if len( a:lines ) == 1 | return | endif
  " echom len(a:lines)
  " if (type(a:lines) != type(v:t_list))
  "   echom a:lines
  "   " call FloatWin_ShowLines( [a:lines] )
  "   return
  " endif
  let l:lines = RemoveTermCodes( l:lines )

  if len( l:lines ) == 3
    " WsRepl returned the typlical one value
    call VirtualtextShowMessage( l:lines[0], 'CommentSection' )
    let hsReturnVal = l:lines[0]
    if hsReturnVal[0:1] == '["'
      " Detected list of strings: To split the list into lines, convert to vim list of line-strings!
      call FloatWin_ShowLines( eval ( hsReturnVal ) )
    else
      call FloatWin_ShowLines( [hsReturnVal] )
    endif
  elseif len( l:lines ) == 0
    echo "WsRepl returned 0 lines"
  " elseif len( l:lines ) > 15
  "   call PsShowLinesInBuffer( l:lines )
  else
    call FloatWin_ShowLines( l:lines )
    call VirtualtextShowMessage( join(l:lines[:1]), 'CommentSection' )
  endif
endfunc
" call WsReplSimpleResponseHandler (["eins", "zwei"])



