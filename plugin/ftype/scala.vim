" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..

nnoremap <silent> ges :call S_Menu()<cr>


func! S_Menu()
  call UserChoiceAction( ' ', {}, S_MenuCommands(), function('TestServerCmd'), [] )
endfunc

func! S_MenuCommands()
  let cmds =  [ {'section': 'Identifiers'} ]

  let cmds +=  [ {'section': 'Project [' . (S_IsInitialized() ? '↑]' : '↓]')} ]
  if !S_IsInitialized()
    let cmds += [ {'label': '_M Initialize from ..',   'cmd': 'echo "-"' } ]
  else
    let cmds += [ {'label': 'Printer & Examples',   'cmd': 'new m/_printer' } ]
    let cmds += [ {'label': 'Examples',   'cmd': 'new ' . g:ExamplesPath } ]
    " let cmds += [ {'label': '_Examples',   'cmd': "call v:lua.FloatBuf_inOtherWinColumn( 'm/_printer/ExampleLog.md' )" } ]
    let cmds += [ {'label': '_Examples',   'cmd': "new m/_printer/ExampleLog.md" } ]
    let cmds += [ {'label': '_Build',   'cmd': 'new build.sbt' } ]
    let cmds += [ {'label': '_Dependencies',   'cmd': 'new project/Dependencies.scala' } ]
  endif

  let cmds +=  [ {'section': 'Sbt printer [' . (exists('g:SbtPrinterID') ? '↑]' : '↓]')} ]
  let cmds += [ {'label': '_Printer term',   'cmd': 'call NewBuf_fromBufNr( g:SbtPrinter_bufnr, "down" )' } ]
  let cmds +=  [ {'section': 'Sbt long-run [' . (exists('g:SbtLongrunID') ? '↑]' : '↓]')} ]
  let cmds += [ {'label': '_Longrun term',   'cmd': 'call NewBuf_fromBufNr( g:SbtLongrun_bufnr, "down" )' } ]
  " let cmds +=  [ {'section': 'Sbt long-run up [' . (ScalaServerRepl_isRunning() ? '↑]' : '↓]')} ]
  " let cmds +=  [ {'section': 'Sbt reloader [' . (exists('g:SbtReloaderID') ? '↑]' : '↓]')} ]
  " let cmds += [ {'label': '_Reloader term',   'cmd': 'call NewBuf_fromBufNr( g:SbtReloader_bufnr, "down" )' } ]
  let cmds +=  [ {'section': 'Sbt Js [' . (exists('g:SbtJsID') ? '↑]' : '↓]')} ]
  let cmds += [ {'label': '_Js term',   'cmd': 'call NewBuf_fromBufNr( g:SbtJs_bufnr, "down" )' } ]
  let cmds += [ {'label': '_Vite term',   'cmd': 'call NewBuf_fromBufNr( g:SbtJsVite_bufnr, "down" )' } ]

  return cmds
endfunc

func! S_IsInitialized()
  return isdirectory( "m/_printer" )
endfunc


" Sbt terminals                           |
"                                         v
" nnoremap <silent> <leader><leader><c-w>sp  :call NewBuf_fromBufNr( g:SbtPrinter_bufnr, "down" )<cr>
" nnoremap <silent> <leader><leader><c-w>sl  :call NewBuf_fromBufNr( g:SbtLongrun_bufnr, "down" )<cr>
" nnoremap <silent> <leader><leader><c-w>sr  :call NewBuf_fromBufNr( g:SbtReloader_bufnr, "down" )<cr>
" nnoremap <silent> <leader><leader><c-w>sj  :call NewBuf_fromBufNr( g:SbtJs_bufnr, "down" )<cr>
" nnoremap <silent> <leader><leader><c-w>sv  :call NewBuf_fromBufNr( g:SbtJsVite_bufnr, "down" )<cr>


func! Scala_bufferMaps()


" ─   Printer                                            ■
  nnoremap <silent><buffer>         gep :call Scala_SetPrinterIdentif( "plain" )<cr>
  nnoremap <silent><buffer>         gew :call Scala_SetPrinterIdentif( "webbrowser" )<cr>
  nnoremap <silent><buffer> <leader>gew :call Scala_PrintAnyType_Js()<cr>
  nnoremap <silent><buffer>         geW :call Scala_ReSetPrinterIdentif_Js( getline('.') )<cr>
  nnoremap <silent><buffer>         geS :call Scala_SetPrinterIdentif( "server" )<cr>

  " TODO: to be tested again
  " nnoremap <silent><buffer>         get :call Scala_SetPrinterIdentif( "table" )<cr>
  " nnoremap <silent><buffer>         gef :call Scala_SetPrinterIdentif( "file1" )<cr>
  " " nnoremap <silent><buffer>         geW :call Scala_SetPrinterIdentif( "plain json" )<cr>
  " nnoremap <silent><buffer>         gee :call Scala_SetPrinterIdentif( "effect" )<cr>
  " nnoremap <silent><buffer>         gegj :call Scala_SetPrinterIdentif( "gallia" )<cr>
  " nnoremap <silent><buffer>         gegs :call Scala_SetPrinterIdentif( "gallias" )<cr>

  nnoremap <silent><buffer>         gei :call Scala_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer>         geb :call JS_RunPrinterAppBundle()<cr>
  nnoremap <silent><buffer>         geI :call Scala_RunPrinter( "server" )<cr>
  nnoremap <silent><buffer> <leader>gei :call Scala_RunPrinter( "term"  )<cr>
  nnoremap <silent><buffer>         gej :call SbtJs_compile()<cr>
" ─^  Printer                                            ▲

  " STUBS
  nnoremap <silent><buffer> <leader>es  :call Scala_AddSignature()<cr>
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_scala()<cr>
  nnoremap <silent><buffer> <leader>ey :call CreateInlineTestDec_indent_scala()<cr>

  " MOTIONS (see general motions in shared maps)
  nnoremap <silent><buffer> <leader><c-p> :call Scala_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <c-p>         :call Scala_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Scala_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <c-n>         :call Scala_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>

  call Scala_bufferMaps_shared()
endfunc


func! Scala_bufferMaps_shared()

  nnoremap <silent><buffer> µ :call HotspotTSFw()<cr>
  nnoremap <silent><buffer> <tab> :call HotspotTSBw()<cr>

" ─   Regex search maps                                  ■

" let g:Scala_MainStartPattern = '\v^((\s*)?\zs(sealed|val|inline|private|given|final|trait|override\sdef|abstract|type|val\s|lazy\sval|case\sclass|enum|final|object|class|def)\s|val)\zs'
" let g:Scala_TopLevPattern = '\v^(object|type|case|final|sealed|inline|class|trait)\s\zs'

" To be tested!
  " nnoremap <silent><buffer> ge;  :call v:lua.Search_mainPatterns( 'file', g:Scala_MainStartPattern )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.Search_mainPatterns( 'global', g:Scala_TopLevPattern )<cr>

  nnoremap <silent><buffer> gs;  :call v:lua.Search_mainPatterns( 'file' )<cr>
  nnoremap <silent><buffer> gs:  :call v:lua.Search_mainPatterns( 'global' )<cr>

  " nnoremap <silent><buffer> gsf  :Telescope current_buffer_fuzzy_find<cr>
  " nnoremap <silent><buffer> gsg  :Telescope live_grep<cr>
  nnoremap <silent><buffer> gsf  :call v:lua.Telesc_launch('current_buffer_fuzzy_find')<cr>
  nnoremap <silent><buffer> gsg  :call v:lua.Telesc_launch('live_grep')<cr>

  " nnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( 'global', expand('<cword>'), "normal" )<cr>
  " xnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( 'global', GetVisSel(), "normal" )<cr>

  nnoremap <silent><buffer> gsr  :call v:lua.Search_selection()<cr>
  xnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( 'global', GetVisSel(), "normal" )<cr>

  nnoremap <silent><buffer> gst  :call v:lua.Search_ast( expand('<cword>') )<cr>
  xnoremap <silent><buffer> gst  :call v:lua.Search_ast( GetVisSel() )<cr>

  " note the other "gs.." maps: ~/.config/nvim/plugin/config/telescope.vim‖/noteˍtheˍot


" ─^  Regex search maps                                  ▲

  " nnoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>
  " onoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>(     :call Scala_MvStartOfBlock()<cr>
  " onoremap <silent><buffer> <leader>(     :call Scala_MvStartOfBlock()<cr>
  onoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>
  vnoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>

  nnoremap <silent><buffer> <leader>)     :call Scala_MvEndOfBlock()<cr>
  onoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>
  vnoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>

  nnoremap <silent><buffer> * :call MvPrevLineStart()<cr>
  nnoremap <silent><buffer> ( :call MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call MvNextLineStart()<cr>

  nnoremap <silent><buffer> I :call Scala_ColumnForw()<cr>
  nnoremap <silent><buffer> Y :call Scala_ColumnBackw()<cr>

  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  " " find a new map if I actually use this:
  " nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>


" ─   Lsp                                                ■
" -- also at:
" ~/.config/nvim/plugin/utils_general_maps.lua#/--%20Lsp%20maps


  nnoremap <silent><buffer> <leader>/   :lua require('telescope.builtin').lsp_document_symbols()<cr>
  nnoremap <silent><buffer> <leader>ot  :Vista nvim_lsp<cr>

  nnoremap <silent><buffer> <leader>gek :call Scala_LspTopLevelHover()<cr>
  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>
  nnoremap <silent><buffer>         geK :lua vim.lsp.buf.signature_help()<cr>
  nnoremap <silent><buffer> ,sl :lua require('telescope.builtin').lsp_document_symbols()<cr>
  " nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({layout_config={vertical={sorting_strategy="ascending"}}})<cr>
  nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({initial_mode='insert'})<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  " nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>
  " nice using a qf list view and a preview. preview only shows up when cursor is in the qf list. else i can navigate with ]q [q
  nnoremap <silent><buffer> geR :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  " " this is small and local
  " nnoremap <silent><buffer> ger :lua require('telescope.builtin').lsp_references(require('telescope.themes').get_cursor({initial_mode='normal', layout_config={width=0.95, height=25}}))<cr>
  nnoremap <silent><buffer> ,ger <cmd>TroubleToggle lsp_references<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>
  nnoremap <silent><buffer> ger <cmd>Glance references<cr>
  nnoremap <silent><buffer> ge] :lua require("trouble").next({skip_groups = true, jump = true})<cr>
  nnoremap <silent><buffer> ge[ :lua require("trouble").previous({skip_groups = true, jump = true})<cr>
  nnoremap <silent><buffer> <leader>lr :lua vim.lsp.buf.rename()<cr>

endfunc


func! Scala_LspTypeAtPos(lineNum, colNum)
  let [oLine, oCol] = getpos('.')[1:2]
  call setpos('.', [0, a:lineNum, a:colNum, 0] )
  let typeStr = v:lua.require('utils_lsp').LspType()
  call setpos('.', [0, oLine, oCol, 0] )
  return typeStr
endfunc
" echo Scala_LspTypeAtPos(111, 10)
" echo Scala_LspTypeAtPos(line('.'), col('.'))
" TODO: keep refining: ~/.config/nvim/lua/utils_lsp.lua#/if%20retval%20==


func! Scala_LspType()
  let [oLine, oCol] = getpos('.')[1:2]
  let l:typeStr = Scala_LspTypeAtPos(oLine, oCol)
  return l:typeStr
endfunc
" echo Scala_LspType()

func! Scala_LspTopLevelHover()
  let [oLine, oCol] = getpos('.')[1:2]
  normal ^
  call SkipScalaSkipWords()
  lua vim.lsp.buf.hover()
  call setpos('.', [0, oLine, oCol, 0] )
endfunc


" ─^  Lsp                                                ▲






" ─   Motions                                            ■

" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Scala_MainStartPattern = '\v^((\s*)?\zs(sealed|val|operation|service|inline|private|given|final|trait|override\sdef|abstract|type|val\s|lazy\sval|case\sclass|case\sobject|enum|final|object|class|def)\s|val)\zs'
let g:Scala_TopLevPattern = '\v^(object|type|case|final|sealed|inline|class|trait)\s\zs'

func! Scala_TopLevBindingForw()
  call search( g:Scala_TopLevPattern, 'W' )
endfunc

func! Scala_MainStartBindingForw()
  " normal! }
  normal! jj
  call search( g:Scala_MainStartPattern, 'W' )
endfunc

func! Scala_TopLevBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Scala_TopLevPattern, 'bW' )
  " normal! {
  " normal! kk
  " call search( g:Scala_TopLevPattern, 'W' )
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc


func! Scala_MainStartBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Scala_MainStartPattern, 'bW' )
  " normal! {
  normal! kk
  call search( g:Scala_MainStartPattern, 'W' )
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc

" call search('\v^(\s*)?call', 'W')

func! Scala_MvStartOfBlock()
  normal! k
  exec "silent keepjumps normal! {"
  normal! j^
endfunc


func! Scala_MvEndOfBlock()
  normal! j
  exec "silent keepjumps normal! }"
  normal! k^
endfunc

func! BlockStart_VisSel()
  normal! m'
  normal! V
  call Scala_MvStartOfBlock()
  normal! o
endfunc


func! BlockEnd_VisSel()
  normal! m'
  normal! V
  call Scala_MvEndOfBlock()
  normal! o
endfunc


" let g:Scala_MvStartLine_SkipWords = '\v(val|def|lazy|private|final|override)'
let g:Scala_MvStartLine_SkipWordsL = ['val', 'def', 'case', 'lazy', 'private', 'final', 'override']
" echo "private" =~ g:Scala_MvStartLine_SkipWords

func! SkipScalaSkipWords()
  if GetCharAtCursor() == "."
    normal! l
    return
  endif
  if GetCharAtCursor() == "/" || GetCharAtCursor() == "*"
    normal! w
    return
  endif

  let cw = expand('<cword>')
  " if cw =~ g:Scala_MvStartLine_SkipWords
  if count( g:Scala_MvStartLine_SkipWordsL, cw )
    normal! w
    call SkipScalaSkipWords()
  endif
endfunc
"   .mapValues[ Domain.Destination.Issues ] { employeeIssues =>


func! MvLineStart()
  normal! m'
  normal! ^
  call SkipScalaSkipWords()
endfunc

func! MvNextLineStart()
  normal! m'
  normal! j^
  call SkipScalaSkipWords()
endfunc

func! MvPrevLineStart()
  normal! m'
  normal! k^
  call SkipScalaSkipWords()
endfunc

func! MakeOrPttn( listOfPatterns )
  return '\(' . join( a:listOfPatterns, '\|' ) . '\)'
endfunc

let g:Scala_columnPttn = MakeOrPttn( ['\:', '%', '+', '&', '->', '<-', '\#', '\/\/', '*>', '=', 'extends', 'yield', 'if', 'then', 'else', '\$'] )


func! Scala_ColumnForw()
  call SearchSkipSC( g:Scala_columnPttn, 'W' )
  normal w
endfunc

func! Scala_ColumnBackw()
  normal bh
  call SearchSkipSC( g:Scala_columnPttn, 'bW' )
  normal w
endfunc

" ─^  Motions                                            ▲


" ─   Hotspot motions                                    ■

" Note: <c-m> and <c-i> is now unmappable
" nnoremap <silent> <c-m> :call FnAreaForw()<cr>
" nnoremap <silent> <c-i> :call FnAreaBackw()<cr>
" Instead use option-key / alt-key maps that are sent by karabiner. see /Users/at/Documents/Notes/help.md.md#/###%20Mapping%20Alt
" nnoremap <silent> µ :call HotspotForw()<cr>
" nnoremap <silent> <tab> :call HotspotBackw()<cr>

" nnoremap <silent> µ :call HotspotTSFw()<cr>
" nnoremap <silent> <tab> :call HotspotTSBw()<cr>

func! HotspotTSFw()
  call search('\v(\.|\|)', 'W')
  normal! w
  let cw = expand('<cword>')
  " let cc = GetCharAtCursorAscii()
  if cw == '$'
    normal! ll
  endif
endfunc

func! HotspotTSBw()
  normal! h
  call search('\v(\.|\|)', 'bW')
  normal! l
  let cw = expand('<cword>')
  " let cc = GetCharAtCursorAscii()
  if cw == '$'
    call HotspotTSBw()
  endif
endfunc

func! HotspotForw()
  call SearchSkipSC( g:lineHotspotsPttn, 'W' )
  normal w
endfunc

func! HotspotBackw()
  normal bh
  call SearchSkipSC( g:lineHotspotsPttn, 'bW' )
  normal w
endfunc

" ─^  Hotspot motions                                    ▲


