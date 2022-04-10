
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
" echo 'eiens' =~ '^e' && 'eins' !~ 'a'

" Note: Buffer maps!
" ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..

func! tools_js#eval_line( ln, formatted, edgeql_preview, useTLBindNameAsExpression )

  " Workaround: The type info is based in 'hover' of the cursor loc, so we need to move the cursor here
  let l:maintainedCursorPos = getpos('.')
  exec "silent keepjumps normal! {"
  " moves cursor to the first code line (not a comment)
  let [sLine, sCol] = searchpos( '^\i', 'W' )
  exec "silent keepjumps normal! w"

  let lspTypeStr = v:lua.require('utils_lsp').type()
  let tlBindName = expand('<cword>')
  call setpos('.', l:maintainedCursorPos)
  redraw " so the float win will use the original cursor pos
  " echo tlBindName
  " return
  let typeStr = matchstr( lspTypeStr, '\v\:\s\zs.*' )
  let isPromise = typeStr =~ 'Promise'
  let isQuery = typeStr =~ 'expr_'

  if a:useTLBindNameAsExpression
    if tlBindName =~ 'e\d_'
      " echo "Can't eval a test-binding name. You can only eval the one-line expression of this binding!"
      " return
      let expression = matchstr( getline(a:ln), '\v\=\s\zs.*' )
    else
      let expression = tlBindName
    endif
  else
    let expression = matchstr( getline(a:ln), '\v\=\s\zs.*' )
    " let [startLine, endLine] = ParagraphStartEndLines() ■
    " if startLine - endLine != 0
    "   " paragraph mode!
    "   echo 'Paragraph mode is not supported yet. Eval the binding name instead (using gei)'
    "   return
    "   let firstLine = matchstr( getline(startLine), '\v\=\s\zs.*' )
    "   let lines = getline(startLine + 1, endLine)
    "   " let expression = join( [firstLine] + lines )
    "   let expression = [firstLine] + lines
    " else
    "   let expression = matchstr( getline(a:ln), '\v\=\s\zs.*' )
    " endif ▲
  endif

  if a:edgeql_preview
    let expression = expression . '.toEdgeQL()'
  elseif isQuery
    let expression = expression . '.run(db)'
  endif

  " Old
  " if expression =~ '^e\.' && expression !~ '\.run('
  "   let expression = expression . '.run(db)'
  " endif

  " let printStatement = 'console.log(' . expression . ')'

  " example: new Promise( (r) => r( runAsyc1() ) ).then( res => console.log( res ) )
  let ps = 'new Promise( (r) => r( ' . expression . ' ) ).then( res => console.log( res ) )'
  " Just in case the value of the expression is a promise we console.log in a callback

  let compl_sourceLines = tools_js#getStrOfBufAndCmd( ps )

  " let stdInStr = join( compl_sourceLines, "\n" ) ■
  " let resLines = systemlist( 'python -c ' . '"' . stdInStr . '"' )
  " let sourceFileName = repl_py#create_source_file( compl_sourceLines ) ▲

  " let filenameSource = expand('%:p:h') . '/replSrc_' . expand('%:t')
  let filenameSource = expand('%:p:h') . '/.rs_' . expand('%:t:r') . '.ts'
  " let filenameSource = "/Users/at/Documents/Server-Dev/edgedb/1playground/src/server/.rs_3pl.ts"
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
  " let resLines = systemlist( 'node --loader ts-node/esm -T ' . filenameSource )
  " let resLines = systemlist( 'node ' . filenameSource )

  " echoe resLines[0]

  if !a:formatted
    " Todo: how to silence the float window? e.i. not echo the file name
    silent let g:floatWin_win = FloatingSmallNew ( resLines )
    " silent call FloatingSmallNew ( resLines )
    " let g:floatWin_win = FloatWin_ShowLines ( resLines )
    " let g:floatWin_win = FloatWin_ShowLines_old ( resLines )
    silent call FloatWin_FitWidthHeight()
    silent wincmd p

  " elseif resLines[0] =~ '\v(with)|(select)'
  elseif a:edgeql_preview
    silent let g:floatWin_win = FloatingSmallNew ( resLines )
    silent call FloatWin_FitWidthHeight()
    silent wincmd p

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
    silent wincmd p

    " Collection returned:
  elseif resLines[-1] =~ "[\[|\{|\(]"
  " elseif 0
    let expResult = resLines[-1]
    " echoe expResult

    if len( expResult ) > 3
      " call v:lua.VirtualTxShow( expResult[:20] . ' ..' )
      let linesResult = repl_py#splitToLines( expResult )
      " echoe linesResult
      " call FloatWin_ShowLines_old ( linesResult )
      let g:floatWin_win = FloatingSmallNew ( linesResult )
      " call FloatWin_ShowLines ( repl_py#splitToLines( expResult ) )
      " if len(linesResult) > 2
      call repl_py#alignInFloatWin()
      " endif
    else
      " call v:lua.VirtualTxShow( expResult )
    endif

  else
    " Printed object:
    let g:floatWin_win = FloatingSmallNew ( resLines )
    " if len(resLines) > 2
      call repl_py#alignInFloatWin()
    " endif
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

