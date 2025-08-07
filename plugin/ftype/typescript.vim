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


  " nnoremap <silent><buffer>         gei :call System_Float( JS_EvalParagIdentif_simple() )<cr>
  nnoremap <silent><buffer>         gei :call JS_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer> <leader>gei :call JS_RunPrinter( "term"  )<cr>
  nnoremap <silent><buffer>        ,gei :call JS_RunPrinter( "term_float"  )<cr>
  nnoremap <silent><buffer>         geh :call JS_RunPrinter( "term_hidden"  )<cr>

  nnoremap <silent><buffer>         get :call JS_RunVitest( "float" )<cr>
  nnoremap <silent><buffer>         geT :call JS_RunVitest( "term" )<cr>


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




