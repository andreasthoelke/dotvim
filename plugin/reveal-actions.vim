

" nnoremap <silent> gkk    :call RevAct1( #{ act: 'RAedit', sbj: 'cursor' } )<cr>

" func! RevAct1( ev )
"   echo a:ev.act a:ev.sbj has_key(a:ev, 'some')
"   return 'hi'
" endfunc

" nnoremap <silent> gk<cr> :call RevAct("cursor", "this", "RAedit")<cr>
" nnoremap <silent> gku    :call RevAct("cursor", "this", "top")<cr>
" nnoremap <silent> gkv    :call RevAct("cursor", "this", "right")<cr>
" nnoremap <silent> gks    :call RevAct("cursor", "this", "bottom")<cr>
" nnoremap <silent> gky    :call RevAct("cursor", "this", "left")<cr>
" nnoremap <silent> gkt    :call RevAct("cursor", "this", "new_tab")<cr>
" nnoremap <silent> gko    :call RevAct("cursor", "this", "float")<cr>
" nnoremap <silent> gke    :call RevAct("cursor", "this", "telescope")<cr>
" nnoremap <silent> gkn    :call RevAct("cursor", "this", "RAtree")<cr>

" nnoremap <silent> gkp<cr> :call RevAct("cursor", "prev", "full")<cr>
" nnoremap <silent> gkpu    :call RevAct("cursor", "prev", "top")<cr>
" nnoremap <silent> gkpv    :call RevAct("cursor", "prev", "right")<cr>
" nnoremap <silent> gkps    :call RevAct("cursor", "prev", "bottom")<cr>
" nnoremap <silent> gkpy    :call RevAct("cursor", "prev", "left")<cr>
" nnoremap <silent> gkpt    :call RevAct("cursor", "prev", "new_tab")<cr>
" nnoremap <silent> gkpo    :call RevAct("cursor", "prev", "float")<cr>
" nnoremap <silent> gkpe    :call RevAct("cursor", "prev", "telescope")<cr>
" nnoremap <silent> gkpn    :call RevAct("cursor", "prev", "nvim-tree")<cr>

" nnoremap <silent> gkf<cr> :call RevAct("filefolder", "this", "full")<cr>
" nnoremap <silent> gkfu    :call RevAct("filefolder", "this", "top")<cr>
" nnoremap <silent> gkfv    :call RevAct("filefolder", "this", "right")<cr>
" nnoremap <silent> gkfs    :call RevAct("filefolder", "this", "bottom")<cr>
" nnoremap <silent> gkfy    :call RevAct("filefolder", "this", "left")<cr>
" nnoremap <silent> gkft    :call RevAct("filefolder", "this", "new_tab")<cr>
" nnoremap <silent> gkfo    :call RevAct("filefolder", "this", "float")<cr>
" nnoremap <silent> gkfe    :call RevAct("filefolder", "this", "telescope")<cr>
" nnoremap <silent> gkfn    :call RevAct("filefolder", "this", "nvim-tree")<cr>

" nnoremap <silent> gkr<cr> :call RevAct("prjroot", "this", "full")<cr>
" nnoremap <silent> gkru    :call RevAct("prjroot", "this", "top")<cr>
" nnoremap <silent> gkrv    :call RevAct("prjroot", "this", "right")<cr>
" nnoremap <silent> gkrs    :call RevAct("prjroot", "this", "bottom")<cr>
" nnoremap <silent> gkry    :call RevAct("prjroot", "this", "left")<cr>
" nnoremap <silent> gkrt    :call RevAct("prjroot", "this", "new_tab")<cr>
" nnoremap <silent> gkro    :call RevAct("prjroot", "this", "float")<cr>
" nnoremap <silent> gkre    :call RevAct("prjroot", "this", "telescope")<cr>
" nnoremap <silent> gkrn    :call RevAct("prjroot", "this", "nvim-tree")<cr>

" nnoremap <silent> gks<cr> :call RevAct("thisfile", "this", "full")<cr>
" nnoremap <silent> gksu    :call RevAct("thisfile", "this", "top")<cr>
" nnoremap <silent> gksv    :call RevAct("thisfile", "this", "right")<cr>
" nnoremap <silent> gkss    :call RevAct("thisfile", "this", "bottom")<cr>
" nnoremap <silent> gksy    :call RevAct("thisfile", "this", "left")<cr>
" nnoremap <silent> gkst    :call RevAct("thisfile", "this", "new_tab")<cr>
" nnoremap <silent> gkso    :call RevAct("thisfile", "this", "float")<cr>
" nnoremap <silent> gkse    :call RevAct("thisfile", "this", "telescope")<cr>
" nnoremap <silent> gksn    :call RevAct("thisfile", "this", "nvim-tree")<cr>

" nnoremap <silent> gkb<cr> :call RevAct("buildconf", "this", "full")<cr>
" nnoremap <silent> gkbu    :call RevAct("buildconf", "this", "top")<cr>
" nnoremap <silent> gkbv    :call RevAct("buildconf", "this", "right")<cr>
" nnoremap <silent> gkbs    :call RevAct("buildconf", "this", "bottom")<cr>
" nnoremap <silent> gkby    :call RevAct("buildconf", "this", "left")<cr>
" nnoremap <silent> gkbt    :call RevAct("buildconf", "this", "new_tab")<cr>
" nnoremap <silent> gkbo    :call RevAct("buildconf", "this", "float")<cr>
" nnoremap <silent> gkbe    :call RevAct("buildconf", "this", "telescope")<cr>
" nnoremap <silent> gkbn    :call RevAct("buildconf", "this", "nvim-tree")<cr>



" " Reveal action: Subject, Target Container
" func! RevAct( sbj, relTo, tgtCnt )

"   let subjPath =
"         \ a:sbj == 'cursor'     ? getline( '.' ) :
"         \ a:sbj == 'parfolder'  ? expand( '%:h' ) :
"         \ a:sbj == 'filefolder' ? "." :
"         \ a:sbj == 'thisfile'   ? expand( '%:p' ) :
"         \ a:sbj == 'buildconf'  ? 'build.sbt' :
"         \                      a:sbj . ' not implemented'

"   let tgtCmd =
"         \ a:tgtCnt == 'full'       ? 'edit' :
"         \ a:tgtCnt == 'top'        ? 'above 15new' :
"         \ a:tgtCnt == 'right'      ? 'vnew' :
"         \ a:tgtCnt == 'bottom'     ? '22new' :
"         \ a:tgtCnt == 'left'       ? 'leftabove 30new' :
"         \ a:tgtCnt == 'new_tab'    ? 'tabedit' :
"         \ a:tgtCnt == 'float'      ? 'Path_Float' :
"         \ a:tgtCnt == 'telescope'  ? 'Telescope find_files default_text=' :
"         \ a:tgtCnt == 'nvim-tree'  ? 'NvimTree_find_file' :
"         \                         a:tgtCnt . ' not implemented'

"   let currentFilePath = expand('%:p')

"   " if a:relTo == 'prev' | wincmd p | endif

"   " how can i apply to/call any global function lua/vimscript?
"   call call( a:tgtCnt, [subjPath] )

"   " if a:sbj == 'parfolder' && a:tgtCnt != 'telescope' && a:tgtCnt != 'nvim-tree'
"   "   call search('\V\^'.escape( currentFilePath, '\').'\$', 'cw')
"   " endif

"   " if a:relTo == 'prev' | wincmd p | endif
" endfunc


" func! RAedit(p)
"   exec 'edit' a:p
" endfunc

" func! RAtree(p)
"   v:lua.NvimTree_find_file(p)
" endfunc





































