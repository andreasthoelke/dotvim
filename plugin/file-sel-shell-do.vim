

" ─   R list                                             ■

" A list for (primarily) filepaths as arguments
" using the prefix leader "r"

let Rlist = []

" Show the Filepath R list with fzf. use c-v/t/x to open a file or folderpath in dirvish
nnoremap <silent> <leader>rs :Rlist<cr>

command! -bang Rlist call fzf#run(fzf#wrap('args', {'source': Rlist}, <bang>0))

nnoremap <silent> <leader>v :set opfunc=ArglistToggle_op<cr>g@
" l aa  - toggels the vis-selection of lines
vnoremap <silent> <leader>vv :<c-u>call Arglist_toggleItems( getline("'<", "'>") )<cr>

" clear the list
nnoremap <leader>ac :call ArglistClear()<cr>


func! FPList_Add_op( _ )
  call FPList_Add( getline( "'[", "']" ) )
endfunc

func! FPList_Delete_op( _ )
  call FPList_Delete( getline( "'[", "']" ) )
endfunc


" Remove a string from the list if already present, add it otherwise.
func! FPList_Add( listOfStr )

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















