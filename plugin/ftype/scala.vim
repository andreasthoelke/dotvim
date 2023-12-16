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
    let cmds += [ {'label': 'PrinterZio',   'cmd': 'edit src/main/scala/PrinterZio.scala' } ]
    let cmds += [ {'label': 'PrinterZioServer',   'cmd': 'edit src/main/scala/PrinterZioServer.scala' } ]
  endif

  let cmds +=  [ {'section': 'Repl [' . (exists('g:ScalaReplID') ? '↑]' : '↓]')} ]
  let cmds +=  [ {'section': 'ServerTerm [' . (exists('g:ScalaServerReplID') ? '↑]' : '↓]')} ]
  let cmds +=  [ {'section': 'Server [' . (ScalaServerRepl_isRunning() ? '↑]' : '↓]')} ]

  return cmds
endfunc

func! S_IsInitialized()
  return filereadable( T_TesterFilePath( 'GqlExec' ) )
endfunc




func! Scala_bufferMaps()


" ─   Printer                                            ■
  nnoremap <silent><buffer>         gew :call Scala_SetPrinterIdentif( "plain" )<cr>
  nnoremap <silent><buffer>         geW :call Scala_SetPrinterIdentif( "server" )<cr>

  " TODO: to be tested again
  " nnoremap <silent><buffer>         get :call Scala_SetPrinterIdentif( "table" )<cr>
  " nnoremap <silent><buffer>         gef :call Scala_SetPrinterIdentif( "file1" )<cr>
  " " nnoremap <silent><buffer>         geW :call Scala_SetPrinterIdentif( "plain json" )<cr>
  " nnoremap <silent><buffer>         gee :call Scala_SetPrinterIdentif( "effect" )<cr>
  " nnoremap <silent><buffer>         gegj :call Scala_SetPrinterIdentif( "gallia" )<cr>
  " nnoremap <silent><buffer>         gegs :call Scala_SetPrinterIdentif( "gallias" )<cr>

  nnoremap <silent><buffer>         gei :call Scala_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer>         geI :call Scala_RunPrinter( "server" )<cr>
  nnoremap <silent><buffer> <leader>gei :call Scala_RunPrinter( "term"  )<cr>
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

  nnoremap <silent><buffer> I :call Scala_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Scala_ColonBackw()<cr>

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
  nnoremap <silent><buffer>         gej :lua vim.lsp.buf.signature_help()<cr>
  nnoremap <silent><buffer> ,sl :lua require('telescope.builtin').lsp_document_symbols()<cr>
  " nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({layout_config={vertical={sorting_strategy="ascending"}}})<cr>
  nnoremap <silent><buffer> gel :lua require('telescope.builtin').lsp_document_symbols({initial_mode='insert'})<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer> ged :TroubleToggle workspace_diagnostics<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
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


" ─   Helpers                                            ■

func! Scala_BufferCatsOrZio()
  let lineZio  = searchpos( '\v^import\szio', 'cnbW' )[0]
  let lineCats = searchpos( '\v^import\scats\.', 'cnbW' )[0]
  if     lineZio && lineCats
    return 'both'
  elseif lineZio && !lineCats
    return 'zio'
  elseif !lineZio && lineCats
    return 'cats'
  elseif !lineZio && !lineCats
    return 'none'
  endif
endfunc

func! Scala_RepoBuildTool()
  let millPath  = filereadable( getcwd(winnr()) . '/build.sc' )
  let sbtPath   = filereadable( getcwd(winnr()) . '/build.sbt' )
  let scliPath  = filereadable( getcwd(winnr()) . '/build.scala' )
  if     millPath && !sbtPath
    return 'mill'
  elseif !millPath && sbtPath
    return 'sbt'
  elseif scliPath && !sbtPath
    return 'scala-cli'
  else
    " temp, bc/ i'm now using project.scala in sub folders
    return 'scala-cli'
  endif
endfunc


func! Scala_GetPackageName()
  let hostLn = searchpos( '\v^package\s', 'cnbW' )[0]
  if !hostLn
    return ""
  endif
  " let identif = matchstr( getline(hostLn ), '\vpackage\s\zs\i*\ze\W' )
  let packageName1 = split( getline( hostLn -2 ) )
  let packageName2 = split( getline( hostLn -1 ) )
  let packageName3 = split( getline( hostLn    ) )

  " support compound packageNames across multiple lines. NOTE only 2 or 3
  " consecutive lines are supported


  if len( packageName2 ) && packageName2[0] == "package"
    let packageName2 = packageName2[1]
    let packageName3 = packageName3[1]
    let packageName = packageName2 . "." . packageName3

    if len( packageName1 ) && packageName1[0] == "package"
      let packageName1 = packageName1[1]
      let packageName = packageName1 . "." . packageName
    endif

  else
    let packageName = packageName3[1]
  endif

  return packageName
endfunc

func! Sc_PackagePrefix()
  let name = Scala_GetPackageName()
  return len(name) ? name . "." : ""
endfunc


func! Scala_GetObjectName( identifLine )
  " NOTE: supports only one level of objects
  let [oLine, oCol] = getpos('.')[1:2]
  let hostLnObj      = searchpos( '\v^(object|case\sclass)\s', 'cnbW' )[0]
  call setpos('.', [0, hostLnObj, 0, 0] )
  let hostLnObjClose = searchpos( '\v^\}', 'cnW' )[0]
  call setpos('.', [0, oLine, oCol, 0] )
  " echo a:identifLine hostLnObj hostLnObjClose
  " return

  let identifIndented = getline(a:identifLine)[1] == " "
  if !identifIndented
    return ""
  endif

  let objName = matchstr( getline( hostLnObj ), '\v(object|case\sclass)\s\zs\i*' )
  return objName

endfunc

func! Sc_ObjectPrefix( identifLine )
  let name = Scala_GetObjectName( a:identifLine )
  return len(name) ? name . "." : ""
endfunc
" Scala_GetObjectName(line('.'))


" ─^  Helpers                                            ▲



func! Scala_AddSignature()
  let cw = expand('<cword>')
  if cw == "lazy"
    normal! ww
    let [hostLn, identifCol] = searchpos( '\v(lazy\s)?(val|def)\s\zs.', 'cnbW' )
    normal! bb
  else
    normal! w
    let [hostLn, identifCol] = searchpos( '\v(lazy\s)?(val|def)\s\zs.', 'cnbW' )
    normal! b
  endif

  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  " echo hostLn identifCol
  " return
  let typeStr = Scala_LspTypeAtPos(hostLn, identifCol)
  if typeStr == "timeout"
    echo "Lsp timeout .. try again"
    return
  endif
  " echo typeStr
  " echo hostLn identifCol
  " return

  let [oLine, oCol] = getpos('.')[1:2]
  call setpos('.', [0, hostLn, 0, 0] )

  let lineText = getline( hostLn )
  let [lineEq, idxEq] = searchpos( '\v\=(\s|\_$)', 'n' )

  let textBefore = lineText[:idxEq -3]
  let textAfter = lineText[idxEq -2:]

  normal! "_dd
  call append( hostLn -1, textBefore . ": " . typeStr . textAfter )
  normal! k
  call setpos('.', [0, hostLn, 0, 0] )
  call search('=')

endfunc



" ─   Set printer identifier                             ■

func! Scala_SetPrinterIdentif( mode )
  let effType  = Scala_BufferCatsOrZio()
  let repoType = Scala_RepoBuildTool()
  let fntag = 'ScalaCliZIO'
  call call( 'Scala_SetPrinterIdentif_' . fntag, [a:mode] )
endfunc


func! Scala_SetPrinterIdentif_ScalaCliZIO( keyCmdMode )

  let effType  = Scala_BufferCatsOrZio()

  normal! ww
  let [hostLn, identifCol] = searchpos( '\v(lazy\s)?(val|def)\s\zs.', 'cnbW' )
  normal! bb

  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  let typeStr = Scala_LspTypeAtPos(hostLn, identifCol)
  if typeStr == "timeout"
    echo "Lsp timeout .. try again"
    return
  endif
  " echo typeStr
  " echo hostLn identifCol
  " return

  " Support nesting in objects
  let classObjPath = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn)[:-2]
  let classObjIdentif = identif

  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif
  " echo identif
  " return


  if      typeStr =~ "ZIO\[" && typeStr =~ "DataSource_off" && typeStr =~ "\]\]"
    let typeMode = "QuillDSLive_coll"
  elseif  typeStr =~ "ZIO\[" && typeStr =~ "DataSource_off" || typeStr =~ "QIO\["
    let typeMode = "QuillDSLive"
  elseif  typeStr =~ "ZIO\[" && typeStr =~ "List"
    let typeMode = "zio_collection"
  elseif  effType == 'zio' && (typeStr =~ "IO\["  || typeStr =~ "UIO\[")
    let typeMode = "zio"

  elseif  effType == 'cats' && typeStr =~ "IO\["
    let typeMode = "cats"

  elseif  typeStr =~ "CompletionStage" && typeStr =~ "List"
    let typeMode = "CompletionStageList"

  elseif  typeStr =~ "CompletionStage"
    let typeMode = "CompletionStage"

  " elseif  typeStr =~ "ZIO\[" && typeStr =~ "List"
  "   let typeMode = "zio_collection"
  elseif  typeStr =~ "\(List"
    let typeMode = "tupled-collection"
  elseif  typeStr =~ "^\("
    let typeMode = "tupled-collection"
  elseif  typeStr =~ "List"
    let typeMode = "collection"
  elseif  typeStr =~ "Iterable"
    let typeMode = "collection"
  elseif  typeStr =~ "Set"
    let typeMode = "collection"
  elseif  typeStr =~ "Vector"
    let typeMode = "collection"
  elseif  typeStr =~ "Seq"
    let typeMode = "collection"
  elseif  typeStr =~ "Map"
    let typeMode = "collection"
  elseif  typeStr =~ "Array" 
    let typeMode = "array"
  elseif  typeStr =~ "\(Iterator"
    let typeMode = "tupled-iterator"
  elseif  typeStr =~ "Iterator"
    let typeMode = "iterator"
  else
    let typeMode = "plain"
  endif

  if a:keyCmdMode == 'server'
    " echo "ServerProcess: " . identif . " - " . typeStr . " - " . typeMode
    call VirtualRadioLabel_lineNum( "≀ " . typeStr . " " . typeMode, hostLn, "server" )
  else
    " echo "Printer: " . identif . " - " . typeStr . " - " . typeMode
    call VirtualRadioLabel_lineNum( "« " . typeStr . " " . typeMode, hostLn )
  endif

  " Default values
  " let _replTag    = '"RESULT_"'
  " let _replEndTag = '""'
  let _replTag    = '"RES_multi_"'
  let _replEndTag = '"_RES_multi_END"'
  let _info       = '""'
  let _infoEf     = 'ZIO.succeed( "" )'
  let _printVal   = '""'
  let _printValEf = 'ZIO.succeed( "" )'
  let _ConsoleLineEf = '  _ <- zio.Console.printLine( str )'
  " let _ConsoleLineEf = '  _ <- IO.println( str )'
  let _RunApp = '  val ziores = zio.Unsafe.unsafe { implicit unsafe => zio.Runtime.default.unsafe.run( app ).getOrThrowFiberFailure() }'

  if     a:keyCmdMode == 'effect' || typeMode == 'zio'
    let _printValEf   = identif . '.map( v => pprint.apply(v, width=3)  )' 
    " let _printValEf = identif          " already an effect

  elseif typeMode == 'cats'
    let _printValEf   = identif . '.map( v => pprint.apply(v, width=3)  )' 
    let _infoEf       = 'IO( "" )'
    let _ConsoleLineEf = '  _ <- IO.println( str )'
    let _RunApp = '   app.unsafeRunSync()'

  elseif typeMode == 'CompletionStage'
    let _printValEf = "Fiber.fromCompletionStage( " . identif . " ).join"

  elseif typeMode == 'CompletionStageList'
    let _printValEf = "Fiber.fromCompletionStage( " . identif . ' ).join.map( v => (v.size.toString + "\n" + v.toString ) )'

  elseif typeMode == 'collectionIO'
    " TODO: not clear where this came from
    let _infoEf     = "ZIO.succeed( " . identif . ".size.toString + '\n' )"    " an effect returning a string
    let _printValEf = "ZIO.succeed( " . identif . " )"                  " an effect now

  elseif typeMode == 'array'
    let _infoEf     = "ZIO.succeed( " . identif . ".size.toString + '\n' )"    " an effect returning a string
    let _printValEf = "ZIO.succeed( " . identif . ".toList )"                  " an effect now

  elseif typeMode == 'collection'
    let _info     = identif . ".size.toString + '\n'"
    let _printVal = identif . '.mkString("\n")'                 
    let _replTag    = '"RES_multi_"'
    let _replEndTag = '"_RES_multi_END"'

  elseif typeMode == 'iterator'
    let _info     = "printVal.size.toString + '\n'"
    let _printVal = identif . ".toList"                 

  elseif typeMode == 'tupled-iterator'
    let _printVal = identif . "._1.toList.toString + '\n' + " . identif . "._2.toList.toString"                

  elseif typeMode == 'tupled-collection'
    let _printVal = identif . "._1.toString + '\n' + " . identif . "._2.toString"                

  elseif typeMode == 'zio_collection'
    " NOTE: the following line works, but:
    " it runs the program (identif) twice, issuing side-effect twice (e.g. printing).
    " NEW ATTEMPT: .. still to be tested
    " let _infoEf   = identif . '.map( v => (v.size.toString + "\n" + v.toString ) )' 
    " show list size, then break list item per line
    " let _infoEf   = identif . '.map( v => (v.size.toString + "\n" + v.map(i => i.toString + "\n") ) )' 
    " this works. and just shows linewise objects
    " let _infoEf   = identif . '.map( v => (v.size.toString + "\n" + v.mkString("\n") ) )' 
    let _infoEf   = identif . '.map( v => (v.size.toString + "\n" + pprint.apply(v, width=3) ) )' 
    " let _printVal = identif                                 " already an effect
    let _replTag    = '"RES_multi_"'
    let _replEndTag = '"_RES_multi_END"'

  elseif typeMode == 'QuillDSLive_coll'
    " let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => v.size.toString + "\n" + v.mkString("\n") )'
    let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => (v.size.toString + "\n" + pprint.apply(v, width=3) ) )'


  elseif typeMode == 'QuillDSLive'
  " this uses a live case class instance with a datasource layer field like here:
  " /Users/at/Documents/Proj/_repos/11_spoti_gql_muse/src/main/scala/DPostgres.scala|21
  " val printValEf   = ZIO.serviceWithZIO[dpostgres.DSLive](_.adf1).map( v => v.size.toString + "\n" + pprint.apply(v, width=3) )
  " val printValEf   = ZIO.serviceWithZIO[dpostgres.DSLive](_.adf1).map( v => v.size.toString + "\n" + v.mkString("\n") )
  " let _printValEf = "ZIO.serviceWithZIO[" . classObjPath . "](_." . classObjIdentif . ").map( v => v.size.toString + '\n' + pprint.apply(v, width=3) )"
  " let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => v.size.toString + "\n" + v.mkString("\n") )'
  let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => pprint.apply(v, width=3) )'

  elseif typeMode == 'plain'
    " let _printVal = identif
    let _printVal = 'pprint.apply(' . identif . ', width=3 )'
    let _replTag    = '"RES_multi_"'
    let _replEndTag = '"_RES_multi_END"'
  endif

  if a:keyCmdMode == 'server'
    let printerFilePath = getcwd(winnr()) . '/src/main/scala/PrinterZioServer.scala'
  else
    let printerFilePath = getcwd(winnr()) . '/src/main/scala/PrinterZio.scala'
  endif

  if !filereadable(printerFilePath)
    let printerFilePath = getcwd(winnr()) . '/modules/core/PrinterZio.scala'
  endif
  if !filereadable(printerFilePath)
    let printerFilePath = getcwd(winnr()) . '/printer/PrinterZio.scala'
  endif

  let plns = readfile( printerFilePath, '\n' )

  " object P { // <<== this needs to be line 16!
  " NOTE: the line numbers here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/PrinterCats.scala#/object%20P%20{
  " 16) ScalaReplMainCallback will parse "RESULT_" or "FILEVIEW"
  let plns[17]  = "  val replTag  = " . _replTag
  " 18) the effect (or wrapped simple value) to be printed including packageName and object namespace
  let plns[19] = "  val printVal   = " . _printVal
  let plns[20] = "  val printValEf = " . _printValEf
  " 21) info effect can the an empty string or any additional string with a \n at the end. note: this prepended line may also show up in a FILEVIEW
  let plns[22] = "  val info     = " . _info
  let plns[23] = "  val infoEf   = " . _infoEf
  let plns[24] = "  val replEndTag   = " . _replEndTag

  let plns[32] = _ConsoleLineEf
  let plns[37] = _RunApp

  call writefile( plns, printerFilePath )
endfunc

" ─^  Set printer identifier                             ▲



" ─   Run Printer                                        ■

func! Scala_RunPrinter( termType )
  let effType  = Scala_BufferCatsOrZio()
  let effType  = 'zio'
  let repoType = Scala_RepoBuildTool()
  " echo effType repoType
  " return

  if     effType == 'zio' || effType == 'none'
    " let cmd = g:Scala_PrinterZioCmd
  elseif effType == 'cats' || effType == 'both' || effType == 'none'
    let cmd = g:Scala_PrinterCatsCmd
  else
    echoe "not supported: " . effType
    return
  endif

  if     repoType == 'scala-cli' && a:termType == 'float'
    let resLines = systemlist( cmd )
    call Scala_showInFloat( resLines )

  elseif repoType == 'scala-cli' && a:termType == 'term'
    call TermOneShot( cmd )

  elseif repoType == 'sbt'
    " call ScalaReplRun()

    " TODO: just temp for a prim zio sbt repo
    if effType == 'both'  || effType == 'zio' || effType == 'none'
      if a:termType == 'server'
        if !exists('g:ScalaServerReplID') | echo 'ScalaServerRepl is not running' | return | endif
        " Old version: NOTE: the initial \n as a convention to end the previous process using zio.Console.read
        " let cmd = "\nrunMain " . "printzioserver.runZioServerApp" . "\n"
        " New version: killJVMProcess should block so the new/restarted process should not be affected
        let cmd = "bgRunMain " . "printzioserver.runZioServerApp" . "\n"
        call ScalaServerRepl_killJVMProcess( 'runZioServerApp' )
        call ScalaSbtSession_RunMain( g:ScalaServerReplID, cmd )
      else
        if !exists('g:ScalaReplID') | echo 'ScalaRepl is not running' | return | endif
        let cmd = "runMain " . "printzio.runApp" . "\n"
        call ScalaSbtSession_RunMain( g:ScalaReplID, cmd )
      endif
    else
      echoe "not active"
      " call ScalaSbtSession_RunMain( "printcat.runCatsApp" )
    endif

  else
    echoe "not supported: " . repoType
    return
  endif
endfunc

" The '--py' option is experimental.
" Please bear in mind that non-ideal user experience should be expected.
" If you encounter any bugs or have feedback to share, make sure to reach out to the maintenance team at https://github.com/VirtusLab/scala-cli
" Scala CLI (v. 1.0.0-RC1) cannot post process TASTY files from Scala 3.3.0-RC4.
"  since post processing only cleans up source paths in TASTY file and it should not affect your application.
" To get rid of this message, please update Scala CLI version.




func! Scala_filterCliLine( line, accum )
  " filter all lines that contain these words:
  if a:line =~ '\v^(compil|\[warn|Please|The|If|Scala|To)'
    return a:accum
  elseif a:line =~ '\v(TASTY)'
    return a:accum
  else

    if a:line =~ '\v(RESULT_|ERROR)'
      " clean up / select from all lines that contain these words:
      let filteredLineStr = matchstr( a:line, '\v(RESULT_|ERROR)\zs.*' )
    else
      " keep all other lines as they are!
      let filteredLineStr = a:line
    endif
    return add( a:accum, filteredLineStr )

  endif
endfunc

func! Scala_showInFloat( data )
  let lines = RemoveTermCodes( a:data )

  if !len( lines )
    return
  endif

  " let resultVal = matchstr( lines[0], '\v(RESULT_)\zs.*' )

  " let result = functional#foldr( {line, accum -> accum . matchstr( line, '\v(RESULT_|ERROR)\zs.*' ) }, "", lines )
  let result = lines
  let result = functional#foldr( function("Scala_filterCliLine") , [], result )

  silent let g:floatWin_win = FloatingSmallNew ( result )
  call ScalaSyntaxAdditions() 
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfun


" ─^  Run Printer                                        ▲




" ─   Motions                                            ■

" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Scala_MainStartPattern = '\v^((\s*)?\zs(sealed|val|inline|private|given|final|trait|override\sdef|abstract|type|val\s|lazy\sval|case\sclass|enum|final|object|class|def)\s|val)\zs'
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

let g:Scala_colonPttn = MakeOrPttn( ['\:', '\#', '\/\/', '*>', '=', 'extends', 'yield', 'if', 'then', 'else', '\$'] )


func! Scala_ColonForw()
  call SearchSkipSC( g:Scala_colonPttn, 'W' )
  normal w
endfunc

func! Scala_ColonBackw()
  normal bh
  call SearchSkipSC( g:Scala_colonPttn, 'bW' )
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


