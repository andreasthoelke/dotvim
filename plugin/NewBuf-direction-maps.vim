


" ─   NewBuf from self/parent/root-folder               ──
" self    c-w (native) 
" parent  ,             
" root    ,,            

" SELF
nnoremap <silent> <c-w>o    :call NewBuf_self        ( "float" )<cr>
nnoremap <silent> <c-w>t    :call NewBuf_self        ( "tab" )<cr>
nnoremap <silent> <c-w>T    :call NewBuf_self        ( "tab_spinoff" )<cr>
nnoremap <silent> <c-w>v    :call NewBuf_self        ( "right" )<cr>
nnoremap <silent> <c-w>V    :call NewBuf_self        ( "right_back" )<cr>
nnoremap <silent> <c-w>a    :call NewBuf_self        ( "left" )<cr>
nnoremap <silent> <c-w>u    :call NewBuf_self        ( "up" )<cr>
nnoremap <silent> <c-w>s    :call NewBuf_self        ( "down" )<cr>
nnoremap <silent> <c-w>S    :call NewBuf_self        ( "down_back" )<cr>

" PARENT & ROOT
nnoremap <silent> ,o        :call Browse_parent( "float" )<cr>
nnoremap <silent> ,,o       :call Browse_cwd  ( "float" )<cr>
nnoremap <silent> ,i        :call Browse_parent( "full" )<cr>
nnoremap <silent> ,,i       :call Browse_cwd  ( "full" )<cr>
nnoremap <silent> -         :call Browse_parent( "full" )<cr>
nnoremap <silent> <leader>- :call Browse_cwd  ( "full" )<cr>
nnoremap <silent> <leader><leader>- :Dirvish<cr>
nnoremap <silent> <leader>od :Dirvish<cr>
nnoremap <silent> ,tn        :call Browse_parent( "tab" )<cr>
nnoremap <silent> ,,tn       :call Browse_cwd  ( "tab" )<cr>
" _
nnoremap <silent> ,v        :call Browse_parent( "right" )<cr>
nnoremap <silent> ,V        :call Browse_parent( "right_back" )<cr>
nnoremap <silent> ,,v       :call Browse_cwd  ( "right" )<cr>
nnoremap <silent> ,,V       :call Browse_cwd  ( "right_back" )<cr>
nnoremap <silent> ,an       :call Browse_parent( "left" )<cr>
nnoremap <silent> ,,an      :call Browse_cwd  ( "left" )<cr>
nnoremap <silent> ,An       :call Browse_parent( "left_back" )<cr>
nnoremap <silent> ,,An      :call Browse_cwd  ( "left_back" )<cr>
nnoremap <silent> ,u        :call Browse_parent( "up" )<cr>
nnoremap <silent> ,,u       :call Browse_cwd  ( "up" )<cr>
nnoremap <silent> ,sn       :call Browse_parent( "down" )<cr>
nnoremap <silent> ,,sn      :call Browse_cwd  ( "down" )<cr>



" ─   NewBuf from path                                  ──

" LINE-WORD
nnoremap <silent> <c-w><leader>p  :call NewBuf_fromCursorLinkPath( "preview_back" )<cr>
nnoremap <silent> <c-w><leader>o  :call NewBuf_fromCursorLinkPath( "float" )<cr>
nnoremap <silent> <c-w><leader>i  :call NewBuf_fromCursorLinkPath( "full" )<cr>
nnoremap <silent> <c-w><leader>t  :call NewBuf_fromCursorLinkPath( "tab" )<cr>
nnoremap <silent> <c-w><leader>T  :call NewBuf_fromCursorLinkPath( "tab_bg" )<cr>
" _
nnoremap <silent> <c-w><leader>v  :call NewBuf_fromCursorLinkPath( "right" )<cr>
nnoremap <silent> <c-w><leader>V  :call NewBuf_fromCursorLinkPath( "right_back" )<cr>
nnoremap <silent> <c-w><leader>a  :call NewBuf_fromCursorLinkPath( "left" )<cr>
nnoremap <silent> <c-w><leader>u  :call NewBuf_fromCursorLinkPath( "up" )<cr>
nnoremap <silent> <c-w><leader>U  :call NewBuf_fromCursorLinkPath( "up_back" )<cr>
nnoremap <silent> <c-w><leader>s  :call NewBuf_fromCursorLinkPath( "down" )<cr>
nnoremap <silent> <c-w><leader>S  :call NewBuf_fromCursorLinkPath( "down_back" )<cr>


" TELESCOPE 
" ~/.config/nvim/plugin/utils-fileselect-telescope.lua‖*NewBufˍmapsˍi


" CLIP-BOARD
nnoremap <silent> <c-w>,p  :call NewBuf_fromClipPath( "preview" )<cr>
nnoremap <silent> <c-w>,o  :call NewBuf_fromClipPath( "float" )<cr>
nnoremap <silent> <c-w>,i  :call NewBuf_fromClipPath( "full" )<cr>
nnoremap <silent> <c-w>,t  :call NewBuf_fromClipPath( "tab" )<cr>
nnoremap <silent> <c-w>,T  :call NewBuf_fromClipPath( "tab_bg" )<cr>
" _                     
nnoremap <silent> <c-w>,v  :call NewBuf_fromClipPath( "right" )<cr>
nnoremap <silent> <c-w>,V  :call NewBuf_fromClipPath( "right_back" )<cr>
nnoremap <silent> <c-w>,a  :call NewBuf_fromClipPath( "left" )<cr>
nnoremap <silent> <c-w>,u  :call NewBuf_fromClipPath( "up" )<cr>
nnoremap <silent> <c-w>,U  :call NewBuf_fromClipPath( "up_back" )<cr>
nnoremap <silent> <c-w>,s  :call NewBuf_fromClipPath( "down" )<cr>
nnoremap <silent> <c-w>,S  :call NewBuf_fromClipPath( "down_back" )<cr>

" nnoremap <c-w>o :echo "not active"<cr>
nnoremap <silent> <c-w>dd <c-w>o


" TERM-BUFFER
" c-w t  - TODO: any / glt? terminal buffer?

" REPL-BUFFER
nnoremap <silent> <c-w>rp  :call NewBuf_fromReplBuffer( "preview" )<cr>
nnoremap <silent> <c-w>ro  :call NewBuf_fromReplBuffer( "float" )<cr>
nnoremap <silent> <c-w>ri  :call NewBuf_fromReplBuffer( "full" )<cr>
nnoremap <silent> <c-w>rt  :call NewBuf_fromReplBuffer( "tab" )<cr>
nnoremap <silent> <c-w>rT  :call NewBuf_fromReplBuffer( "tab_left" )<cr>
"      
nnoremap <silent> <c-w>rv  :call NewBuf_fromReplBuffer( "right" )<cr>
nnoremap <silent> <c-w>rV  :call NewBuf_fromReplBuffer( "right_back" )<cr>
nnoremap <silent> <c-w>ra  :call NewBuf_fromReplBuffer( "left" )<cr>
nnoremap <silent> <c-w>rA  :call NewBuf_fromReplBuffer( "left_back" )<cr>
nnoremap <silent> <c-w>ru  :call NewBuf_fromReplBuffer( "up" )<cr>
nnoremap <silent> <c-w>rU  :call NewBuf_fromReplBuffer( "up_back" )<cr>
nnoremap <silent> <c-w>rs  :call NewBuf_fromReplBuffer( "down" )<cr>
nnoremap <silent> <c-w>rS  :call NewBuf_fromReplBuffer( "down_back" )<cr>

" SCRATCH-BUFFER
nnoremap <silent> <c-w>gp  :call NewBuf_fromScratchBuffer( "preview" )<cr>
nnoremap <silent> <c-w>go  :call NewBuf_fromScratchBuffer( "float" )<cr>
nnoremap <silent> <c-w>gi  :call NewBuf_fromScratchBuffer( "full" )<cr>
nnoremap <silent> <c-w>gt  :call NewBuf_fromScratchBuffer( "tab" )<cr>
nnoremap <silent> <c-w>gT  :call NewBuf_fromScratchBuffer( "tab_left" )<cr>
"                      
nnoremap <silent> <c-w>gv  :call NewBuf_fromScratchBuffer( "right" )<cr>
nnoremap <silent> <c-w>gV  :call NewBuf_fromScratchBuffer( "right_back" )<cr>
nnoremap <silent> <c-w>ga  :call NewBuf_fromScratchBuffer( "left" )<cr>
nnoremap <silent> <c-w>gA  :call NewBuf_fromScratchBuffer( "left_back" )<cr>
nnoremap <silent> <c-w>gu  :call NewBuf_fromScratchBuffer( "up" )<cr>
nnoremap <silent> <c-w>gU  :call NewBuf_fromScratchBuffer( "up_back" )<cr>
nnoremap <silent> <c-w>gs  :call NewBuf_fromScratchBuffer( "down" )<cr>
nnoremap <silent> <c-w>gS  :call NewBuf_fromScratchBuffer( "down_back" )<cr>


" CURSOR-LSP-REFERENCE
nnoremap <silent> gdp  :call NewBuf_fromCursorLspRef( "preview_back" )<cr>
nnoremap <silent> gdo  :call NewBuf_fromCursorLspRef( "float" )<cr>
nnoremap <silent> gdi  :call NewBuf_fromCursorLspRef( "full" )<cr>
nnoremap <silent> gdt  :call NewBuf_fromCursorLspRef( "tab" )<cr>
nnoremap <silent> gdT  :call NewBuf_fromCursorLspRef( "tab_bg" )<cr>
" _                                        
nnoremap <silent> gdv  :call NewBuf_fromCursorLspRef( "right" )<cr>
nnoremap <silent> gdV  :call NewBuf_fromCursorLspRef( "right_back" )<cr>
nnoremap <silent> gda  :call NewBuf_fromCursorLspRef( "left" )<cr>
nnoremap <silent> gdu  :call NewBuf_fromCursorLspRef( "up" )<cr>
nnoremap <silent> gdU  :call NewBuf_fromCursorLspRef( "up_back" )<cr>
nnoremap <silent> gds  :call NewBuf_fromCursorLspRef( "down" )<cr>
nnoremap <silent> gdS  :call NewBuf_fromCursorLspRef( "down_back" )<cr>

nnoremap <silent> gdd  :echo 'use gdi'<cr>


" ─   NewBuf from telescope prompt                      ──
" ~/.config/nvim/plugin/utils-fileselect-telescope.lua‖/localˍNewBu
" ~/.config/nvim/plugin/utils-fileselect-telescope.lua‖*NewBufˍmapsˍi



" ─   NewBuf from lsp ref                               ──

func! NewBuf_fromCursorLspRef( direction )
  let [direction; maybe_back ] = a:direction->split('_')
  let winview = winsaveview()
  let file = expand('%:p')
  let cmd = NewBufCmds( file )[ direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  call winrestview( winview )
  lua vim.lsp.buf.definition()
  if direction != "full"
    call T_DelayedCmd('normal zz', 300)
  endif

  " POST ACTION PHASE: 
  if     a:direction == 'tab_bg' 
    " delay the tabprevious call
    call T_DelayedCmd('tabprevious', 1000)
  " elseif a:direction == 'preview_back' 
    " preview jump back can actually be instant/ without flicker
    " wincmd p 
  else
    " delay all other _back jumps (as neo-tree seems to need this)
    if len( maybe_back ) | call T_DelayedCmd('wincmd p', 500) | endif
  endif
endfunc


" ─   Browse folder with neo-tree                       ──

func! Browse_parent( direction )
  let [direction; maybeBg ] = a:direction->split('_')
  " call AlternateFileLoc_save()
  " this captures the file-cursor loc the tree was spawned off of ->
  let captureAltFileLoc = LinkPath_linepos()
  let file = expand('%:p')  " might be a file or dirvish directory
  let parentFolderPath = ParentFolder( file )  " if a directory this will get the parent folder of the directory!
  let cmd = NewBufCmds( parentFolderPath )[ direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  " .. -> and sets it to a var local to the *new* window!
  let w:AlternateFileLoc = captureAltFileLoc
  call v:lua.Ntree_launch( file, parentFolderPath ) 
  if len( maybeBg ) | wincmd p | end
endfunc

func! Browse_cwd( direction )
  let [direction; maybeBg ] = a:direction->split('_')
  " call AlternateFileLoc_save()
  " this captures the file-cursor loc the tree was spawned off of ->
  let captureAltFile = LinkPath_linepos()
  let file = expand('%:p')  " might be a file or dirvish directory
  let cwd = getcwd()
  let cmd = NewBufCmds( cwd )[ direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  " .. -> and sets it to a var local to the *new* window!
  let w:AlternateFileLoc = captureAltFile
  " TODO: if a file is not in the cwd, do not attempt to reveal it
  call v:lua.Ntree_launch( file, cwd ) 
  if len( maybeBg ) | wincmd p | end
endfunc



" ─   NewBuf from self                                  ──

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
" Supporting 'LinkPaths', e.i. Might have an appended line link: #:<num> or #/<searchStr> or #*<headerStr> 

" Use this function for mappings in 
" divish, nvim-tree, LinkPaths in .md or source files
" to spin off a new folder or file buffer.
func! NewBuf_fromCursorLinkPath( direction, ... )
  let [path; maybeLinkExt] = 
     \ &filetype == 'neo-tree' ?
     \   [ a:0 ? a:1 : v:lua.Ntree_currentNode().linepath ] :
     \ &filetype == 'NvimTree' ?
     \   [ v:lua.Tree_cursorPath() ] :
     \   GetLongestWord_inLine()->split('‖')

  if &filetype == 'NvimTree' || &filetype == 'neo-tree'
    let [direction; maybe_back ] = a:direction->split('_')
    " do not run any post actions like wincmd p or tabprevious
    " this captures the file-cursor loc the tree was spawned off of ->
    let captureAltFile = LinkPath_linepos()
    let cmd = NewBufCmds( path )[ direction ] 
    exec cmd
    " .. -> and sets it to a var local to the *new* window!
    let w:AlternateFileLoc = captureAltFile
    " TREE POST ACTION PHASE: 
    if     a:direction == 'tab_bg' 
      " delay the tabprevious call
      call T_DelayedCmd('tabprevious', 50)
    elseif a:direction == 'preview_back' 
      " preview jump back can actually be instant/ without flicker
      wincmd p 
    else
      " delay all other _back jumps (as neo-tree seems to need this)
      if len( maybe_back ) | call T_DelayedCmd('wincmd p') | endif
    endif
  else
    " will run post actions like wincmd p or tabprevious right away.
    let cmd = NewBufCmds( path )[ a:direction ] 
    if IsInFloatWin() | wincmd c | endif
    exec cmd
    " Search for any file focus. Filesystem trees or dirvish don't provide links, but diagnostics, gitinfo and telescope will (TODO)
    if len(maybeLinkExt) | call Link_jumpToLine( maybeLinkExt[0] ) | endif
  endif
endfunc


func! NewBuf_fromClipPath( direction )
  let [path; maybeLinkExt] = @*->split('‖')
  let cmd = NewBufCmds( path )[ a:direction ] 
  if IsInFloatWin() | wincmd c | endif
  exec cmd
  if len(maybeLinkExt) | call Link_jumpToLine( maybeLinkExt[0] ) | endif
endfunc

func! NewBuf_fromScratchBuffer( direction )
  let path = '~/Documents/Notes/scratch/' . GetRandNumberString()
  if a:direction == 'float'
    call v:lua.FloatBuf_inOtherWinColumn( path, v:lua.Telesc_dynPosOpts() )
  else
    let cmd = NewBufCmds( path )[ a:direction ]
    if IsInFloatWin() | wincmd c | endif
    exec cmd
  endif
endfunc



func! NewBuf_fromReplBuffer( direction )
  if exists('g:ScalaRepl_bufnr')
    echo 'ScalaRepl is not running'
    return
  endif
  let bnr = g:ScalaRepl_bufnr
  if a:direction == 'float'
    call v:lua.FloatBuf_inOtherWinColumn( bnr, v:lua.Telesc_dynPosOpts() )
  else
    let cmd = a:direction == 'right'      ? 'vert sbuffer ' . bnr :
        \ a:direction == 'right_back' ? 'vert sbuffer ' . bnr . ' | wincmd p' :
        \ a:direction == 'up'         ? 'leftabove sbuffer ' . bnr :
        \ a:direction == 'up_back'    ? 'leftabove sbuffer ' . bnr . ' | wincmd p' :
        \ a:direction == 'left'       ? 'leftabove vert sbuffer ' . bnr :
        \ a:direction == 'left_back'  ? 'leftabove vert sbuffer ' . bnr . ' | wincmd p' :
        \ a:direction == 'full'       ? 'buffer ' . bnr :
        \ a:direction == 'preview'    ? 'wincmd p | buffer ' . bnr . ' | wincmd p' :
        \ a:direction == 'tab'        ? 'tab sbuffer ' . bnr :
        \ a:direction == 'tab_left'   ? 'tabnew | tabmove -1 | buffer ' . bnr :
        \ 'sbuffer ' . bnr
    exec cmd
  endif
endfunc


" DIRECTION IDS  <==>   BUF-open Commands:

func! NewBufCmds_templ(...)
  let winnr = a:0 ? a:1 : 0
  let mp = {}
  let mp['preview'] = 'wincmd p | edit _PATH_'
  let mp['preview_back'] = 'wincmd p | edit _PATH_ | wincmd p'
  let mp['float'] = 'call Path_Float( "_PATH_" )'
  let mp['float_spinoff'] = 'wincmd c | call Path_Float( "_PATH_" )'
  let mp['full']  = 'edit _PATH_'
  let mp['tab']   = 'tabedit _PATH_'
  let mp['tab_left']   = 'tabedit _PATH_ | tabmove -1'
  let mp['tab_bg'] = 'tabedit _PATH_ | tabprevious' " opened to the right in the background
  let mp['tab_back'] = 'tabedit _PATH_ | wincmd p' " open and go to new tab, then jump *back* to prompt
  let mp['tab_spinoff'] = 'wincmd c | tabedit _PATH_' " close window and open in new tab.
  let mp['right'] = 'vnew _PATH_'
  let mp['right_back'] = 'vnew _PATH_ | wincmd p'
  " let mp['left']  = 'leftabove 30vnew _PATH_'
  let mp['left']    = 'leftabove '. winwidth(winnr)/4 . 'vnew _PATH_'
  let mp['left_back'] = 'leftabove '. winwidth(winnr)/4 . 'vnew _PATH_ | wincmd p'
  " let mp['up']    = 'leftabove 20new _PATH_'
  " let mp['up']    = 'leftabove new _PATH_'
  let mp['up']   = 'leftabove '. winheight(winnr)/4 . 'new _PATH_'
  let mp['up_back'] = 'leftabove '. winheight(winnr)/4 . 'new _PATH_ | wincmd p'
  let mp['down']  = 'new _PATH_'
  let mp['down_back'] = 'new _PATH_ | wincmd p'
  return mp
endfunc


func! NewBufCmds( path, ... )
  let winnr = a:0 ? a:1 : 0
  return NewBufCmds_templ(winnr)->map( {_idx, cmdTmp -> substitute( cmdTmp, '_PATH_', a:path, "" )} )
endfunc
" NewBufCmds( "src" )
" Exec( NewBufCmds( ".gitignore" )["tab_bg"] )
" Exec( NewBufCmds( ".gitignore" )["float"] )
" Exec( NewBufCmds( "src" )["float"] )
" Exec( NewBufCmds( "src" )["down"] )

func! Exec( cmd )
  exec a:cmd
endfunc










