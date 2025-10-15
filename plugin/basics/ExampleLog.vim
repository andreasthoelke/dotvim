

nnoremap <silent><leader>ces :call Example_SetStart()<cr>
nnoremap <silent><leader>cea :call Example_AddIdentif()<cr>
vnoremap <silent><leader>cea :call Example_AddVisSel()<cr>

" Use notes/ folder if it exists (symlink or directory)
if isdirectory("notes")
  let g:ExamplesPath = "notes/ExampleLog.md"
  " Auto-migrate existing ExampleLog.md from root to notes/
  if filereadable("ExampleLog.md") && !filereadable(g:ExamplesPath)
    call rename("ExampleLog.md", g:ExamplesPath)
    echo "Migrated ExampleLog.md to notes/"
  endif
else
  let g:ExamplesPath = "ExampleLog.md"
endif

func! Example_SetStart()
  if !filereadable( g:ExamplesPath )
    call writefile( [], g:ExamplesPath )
    echo "created ExampleLog.md"
    " return
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

  let identif = matchstr( getline( hostLn ), '\v(\s*)?(export\s|const\s|val|def)?(export|const|val|def)?\s\zs\i*\ze\W' )
  let identif = Sc_PackagePrefix() . Sc_ObjectPrefix(hostLn) . identif

  let lnStr = getline('.')
  let comment = matchstr( getline( hostLn -1 ), '\v(\s*)?(\/\/\s|\#\s)?\zs.*' )

  " if split( lnStr )[0] =~ '\v(#|//)'
  "   let comment = matchstr( getline( hostLn ), '\v(\s*)?(\/\/\s|\#\s)?\zs.*' )
  " else
  "   let comment = matchstr( getline( hostLn -1 ), '\v(\s*)?(\/\/\s|\#\s)?\zs.*' )
  " endif

  let linkPath = LinkPath_get()

  if len(identif)
    let linkLines = [identif . " " . linkPath]
  else
    let linkLines = [linkPath]
  endif

  if len(comment)
    call writefile( ['## ' . comment] + linkLines, g:ExamplesPath, "a" )
    echo 'Added line: ' . comment
  else
    call writefile( linkLines, g:ExamplesPath, "a" )
    echo 'Added line: ' . linkLines[0]
  endif
endfunc

" TODO fix: this repleats the selLines
func! Example_AddVisSel()
  let linkPath = LinkPath_get()
  let selLines = Get_visual_selection_lines()
  let textLines = selLines + [linkPath]
  call writefile( selLines, g:ExamplesPath, "a" )
endfunc



" ─^  Printer examples                                   ▲




