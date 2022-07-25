

" Note: Buffer maps init: ~/.config/nvim/plugin/HsSyntaxAdditions.vim#/func.%20JsSyntaxAdditions..
func! tools_rescript#bufferMaps()
  nnoremap <silent><buffer>         gei :call System_Float( RS_EvalParagIdentif_simple() )<cr>
  nnoremap <silent><buffer>        ,gei :call TermOneShot_FloatBuffer( RS_EvalParagIdentif() )<cr>
  nnoremap <silent><buffer> <leader>gei :call TermOneShot( RS_EvalParagIdentif() )<cr>

  nnoremap <silent><buffer>         gel :call RS_ComponentShow()<cr>

  " Todo: Vite Rescript plugin shows these errors in the browser
  nnoremap <silent><buffer>         geo :call RS_RescriptCompile()<cr>
  nnoremap <silent><buffer>         geO :call RS_RelayCompile()<cr>
  nnoremap <silent><buffer>         gef :RescriptFormat<cr>

  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_rescript()<cr>

  nnoremap <silent><buffer>       geh :silent call RescriptTypeHint()<cr>
  " vnoremap <silent><buffer>       geh :<c-u>silent call RescriptTypeHint()<cr>

  nnoremap <silent><buffer>            gdd :call RS_OpenDefinition(':e')<cr>
  nnoremap <silent><buffer> gdv :call RS_OpenDefinition(':vsplit')<cr>
  " nnoremap <silent><buffer> gdo :call FloatingBuffer(expand('%'))<CR>:RescriptJumpToDefinition<cr>
  nnoremap <silent><buffer> gdo :call FloatingBuffer(expand('%'))<CR>:call RS_OpenDefinition(':e')<cr>
  nnoremap <silent><buffer> gds :call RS_OpenDefinition(':split')<cr>
  nnoremap <silent><buffer> gdt :call RS_OpenDefinition(':tabnew')<cr>

  nnoremap <silent><buffer> <c-n> :call RS_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <c-p> :call RS_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>

endfunc

func! RS_OpenDefinition( cmd )
  let [file, start_line, start_col] = rescript#GetDefinitionLocation()
  " if !(type(file) == v:t_string)
  if type(file) != v:t_string
    echo "no result"
    return
  endif
  " echo [file, start_line, start_col]
  " return
  if len( file )
    exec a:cmd file
  endif
  call cursor(start_line, start_col)
endfunc


func! RS_RescriptCompile()
  let lines = systemlist( 'npx rescript' )
  let lines = RemoveTermCodes( lines )
  " Rescript uses "We've found a bug", but the "'" breaks syntax highlight
  let lines = SubstituteInLines( lines, "'", " " )
  silent let g:floatWin_win = FloatingSmallNew ( lines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


func! RS_RelayCompile()
  let lines = systemlist( 'npx rescript-relay-compiler' )
  let lines = RemoveTermCodes( lines )
  silent let g:floatWin_win = FloatingSmallNew ( lines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


func! RS_ComponentShow()
  if IndentLevel( line('.') ) == 1
    let identLineNum = line('.')
  else
    let identLineNum = searchpos( '^let\s', 'cnb' )[0]
  endif
  let identif = matchstr( getline( identLineNum ), '\vlet\s\zs\i*\ze\W' )
  if getline( identLineNum ) =~ '() =>'
    " This is (likely) a component with no args. it needs to be called to return an element to be rendered
    " let identif = identif . '()'
  endif
  let moduleName = expand('%:t:r')
  call RS_ComponentShow_UpdateFile( identif, moduleName )
endfunc

" File ./src/ShowRS.res is set to have the following lines:
" @genType @react.component
" let make = () => A_markupRS.make
" @genType let default = make
func! RS_ComponentShow_UpdateFile( identifier, module )
  let makeBinding = "let make = () => " . a:module . "\." . a:identifier
  let lines = ["@genType @react.component", makeBinding, "@genType let default = make"]
  " let folderPath = expand('%:p:h')
  let filePath = getcwd() . '/src/ShowRS.res'
  " Overwrite the Show.res file
  call writefile( lines, filePath)
endfunc


func! RS_TopLevBindingForw()
  normal! }
  call search( '\v^(module|let)\s', 'W' )
endfunc

func! RS_TopLevBindingBackw()
  call search( '\v^(module|let)\s', 'bW' )
  normal! {
  call search( '\v^(module|let)\s', 'W' )
endfunc


func! RS_EvalParagIdentif_simple()
  if IndentLevel( line('.') ) == 1
    let identLineNum = line('.')
  else
    " let identLineNum = searchpos( '^let\s\(e\d_\)\@!', 'cnb' )[0]
    let identLineNum = searchpos( '^let\s', 'cnb' )[0]
  endif
  let identif = matchstr( getline( identLineNum ), '\vlet\s\zs\i*\ze\W' )
  " echo identLineNum identif
  " return
  let filePath = expand('%:p:h')

  let _compl_ = system( 'npm run build' )
  return RS_NodeCall( identif )
endfunc


func! RS_EvalParagIdentif()"  ■
  if IndentLevel( line('.') ) == 1
    let identLineNum = line('.')
  else
    " let identLineNum = searchpos( '^let\s\(e\d_\)\@!', 'cnb' )[0]
    let identLineNum = searchpos( '^let\s', 'cnb' )[0]
  endif
  " let identif = split( getline( identLineNum) )[1]
  let identif = matchstr( getline( identLineNum ), '\vlet\s\zs\i*\ze\W' )
  let filePath = expand('%:p:h')
  " echo matchstr( getline( '.' ), '\vlet\s\zs\i*\ze\W' )
  " This rescript code will always print/side effect. i can only(?) prevent this by commenting all test lines but the current one
  " let someLet2 = () => {
  "   Js.log( "hi 8 there" )
  "   42
  " }
  " let e1_someLet2 = someLet2()

  " Temp comment out test lines (they are of the form e_12, use a_12 to keep them while evaluating)
  " Issue/Todo: File updates issue an Lsp user prompt: "do you want to rebuild?" Therefore modifying the buffer
  " comment lines (insert "// ") when a pattern matches
  " Substitute example: ~/.config/nvim/help.md#/###%20Substitute%20in
  " let [oLine, oCol] = getpos('.')[1:2]
  let l:maintainedCursorPos = getpos('.')
  let l:save_view = winsaveview()
  silent exec '%substitute/^\zelet\se\d_/\/\/ /'
  call setpos('.', l:maintainedCursorPos)
  " uncomment current line
  silent exec '.substitute/\/\/\s\zelet\se\d_//ge'
  silent exec 'write'

  " Compile and write JS file
  let _compl_ = system( 'npm run build' )
  " call rescript#Build()

  " uncomment all testlines. this should revert the command above (for user comments I use /*  */)
  silent exec '%substitute/\/\/\s\zelet\se\d_//ge'
  silent normal uu
  call setpos('.', l:maintainedCursorPos)
  call winrestview(l:save_view)
  redraw " so the float win will use the original cursor pos

  " This doesn't work well because rescript replaces variables names in case of static calls
  " call RS_ModFile_CommentOutTestLines( identif )

  return RS_NodeCall( identif )
  " call RS_ModFile_CommentInTestLines( filePath )
endfunc"  ▲
" in .res buffer: call append('.', RS_EvalParagIdentif() )


func! RS_NodeCall( identif )
  " let moduleName = expand('%:t:r')
  " let filePath = expand('%:p')
  " Note: expand('%:r') is returning the absolute path initially when opened from dirvish!
  " let filePath_compiledJS = getcwd() . '/' . expand('%:r') . '.bs.js'
  let projRelativeFilenameRoot = fnamemodify( CurrentRelativeFilePath(), ':r' )
  " let filePath_compiledJS = getcwd() . projRelativeFilenameRoot . '.bs.js'
  let rescriptCompileToFileExtension = JsonConfKey( 'bsconfig.json', 'suffix' )
  let filePath_compiledJS = getcwd() . projRelativeFilenameRoot . rescriptCompileToFileExtension


  let lines = []
  call add( lines, "function isPromise(p) { if (typeof p === \"object\" && typeof p.then === \"function\") { return true; } return false; }; " )

  call add( lines, "function execIdentif (symb) { " )
  call add( lines,    "if     (typeof symb == \"function\" ) { console.log( symb() ) " )
  call add( lines,    "} else if (isPromise(symb))              { symb.then( v => console.log( v ) ) " )
  call add( lines,    "} else                                  { console.log( symb ) }; " )
  call add( lines, "}; " )

  " call add( lines, 'const modu = require("' . filePath_compiledJS . '"); execIdentif(modu.' . a:identif . ')' )
  call add( lines, 'import("' . filePath_compiledJS . '").then(m => execIdentif(m.' . a:identif . '))' )

  return "node -e '" . join( lines ) . "'"

  " let js_code_helperFn = "function execIdentif (symb) { if (typeof symb == \"function\" ) { console.log( symb() ) } else { console.log( symb ) } }; "

  " node -e "import('<path>').then(m => console.log(m.abc1))"
  " let js_code_statement = 'import("' . filePath . '").then(m => console.log(m.' . a:identif . '))'
  " let js_code_statement = 'import("' . filePath . '").then(m => console.log(m.' . a:identif . '()' . '))'

  " let js_code_importCall = 'import("' . filePath_compiledJS . '").then(m => execIdentif(m.' . a:identif . '))'

  " return "node -e '" . js_code_helperFn . js_code_importCall . "'"
  " return "npx ts-node -T  -e '" . js_code_helperFn . js_code_importCall . "'"
endfunc
" let @" = RS_NodeCall( expand('<cword>') )


func! RS_ModJsonFile()

endfunc


" Unused functions ■
func! RS_ModFile_CommentOutTestLines( identif )
  " let filePath_compiledJS = getcwd() . '/' . expand('%:r') . '.bs.js'
  let projRelativeFilenameRoot = fnamemodify( CurrentRelativeFilePath(), ':r' )
  let filePath_compiledJS = getcwd() . projRelativeFilenameRoot . '.bs.js'
  let bufferLines = readfile( filePath_compiledJS, '\n' )
  " let modLines = functional#map( {lineStr -> substitute( lineStr, '\zevar\se\d_', '// ', 'g' )}, bufferLines )
  let modLines = []
  for lineStr in bufferLines
    if !(lineStr =~ a:identif)
      let outStr = substitute( lineStr, '\zevar\se\d_', '// ', 'g' )
      let outStr = substitute( lineStr, '\zeexports\.e\d_', '// ', 'g' )
    else
      let outStr = lineStr
    endif
    call add( modLines, lineStr )
  endfor
  call writefile( modLines, filePath_compiledJS )
endfunc
" call RS_ModFile_CommentOutTestLines( expand('%:p') )

func! RS_ModFile_CommentInTestLines( filePath )
  let bufferLines = readfile( a:filePath, '\n' )
  let modLines = functional#map( {lineStr -> substitute( lineStr, '//\s\zelet\se\d_', '', 'g' )}, bufferLines )
  call writefile( modLines, a:filePath )
endfunc
" call RS_ModFile_CommentInTestLines( expand('%:p') ) ▲




