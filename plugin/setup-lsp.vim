
" https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim/blob/main/README.md

lua <<EOF
-- require'toggle_lsp_diagnostics'.init()
-- require'toggle_lsp_diagnostics'.init({ start_on = true, signs = false, underline = false, virtual_text = { prefix = "|" }})
EOF


" nmap <silent>            ,gd <Plug>(coc-definition)
" nmap <silent> \gd :vsplit<CR><Plug>(coc-definition)
" nmap <silent> gd :call FloatingBuffer(expand('%'))<CR><Plug>(coc-definition)
" nmap <silent> gD :split<CR><Plug>(coc-definition)

nnoremap <silent> gdd :LspDef<cr>
nnoremap <silent> gdo :call FloatingBuffer(expand('%'))<CR>:LspDef<cr>
nnoremap <silent> gdv :vsplit<CR>:LspDef<cr>
nnoremap <silent> gds :split<CR>:LspDef<cr>


nmap <leader>ltu <Plug>(toggle-lsp-diag-underline)
nmap <leader>lts <Plug>(toggle-lsp-diag-signs)
nmap <leader>ltv <Plug>(toggle-lsp-diag-vtext)
nmap <leader>ltp <Plug>(toggle-lsp-diag-update_in_insert)
nmap <leader>ltd  <Plug>(toggle-lsp-diag)

" Issue: ToggleDiagDefault only works via the Command!?
nmap <leader>ltD  :ToggleDiagDefault<cr>
" nmap <leader>ltdd <Plug>(toggle-lsp-diag-default)
nmap <leader>ltdo <Plug>(toggle-lsp-diag-off)
nmap <leader>ltdf <Plug>(toggle-lsp-diag-on)

" ─   coc-nvim                                          ──
" https://github.com/neoclide/coc.nvim/blob/master/README.md
let g:coc_config_home = '~/.config/nvim'
" ~/.coc-settings.json
" old settings: ~/.config/nvim/plugin/tools-langClientHIE-completion.vim.bak#/let%20g.coc_config_home%20=

" Coc's completion menu can itegrate many sources (like webbrowser, buffer, lsp).
" inoremap <silent><expr> <c-i> coc#refresh()
inoremap <silent><expr> <Tab> coc#refresh()
" nnoremap <Tab> :echo "hi4"<cr>

nnoremap <leader>lds :call DiagnosticsShow()<cr>

func! DiagnosticsShow ()
  call FloatWin_ShowLines( functional#map( 'string', v:lua.vim.lsp.diagnostic.get(0) ) )
endfunc

" autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})
" autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)

" inoremap <expr> <c-i> pumvisible() ? "\<C-o>coc#_hide()" : "<c-i>"

" doesn't work
" call CocAction('runCommand', 'editor.action.organizeImport')












