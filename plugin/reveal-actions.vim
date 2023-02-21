


nnoremap <silent> <c-f>



" Reveal action: Subject, Target Container
func! RevAct( sbj, tgtCnt )

  let subjectPath =
        \ a:sbj == 'cursor'    ? getline( '.' ) :
        \ a:sbj == 'parfolder' ? expand( '%:h' ) :
        \ a:sbj == 'prjroot'   ? "." :
        \ a:sbj == 'thisfile'  ? expand( '%:p' ) :
        \                      a:sbj . ' not implemented'

  let tgtCmd =
        \ a:tgtCnt == 'origin'     ? 'edit' :
        \ a:tgtCnt == 'top'        ? 'above 15new' :
        \ a:tgtCnt == 'right'      ? 'vnew' :
        \ a:tgtCnt == 'bottom'     ? 'new' :
        \ a:tgtCnt == 'left'       ? 'leftabove 30new' :
        \ a:tgtCnt == 'new_tab'    ? 'tabedit' :
        \ a:tgtCnt == 'float'      ? 'DirvishFloat1' :
        \ a:tgtCnt == 'telescope'  ? 'Telescope find_files default_text=' :
        \ a:tgtCnt == 'nvim-tree'  ? 'NvimTreeRevealFile' :
        \                         a:tgtCnt . ' not implemented'


  let floatWinMode = IsInFloatWin()
  if floatWinMode | wincmd p | endif


  if floatWinMode | wincmd p | endif
endfunc

  " let folder = expand('%:h')
  " let file = expand('%:p')
  " exec a:cmd folder
  " call search('\V\^'.escape(file, '\').'\$', 'cw')




















