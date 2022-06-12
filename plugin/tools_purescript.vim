

" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_purescript#bufferMaps()
  nnoremap <silent><buffer>         gei :call System_Float( PS_EvalParagIdentif() )<cr>
  nnoremap <silent><buffer>        ,gei :call TermOneShot_FloatBuffer( PS_EvalParagIdentif() )<cr>
  nnoremap <silent><buffer> <leader>gei :call TermOneShot( PS_EvalParagIdentif() )<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_hs()<cr>
  nnoremap <silent><buffer> <leader>es :call Stubs_ExpandATypeSign()<cr>
  nnoremap <silent><buffer> <leader>eb :call Stubs_ExpandTermLevelFromTypeSign()<cr>
endfunc


func! PS_EvalParagIdentif()
  if IndentLevel( line('.') ) == 1
    let identLineNum = line('.')
  else
    let identLineNum = TopLevBackwLine()
  endif
  let identif = split( getline( identLineNum) )[0]
  let filePath = expand('%:p')

  " Temporarily export the identifier (alternatively i could write the identifier namme to the export clause of the output/index.js file _)
  let origHeaderLine = getline( 1 )
  let moduleName = split( origHeaderLine )[1] " this cover nester namespaces like Data.List (?) let moduleName = expand('%:t:r')
  let newHeaderLine = PS_GetUpdatedHeaderLine( identif, origHeaderLine, moduleName )
  if len( newHeaderLine )
    call PS_OverwriteLineInFile( 1, newHeaderLine, filePath )
  endif

  " Update the js sources in ./output
  let _compl_ = system( 'npx spago build' )

  if len( newHeaderLine )
    " Rollback if newHeaderLine was set
    call PS_OverwriteLineInFile( 1, origHeaderLine, filePath )
  endif

  return PS_Module_NodeCall( identif, moduleName )
endfunc
" in .purs buffer: call append('.', PS_EvalParagIdentif() )
" node -e 'function execIdentif (symb) { if (typeof symb == "function" ) { console.log( symb() ) } else { console.log( symb ) } }; import("/Users/at/Documents/PS/setup-tests/a_pss/output/SyncEffect/index.js").then(m => execIdentif(m.fiberTest))'


func! PS_Module_NodeCall( identif, moduleName )
  let filePath = PS_ModuleOutputPath( a:moduleName )

  let js_code_helperFn = "function execIdentif (symb) { if (typeof symb == \"function\" ) { console.log( symb() ) } else { console.log( symb ) } }; "

  " node -e "import('<path>').then(m => console.log(m.abc1))"
  " let js_code_statement = 'import("' . filePath . '").then(m => console.log(m.' . a:identif . '))'
  " let js_code_statement = 'import("' . filePath . '").then(m => console.log(m.' . a:identif . '()' . '))'

  let js_code_importCall = 'import("' . filePath . '").then(m => execIdentif(m.' . a:identif . '))'

  return "node -e '" . js_code_helperFn . js_code_importCall . "'"
endfunc
" echo PS_Module_NodeCall()


func! PS_ModuleOutputPath( moduleName )
  return getcwd() . '/output/' . a:moduleName . '/index.js'
endfunc


func! PS_GetUpdatedHeaderLine( newIdentif, origHeaderline, moduleName )
  " Example line:
  " module Ch5 (test, abc1, abc) where
  let exportList = split( a:origHeaderline, '\v(,|\(|\))' )[1:-2]
  let exportList = TrimListOfStr( exportList )
  if index( exportList, a:newIdentif ) != -1
    return "" " found the identif in export list: don't overwrite the headerline
  endif
  let exportList = add( exportList, a:newIdentif )
  return 'module ' . a:moduleName . ' (' . join( exportList, ', '  ) . ') where'
endfunc

" echo !index( ['aa', 'bb'], 'aa' )

func! PS_OverwriteLineInFile( lineIdx, newLineStr, filePath )
  let lines = readfile( a:filePath, '\n' )
  let lines[ a:lineIdx -1 ] = a:newLineStr
  call writefile( lines, a:filePath )
endfunc













