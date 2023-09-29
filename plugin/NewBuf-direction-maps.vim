


" ─   NewBuf from self/parent/root-folder               ──
" self    c-w (native) 
" parent  ,             
" root    ,,            

" SELF
nnoremap <silent> <c-w>o    :call NewBuf_self        ( "float" )<cr>
nnoremap <silent> <c-w>t    :call NewBuf_self        ( "tab" )<cr>
nnoremap <silent> <c-w>T    :call NewBuf_self        ( "tab_spinoff" )<cr>
nnoremap <silent> <c-w>v    :call NewBuf_self        ( "right" )<cr>
nnoremap <silent> <c-w>V    :call NewBuf_self        ( "right_bg" )<cr>
nnoremap <silent> <c-w>a    :call NewBuf_self        ( "left" )<cr>
nnoremap <silent> <c-w>u    :call NewBuf_self        ( "up" )<cr>
nnoremap <silent> <c-w>s    :call NewBuf_self        ( "down" )<cr>
nnoremap <silent> <c-w>S    :call NewBuf_self        ( "down_bg" )<cr>

" PARENT & ROOT
nnoremap <silent> ,o        :call Browse_parent( "float" )<cr>
nnoremap <silent> ,,o       :call Browse_cwd  ( "float" )<cr>
nnoremap <silent> ,i        :call Browse_parent( "full" )<cr>
nnoremap <silent> ,,i       :call Browse_cwd  ( "full" )<cr>
nnoremap <silent> -         :call Browse_parent( "full" )<cr>
nnoremap <silent> <leader>- :call Browse_cwd  ( "full" )<cr>
nnoremap <silent> ,t        :call Browse_parent( "tab" )<cr>
nnoremap <silent> ,,t       :call Browse_cwd  ( "tab" )<cr>
" _
nnoremap <silent> ,v        :call Browse_parent( "right" )<cr>
nnoremap <silent> ,V        :call Browse_parent( "right_bg" )<cr>
nnoremap <silent> ,,v       :call Browse_cwd  ( "right" )<cr>
nnoremap <silent> ,,V       :call Browse_cwd  ( "right_bg" )<cr>
nnoremap <silent> ,an       :call Browse_parent( "left" )<cr>
nnoremap <silent> ,,an      :call Browse_cwd  ( "left" )<cr>
nnoremap <silent> ,u        :call Browse_parent( "up" )<cr>
nnoremap <silent> ,,u       :call Browse_cwd  ( "up" )<cr>
nnoremap <silent> ,sn       :call Browse_parent( "down" )<cr>
nnoremap <silent> ,,sn      :call Browse_cwd  ( "down" )<cr>



" ─   NewBuf from path                                  ──

" LINE-WORD
nnoremap <silent> <c-w><leader>p  :call NewBuf_fromCursorLinkPath( "preview" )<cr>
nnoremap <silent> <c-w><leader>o  :call NewBuf_fromCursorLinkPath( "float" )<cr>
nnoremap <silent> <c-w><leader>i  :call NewBuf_fromCursorLinkPath( "full" )<cr>
nnoremap <silent> <c-w><leader>t  :call NewBuf_fromCursorLinkPath( "tab" )<cr>
nnoremap <silent> <c-w><leader>T  :call NewBuf_fromCursorLinkPath( "tab_bg" )<cr>
" _
nnoremap <silent> <c-w><leader>v  :call NewBuf_fromCursorLinkPath( "right" )<cr>
nnoremap <silent> <c-w><leader>V  :call NewBuf_fromCursorLinkPath( "right_bg" )<cr>
nnoremap <silent> <c-w><leader>a  :call NewBuf_fromCursorLinkPath( "left" )<cr>
nnoremap <silent> <c-w><leader>u  :call NewBuf_fromCursorLinkPath( "up" )<cr>
nnoremap <silent> <c-w><leader>U  :call NewBuf_fromCursorLinkPath( "up_bg" )<cr>
nnoremap <silent> <c-w><leader>s  :call NewBuf_fromCursorLinkPath( "down" )<cr>
nnoremap <silent> <c-w><leader>S  :call NewBuf_fromCursorLinkPath( "down_bg" )<cr>

" CLIP-BOARD
nnoremap <silent> <c-w>,p  :call NewBuf_fromClipPath( "preview" )<cr>
nnoremap <silent> <c-w>,o  :call NewBuf_fromClipPath( "float" )<cr>
nnoremap <silent> <c-w>,i  :call NewBuf_fromClipPath( "full" )<cr>
nnoremap <silent> <c-w>,t  :call NewBuf_fromClipPath( "tab" )<cr>
nnoremap <silent> <c-w>,T  :call NewBuf_fromClipPath( "tab_bg" )<cr>
" _                     
nnoremap <silent> <c-w>,v  :call NewBuf_fromClipPath( "right" )<cr>
nnoremap <silent> <c-w>,V  :call NewBuf_fromClipPath( "right_bg" )<cr>
nnoremap <silent> <c-w>,a  :call NewBuf_fromClipPath( "left" )<cr>
nnoremap <silent> <c-w>,u  :call NewBuf_fromClipPath( "up" )<cr>
nnoremap <silent> <c-w>,U  :call NewBuf_fromClipPath( "up_bg" )<cr>
nnoremap <silent> <c-w>,s  :call NewBuf_fromClipPath( "down" )<cr>
nnoremap <silent> <c-w>,S  :call NewBuf_fromClipPath( "down_bg" )<cr>

nnoremap <c-w>o :echo "not active"<cr>
nnoremap <silent> <c-w>dd <c-w>o


" ─   Browse folder with nvt                            ──

func! Browse_parent( direction )
  call AlternateFileLoc_save()
  let file = expand('%:p')  " might be a file or dirvish directory
  let parentFolderPath = ParentFolder( file )  " if a directory this will get the parent folder of the directory!
  let cmd = NewBufCmds( parentFolderPath )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  call v:lua.Tree_focusPathInRootPath( file, parentFolderPath ) 
endfunc

func! Browse_cwd( direction )
  call AlternateFileLoc_save()
  let file = expand('%:p')  " might be a file or dirvish directory
  let cwd = getcwd()
  let cmd = NewBufCmds( cwd )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  call v:lua.Tree_focusPathInRootPath( file, cwd ) 
endfunc



" ─   NewBuf from self/parent/root-folder               ──

func! NewBuf_parentFolder( direction, ... )
  let file = expand('%:p')  " might be a file or dirvish directory
  let parentFolderPath = ParentFolder( file )  " if a directory this will get the parent folder of the directory!
  let cmd = NewBufCmds( parentFolderPath )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  call search('\V\^'.escape(file, '\').'\$', 'cw')
  if get(a:, 1,  '') == 'tree' 
    call v:lua.Tree_focusPathInRootPath( getline('.'), expand('%:p') ) 
  endif
endfunc
" ParentFolder( expand("%:h") )
" ParentFolder( expand("%:p") )

func! NewBuf_rootFolder( direction, ... )
  let cmd = NewBufCmds( getcwd() )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  if get(a:, 1,  '') == 'tree' 
    call v:lua.Tree_focusPathInRootPath( getline('.'), expand('%:p') ) 
  endif
endfunc

func! NewBuf_self( direction )
  let winview = winsaveview()
  let file = expand('%:p')  " might be a file or dirvish directory
  let cmd = NewBufCmds( file )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  call winrestview( winview )
endfunc

func! SearchLine( str )
  call search( '\V\^' . escape( a:str, '\' ) . '\$', 'cw' )
endfunc


" ─   NewBuf from path                                  ──
" Supporting 'LinkPaths', e.i. Might have an appended line link: #:<num> or #/<searchStr>  

" Use this function for mappings in 
" divish, nvim-tree, LinkPaths in .md or source files
" to spin off a new folder or file buffer.
func! NewBuf_fromCursorLinkPath( direction )
  let [path; maybeLinkExt] = 
     \ &filetype == 'NvimTree' ?
     \   [ v:lua.Tree_cursorPath() ] :
     \   GetLongestWord_inLine()->split('‖')

  let cmd = NewBufCmds( path )[ a:direction ] 
  if &filetype == 'NvimTree' 
    " wincmd c
  elseif IsInFloatWin() 
    wincmd c 
  endif
  exec cmd
  if len(maybeLinkExt) | call Link_jumpToLine( maybeLinkExt[0] ) | endif
endfunc

" In divish, nvim-tree or paths in .md files spin off a new buffer from that path. ■
" func! NewBuf_fromLine( direction )
"   let [path; maybeLinkExt] = getline('.')->split('‖')
"   let cmd = NewBufCmds( path )[ a:direction ] 
"   if IsInFloatWin() | wincmd c | endif
"   exec cmd
"   if len(maybeLinkExt) | call Link_jumpToLine( maybeLinkExt[0] ) | endif
" endfunc
" func! NewBuf_fromLineWord( direction )
"   let [path; maybeLinkExt] = GetLongestWord_inLine()->split('‖')
"   let cmd = NewBufCmds( path )[ a:direction ] 
"   if IsInFloatWin() | wincmd c | endif
"   exec cmd
"   if len(maybeLinkExt) | call Link_jumpToLine( maybeLinkExt[0] ) | endif
" endfunc
  " if &filetype == 'NvimTree'
    " let path = Tree_cursorPath()
    " let maybeLinkExt = []
  " else
  "   let [path; maybeLinkExt] = getline('.')->split('‖')
  " endif
"  ▲

func! NewBuf_fromClipPath( direction )
  let [path; maybeLinkExt] = @*->split('‖')
  let cmd = NewBufCmds( path )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  if len(maybeLinkExt) | call Link_jumpToLine( maybeLinkExt[0] ) | endif
endfunc


" Focus the "path" (dir or file) at cursor in tree-view. Mostly launched from dirvish(?)
" The tree-view is launched in the same window. To launch the tree-view in a new window, use the "parent" maps first (e.g. ,v) then this map.
func! Tree_fromLinePath()
  let [path; _maybeLinkExt] = getline('.')->split('‖') " link extensions are ignored
  let parentDir = expand('%:p')  " parent dir to path (usually dirvish folder)
  " call v:lua.Tree_focusPathInRootPath( path, parentDir )
  call v:lua.Tree_expandFolderInRootPath( path, parentDir )
  call v:lua.Tree_expandFolderInRootPath( getline('.'), expand('%:p') )
endfunc

func! Tree_test()
  let tempFile = tempname()
  call writefile( 'hi there', tempFile)
  " call delete( tempFile )
  call v:lua.open.replace_tree_buffer
  call v:lua.Tree_expandFolderInRootPath( path, parentDir )
endfunc

" 

" DIRECTION IDS  <==>   BUF-open Commands:

func! NewBufCmds_templ()
  let mp = {}
  let mp['preview'] = 'wincmd p | edit _PATH_ | wincmd p'
  let mp['float'] = 'call Path_Float( "_PATH_" )'
  let mp['float_spinoff'] = 'wincmd c | call Path_Float( "_PATH_" )'
  let mp['full']  = 'edit _PATH_'
  let mp['tab']   = 'tabedit _PATH_'
  let mp['tab_bg'] = 'tabedit _PATH_ | tabprevious'
  let mp['tab_spinoff'] = 'wincmd c | tabedit _PATH_'
  let mp['right'] = 'vnew _PATH_'
  let mp['right_bg'] = 'vnew _PATH_ | wincmd p'
  " let mp['left']  = 'leftabove 30vnew _PATH_'
  let mp['left']    = 'leftabove '. winwidth(0)/4 . 'vnew _PATH_'
  let mp['left_bg'] = 'leftabove '. winwidth(0)/4 . 'vnew _PATH_ | wincmd p'
  " let mp['up']    = 'leftabove 20new _PATH_'
  " let mp['up']    = 'leftabove new _PATH_'
  let mp['up']   = 'leftabove '. winheight(0)/4 . 'new _PATH_'
  let mp['up_bg'] = 'leftabove '. winheight(0)/4 . 'new _PATH_ | wincmd p'
  let mp['down']  = 'new _PATH_'
  let mp['down_bg'] = 'new _PATH_ | wincmd p'
  return mp
endfunc


func! NewBufCmds( path )
  return NewBufCmds_templ()->map( {_idx, cmdTmp -> substitute( cmdTmp, '_PATH_', a:path, "" )} )
endfunc
" NewBufCmds( "src" )
" Exec( NewBufCmds( ".gitignore" )["tab_bg"] )
" Exec( NewBufCmds( ".gitignore" )["float"] )
" Exec( NewBufCmds( "src" )["float"] )
" Exec( NewBufCmds( "src" )["down"] )

func! Exec( cmd )
  exec a:cmd
endfunc










