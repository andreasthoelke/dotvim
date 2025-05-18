" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..

" nnoremap <silent> gee :call UserChoiceAction( ' ', {}, T_MenuCommands(), function('TestServerCmd'), [] )<cr>
nnoremap <silent> gee :call T_Menu()<cr>


func! JS_bufferMaps()
  call Scala_bufferMaps_shared()

  " nnoremap <silent><buffer> <leader>ca :TSLspImportCurrent<cr>
  " nnoremap <silent><buffer> <leader>cA :TSLspImportAll<cr>

  " nnoremap <silent><buffer> <leader>ca :TSLspImportCurrent<cr>
  nnoremap <silent><buffer> <leader>ca :LspCodeAction<cr>
  " not working
  " nnoremap <silent><buffer> <leader>,ci <cmd>lua vim.lsp.buf.code_action({ apply = true, context = { only = { "source.addMissingImports.ts" } } })<CR>
  " nnoremap <silent><buffer> <leader>ci :lua vim.lsp.buf.code_action({ apply = true, context = { only = { "source.addMissingImports.ts", "source.fixAll.ts" } } })<CR>

  " nnoremap <silent><buffer> gew :call T_DoSetImport()<cr>
  nnoremap <silent><buffer> gew :call JS_SetPrinterIdentif()<cr>
  " nnoremap <silent><buffer> gej :call T_DoSetImport()<cr>
  nnoremap <silent><buffer> gef :call T_Refetch("Client")<cr>
  " nnoremap <silent><buffer> gei :call T_Refetch("Printer")<cr>

  " TODO: test this
  " nnoremap <silent><buffer>         gei :call JS_eval_line( line('.'), v:true, v:false, v:false )<cr>
  " nnoremap <silent><buffer> <leader>gei :call JS_eval_line( line('.'), v:false, v:false, v:false )<cr>
  " nnoremap <silent><buffer>         gel :call JS_ComponentShow()<cr>

  " JS_eval_line( ln, formatted, edgeql_preview, useTLBindNameAsExpression )
  " nnoremap <silent><buffer> gel :call JS_eval_line( line('.'), v:true, v:false, v:false )<cr>
  " nnoremap <silent><buffer> gei :call JS_eval_line( line('.'), v:true, v:false, v:true )<cr>
  " nnoremap <silent><buffer> geL :call JS_eval_line( line('.'), v:true, v:true, v:false )<cr>
  " nnoremap <silent><buffer> geI :call JS_eval_line( line('.'), v:true, v:true, v:true )<cr>
  " nnoremap <silent><buffer> <leader>gel :call JS_eval_line( line('.'), v:false, v:false, v:false )<cr>
  " nnoremap <silent><buffer> <leader>gei :call JS_eval_line( line('.'), v:false, v:false, v:true )<cr>
  " nnoremap <silent><buffer> <leader>geL :call JS_eval_line( line('.'), v:false, v:true, v:false )<cr>
  " nnoremap <silent><buffer> <leader>geI :call JS_eval_line( line('.'), v:false, v:true, v:true )<cr>

  " nnoremap <silent><buffer>         gei :call System_Float( JS_EvalParagIdentif_simple() )<cr>
  nnoremap <silent><buffer>         gei :call JS_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer> <leader>gei :call JS_RunPrinter( "term"  )<cr>
  nnoremap <silent><buffer>        ,gei :call JS_RunPrinter( "term_float"  )<cr>
  nnoremap <silent><buffer>         geh :call JS_RunPrinter( "term_hidden"  )<cr>
  " nnoremap <silent><buffer>         gew :call TsPlus_SetPrinterIdentif()<cr>
  " nnoremap <silent><buffer>         gep :call TsPlus_RunPrinter()<cr>
  " nnoremap <silent><buffer>         geP :call TsPlus_RunPrinter_InTerm()<cr>


" ─   Motions                                           ──
" ~/.config/nvim/plugin/ftype/python.vim‖*Motions

  nnoremap <silent><buffer> <c-p>         :call JS_BindingBackw()<cr>
  " nnoremap <silent><buffer> <leader><c-n> :call JS_MvEndOfBlock()<cr>
  nnoremap <silent><buffer> <leader><c-n> :call JS_TopLevBindingForw()<cr>
  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <c-n>         :call JS_BindingForw()<cr>

  " GO RETURN motions
  nnoremap <silent><buffer> ]r            :keepjumps call JS_GoReturn()<cr>
  nnoremap <silent><buffer> [r            :call JS_GoBackReturn()<cr>
  " nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <leader><c-p> :call JS_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>



  " nnoremap geR :Glance references<CR>
  " nnoremap geD :Glance definitions<CR>
  " nnoremap geY :Glance type_definitions<CR>
  " nnoremap geM :Glance implementations<CR>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_js('normal')<cr>
  nnoremap <silent><buffer> <leader>eT :call CreateInlineTestDec_js('async')<cr>
  nnoremap <silent><buffer> <leader>ev :call CreateInlineTestDec_js_nvim()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

  nnoremap <silent><buffer> <leader>ebc :call CreateJS_fewerBraces_c()<cr>



  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  " nnoremap <silent><buffer> ged :Trouble diagnostics toggle focus=false filter.buf=0<cr>
  " nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  " nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>

" ─   Lsp                                                ■

  " Copied from Scala

  nnoremap <silent><buffer> <leader>/   :lua require('telescope.builtin').lsp_document_symbols()<cr>
  nnoremap <silent><buffer> <leader>ot  :Outline<cr>
  nnoremap <silent><buffer> ,ot  :Vista nvim_lsp<cr>

  " nnoremap <silent><buffer> <leader>gek :call Scala_LspTopLevelHover()<cr>
  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>
  nnoremap <silent><buffer>         geK :lua vim.lsp.buf.signature_help()<cr>
  nnoremap <silent><buffer> ,sl :lua require('telescope.builtin').lsp_document_symbols()<cr>
  " nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({layout_config={vertical={sorting_strategy="ascending"}}})<cr>
  " " TODO: gsl seems more consistent
  nnoremap <silent><buffer> gel :echo 'use gsl'<cr>
  nnoremap <silent><buffer> geL :echo 'use gsL'<cr>
  " nnoremap <silent><buffer> gsl :lua require('telescope.builtin').lsp_document_symbols({initial_mode='insert'})<cr>
  " nnoremap <silent><buffer> gsL <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
  nnoremap <silent><buffer> gsl :call v:lua.Telesc_launch('lsp_document_symbols')<cr>
  nnoremap <silent><buffer> gsL :call v:lua.Telesc_launch('lsp_dynamic_workspace_symbols')<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  " nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  " nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>
  " TS diagnostics
  nnoremap <silent><buffer> <leader>ged :Telescope diagnostics initial_mode=normal<cr>
  nnoremap <silent><buffer> ged :Trouble diagnostics toggle focus=false filter.buf=0<cr>
  nnoremap <silent><buffer> geD :Trouble diagnostics toggle focus=false<cr>
  " nice using a qf list view and a preview. preview only shows up when cursor is in the qf list. else i can navigate with ]q [q
  nnoremap <silent><buffer> geR :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  " " this is small and local
  " nnoremap <silent><buffer> ger :lua require('telescope.builtin').lsp_references(require('telescope.themes').get_cursor({initial_mode='normal', layout_config={width=0.95, height=25}}))<cr>
  nnoremap <silent><buffer> ,ger <cmd>TroubleToggle lsp_references<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  nnoremap <silent><buffer> ger <cmd>Glance references<cr>
  " doesn't seem to work properly. using ]d for now
  " nnoremap <silent><buffer> ge] :lua require("trouble").next({skip_groups = true, jump = true})<cr>
  " nnoremap <silent><buffer> ge[ :lua require("trouble").previous({skip_groups = true, jump = true})<cr>
  nnoremap <silent><buffer> <leader>lr :lua vim.lsp.buf.rename()<cr>


endfunc

func! JS_MvEndOfBlock()
  normal! m'
  call JumpNextNonEmptyLine()
  call search( '\v^\S', 'W' )
endfunc

func! JS_MvEndOfPrevBlock()
  call JS_TopLevBindingBackw()
  call JS_TopLevBindingBackw()
  call JS_MvEndOfBlock()
endfunc



func! JS_Identif_ParagExport()

  let hostLn1 = searchpos( '^const\s', 'cnbW' )[0]
  let hostLn2 = searchpos( '^export\sconst\s', 'cnbW' )[0]
  let hostLn3 = searchpos( '\v^(async\s)?function', 'cnbW' )[0]

  let hostLn = max( [hostLn1, hostLn2, hostLn3] )
  let hostDecName = matchstr( getline(hostLn ), '\v(const|function)\s\zs\i*\ze\W' )

  let firstWord = split( getline( hostLn ) )[0]
  if firstWord != 'export'
    let [oLine, oCol] = getpos('.')[1:2]
    call setpos('.', [0, hostLn, 0, 0] )
    let lineText = getline( hostLn )
    call append( hostLn, 'export ' . lineText )
    normal dd
    call setpos('.', [0, oLine, oCol, 0] )
  endif

  call VirtualRadioLabel_lineNum( '«', hostLn )
  return hostDecName
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


  " call writefile( lines, 'tempPrinter.js' )

  " return "node -e '" . js_code_helperFn . js_code_importCall . "'"
  return "npx ts-node --transpile-only -T  -e '" . join( lines ) . "'"
  " return "npx ts-node --trace-deprecation --transpile-only -T  -e '" . join( lines ) . "'"

  " return "node --loader ts-node/esm -e '" . join( lines ) . "'" 


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

" Process: import identif into runPrinter.ts, build --watch will update runPrinter.js
" - source file:   packages/app/src/mySourceFile.ts
" - printer:       packages/app/src/runPrinter.ts
" - module:        @org/app/mySourceFile
" - printer (run): packages/app/build/esm/runPrinter.js

func! TsPlus_SetPrinterIdentif()
  " Create the import statement of the test identif under the cursor
  let [packageName, modulePath] = ModulePath_MonoRepo()
  " let [identif, _] = T_ImportInfo()
  let identif = JS_Identif_ParagExport()
  let importStm = "import { " . identif . " as testIdentif } from '" . modulePath . "'"

  let g:TsPlusPrinter_packageName = packageName

  " Overwrite with first import line in the printer.ts (needs to be in the same folder as the source file for now)
  let printerFilePath = expand('%:p:h') . '/runPrinter.ts'
  let printerLines = readfile( printerFilePath, '\n' )
  let printerLines[0] = importStm
  call writefile( printerLines, printerFilePath )
  " call VirtualRadioLabel('«')
endfunc

func! TsPlus_RunPrinter()
  " node packages/app/build/esm/runPrinter.js
  let printerRunnablePath = 'packages/' . g:TsPlusPrinter_packageName . '/build/esm/runPrinter.js'
  echom printerRunnablePath
  " call System_Float( 'node ' . printerRunnablePath )
  " call System_Float( 'yarn build && node ' . printerRunnablePath )
  " NOTE: there needs to be a build script in packagage json with "tsc -b tsconfig.json"
  call System_Float( 'yarn build-all && node ' . printerRunnablePath )
endfunc

func! TsPlus_RunPrinter_InTerm()
  " node packages/app/build/esm/runPrinter.js
  let printerRunnablePath = 'packages/' . g:TsPlusPrinter_packageName . '/build/esm/runPrinter.js'
  " echom printerRunnablePath
  " call System_Float( 'node ' . printerRunnablePath )
  call TermOneShot( 'yarn build && node ' . printerRunnablePath )
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

" nnoremap <silent> gej :call JS_eval_line( line('.') )<cr>

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

func! JS_json_stringify( expressionCodeStr )
  return JS_eval_expression( 'JSON.stringify(' . a:expressionCodeStr . ')' )
endfunc


func! JS_eval_expression( expressionCodeStr )
  let tmpFileName = tempname() . '.js'
  let printStatement = 'console.log(' . a:expressionCodeStr . ')'
  call writefile( [printStatement], tmpFileName )

  let res = system( 'node ' . tmpFileName )
  call delete( tmpFileName )
  return res
endfunc
" echo JS_eval_expression( '{aa: 44, bb: "eins"}.aa' )
" echo 'eiens' =~ '^e' && 'eins' !~ 'a'

" Note: Buffer maps!
" ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..

func! JS_eval_line( ln, formatted, edgeql_preview, useTLBindNameAsExpression )

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
  let compl_sourceLines = JS_getStrOfBufAndCmd( ps )

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
func! JS_getStrOfBufAndCmd ( cmd_str )
  let bufferLines = getline( 0, "$" )
  let replLines = functional#map( {lineStr -> substitute( lineStr, '\zeconst\se\d_', '// ', 'g' )}, bufferLines )
  return add( replLines, a:cmd_str )
endfunc

" echo substitute( 'const e3_eins = 33', '\zeconst\se\d_', '// ', 'g' )
" echo functional#map( {lineStr -> substitute( lineStr, '\zeconst\se\d_', '// ', 'g' )}, ['const e3_eins = 33', 'const zwei = 33'] )

" func! JS_TopLevBindingForw()
"   " normal! j
"   call search( '\v^(async|\s\s(private\s)?async\s\zs\i|final|override|case|enum|final|lazy|(export\s)?(\s\s)?(\s\s)?function\s\zs\i|(export\s)?type\s\zs\i|object\s\zs\i|(export\s)?class\s\zs\i|def|val|var|const|let|export\s\zs\i|(\s\s)?\s\s\zs\i*(\(|\<))', 'W' )
" endfunc

func! JS_TopLevPattern()
  let patterns = [
        \ 'function ',
        \ 'async ',
        \ 'case "',
        \ 'it."',
        \ 'const ',
        \]
  return '(' . join(patterns, '|') . ')'
endfunc

func! JS_SkipTypeSign()
  let c = col('.')
  " Skip the type signature e.i. this pattern: }: {
  " echo getline('.')[c+2] 
  " if getline('.')[c+2] == '{' 
  if LastChar(getline('.')) == '{' 
    call search('\s\zs{', 'W')
    call FlipToPairChar('')
  endif
endfunc

" keepjumps doesn't seem to work.
func! JS_GoReturn()
  let oLine = line('.')
  let oCol = virtcol('.')  " Get visible column position
  " execute "normal m'"
  keepjumps call search('\s\zs{', 'W')
  keepjumps call FlipToPairChar('')

  " let nLine = line('.')
  " echo oLine
  " echo nLine
  " if nLine == oLine
  "   echo 'no'
  "   return
  " endif

  keepjumps call JS_SkipTypeSign()
  let patterns = [
        \ '\s\zsreturn',
        \]
  let combined_pattern = '\v' . join(patterns, '|')
  keepjumps call search(combined_pattern, 'bW')
  let nLine = line('.')
  if nLine < oLine + 1
    " Go to the end of the block and try one more time
    keepjumps call cursor(oLine, oCol)  " Use cursor() instead of setpos()
    call JS_MvEndOfBlock()
    keepjumps call search(combined_pattern, 'bW')
    let nLine = line('.')
    if nLine < oLine + 1
      keepjumps call cursor(oLine, oCol)  " Use cursor() instead of setpos()
      echo 'no return'
    endif
  endif
endfunc

func! JS_GoBackReturn()
  let patterns = [
        \ '^\s\s\zs\i.*\=\s\(',
        \ '^\s\s\zs\i.*\<\{',
        \ '^\s\s(private\s)?async\sfunction\s\zs\i',
        \ 'static\sasync\s\zs\i',
        \ 'private\sasync\s\zs\i',
        \ '\s\zsreturn',
        \ 'async\sfunction\s\zs\i',
        \ 'async\s\zs\i',
        \ '\sprivate\s\zs\i*(\(|\<)',
        \ '^(\s\s)?\s\s\zs\i*(\(|\<)'
        \]
  let combined_pattern = '\v' . join(patterns, '|')
  call search(combined_pattern, 'bW')
  call ScrollOff(10)
endfunc


func! JS_TopLevBindingForw()
  let patterns = [
        \ '^\s\s\zs\i.*\=\s\(',
        \ '^\s\s\zs\i.*\<\{',
        \ '^\s\s(async\s)?function\s\zs\i',
        \ '^enum',
        \ '^(export\s)?type\s\zs\i',
        \ 'interface\s\zs\i',
        \ '^object\s\zs\i',
        \ '^(export\s)?class\s\zs\i',
        \ '^export\s\zs\i',
        \]
  let combined_pattern = '\v' . join(patterns, '|')
  call search(combined_pattern, 'W')
endfunc

func! JS_TopLevBindingBackw()
  let patterns = [
        \ '^\s\s\zs\i.*\=\s\(',
        \ '^\s\s\zs\i.*\<\{',
        \ '^\s\s(async\s)?function\s\zs\i',
        \ '^enum',
        \ '^(export\s)?type\s\zs\i',
        \ 'interface\s\zs\i',
        \ '^object\s\zs\i',
        \ '^(export\s)?class\s\zs\i',
        \ '^export\s\zs\i',
        \]
  let combined_pattern = '\v' . join(patterns, '|')
  call search(combined_pattern, 'bW')
endfunc


let g:JS_patterns = [
      \ '\scase\s\zs\S',
      \ '^\s\s\zs\i.*\=\s\(',
      \ '^\s\s\zs\i.*\<\{',
      \ '^\s\s(private\s)?async\sfunction\s\zs\i',
      \ 'static\sasync\s\zs\i',
      \ 'private\sasync\s\zs\i',
      \ '^enum',
      \ '^export const\s\zs\i',
      \ '^const\s\zs\i',
      \ '^(export\s)?(\s\s)?(\s\s)?function\s\zs\i',
      \ '^(export\s)?type\s\zs\i',
      \ 'interface\s\zs\i',
      \ '^object\s\zs\i',
      \ 'class\s\zs\i',
      \ 'async\sfunction\s\zs\i',
      \ 'async\s\zs\i',
      \ '\sprivate\s\zs\i*(\(|\<)',
      \ '^(\s\s)?\s\s\zs\i*(\(|\<)',
      \ '^export\s.*function\s\zs\i',
      \]

func! JS_BindingForw()
  let combined_pattern = '\v' . join(g:JS_patterns, '|')
  call search(combined_pattern, 'W')
  call ScrollOff(25)
endfunc

func! JS_BindingBackw()
  let combined_pattern = '\v' . join(g:JS_patterns, '|')
  call search(combined_pattern, 'bW')
  call ScrollOff(10)
endfunc



" func! JS_TopLevBindingBackw()
"   " call search( '\v^(async|export|final|override|case|enum|final|def|lazy|val|function|var|object|class|const|let)\s', 'bW' )
"   call search( '\v^(async|\s\s(private\s)?async\s\zs\i|final|override|case|enum|final|lazy|(export\s)?(\s\s)?(\s\s)?function\s\zs\i|(export\s)?type\s\zs\i|object\s\zs\i|(export\s)?class\s\zs\i|def|val|var|const|let|export\s\zs\i|(\s\s)?\s\s\zs\i*(\(|\<))', 'bW' )
"   " normal! {
"   " call search( '\v^(export|function|const|let)\s', 'W' )
" endfunc

" call search('\v^(\s*)?call', 'W')


func! JS_YankCodeBlock()
  let [oLine, oCol] = getpos('.')[1:2]
  call JS_TopLevBindingBackw()
  let [sLine, sCol] = getpos('.')[1:2]
  call search( '\v^\S', 'W' )
  let [eLine, eCol] = getpos('.')[1:2]

  call setpos( "'<", [0, sLine, sCol, 0] )
  call setpos( "'>", [0, eLine, eCol, 0] )
  normal gvy
  call setpos('.', [0, oLine, oCol, 0] )
endfunc


" ─   Javascript Nodejs helper                           ■

command! TypescriptReplsetCommonJS call TypescriptRepl_TSNode_setCommonJS()

func! TypescriptRepl_TSNode_setCommonJS()
  let newConfigLine1 = ' , "ts-node": { "compilerOptions": { "module": "CommonJS" } }'
  let newConfigLine2 = '}'
  let fileName = 'tsconfig.json'
  call AddLinesToFile( fileName, [newConfigLine1, newConfigLine2], -2 )
endfunc

" Execute a function in a typescript file. This function should typically console.log() its result. Example:
  " let resLines = systemlist( T_TesterTerminalCommand( a:testerName ) )
  " silent let g:floatWin_win = FloatingSmallNew ( resLines )
func! T_NodeFunctionCall_TermCmd( filePath, fnName )
  " let js_code_statement = 'require("' . a:filePath . '").' . a:fnName . '()'

  let js_code_statement = '(async () => { const module = await import("' . a:filePath . '")' . '; module.' . a:fnName . '(); })()'

  " let js_c = '(async () => { try { const module = await import("' . a:filePath . '"); module.' . a:fnName . '(); } catch (error) { console.error(error); } })()'
  " call writefile( [js_code_statement], 'tempPrinter.js' )

  " return "npx ts-node -T -e '" . js_code_statement . "'"

  " return "NODE_NO_WARNINGS=1 npx ts-node -T -e '" . js_c . "'"
  " return "NODE_NO_WARNINGS=1 node -e '" . js_code_statement . "'"
  " return "NODE_NO_WARNINGS=1 node --experimental-require-module -e '" . js_code_statement . "'"
  return "NODE_NO_WARNINGS=1 npx ts-node -T -e '" . js_code_statement . "'"

  " return "node --loader ts-node/esm -e '" . js_code_statement . "'"

  " return "node -O '{\"module\": \"commonjs\"}' --loader ts-node/esm -e '" . js_code_statement . "'"
  " node -e 'require("./db").init()'
  " npx ts-node -T -e 'require("/Users/at/Documents/Architecture/examples/gql1/scratch/.testGqlExec.ts").ShowSchema()'
endfunc


" node -e "import('<path>').then(m => console.log(m.abc1))"


func! CurrentRelativeModulePath()
  let path = expand('%:p:r')
  let cwd = getcwd()
  let relPath = substitute( path, cwd, '', '' )
  return relPath
endfunc
" echo CurrentRelativeModulePath()

" CurrentRelativeModulePath() -> /packages/app/src/program
" import { e1_processCommands as testIdentif } from "@org/app/program"

" echo split( '/packages/app/src/program', '/' )
" echo substitute( '/packages/app/src/program', '/packages', '@org', '' )

func! ModulePath_MonoRepo()
  let path = expand('%:p:r')
  let cwd = getcwd()
  let orgName = '@' . JsonConfKey( 'package.json', 'name' )

  let relPath    = substitute( path, cwd, '', '' )
  " let orgPath    = substitute( relPath, '/packages', '@org', '' )
  let orgPath    = substitute( relPath, '/packages', orgName, '' )
  let modulePath = substitute( orgPath, '/src', '', '' )
  let modulePath = substitute( modulePath, '/_src', '', '' )

  let packageName = split( relPath, '/' )[1]
  return [packageName, modulePath]
endfunc


" ─^  Javascript Nodejs helper                           ▲




