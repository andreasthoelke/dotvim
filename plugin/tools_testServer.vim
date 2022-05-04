
" " ~/.config/nvim/notes/TestServer-TestClient.md#/#%20Test%20Server

" let testServer_filePath = './scratch/.testServer.ts'
" let testServer_template = '~/.config/nvim/notes/templates/.testServer.ts'

" return add( replLines, a:cmd_str )


" let lines = readfile( a:fileName, "\n" )


" func! repl_py#create_source_file( source_lines )
"   let filename = expand('%:p:h') . '/replSrc_' . expand('%:t')
"   call writefile( a:source_lines, filename )
"   return filename
" endfun


" if !filereadable( testServer_filePath )
"   call writefile( lines, testServer_filePath )

" let fl = readfile("foo", "b")
" call writefile(fl, "foocopy", "b")



" func! tools_testServer#setImportVar()
"   let [export, _, identif] = getline('.')

"   if     identif ~= 'schem'
"   elseif identif ~= 'resol'
"   elseif identif ~= 'query'
"   elseif identif ~= 'varia'
"   else
"   endif

" endfunc

" func! TSinitProject()
"   projectroot#guess()
"   getcwd()
" endfunc

" func! TsSetTypeDefMap()
"   let [export, _, identif; _] = split( getline('.') )
"   if export != 'export'
"     echo 'identifier needs to be exported'
"     return
"   endif
"   echo identif
"   return
"   let [export, _, identif] = getline('.')
"   let identifier =
"   let modulePath =
" endfunc

" func! TsSetTypeDef( identifier, module )
"   let importSta = "import { " . a:identifier . " as typeDef } from '" . module . "'"

" endfunc

" func! TsAbsModulePath()

" endfunc


" func! CurrentRelativeModulePath()
"   let path = expand('%:p:r')
"   let cwd = getcwd()
"   let relPath = substitute( path, cwd, '', '' )
"   return relPath
" endfunc
" echo CurrentModuleFilePath()



