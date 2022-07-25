" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_js#bufferMaps()

  " tools_js#eval_line( ln, formatted, edgeql_preview, useTLBindNameAsExpression )
  " nnoremap <silent><buffer> gel :call tools_js#eval_line( line('.'), v:true, v:false, v:false )<cr>
  " nnoremap <silent><buffer> gei :call tools_js#eval_line( line('.'), v:true, v:false, v:true )<cr>
  " nnoremap <silent><buffer> geL :call tools_js#eval_line( line('.'), v:true, v:true, v:false )<cr>
  " nnoremap <silent><buffer> geI :call tools_js#eval_line( line('.'), v:true, v:true, v:true )<cr>
  " nnoremap <silent><buffer> <leader>gel :call tools_js#eval_line( line('.'), v:false, v:false, v:false )<cr>
  " nnoremap <silent><buffer> <leader>gei :call tools_js#eval_line( line('.'), v:false, v:false, v:true )<cr>
  " nnoremap <silent><buffer> <leader>geL :call tools_js#eval_line( line('.'), v:false, v:true, v:false )<cr>
  " nnoremap <silent><buffer> <leader>geI :call tools_js#eval_line( line('.'), v:false, v:true, v:true )<cr>


  nnoremap <silent><buffer>         gei :call System_Float( JS_EvalParagIdentif_simple() )<cr>

  " nnoremap <silent><buffer>         gei :call tools_js#eval_line( line('.'), v:true, v:false, v:false )<cr>
  nnoremap <silent><buffer> <leader>gei :call tools_js#eval_line( line('.'), v:false, v:false, v:false )<cr>

  nnoremap <silent><buffer>         gel :call JS_ComponentShow()<cr>

  nnoremap <silent><buffer> <c-n> :call JS_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <c-p> :call JS_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>

  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_js()<cr>
  nnoremap <silent><buffer> <leader>eT :call CreateInlineTestDec_js_function()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

endfunc


func! JS_EvalParagIdentif_simple()
  if IndentLevel( line('.') ) == 1
    let identLineNum = line('.')
    let firstWord = split( getline('.') )[0]
    if firstWord != 'export'
      if !(expand('%:e') == 'mjs') " rescript files already export all identifiers.
        let lineText = getline( line('.') )
        " normal dd
        call append( '.', 'export ' . lineText )
        normal dd
        return "echo 'line exported!'"
      endif
    endif
  else
    " let identLineNum = searchpos( '^let\s\(e\d_\)\@!', 'cnb' )[0]
    let identLineNum = searchpos( '^const\s', 'cnb' )[0]
  endif
  let identif = matchstr( getline( identLineNum ), '\v(const|var)\s\zs\i*\ze\W' )
  " echo identLineNum identif
  " return

  " TODO: remove the types, change the file extension so I can use node not ts-node
  " let filePath = expand('%:p:h')
  " let _compl_ = system( 'tsc ' . filePath )

  return JS_NodeCall( identif )
endfunc

func! JS_NodeCall( identif )
  let filePath = getcwd() . CurrentRelativeFilePath()

  " Note: This is only needed in .mjs files. it basically only changes the file extension for ts-node to work
  let fileExtension = fnamemodify( filePath, ':e' )
  if fileExtension == 'mjs'
    let lines = readfile( filePath, '\n' )
    let filePath = filePath . '.ts'
    call writefile(lines, filePath)

    " Optional: Delete this temp file
    call JS_DeleteFileDelayed( filePath )
    " Also: could add more conditions here like: if !(getline('.') =~ 'export')
  endif

  " TODO: move this into a JS file. try to integrate console.table( [obj1, obj2], ["columnName1", "colName2"] )

  let filePathPrinter = getcwd() . "/scratch/.testPrinter.ts"

  let lines = []
  call add( lines, 'const printer = require("' . filePathPrinter . '");' )

  call add( lines, "require(\"util\").inspect.defaultOptions.depth = 4;" )
  " call add( lines, "const util = require(\"node:util\");" )
  call add( lines, "function isPromise(p) { if (typeof p === \"object\" && typeof p.then === \"function\") { return true; } return false; }; " )
  " call add( lines, "function ensureArray(v) { if (typeof v === \"object\" && typeof v.then === \"function\") { return v; } return [v]; }; " )

  call add( lines, "function execIdentif (symb) { " )
  call add( lines,    "if     (typeof symb == \"function\" ) { console.log( symb() ) " )
  call add( lines,    "} else if (isPromise(symb))              { symb.then( v => console.log( v ) ) " )
  " call add( lines,    "} else if (isPromise(symb))              { symb.then( v => Promise.all( ensureArray( v ) ).then( w => console.log( w ) ) ) " )
  call add( lines,    "} else                                  { console.log( symb ) }; " )
  call add( lines, "}; " )

  " call add( lines, 'const modu = require("' . filePath . '"); execIdentif(modu.' . a:identif . ')' )
  call add( lines, 'const modu = require("' . filePath . '");' )

  call add( lines, 'printer.execIdentif(modu.' . a:identif . ')' )

  " return "node -e '" . js_code_helperFn . js_code_importCall . "'"
  return "npx ts-node --transpile-only -T  -e '" . join( lines ) . "'"
  " NOTE: .mjs files do not work with ts-node
endfunc
" let @" = JS_NodeCall( expand('<cword>') ) ■
  " example: new Promise( (r) => r( runAsyc1() ) ).then( res => console.log( res ) )
  " let ps = 'new Promise( (r) => r( ' . expression . ' ) ).then( res => console.log( res ) )'
  " Just in case the value of the expression is a promise we console.log in a callback
  " node -e "import('<path>').then(m => console.log(m.abc1))"
  " let js_code_statement = 'import("' . filePath . '").then(m => console.log(m.' . a:identif . '))'
  " let js_code_statement = 'import("' . filePath . '").then(m => console.log(m.' . a:identif . '()' . '))'
  " let js_code_importCall = 'import("' . filePath . '").then(m => execIdentif(m.' . a:identif . '))'
  " let js_code_importCall = 'const modu = require("' . filePath . '"); execIdentif(modu.' . a:identif . ')' ▲

func! JS_DeleteFileDelayed( filePath )
  let delFileCmd = "call system( 'del " . a:filePath . "' )"
  " echo delFileCmd
  call T_DelayedCmd( delFileCmd, 400 )
  " call T_DelayedCmd( "echo 'hi there'", 1000 )
  "  "call system( 'del ' . fname )"
endfunc

func! JS_ComponentShow()
  if IndentLevel( line('.') ) == 1
    let identLineNum = line('.')
  else
    let identLineNum = searchpos( '^export\s', 'cnb' )[0]
  endif
  if getline( identLineNum ) =~ 'default'
    let binding = 'ShowComp'
  else
    let identif = matchstr( getline( identLineNum ), '\v(function|const)\s\zs\i*\ze\W' )
    let binding = "{ " . identif . " as ShowComp }"
  endif
  let moduleName = expand('%:t:r')
  call JS_ComponentShow_UpdateFile( binding, moduleName )
endfunc

" File ./src/ShowJS.res is set to have the following lines:
" import ShowComp from "./A_markup"
" import { Identif as ShowComp } from "./A_markup"
" export default ShowComp
func! JS_ComponentShow_UpdateFile( binding, module )
  let makeBinding = "import " . a:binding . " from './" . a:module . "'"
  let lines = [makeBinding, "export default ShowComp"]
  let folderPath = expand('%:p:h')
  let filePath = folderPath . '/ShowJS.jsx'
  " Overwrite the Show.res file
  call writefile( lines, filePath)
endfunc



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
  if expand('<cword>') == 'const'
    " this might be an export statement
    exec "silent keepjumps normal! w"
  endif

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

  " Todo: use a separate printer file: ~/.config/nvim/notes/TestServer-TestClient.md#/#%20TODO.%20Normal 
  let compl_sourceLines = tools_js#getStrOfBufAndCmd( ps )

  " let stdInStr = join( compl_sourceLines, "\n" ) ■
  " let resLines = systemlist( 'python -c ' . '"' . stdInStr . '"' )
  " let sourceFileName = repl_py#create_source_file( compl_sourceLines ) ▲

  " let filenameSource = expand('%:p:h') . '/replSrc_' . expand('%:t')
  let filenameSource = expand('%:p:h') . '/.rs_' . expand('%:t:r') . '.ts'
  " The `.mjs` extension seems needed to avoid `export` and `module` errors
  " let filenameSource = expand('%:p:h') . '/.rs_' . expand('%:t:r') . '.mjs'
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

func! JS_TopLevBindingForw()
  " normal! j
  call search( '\v^(export|function|var|const|let)\s', 'W' )
endfunc

func! JS_TopLevBindingBackw()
  call search( '\v^(export|function|var|const|let)\s', 'bW' )
  " normal! {
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc






