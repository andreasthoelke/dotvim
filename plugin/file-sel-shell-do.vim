



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















