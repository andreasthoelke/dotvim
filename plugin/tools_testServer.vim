
" Notes/planning: ~/.config/nvim/notes/TestServer-TestClient.md#/#%20Test%20Server

nnoremap <silent> gsi :call T_DoSetImport()<cr>
nnoremap <silent> gwi :call T_DoSetPrinterIdentif()<cr>

nnoremap <silent> gsr :call T_ServerRefresh()<cr>:call T_ClientRefetch()<cr>
nnoremap <silent> gsR :call T_ServerRefresh()<cr>:echo 'Refeshed server'<cr>

nnoremap <silent> ger :call T_ClientRefetch()<cr>
nnoremap <silent> gwr :call T_PrinterRerun()<cr>
nnoremap <silent> dr :call T_PrinterRerun()<cr>

nnoremap <silent> <leader>gss :call T_ServerStart()<cr>:echo 'Server started'<cr>
nnoremap <silent> <leader>gsS :call T_ServerStop()<cr>:echo 'Server stopped'<cr>

" ─   Set import variables                               ■
" Set the imports of scratch/.testServer.ts, testClient.ts and testPrinter.ts

" Set an exported identifier as a specific import variable in the testServer.ts file
func! T_DoSetImport()
  let [identif, modulePath] = T_ImportInfo()

  " 3. Which type of import var do we want to set?
  if     identif =~ 'tydef'
    call T_SetServerTypeDef( identif, modulePath )
  elseif identif =~ 'resol'
    call T_SetServerResolver( identif, modulePath )
  elseif identif =~ 'query'
    call T_SetClientQuery( identif, modulePath )
  elseif identif =~ 'varia'
    call T_SetClientVariables( identif, modulePath )
  else
    call T_SetPrinterIdentif( identif, modulePath )
  endif
  echo 'Set: ' . identif
endfunc

func! T_ImportInfo()
  " 1. Get the exported identifier
  let [export, _, identif; _] = split( getline('.') )
  if export != 'export' | echo 'identifier needs to be exported' | return | endif
  " 2. Get the module path
  let modulePath = T_AbsModulePath()
  return [identif, modulePath]
endfunc

" Server:
func! T_SetServerTypeDef( identifier, module )
  let importStm = "import { " . a:identifier . " as typeDefs } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Server')
  " Overwrite/set the imported var
  let TesterLines[0] = importStm
  call T_WriteTesterFile( TesterLines, 'Server' )
endfunc

func! T_SetServerResolver( identifier, module )
  let importStm = "import { " . a:identifier . " as resolvers } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Server')
  " Overwrite/set the imported var
  let TesterLines[1] = importStm
  call T_WriteTesterFile( TesterLines, 'Server')
endfunc


" Client:
func! T_SetClientQuery( identifier, module )
  let importStm = "import { " . a:identifier . " as query } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Client')
  " Overwrite/set the imported var
  let TesterLines[0] = importStm
  call T_WriteTesterFile( TesterLines, 'Client' )
endfunc

func! T_SetClientVariables( identifier, module )
  let importStm = "import { " . a:identifier . " as variables } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Client')
  " Overwrite/set the imported var
  let TesterLines[1] = importStm
  call T_WriteTesterFile( TesterLines, 'Client' )
endfunc

" Printer:
func! T_SetPrinterIdentif( identifier, module )
  let importStm = "import { " . a:identifier . " as testIdentif } from '" . a:module . "'"
  let TesterLines = T_ReadTesterFileLines('Printer')
  " Overwrite/set the imported var
  let TesterLines[0] = importStm
  call T_WriteTesterFile( TesterLines, 'Printer' )
  call T_PrinterRerun()
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
  if !filereadable( TesterPath )
    " There's no testServer.ts file yet in this project - copy a template
    let templateFile = '~/.config/nvim/notes/templates/.test' . a:testerName . '.ts'
    let templateFile = fnamemodify( templateFile, ':p')
    let lines = readfile( templateFile, '\n' )
    call writefile(lines, TesterPath)
  endif
  return readfile( TesterPath, '\n' )
endfunc

func! T_TesterFilePath( testerName )
  return getcwd() . '/scratch/.test' . a:testerName . '.ts'
endfunc

func! T_TesterTerminalCommand( testerName )
  return 'npx ts-node -T ' . T_TesterFilePath( a:testerName )
endfunc

" The current files' module path
func! T_AbsModulePath()
  " This is based on the convention of having include: "src" in tsconfig
  return '..' . CurrentRelativeModulePath()
endfunc

func! CurrentRelativeModulePath()
  let path = expand('%:p:r')
  let cwd = getcwd()
  let relPath = substitute( path, cwd, '', '' )
  return relPath
endfunc
" echo CurrentRelativeModulePath()


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
  " exec "10new"
  " let g:T_ServerID = termopen( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
  let g:T_ServerID = jobstart( T_TesterTerminalCommand('Server'), g:T_ServerCallbacks )
endfunc

func! T_ServerStop ()
  if !exists('g:T_ServerID') | echo 'T_Server is not running' | return | endif
  call jobstop( g:T_ServerID )
  unlet g:T_ServerID
  " echo 'T_Server stopped'
endfunc


func! T_ServerMainCallback (job_id, data, event)
  " echo a:data
endfunc

func! T_ServerErrorCallback (job_id, data, event)
  echo a:data
endfunc

let g:T_ServerCallbacks = {
      \ 'on_stdout': function('T_ServerMainCallback'),
      \ 'on_stderr': function('T_ServerErrorCallback'),
      \ 'on_exit': function('T_ServerMainCallback')
      \ }


" ─^  Manage long running server process                 ▲



func! T_ClientRefetch()
  let resLines = systemlist( T_TesterTerminalCommand('Client') )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


func! T_PrinterRerun()
  let resLines = systemlist( T_TesterTerminalCommand('Printer') )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


















