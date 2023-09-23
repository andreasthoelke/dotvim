
" ─   Quickfix Loclist                                   ■

" Quickfix Navigation: - "leader qq", "]q" with cursor in code, "c-n/p" and "go" with cursor in quickfix list
" au ag BufWinEnter quickfix call QuickfixMaps()
augroup quickfix_maps
  autocmd!
  autocmd BufWinEnter quickfix call QuickfixMaps()
augroup END

func! QuickfixMaps()
  nnoremap <buffer> go :.cc<cr>:wincmd p<cr>
  nnoremap <buffer> Go :.ll<cr>:wincmd p<cr>
  nnoremap <buffer> <c-n> :cnext<cr>:wincmd p<cr>
  nnoremap <buffer> <c-p> :cprev<cr>:wincmd p<cr>
  nnoremap <buffer> <c-m> :lnext<cr>:wincmd p<cr>
  nnoremap <buffer> <c-i> :lprev<cr>:wincmd p<cr>
  nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  nnoremap <silent><buffer> P :PreviewClose<cr>
  nnoremap <silent><buffer> dd :call RemoveQFItem()<cr>
  " autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  " autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
endfunc

" nmap <leader>ll :lopen<cr>:Wrap<cr>
nnoremap <leader>ll :call Location_toggle()<cr>
" nmap <leader>qq :copen<cr>
" Todo: this get's overwrittern on quickfix refesh:
" nnoremap <leader>qq :copen<cr>:set syntax=purescript<cr>

nnoremap <silent><leader>qq :call QuickFix_toggle()<cr>
nnoremap <silent><leader>qa :call QFListAddCWord()<cr>
nnoremap <silent><leader>M  :call QFListAddCWord()<cr>

" Toggle quickfix window
function! QuickFix_toggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction

function! s:BufferCount() abort
  return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

" Toggle Location List window
function! Location_toggle()
  " https://github.com/Valloric/ListToggle/blob/master/plugin/listtoggle.vim
  let buffer_count_before = s:BufferCount()
  " Location list can't be closed if there's cursor in it, so we need
  " to call lclose twice to move cursor to the main pane
  silent! lclose
  silent! lclose
  if s:BufferCount() == buffer_count_before
    lopen
  endif
endfunction

" When using `dd` in the quickfix list, remove the item from the quickfix list.

function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  copen
endfunction
command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
" autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

" Note the maps here: ~/.config/nvim/plugin/setup-general.vim#/func.%20QuickfixMaps..

" Todo: Add a new QF entry after the current position. I might want to do this by creating the dictionary line from a
" template. Currently using the vimgrep approach to add to the QF list: see func! AddCWordToQFList
function! AddQFItem()
  " let qfall = getqflist()
  " call add(qfall, getline('.'))
  " call setqflist(qfall, 'r')
  " execute curqfidx + 1 . "cfirst"
  " copen
  " cfdo :call append( line('.'), getline('.'))
endfunction
" call append( line('.'), functional#map( {a -> string(a)}, getqflist() ) )
" {'lnum': 18, 'bufnr': 17, 'end_lnum': 0, 'valid': 1, 'vcol': 0, 'nr': 0, 'module': '', 'type': '', 'col': 12, 'end_col': 0, 'pattern': '', 'text': '- vs code, mpv'}
" {'lnum': 58, 'bufnr': 18, 'end_lnum': 0, 'valid': 1, 'vcol': 0, 'nr': 0, 'module': '', 'type': '', 'col': 14, 'end_col': 0, 'pattern': '', 'text': '" - vs code, mpv'}
" {'lnum': 40, 'bufnr': 19, 'end_lnum': 0, 'valid': 1, 'vcol': 0, 'nr': 0, 'module': '', 'type': '', 'col': 1, 'end_col': 0, 'pattern': '', 'text': 'mpv World\''s\ smallest\ cat\ ð¿°¨-\ BBC-W86cTIoMv2U.mp4'}


func! SetVisSelToLineRange( l1, l2 )
  let linelength = len( getline( a:l2 ) )
  call setpos( "'<", [0, a:l1, 0, 0] )
  call setpos( "'>", [0, a:l2, linelength, 0] )
  " normal! gv
endfunc
" call SetVisSelToCurrentLine( line('.'), line('.')+2 )
" Also note: ~/.config/nvim/plugin/HsMotions.vim#/func.%20SetVisSel.%20l1,

func! QFListAddCWord()
  call SetVisSelToLineRange( line('.'), line('.') )
  " exec "1lvimgrepa /" . expand('<cword>') . "/ %"
  " let cmd = ":vimgrep/\%(\%'<\|\%>'<\%<'>\|\%'>\)" . expand('<cword>') . "/ %"
  let cmd = "vimgrepa/\\%(\\%'<\\|\\%>'<\\%<'>\\|\\%'>\\)" . expand('<cword>') . "/j %"
  exec cmd
  " let cmd = escape(cmd, '\')
  " let cmd = ":vimgrepa/\\%(\\%'<\\|\\%>'<\\%<'>\\|\\%'>\\)" . expand('<cword>') . "/j %\n"
  " call feedkeys( cmd, 'n' )
  " copen
endfunc
" call SetVisSelToLineRange( line('.')-5, line('.') )
" vimgrep/\%(\%'<\|\%>'<\%<'>\|\%'>\)expand/ %
" call feedkeys( ":echo 'hi'\n", "n" )
" From https://stackoverflow.com/questions/21483847/is-it-possible-to-use-vimgrep-for-a-visual-selection-of-the-current-file
" Using :vimgrep to "easily" add to the qf-list
" So the approach it to search for the curent word under the cursor. But vimgrep starts to search from the beginning of
" the file. This is why the focus on the current selection is needed. The "j" flag prevent a jump.
" I had to double-escape the \ !!
" The feedkeys version also works but also needs the double quoted slashes


" ─^  Quickfix Loclist                                   ▲

