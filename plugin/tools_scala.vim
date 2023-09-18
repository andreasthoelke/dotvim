" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_scala#bufferMaps()

" ─     PrinterZio                                      ──
  nnoremap <silent><buffer>         gew :call Scala_SetPrinterIdentif( "plain" )<cr>
  nnoremap <silent><buffer>         get :call Scala_SetPrinterIdentif( "table" )<cr>
  nnoremap <silent><buffer>         gef :call Scala_SetPrinterIdentif( "file1" )<cr>
  nnoremap <silent><buffer>         geW :call Scala_SetPrinterIdentif( "plain json" )<cr>
  nnoremap <silent><buffer>         gee :call Scala_SetPrinterIdentif( "effect" )<cr>
  nnoremap <silent><buffer>         gegj :call Scala_SetPrinterIdentif( "gallia" )<cr>
  nnoremap <silent><buffer>         gegs :call Scala_SetPrinterIdentif( "gallias" )<cr>

  nnoremap <silent><buffer> <leader>es  :call Scala_AddSignature()<cr>

  nnoremap <silent><buffer>         gei :call Scala_RunPrinter( "float" )<cr>
  nnoremap <silent><buffer> <leader>gei :call Scala_RunPrinter( "term"  )<cr>
  " nnoremap <silent><buffer>         gep :call Scala_RunPrinter()<cr>:call T_DelayedCmd( "call Scala_SyntaxInFloatWin()", 4000 )<cr>

  nnoremap <silent><buffer>         gss :call Scala_SetServerApp_ScalaCLI()<cr>
  nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>
  nnoremap <silent><buffer>         ,,gsr :call Scala_ServerRestartTerm()<cr>
  nnoremap <silent><buffer>         gsS :call Scala_ServerStop()<cr>
  " nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>:call Scala_ServerClientRequest_rerun()<cr>
  " nnoremap <silent><buffer>         gsr :call Scala_ServerRestart()<cr>:call T_DelayedCmd( "call Scala_ServerClientRequest_rerun()", 4000 )<cr>
  " NOTE these are now global as well: /Users/at/.config/nvim/plugin/repl.vim
  nnoremap <silent><buffer>         gsf :call Scala_ServerClientRequest('', 'float')<cr>
  nnoremap <silent><buffer>        ,gsf :call Scala_ServerClientRequest( 'POST', 'float' )<cr>
  nnoremap <silent><buffer>         gsF :call Scala_ServerClientRequest('', 'term')<cr>
  nnoremap <silent><buffer>        ,gsF :call Scala_ServerClientRequest( 'POST', 'term' )<cr>

  nnoremap <silent><buffer>        gsh :call Scala_ServerClientRequest_x()<cr>


  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_scala()<cr>
  nnoremap <silent><buffer> <leader>ey :call CreateInlineTestDec_indent_scala()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

  nnoremap <silent><buffer> <leader><c-p> :call Scala_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <c-p>         :call Scala_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Scala_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <c-n>         :call Scala_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>

  " this works super nice. there's another (default?) mapping for leader ?
  nnoremap <silent><buffer> <leader>/   :lua require('telescope.builtin').lsp_document_symbols()<cr>
  nnoremap <silent><buffer> <leader>ot  :Vista nvim_lsp<cr>

  call tools_scala#bufferMaps_shared()

endfunc

func! tools_scala#bufferMaps_shared()
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

" ─     Lsp maps                                        ──
" -- also at:
" ~/.config/nvim/plugin/utils_general_maps.lua#/--%20Lsp%20maps

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
  let l:typeStr = v:lua.require'utils_lsp'.LspType()
  call setpos('.', [0, oLine, oCol, 0] )
  return l:typeStr
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
  let millPath  = filereadable( getcwd() . '/build.sc' )
  let sbtPath   = filereadable( getcwd() . '/build.sbt' )
  let scliPath  = filereadable( getcwd() . '/build.scala' )
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


func! Scala_SetPrinterIdentif( mode )
  let effType  = Scala_BufferCatsOrZio()
  let repoType = Scala_RepoBuildTool()
  " echo effType repoType
  if     repoType == 'scala-cli' && effType == 'zio'
    let fntag = 'ScalaCliZIO'
  elseif repoType == 'scala-cli' && effType == 'cats'
    let fntag = 'ScalaCliCats'
  elseif repoType == 'scala-cli' && effType == 'none'
    let fntag = 'ScalaCliCats'
  elseif repoType == 'scala-cli' && effType == 'both'
    let fntag = 'ScalaCliCats'
  elseif repoType == 'sbt' && effType == 'none'
    let fntag = 'ScalaCliZIO'
  elseif repoType == 'sbt' && effType == 'cats'
    let fntag = 'ScalaCliCats'
    " setting vars in printer.scala should not depend on sbt vs scala-cli?
  elseif repoType == 'sbt' && (effType == 'both' || effType == 'zio')
    " let fntag = 'SBT'
    " let fntag = 'ScalaCliCats'
    let fntag = 'ScalaCliZIO'
  else
    echoe "not supported"
    return
  endif
  " echo fntag
  call call( 'Scala_SetPrinterIdentif_' . fntag, [a:mode] )
endfunc

func! Scala_SetPrinterIdentif_SBT( mode )

  " /Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/DDaSci_ex/src/main/scala/Printer.scala
  let printerFilePath = 'src/main/scala/Printer.scala'

  " let packageName = split( getline(1), ' ' )[1]
  let packageName = Scala_GetPackageName()

  " let hostLn = searchpos( '\v(lazy\s)?val\s', 'cnbW' )[0]

  normal! ww
  let [hostLn, identifCol] = searchpos( '\v(lazy\s)?val\s\zs.', 'cnbW' )
  normal! bb

  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  let l:typeStr = Scala_LspTypeAtPos(hostLn, identifCol)
  if l:typeStr == "timeout"
    echo "Lsp timeout .. try again"
    return
  endif
  " echo l:typeStr
  " return

  let hostLnObj = searchpos( '\v^object\s', 'cnbW' )[0]
  let objName = matchstr( getline( hostLnObj ), '\vobject\s\zs\i*\ze\W' )

  if len( objName )
    let identif = packageName . "." . objName . "." . identif
  endif

  " // this just needs a place to evaluate
  " val dirPath = s"${System.getProperty("user.dir")}/data/printer/"  
  " // 8) set the ".tsv" file extension to create a table/column view. or "" for RESULT_ prints
  " val filePath = dirPath + "view.tsv"
  " // 10) use "writeFileContent" to simple (non Gallia) values. empty this line to not write a file.
  " val doVal = tutorial.A.ds3.write( filePath )
  " // 12) ScalaReplMainCallback will parse "RESULT_" or "FILEVIEW"
  " val replTag = "RESULT_"
  " // 14) info can the an empty string or any additional string with a \n at the end. note: this prepended line may also show up in a FILEVIEW
  " val info = readme.A.e10_sql.forceSize.toString + "\n"
  " // 16) define the formatting for the RESULT_ val. Use "" with FILEVIEW.
  " val printVal = readme.A.e10_sql.formatTable

  let force_mode = a:mode
  let mode = a:mode

  " for specific lsp types the rendering mode is set here
  if     l:typeStr == "HeadU"
    let mode = "gallia"
  elseif l:typeStr == "HeadZ"
    let mode = "gallias"
  elseif l:typeStr =~ "Self"
    let mode = "gallias"
  endif



  if    force_mode == "table"
    let _filePath = '""'
    let _doVal    = '""'
    let _replTag  = '"RESULT_"'
    let _info     = identif . '.forceSize.toString + "\n"'
    let _printVal = identif . '.formatPrettyTable'
    let mode = force_mode " just for the virtual label

  elseif force_mode == "file1"
    let _filePath = 'dirPath + "view.tsv"'
    let _doVal    = identif . ".write(filePath)"
    let _replTag  = '"FILEVIEW"'
    let _info     = '""'
    let _printVal = '"↧"'
    let mode = force_mode " just for the virtual label

  elseif mode == "gallia"
    let _filePath = '""'
    let _doVal    = '""'
    let _replTag  = '"RESULT_"'
    let _info     = '""'
    let _printVal = identif . '.format' . (force_mode == "plain json" ? "Json" : "PrettyJson")

  elseif mode == "gallias"
    let _filePath = '""'
    let _doVal    = '""'
    let _replTag  = '"RESULT_"'
    let _info     = identif . '.forceSize.toString + "\n"'
    let _printVal = identif . '.format' . (force_mode == "plain json" ? "Jsonl" : "PrettyJsons")

  else
    let _filePath = '""'
    let _doVal    = '""'
    let _replTag  = '"RESULT_"'
    let _info     = '""'
    let _printVal = identif

  endif

  let formatter = matchstr( _printVal, '\vformat\zs.*' )
  echo "Printer: " . identif . " - " . l:typeStr . " - " . mode . " " . formatter
  call VirtualRadioLabel_lineNum( "« " . l:typeStr . " " . mode . " " . formatter, hostLn )

  let plns = readfile( printerFilePath, '\n' )

  let plns[7]  = "  val filePath = " . _filePath
  let plns[9]  = "  val doVal    = " . _doVal
  let plns[11] = "  val replTag  = " . _replTag
  let plns[13] = "  val info     = " . _info
  let plns[15] = "  val printVal = " . _printVal

  call writefile( plns, printerFilePath )
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

func! Scala_GetObjectName_bak( identifLine )
  " NOTE: supports only one level of objects
  let [oLine, oCol] = getpos('.')[1:2]
  let hostLnObj      = searchpos( '\v^(object|case\sclass)\s', 'cnbW' )[0]
  call setpos('.', [0, hostLnObj, 0, 0] )
  let hostLnObjClose = searchpos( '\v^\}', 'cnW' )[0]
  call setpos('.', [0, oLine, oCol, 0] )
  " echo a:identifLine hostLnObj hostLnObjClose
  " return

  let scala33colonnotation = getline(hostLnObj) =~ ":"
  let identifIndented = getline(a:identifLine)[1] == " "
  if scala33colonnotation && !identifIndented
    return ""
  endif

  if scala33colonnotation && identifIndented
    let objName = matchstr( getline( hostLnObj ), '\v(object|case\sclass)\s\zs\i*' )
    return objName
  endif

  if a:identifLine > hostLnObj && a:identifLine < hostLnObjClose
    let objName = matchstr( getline( hostLnObj ), '\v(object|case\sclass)\s\zs\i*\ze\W' )
    return objName
  else
    return ""
  endif
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


func! Scala_SetPrinterIdentif_ScalaCliCats( keyCmdMode )

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
  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif

  if      typeStr =~ "IO\[" && typeStr =~ "List"
    let typeMode = "cats_collection"
  elseif  typeStr =~ "IO\["
    let typeMode = "cats"
  elseif  typeStr =~ "IO\[" && typeStr =~ "List"
    let typeMode = "cats_collection"
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
  " elseif  typeStr =~ "CompletionStage"
  "   let typeMode = "compl stg"
  else
    let typeMode = "plain"
  endif

  echo "Printer: " . identif . " - " . typeStr . " - " . typeMode
  call VirtualRadioLabel_lineNum( "« " . typeStr . " " . typeMode, hostLn )

  " Default values
  let _replTag    = '"RESULT_"'
  let _info       = '""'
  let _infoEf     = 'IO( "" )'
  let _printVal   = '""'
  let _printValEf = 'IO( "" )'

  if     a:keyCmdMode == 'effect' || typeMode == 'cats'
    let _printValEf = identif          " already an effect

  elseif typeMode == 'collectionIO'
    let _infoEf     = "IO( " . identif . ".size.toString + '\n' )"    " an effect returning a string
    let _printValEf = "IO( " . identif . " )"                  " an effect now

  elseif typeMode == 'array'
    let _infoEf     = "IO( " . identif . ".size.toString + '\n' )"    " an effect returning a string
    let _printValEf = "IO( " . identif . ".toList )"                  " an effect now

  elseif typeMode == 'collection'
    let _info     = identif . ".size.toString + '\n'"
    let _printVal = identif . '.mkString("\n")'                 

  elseif typeMode == 'iterator'
    let _info     = "printVal.size.toString + '\n'"
    let _printVal = identif . ".toList"                 

  elseif typeMode == 'tupled-iterator'
    let _printVal = identif . "._1.toList.toString + '\n' + " . identif . "._2.toList.toString"                

  elseif typeMode == 'tupled-collection'
    let _printVal = identif . "._1.toString + '\n' + " . identif . "._2.toString"                

  elseif typeMode == 'cats_collection'
    " NOTE: the following line works, but:
    " it runs the program (identif) twice, issuing side-effect twice (e.g. printing).
    " NEW ATTEMPT: .. still to be tested
    let _infoEf   = identif . '.map( v => (v.size.toString + "\n" + v.toString ) )' 
    " let _printVal = identif                                 " already an effect

  elseif typeMode == 'plain'
    let _printVal = identif
  endif

  let printerFilePath = getcwd() . '/PrinterCats.scala'
  let plns = readfile( printerFilePath, '\n' )

  " NOTE: the line numbers here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/PrinterCats.scala#/object%20P%20{
  " 9) ScalaReplMainCallback will parse "RESULT_" or "FILEVIEW"
  let plns[9]  = "  val replTag  = " . _replTag
  " 11) the effect (or wrapped simple value) to be printed including packageName and object namespace
  let plns[11] = "  val printVal   = " . _printVal
  let plns[12] = "  val printValEf = " . _printValEf
  " 14) info effect can the an empty string or any additional string with a \n at the end. note: this prepended line may also show up in a FILEVIEW
  let plns[14] = "  val info     = " . _info
  let plns[15] = "  val infoEf   = " . _infoEf

  call writefile( plns, printerFilePath )
endfunc

" val app =
"   for
"     in <- P.infoEf
"     pv <- P.printValEf
"     _ <- IO.println( P.replTag + P.info + in + P.printVal + pv )
"   yield ()

" @main
" def runCatsApp() = app.unsafeRunSync()

func! Scala_SetPrinterIdentif_ScalaCliZIO( keyCmdMode )

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
  elseif  typeStr =~ "IO\["  || typeStr =~ "UIO\["
    let typeMode = "zio"

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

  echo "Printer: " . identif . " - " . typeStr . " - " . typeMode
  call VirtualRadioLabel_lineNum( "« " . typeStr . " " . typeMode, hostLn )

  " Default values
  let _replTag    = '"RESULT_"'
  let _info       = '""'
  let _infoEf     = 'ZIO.succeed( "" )'
  let _printVal   = '""'
  let _printValEf = 'ZIO.succeed( "" )'

  if     a:keyCmdMode == 'effect' || typeMode == 'zio'
    let _printValEf   = identif . '.map( v => pprint.apply(v, width=3)  )' 
    " let _printValEf = identif          " already an effect

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
  endif

  " let printerFilePath = getcwd() . '/PrinterZio.scala'
  let printerFilePath = getcwd() . '/src/main/scala/PrinterZio.scala'
  if !filereadable(printerFilePath)
    let printerFilePath = getcwd() . '/modules/core/PrinterZio.scala'
  endif
  if !filereadable(printerFilePath)
    let printerFilePath = getcwd() . '/printer/PrinterZio.scala'
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

  call writefile( plns, printerFilePath )
endfunc


func! Scala_SetPrinterIdentif_ScalaCliZio_( mode )
  let printerFilePath = getcwd() . '/PrinterZio.scala'

  let hostLn = searchpos( '\v^(lazy\s)?val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  call VirtualRadioLabel_lineNum( '«', hostLn )

  " Support nesting in objects
  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif

  if a:mode == "effect"
    let bindingLine = "val printVal = " . identif
  else
    let bindingLine = "val printVal = ZIO.succeed( " . identif . " )"
  endif

  let printerLines = readfile( printerFilePath, '\n' )
  let printerLines[1] = bindingLine

  call writefile( printerLines, printerFilePath )
endfunc

func! Scala_SetServerApp_ScalaCLI()
  let printerFilePath = getcwd() . '/PreviewServer_Ember.scala'

  let hostLn = searchpos( '\v^(lazy\s)?val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )
  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif

  call VirtualRadioLabel_lineNum( "« httpApp" , hostLn )

  let bindingLine = "val httpApp = " . identif

  let printerLines = readfile( printerFilePath, '\n' )
  let printerLines[1] = bindingLine

  call writefile( printerLines, printerFilePath )

endfunc


let g:Scala_ServerCmd_Zio   = "scala-cli . --main-class PreviewServer --class-path resources -nowarn -Ymacro-annotations"
let g:Scala_ServerCmd_Ember = "scala-cli . --main-class server_ember.PreviewServer_Ember --class-path resources -nowarn -Ymacro-annotations"
" let g:Scala_PrinterZioCmd  = "scala-cli . --py --main-class printzio.PrinterZio --class-path resources -nowarn -Ymacro-annotations"
" let g:Scala_PrinterCatsCmd = "scala-cli . --main-class printcat.Printer --class-path resources -nowarn -Ymacro-annotations"
let g:Scala_PrinterCatsCmd = "scala-cli . --py --main-class printcat.runCatsApp --class-path resources -nowarn -Ymacro-annotations"
" let g:Scala_PrinterCatsCmd = "bloop run root --main printcat.runCatsApp"
" let g:Scala_PrinterZioCmd  = 'scala-cli . --py --main-class printzio.runZioApp  --class-path resources -nowarn -Ymacro-annotations --repository "https://maven-central.storage-download.googleapis.com/maven2"'
let g:Scala_PrinterZioCmd  = "scala-cli . --py --main-class printzio.runZioApp  --class-path resources -nowarn -Ymacro-annotations"
" let g:Scala_PrinterZioCmd  = "scala-cli . --py --main-class printzio.runZioApp  --class-path resources -nowarn -Ymacro-annotations --extra-jar '/Users/at/Documents/Proj/g_edgedb/edgedb-java-repo/build/libs/edgedb-java-0.1.1-SNAPSHOT-sources.jar'"
" let g:Scala_PrinterZioCmd  = "scala-cli . --py --main-class printzio.runZioApp  --class-path resources -nowarn -Ymacro-annotations --extra-jar '/Users/at/Documents/Proj/g_edgedb/edgedb-java-repo/examples/scala-examples/lib/com.edgedb.driver-0.1.1-SNAPSHOT.jar'"

func! Scala_RunPrinter( termType )
  let effType  = Scala_BufferCatsOrZio()
  let repoType = Scala_RepoBuildTool()
  " echo effType repoType
  " return

  if     effType == 'zio' || effType == 'none'
    let cmd = g:Scala_PrinterZioCmd
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
      call ScalaSbtSession_RunMain( "printzio.runZioApp" )
    else
      call ScalaSbtSession_RunMain( "printcat.runCatsApp" )
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


" ─   " PreviewServer                                   ──
" async running process scala-cli . --main-class PreviewServer
" can be started in term (to debug) or as job (invisible)
" no need for callback handlers
" can be jobstop'ed and restarted with new compiled scala-cli . --main-class PreviewServer

func! Scala_ServerRestart ()
  if !exists('g:Scala_ServerID')
    call Scala_ServerStart()
  else
    call Scala_ServerStop()
    call Scala_ServerStart()
  endif
endfunc

func! Scala_ServerRestartTerm ()
  if !exists('g:Scala_ServerID')
    call Scala_ServerStartT()
  else
    call Scala_ServerStop()
    call Scala_ServerStartT()
  endif
endfunc


func! ScalaServerMainCallback(job_id, data, event)
  " call Scala_ServerClientRequest_rerun()
  " call T_DelayedCmd( "call Scala_ServerClientRequest_rerun()", 1000 )
  return
  let lines = RemoveTermCodes( a:data )
  if !len( lines )
    return
  endif
  silent let g:floatWin_win = FloatingSmallNew ( lines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


let g:ScalaServerCallbacks = {
      \ 'on_stdout': function('ScalaServerMainCallback'),
      \ 'on_stderr': function('ScalaReplErrorCallback'),
      \ 'on_exit': function('ScalaReplExitCallback')
      \ }


func! Scala_ServerStart ()
  if exists('g:Scala_ServerID') | call T_echo( 'Scala_Server is already running' ) | return | endif
  silent let g:Scala_ServerID = jobstart( g:Scala_ServerCmd_Ember, g:ScalaServerCallbacks )
endfunc

func! Scala_ServerStartT ()
  if exists('g:Scala_ServerID') | call T_echo( 'Scala_Server is already running' ) | return | endif
  exec "8new"
  let g:Scala_ServerID = termopen( g:Scala_ServerCmd_Ember )
  silent wincmd p
endfunc


func! Scala_ServerStop ()
  if !exists('g:Scala_ServerID') | call T_echo( 'Scala_Server is not running' ) | return | endif
  silent call jobstop( g:Scala_ServerID )
  unlet g:Scala_ServerID
endfunc


" func! Scala_ServerClientRequest( args )
"   let urlExtension = GetLineFromCursor()
"   let g:scala_serverRequestCmd = "curl " . a:args . "http://localhost:8003/" . urlExtension
"   let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
"   silent let g:floatWin_win = FloatingSmallNew ( resultLines[3:] )
"   silent call FloatWin_FitWidthHeight()
"   silent wincmd p
" endfunc

" httpx -m PUT http://127.0.0.1:5000/actors -p filter_name "Robert Downey Jr." -j '{"age": 57, "height": 173}'
" httpx --help

" actors PUT -p filter_name "Robert Downey Jr." -j '{"age": 57, "height": 173}'
" conversion for my short version: don't use the -m key. all options after URL are optional. but the sequnce is fixed to how they appear in the --help


let g:httpport = 8080
" let g:httpport = 5000
" let g:httpdomain = '127.0.0.1'
let g:httpdomain = 'localhost'

func! Httpx_parse( source, result )
  if     a:source[0][0] == "-"
    let val = join( a:source, " " )
    let rest = []

  " elseif a:source[0] == "-j"
  elseif a:source[0] =~ '\v(POST|PUT|DELETE|UPDATE)'
    let val = "-m " . a:source[0]
    let rest = a:source[1:]
  else
    let val = "-m GET"
    let rest = a:source
  endif

  return [rest, a:result . " " . val]
endfunc

func! Scala_ServerClientRequest_x()
  let sourceLineItems = split( matchstr( getline("."), '\v(//\s)?\zs.*' ), " " )

  let url = sourceLineItems[0]
  let sourceLineItems = sourceLineItems[1:]

  " call append(line('.'), sourceLineItems)
  
  let extension = ""

  while len( sourceLineItems )
    let [sourceLineItems, extension] = Httpx_parse( sourceLineItems, extension )
  endwhile

  " echo extension
  " return

  let url = "http://" . g:httpdomain . ":" . g:httpport . "/" . url

  let g:scala_serverRequestCmd = "httpx " . url . extension
  " call append(line('.'), g:scala_serverRequestCmd)
  " return

  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )

  let jsonStartLine = functional#find( resultLines, '\v^(\{|\[)' )
  if jsonStartLine != -1
    let resultLines = resultLines[jsonStartLine:]
  endif
  " call Scala_showInFloat( resultLines )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines )
  if len( resultLines ) && !(resultLines[0] =~ 'error') && !(resultLines[0] =~ 'html')
    if jsonStartLine != -1
      silent exec "%!jq"
      call tools_edgedb#addObjCountToBuffer()
    endif
  endif

  set ft=json
  call TsSyntaxAdditions()
  silent call FloatWin_FitWidthHeight()
  silent wincmd p

endfunc


func! Scala_ServerClientRequest( args, mode )
  let urlEx = matchstr( getline("."), '\v(//\s)?\zs.*' )

  " let g:scala_serverRequestCmd = "http " . a:args . " :" . g:httpport . "/" . urlEx . " --ignore-stdin --stream"
  let g:scala_serverRequestCmd = "http " . a:args . " " . g:httpdomain . ":" . g:httpport . "/" . urlEx . " --ignore-stdin --stream"
  " call append(line('.'), g:scala_serverRequestCmd)
  " return
  if a:mode == 'term'
    call TermOneShot( g:scala_serverRequestCmd )
  else
    let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
    " call Scala_showInFloat( resultLines )
    silent let g:floatWin_win = FloatingSmallNew ( resultLines )
    if len( resultLines ) && !(resultLines[0] =~ 'error') && !(resultLines[0] =~ 'html')
      silent exec "%!jq"
    endif

    set ft=json
    call TsSyntaxAdditions()
    silent call FloatWin_FitWidthHeight()
    silent wincmd p
    " silent let g:floatWin_win = FloatingSmallNew ( resultLines )
    " silent call FloatWin_FitWidthHeight()
  endif
  " silent wincmd p
endfunc
" http --help
" echo system( "http localhost:8002/fruits/a eins=zwei --ignore-stdin" )
" echo system( "http localhost:8002/users name=zwei age=44 --ignore-stdin" )
" echo system( "curl -X POST localhost:8002/fruits/a --raw eins=zwei" )


func! Scala_ServerClientRequest_rerun()
  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc

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





