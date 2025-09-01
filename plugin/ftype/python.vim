" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! Py_bufferMaps()

  call Scala_bufferMaps_shared()

  nnoremap <silent><buffer>         gew :call Py_SetPrinterIdentif( "plain" )<cr>
  nnoremap <silent><buffer>         get :call Py_SetPrinterIdentif( "table" )<cr>
  nnoremap <silent><buffer>         gef :call Py_SetPrinterIdentif( "file1" )<cr>
  nnoremap <silent><buffer>         geW :call Py_SetPrinterIdentif( "image" )<cr>
  nnoremap <silent><buffer>         gee :call Py_SetPrinterIdentif( "effect" )<cr>
  nnoremap <silent><buffer>         gegj :call Py_SetPrinterIdentif( "gallia" )<cr>
  nnoremap <silent><buffer>         gegs :call Py_SetPrinterIdentif( "gallias" )<cr>

  nnoremap <silent><buffer> <leader>gep      :call PyReplEval( GetPyReplExprLN( line('.') ) )<cr>
  nnoremap <silent><buffer> geJ              :call PyReplEval( GetPyDefName() )<cr>
  nnoremap <silent><buffer> gej              :call PyReplEval( GetPyDefExpression() )<cr>

  " nnoremap <silent> gep              :silent call PyReplEval( GetLineFromCursor() )<cr>
  " nnoremap <silent> gep              :silent call PyReplEval( GetLineFromCursor() )<cr>
  vnoremap <silent> gep :<c-u>call PyReplEval( Get_visual_selection() )<cr>
  nnoremap <silent><buffer>         gep :call PyReplParag()<cr>


  nnoremap <silent><buffer> <leader>es  :call Py_AddSignature()<cr>

  " TODO: gei should be analogous to the TS vitest features
  " nnoremap <silent><buffer>         gei :call Py_RunPrinter( "float" )<cr>
  " nnoremap <silent><buffer> <leader>gei :call Py_RunPrinter( "term"  )<cr>

  nnoremap <silent><buffer>         gej :call Py_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer> <leader>gej :call Py_RunPrinter( "term"  )<cr>
  nnoremap <silent><buffer>        ,gej :call Py_RunPrinter( "term_float"  )<cr>
  nnoremap <silent><buffer>         geh :call Py_RunPrinter( "term_hidden"  )<cr>

  " nnoremap <silent><buffer>         gej :call Py_RunPrinter( "float" )<cr>
  " nnoremap <silent><buffer> <leader>gej :call Py_RunPrinter( "term"  )<cr>

  " currently not using poety to run
  " nnoremap <silent><buffer>gwj :call Py_RunCli( "showReturn" )<cr>
  " nnoremap <silent><buffer>gwJ :call Py_RunCli( "notShowReturn" )<cr>
  " nnoremap <silent><buffer>,gwj :call Py_RunCli( "termFloat" )<cr>
  " nnoremap <silent><buffer><leader>gwj :call Py_RunCli( "termSplit" )<cr>


" ─   Motions                                           ──
" ~/.config/nvim/plugin/ftype/typescript.vim‖*Motions

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

  nnoremap <silent><buffer> <leader><c-p> :call Py_MainStartBindingBackw()<cr>
  nnoremap <silent><buffer> <c-p>         :call Py_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Py_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <c-n>         :call Py_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> ]r            :keepjumps call Py_GoReturn()<cr>
  nnoremap <silent><buffer> [r            :call Py_GoBackReturn()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>


  " OLD LSP
" -- also at:
" ~/.config/nvim/plugin/utils_general_maps.lua#/--%20Lsp%20maps
  " nnoremap <silent><buffer> <leader>gek :call Py_LspTopLevelHover()<cr>
  " nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>
  " nnoremap <silent><buffer>         geK :lua vim.lsp.buf.signature_help()<cr>
  " " this works super nice. there's another (default?) mapping for leader ?
  " nnoremap <silent><buffer> <leader>/   :lua require('telescope.builtin').lsp_document_symbols()<cr>
  " " nnoremap <silent><buffer> <leader>ot  :Vista nvim_lsp<cr>
  " nnoremap <silent><buffer> <leader>ot  :Outline<cr>
  " nnoremap <silent><buffer> ,sl :lua require('telescope.builtin').lsp_document_symbols()<cr>
  " " nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({layout_config={vertical={sorting_strategy="ascending"}}})<cr>
  " nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({initial_mode='insert'})<cr>
  " " TODO: works as of 2025-03
  " nnoremap <silent><buffer> <leader>ca :lua require("lspimport").import()<cr>
  " " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  " " nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  " nnoremap <silent><buffer> ,ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  " nnoremap <silent><buffer> ger :lua require('telescope.builtin').lsp_references(require('telescope.themes').get_cursor({initial_mode='normal', layout_config={width=0.95, height=25}}))<cr>
  " nnoremap <silent><buffer> geR <cmd>TroubleToggle lsp_references<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  " nnoremap <silent><buffer> ge] :lua require("trouble").next({skip_groups = true, jump = true})<cr>
  " nnoremap <silent><buffer> ge[ :lua require("trouble").previous({skip_groups = true, jump = true})<cr>

  " OLD LSP

" ─   LSP                                                ■

  " nnoremap <silent><buffer> <leader>ca :lua require("lspimport").import()<cr>

  " copied from typescript! ->

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


" ─^  LSP                                                ▲



" ─   Stubs and inline tests                            ──
  nnoremap <silent><buffer> <leader>et :call Py_InlineTestDec("normal")<cr>
  nnoremap <silent><buffer> <leader>eT :call Py_InlineTestDec("async")<cr>
  " nnoremap <silent><buffer> ,et :call Py_InlineTestDec()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

endfunc


func! Py_InlineTestDec( type )
  let func_ln = searchpos( '^def\s\(e\d_\)\@!', 'cnbW' )[0]
  let class_ln = searchpos( 'class\s\(e\d_\)\@!', 'cnbW' )[0]
  echo func_ln class_ln

  if getline( func_ln ) =~ "async" || a:type =~ "async"
    let async = v:true
  else
    let async = v:false
  endif

  " echo matchstr( getline('.'), '\vdef\s\zs\i*\ze\(' )
  let funcName = matchstr( getline(func_ln), '\vdef\s\zs\i*\ze\(' )
  let className = matchstr( getline(class_ln), '\vclass\s\zs\i*\ze\(' )
  " echo className
  let strInParan = matchstr( getline(func_ln), '\v\(\zs.{-}\ze\)' )
  let paramNames = split( strInParan, ',' )
  if len( paramNames )
    let paramNames = paramNames[0]
  endif
  let paramNames = string( paramNames )
  let paramNames = substitute( paramNames, "'", "", 'g' )
  let paramNames = paramNames[0:-1]
  let paramNames = '"'. paramNames . '"'
  " let paramNames = '"' . SubstituteInLines( split( strInParan, ',' ), '\s', '' ) . '"'
  " echo "['first', 'sec', 'third']"[1:-2]

  let lineText = funcName . '(' . paramNames . ')'

  " echo func_ln class_ln
  " if func_ln < class_ln then use className in place of funcName
  if func_ln < class_ln
    let func_ln = class_ln 
    let funcName = className
    let lineText = "'ab'"
  endif


  let nextIndex = GetNextTestDeclIndex(func_ln)
  " let lineText = 'e' . nextIndex . '_' . funcName . ' = ' . lineText
  if async
    let lineText = 'async def e' . nextIndex . '_' . funcName . "(): return await " . lineText
  else
    let lineText = 'def e' . nextIndex . '_' . funcName . "(): return " . lineText
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

  let printerPath = "m/printer.py"
  if filereadable( printerPath )
    return printerPath
  endif

  let printerPath = "printer.py"
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

func! Py_GetPackageName_old()
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

func! Py_GetPackageName()
  " Get the current file path
  let l:current_file_path = expand('%:p')

  " Get the current working directory
  let l:cwd = getcwd()

  " Ensure the CWD ends with a slash to match the start of the file path
  if l:cwd[-1] != '/'
    let l:cwd .= '/'
  endif

  " Find the position of the CWD in the full path
  let l:cwd_pos = match(l:current_file_path, '^' . l:cwd)

  " If CWD is not found in the current file path, return an empty string
  if l:cwd_pos == -1
    return ''
  endif

  " Extract the relative file path using the CWD's position
  let l:relative_path = l:current_file_path[l:cwd_pos + len(l:cwd):]

  " Replace file separators with dots and remove the file extension
  let l:module_path = substitute(l:relative_path, '/', '.', 'g')
  let l:module_path = substitute(l:module_path, '\.py$', '', '')
  " let l:module_path = substitute(l:module_path, 'm.', '', '')

  return l:module_path
endfunc



func! Py_AddSignature()
  let hostLn = line('.')
  let identifCol = 5
  let identif = matchstr( getline(hostLn ), '^def\s\zs\i*\ze\=' )

  " def tool_calling_llm(state: MessagesState) -> dict[str, list[BaseMessage]]
  let typeStr = Py_LspTypeAtPos(hostLn, identifCol)
  if typeStr == "timeout"
    echo "Lsp timeout .. try again"
    return
  endif

  let lineStr = typeStr . ":"

  normal! "_dd
  call append( hostLn -1, lineStr )
  normal! k
  call setpos('.', [0, hostLn, 0, 0] )
endfunc



func! Py_AddSignature_bak()
  let hostLn = line('.')
  let identifCol = 5
  let identif = matchstr( getline(hostLn ), '^def\s\zs\i*\ze\=' )

  " (function) def tool_calling_llm(state: MessagesState) -> dict[str, list[BaseMessage]]
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

  " OBSOLETE: now handled automatically by new printer.py
  if getline(hostLn ) =~ "async"
    let _printEval = "        valu = await symToEval()"
    let identifCol = 11
    let typeDisp = "≀"
    let identif = matchstr( getline(hostLn ), '^async def\s\zs\i*\ze\=' )
  elseif getline(hostLn ) =~ "def"
    let _printEval = "        valu = symToEval()"
    let identifCol = 5
    let typeMode = ""
    let identif = matchstr( getline(hostLn ), '^def\s\zs\i*\ze\=' )
  else 
    let _printEval = "        valu = symToEval()"
    let identifCol = 5
    let typeMode = ""
    let identif = matchstr( getline(hostLn ), '^\i*\ze\=' )
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

  " _setPrintMapArg & keyCmdMode
  if a:keyCmdMode =~ "image"
    let typeDisp = "󱁊"
    let typeMode = "image"
    let _setPrintMapArg = "PrintMapParam = 'image'"
  else
    let _setPrintMapArg = "PrintMapParam = ''"
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
  " echo Py_GetPrinterPath()
  " return

  let printerFilePath = Py_GetPrinterPath()
  let plns = readfile( printerFilePath, '\n' )

  let plns[0] = _setPrintMapArg
  let plns[1] = _import


  " let plns[0] = "import pandas as pd"
  " let plns[0] = ""
  " let plns[1] = "from pprint import pprint"
  " let plns[1] = ""
  " let plns[4] = _bindVal
  " let plns[5] = _bindIsColl

  " let plns[4] = _print_type

  " now handled automatically by new printer.py
  " let plns[7] = _printEval

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

  let Cmd = "python " . Py_GetPrinterPath()
  let isUVProject = filereadable( getcwd() . '/pyproject.toml' )
  let Cmd = isUVProject ? "uv run " . Cmd : Cmd

  if     a:termType == 'float'
    let resLines = systemlist( Cmd )
    let resLines = RemoveTermCodes( resLines )
    if !len( resLines )
      echo 'done'
      return
    endif

    silent let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )
    call PythonSyntaxAdditions() 
    silent call FloatWin_FitWidthHeight()
    if len( resLines ) > 10
      normal! zM
    endif
    silent wincmd p

  elseif a:termType == 'term'
    call TermOneShot( Cmd )
  elseif a:termType == 'term_hidden'
    call TermOneShot( Cmd )
    silent wincmd c
  elseif a:termType == 'term_float'
    call FloatingTerm( 'otherWinColumn' )
    let g:TermID = termopen( Cmd )
    call PythonSyntaxAdditions() 
    " TODO more useful result maps
    nnoremap <silent><buffer> <c-n> :call search('message', 'W')<cr>
    nnoremap <silent><buffer> <c-p> :call search('message', 'bW')<cr>

    " call TermOneShot_FloatBuffer( Cmd, "otherWinColumn" )
  endif


  " if     a:termType == 'float'
  "   let resLines = systemlist( cmd )
  "   call Py_showInFloat( resLines )
  " elseif a:termType == 'term'
  "   call TermOneShot( cmd )
  " endif

endfunc
" filereadable( getcwd() . '/pyproject.toml' )
" Py_GetPrinterPath()

func! Py_showInFloat( data )
  let lines = RemoveTermCodes( a:data )
  if !len( lines )
    return
  endif
  " let resLines = functional#foldr( function("Py_filterCliLine") , [], lines )
  let resLines = lines
  " silent let g:floatWin_win = FloatingSmallNew ( resLines )
  " silent let g:floatWin_win = FloatingSmallNew ( resLines, "otherWinColumn" )
  silent let g:floatWin_win = FloatingSmallNew ( resLines, "cursor" )

  " if resLines[0][0] == "{" || resLines[0][0] == "["
  "   silent! exec "%!jq"
  "   let synt = 'json'
  " endif

  call PythonSyntaxAdditions() 
  silent call FloatWin_FitWidthHeight()
  if len( resLines ) > 10
    normal! zM
  endif
  silent wincmd p
endfun


" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
" let g:Py_TopLevPattern = '\v^((\s*)?\zs(inline|given|final|trait|override\sdef|type|val\s|lazy\sval|case\sclass|enum|final|object|class|def)\s|val)'
let g:Py_TopLevPattern = '\v(class|def)\s\zs\i*'
let g:Py_MainStartPattern = '\v(class)\s\zs\i*'

func! Py_MainStartBindingForw()
  " normal! }
  normal! jj
  call search( g:Py_MainStartPattern, 'W' )
endfunc

func! Py_MainStartBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Py_MainStartPattern, 'bW' )
  " normal! {
  normal! kk
  call search( g:Py_MainStartPattern, 'W' )
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc


func! Py_TopLevBindingForw()
  normal! jj
  call search( g:Py_TopLevPattern, 'W' )
endfunc

func! Py_TopLevBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Py_TopLevPattern, 'bW' )
  normal! kk
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


func! Py_GoReturn()
  let oLine = line('.')
  let oCol = virtcol('.')  " Get visible column position
  " using treesitter textobjects! ~/.config/nvim/plugin/config/treesitter.lua
  normal ]M
  let patterns = [
        \ '\s\zsreturn',
        \]
  let combined_pattern = '\v' . join(patterns, '|')
  keepjumps call search(combined_pattern, 'bW')
  let nLine = line('.')
  if nLine < oLine + 1
    keepjumps call cursor(oLine, oCol)  " Use cursor() instead of setpos()
    echo 'no return'
  endif
endfunc

func! Py_GoBackReturn()
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




