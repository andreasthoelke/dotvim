

augroup NeotestMappings
  autocmd!
  autocmd BufWinEnter,FileType * if &ft == "neotest-summary" | call NeotestBufferMaps() | endif
  autocmd FileType neotest-summary call NeotestBufferMaps()
augroup END


func! NeotestBufferMaps()
  nnoremap <silent><buffer> P  :call Neotest_JumpToTestFile_back()<cr>
endfunc


func! Neotest_JumpToTestFile_back()
  let [oLine, oCol] = getpos('.')[1:2]
  execute 'normal zz'
  execute 'normal p'
  wincmd p
  call setpos('.', [0, oLine, oCol, 0] )
endfunc


