"    unmap all default mappings
let  g:dirvish_dovish_map_keys = 0

nmap <silent><buffer> <leader>to <Plug>(dovish_create_file)
nmap <silent><buffer> <leader>mk <Plug>(dovish_create_directory)
nmap <silent><buffer> <leader>dd <Plug>(dovish_delete)
nmap <silent><buffer> <leader>ree <Plug>(dovish_rename)
nmap <silent><buffer> <leader>yy <Plug>(dovish_yank)
xmap <silent><buffer> <leader>yy <Plug>(dovish_yank)
nmap <silent><buffer> <leader>pp <Plug>(dovish_copy)
nmap <silent><buffer> <leader>mv <Plug>(dovish_move)

nnoremap <buffer> <leader><leader>im :call DirvishSortByModified()<cr>
nnoremap <buffer> ,,im :lua DirvishShowModified()<cr>
nnoremap <buffer> <leader><leader>is :call DirvishSortBySize()<cr>
nnoremap <buffer> ,,is :lua DirvishShowSize()<cr>

" 2023-09: use consistent direction maps
nnoremap <silent><buffer>o :call NewBuf_fromLine("float")<cr>
nnoremap <silent><buffer>i :call NewBuf_fromLine("full")<cr>
nnoremap <silent><buffer>t :call NewBuf_fromLine("tab")<cr>
nnoremap <silent><buffer>T :call NewBuf_fromLine("tab_bg")<cr>
nnoremap <silent><buffer>v :call NewBuf_fromLine("right")<cr>
nnoremap <silent><buffer>V :call NewBuf_fromLine("left")<cr>
nnoremap <silent><buffer>u :call NewBuf_fromLine("up")<cr>
nnoremap <silent><buffer>s :call NewBuf_fromLine("down")<cr>

" In a divish buffer I rarely use visual selection. but i'd want to use 'v' for splits
nnoremap <silent><buffer>,v v
nnoremap <silent><buffer>,V V
nnoremap <silent><buffer>,<c-V> <c-V>

nnoremap <silent><buffer>,u u




