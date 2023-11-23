" Vim-Bookmarks
" ~/.vim/plugged/vim-bookmarks/doc/bookmarks.txt

let g:bookmark_no_default_key_mappings = 1
let g:bookmark_auto_save = 0

let g:bookmark_sign = ''
let g:bookmark_annotation_sign = ''

" nmap <Leader>bb <Plug>BookmarkToggle
" nmap <Leader>ba <Plug>BookmarkAnnotate
nnoremap <leader>ba :call BookmarkAnnotate_save()<cr>
" nmap <Leader>bs <Plug>BookmarkShowAll
nmap <Leader>bn <Plug>BookmarkNext
nmap <Leader>bp <Plug>BookmarkPrev
" nmap <Leader>bc <Plug>BookmarkClear
nmap <Leader>bc :BookmarkClear_save()<cr>
nmap <Leader><Leader>bd :BookmarkClear_save()<cr>
" nmap <Leader>x <Plug>BookmarkClearAll
" nmap <Leader>bk <Plug>BookmarkMoveUp
" nmap <Leader>bj <Plug>BookmarkMoveDown
" nmap <Leader>g <Plug>BookmarkMoveToLine
" NOTE: there's also BookmarkClearAll

nnoremap <silent><leader>bs :call BookmarkTelescope_load()<cr>

func! BookmarkTelescope_load()
  call BookmarkLoad( "/Users/at/.vim-bookmarks", 0, 1 )
  lua TelBookmarks()
endfunc

func! BookmarkAnnotate_save()
  call BookmarkLoad( "/Users/at/.vim-bookmarks", 0, 1 )
  call BookmarkAnnotate()
  call BookmarkSave( "/Users/at/.vim-bookmarks", 1 )
endfunc

func! BookmarkClear_save()
  call BookmarkLoad( "/Users/at/.vim-bookmarks", 0, 1 )
  call BookmarkClear()
  call BookmarkSave( "/Users/at/.vim-bookmarks", 1 )
endfunc


