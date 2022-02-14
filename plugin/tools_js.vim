
func! RunJSCode ( code )
  let nodeCmd = 'console.log( ' . a:code . ' )'
  let l:cmd = 'node -e ' . shellescape( nodeCmd )
  let resLines = systemlist( l:cmd )
  return resLines
endfunc

func! RunJSLines ()
  let code = GetVisSel()
  echo RunJSCode( code )
endfunc

" Executes the code in an isolated process (no access to app variables, only the DOM)
" Returns the return value of (synchronous) expression.
func! RunJSFileInBrowser ( fileName )
  let cmd = 'JS=$(cat ' . a:fileName . ') && chrome-cli execute "$JS"'
  return system( cmd )
endfunc

" Evaluates the code in the app process by injecting it into a MutationObserver element.
func! EvalInBrowserApp ( fileName )
  let lines = readfile( a:fileName, "\n" )
  let jsCode = shellescape( join( lines, '\n' ) )
  let compl_sourceLines = 'document.getElementById("evalCode").innerHTML = ' . jsCode

  let sourceFileName = repl_py#create_source_file( [compl_sourceLines] )
  echo sourceFileName
  return
  call EvalJSFileInBrowser( sourceFileName )
endfunc
" call EvalInBrowserApp( "/Users/at/Documents/UI-Dev/React1/graphin1/scratch/rep_test2.js" )


command! -range=% JSRun call JSRun( <line1>, <line2> )
" Note: this applies to the whole buffer when no visual-sel

" nnoremap <leader>dl :call DBRun( line('.'), line('.') )<cr>
" nnoremap <leader>d :let g:opContFn='DBRun'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
" vnoremap <leader>d :<c-u>let g:opContFn='DBRun'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

" nnoremap <silent> gej :call tools_js#eval_line( line('.') )<cr>

func! JSRun( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  " let rangeStr = startLine . ',' . endLine
  let lines = getline(startLine, endLine)
  let sqlStr = join(lines, "\n")

  let rows = db_ui#query( sqlStr )
  if len( rows ) == 0
    echo "query completed!"
    return
  endif

  let g:query_res = rows

  let str_rows = functional#map( 'string', rows )

  " let linesResult = repl_py#splitToLines( string( rows ) )

  let g:floatWin_win = FloatingSmallNew ( str_rows )

  call tools_db#alignInFloatWin()

endfunc

func! tools_js#json_stringify( expressionCodeStr )
  return tools_js#eval_expression( 'JSON.stringify(' . a:expressionCodeStr . ')' )
endfunc


func! tools_js#eval_expression( expressionCodeStr )
  let tmpFileName = tempname() . '.js'
  let printStatement = 'console.log(' . a:expressionCodeStr . ')'
  call writefile( [printStatement], tmpFileName )

  let res = system( 'node ' . tmpFileName )
  call delete( tmpFileName )
  return res
endfunc
" echo tools_js#eval_expression( '{aa: 44, bb: "eins"}.aa' )


" Note: Buffer maps!
" ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..

func! tools_js#eval_line( ln, plain )
  " if !(&filetype == 'python')
  "   echo "This is not a Python file!"
  "   return
  " endif
  let expression = matchstr( getline(a:ln), '\v\=\s\zs.*' )
  let printStatement = 'console.log(' . expression . ')'
  let compl_sourceLines = tools_js#getStrOfBufAndCmd( printStatement )

  " let stdInStr = join( compl_sourceLines, "\n" ) ■
  " let resLines = systemlist( 'python -c ' . '"' . stdInStr . '"' )
  " let sourceFileName = repl_py#create_source_file( compl_sourceLines ) ▲

  " let filenameSource = expand('%:p:h') . '/replSrc_' . expand('%:t')
  let filenameSource = expand('%:p:h') . '/.replSrc_' . expand('%:t:r')
  " let filenameBuild  = expand('%:p:h') . '/replBuild_' . expand('%:t')
  " let filenameBuild  = expand('%:p:h') . '/replBuild_' . expand('%:t:r') . '.mjs'
  call writefile( compl_sourceLines, filenameSource )
  " echo expand('%:r')

  " call system( 'npx babel ' . filenameSource . ' --out-file ' . filenameBuild )
  " call system( 'tsc ' . filenameSource . ' --outfile ' . filenameBuild )
  " call system( 'npx swc ' . filenameSource . ' -o ' . filenameBuild )
  " let resLines = systemlist( 'node ' . filenameBuild )
  " npx ts-node -T src/main.ts
  let resLines = systemlist( 'npx ts-node -T ' . filenameSource )
  " let resLines = systemlist( 'node ' . filenameSource )

  if a:plain
    let g:floatWin_win = FloatingSmallNew ( resLines )

    " We have reveived a printed nd_array if the first line starts with [[ and has no commas!
  elseif resLines[0][0:1] == "[[" && !(resLines[0] =~ ",")
    " if 0
    " echo "ndarray"
    let g:floatWin_win = FloatingSmallNew ( resLines )

    call FloatWin_FocusFirst()
    exec "%s/\\[//ge"
    exec "%s/]//ge"
    " exec "%s/'//ge"
    call easy_align#easyAlign( 1, line('$'), ',')
    call FloatWin_FitWidthHeight()
    wincmd p

    " Collection returned:
  elseif resLines[-1] =~ "[\[|\{|\(]"
  " elseif 0
    let expResult = resLines[-1]
    " echoe expResult

    if len( expResult ) > 3
      call v:lua.VirtualTxShow( expResult[:20] . ' ..' )
      let linesResult = repl_py#splitToLines( expResult )
      " echoe linesResult
      " call FloatWin_ShowLines_old ( linesResult )
      let g:floatWin_win = FloatingSmallNew ( linesResult )
      " call FloatWin_ShowLines ( repl_py#splitToLines( expResult ) )
      if len(linesResult) > 2
        call repl_py#alignInFloatWin()
      endif
    else
      call v:lua.VirtualTxShow( expResult )
    endif

  else
    " Printed object:
    let g:floatWin_win = FloatingSmallNew ( resLines )
    if len(resLines) > 2
      call repl_py#alignInFloatWin()
    endif
  endif

endfunc

" Approach: The inline values are bound to variables named "e<int>_<funcname> = expression"
" These variables are commented out in the repl-execution file. Only the expression of the executed line will be appended in a print statement.
func! tools_js#getStrOfBufAndCmd ( cmd_str )
  let bufferLines = getline( 0, "$" )
  let replLines = functional#map( {lineStr -> substitute( lineStr, '\zeconst\se\d_', '// ', 'g' )}, bufferLines )
  return add( replLines, a:cmd_str )
endfunc

" echo substitute( 'const e3_eins = 33', '\zeconst\se\d_', '// ', 'g' )
" echo functional#map( {lineStr -> substitute( lineStr, '\zeconst\se\d_', '// ', 'g' )}, ['const e3_eins = 33', 'const zwei = 33'] )






