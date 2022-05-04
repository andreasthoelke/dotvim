
" Notes/planning: ~/.config/nvim/notes/TestServer-TestClient.md#/#%20Test%20Server


nnoremap <silent> <leader>gss :call T_ServerStart()<cr>:echo 'Server started'<cr>
nnoremap <silent> <leader>gsS :call T_ServerStop()<cr>:echo 'Server stopped'<cr>
nnoremap <silent> gsi :call T_DoSetImport()<cr>
nnoremap <silent> gsr :call T_ServerRefresh()<cr>:echo 'hi'<cr>
nnoremap <silent> gsR :call T_ServerRefresh()<cr>:echo 'Refeshed server'<cr>


" ─   Set server import variables                        ■
" Set the typeDef and resolver imports of scratch/.testServer.ts

" Set an exported identifier as a specific import variable in the testServer.ts file
func! T_DoSetImport()
  " 1. Get the exported identifier
  let [export, _, identif; _] = split( getline('.') )
  if export != 'export' | echo 'identifier needs to be exported' | return | endif
  " 2. Get the module path
  let modulePath = T_AbsModulePath()

  " 3. Which type of import var do we want to set?
  if     identif =~ 'tydef'
    call T_SetTypeDef( identif, modulePath )
  elseif identif =~ 'resol'
    call T_SetResolver( identif, modulePath )
  elseif identif =~ 'query'
  elseif identif =~ 'varia'
  else
  endif
  echo 'Set: ' . identif
endfunc

func! T_SetTypeDef( identifier, module )
  let importStm = "import { " . a:identifier . " as typeDefs } from '" . a:module . "'"
  let serverLines = T_ReadServerFileLines()
  " Overwrite/set the imported typeDef in line 0
  let serverLines[0] = importStm
  call T_WriteServerFile( serverLines )
endfunc

func! T_SetResolver( identifier, module )
  let importStm = "import { " . a:identifier . " as resolvers } from '" . a:module . "'"
  let serverLines = T_ReadServerFileLines()
  " Overwrite/set the imported typeDef in line 0
  let serverLines[1] = importStm
  call T_WriteServerFile( serverLines )
endfunc

" ─^  Set server import variables                        ▲



" ─   File operations                                    ■

func! T_WriteServerFile( lines )
  let serverPath = T_ServerFilePath()
  call writefile(a:lines, serverPath)
endfunc

func! T_ReadServerFileLines()
  let serverPath = T_ServerFilePath()
  if !filereadable( serverPath )
    " There's no testServer.ts file yet in this project - copy a template
    let templateFile = '~/.config/nvim/notes/templates/.testServer.ts'
    let templateFile = fnamemodify( templateFile, ':p')
    let lines = readfile( templateFile, '\n' )
    call writefile(lines, serverPath)
  endif
  return readfile( serverPath, '\n' )
endfunc

func! T_ServerFilePath()
  return getcwd() . '/scratch/.testServer.ts'
endfunc

func! T_ServerStartTerminalCommand()
  return 'npx ts-node -T ' . T_ServerFilePath()
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
  " let g:T_ServerID = termopen( T_ServerStartTerminalCommand(), g:T_ServerCallbacks )
  let g:T_ServerID = jobstart( T_ServerStartTerminalCommand(), g:T_ServerCallbacks )
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
  " echo a:data
endfunc

let g:T_ServerCallbacks = {
      \ 'on_stdout': function('T_ServerMainCallback'),
      \ 'on_stderr': function('T_ServerErrorCallback'),
      \ 'on_exit': function('T_ServerMainCallback')
      \ }


" ─^  Manage long running server process                 ▲




