" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_scala#bufferMaps()

  " tools_js#eval_line( ln, formatted, edgeql_preview, useTLBindNameAsExpression )
  " nnoremap <silent><buffer> gel :call tools_js#eval_line( line('.'), v:true, v:false, v:false )<cr>
  " nnoremap <silent><buffer> gei :call tools_js#eval_line( line('.'), v:true, v:false, v:true )<cr>
  " nnoremap <silent><buffer> geL :call tools_js#eval_line( line('.'), v:true, v:true, v:false )<cr>
  " nnoremap <silent><buffer> geI :call tools_js#eval_line( line('.'), v:true, v:true, v:true )<cr>
  " nnoremap <silent><buffer> <leader>gel :call tools_js#eval_line( line('.'), v:false, v:false, v:false )<cr>
  " nnoremap <silent><buffer> <leader>gei :call tools_js#eval_line( line('.'), v:false, v:false, v:true )<cr>
  " nnoremap <silent><buffer> <leader>geL :call tools_js#eval_line( line('.'), v:false, v:true, v:false )<cr>
  " nnoremap <silent><buffer> <leader>geI :call tools_js#eval_line( line('.'), v:false, v:true, v:true )<cr>


  nnoremap <silent><buffer>         gei :call System_Float( JS_EvalParagIdentif_simple() )<cr>

  nnoremap <silent><buffer>         gew :call Scala_SetPrinterIdentif( v:false )<cr>
  nnoremap <silent><buffer>         geW :call Scala_SetPrinterIdentif( v:true )<cr>
  nnoremap <silent><buffer>         gep :call Scala_RunPrinter()<cr>
  nnoremap <silent><buffer>         geP :call Scala_RunPrinter_InTerm()<cr>

  " nnoremap <silent><buffer>         gei :call tools_js#eval_line( line('.'), v:true, v:false, v:false )<cr>
  nnoremap <silent><buffer> <leader>gei :call tools_js#eval_line( line('.'), v:false, v:false, v:false )<cr>

  nnoremap <silent><buffer>         gel :call JS_ComponentShow()<cr>

  nnoremap <silent><buffer> <c-p>         :call JS_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <leader><c-n> :call JS_MvEndOfBlock()<cr>
  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <c-n>         :call JS_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>


  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_scala()<cr>

  " nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

endfunc

" NOTE: deleted several JS motions and commands. i might want to copy
" and adapt these to scala at one point
" other motions: ~/.config/nvim/plugin/HsMotions.vim#/Just%20a%20new

" Process: import identif into runPrinter.ts, build --watch will update runPrinter.js
" - source file:   packages/app/src/mySourceFile.ts
" - printer:       packages/app/src/runPrinter.ts
" - module:        @org/app/mySourceFile
" - printer (run): packages/app/build/esm/runPrinter.js

func! Scala_SetPrinterIdentif( forEffect )

  let printerFilePath = 'src/main/scala/Main.scala'
  " is just the normal Main.scala for now

  let packageName = split( getline(1), ' ' )[1]
  " this will get e.g. 'azio.abbcc'. it's independent from the file/folder - scala handles this.

  let hostLn = searchpos( '^val\s', 'cnbW' )[0]
  let identif = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )

  call VirtualRadioLabel_lineNum( '«', hostLn )



  let importLine = "import " . packageName . "." . identif
  if a:forEffect
    let bindingLine = "val printVal = " . identif
  else
    let bindingLine = "val printVal = ZIO.succeed( " . identif . " )"
  endif

  let printerLines = readfile( printerFilePath, '\n' )
  let printerLines[0] = importLine
  let printerLines[1] = bindingLine

  call writefile( printerLines, printerFilePath )
endfunc

func! Scala_Identif_ParagExport()
  let hostLn = searchpos( '^val\s', 'cnbW' )[0]
  let hostDecName = matchstr( getline(hostLn ), '\v(val|def)\s\zs\i*\ze\W' )
  call VirtualRadioLabel_lineNum( '«', hostLn )
  return hostDecName
endfunc



func! TsPlus_RunPrinter()
  " node packages/app/build/esm/runPrinter.js
  let printerRunnablePath = 'packages/' . g:TsPlusPrinter_packageName . '/build/esm/runPrinter.js'
  echom printerRunnablePath
  " call System_Float( 'node ' . printerRunnablePath )
  " call System_Float( 'yarn build && node ' . printerRunnablePath )
  " NOTE: there needs to be a build script in packagage json with "tsc -b tsconfig.json"
  call System_Float( 'yarn build-all && node ' . printerRunnablePath )
endfunc

func! TsPlus_RunPrinter_InTerm()
  " node packages/app/build/esm/runPrinter.js
  let printerRunnablePath = 'packages/' . g:TsPlusPrinter_packageName . '/build/esm/runPrinter.js'
  " echom printerRunnablePath
  " call System_Float( 'node ' . printerRunnablePath )
  call TermOneShot( 'yarn build && node ' . printerRunnablePath )
endfunc










