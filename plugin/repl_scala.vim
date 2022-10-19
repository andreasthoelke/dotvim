
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

func! ScalaReplMainCallback(job_id, data, event)
  let lines = RemoveTermCodes( a:data )
  if len( lines )
    if stridx( lines[0], "RESULT" ) >= 0
      let resLines = [ lines[0][6:] ]
      " let g:floatWin_win = FloatingSmallNew ( [ result[5:] ] )
      " call FloatWin_FitWidthHeight()
      silent let g:floatWin_win = FloatingSmallNew ( resLines )
      silent call FloatWin_FitWidthHeight()
      silent wincmd p

    endif
  endif
endfunc

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
  " let g:floatWin_win = FloatingSmallNew([])
  " exec 'buffer' g:ScalaRepl_bufnr
  " call FloatWin_FitWidthHeight()
  " call nvim_win_set_config( g:floatWin_win, { 'width' : 100, 'height': 20 } )
  " normal G
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
func! ScalaReplSimpleResponseHandler( lines )
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



