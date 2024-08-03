" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! Py_bufferMaps()

  call Scala_bufferMaps_shared()

  nnoremap <silent><buffer>         gew :call Py_SetPrinterIdentif( "plain" )<cr>
  nnoremap <silent><buffer>         get :call Py_SetPrinterIdentif( "table" )<cr>
  nnoremap <silent><buffer>         gef :call Py_SetPrinterIdentif( "file1" )<cr>
  nnoremap <silent><buffer>         geW :call Py_SetPrinterIdentif( "plain json" )<cr>
  nnoremap <silent><buffer>         gee :call Py_SetPrinterIdentif( "effect" )<cr>
  nnoremap <silent><buffer>         gegj :call Py_SetPrinterIdentif( "gallia" )<cr>
  nnoremap <silent><buffer>         gegs :call Py_SetPrinterIdentif( "gallias" )<cr>

  nnoremap <silent><buffer> <leader>gep      :call PyReplEval( GetPyReplExprLN( line('.') ) )<cr>
  nnoremap <silent><buffer> geJ              :call PyReplEval( GetPyDefName() )<cr>
  nnoremap <silent><buffer> gej              :call PyReplEval( GetPyDefExpression() )<cr>

  " nnoremap <silent> gep              :silent call PyReplEval( GetLineFromCursor() )<cr>
  " nnoremap <silent> gep              :silent call PyReplEval( GetLineFromCursor() )<cr>
  " vnoremap <silent> gep :<c-u>call PyReplEval( Get_visual_selection() )<cr>
  nnoremap <silent><buffer>         gep :call PyReplParag()<cr>


  nnoremap <silent><buffer> <leader>es  :call Py_AddSignature()<cr>

  nnoremap <silent><buffer>         gei :call Py_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer> <leader>gei :call Py_RunPrinter( "term"  )<cr>

  " nnoremap <silent><buffer>         gej :call Py_RunPrinter( "float" )<cr>
  " nnoremap <silent><buffer> <leader>gej :call Py_RunPrinter( "term"  )<cr>

  " currently not using poety to run
  " nnoremap <silent><buffer>gwj :call Py_RunCli( "showReturn" )<cr>
  " nnoremap <silent><buffer>gwJ :call Py_RunCli( "notShowReturn" )<cr>
  " nnoremap <silent><buffer>,gwj :call Py_RunCli( "termFloat" )<cr>
  " nnoremap <silent><buffer><leader>gwj :call Py_RunCli( "termSplit" )<cr>

  nnoremap <silent><buffer> <leader>(     :call Py_MvStartOfBlock()<cr>
  onoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>
  vnoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>

  nnoremap <silent><buffer> <leader>)     :call Py_MvEndOfBlock()<cr>
  onoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>
  vnoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>

  nnoremap <silent><buffer> * :call MvPrevLineStart()<cr>
  nnoremap <silent><buffer> ( :call MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call MvNextLineStart()<cr>

  nnoremap <silent><buffer> I :call Py_ColumnForw()<cr>
  nnoremap <silent><buffer> Y :call Py_ColumnBackw()<cr>

  nnoremap <silent><buffer> <c-p>         :call Py_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Py_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>

" ─     Lsp maps                                        ──
" -- also at:
" ~/.config/nvim/plugin/utils_general_maps.lua#/--%20Lsp%20maps

  nnoremap <silent><buffer> <leader>gek :call Py_LspTopLevelHover()<cr>
  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>
  nnoremap <silent><buffer>         geK :lua vim.lsp.buf.signature_help()<cr>
  " this works super nice. there's another (default?) mapping for leader ?
  nnoremap <silent><buffer> <leader>/   :lua require('telescope.builtin').lsp_document_symbols()<cr>
  nnoremap <silent><buffer> <leader>ot  :Vista nvim_lsp<cr>
  nnoremap <silent><buffer> ,sl :lua require('telescope.builtin').lsp_document_symbols()<cr>
  " nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({layout_config={vertical={sorting_strategy="ascending"}}})<cr>
  nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({initial_mode='insert'})<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer> ,ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  nnoremap <silent><buffer> ger :lua require('telescope.builtin').lsp_references(require('telescope.themes').get_cursor({initial_mode='normal', layout_config={width=0.95, height=25}}))<cr>
  nnoremap <silent><buffer> geR <cmd>TroubleToggle lsp_references<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  nnoremap <silent><buffer> ge] :lua require("trouble").next({skip_groups = true, jump = true})<cr>
  nnoremap <silent><buffer> ge[ :lua require("trouble").previous({skip_groups = true, jump = true})<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call Py_InlineTestDec()<cr>
  nnoremap <silent><buffer> ,et :call Py_InlineTestDec()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

endfunc


func! Py_InlineTestDec()
  let func_ln = searchpos( 'def\s\(e\d_\)\@!', 'cnb' )[0]

  if getline( func_ln ) =~ "async"
    let async = v:true
  else
    let async = v:false
  endif

  " echo matchstr( getline('.'), '\vdef\s\zs\i*\ze\(' )
  let funcName = matchstr( getline(func_ln), '\vdef\s\zs\i*\ze\(' )
  let strInParan = matchstr( getline(func_ln), '\v\(\zs.{-}\ze\)' )
  let paramNames = split( strInParan, ',' )
  if len( paramNames )
    let paramNames = paramNames[0]
  endif
  let paramNames = string( paramNames )
  let paramNames = substitute( paramNames, "'", "", 'g' )
  let paramNames = paramNames[1:-2]
  let paramNames = '"'. paramNames . '"'
  " let paramNames = '"' . SubstituteInLines( split( strInParan, ',' ), '\s', '' ) . '"'
  " echo "['first', 'sec', 'third']"[1:-2]
  let lineText = funcName . '(' . paramNames . ')'
  let nextIndex = GetNextTestDeclIndex(func_ln)
  " let lineText = 'e' . nextIndex . '_' . funcName . ' = ' . lineText
  let lineText = 'def e' . nextIndex . '_' . funcName . "(): return " . lineText
  if async
    let lineText = "async " . lineText
  endif
  call append( line('.') -1, lineText )
  normal k^
  call search('return')
  normal w
endfunc
" Tests:
" def mult(aa, bb):
"   return aa * bb
" e1_mult = mult('aa', 'bb')

func! Py_LspTypeAtPos(lineNum, colNum)
  let [oLine, oCol] = getpos('.')[1:2]
  call setpos('.', [0, a:lineNum, a:colNum, 0] )
  " currently doesn't return "async", but could
  let l:typeStr = v:lua.require('utils_lsp').LspType()
  call setpos('.', [0, oLine, oCol, 0] )
  return l:typeStr
endfunc
" echo Py_LspTypeAtPos(111, 10)
" echo Py_LspTypeAtPos(line('.'), col('.'))
" TODO: keep refining: ~/.config/nvim/lua/utils_lsp.lua#/if%20retval%20==


func! Py_LspType()
  let [oLine, oCol] = getpos('.')[1:2]
  let l:typeStr = Py_LspTypeAtPos(oLine, oCol)
  return l:typeStr
endfunc
" echo Py_LspType()

func! Py_LspTopLevelHover()
  let [oLine, oCol] = getpos('.')[1:2]
  normal ^
  call SkipPySkipWords()
  lua vim.lsp.buf.hover()
  call setpos('.', [0, oLine, oCol, 0] )
endfunc

func! Py_GetPrinterPath()

  let printerPath = "m/_printer/printer.py"

  if filereadable( printerPath )
    return printerPath
  endif

  let parentFolderPath = expand('%:h')
  let printerPath = parentFolderPath . "/printer.py"

  if filereadable( printerPath )
    return printerPath
  endif

  let grandParentFolderPath = fnamemodify( parentFolderPath, ':h' )

  let printerPath = grandParentFolderPath . "/printer.py"
  if filereadable( printerPath )
    return printerPath
  else
    echoe 'printer.py not found!'
  endif
endfunc

func! Py_GetPackageName()
  let thisModuleName = expand('%:t:r')
  let parentFolderPath = expand('%:h')

  if filereadable( parentFolderPath . '/printer.py' )
    return thisModuleName
  endif

  let grandParentFolderPath = fnamemodify( parentFolderPath, ':h' )
  " echo grandParentFolderPath
  " return
  if filereadable( grandParentFolderPath . '/printer.py' )
    let parentPackageName = fnamemodify( parentFolderPath, ':t' )
    return parentPackageName . "." . thisModuleName
  else
    echoe 'printer.py not found!'
  endif

endfunc

func! Py_AddSignature()

  let hostLn = line('.')
  let identifCol = 5

  let identif = matchstr( getline(hostLn ), '^def\s\zs\i*\ze\=' )

  let typeStr = Py_LspTypeAtPos(hostLn, identifCol)
  if typeStr == "timeout"
    echo "Lsp timeout .. try again"
    return
  endif
  let typeStr = typeStr[6:]

  let [oLine, oCol] = getpos('.')[1:2]
  call setpos('.', [0, hostLn, 0, 0] )

  let lineText = getline( hostLn )
  let [lineEq, idxEq] = searchpos( '\v\:(\s|\_$)', 'n' )

  let textBefore = lineText[:idxEq -2]
  let textAfter = lineText[idxEq:]
  " echo textBefore . "||" . textAfter
  " return

  normal! "_dd
  call append( hostLn -1, textBefore . " -> " . typeStr . ":" . textAfter )
  normal! k
  call setpos('.', [0, hostLn, 0, 0] )
  " call search('=')

endfunc


func! Py_SetPrinterIdentif( keyCmdMode )

  " let [hostLn, identifCol] = searchpos( '^def\s\zs\i*\ze\=', 'cnbW' )
  let hostLn = line('.')
  let typeStr = ""

  if getline(hostLn ) =~ "async"
    let _printEval = "    valu = await symToEval()"
    let identifCol = 11
    let typeDisp = "≀"
    let identif = matchstr( getline(hostLn ), '^async def\s\zs\i*\ze\=' )
  else
    let _printEval = "    valu = symToEval()"
    let identifCol = 5
    let typeMode = ""
    let identif = matchstr( getline(hostLn ), '^def\s\zs\i*\ze\=' )
  endif

  " echo identif hostLn identifCol
  " return

  let typeStr = Py_LspTypeAtPos(hostLn, identifCol)
  if typeStr == "timeout"
    echo "Lsp timeout .. try again"
    return
  endif
  " let typeStr = typeStr[6:]
  " echo typeStr
  " return

  let typeDisp = typeStr
  if     typeStr =~ "list" || typeStr =~ "set"
    let typeMode = "collection"
  elseif typeStr =~ "DataFrame" || typeStr =~ "Series"
    let typeMode = "DataFrame"
  elseif typeStr =~ "Coroutine"
    let typeMode = "≀"
    let corouRetType = matchstr( typeStr, '\,\s\zs\i*\ze\]' )
    let typeDisp = "• " . corouRetType
  else
    let typeMode = "plain"
  endif


  " echo "Printer: " . identif . " - " . typeStr . " - " . typeMode
  call VirtualRadioLabel_lineNum( "« " . typeDisp . " " . typeMode, hostLn )

  " from t2 import fruits as symToEval
  let _import = "from " . Py_GetPackageName() . " import " . identif . " as symToEval"

  " let _bindVal  = "valu = symToEval()"
  " let _bindIsColl = 'isColl = "list" in str(type(valu))'

  let _print_type = "print( str(type(valu)) + ' | ' + '" . typeStr . "' )"
  " let _print_type = "if isColl: print( type( valu[0] ) )"
  " let _print_info = "if isColl: print( len( valu ) )"

  " let _printSetting = ""

  " let _printVal1 = "if isColl:"
  " let _printVal2 = "  for x in valu: print(x)"
  " let _printVal3 = "else: print(valu)"

  " if     typeMode == 'collection'
  "   let _print_type     = "print( type( valu ) )"
  "   let _print_info     = "print( len( valu ) )"
  "   " if (11 > 10 and "ab" in "xdabed"): 
  "   "     for x in [2, 33, 44, 55, 66]: print(x)
  "   let _printVal1 = "if (len(valu) >  and "ab" in "xdabed"):"
  " elseif typeMode == 'DataFrame'
  "   let _print_type     = "print( valu.dtypes )"
  "   let _print_info     = "print( valu.shape )"
  "   let _printSetting = "pd.options.display.width = None"
  "   let _printVal1 = "print( valu.head(30) )"
  " elseif typeMode == 'plain'
  "   let _print_type     = "print( type( valu ) )"
  "   let _print_info     = ""
  " endif

  " let printerFilePath = getcwd() . '/printer.py'
  let printerFilePath = Py_GetPrinterPath()
  let plns = readfile( printerFilePath, '\n' )

  let plns[1] = _import


  " let plns[0] = "import pandas as pd"
  " let plns[0] = ""
  " let plns[1] = "from pprint import pprint"
  " let plns[1] = ""
  " let plns[4] = _bindVal
  " let plns[5] = _bindIsColl

  " let plns[4] = _print_type

  let plns[6] = _printEval

  " let plns[7] = _print_info
  " let plns[8] = _printSetting
  " let plns[10] = _printVal1
  " let plns[11] = _printVal2
  " let plns[12] = _printVal3

  call writefile( plns, printerFilePath )
endfunc


func! Py_RunCli( dispType )
  let filePath = expand('%')

  " # sourceTxt -d destTxt --flagA
  let argStr = getline('.')[1:]

  let isPoetryProject = filereadable( getcwd() . '/pyproject.toml' )
  let runner = isPoetryProject ? "poetry run python " : "python "
  let cmd = runner . filePath . " " . argStr


  if     a:dispType == 'notShowReturn'
    call system( cmd )

  elseif a:dispType == 'showReturn'
    call System_Float( cmd )

  elseif a:dispType == 'termFloat'
    call TermOneShotFloat( cmd )

  elseif a:dispType == 'termSplit'
    call TermOneShot( cmd )

  endif
endfunc

func! Py_RunPrinter( termType )

  let cmd = "python " . Py_GetPrinterPath()
  let isPoetryProject = filereadable( getcwd() . '/pyproject.toml' )
  " let cmd = isPoetryProject ? "poetry run " . cmd : cmd

  if     a:termType == 'float'
    let resLines = systemlist( cmd )
    call Py_showInFloat( resLines )

  elseif a:termType == 'term'
    call TermOneShot( cmd )

  endif
endfunc


func! Py_showInFloat( data )
  let lines = RemoveTermCodes( a:data )
  if !len( lines )
    return
  endif
  " let resLines = functional#foldr( function("Py_filterCliLine") , [], lines )
  let resLines = lines
  silent let g:floatWin_win = FloatingSmallNew ( resLines )

  " if resLines[0][0] == "{" || resLines[0][0] == "["
  "   silent! exec "%!jq"
  "   let synt = 'json'
  " endif

  call PythonSyntaxAdditions() 
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfun


" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
" let g:Py_TopLevPattern = '\v^((\s*)?\zs(inline|given|final|trait|override\sdef|type|val\s|lazy\sval|case\sclass|enum|final|object|class|def)\s|val)'
let g:Py_TopLevPattern = '\v(^class|def|\i*\s\=\s)'

func! Py_TopLevBindingForw()
  normal! }
  call search( g:Py_TopLevPattern, 'W' )
endfunc

func! Py_TopLevBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Py_TopLevPattern, 'bW' )
  normal! {
  call search( g:Py_TopLevPattern, 'W' )
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc

" call search('\v^(\s*)?call', 'W')

func! Py_MvStartOfBlock()
  normal! k
  exec "silent keepjumps normal! {"
  normal! j^
endfunc


func! Py_MvEndOfBlock()
  normal! j
  exec "silent keepjumps normal! }"
  normal! k^
endfunc

func! BlockStart_VisSel()
  normal! m'
  normal! V
  call Py_MvStartOfBlock()
  normal! o
endfunc


func! BlockEnd_VisSel()
  normal! m'
  normal! V
  call Py_MvEndOfBlock()
  normal! o
endfunc


" let g:Py_MvStartLine_SkipWords = '\v(val|def|lazy|private|final|override)'
let g:Py_MvStartLine_SkipWordsL = ['val', 'def', 'lazy', 'private', 'final', 'override']
" echo "private" =~ g:Py_MvStartLine_SkipWords

func! SkipPySkipWords()
  if GetCharAtCursor() == "."
    normal! l
    return
  endif
  if GetCharAtCursor() == "/"
    normal! w
    return
  endif

  let cw = expand('<cword>')
  " if cw =~ g:Py_MvStartLine_SkipWords
  if count( g:Py_MvStartLine_SkipWordsL, cw )
    normal! w
    call SkipPySkipWords()
  endif
endfunc
"   .mapValues[ Domain.Destination.Issues ] { employeeIssues =>


func! MvLineStart()
  normal! m'
  normal! ^
  call SkipPySkipWords()
endfunc

func! MvNextLineStart()
  normal! m'
  normal! j^
  call SkipPySkipWords()
endfunc

func! MvPrevLineStart()
  normal! m'
  normal! k^
  call SkipPySkipWords()
endfunc


func! MakeOrPttn( listOfPatterns )
  return '\(' . join( a:listOfPatterns, '\|' ) . '\)'
endfunc

let g:Py_columnPttn = MakeOrPttn( ['\:\s', '=', '->', '#', 'with', 'as', 'if', 'return'] )

func! Py_ColumnForw()
  call SearchSkipSC( g:Py_columnPttn, 'W' )
  normal w
endfunc

func! Py_ColumnBackw()
  normal bh
  call SearchSkipSC( g:Py_columnPttn, 'bW' )
  normal w
endfunc





