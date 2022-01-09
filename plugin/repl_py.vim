





" ─   Sync IVR                                          ──
" ~/.config/nvim/notes/inline-values-repl.md#/#%20Inline%20Values

nnoremap <silent> gee :call repl_py#eval_line( line('.') )<cr>
nnoremap <silent> gei :call repl_py#eval_line( line('.') )<cr>

func! repl_py#create_source_file( source_lines )
  let filename = expand('%:p:h') . '/replSrc_' . expand('%:t')
  call writefile( a:source_lines, filename )
  return filename
endfun

func! repl_py#eval_line( ln )
  let expression = matchstr( getline(a:ln), '\v\=\s\zs.*' )
  let printStatement = 'print(' . expression . ')'
  let compl_sourceLines = repl_py#getStrOfBufAndCmd( printStatement )
  let stdInStr = join( compl_sourceLines, "\n" )
  " echo completeSource
  let sourceFileName = repl_py#create_source_file( compl_sourceLines )
  " echo sourceFileName
  " return
  " let resLines = systemlist( 'python -c ' . '"' . stdInStr . '"' )
  let resLines = systemlist( 'python ' . sourceFileName )
  let expResult = resLines[-1]

  if len( expResult ) > 8
    let res_lineWise = [expResult]
    " let res_lineWise = substitute( expResult, '\v[\[|\]]', '', 'g' )
    " let res_lineWise = substitute( res_lineWise, '\v,\zs\s', '', 'g' )
    " let res_lineWise = split( res_lineWise, ',' )
    " let g:floatWin_win = v:lua.vim.lsp.util.open_floating_preview( [expResult] )
    let g:floatWin_win = v:lua.vim.lsp.util.open_floating_preview( res_lineWise )

    call v:lua.VirtualTxShow( expResult[:20] . ' ..' )
  else
    call v:lua.VirtualTxShow( expResult )
  endif

  " call VirtualtextShowMessage( expResult , "CommentSection" )

endfunc

func! repl_py#getStrOfBufAndCmd ( cmd_str )
  return add( getline(1, "$"), a:cmd_str )
endfunc



" ─   Async REPL                                        ──

" Repl multiple lines:
" nnoremap gel      :let g:opContFn='PyReplEvalLines'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
" vnoremap gel :<c-u>let g:opContFn='PyReplEvalLines'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

func! PyReplEvalLines( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  " let l:lines = getline( startLine, endLine)
  " call PsShowLinesInBuffer( l:lines )
  " for lineStr in l:lines
  for lineNum in range(startLine, endLine)
    " call PyReplEval( GetPyReplExprLN( lineNum ) )
    call PyReplEval( getline('.') )
  endfor
endfunc

func! GetPyReplExprLN( lineNum )
  if IsEmptyLine( a:lineNum )
    return ""
  endif

  let lineList                = split( getline( a:lineNum ) )
  let secondWordOnwards       = join( l:lineList[1:], ' ')
  let expressionOfBind        = join( l:lineList[2:], ' ')
  let topLevelSymbol          = lineList[0]
  let concealedBindingLine    = lineList[0][0:1] == 'cb'
  let testBindingLine         = lineList[0][0:1] =~ 'e\d'
  let isDeclarationWithNoArgs = lineList[1] == '='
  let isToplevelLine          = IndentLevel( a:lineNum ) == 1
  let cursorIsAtStartOfLine   = col('.') == 1 " not sure where?

  if IsImportLine( a:lineNum )
    return getline( a:lineNum )
  elseif IsDoStartLine( a:lineNum )
    return topLevelSymbol
  elseif concealedBindingLine || testBindingLine
    return expressionOfBind
  elseif CursorIsInsideStringOrComment()
    return secondWordOnwards
  elseif IsTypeSignLine( a:lineNum )
    return topLevelSymbol
  elseif IsTypeSignLineWithArgs( a:lineNum )
    return topLevelSymbol
  elseif CursorIsAtStartOfWord()
    return expand('<cword>')
  elseif isToplevelLine && isDeclarationWithNoArgs
    " echoe 'declaration with no args'
    return topLevelSymbol
  else
    echoe 'Could not extract an expression!'
  endif
endfunc


nnoremap <silent> <leader>ro :call PyReplStart()<cr>
nnoremap <silent> <leader>rq :call PyReplStop()<cr>
" nnoremap <silent> <leader>rl :call ReplEval('import ' . GetModuleName())<cr>
" nnoremap <silent> dr         :call ReplEval(':reload')<cr>:call ReplReload_Refreshed( expand('%') )<cr>
nnoremap <silent> dr         :call PyReplReload()<cr>
" nnoremap          <leader>ri :exec "Pimport " . expand('<cword>')<cr>

" Obsolete: use ~/.vim/plugin/HsAPI.vim#/Browse%20modules%20uses
" nnoremap <silent> <leader>rb      :call ReplEval(':browse ' . input( 'Browse module: ', expand('<cWORD>')))<cr>
" vnoremap <silent> <leader>rb :<c-u>call ReplEval(':browse ' . input( 'Browse module: ', GetVisSel()))<cr>

" nnoremap <silent> gei      :silent call PyReplEval( GetPyReplExprLN( line('.') ) )<cr>
" nnoremap <silent> gei      :silent call PyReplEval( GetLineFromCursor() )<cr>
" vnoremap <silent> gei :<c-u>call PyReplEval( Get_visual_selection() )<cr>

" now moved to ~/.vim/plugin/HsAPI.vim#/Get%20.type%20from
" nnoremap get      :call PyReplEval( '?' . expand('<cword>') )<cr>
" vnoremap get :<c-u>call PyReplEval( '?' . GetVisSel() )<cr>



" Note that the following functions are linked by referring to the same Psci session (PursPyReplID)
command! PyReplStart :let g:PursPyReplID = jobstart("ipython", g:PyReplCallbacks)

func! PyReplStart ()
  if exists('g:PursPyReplID')
    echo 'PyRepl is already running'
    return
  endif
  exec "new"
  " let g:PursPyReplID = jobstart("ipython", g:PyReplCallbacks)
  let g:PursPyReplID = termopen("ipython", g:PyReplCallbacks)
endfunc

func! TestTer()
  " call FloatWin_ShowLines( ['eins', 'zwei'] )
  " call FloatWin_FocusFirst()
  exec "new"
  let g:PursPyReplID = termopen(g:cm, g:PyReplCallbacks)
endfunc

func! PyReplStop ()
  if !exists('g:PursPyReplID')
    echo 'PyRepl is not running'
    return
  endif
  call jobstop( g:PursPyReplID )
  unlet g:PursPyReplID
endfunc

func! PyReplReload ()
  call jobsend(g:PursPyReplID, "%run " . expand('%') . "\n")
endfunc

func! PyReplLoadCurrentModule ()
  call PyReplEval ( 'import ' . GetModuleName() )
endfunc

func! PyReplMainCallback(job_id, data, event)
  call PyReplSimpleResponseHandler (a:data)
endfunc

func! PyReplErrorCallback(job_id, data, event)
  echom a:data
endfunc

func! PyReplExitCallback(job_id, data, event)
  echom a:data
endfunc


let g:PyReplCallbacks = {
      \ 'on_stdout': function('PyReplMainCallback'),
      \ 'on_stderr': function('PyReplErrorCallback'),
      \ 'on_exit': function('PyReplExitCallback')
      \ }

func! PyReplEval( expr )
  " if a:expr =~ '^.*--.*$' || a:expr =~ '^$' | return | endif
  " if PyReplReload_FileNeedsReplReload(expand('%'))
    " call PyReplReload()
  " endif
  call jobsend(g:PursPyReplID, a:expr . "\n")
endfunc

" ANSI colors are incoded into the error messages and need to be removed (TODO there is also a setting for psci). e.g.  [32m'Done!'[39m
let g:PyReplaceBashEscapeStrings = [['[33m',''], ['[32m',''], ['[39m',''], ['[0m','']]

" Separates 3 output types:
" - Forwards multi-line repl-outputs
" - Splits a list of strings into lines
" - Forwards other values
func! PyReplSimpleResponseHandler( lines )
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
    " PyRepl returned the typlical one value
    call VirtualtextShowMessage( l:lines[0], 'CommentSection' )
    let hsReturnVal = l:lines[0]
    if hsReturnVal[0:1] == '["'
      " Detected list of strings: To split the list into lines, convert to vim list of line-strings!
      call FloatWin_ShowLines( eval ( hsReturnVal ) )
    else
      call FloatWin_ShowLines( [hsReturnVal] )
    endif
  elseif len( l:lines ) == 0
    echo "PyRepl returned 0 lines"
  " elseif len( l:lines ) > 15
  "   call PsShowLinesInBuffer( l:lines )
  else
    call FloatWin_ShowLines( l:lines )
    call VirtualtextShowMessage( join(l:lines[:1]), 'CommentSection' )
  endif
endfunc
" call PyReplSimpleResponseHandler (["eins", "zwei"])








