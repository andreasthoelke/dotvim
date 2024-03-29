
" nnoremap <silent> <leader>ro :call EdbReplStart()<cr>
" nnoremap <silent> <leader>rq :call EdbReplStop()<cr>
" nnoremap <silent> dr         :call EdbReplReload()<cr>

" nnoremap <silent> ,gei      :silent call EdbReplPost( GetLineFromCursor() )<cr>
" vnoremap <silent> ,gei :<c-u>call EdbReplPost( Get_visual_selection() )<cr>

"    \lt
func! EdbReplStart ()
  if exists('g:EdbReplID')
    echo 'EdbRepl is already running'
    return
  endif

  " call tools_edgedb#startInstance ()

  exec "new"
  let g:EdbRepl_bufnr = bufnr()
  let g:EdbReplID = termopen('edgedb -d ' . g:edgedb_db, g:EdbReplCallbacks)
endfunc


func! EdbReplStop ()
  if !exists('g:EdbReplID')
    echo 'EdbRepl is not running'
    return
  endif
  call jobstop( g:EdbReplID )
  unlet g:EdbReplID
endfunc

" func! EdbReplReload ()
"   call jobsend(g:EdbReplID, "%run " . expand('%') . "\n")
" endfunc

func! EdbReplMainCallback(job_id, data, event)
  " Todo: returns are inconsistent
  return
  " echoe a:event
  " let l:lines = RemoveTermCodes( a:data )
  " echoe l:lines[-3:-2]
  " echoe a:data[-1]
  " echoe len( a:data )
  " call EdbReplSimpleResponseHandler (a:data)
endfunc

func! EdbReplErrorCallback(job_id, data, event)
  echom a:data
endfunc

func! EdbReplExitCallback(job_id, data, event)
  echom a:data
endfunc

func! EdbReplPlain( message )
  call jobsend(g:EdbReplID, a:message . "\n" )
endfunc


let g:EdbReplCallbacks = {
      \ 'on_stdout': function('EdbReplMainCallback'),
      \ 'on_stderr': function('EdbReplErrorCallback'),
      \ 'on_exit': function('EdbReplExitCallback')
      \ }

func! EdbReplPost( message )
  call jobsend(g:EdbReplID, a:message . "\n" )
  let g:floatWin_win = FloatingSmallNew([])
  exec 'buffer' g:EdbRepl_bufnr
  " call FloatWin_FitWidthHeight()
  call nvim_win_set_config( g:floatWin_win, { 'width' : 100, 'height': 20 } )
  normal G
endfunc

" Separates 3 output types:
" - Forwards multi-line repl-outputs
" - Splits a list of strings into lines
" - Forwards other values
func! EdbReplSimpleResponseHandler( lines )
  " echo a:lines
  " return
  let l:lines = a:lines
  let l:lines = RemoveTermCodes( l:lines )
  let g:floatWin_win = FloatingSmallNew ( l:lines )
  call FloatWin_FitWidthHeight()
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
    " EdbRepl returned the typlical one value
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
    echo "EdbRepl returned 0 lines"
  " elseif len( l:lines ) > 15
  "   call PsShowLinesInBuffer( l:lines )
  else
    " call FloatWin_ShowLines( l:lines )
    let g:floatWin_win = FloatingSmallNew ( l:lines )
    " call VirtualtextShowMessage( join(l:lines[:1]), 'CommentSection' )
  endif

  call FloatWin_FitWidthHeight()
endfunc
" call EdbReplSimpleResponseHandler (["eins", "zwei"])



