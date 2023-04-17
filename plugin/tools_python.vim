" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_python#bufferMaps()

  nnoremap <silent><buffer>         gew :call Py_SetPrinterIdentif( "plain" )<cr>
  nnoremap <silent><buffer>         get :call Py_SetPrinterIdentif( "table" )<cr>
  nnoremap <silent><buffer>         gef :call Py_SetPrinterIdentif( "file1" )<cr>
  nnoremap <silent><buffer>         geW :call Py_SetPrinterIdentif( "plain json" )<cr>
  nnoremap <silent><buffer>         gee :call Py_SetPrinterIdentif( "effect" )<cr>
  nnoremap <silent><buffer>         gegj :call Py_SetPrinterIdentif( "gallia" )<cr>
  nnoremap <silent><buffer>         gegs :call Py_SetPrinterIdentif( "gallias" )<cr>

  nnoremap <silent><buffer>         gei :call Py_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer> <leader>gei :call Py_RunPrinter( "term"  )<cr>

  nnoremap <silent><buffer> <leader>(     :call Py_MvStartOfBlock()<cr>
  onoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>
  vnoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>

  nnoremap <silent><buffer> <leader>)     :call Py_MvEndOfBlock()<cr>
  onoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>
  vnoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>

  nnoremap <silent><buffer> * :call MvPrevLineStart()<cr>
  nnoremap <silent><buffer> ( :call MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call MvNextLineStart()<cr>

  nnoremap <silent><buffer> I :call Py_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Py_ColonBackw()<cr>

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
  nnoremap <silent><buffer>         gej :lua vim.lsp.buf.signature_help()<cr>
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
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_py()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

endfunc


func! Py_LspTypeAtPos(lineNum, colNum)
  let [oLine, oCol] = getpos('.')[1:2]
  call setpos('.', [0, a:lineNum, a:colNum, 0] )
  let l:typeStr = v:lua.require'utils_lsp'.LspType()
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

func! Py_SetPrinterIdentif( keyCmdMode )

  " let [hostLn, identifCol] = searchpos( '^def\s\zs\i*\ze\=', 'cnbW' )
  let hostLn = line('.')
  let identifCol = 5

  let identif = matchstr( getline(hostLn ), '^def\s\zs\i*\ze\=' )
  " echo identif hostLn identifCol
  " return

  let typeStr = Py_LspTypeAtPos(hostLn, identifCol)
  if typeStr == "timeout"
    echo "Lsp timeout .. try again"
    return
  endif
  let typeStr = typeStr[6:]
  " echo typeStr
  " echo hostLn identifCol
  " return

  if     typeStr =~ "list" || typeStr =~ "set"
    let typeMode = "collection"
  else
    let typeMode = "plain"
  endif

  echo "Printer: " . identif . " - " . typeStr . " - " . typeMode
  call VirtualRadioLabel_lineNum( "« " . typeStr . " " . typeMode, hostLn )

  " from t2 import fruits as symToEval
  let _import = "from " . Py_GetPackageName() . " import " . identif . " as symToEval"
  let _printVal = "pprint( symToEval() )"

  if     typeMode == 'collection'
    let _info     = "print( len( symToEval() ) )"
  elseif typeMode == 'plain'
    let _info     = ""
  endif

  let printerFilePath = getcwd() . '/printer.py'
  let plns = readfile( printerFilePath, '\n' )


  let plns[2] = _import
  let plns[5] = _info
  let plns[7] = _printVal

  call writefile( plns, printerFilePath )
endfunc



let g:Py_PrinterCmd  = "python printer.py"

func! Py_RunPrinter( termType )

  let cmd = g:Py_PrinterCmd

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
  " let result = functional#foldr( function("Py_filterCliLine") , [], lines )
  let result = lines
  silent let g:floatWin_win = FloatingSmallNew ( result )
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

let g:Py_colonPttn = MakeOrPttn( ['\:\s', '\/\/', '*>', '-', '=', 'extends', 'yield', 'then', 'else', '\$'] )

func! Py_ColonForw()
  call SearchSkipSC( g:Py_colonPttn, 'W' )
  normal w
endfunc

func! Py_ColonBackw()
  normal bh
  call SearchSkipSC( g:Py_colonPttn, 'bW' )
  normal w
endfunc





