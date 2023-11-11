

" ─   R list                                             ■

" A list for (primarily) filepaths as arguments
" Alerts and filters duplicate strings (maintains a Set of strings). 

" Show Rlist in float-win. Note you can delete items, edit items, write new items and refresh the Rlist highlight in the float-win!.
nnoremap <silent> <leader>rs :call Rlist_Show()<cr>
nnoremap <silent> <leader>rr :call Rlist_Highlight()<cr>:echo "Rlist count: " len(Rlist())<cr>

" Add or delete a range of lines. Will alert & filter for dublicate adds or redundant deletes.
nnoremap <silent> <leader>ra :set opfunc=Rlist_Add_op<cr>g@
nnoremap <silent> <leader>rd :set opfunc=Rlist_Delete_op<cr>g@

nnoremap <leader>rc :call Rlist_Clear()<cr>




func! Rlist_set( list )
  call writefile( a:list, Rlist_path() )
endfunc



func! Rlist_Show()
  call Rlist_Highlight()
  " call Scala_showInFloat( [len(Rlist())] + Rlist() )
  " call FloatingBuffer( Rlist_path() )
  call Path_Float( Rlist_path() )
  " to test!
  echo "Rlist count: " len(Rlist())
endfunc


func! Rlist_Add_op( _ )
  call Rlist_Add( getline( "'[", "']" ) )
endfunc

func! Rlist_Delete_op( _ )
  call Rlist_Delete( getline( "'[", "']" ) )
endfunc


func! Rlist_Add( listOfStr )
  let currentRlist = Rlist_get()
  let duplicates = FindMany  ( currentRlist, a:listOfStr )
  let newItems   = FilterMany( a:listOfStr, currentRlist )
  let newRlist = currentRlist + newItems
  call Rlist_set( newRlist )
  call VirtualHighlightMatchedStrings( newRlist )
  if len( duplicates )
    echo "Added " . len( newItems ) . " new elem to Rlist. Total: " . len( newRlist ) . "\n" . "Rejected " . len(duplicates) . " duplicates: " . string( duplicates ) 
  else
    echo "Added " . len( a:listOfStr ) . " new elem to Rlist. Total: " . len( newRlist )
  endif
endfunc

func! Rlist_Delete( listOfStr )
  let currentRlist = Rlist_get()
  let foundElems    = FindMany  ( currentRlist, a:listOfStr )
  let notFoundElems = FilterMany( a:listOfStr, currentRlist )
  let filteredRlist = FilterMany( currentRlist, a:listOfStr )
  call Rlist_set( filteredRlist )
  call VirtualHighlightMatchedStrings( filteredRlist )
  echo "Deleted " . len(foundElems) . " elem from Rlist. Total: " . len( filteredRlist ) . ".\n" . (len(notFoundElems) ? len(notFoundElems) . " where not found: " . string( notFoundElems ) : "")
endfunc

func! Rlist_Highlight()
  call VirtualHighlightMatchedStrings( Rlist() )
endfunc

func! Rlist_Clear()
  let Rlist() = []
  call VirtualHighlightMatchedStrings( Rlist() )
  echo "Rlist cleared"
endfunc

" ─^  R list                                             ▲


" ─   INITIALIZING                                       ■
" RunList uses these three files:
func! Rsh_path()
  return g:Rlist_cwd . "r"
endfunc

func! Rlist_path()
  return g:Rlist_cwd . "rlist"
endfunc

func! Rcmds_path()
  return g:Rlist_cwd . "r_cmds.sh"
endfunc

" The files can be initialized with ll ri
nnoremap <silent> <leader><leader>ri :call R_init()<cr>
func! R_init()
  let msg = 'Resetting ' . Rsh_path() . "?"
  let dres = confirm( msg, "&Yes\n&Cancel", 2 )
  if !(dres == 1)
    redraw
    echo 'canceled'
  endif
  let lns = range(0,20)->map({_,__->""})
  let lns[0] = '#!/bin/zsh'
  let lns[1] = "r_source=''"
  let lns[2] = "r_dest=''"
  let lns[3] = "r_opt=''"
  let lns[4] = "r_el=$1"
  let lns[10] = '# <<== line 11'
  let lns[11] = "echo $r_el"  " NOTE: List item 11 is buffer line 12 (1 based).
  call system( "mkdir " . g:Rlist_cwd )
  call system( "cp /Users/at/.config/nvim/rlist/r_cmds.sh " . Rcmds_path() )
  call system( "touch " . Rlist_path() )
  call writefile( lns, Rsh_path() )
  call system( "chmod +x " . Rsh_path() )
endfunc

" By default the rlist folder is global (shared across vim instances and projects):
let g:Rlist_cwd = 'r/_/'

" But you can initialize a local rlist using ll rI:
nnoremap <silent> <leader><leader>rI :let g:Rlist_cwd = "rlist/"<cr>:call R_init()<cr>

" Or you can l ss on the following line to keep a use case specific script.
" let g:Rlist_cwd = 'rlist_feature_version/'

func! Rlist_cwd()
  return g:Rlist_cwd
endfunc

func! Rlist_cwd_set( path )
  let g:Rlist_cwd = a:path
endfunc


" ─^  INITIALIZING                                       ▲



" ─   PREVIEW & RUN r.sh                                ──

" l rei/I will execute the (static) runner code (e.i. "cat rlist/r_list | (while read arg; do rlist/r.sh $arg; done))
" in a new term or via float( system( cmd ) )

" The runner will call r.sh (in it's current state): /Users/at/.config/nvim/rlist/r.sh
" n-times with each val in: /Users/at/.config/nvim/rlist/r_list

" You can quickly preview (and edit) r.sh using l res
nnoremap <silent> <leader>rep :call Rsh_show()<cr>
func! Rsh_show()
  call FloatingBuffer( Rsh_path() )
endfunc

" You can also show the list of the actual commands (including the literal (iterated) argument values)
" that would be executed once you issue l rei
nnoremap <silent> <leader>reP :call Rsh_preview()<cr>
func! Rsh_preview()
  let cmd = RcmdString_get()
  if cmd =~ '"'
    if cmd =~ "'"
      echo "Found literal strings in the command. This isn't compatible with this simple preview feature."
      return
    endif
    call RcmdString_set( "echo '" . cmd . "'" )
  else
    " Will usually use double quotes
    call RcmdString_set( 'echo "' . cmd . '"' )
  endif
  call Rlist_run()
  call RcmdString_set( cmd )
endfunc

nnoremap <silent> <leader>rei :call Rlist_run()<cr>
nnoremap <silent> <leader>reI :call Rlist_runTerm()<cr>

func! Rlist_run()
  let cmd = Rlist_cmdrunnercode()
  let resLines = systemlist( cmd )
  call Scala_showInFloat( resLines )
endfunc

func! Rlist_runTerm()
  let cmd = Rlist_cmdrunnercode()
  let resLines = systemlist( cmd )
  call TermOneShot( cmd )
endfunc


" ─   SET A COMMAND STRING                              ──
" l rew will copy getline('.'), overriding (magic!) line 11 in r.sh: /Users/at/.config/nvim/rlist/r.sh|11
" The cmd-string can be any shell command, (e.g. "echo 'hi'").
" The cmd-string can use 3 (magic) shell variables e.g. "echo $r_source $r_dest $r_el"
" Only $r_el will iterate throuch the lines of the r_list file. So "touch $r_el" would be useful.
" Try the following (uncommented) line:
" echo 'test1' $r_el
" An example that also uses the static $r_source and $r_dest variables:
" unzip -j $r_source $r_el -d $r_dest

nnoremap <silent> <leader>rew :call RcmdString_set( getline('.') )<cr>
func! RcmdString_set( cmd )
  let lns = readfile( Rsh_path() )
  let lns[11] = a:cmd
  call writefile( lns, Rsh_path() )
  echo "Set: " . a:cmd . " => " . Rsh_path()
endfunc

func! RcmdString_get()
  let lns = readfile( Rsh_path() )
  return lns[11]
endfunc

nnoremap <silent> <leader>rec :call Rcmds_selection()<cr>
func! Rcmds_selection()
  call FloatingBuffer( Rcmds_path() )
  call search( '\V\^'.escape( RcmdString_get(), '\').'\$', 'cw' )
  echo "Current cmd:" RcmdString_get()
endfunc


" ─   SET r_source AND r_dest                            ■

" l rS/D/O allow to set the r_source, r_dest, r_opt static vars from the clipboard
" The clipboard content will be single-quoted. Thus numbers, arrays might not work.

nnoremap <silent> <leader>rS :call R_source_set( @* )<cr>
func! R_source_set( val )
  let lns = readfile( Rsh_path() )
  let lns[1] = "r_source='" . a:val . "'"
  call writefile( lns, Rsh_path() )
  echo "Set: " . "r_source=" . a:val . " => " . Rsh_path()
endfunc

nnoremap <silent> <leader>rD :call R_dest_set( @* )<cr>
func! R_dest_set( val )
  let lns = readfile( Rsh_path() )
  let lns[2] = "r_dest='" . a:val . "'"
  call writefile( lns, Rsh_path() )
  echo "Set: " . "r_dest=" . a:val . " => " . Rsh_path()
endfunc

nnoremap <silent> <leader>rO :call R_opt_set( @* )<cr>
func! R_opt_set( val )
  let lns = readfile( Rsh_path() )
  let lns[3] = "r_opt='" . a:val . "'"
  call writefile( lns, Rsh_path() )
  echo "Set: " . "r_opt=" . a:val . " => " . Rsh_path()
endfunc



" ─^  SET r_source AND r_dest                            ▲




" The runner code looks like this:
  " cat rlist/r_list | (while read arg; do rlist/r.sh $arg; done)
" It feeds r_els into r.sh using a subshell just to call r.sh. r.sh might echo output which an extended runner could use like:
" cat rlist/args.txt | (while read arg; do rlist/r.sh $arg; done) | xargs -n 2

" Below creates the runner code from just the path to the r_list and r.sh.
" just feeds r_els into the r.sh script
func! Rlist_cmdrunnercode()
  " return "cat " . g:Rlist_cwd . "r_list " . "| (while read arg; do " . g:Rlist_cwd . "r.sh" . " $arg; done)"
  return g:Rlist_cwd . "r"
endfunc
" Rlist_cmdrunnercode()




" ─   Exec range in buffer                              ──


" chmod +x /Users/at/.config/nvim/r_buffer_range.sh
" #!/bin/zsh
" system("/Users/at/.config/nvim/r_buffer_range.sh")



nnoremap <silent> <leader>re :set opfunc=Rbuffer_exec_op<cr>g@


func! Rbuffer_exec_op( _ )
   call Rbuffer_exec( getline( "'[", "']" ) )
endfunc

let g:Rbuffer_path = "/Users/at/.config/nvim/r_buffer_range.sh"

func! Rbuffer_exec( lines )
  call writefile( ["#!/bin/zsh", ""] + a:lines, g:Rbuffer_path )
 echo "Running terminal command .."
 call T_DelayedCmd( "echo ''", 2000 )
 call System_Float( g:Rbuffer_path )
endfunc

" echo ab
" echo cd

nnoremap <silent> <leader>ree :call Rbuffer_exec_again()<cr>
func! Rbuffer_exec_again()
 echo "Running terminal command .."
 call T_DelayedCmd( "echo ''", 2000 )
 call System_Float( g:Rbuffer_path )
endfunc

nnoremap <silent> <leader>res :call Rsh_show()<cr>
func! Rsh_show()
  call FloatingBuffer( g:Rbuffer_path )
endfunc





" not used for now
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

func! InterpolCmdTemplate( cmd_template )
  let cmd = a:cmd_template
  let cmd = substitute( cmd, "SOURCE_PATH", a:source_path, '' )
  let cmd = substitute( cmd, "TARGET_PATH", a:target_path, '' )
  let cmd = substitute( cmd, "SUBJECT_FILES", join( a:subject_files ), '' )
  return cmd
endfunc

" Same as above but returns a list of command strings (e.g. to be executed in a shell script).
" Has the same effect in the case of unzip.
func! InterpolCmdTemplate_list( cmd_template, source_path, target_path, subject_files )
  return functional#map( {sj_file -> InterpolCmdTemplate( a:cmd_template, a:source_path, a:target_path, [sj_file] )}, a:subject_files )
endfunc

" InterpolCmdTemplate_list( g:cmd_template_unzip1, "temp.zip", "ab", argv() )
" unzip -j temp.zip filepath1 -d ab
" unzip -j temp.zip filepath_with_glob2 -d ab
" unzip -j temp.zip fp3 -d ab


nnoremap <silent> <leader>rp :call Review_ThenRun_CmdTemplToRlist_args()<cr>

func! Review_ThenRun_CmdTemplToRlist_args()
  let rlist_quoted = copy( ...Rlist()->map( {_,str -> "'" . str . "'"} )
  let cmd = InterpolCmdTemplate( g:cmd_template_unzip1, g:R_SOURCE_PATH, g:R_TARGET_PATH, rlist_quoted )
  call Scala_showInFloat( ['Cmd:', cmd, ""] )
endfunc


" ─^  ApplyCmdTemplate                                   ▲


func! Rlist_get()
  return readfile( Rlist_path(), '\n' )
endfunc












