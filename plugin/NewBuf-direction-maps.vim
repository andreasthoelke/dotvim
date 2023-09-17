


" ─   NewBuf from self/parent/root-folder               ──
" self    c-w (native) 
" parent  ,             
" root    ,,            

" SELF
nnoremap <silent> <c-w>o    :call NewBuf_self        ( "float" )<cr>
" nnoremap <silent> <c-w>i     :call NewBuf_self        ( "full" )<cr>
nnoremap <silent> <c-w>t    :call NewBuf_self        ( "tab" )<cr>
nnoremap <silent> <c-w>Ts    :call NewBuf_self        ( "tab_spinoff" )<cr>
nnoremap <silent> <c-w>v    :call NewBuf_self        ( "right" )<cr>
nnoremap <silent> <c-w>Vb    :call NewBuf_self        ( "right_bg" )<cr>
nnoremap <silent> <c-w>a    :call NewBuf_self        ( "left" )<cr>
nnoremap <silent> <c-w>u    :call NewBuf_self        ( "up" )<cr>
nnoremap <silent> <c-w>s    :call NewBuf_self        ( "down" )<cr>
nnoremap <silent> <c-w>Sb    :call NewBuf_self        ( "down_bg" )<cr>

" PARENT & ROOT
nnoremap <silent> ,o        :call NewBuf_parentFolder( "float" )<cr>
nnoremap <silent> ,,o       :call NewBuf_rootFolder  ( "float" )<cr>
nnoremap <silent> ,i        :call NewBuf_parentFolder( "full" )<cr>
nnoremap <silent> ,,i       :call NewBuf_rootFolder  ( "full" )<cr>
nnoremap <silent> -          :call NewBuf_parentFolder( "full" )<cr>
nnoremap <silent> <leader>-  :call NewBuf_rootFolder  ( "full" )<cr>
nnoremap <silent> ,t        :call NewBuf_parentFolder( "tab" )<cr>
nnoremap <silent> ,,t       :call NewBuf_rootFolder  ( "tab" )<cr>
" _
nnoremap <silent> ,v        :call NewBuf_parentFolder( "right" )<cr>
nnoremap <silent> ,,v       :call NewBuf_rootFolder  ( "right" )<cr>
nnoremap <silent> ,an       :call NewBuf_parentFolder( "left" )<cr>
nnoremap <silent> ,,an      :call NewBuf_rootFolder  ( "left" )<cr>
nnoremap <silent> ,u        :call NewBuf_parentFolder( "up" )<cr>
nnoremap <silent> ,,u       :call NewBuf_rootFolder  ( "up" )<cr>
nnoremap <silent> ,sn       :call NewBuf_parentFolder( "down" )<cr>
nnoremap <silent> ,,sn      :call NewBuf_rootFolder  ( "down" )<cr>


" ─   NewBuf from path                                  ──

" LINE-WORD
nnoremap <silent> <c-w><leader>p   :call NewBuf_fromLineWord( "preview" )<cr>
nnoremap <silent> <c-w><leader>o  :call NewBuf_fromLineWord( "float" )<cr>
nnoremap <silent> <c-w><leader>i  :call NewBuf_fromLineWord( "full" )<cr>
nnoremap <silent> <c-w><leader>t  :call NewBuf_fromLineWord( "tab" )<cr>
nnoremap <silent> <c-w><leader>Ts  :call NewBuf_fromLineWord( "tab_spinoff" )<cr>
nnoremap <silent> <c-w><leader>Tb  :call NewBuf_fromLineWord( "tab_bg" )<cr>
" _
nnoremap <silent> <c-w><leader>v  :call NewBuf_fromLineWord( "right" )<cr>
nnoremap <silent> <c-w><leader>Vb  :call NewBuf_fromLineWord( "right_bg" )<cr>
nnoremap <silent> <c-w><leader>a  :call NewBuf_fromLineWord( "left" )<cr>
nnoremap <silent> <c-w><leader>u  :call NewBuf_fromLineWord( "up" )<cr>
nnoremap <silent> <c-w><leader>Ub  :call NewBuf_fromLineWord( "up_bg" )<cr>
nnoremap <silent> <c-w><leader>s  :call NewBuf_fromLineWord( "down" )<cr>
nnoremap <silent> <c-w><leader>Sb  :call NewBuf_fromLineWord( "down_bg" )<cr>

" CLIP-BORD
nnoremap <silent> <c-w>,p   :call NewBuf_fromLineWord( "preview" )<cr>
nnoremap <silent> <c-w>,o  :call NewBuf_fromLineWord( "float" )<cr>
nnoremap <silent> <c-w>,i  :call NewBuf_fromLineWord( "full" )<cr>
nnoremap <silent> <c-w>,t  :call NewBuf_fromLineWord( "tab" )<cr>
nnoremap <silent> <c-w>,Ts  :call NewBuf_fromLineWord( "tab_spinoff" )<cr>
nnoremap <silent> <c-w>,Tb  :call NewBuf_fromLineWord( "tab_bg" )<cr>
" _                     
nnoremap <silent> <c-w>,v  :call NewBuf_fromLineWord( "right" )<cr>
nnoremap <silent> <c-w>,Vb  :call NewBuf_fromLineWord( "right_bg" )<cr>
nnoremap <silent> <c-w>,a  :call NewBuf_fromLineWord( "left" )<cr>
nnoremap <silent> <c-w>,u  :call NewBuf_fromLineWord( "up" )<cr>
nnoremap <silent> <c-w>,Ub  :call NewBuf_fromLineWord( "up_bg" )<cr>
nnoremap <silent> <c-w>,s  :call NewBuf_fromLineWord( "down" )<cr>
nnoremap <silent> <c-w>,Sb  :call NewBuf_fromLineWord( "down_bg" )<cr>

nnoremap <c-w>o :echo "not active"<cr>
nnoremap <silent> <c-w>dd <c-w>o



" ─   NewBuf direction maps                              ■

func! NewBuf_parentFolder( direction )
  let file = expand('%:p')  " might be a file or dirvish directory
  let parentFolderPath = ParentFolder( file )  " if a directory this will get the parent folder of the directory!
  let cmd = NewBufCmds( parentFolderPath )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  call search('\V\^'.escape(file, '\').'\$', 'cw')
endfunc
" ParentFolder( expand("%:h") )
" ParentFolder( expand("%:p") )

func! NewBuf_rootFolder( direction )
  let cmd = NewBufCmds( getcwd() )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
endfunc


func! NewBuf_self( direction )
  let winview = winsaveview()
  let file = expand('%:p')  " might be a file or dirvish directory
  let cmd = NewBufCmds( file )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  call winrestview( winview )
endfunc


" Path at cusor pos or clip-board 
" Supporting 'LinkPaths', e.i. Might have an appended line link: #:<num> or #/<searchStr>  

" In divish buffers or paths in .md files spin off a new buffer from that path.
func! NewBuf_fromLine( direction )
  let [path; linkL] = getline('.')->split('#')
  let cmd = NewBufCmds( path )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
endfunc

func! NewBuf_fromLineWord( direction )
  let [path; linkL] = GetLongestWord_inLine()->split('#')
  let cmd = NewBufCmds( path )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
endfunc

func! NewBuf_fromClipPath( direction )
  let [path; linkL] = @*->split('#')
  " let path = GetLongestWord_inLine()
  let cmd = NewBufCmds( path )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
endfunc




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
  let mp['left']  = 'leftabove '. winwidth(0)/4 . 'vnew _PATH_'
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


" ─^  NewBuf direction maps                              ▲








