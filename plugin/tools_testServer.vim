
" Todo:
" 0. copy all files at once from the template. including .env to the project root. and a *default test*. this will
" include empty/undefined schema, resolvers, query and variab. these are imported as a default to the Tester files.
" 1. This depands on the following installs:
" pnpm add -D -w lodash @types/lodash graphql-request apollo-server express express-graphql @types/express @graphql-yoga/node @pothos/core dotenv
" npm i -D lodash @types/lodash graphql-request apollo-server express express-graphql @types/express @graphql-yoga/node @pothos/core dotenv
" 2. client and server are reading from TESTSERVERNAME and TESTPORT from .env. This script could copy these lines
" into the .env file
" 
let g:T_ServerName = ''
" let g:T_ServerName = 'Yoga'
" let g:T_ServerName = 'Express'

" Notes/planning: ~/.config/nvim/notes/TestServer-TestClient.md#/#%20Test%20Server

nnoremap <silent> gsi :call T_DoSetImport()<cr>
nnoremap <silent> gwi :call T_DoSetPrinterIdentif()<cr>

nnoremap <silent> gsR :call T_ServerRefresh()<cr>:call T_Refetch('Client')<cr>
nnoremap <silent> gsr :call T_ServerRefresh()<cr>:echo 'Refeshed server'<cr>

nnoremap <silent> ger :call T_Refetch('Client')<cr>
" nnoremap <silent> ,ger :call T_DoSetImport()<cr>:T_Refetch('Client')<cr>
nnoremap <silent> gdr :call T_Refetch('GqlExec')<cr>
nnoremap <silent> ,gdr :call T_Refetch('GqlExecWithError')<cr>
nnoremap <silent> gwr :call T_Refetch('Printer')<cr>
nnoremap <silent> ges :call T_Refetch('ShowSchema')<cr>

nnoremap <silent> <leader>gss :call T_ServerStart()<cr>:echo 'Server started'<cr>
nnoremap <silent> ,gss :call T_ServerStartT()<cr>:echo 'Server started'<cr>
nnoremap <silent> <leader>gsS :call T_ServerStop()<cr>:echo 'Server stopped'<cr>

" ─   Set import variables                               ■
" Set the imports of scratch/.testServer.ts, testClient.ts and testPrinter.ts

" Set an exported identifier as a specific import variable in the testServer.ts file
func! T_DoSetImport()
  let [identif, modulePath] = T_ImportInfo()

  " 3. Which type of import var do we want to set?
  if     identif =~ 'sch' || identif =~ 'builder'
    " call T_SetServerTypeDef( identif, modulePath )
    call T_SetGqlExecTypeDef( identif, modulePath )
    call VirtualRadioLabel('▵s')
  elseif identif =~ 'resol'
    " call T_SetServerResolver( identif, modulePath )
    call T_SetGqlExecResolver( identif, modulePath )
    call VirtualRadioLabel('▵r')
  elseif identif =~ 'query'
    call T_SetClientQuery( identif, modulePath )
    call T_SetGqlExecQuery( identif, modulePath )
    call VirtualRadioLabel('▵q')
  elseif identif =~ 'varia'
    call T_SetClientVariables( identif, modulePath )
    call T_SetGqlExecVariables( identif, modulePath )
    call VirtualRadioLabel('▵v')
  elseif identif =~ 'contex'
    " Server context factory function
    call T_SetServerContext( identif, modulePath )
    call VirtualRadioLabel('▵c')
  else
    call T_SetPrinterIdentif( identif, modulePath )
  endif
  echo 'Set: ' . identif
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
  call T_EnsureTesterModuleFile( TesterPath, a:testerName )
  return TesterPath
endfunc

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
  if exists('g:T_ServerID') | echo 'T_Server is already running' | return | endif
  let g:T_ServerID = jobstart( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
endfunc

func! T_ServerStartT ()
  if exists('g:T_ServerID') | echo 'T_Server is already running' | return | endif
  exec "10new"
  let g:T_ServerID = termopen( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
endfunc

func! T_ServerStop ()
  if !exists('g:T_ServerID') | echo 'T_Server is not running' | return | endif
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



















