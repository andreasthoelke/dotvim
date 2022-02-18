
" https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim/blob/main/README.md

lua <<EOF
-- require'toggle_lsp_diagnostics'.init()
-- require'toggle_lsp_diagnostics'.init({ start_on = true, signs = false, underline = false, virtual_text = { prefix = "|" }})
EOF


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
inoremap <silent><expr> <c-i> coc#refresh()

nnoremap <leader>lds :call DiagnosticsShow()<cr>

func! DiagnosticsShow ()
  call FloatWin_ShowLines( functional#map( 'string', v:lua.vim.lsp.diagnostic.get(0) ) )
endfunc





