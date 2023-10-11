


" ─   Arglist                                            ■

" new maps 2023-09

" Show the arglist with fzf. use c-v/t/x to open a file or folderpath in dirvish
nnoremap <silent> <leader>vs :Args<cr>

" ADDING & TOGGLING
" Arglist items toggle motions. examples:
" l al  - toggels a single filepath in the arglist
" l aj  - toggels 2 lines
" l a}  - toggels a paragraph of lines
nnoremap <silent> <leader>v :set opfunc=ArglistToggle_op<cr>g@
" l aa  - toggels the vis-selection of lines
vnoremap <silent> <leader>vv :<c-u>call Arglist_toggleItems( getline("'<", "'>") )<cr>

" clear the list
nnoremap <leader>ac :call ArglistClear()<cr>

" issure: currently folders can not be toggled in dirvish. also the auto-switch between local and 
" global paths is confusing. so exporing a simple self made 'read filepath' list
" the leader v or leader x maps might be used for other things if i keep not using the arglist


" CtrlP support: Arglist can be shown in CtrlP. Files can be opened and items deleted with <c-s>
command! CtrlPArgs call ctrlp#init( ctrlpArgs#id() )
" nnoremap <leader>sA :CtrlPArgs<cr>
" nnoremap <leader>sA :Args<cr>
nnoremap <leader>dA :call ArglistDelFiles()<cr>
nnoremap <leader>cA :call ArglistClear()<cr>

nnoremap <leader>oa :echo 'use sA (show Arglist)'<cr>
nnoremap <leader>X :echo 'use cA (clear Arglist)'<cr>

" Use "argg and argl" to switch to global and local arg list. Generally prefer the global arg list.

func! ReloadKeepView()
  let l:winview = winsaveview()
  exec 'e'
  exec 'normal!' "\<C-o>"
  call winrestview(l:winview)
endfunc

" Toggle arglist items: Single, vis-sel and line motion
nnoremap <leader>xx :call Arglist_toggleItems( [getline('.')] )<cr>:Dirvish %<cr>
vnoremap <leader>x :<c-u>call Arglist_toggleItems( getline("'<", "'>") )<cr>
nnoremap <leader>x :set opfunc=ArglistToggle_op<cr>g@
" Tip: can add popular folders as well, then CtrlP-v/t to open the dirvish pane
" Issue: Dotfolders e.g. ".git" can not be toggled in dirvish, only with CtrlP-s

" leader xiB  - toggle all dirvish files to the arglist

func! ArglistDelFiles()
  let msg = 'Deleting these files: ' . string( argv() ) . ' ?'
  let dres = confirm( msg, "&Yes\n&Cancel", 2 )
  if dres == 1
    for fname in argv()
      call system( 'del ' . fname )
      exec 'bdelete' fname
    endfor
    exec '%argdelete'
    normal R
  else
    redraw
    echo 'canceled'
  endif
  " clear the message area
  call feedkeys(':','nx')
endfunc

" Note: vim delete(<fname>) doesn't move to trash!
" call map ( argv(), {_, str -> delete( str, 'rf' )} )

func! ArglistClear()
  exec '%argdelete'
  normal R
endfunc

func! ArglistToggle_op( _ )
  call Arglist_toggleItems( getline( "'[", "']" ) )
endfunc

" Remove a string from the arglist if already present, add it otherwise.
func! Arglist_toggleItems( listOfStr )
  argglobal
  for argItem in a:listOfStr
    let currentIndex = index( ArgvFilenameTailOnly(), fnamemodify( argItem, ":t" ) )
    if currentIndex == -1
      exec '$argadd ' . argItem
    else
      exec (currentIndex+1) . "argd"
    endif
  endfor
  if &filetype == 'dirvish'
    Dirvish %
  endif
endfunc

func! ArgvAbsPath()
  return MakeFilenamesAbsolute( argv() )
endfunc

func! ArgvFilenameTailOnly()
  return map ( argv(), {_, str -> fnamemodify( str, ":t" )} )
endfunc

func! MakeFilenamesAbsolute ( listOfFilesnames )
  return map( a:listOfFilesnames, {_, str -> fnamemodify( str, ":p")} )
endfunc

" ─^  Arglist                                            ▲


" ─   fzf                                                ■
" 

" let g:fzf_layout = { 'up': '~60%' }
" let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85} }

command! -bang Args call fzf#run(fzf#wrap('args', {'source': argv()}, <bang>0))


" ─^  fzf                                                ▲




















" ─   Move Files                                         ■
" Process:
" - put two Dirvish folders side by side (source -> target)
" - use leader x(l/j/vis-sel) in the left window to add to the arglist
"   - leader sA to show current arglist
"   - leader X to reset/clear arglist
"   - do this regularly (also R to refesh Dirvish)
" - leader mv will run the 'move' command.
"   - <c-w>l to see the moved file in the other folder in 'red' (auto added to the arg list)
"   - with the cursor still in the right win (related folder path is filtered as the target folder)
"     run leader mv again to undo/redo to operation in reverse direction
" - leader mV will show e.g.
  " Shdo! mv %{} /Users/at/Documents/PS/A/TestsA/webpack-reload/src/App/{}
  " in command edit mode. placeholder "{}" will insert the arglist! and I can now change "mv" to "cp" or "rm", etc
  " - <c-c><c-c> cancels the process
  " - <c-c><cr> runs the Shdo! command to will show a buffer with the full command
  " - leader leader z will run the shell script in that buffer
  " - leader bd to delete that temp buffer
  " - see the effect in the dirvish buffers. R? or leader X?
  " - <c-w>L/H to reverse the command?


" nnoremap <leader>mv :call MoveFilesFromLeftWinToRightWin( 0 )<cr>
" nnoremap <leader>mV :call MoveFilesFromLeftWinToRightWin( 1 )<cr>q:<leader>"tP^W

" The list of filenames in the current tab
func! TabWinFilenames()
  return map( tabpagebuflist( tabpagenr() ), {_, bufnum -> bufname( bufnum ) } )
endfunc


func! MoveFilesFromLeftWinToRightWin( prompt )
  let folderPathSource = bufname( bufnr('%') )
  " Of the other windows choose the leftmost as the target of the file move
  let [folderPathTarget;_] = functional#filter( {path-> path isnot# folderPathSource}, TabWinFilenames() )
  " if len(TabWinFilenames()) > 1
  " else
  "   let folderPathTarget = '%'
  " endif
  if !( IsFolderPath( folderPathSource ) && IsFolderPath( folderPathTarget ))
    echoe "You need to have source and target folders side by side"
    return
  endif

  " let cmdStr = 'Shdo! mv ' . folderPathSource.'{} ' . folderPathTarget.'{}'
  let cmdStr = 'Shdo! mv ' . '%{} ' . folderPathTarget.'{}'
  if a:prompt
    " TODO go directly into the command editing window - automate <c-f>k^w
    " normal! q:
    let @t = cmdStr
    " call feedkeys( ':' . cmdStr )
    " Stop at the pre-filled command prompt, don't auto-run and close the Shdo buffer
    return
  else
    " this opens a buffer with the full shell script!
    exec cmdStr
    " this runs the shell script
    call RunBufferAsShellScript()
    wincmd c
    call SetArglistfilesFolder( folderPathTarget )
  endif
  " wincmd p
  " if &filetype == 'dirvish'
  "   Dirvish %
  " else
  "   wincmd w
  "   Dirvish %
  " endif
  " wincmd w
endfunc

" ─^  Move Files                                         ▲


nnoremap <leader>mv :call UnzipArglistToFolderpath( 0 )<cr>
nnoremap <leader>mV :call UnzipArglistToFolderpath( 1 )<cr>q:<leader>"tP^W

func! UnzipArglistToFolderpath( prompt )
  let folderPathTarget = getline(".")
  if !( IsFolderPath( folderPathTarget ) )
    echoe "Please move the cursor to a target folder path."
    return
  endif

  let cmdStr = 'unzip temp.zip ' . "%{} -d " . folderPathTarget
  if a:prompt
    " TODO go directly into the command editing window - automate <c-f>k^w
    " normal! q:
    let @t = cmdStr
    " call feedkeys( ':' . cmdStr )
    " Stop at the pre-filled command prompt, don't auto-run and close the Shdo buffer
    return
  else
    " this opens a buffer with the full shell script!
    exec cmdStr
    " this runs the shell script
    call RunBufferAsShellScript()
    wincmd c
    call SetArglistfilesFolder( folderPathTarget )
  endif
  " wincmd p
  " if &filetype == 'dirvish'
  "   Dirvish %
  " else
  "   wincmd w
  "   Dirvish %
  " endif
  " wincmd w
endfunc


func! ExpandListGlobsToListFilespaths ( listOfGlobs )
  let listOfListsPaths = functional#map( 'GlobToPaths', a:listOfGlobs )
  return functional#concat( listOfListsPaths )
endfunc
" echo ExpandListGlobsToListFilespaths( g:testVimGlobs )
" echo glob( 'notes/*txt', v:true, v:true )
" echo globpath( join(['notes/', './'], ','), '*vim*' )
" echo map( ExpandListGlobsToListFilespaths(g:testVimGlobs), 'fnamemodify(v:val, ":t:r")' )

" let g:testVimGlobs = ['notes/*.txt', 'autoload/**.old', 'syntax/h*', 'plugin/*ma*']
" let g:testVimFilesnames = map( ExpandListGlobsToListFilespaths(g:testVimGlobs), 'fnamemodify(v:val, ":t:r")' )


func! GlobToPaths (glob)
  return glob( a:glob, v:true, v:true )
endfunc

func! IsFolderPath ( path )
  " return isdirectory( a:path )
  " This is technically faster as it's not checking the existence of the folder in the file system but only tests the last character of the string
  return (a:path[-1:] == '/')
endfunc

func! GetLastComponentFromPath (folderpath)
  let components = split( a:folderpath, '/' )[-1:]
  return !empty(components) ? components[0] : ''
endfunc

func! ProjectRootFolderName ()
  return GetLastComponentFromPath( getcwd() )
endfunc

func! ProjectRootFolderNameOfWin (winnr)
  return GetLastComponentFromPath( getcwd(a:winnr) )
endfunc

" When opening a file with Dirvish the filepath is not relative. This makes sure it is.
func! CurrentRelativeFilePath ()
  let path = expand('%:p')
  let cwd = getcwd()
  let relPath = substitute( path, cwd, '', '' )
  let relPath = substitute( relPath[1:], "/", ' ', 'g' )
  return relPath
endfunc
" CurrentRelativeFilePath()

func! CurrentRelativeFilePathOfWin()
  let path = expand('%:p')
  let cwd = getcwd( winnr() )
  let relPath = substitute( path, cwd, '', '' )
  let relPath = substitute( relPath[1:], "/", ' ', 'g' )
  return relPath
endfunc

" A dirvish buffer will be the 'next folder path'
func! CurrentNextFolderPath ()
  let path = expand('%:p')
  let filename = expand('%:t') " filename is empty in Dirvish
  let folderpath = substitute( path, filename, '', '' )
  return folderpath
endfunc
" echo CurrentNextFolderPath()

func! GetFilenameOrFolderStrFromPath (path)
  let lastSegment = GetLastComponentFromPath( a:path )
  if IsFolderPath( a:path )
    let lastSegment .= '/'
  endif
  return lastSegment
endfunc
" echo GetFilenameOrFolderStrFromPath('/Users/at/.vim/plugged/csv.vim/')
" echo GetFilenameOrFolderStrFromPath('/Users/at/.vim/plugged/csv.vim/test.txt')

func! FilenameOrFolderStrOfCurrentBuffer (tab_count)
  let buflist = tabpagebuflist(a:tab_count)
  let winnr = tabpagewinnr(a:tab_count)
  let path = expand('#' . buflist[winnr - 1])
  return GetFilenameOrFolderStrFromPath( path )
endfunc
" FilenameOrFolderStrOfCurrentBuffer( tabpagenr() )
" From ~/.vim/plugged/lightline.vim/autoload/lightline/tab.vim#/function.%20lightline#tab#filename.n.%20abort


func! SetArglistfilesFolder( newFolder )
  let argvTail = ArgvFilenameTailOnly()
  %argdelete
  for argItem in argvTail
    exec '$argadd ' . a:newFolder . argItem
  endfor
endfunc

" nnoremap <buffer><silent> Z! :silent write<Bar>exe '!'.(has('win32')?fnameescape(escape(expand('%:p:gs?\\?/?'), '&\')):shellescape(&shell).' %')<Bar>if !v:shell_error<Bar>close<Bar>endif<CR>

nnoremap <leader><leader>z :call RunBufferAsShellScript()<cr>

func! RunBufferAsShellScript()
  exec '!'. shellescape( &shell ) .' %'
  if !v:shell_error
    close
  endif
endfunc

func! SetExecutableFlag ( path, val )
  let cmd = a:val ? 'chmod u+x ' : 'chmod u-x '
  call system( cmd . fnameescape(a:path) )
endfunc
" call SetExecutableFlag('/Users/at/.vim/notes/my folder/ei.txt', v:false)
" call SetExecutableFlag('/Users/at/.vim/notes/my folder/ei.txt', v:true)

" call SetExecutableFlag('~/apps_bin/nvim07/bin/nvim', v:true)
" call SetExecutableFlag('~/apps_bin/nvim061/bin/nvim', v:true)
"
" can also navigate to folder and then chmod +x nvim
" but then I just right-clicked and >open< the file .. also the lib...8.. file










