" Conceal Google Docs links
" Use autocmd to persist matches across window changes

" Set conceallevel
setlocal conceallevel=2
setlocal concealcursor=nc

" Function to set up concealment
function! s:SetupGDocConceal()
  " Clear existing gdoc matches to avoid duplicates
  for m in getmatches()
    if m.group == 'Conceal' && (m.pattern =~ 'small' || m.pattern =~ 'docs')
      silent! call matchdelete(m.id)
    endif
  endfor

  " Add new matches
  call matchadd('Conceal', '\v\<small\>\<a href\="https://docs\.google\.com/[^"]*"\>')
  call matchadd('Conceal', '\v\</a\>\</small\>')
endfunction

" Set up autocmd to maintain concealment
augroup GDocConceal
  autocmd! * <buffer>
  autocmd BufWinEnter,WinEnter <buffer> call s:SetupGDocConceal()
augroup END

" Initial setup
call s:SetupGDocConceal()
