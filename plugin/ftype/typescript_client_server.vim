

" nnoremap <silent> gj :call UserChoiceAction( 'TS client server', {}, T_MenuCommands(), function('TestServerCmd'), [] )<cr>


" Notes/planning: ~/.config/nvim/notes/TestServer-TestClient.md
" old planning for testserver: ~/Documents/Notes/2022/TestServer-TestClient.md

" let g:testServerDefaultFiles = '/Users/at/Documents/Proj/g_ts_gql/b_pothos_repo/scratch/snapshot_sdl1/'
" let g:testServerDefaultFiles = '~/Documents/Proj/_templates/ts_client_server'
let g:testServerDefaultFiles = '~/Documents/Proj/g_edb_gql/scratch'

func! T_Menu()
  call UserChoiceAction( ' ', {}, T_MenuCommands(), function('TestServerCmd'), [] )
endfunc

func! T_MenuCommands()
  let testServerCmds =  [ {'section': 'Identifiers'} ]
  " nnoremap <silent> gsi :call T_DoSetImport()<cr>
  let testServerCmds += [ {'label': '_W set import',   'cmd': 'call T_DoSetImport()' } ]
  " nnoremap <silent> gwi :call T_DoSetPrinterIdentif()<cr>
  let testServerCmds += [ {'label': '_P set printer identif',   'cmd':'call T_DoSetPrinterIdentif()' } ]
  let testServerCmds = T_CurrentIdentif_report_withLinks( testServerCmds )

  let testServerCmds +=  [ {'section':'Fetch'} ]
  " nnoremap <silent> gsR :call T_ServerRefresh()<cr>:call T_Refetch('Client')<cr>
  let testServerCmds += [ {'label': '_Refresh + client refetch',   'cmd': 'call T_ServerRefresh()', 'cmd2': 'call T_Refetch("Client")' } ]
  " nnoremap <silent> gsr :call T_ServerRefresh()<cr>:echo 'Refeshed server'<cr>
  let testServerCmds += [ {'label': '_T Just server refresh',   'cmd': 'call T_ServerRefresh()', 'cmd2': 'echo "Refreshed server"' } ]

  " nnoremap <silent> ger :call T_Refetch('Client')<cr>
  let testServerCmds += [ {'label': '_F Client',   'cmd': 'call T_Refetch("Client")' } ]
  " nnoremap <silent> gdr :call T_Refetch('GqlExec')<cr>
  let testServerCmds += [ {'label': '_D GQL Exec',   'cmd': 'call T_Refetch("GqlExec")' } ]
  " nnoremap <silent> ,gdr :call T_Refetch('GqlExecWithError')<cr>
  let testServerCmds += [ {'label': '_E GQL Exec with error',   'cmd': 'call T_Refetch("GqlExecWithError")' } ]
  " nnoremap <silent> gwr :call T_Refetch('Printer')<cr>
  let testServerCmds += [ {'label': '_I Printer',   'cmd': 'call T_Refetch("Printer")' } ]
  " nnoremap <silent> ges :call T_Refetch('ShowSchema')<cr>
  let testServerCmds += [ {'label': '_Show schema',   'cmd': 'call T_Refetch("ShowSchema")' } ]
  let testServerCmds += [ {'label': '_Chromium Giql',   'cmd': 'call T_Giql_open()' } ]
  let testServerCmds += [ {'label': '_Voyager Diagram',   'cmd': 'call T_Voyager_open()' } ]
                                                 
  let testServerCmds +=  [ {'section': 'Server [' . (exists('g:T_ServerID') ? '↑]' : '↓]')} ]
  " nnoremap <silent> <leader>gss :call T_ServerStart()<cr>:echo 'Server started'<cr>
  let testServerCmds += [ {'label': '_A Server start',   'cmd': 'call T_ServerStart()', 'cmd2': 'echom "Server started"' } ]
  " nnoremap <silent> ,gss :call T_ServerStartT()<cr>:echo 'Server started'<cr>
  " let testServerCmds += [ {'label': '_G Server start in term',   'cmd': 'call T_ServerStartT()', 'cmd2': 'echo "Server started"' } ]
  let testServerCmds += [ {'label': '_G Server show term',   'cmd': 'call T_ServerShowTerm()' } ]
  " nnoremap <silent> <leader>gsS :call T_ServerStop()<cr>:echo 'Server stopped'<cr>
  let testServerCmds += [ {'label': '_H Server stop',   'cmd': 'call T_ServerStop()', 'cmd2': 'echom "Server stopped"' } ]


  let testServerCmds +=  [ {'section': 'Project [' . (T_IsInitialized() ? '↑]' : '↓]')} ]
  if !T_IsInitialized()
    let snapshotName = T_GetSnapshotNameFromFolderPath( g:testServerDefaultFiles )
    let testServerCmds += [ {'label': '_M Initialize from '. snapshotName ,   'cmd': 'call T_InitTesterFiles()' } ]
  else
    let testServerCmds += [ {'label': '_N Install packages',   'cmd': 'call T_InitInstallPackages()' } ]
    let testServerCmds += [ {'label': '_Make snapshot',   'cmd': 'call T_SnapshotTesterFiles( input( "Snapshot name: " ) )' } ]
  endif
  " let snapshotName = T_GetSnapshotNameFromFolder()
  let snapshotName = "-"
  if len( snapshotName )
    " let testServerCmds += [ {'label': '_Y Load: ['. snapshotName . ']' ,   'cmd': 'call T_ReactivateSnapshot( getline(".") )' } ]
    let testServerCmds += [ {'label': '_Y Load: ['. snapshotName . ']' ,   'cmd': 'call T_ReactivateSnapshot()' } ]
  endif

  return testServerCmds
endfunc


func! T_GetSnapshotNameFromFolder()
  let treeProps = v:lua.Ntree_getPathWhenOpen()
  if treeProps == v:null | return | endif
  if !(type( treeProps ) == type( {} )) | return '' | endif
  let lastPathComponent = fnamemodify( treeProps.linepath, ':t' )
  return matchstr( lastPathComponent, 'snapshot_\zs.*' )
endfunc

func! T_GetSnapshotNameFromFolderPath( path )
  let lastPathComponent = fnamemodify( a:path, ':t' )
  return matchstr( lastPathComponent, 'snapshot_\zs.*' )
endfunc
" T_GetSnapshotNameFromFolderPath( '~/Documents/Proj/g_edb_gql/scratch' )


func! TestServerCmd ( chosenObj )
  exec a:chosenObj.cmd
  if has_key( a:chosenObj, 'cmd2' )
    call timer_start(200, { tid -> execute( a:chosenObj.cmd2, "" )})
    " exec a:chosenObj.cmd2
  endif
endfunc


func! T_echo( str )
  call T_DelayedCmd( 'echom "' . a:str . '"', 500 )
endfunc
" call T_echo( 'hi 2 there')
" in lua: -- vim.fn.call( 'T_DelayedCmd', {'echo "hi there"', 1000} )

  " exec "call TestUserChoice1( {'otherData':123} )" ■
  " exec "call TestUserChoice1(" . string( {'otherData':123} ) . ")"
  " call call( actionFn, actionArgs + [processResult] )
  " 
  " if a:shouldEcho
  "   echo 'Searching ' . a:choosenObjCmd.label
  " endif
  " if has_key( a:choosenObjCmd, 'url' )
  "   exec '!open ' . shellescape( a:choosenObjCmd.url . a:searchTerm.term )
  " elseif has_key( a:choosenObjCmd, 'comm' )
  "   exec a:choosenObjCmd.comm . ' ' . a:searchTerm.term
  " endif

" let g:testServerCmds += [ {'label':'_Stackage',   'cmd':'call T_DoSetImport()'
"       \, 'cmd2':''
"       \}] ▲



" ─   Set import variables                               ■
" Set the imports of scratch/rServer.ts, testClient.ts and testPrinter.ts

" Set an exported identifier as a specific import variable in the testServer.ts file
func! T_DoSetImport()
  let [identif, modulePath] = T_ImportInfo()
  let [persistKey, label] = T_IdentifNameToPeristKey( identif )
  call VirtualRadioLabel( label )

  " 3. Which type of import var do we want to set?
  if     identif =~ 'sch' || identif =~ 'builder'
    " call T_SetServerTypeDef( identif, modulePath )
    call T_SetGqlExecTypeDef( identif, modulePath )
  elseif identif =~ 'resol'
    " call T_SetServerResolver( identif, modulePath )
    call T_SetGqlExecResolver( identif, modulePath )
  elseif identif =~ 'query'
    call T_SetClientQuery( identif, modulePath )
    call T_SetGqlExecQuery( identif, modulePath )
    " call T_Refetch("Client")
    " TODO: set and refetch might be a separate command?
  elseif identif =~ 'varia'
    call T_SetClientVariables( identif, modulePath )
    call T_SetGqlExecVariables( identif, modulePath )
  elseif identif =~ 'contex'
    " Server context factory function
    call T_SetServerContext( identif, modulePath )
  else
    call T_SetPrinterIdentif( identif, modulePath )
  endif
  " echo 'Set: ' . identif

  call T_CurrentIdentif_update( persistKey, identif, modulePath )
endfunc

" let g:testServerCurrentIdentif = {'schemaI': '', 'schemaM': '', 

func! T_CurrentIdentif_default()
  let def = {}
  let def.schema_identif = ''
  let def.schema_module = ''
  let def.query_identif = ''
  let def.query_module = ''
  return def
endfunc


func! T_IdentifNameToPeristKey( identif )
  let identif = a:identif
  if     identif =~ 'sch' || identif =~ 'builder'
    return ['schema', '▵s']
  elseif identif =~ 'resol'
    return ['resolver', '▵r']
  elseif identif =~ 'query'
    return ['query', '▵q']
  elseif identif =~ 'varia'
    return ['variables', '▵v']
  elseif identif =~ 'contex'
    return ['context', '▵c']
  else
    return ['printer', '«']
  endif
endfunc

func! T_ImportInfo()
  " 1. Get the module path
  let modulePath = T_AbsModulePath()
  " 2. Get the exported identifier
  let [export, altIdentif, identif; _] = split( getline('.') )
  if export != 'export'
    " echo 'identifier needs to be exported'
    call T_ExportLine()
    let ident = T_RemoveTypeColon( altIdentif )
  else
    let ident = T_RemoveTypeColon( identif )
  endif
  return [ident, modulePath]
endfunc

func! T_RemoveTypeColon( str )
  return substitute( a:str, ':', '', '' )
endfunc
" echo T_RemoveTypeColon( 'myVar:' )

func! T_ExportLine()
  let lineText = getline('.')
  let lineText = 'export ' . lineText
  call append( '.', lineText )
  normal dd
endfunc
" call T_ExportLine()

" Server:
" func! T_SetServerTypeDef( identifier, module )
"   let importStm = "import { " . a:identifier . " as schemaConfig } from '" . a:module . "'"
"   let TesterLines = T_ReadTesterFileLines('Server')
"   let TesterLines[0] = importStm
"   call T_WriteTesterFile( TesterLines, 'Server' )
" endfunc

" The context value setup depends a bit on which server is used. So currently only this contextFactory function is
" imported directly into the testServer.ts and used by currently only some servers (e.g. Express).
func! T_SetServerContext( identifier, module )
  let importStm = "import { " . a:identifier . " as context } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Server')
  let TesterLines[0] = importStm
  call T_WriteTesterFile( TesterLines, 'Server')
endfunc


func! T_SetGqlExecTypeDef( identifier, module )
  let importStm = "import { " . a:identifier . " as schemaSource } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('GqlExec')
  let TesterLines[0] = importStm
  call T_WriteTesterFile( TesterLines, 'GqlExec' )
endfunc

" func! T_SetServerResolver( identifier, module )
"   let importStm = "import { " . a:identifier . " as resolvers } from '" . a:module . "'"
"   let TesterLines = T_ReadTesterFileLines('Server')
"   let TesterLines[1] = importStm
"   call T_WriteTesterFile( TesterLines, 'Server')
" endfunc

func! T_SetGqlExecResolver( identifier, module )
  let importStm = "import { " . a:identifier . " as resolvers } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('GqlExec')
  let TesterLines[1] = importStm
  call T_WriteTesterFile( TesterLines, 'GqlExec')
endfunc

" Client:
func! T_SetClientQuery( identifier, module )
  let importStm = "import { " . a:identifier . " as query } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Client')
  let TesterLines[0] = importStm
  call T_WriteTesterFile( TesterLines, 'Client' )
  " call T_Refetch( 'Client' )
endfunc

func! T_SetGqlExecQuery( identifier, module )
  let importStm = "import { " . a:identifier . " as query } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('GqlExec')
  let TesterLines[2] = importStm " Note that the Client imports start at the 3rd line!
  call T_WriteTesterFile( TesterLines, 'GqlExec' )
  " call T_Refetch( 'GqlExec' )
endfunc

func! T_SetClientVariables( identifier, module )
  let importStm = "import { " . a:identifier . " as variables } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Client')
  let TesterLines[1] = importStm
  call T_WriteTesterFile( TesterLines, 'Client' )
endfunc

func! T_SetGqlExecVariables( identifier, module )
  let importStm = "import { " . a:identifier . " as variables } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('GqlExec')
  let TesterLines[3] = importStm
  call T_WriteTesterFile( TesterLines, 'GqlExec' )
endfunc

" Printer:
func! T_SetPrinterIdentif( identifier, module )
  let importStm = "import { " . a:identifier . " as testIdentif } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Printer')
  let TesterLines[0] = importStm
  call T_WriteTesterFile( TesterLines, 'Printer' )
  call T_Refetch( 'Printer' )
endfunc

func! T_DoSetPrinterIdentif()
  let [identif, modulePath] = T_ImportInfo()
  call T_SetPrinterIdentif( identif, modulePath )
endfunc
" ─^  Set import variables                               ▲


" ─   Vitest                                            ──

" npx vitest run ./node/inline-edit/inline-edit-app.spec.ts -t "performs inline edit on file"
func! JS_RunVitest(termType)
  let path = expand('%:p')
  let test_ln = searchpos( '\v\sit\(', 'cnb' )[0]
  let strInParan = matchstr( getline(test_ln), '\v\(\"\zs.{-}\ze\"' )
  " echo strInParan

  let Cmd = 'npx vitest run ' . path . ' -t "' . strInParan . '"'
  let Cmd = Cmd . " && clear && jq -C . /tmp/magenta-test.log"
  let Cmd = "jq -C . /tmp/magenta-test.log"

  if     a:termType == 'float'
    let resLines = systemlist( Cmd )
    silent let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )
    silent call FloatWin_FitWidthHeight()
    silent wincmd p
  elseif a:termType == 'term'
    call TermOneShot( Cmd )
  elseif a:termType == 'term_hidden'
    call TermOneShot( Cmd )
    silent wincmd c
  elseif a:termType == 'term_float'
    call TermOneShot_FloatBuffer( Cmd, 'otherWinColumn' )
  endif


endfunc



" ─   05-2024 standalone approach                        ■

func! JS_LspTypeAtPos(lineNum, colNum)
  let [oLine, oCol] = getpos('.')[1:2]
  call setpos('.', [0, a:lineNum, a:colNum, 0] )
  " currently doesn't return "async", but could
  let l:typeStr = v:lua.require('utils_lsp').type()
  call setpos('.', [0, oLine, oCol, 0] )
  return l:typeStr
endfunc
" echo JS_LspTypeAtPos(111, 10)

func! JS_SetPrinterIdentif()
  let path = expand('%:p')
  " let jsWd = JS_getRootFolderPath(["package.json"])
  let jsWd = JS_getRootFolderPath(["JsPrinter.js"])
  let relPath = substitute( path, jsWd, '', '' )
  let relPath = '.' . relPath
  call VirtualRadioLabel( '«')

  let [export, altIdentif, identif; _] = split( getline('.') )
  if export != 'export'
    " echo 'identifier needs to be exported'
    call T_ExportLine()
    let ident = T_RemoveTypeColon( altIdentif )
  else
    let ident = T_RemoveTypeColon( identif )
  endif

  let importStm = "import { " . ident . " as testIdentif } from '" . relPath . "'"
  let TesterLines = readfile( JsPrinterPath(), '\n' )
  let TesterLines[0] = importStm
  call writefile( TesterLines, JsPrinterPath() )
endfunc

func! JS_RunPrinter( termType )
  " compile typescript
  " let jsWd = JS_getRootFolderPath(["JsPrinter.js"])
  " let cmd = "cd " . jsWd . " && tsc"
  " let _resLines = systemlist( cmd)

  " https://tsx.is/typescript
  " let Cmd = 'NODE_NO_WARNINGS=1 node --experimental-require-module '
  let Cmd = 'npx tsx --no-deprecation '
  let Cmd = Cmd . JsPrinterPath()
  " let Cmd = 'NODE_NO_WARNINGS=1 ts-node '
  " let Cmd = 'bun '
  " let Cmd = 'npx ts-node --transpile-only '
  " let Cmd = 'node '
  " let Cmd = 'npx ts-node '

  let reset_needed = JS_ensure_type_modules()

  if     a:termType == 'float'
    let resLines = systemlist( Cmd )
    silent let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )
    silent call FloatWin_FitWidthHeight()
    silent wincmd p
  elseif a:termType == 'term'
    call TermOneShot( Cmd )
  elseif a:termType == 'term_hidden'
    call TermOneShot( Cmd )
    silent wincmd c
  elseif a:termType == 'term_float'
    call TermOneShot_FloatBuffer( Cmd )
  endif

  if reset_needed
    call T_DelayedCmd( "call JS_reset_type_modules()", 4000 )
    " call JS_reset_type_modules()
  endif
endfunc

func! JS_ensure_type_modules()
  let packagejson_lines = readfile( "./package.json", '\n' )
  " return packagejson_lines[2]
  let line3 = packagejson_lines[2]
  if line3 =~ '"type": "module"'
    return v:false
  endif
  let lineToInsert = '  "type": "module",'
  " Insert the line at position 2 in packagejson_lines
  call insert( packagejson_lines, lineToInsert, 2 )
  call writefile( packagejson_lines, './package.json' )
  return v:true
endfunc

func! JS_reset_type_modules()
  let packagejson_lines = readfile( "./package.json", '\n' )
  call remove( packagejson_lines, 2 )
  call writefile( packagejson_lines, './package.json' )
endfunc


func! JS_RunPrinterAppBundle()
  " let Cmd = 'NODE_NO_WARNINGS=1 node --experimental-require-module '
  " let Cmd = 'bun '
  " let Cmd = 'ts-node '
  let Cmd = 'node '
  let resLines = systemlist( Cmd . JsPrinterAppBundlePath() )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


func! ScalaTyDefPrinterPath()
  return JS_getRootFolderPath(["PrinterTyDef.scala"]) . "/PrinterTyDef.scala"
endfunc

func! ScalaPrinterFF4sApp()
  return JS_getRootFolderPath(["PrinterFF4sApp.scala"]) . "/PrinterFF4sApp.scala"
endfunc

func! ScalajsPrinterPath()
  return JS_getRootFolderPath(["PrinterJs.scala"]) . "/PrinterJs.scala"
endfunc

func! JsPrinterPath()
  return JS_getRootFolderPath(["JsPrinter.js"]) . "/JsPrinter.js"
endfunc

func! JsPrinterAppBundlePath()
  return JS_getRootFolderPath(["JsPrinterAppBundle.js"]) . "/JsPrinterAppBundle.js"
endfunc


func! JS_getRootFolderPath(rootFileNames)
    " Get the current file's directory
    let l:currentDir = expand('%:p:h')

    " Loop until we reach the root directory or find a root file
    while l:currentDir !=# '/'
        " Check if any of the root files exist in the current directory
        for l:rootFileName in a:rootFileNames
            if filereadable(l:currentDir . '/' . l:rootFileName)
                " If a root file is found, return the current directory
                return l:currentDir
            endif
        endfor

        " Move up one directory level
        let l:currentDir = fnamemodify(l:currentDir, ':h')
    endwhile

    " If no root file was found, return an empty string
    return ''
endfunc
" JS_getRootFolderPath(["package.json"])

" ─^  05-2024 standalone approach                        ▲




func! T_InsertLineAt( path, lineTxt, idx )
  let lines = readfile( a:path, '\n' )
  call insert( lines, a:lineTxt, a:idx )
  call writefile( lines, a:path )
endfunc


" ─   File operations                                    ■

func! T_WriteTesterFile( lines, testerName )
  let TesterPath = T_TesterFilePath( a:testerName )
  call writefile(a:lines, TesterPath)
endfunc

func! T_ReadTesterFileLines( testerName )
  let TesterPath = T_TesterFilePath( a:testerName )
  return readfile( TesterPath, '\n' )
endfunc

func! T_TesterFilePath( testerName )
  let TesterPath = getcwd( winnr() ) . '/scratch/r' . a:testerName . '.ts'
  return TesterPath
endfunc


let g:TesterFileNamesAll = ['rClient.ts' , 'rGqlExec.ts' , 'rPrinter.ts' , 'rServer.ts' , 'rsDefault.ts', 'rServer_currentIdentif', 'rServer_packages']
let g:TesterNamesAll =          ['Client' , 'GqlExec' , 'Printer' , 'Server' , 'sDefault']


" This should generally be empty so just StartServer() is called. Then testServer.ts uses process.env.SERVERNAME to e.g. call StartServerYoga()
let g:T_ServerName = ''
" let g:T_ServerName = 'Express'

func! T_TesterTerminalCommand( testCmd )

  if a:testCmd     == 'ShowSchema'
    let filePath = T_TesterFilePath( 'GqlExec' )
    let functionName = 'ShowSchema'

  elseif a:testCmd == 'GqlExec'
    let filePath = T_TesterFilePath( 'GqlExec' )
    let functionName = 'ExecSchema'

  elseif a:testCmd == 'GqlExecWithError'
    let filePath = T_TesterFilePath( 'GqlExec' )
    let functionName = 'ExecSchemaWithError'

  elseif a:testCmd == 'Server'
    let filePath = T_TesterFilePath( 'Server' )
    let functionName = 'StartServer' . g:T_ServerName

  elseif a:testCmd == 'ServerProps'
    let filePath = T_TesterFilePath( 'Server' )
    let functionName = 'ServerProps_show'

  elseif a:testCmd == 'Client'
    let filePath = T_TesterFilePath( 'Client' )
    let functionName = 'RunQuery'

  elseif a:testCmd == 'Printer'
    let filePath = T_TesterFilePath( 'Printer' )
    let functionName = 'RunPrint'

  else
    echoe a:testCmd . ' not supported!'
    return
  endif

  return T_NodeFunctionCall_TermCmd( filePath, functionName )
endfunc
" echo systemlist( T_TesterTerminalCommand( 'Printer' ) )
" echo systemlist( T_TesterTerminalCommand( 'ServerName' ) )
"  T_TesterTerminalCommand( 'ServerName' ) 
" T_TesterTerminalCommand( 'Printer' )
" echo systemlist( T_TesterTerminalCommand( 'Client' ) )
" T_NodeFunctionCall_TermCmd( "fileName", "functionName" )

" The current files' module path
func! T_AbsModulePath()
  " This is based on the convention of having include: "src" in tsconfig
  return '..' . CurrentRelativeModulePath()
endfunc



" ─^  File operations                                    ▲



" ─   Manage long running server process                 ■


" Restart the server to activate current schema/resolvers and any code it depends on!
func! T_ServerRefresh ()
  if !exists('g:T_ServerID')
    call T_ServerStart()
  else
    call T_ServerStop()
    call T_ServerStart()
  endif
endfunc

func! T_ServerProps()
  return systemlist( T_TesterTerminalCommand( 'ServerProps' ) )
endfunc
" echo T_ServerProps()

" This should be faster than the above
func! T_EnvProps()
  let fname = getcwd( winnr() ) . "/.env"
  let envLines = readfile( fname ) 
  let envLines = functional#map( { line -> split( line, '=' ) }, envLines )
  let dictionary = {}
  for line in envLines
    if !len(line) || line[0][0] == '#' | continue | endif
    let dictionary[ line[0] ] = substitute( line[1], '"', '', 'g' )
  endfor
  return dictionary
endfunc
" echo T_EnvProps()
" echo T_EnvProps()

func! T_Giql_open()
  call LaunchChromium_addWin( T_ServerGiql_url() )
endfunc

func! T_ServerShowTerm()
  if !exists('g:T_ServerID_bufnr') | call T_echo( 'T_Server is not running' ) | return | endif
  let cmd = 'sbuffer ' . g:T_ServerID_bufnr . ' | resize 10 | normal! G'
  exec( cmd )
endfunc


func! T_ServerGiql_url()
  let env = T_EnvProps()
  return env.r_inspect_giql
  " return "http://" . env.r_inspect_domain . ":" . env.r_inspect_port . "/" . env.r_inspect_giqlpath
endfunc

func! T_ServerStart ()
  if exists('g:T_ServerID') | call T_echo( 'T_Server is already running' ) | return | endif
  " let g:T_ServerID = jobstart( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
  exec "new"
  let g:T_ServerID_bufnr = bufnr()
  let g:T_ServerID = termopen( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
  silent wincmd c
endfunc

func! T_ServerStartT ()
  if exists('g:T_ServerID') | call T_echo( 'T_Server is already running' ) | return | endif
  exec "10new"
  let g:T_ServerID = termopen( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
endfunc

func! T_ServerStop ()
  if !exists('g:T_ServerID') | call T_echo( 'T_Server is not running' ) | return | endif
  call jobstop( g:T_ServerID )
  unlet g:T_ServerID
  unlet g:T_ServerID_bufnr
  " echo 'T_Server stopped'
endfunc


func! T_ServerMainCallback (job_id, data, event)
  " Test if a:data is a List
  let lines = RemoveTermCodes( a:data )
  if !len( lines ) | return | endif
  echom lines
endfunc

func! T_ServerErrorCallback (job_id, data, event)
  echom a:data
endfunc

let g:T_ServerCallbacks = {
      \ 'on_stdout': function('T_ServerMainCallback'),
      \ 'on_stderr': function('T_ServerErrorCallback'),
      \ 'on_exit': function('T_ServerMainCallback')
      \ }


func! T_RunJob( cmd, mode )
  let dir = getcwd( winnr() ) 
  if a:mode == 'background'
    let g:T_JobID = jobstart( a:cmd, { 'cwd': dir, 'on_stderr': function('T_ServerErrorCallback'), } )
  elseif a:mode == 'visible'
    exec "10new"
    let g:T_JobID = termopen( a:cmd, { 'cwd': dir, 'on_stderr': function('T_ServerErrorCallback'), } )
  endif
endfunc
" call T_RunJob( 'ls', 'visible' )



" ─^  Manage long running server process                 ▲


func! T_Refetch( testerName )
  let resLines = systemlist( T_TesterTerminalCommand( a:testerName ) )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc



" echo eval("[4, 5][0]")
" echo eval("{'aa': 11, 'bb': 22}").bb

func! T_CurrentIdentif()
  let persistPath = getcwd( winnr() ) . '/scratch/rServer_currentIdentif'
  if filereadable( persistPath )
    let confObj = eval( readfile( persistPath, '\n' )[0] )
  else
    let confObj = T_CurrentIdentif_default()
    call writefile( [string( confObj )], persistPath )
  endif
  return confObj
endfunc

func! T_CurrentIdentif_update( key, identif, module )
  let confObj = T_CurrentIdentif()
  let confObj[ a:key . '_identif' ] = a:identif
  let confObj[ a:key . '_module' ] = a:module
  let persistPath = getcwd( winnr() ) . '/scratch/rServer_currentIdentif'
  call writefile( [string( confObj )], persistPath )
endfunc

" Extends the UserChoiceAction menu config with (dummy) sections that show the currently active identifier and module 
func! T_CurrentIdentif_report( list_menuConf )
  if !T_IsInitialized() | return a:list_menuConf | endif
  let resConf = a:list_menuConf
  let confObj = T_CurrentIdentif()
  for key in ['printer', 'schema', 'resolver', 'query', 'variables', 'context']
    if has_key( confObj, key . '_identif' )
      " let infoStr = confObj[ key . '_identif' ] . ' ' . fnamemodify( confObj[ key . '_module' ], ':t:r' )
      let infoStr = confObj[ key . '_identif' ] . ' ' . fnamemodify( confObj[ key . '_module' ], ':t:r' )
      let infoStr = infoStr . ' ' . fnamemodify( confObj[ key . '_module' ], ':h' )
      let infoStr = key[0] . ": " . infoStr
      let resConf +=  [ {'section': infoStr} ]
    endif
  endfor
  return resConf
endfunc

func! T_CurrentIdentif_report_withLinks( list_menuConf )
  if !T_IsInitialized() | return a:list_menuConf | endif
  let resConf = a:list_menuConf
  " let resConf +=  [ {'section': 'Active identifiers'} ]
  let cmd = "call T_HighlightIdentifs()"
  let resConf +=  [ {'label': '_L Highlight Identifs', 'cmd': cmd} ]

  let confObj = T_CurrentIdentif()
  for key in ['printer', 'schema', 'resolver', 'query', 'variables', 'context']
    if has_key( confObj, key . '_identif' )
      let identi  = confObj[ key . '_identif' ]
      let relPath = confObj[ key . '_module' ][3:] . '.ts'
      let infoStr = confObj[ key . '_identif' ] . ' ' . fnamemodify( confObj[ key . '_module' ], ':t:r' )
      let infoStr = infoStr . ' ' . fnamemodify( confObj[ key . '_module' ], ':h' )
      " let infoStr = key[0] . ": " . infoStr
      let cmd = "call T_ShowIdentif( '" . relPath . "', '" . identi . "' )"
      let resConf +=  [ {'label': infoStr, 'cmd': cmd} ]
    endif
  endfor
  return resConf
endfunc


func! T_ShowIdentif( path, identif )
  let lineStart = "export const " . a:identif 
  exec( 'edit ' . a:path )
  " echom a:path
  let absPath = fnamemodify( a:path, ':p' )
  let cmd = "call v:lua.Ntree_revealFile('" . absPath . "')"
  call T_DelayedCmd( cmd, 400 )
  call search( lineStart, 'cw' )
  normal! zz
  let [_persistKey, label] = T_IdentifNameToPeristKey( a:identif )
  call VirtualRadioLabel( label )
  call UserChoiceAction( 'Ts client server', {}, T_MenuCommands(), function('TestServerCmd'), [] )
endfunc

func! T_HighlightIdentifs()
  let confObj = T_CurrentIdentif()
  for key in ['printer', 'schema', 'resolver', 'query', 'variables', 'context']
    if has_key( confObj, key . '_identif' )
      let identi  = confObj[ key . '_identif' ]
      let relPath = confObj[ key . '_module' ][3:] . '.ts'
      let lineStart = "export const " . identi
      exec( 'edit ' . relPath )
      call search( lineStart, 'cw' )
      let [_persistKey, label] = T_IdentifNameToPeristKey( identi )
      call VirtualRadioLabel( label )
    endif
  endfor
endfunc

" echo fnamemodify( "src/simple-interfaces-example/schema.ts", ':p' )
" call v:lua.Ntree_revealFile( fnamemodify( "src/simple-interfaces-example/schema.ts" , ':p' ) )


" ─   Initialization                                    ──

func! T_IsInitialized()
  return filereadable( T_TesterFilePath( 'GqlExec' ) )
endfunc

func! T_InitTesterFiles()
  let targetFolder = getcwd( winnr() ) . '/scratch'
  if !isdirectory( targetFolder ) | call mkdir( targetFolder, 'p' ) | endif
  call T_CopyFileNamesToFolder( g:TesterFileNamesAll + ['schemaView_voyager'], g:testServerDefaultFiles, targetFolder )
  call T_InitEnvFile()
endfunc

func! T_InitEnvFile()
  let path = getcwd( winnr() ) . '/.env'
  call T_AppendEchoLineToFile( 'r_port=4040', path )
  call T_AppendEchoLineToFile( 'r_servername="Apollo"', path )

  call T_AppendEchoLineToFile( 'r_inspect_url="http://localhost:4040/graphql"', path )
  call T_AppendEchoLineToFile( 'r_inspect_giql="http://localhost:4040/graphiql"', path )

  " call T_AppendEchoLineToFile( 'r_inspect_domain="localhost"', path )
  " call T_AppendEchoLineToFile( 'r_inspect_port=4040', path )
  " call T_AppendEchoLineToFile( 'r_inspect_apipath="graphql"', path )
  " call T_AppendEchoLineToFile( 'r_inspect_giqlpath="graphiql"', path )

endfunc

func! T_AppendEchoLineToFile( line, path )
  let cmd = 'echo ' . shellescape( a:line ) . ' >> ' . a:path
  echom system( cmd )
endfunc

func! T_InitInstallPackages()
  let path = getcwd( winnr() ) . '/scratch/rServer_packages'
  if !filereadable( path ) | echoe 'Missing: ' . path | return | endif
  let packages = readfile( path, '\n' )
  let path = getcwd( winnr() ) . '/package.json'
  if !filereadable( path ) 
    echo 'Not an npm project!' 
    echo system( 'pnpm init' )
  endif
  let cmd = T_GetPackageInstallCmdOfCurrentProject() . ' ' . join( packages )
  call T_RunJob( cmd, 'visible' )
endfunc

func! T_GetPackageInstallCmdOfCurrentProject()
  let path = getcwd( winnr() ) . '/pnpm-workspace.yaml'
  let ws = filereadable( path ) ? ' -w' : ''

  let path = getcwd( winnr() ) . '/pnpm-lock.yaml'
  if filereadable( path ) | return 'pnpm add -D' . ws | endif
  let path = getcwd( winnr() ) . '/yarn.lock'
  if filereadable( path ) | return 'yarn add -D' . ws | endif
  " return 'npm install --dev'
  " return 'yarn add -D'
  return 'pnpm add -D'
endfunc

" NOTE: Might stop at or destroy existing files! Copy might fail silently.
" copies files and folder (using cp -r )
func! T_CopyFileNamesToFolder( listOfFileNames, sourceFolderPath, targetFolderPath )
  let testFilePath = a:targetFolderPath . '/' . a:listOfFileNames[0]
  if filereadable( testFilePath )
    echoe 'File ' . testFilePath . ' already exists!'
    return
  endif
  if !isdirectory( a:targetFolderPath ) | call mkdir( a:targetFolderPath, 'p' ) | endif
  let commands = functional#map( { fname -> 'cp -r ' . a:sourceFolderPath . '/' . fname . ' ' . a:targetFolderPath . '/' . fname }, a:listOfFileNames )
  " echo commands
  call RunListOfCommands( commands )
endfunc

func! T_ForceCopyFileNamesToFolder( listOfFileNames, sourceFolderPath, targetFolderPath )
  let testFilePath = a:targetFolderPath . '/' . a:listOfFileNames[0]
  if !isdirectory( a:targetFolderPath ) | call mkdir( a:targetFolderPath, 'p' ) | endif
  let commands = functional#map( { fname -> 'cp ' . a:sourceFolderPath . '/' . fname . ' ' . a:targetFolderPath . '/' . fname }, a:listOfFileNames )
  call RunListOfCommands( commands )
endfunc

command! -nargs=? TestServerSnapshotTesterFiles call T_SnapshotTesterFiles( <q-args> )

func! T_SnapshotTesterFiles( snapshotName )
  let sourceFolder = getcwd( winnr() ) . '/scratch'
  let snapshotFolder = T_NextSnapshotDirPath( sourceFolder . '/snapshot_' . a:snapshotName )
  call T_CopyFileNamesToFolder( g:TesterFileNamesAll, sourceFolder, snapshotFolder )
endfunc

func! T_NextSnapshotDirPath( basePath )
  let idx = 1
  while isdirectory( a:basePath . idx )
    let idx += 1
  endwhile
  return a:basePath . idx
endfunc
" echo T_NextSnapDirPath( getcwd() . '/temp' )
" mkdir 'temp1' 'temp2'
" del 'temp1' 'temp2'

command! TestServerReactivateSnapshot call T_ReactivateSnapshot( getline('.') )

func! T_ReactivateSnapshot()
  let snapshotFolder = v:lua.Ntree_getPathWhenOpen().linepath
  if !len( snapshotFolder ) || !isdirectory( snapshotFolder )
    echo "Neo tree is not on a snapshot folder"
    return
  endif
  " auto backup the current files
  " call T_SnapshotTesterFiles( 'backup' )
  let targetFolder = getcwd( winnr() ) . '/scratch'
  " Overwrite the current tester files!
  call T_ForceCopyFileNamesToFolder( g:TesterFileNamesAll, snapshotFolder, targetFolder )
endfunc


" ─   Voyager                                           ──

func! T_Voyager_open ()
  call PyServer_stop()
  let pyServerPort = PyServer_start()
  let env = T_EnvProps()
  let apiUrl = env.r_inspect_url
  call LaunchChromium_addWin( 'http://localhost:' . pyServerPort . '?apiUrl=' . apiUrl )
endfunc

func! T_getFreePort( port )
  let cmd = 'lsof -i :' . a:port
  let res = system( cmd )
  if len( res ) > 0
    return T_getFreePort( a:port + 1 )
  else
    return a:port
  endif
endfunc

func! PyServer_start ()
  if exists('g:PyServerID') | call T_echo( 'PyServer is already running' ) | return | endif
  let port = T_getFreePort( 8012 )
  let cmd = "python -m http.server " . port
  let dir = getcwd( winnr() ) . "/scratch/schemaView_voyager" 
  if !isdirectory( dir ) | call echo ("Missing: " . dir) | return | endif
  let g:PyServerID = jobstart( cmd, { 'cwd': dir, 'on_stderr': function('T_ServerErrorCallback'), } )
  return port
endfunc

func! PyServer_stop ()
  if !exists('g:PyServerID') | return | endif
  call jobstop( g:PyServerID )
  unlet g:PyServerID
endfunc






