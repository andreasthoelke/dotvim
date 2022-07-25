


" Notes/planning: ~/.config/nvim/notes/TestServer-TestClient.md#/#%20Test%20Server

func! T_MenuCommands()
  let testServerCmds =  [ {'section': 'Set import identifier'} ]
  " nnoremap <silent> gsi :call T_DoSetImport()<cr>
  let testServerCmds += [ {'label': '_I set import',   'cmd': 'call T_DoSetImport()' } ]
  " nnoremap <silent> gwi :call T_DoSetPrinterIdentif()<cr>
  let testServerCmds += [ {'label': '_W set printer identif',   'cmd':'call T_DoSetPrinterIdentif()' } ]

  let testServerCmds +=  [ {'section':'Server refresh'} ]
  " nnoremap <silent> gsR :call T_ServerRefresh()<cr>:call T_Refetch('Client')<cr>
  let testServerCmds += [ {'label': '_Refresh + client refetch',   'cmd': 'call T_ServerRefresh()', 'cmd2': 'call T_Refetch("Client")' } ]
  " nnoremap <silent> gsr :call T_ServerRefresh()<cr>:echo 'Refeshed server'<cr>
  let testServerCmds += [ {'label': '_T Just server refresh',   'cmd': 'call T_ServerRefresh()', 'cmd2': 'echo "Refreshed server"' } ]

  let testServerCmds +=  [ {'section': 'Refetching'} ]
  " nnoremap <silent> ger :call T_Refetch('Client')<cr>
  let testServerCmds += [ {'label': '_E Client',   'cmd': 'call T_Refetch("Client")' } ]
  " nnoremap <silent> gdr :call T_Refetch('GqlExec')<cr>
  let testServerCmds += [ {'label': '_D GQL Exec',   'cmd': 'call T_Refetch("GqlExec")' } ]
  " nnoremap <silent> ,gdr :call T_Refetch('GqlExecWithError')<cr>
  let testServerCmds += [ {'label': 'GQL Exec with error',   'cmd': 'call T_Refetch("GqlExecWithError")' } ]
  " nnoremap <silent> gwr :call T_Refetch('Printer')<cr>
  let testServerCmds += [ {'label': '_Printer',   'cmd': 'call T_Refetch("Printer")' } ]
  " nnoremap <silent> ges :call T_Refetch('ShowSchema')<cr>
  let testServerCmds += [ {'label': '_Show schema',   'cmd': 'call T_Refetch("ShowSchema")' } ]

  let testServerCmds +=  [ {'section': 'Server start/stop'} ]
  " nnoremap <silent> <leader>gss :call T_ServerStart()<cr>:echo 'Server started'<cr>
  let testServerCmds += [ {'label': '_A Server start',   'cmd': 'call T_ServerStart()', 'cmd2': 'echom "Server started"' } ]
  " nnoremap <silent> ,gss :call T_ServerStartT()<cr>:echo 'Server started'<cr>
  let testServerCmds += [ {'label': '_G Server start in term',   'cmd': 'call T_ServerStartT()', 'cmd2': 'echo "Server started"' } ]
  " nnoremap <silent> <leader>gsS :call T_ServerStop()<cr>:echo 'Server stopped'<cr>
  let testServerCmds += [ {'label': '_H Server stop',   'cmd': 'call T_ServerStop()', 'cmd2': 'echom "Server stopped"' } ]

  let testServerCmds +=  [ {'section': 'Snapshots'} ]
  let testServerCmds += [ {'label': '_Create',   'cmd': 'call T_SnapshotTesterFiles( input( "Snapshot name: " ) )' } ]
  let snapshotName = T_GetSnapshotNameFromDirvishFolder()
  if len( snapshotName )
    let testServerCmds += [ {'label': '_Y Reactivate '. snapshotName ,   'cmd': 'call T_ReactivateSnapshot( getline(".") )' } ]
  endif

  let testServerCmds +=  [ {'section': 'Project [' . (T_IsInitialized() ? 'ready]' : 'not yet initialized]')} ]
  if !T_IsInitialized()
    let snapshotName = T_GetSnapshotNameFromFolderPath( g:testServerDefaultFiles )
    let testServerCmds += [ {'label': '_M Initialize from '. snapshotName ,   'cmd': 'call T_InitTesterFiles()' } ]
  endif
  let testServerCmds += [ {'label': '_N Install packages',   'cmd': 'call T_InitInstallPackages()' } ]

  let testServerCmds = T_CurrentIdentif_report( testServerCmds )
  return testServerCmds
endfunc


func! T_GetSnapshotNameFromDirvishFolder()
  if &ft != 'dirvish' | return '' | endif
  return T_GetSnapshotNameFromFolderPath( getline('.')[:-2] )
endfunc

func! T_GetSnapshotNameFromFolderPath( path )
  let lastPathComponent = fnamemodify( a:path, ':t' )
  return matchstr( lastPathComponent, 'snapshot_\zs.*' )
endfunc


nnoremap <silent> gs :call UserChoiceAction( 'Test Server Action', {}, T_MenuCommands(), function('TestServerCmd'), [] )<cr>

func! TestServerCmd ( chosenObj )
  exec a:chosenObj.cmd
  if has_key( a:chosenObj, 'cmd2' )
    call timer_start(200, { tid -> execute( a:chosenObj.cmd2, "" )})
    " exec a:chosenObj.cmd2
  endif
endfunc

" A general sleep, pause, delay, timeout function!
func! T_DelayedCmd( cmd, time )
   call timer_start( a:time, { tid -> execute( a:cmd, "" )})
endfunc
" call T_DelayedCmd( "echo 'hi there'", 1000 )

func! T_echo( str )
  call T_DelayedCmd( 'echom "' . a:str . '"', 500 )
endfunc
" call T_echo( 'hi 2 there')

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
" Set the imports of scratch/.testServer.ts, testClient.ts and testPrinter.ts

" Set an exported identifier as a specific import variable in the testServer.ts file
func! T_DoSetImport()
  let [identif, modulePath] = T_ImportInfo()

  " 3. Which type of import var do we want to set?
  if     identif =~ 'sch' || identif =~ 'builder'
    let persistKey = 'schema'
    " call T_SetServerTypeDef( identif, modulePath )
    call T_SetGqlExecTypeDef( identif, modulePath )
    call VirtualRadioLabel('▵s')
  elseif identif =~ 'resol'
    let persistKey = 'resolver'
    " call T_SetServerResolver( identif, modulePath )
    call T_SetGqlExecResolver( identif, modulePath )
    call VirtualRadioLabel('▵r')
  elseif identif =~ 'query'
    let persistKey = 'query'
    call T_SetClientQuery( identif, modulePath )
    call T_SetGqlExecQuery( identif, modulePath )
    call VirtualRadioLabel('▵q')
    " call T_Refetch("Client")
    " TODO: set and refetch might be a separate command?
  elseif identif =~ 'varia'
    let persistKey = 'variables'
    call T_SetClientVariables( identif, modulePath )
    call T_SetGqlExecVariables( identif, modulePath )
    call VirtualRadioLabel('▵v')
  elseif identif =~ 'contex'
    let persistKey = 'context'
    " Server context factory function
    call T_SetServerContext( identif, modulePath )
    call VirtualRadioLabel('▵c')
  else
    let persistKey = 'printer'
    call T_SetPrinterIdentif( identif, modulePath )
  endif
  echo 'Set: ' . identif

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
  let TesterPath = getcwd() . '/scratch/.test' . a:testerName . '.ts'
  " call T_EnsureTesterModuleFile( TesterPath, a:testerName )
  return TesterPath
endfunc


let g:TesterFileNamesAll = ['.testClient.ts' , '.testGqlExec.ts' , '.testPrinter.ts' , '.testServer.ts' , '.testsDefault.ts', '.testServer_currentIdentif', '.testServer_packages']
let g:TesterNamesAll =          ['Client' , 'GqlExec' , 'Printer' , 'Server' , 'sDefault']


" This should generally be empty so just StartServer() is called. Then .testServer.ts uses process.env.SERVERNAME to e.g. call StartServerYoga()
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
" echo T_TesterTerminalCommand( 'Printer' )
" echo systemlist( T_TesterTerminalCommand( 'Client' ) )


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


func! T_ServerStart ()
  if exists('g:T_ServerID') | call T_echo( 'T_Server is already running' ) | return | endif
  let g:T_ServerID = jobstart( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
endfunc

func! T_ServerStartT ()
  if exists('g:T_ServerID') | call T_echo( 'T_Server is already running' ) | return | endif
  exec "10new"
  let g:T_ServerID = termopen( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
endfunc

func! T_RunJob( cmd, mode )
  if a:mode == 'background'
    let g:T_JobID = jobstart( a:cmd, g:T_ServerCallbacks )
  elseif a:mode == 'visible'
    exec "10new"
    let g:T_JobID = termopen( a:cmd, g:T_ServerCallbacks )
  endif
endfunc
" call T_RunJob( 'ls', 'visible' )

func! T_ServerStop ()
  if !exists('g:T_ServerID') | call T_echo( 'T_Server is not running' ) | return | endif
  call jobstop( g:T_ServerID )
  unlet g:T_ServerID
  " echo 'T_Server stopped'
endfunc


func! T_ServerMainCallback (job_id, data, event)
  echom a:data
endfunc

func! T_ServerErrorCallback (job_id, data, event)
  echom a:data
endfunc

let g:T_ServerCallbacks = {
      \ 'on_stdout': function('T_ServerMainCallback'),
      \ 'on_stderr': function('T_ServerErrorCallback'),
      \ 'on_exit': function('T_ServerMainCallback')
      \ }


" ─^  Manage long running server process                 ▲


func! T_Refetch( testerName )
  let resLines = systemlist( T_TesterTerminalCommand( a:testerName ) )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


func! T_EnsureTesterModuleFile( TesterPath, testerName )
  if !filereadable( a:TesterPath )
    " There's no testServer.ts file yet in this project - copy a template
    let dirpath = fnamemodify( a:TesterPath, ':p:h')
    if !isdirectory( dirpath )
      call mkdir( dirpath, 'p' )
    endif
    let templateFile = '~/.config/nvim/notes/templates/.test' . a:testerName . '.ts'
    let templateFile = fnamemodify( templateFile, ':p')
    let lines = readfile( templateFile, '\n' )
    call writefile(lines, a:TesterPath)
  endif
endfunc

" echo eval("[4, 5][0]")
" echo eval("{'aa': 11, 'bb': 22}").bb

func! T_CurrentIdentif()
  let persistPath = getcwd() . '/scratch/.testServer_currentIdentif'
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
  let persistPath = getcwd() . '/scratch/.testServer_currentIdentif'
  call writefile( [string( confObj )], persistPath )
endfunc

" Extends the UserChoiceAction menu config with (dummy) sections that show the currently active identifier and module 
func! T_CurrentIdentif_report( list_menuConf )
  let resConf = a:list_menuConf
  let confObj = T_CurrentIdentif()
  for key in ['schema', 'resolver', 'query', 'variables', 'context']
    if has_key( confObj, key . '_identif' )
      let infoStr = confObj[ key . '_identif' ] . ' ' . fnamemodify( confObj[ key . '_module' ], ':t:r' )
      let resConf +=  [ {'section': infoStr} ]
    endif
  endfor
  return resConf
endfunc


func! T_IsInitialized()
  return filereadable( T_TesterFilePath( 'GqlExec' ) )
endfunc

let g:testServerDefaultFiles = '/Users/at/Documents/Server-Dev/pothos/pothos/scratch/snapshot_sdl1'

func! T_InitTesterFiles()
  let targetFolder = getcwd() . '/scratch'
  if !isdirectory( targetFolder ) | call mkdir( targetFolder, 'p' ) | endif
  call T_CopyFileNamesToFolder( g:TesterFileNamesAll, g:testServerDefaultFiles, targetFolder )

  call T_InitEnvFile()
endfunc

func! T_InitEnvFile()
  let path = getcwd() . '/.env'
  call T_AppendEchoLineToFile( 'TESTPORT=4040', path )
  call T_AppendEchoLineToFile( 'TESTSERVERNAME="Apollo"', path )
endfunc

func! T_AppendEchoLineToFile( line, path )
  let cmd = 'echo ' . shellescape( a:line ) . ' >> ' . a:path
  echom system( cmd )
endfunc

func! T_InitInstallPackages()
  let path = getcwd() . '/scratch/.testServer_packages'
  if !filereadable( path ) | echoe 'Missing: ' . path | return | endif
  let packages = readfile( path, '\n' )
  let cmd = T_GetPackageInstallCmdOfCurrentProject() . ' ' . join( packages )
  call T_RunJob( cmd, 'visible' )
endfunc

func! T_GetPackageInstallCmdOfCurrentProject()
  let path = getcwd() . '/pnpm-workspace.yaml'
  let ws = filereadable( path ) ? ' -w' : ''

  let path = getcwd() . '/pnpm-lock.yaml'
  if filereadable( path ) | return 'pnpm add -D' . ws | endif
  let path = getcwd() . '/yarn.lock'
  if filereadable( path ) | return 'yarn add -D' . ws | endif
  let path = getcwd() . '/package.json'
  if !filereadable( path ) | echoe 'Not an npm project!' | return | endif
  return 'npm install --dev'
endfunc

" Notes: Might stop at or destroy existing files! Copy might fail silently.
func! T_CopyFileNamesToFolder( listOfFileNames, sourceFolderPath, targetFolderPath )
  let testFilePath = a:targetFolderPath . '/' . a:listOfFileNames[0]
  if filereadable( testFilePath )
    echoe 'File ' . testFilePath . ' already exists!'
    return
  endif
  if !isdirectory( a:targetFolderPath ) | call mkdir( a:targetFolderPath, 'p' ) | endif
  let commands = functional#map( { fname -> 'cp ' . a:sourceFolderPath . '/' . fname . ' ' . a:targetFolderPath . '/' . fname }, a:listOfFileNames )
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
  let sourceFolder = getcwd() . '/scratch'
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

func! T_ReactivateSnapshot( snapshotFolder )
  " auto backup the current files
  " call T_SnapshotTesterFiles( 'backup' )
  let targetFolder = getcwd() . '/scratch'
  " Overwrite the current tester files!
  call T_ForceCopyFileNamesToFolder( g:TesterFileNamesAll, a:snapshotFolder, targetFolder )
endfunc








