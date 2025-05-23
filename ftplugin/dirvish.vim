"    unmap all default mappings
let g:dirvish_dovish_map_keys = 0

nmap <silent><buffer> <leader>to <Plug>(dovish_create_file)
nmap <silent><buffer> <leader>mk <Plug>(dovish_create_directory)
nmap <silent><buffer> <leader>dd <Plug>(dovish_delete)
" nmap <silent><buffer> <leader>ree <Plug>(dovish_rename)
" nmap <silent><buffer> <leader>lr <Plug>(dovish_rename)
nmap <silent><buffer> <leader>yy <Plug>(dovish_yank)
xmap <silent><buffer> <leader>yy <Plug>(dovish_yank)
nmap <silent><buffer> <leader>pp <Plug>(dovish_copy)
nmap <silent><buffer> <leader>mv <Plug>(dovish_move)

nnoremap <buffer> <leader><leader>om :call DirvishSortByModified()<cr>
nnoremap <buffer> <leader><leader>os :call DirvishSortBySize()<cr>
nnoremap <buffer> ,,is :lua DirvishShowSize()<cr>

nnoremap <silent><buffer> - <Plug>(dirvish_up)



" ─   NewBuf from path                                   ■
" In dirvish i can use these standardized direction maps without prefix

nnoremap <silent><buffer>p :call NewBuf_fromCursorLinkPath("preview_back")<cr>
nnoremap <silent><buffer>o :call NewBuf_fromCursorLinkPath("float")<cr>
" then this is in a float the default is to jump to the origin win. so this is kind of a hack. see the comment in NewBuf_fromCursorLinkPath.
nnoremap <silent><buffer>i :call NewBuf_fromCursorLinkPath("full")<cr>
" currently overwritten. see ~/.config/nvim/plugin/config/dirvish.vim‖:48:3
nnoremap <silent><buffer>I :call NewBuf_fromCursorLinkPath("full_bg")<cr>
nnoremap <silent><buffer>tn :call NewBuf_fromCursorLinkPath("tab")<cr>
nnoremap <silent><buffer>tt :call NewBuf_fromCursorLinkPath("tab_bg")<cr>
nnoremap <silent><buffer>Tn :call NewBuf_fromCursorLinkPath("tab_left")<cr>
nnoremap <silent><buffer>Tt :call NewBuf_fromCursorLinkPath("tab_left_bg")<cr>
" _
nnoremap <silent><buffer>v :call NewBuf_fromCursorLinkPath("right")<cr>
nnoremap <silent><buffer>V :call NewBuf_fromCursorLinkPath("right_back")<cr>
nnoremap <silent><buffer>a :call NewBuf_fromCursorLinkPath("left")<cr>
nnoremap <silent><buffer>u :call NewBuf_fromCursorLinkPath("up")<cr>
nnoremap <silent><buffer>U :call NewBuf_fromCursorLinkPath("up_back")<cr>
nnoremap <silent><buffer>s :call NewBuf_fromCursorLinkPath("down")<cr>
nnoremap <silent><buffer>S :call NewBuf_fromCursorLinkPath("down_back")<cr>

" nnoremap <silent><buffer><c-]>     :call v:lua.Tree_expandFolderInRootPath( getline('.'), expand('%:p') )<cr>
nnoremap <silent><buffer><c-]>     :call v:lua.Ntree_launch( getline('.'), expand('%:p') )<cr>

nnoremap <silent><buffer><c-]>     :call v:lua.Ntree_launch( getline('.'), expand('%:p') )<cr>
nnoremap <silent><buffer> <leader>Os   :exec "silent !open " .. getline('.')<cr>

" nnoremap <silent><buffer><c-space> :call v:lua.Ntree_launch( getline('.'), expand('%:p') )<cr>
nnoremap <silent><buffer><c-space> :call v:lua.Ntree_launchToAltView_saveAltFileLoc()<cr>


" ─^  NewBuf from path                                   ▲


" In a divish buffer I rarely use visual selection. but i'd want to use 'v' for splits
" .. i don't understand these maps or comment.
nnoremap <silent><buffer> <localleader>v v
nnoremap <silent><buffer> <localleader>V V
nnoremap <silent><buffer> <localleader><c-V> <c-V>

nnoremap <silent><buffer> <localleader>u u




