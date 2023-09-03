

" ─   R list                                             ■

" A list for (primarily) filepaths as arguments
" Using the prefix leader "r"
" Alerts and filters duplicate strings (maintains a Set of strings). 

let g:Rlist = []

" Show the Filepath R list with fzf. use c-v/t/x to open a file or folderpath in dirvish
nnoremap <silent> <leader>rs :call Rlist_Highlight()<cr>:call Scala_showInFloat( [len(g:Rlist)] + g:Rlist )<cr>
nnoremap <silent> <leader>rr :call Rlist_Highlight()<cr>:echo "Rlist count: " len(g:Rlist)<cr>

nnoremap <silent> <leader>ra :set opfunc=Rlist_Add_op<cr>g@
nnoremap <silent> <leader>rd :set opfunc=Rlist_Delete_op<cr>g@

nnoremap <leader>rc :call Rlist_Clear()<cr>


func! Rlist_Add_op( _ )
  call Rlist_Add( getline( "'[", "']" ) )
endfunc

func! Rlist_Delete_op( _ )
  call Rlist_Delete( getline( "'[", "']" ) )
endfunc


func! Rlist_Add( listOfStr )
  let duplicates = FindMany  ( g:Rlist, a:listOfStr )
  let newItems   = FilterMany( a:listOfStr, g:Rlist )
  let g:Rlist += newItems
  call VirtualHighlightMatchedStrings( g:Rlist )
  if len( duplicates )
    echo "Added " . len( newItems ) . " new elem to Rlist. Total: " . len( g:Rlist ) . "\n" . "Rejected " . len(duplicates) . " duplicates: " . string( duplicates ) 
  else
    echo "Added " . len( a:listOfStr ) . " new elem to Rlist. Total: " . len( g:Rlist )
  endif
endfunc

func! Rlist_Delete( listOfStr )
  let foundElems    = FindMany  ( g:Rlist, a:listOfStr )
  let notFoundElems = FilterMany( a:listOfStr, g:Rlist )
  let filteredRlist = FilterMany( g:Rlist, a:listOfStr )
  let g:Rlist = filteredRlist
  call VirtualHighlightMatchedStrings( g:Rlist )
  echo "Deleted " . len(foundElems) . " elem from Rlist. Total: " . len( g:Rlist ) . ".\n" . (len(notFoundElems) ? len(notFoundElems) . " where not found: " . string( notFoundElems ) : "")
endfunc

func! Rlist_Highlight()
  call VirtualHighlightMatchedStrings( g:Rlist )
endfunc

func! Rlist_Clear()
  let g:Rlist = []
  call VirtualHighlightMatchedStrings( g:Rlist )
  echo "Rlist cleared"
endfunc

" ─^  R list                                             ▲




" ─   ApplyCmdTemplate                                   ■

" Given a list of files (e.g. from argv())
" and a command template string, e.g.:
" unzip -j SOURCE_PATH SUBJECT_FILES -d TARGET_PATH
let g:cmd_template_unzip1 = "unzip -j SOURCE_PATH SUBJECT_FILES -d TARGET_PATH"

" ApplyCmdTemplate will simple replace the 3 placeholder with the three args given.

" Example:
" join( argv() )
" ApplyCmdTemplate( g:cmd_template_unzip1, "temp.zip", "ab", argv() )
" returns:
" unzip -j temp.zip filepath1 filepath_with_glob2 fp3 -d ab

func! ApplyCmdTemplate( cmd_template, source_path, target_path, subject_files )
  let cmd = a:cmd_template
  let cmd = substitute( cmd, "SOURCE_PATH", a:source_path, '' )
  let cmd = substitute( cmd, "TARGET_PATH", a:target_path, '' )
  let cmd = substitute( cmd, "SUBJECT_FILES", join( a:subject_files ), '' )
  return cmd
endfunc

" Same as above but returns a list of command strings (e.g. to be executed in a shell script).
" Has the same effect in the case of unzip.
func! ApplyCmdTemplate_list( cmd_template, source_path, target_path, subject_files )
  return functional#map( {sj_file -> ApplyCmdTemplate( a:cmd_template, a:source_path, a:target_path, [sj_file] )}, a:subject_files )
endfunc

" ApplyCmdTemplate_list( g:cmd_template_unzip1, "temp.zip", "ab", argv() )
" unzip -j temp.zip filepath1 -d ab
" unzip -j temp.zip filepath_with_glob2 -d ab
" unzip -j temp.zip fp3 -d ab

" ─^  ApplyCmdTemplate                                   ▲















