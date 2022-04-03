"    unmap all default mappings
let  g:dirvish_dovish_map_keys = 0

"    unmap dirvish default
"    unmap <buffer> p

"    Maps
nmap <silent><buffer> <leader>to <Plug>(dovish_create_file)
nmap <silent><buffer> <leader>mk <Plug>(dovish_create_directory)
nmap <silent><buffer> <leader>dd <Plug>(dovish_delete)
nmap <silent><buffer> <leader>re <Plug>(dovish_rename)
nmap <silent><buffer> <leader>yy <Plug>(dovish_yank)
xmap <silent><buffer> <leader>yy <Plug>(dovish_yank)
nmap <silent><buffer> <leader>pp <Plug>(dovish_copy)
nmap <silent><buffer> <leader>mv <Plug>(dovish_move)
