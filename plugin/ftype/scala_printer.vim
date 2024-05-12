

" ─   Helpers                                            ■

func! Scala_BufferCatsOrZio()
  " now using gej to call SbtJs_compile()
  let lineJs  = 0 " searchpos( '\v^import.*(html|dom|calico|laminar|scalajs|tyrian)\.', 'cnbW' )[0]
  let lineZio  = searchpos( '\v^import\szio', 'cnbW' )[0]
  let lineCats = searchpos( '\v^import\scats\.', 'cnbW' )[0]
  if lineJs
    return 'js'
  elseif &filetype == "css"
    return 'js'
  elseif     lineZio && lineCats
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


" ─   Printer examples                                   ■
" ~/Documents/Notes/scratch2023.md‖/#ˍPrinterˍ&

nnoremap <silent><leader>ces :call Example_SetStart()<cr>
nnoremap <silent><leader>cea :call Example_AddIdentif()<cr>

let g:ExamplesPath = "m/_printer/ExampleLog.md"

" filereadable( g:ExamplesPath )

func! Example_SetStart()
  if !filereadable( g:ExamplesPath )
    " call writefile( [], g:ExamplesPath )
    echo "missing ExampleLog.md"
    return
  endif
  let headerText = GetHeadingTextFromHeadingLine( line('.') )
  let linkPath = LinkPath_get()
  let lines = ["", "# " . headerText, linkPath]
  call writefile( lines, g:ExamplesPath, "a" )
  echo 'started ' . headerText
endfunc

" call writefile( ["hi"], g:ExamplesPath, "a" )
" readfile( g:ExamplesPath, '\n' )
            " CityId( "123" )    

func! Example_AddIdentif()
  let hostLn = line('.')
  " '\v^(\s*)?(\/\/\s|\"\s)?\zs\S.*' ), " " )
  let identif = matchstr( getline( hostLn ), '\v(\s*)?(val|def)?\s\zs\i*\ze\W' )
  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif

  let comment = matchstr( getline( hostLn -1 ), '\v(\s*)?(\/\/\s|\#\s)?\zs.*' )

  let linkPath = LinkPath_get()
  if len(comment)
    call writefile( [comment, identif . " " . linkPath], g:ExamplesPath, "a" )
  else
    call writefile( [identif . " " . linkPath], g:ExamplesPath, "a" )
  endif
  echo 'added ' . identif
endfunc


" ─^  Printer examples                                   ▲


" ─   Sbt split js modules                              ──

let g:SbtSmallModulesPackage = "printerjs"

func! Sbt_setSmallModulesPackage()
  let packageName = Scala_GetPackageName()
  if !(exists('g:SbtSmallModulesPackage') && g:SbtSmallModulesPackage != packageName)
    echo packageName . " was already set"
    return
  endif
  call Scala_setPrinterPackageName( packageName )
  let lineStr = '          .withModuleSplitStyle( ModuleSplitStyle.SmallModulesFor(List("' . packageName . '")) )'
  call File_searchReplaceLine( "build.sbt", "withModuleSplitStyle", lineStr )
  call SbtPrinterReload ()
endfunc

func! Scala_setPrinterPackageName( packageName )
  let lineStr = "package " . a:packageName
  call File_replaceLine( ScalajsPrinterPath(), 0, lineStr )
endfunc

func! File_replaceLine( path, lineNum, lineStr )
  if !filereadable(a:path)
    echo a:path . " not found!"
    return
  endif
  let plns = readfile( a:path, '\n' )
  let plns[a:lineNum] = a:lineStr
  call writefile( plns, a:path )
endfunc

func! File_findLineNum( path, searchStr )
  let lines = readfile( a:path, "\n" )
  let idx = functional#findP( lines, {x-> x =~ a:searchStr} )
  return idx
endfunc
" echo File_findLineNum( 'build.sbt', 'withModuleSplitStyle' )

func! File_searchReplaceLine( path, searchStr, lineStr )
  let lines = readfile( a:path, "\n" )
  let idx = functional#findP( lines, {x-> x =~ a:searchStr} )
  let lines[idx] = a:lineStr
  call writefile( lines, a:path )
endfunc



" ─   Set printer identifier                             ■

func! Scala_SetPrinterIdentif( mode )
  " let effType  = Scala_BufferCatsOrZio()
  " let repoType = Scala_RepoBuildTool()
  let fntag = 'ScalaCliZIO'
  call call( 'Scala_SetPrinterIdentif_' . fntag, [a:mode] )
endfunc



" Stop the console.log on app reloads. 
func! Scala_ReSetPrinterIdentif_Js( hostLn )
  call VirtualRadioLabel_lineNum( "", a:hostLn )
  let printerFilePath = ScalajsPrinterPath()
  if !filereadable(ScalajsPrinterPath())
    echo ScalajsPrinterPath() . " not found!"
    return
  endif
  let plns = readfile( ScalajsPrinterPath(), '\n' )
  let plns[19] = "   // pprint line (not active)"  
  let plns[28] = "  '[empty]'"
  call writefile( plns, ScalajsPrinterPath() )
endfunc

func! Scala_PrintAnyType_Js()
  normal! ww
  let [hostLn, identifCol] = searchpos( '\v(lazy\s)?(val|def|object)\s\zs.', 'cnbW' )
  normal! bb

  let identif = matchstr( getline( hostLn ), '\v(val|def|object)\s\zs\i*\ze\W' )
  if getline(hostLn ) =~ 'def '
    let identif = identif . '()'
  endif

  " Support nesting in objects
  let classObjPath = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn)[:-2]
  let classObjIdentif = identif

  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif


  call VirtualRadioLabel_lineNum( "« [any]", hostLn )
  if !filereadable(ScalajsPrinterPath())
    echo ScalajsPrinterPath() . " not found!"
    return
  endif
  let plns = readfile( ScalajsPrinterPath(), '\n' )
  let plns[19] = "  pprint.pprintln(" . identif . ")"
  let plns[28] = "  " . identif
  call writefile( plns, ScalajsPrinterPath() )
endfunc



func! Scala_SetPrinterIdentif_Js( identif, hostLn, typeStr )

  call VirtualRadioLabel_lineNum( "« " . a:typeStr, a:hostLn )

  if !filereadable(ScalajsPrinterPath())
    echo ScalajsPrinterPath() . " not found!"
    return
  endif

  let plns = readfile( ScalajsPrinterPath(), '\n' )

  let plns[19] = "   // pprint line (not active)"  
  let plns[28] = "  '[empty]'"

  " echo a:typeStr
  " return
  if     a:typeStr =~ "L\.HtmlElement" || a:typeStr =~ "L\.Div" || a:typeStr =~ "ReactiveHtmlElement"
    let plns[17] = "  val appElement = " . a:identif
    let plns[18] = '  renderOnDomContentLoaded(dom.document.querySelector("#app"), appElement)'
  elseif a:typeStr =~ "Resource"
    let plns[17] = "  val appElement = " . a:identif
    let plns[18] = '  Window[IO].document.getElementById("app").map(_.get).flatMap { appElement.renderInto(_).useForever }.unsafeRunAndForget()'
  " elseif a:typeStr =~ "Ty App"
  "   let plns[18] = '  TyrianIOApp.onLoad( "tyapp" -> appElement )'
  elseif a:typeStr =~ "Ty App"
    let plns[17] = "  val appElement = " . a:identif
    " let plns[18] = '  appElement.launch( "app-container" )'

  elseif a:typeStr =~ "Html[" || a:typeStr =~ "H["
    let plns[17] = "  val appElement = tydefault.TyrianDefaultApp"
    " let plns[18] = '  appElement.launch( "app-container" )'

    " let plns[18] = '  TyrianIOApp.onLoad( "tyapp" -> appElement )'

    " ----- write the *view* identifer into PrinterTyDefault.scala --------
    if !filereadable(ScalaTyDefPrinterPath())
      echo ScalaTyDefPrinterPath() . " not found!"
      return
    endif
    let plnsTy = readfile( ScalaTyDefPrinterPath(), '\n' )
    let plnsTy[34] = "    " . a:identif
    call writefile( plnsTy, ScalaTyDefPrinterPath() )
    " ----- write the *view* identifer into PrinterTyDefault.scala --------

  else
    " NEW 2024-5: All other types are pretty printed in the browser consolue
    " while keeping the dom app in line 17, 18 as it was.
    let plns[19] = "  pprint.pprintln(" . a:identif . ")"
    let plns[28] = "  " . a:identif
    " echo a:typeStr . " is not supported by Scala_SetPrinterIdentif_Js"
  endif

  call writefile( plns, ScalajsPrinterPath() )
endfunc



" ─   Set Printer Identif                               ──

func! Scala_SetPrinterIdentif_ScalaCliZIO( keyCmdMode )

  let effType  = Scala_BufferCatsOrZio()

  normal! ww
  let [hostLn, identifCol] = searchpos( '\v(lazy\s)?(val|def|object)\s\zs.', 'cnbW' )
  normal! bb

  let identif = matchstr( getline( hostLn ), '\v(val|def|object)\s\zs\i*\ze\W' )
  if getline(hostLn ) =~ 'def '
    let identif = identif . '()'
  endif

  if getline(hostLn ) =~ 'TyrianIOApp'
    let typeStr = "Ty App"
  else
    let typeStr = Scala_LspTypeAtPos(hostLn, identifCol)
    if typeStr == "timeout"
      echo "Lsp timeout .. try again"
      return
    endif
    " echo typeStr
    " echo hostLn identifCol
    " return
  endif


  " Support nesting in objects
  let classObjPath = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn)[:-2]
  let classObjIdentif = identif

  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif
  " echo typeStr identif
  " return


  if a:keyCmdMode == 'webbrowser'
    call Scala_SetPrinterIdentif_Js( identif, hostLn, typeStr )
    return
  endif

  " if typeStr =~ "Element" || typeStr =~ "ReactiveHtmlElement" || typeStr =~ "L\.Div" || typeStr == "Ty App" || typeStr =~ "Html["
  "   call Scala_SetPrinterIdentif_Js( identif, hostLn, typeStr )
  "   return
  " endif

  if      typeStr =~ "ZIO\[" && typeStr =~ "DataSource_off" && typeStr =~ "\]\]"
    let typeMode = "QuillDSLive_coll"
  elseif  typeStr =~ "ZIO\[" && typeStr =~ "DataSource_off" || typeStr =~ "QIO\["
    let typeMode = "QuillDSLive"
  elseif  typeStr =~ "ZIO\[" && typeStr =~ "List"
    let typeMode = "zio_collection"
  elseif  typeStr =~ "Either\[" && typeStr =~ '\(Option\|List\)'
    let typeMode = "either_collection"
  elseif  effType == 'zio' && (typeStr =~ "IO\["  || typeStr =~ "UIO\[" || typeStr =~ "Task\[")
    let typeMode = "zio"

  elseif  typeStr =~ " < " && typeStr =~ "IOs"
    let typeMode = "kyo"

  elseif  typeStr =~ "ConnectionIO\["
    let typeMode = "doobie"

  elseif  effType == 'cats' && typeStr =~ "IO\["
    let typeMode = "cats"

  elseif  typeStr =~ "CompletionStage" && typeStr =~ "List"
    let typeMode = "CompletionStageList"

  elseif  typeStr =~ "CompletionStage"
    let typeMode = "CompletionStage"

  elseif  typeStr =~ "Future"
    let typeMode = "Future"

  " elseif  typeStr =~ "ZIO\[" && typeStr =~ "List"
  "   let typeMode = "zio_collection"
  elseif  typeStr =~ "\(List"
    let typeMode = "tupled-collection"
  " elseif  typeStr =~ "^\("
  "   let typeMode = "tupled-collection"
  elseif  typeStr =~ "SelectionBuilder"
    let typeMode = "plain"
  elseif  typeStr =~ "Request" || typeStr =~ "Response"
    let typeMode = "plain"
  elseif  typeStr =~ "List"
    let typeMode = "collection"
  elseif  typeStr =~ "Iterable"
    let typeMode = "collection"
  " elseif  typeStr =~ "Set"
  "   let typeMode = "collection"
  elseif  typeStr =~ "Vector"
    let typeMode = "collection"
  elseif  typeStr =~ "Seq"
    let typeMode = "collection"
  " elseif  typeStr =~ "Map"
  "   let typeMode = "collection"
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


  " The different method names are used to I can killJVMProcess and restart a serverProcess. and not potentially a long running "runApp" normal process. (though these are mostly short)
  if a:keyCmdMode == 'server'
    let _MainMethodName = 'def runServerApp() ='
  else
    let _MainMethodName = 'def runApp() ='
  endif

  if effType == 'cats'
    let _ConsoleLineEf = '  _ <- IO.println( str )'
    let _RunApp = '   app.unsafeRunSync()'
    let _infoEf       = 'IO( "" )'
    let _printValEf   = 'IO( "" )'
  endif

  if     a:keyCmdMode == 'effect' || typeMode == 'zio'
    let _printValEf   = identif . '.map( v => pprint.apply(v, width=3, height=2000)  )' 
    " let _printValEf = identif          " already an effect

  elseif typeMode == 'cats'
    let _printValEf   = identif . '.map( v => pprint.apply(v, width=3, height=2000)  )' 

  " // val printValEf = e_doobie_docs.e2_program1.map( v => pprint.apply(v, width=3, height=2000)  )
  " val printValEf =  e_doobie_docs.program2.transact(e_doobie_docs.transConn).map( v => pprint.apply(v, width=3, height=2000)  )

  elseif typeMode == 'doobie'
    " NOTE: it's required to have a Transactor[IO] value named transConn in the same namespace.
    let transConnection = Sc_PackagePrefix() . "transConn" 
    let _printValEf   = identif . '.transact(' . transConnection . ').map( v => pprint.apply(v, width=3, height=2000)  )' 

  elseif typeMode == 'CompletionStage'
    let _printValEf = "Fiber.fromCompletionStage( " . identif . " ).join"

  elseif typeMode == 'Future'
    let _printValEf = "Fiber.fromFuture( " . identif . " ).join.map( v => pprint.apply(v, width=3, height=2000)  )"

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
    let _infoEf   = identif . '.map( v => (v.size.toString + "\n" + pprint.apply(v, width=3, height=2000) ) )' 
    " let _printVal = identif                                 " already an effect
    let _replTag    = '"RES_multi_"'
    let _replEndTag = '"_RES_multi_END"'

  elseif typeMode == 'either_collection'
    let _infoEf   = 'ZIO.fromEither( ' . identif . ' ).map( v => (v.size.toString + "\n" + pprint.apply(v, width=3, height=2000) ) )' 
    let _replTag    = '"RES_multi_"'
    let _replEndTag = '"_RES_multi_END"'


  elseif typeMode == 'QuillDSLive_coll'
    " let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => v.size.toString + "\n" + v.mkString("\n") )'
    let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => (v.size.toString + "\n" + pprint.apply(v, width=3, height=2000) ) )'


  elseif typeMode == 'QuillDSLive'
  " this uses a live case class instance with a datasource layer field like here:
  " /Users/at/Documents/Proj/_repos/11_spoti_gql_muse/src/main/scala/DPostgres.scala|21
  " val printValEf   = ZIO.serviceWithZIO[dpostgres.DSLive](_.adf1).map( v => v.size.toString + "\n" + pprint.apply(v, width=3) )
  " val printValEf   = ZIO.serviceWithZIO[dpostgres.DSLive](_.adf1).map( v => v.size.toString + "\n" + v.mkString("\n") )
  " let _printValEf = "ZIO.serviceWithZIO[" . classObjPath . "](_." . classObjIdentif . ").map( v => v.size.toString + '\n' + pprint.apply(v, width=3) )"
  " let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => v.size.toString + "\n" + v.mkString("\n") )'
  let _printValEf = 'ZIO.serviceWithZIO[' . classObjPath . '](_.' . classObjIdentif . ').map( v => pprint.apply(v, width=3, height=2000) )'

  elseif typeMode == 'plain'
    let _printVal = 'pprint.apply(' . identif . ', width=3, height=2000 )'

  elseif typeMode == 'kyo'
    let _printVal = 'pprint.apply( IOs.runLazy(' . identif . '), width=3, height=2000 )'
  endif


  if a:keyCmdMode == 'server'
    let printerFilePath = getcwd(winnr()) . '/m/_printer/PrinterServer.scala'
    if !filereadable(printerFilePath)
      " let printerFilePath = getcwd(winnr()) . '/src/main/scala/PrinterServer.scala'
      let printerFilePath = getcwd(winnr()) . '/server/src/main/scala/PrinterServer.scala'
    endif
  else
    let printerFilePath = getcwd(winnr()) . '/m/_printer/Printer.scala'
  endif

  if !filereadable(printerFilePath)
    let printerFilePath = getcwd(winnr()) . '/src/main/scala/Printer.scala'
    " let printerFilePath = getcwd(winnr()) . '/modules/core/Printer.scala'
  endif
  if !filereadable(printerFilePath)
    let printerFilePath = getcwd(winnr()) . '/server/src/main/scala/Printer.scala'
  endif

  if filereadable(printerFilePath)
    let plns = readfile( printerFilePath, '\n' )
  else
    echo "Printer not found!"
    echo printerFilePath
    return
  endif

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
  let plns[36] = _MainMethodName
  let plns[37] = _RunApp

  call writefile( plns, printerFilePath )
endfunc

" ─^  Set printer identifier                             ▲



" ─   Run Printer                                        ■

func! Scala_RunPrinter( termType )
  let effType  = Scala_BufferCatsOrZio()
  " now using gej to call SbtJs_compile()
  " if effType == 'js'
  "   call SbtJs_compile ()
  "   return
  " endif

  let effType  = 'zio'
  let repoType = Scala_RepoBuildTool()
  " echo effType repoType
  " return

  if     effType == 'zio' || effType == 'none'
    " let cmd = g:Scala_PrinterCmd
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
        if !exists('g:SbtLongrunID') | echo 'SbtLongrun is not running' | return | endif
        " Old version: NOTE: the initial \n as a convention to end the previous process using zio.Console.read
        " let cmd = "\nrunMain " . "printzioserver.runZioServerApp" . "\n"
        " New version: killJVMProcess should block so the new/restarted process should not be affected
        " let cmd = "bgRunMain " . "printerserver.runServerApp" . "\n"
        " Earlier Non-Sbt-revolver version:
        " let cmd = "printer/bgRunMain " . "printerserver.runServerApp" . "\n"
        " ISSUE: this could also kill a "runServerApp" in a different vim instance
        " TODO: technically I could use a unique (def name!) run command to then be able to selectively end/restart a process.
        " call SbtLongrun_killJVMProcess( 'runServerApp' )

        " Note the command does not auto-reload via "~printer/reStart" - (see func! SbtReloaderStart() for this)
        let cmd = "printer/reStart" . "\n"
        call ScalaSbtSession_RunMain( g:SbtLongrunID, cmd )
      else
        if !exists('g:SbtPrinterID') | echo 'SbtPrinter is not running' | return | endif
        " let cmd = "runMain " . "printer.runApp" . "\n"
        let cmd = "printer/runMain " . "printer.runApp" . "\n"
        call ScalaSbtSession_RunMain( g:SbtPrinterID, cmd )
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

