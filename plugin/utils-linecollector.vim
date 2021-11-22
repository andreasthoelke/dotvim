
" LINE COLLECTOR: ---------------
" "leader cli" To start collecting lines, "leader cll" to collect the visual selection
nnoremap <leader>cli :call CollectLinesInit()<cr>
func! CollectLinesInit()
  " let g:colLinesFileName = tempname()
  let g:colLinesFileName = $HOME . '/.vim/notes/CollectedLines7.txt'
  exe 'vsplit' g:colLinesFileName
  " let g:colLineBufNr = bufnr('%')
  write
  call writefile( ['# Collected Lines 10:', ''], g:colLinesFileName, 'a' )
  edit
  " checktime
  wincmd p
endfunc
vnoremap <leader>cll :call CollectLine()<cr>
func! CollectLine() range
  let l:selText = Get_visual_selection()
  " * This actually uses the selected text not the lines
  " * This preserves the line breaks of multiline selections
  " * This can update the file while it's loaded in a buffer
  call system( 'echo ' . shellescape(l:selText) . ' >> ' . g:colLinesFileName )
  checktime
endfunc
" LINE COLLECTOR: ---------------
