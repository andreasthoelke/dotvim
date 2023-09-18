
" ─   copilot settings                                  ──

imap <silent><script><expr> <c-j> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

imap <silent><script><expr> <c-o> copilot#Suggest()
imap <silent><script><expr> <c-u> copilot#Next()
imap <silent><script><expr> <c-c> copilot#Dismiss()

" ~/.config/nvim/colors/munsell-blue-molokai.vim‖/hi!ˍCopilot
" hi! CopilotSuggestion  guifg=#4A7780

let g:copilot_filetypes = {
                              \ '*': v:false,
                              \ }

                              " \ 'python': v:true,

" https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim/blob/main/README.md


" nmap <silent>            ,gd <Plug>(coc-definition)
" nmap <silent> \gd :vsplit<CR><Plug>(coc-definition)
" nmap <silent> gd :call FloatingBuffer(expand('%'))<CR><Plug>(coc-definition)
" nmap <silent> gD :split<CR><Plug>(coc-definition)

nnoremap <silent> gek :lua vim.lsp.buf.hover()<cr>
nnoremap <silent> gdd :lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gdo :call FloatingBuffer(expand('%'))<CR>:lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gdv :vsplit<CR>:lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gds :split<CR>:lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gdt :call TabNewFocus()<CR>:lua vim.lsp.buf.definition()<cr>

" nnoremap geR :Glance references<CR>
" nnoremap geD :Glance definitions<CR>
" nnoremap geY :Glance type_definitions<CR>
" nnoremap geM :Glance implementations<CR>

nnoremap <leader>lgr :Glance references<cr>
nnoremap <leader>lgd :Glance definitions<cr>
nnoremap <leader>lgt :Glance type_definitions<cr>
nnoremap <leader>lgi :Glance implementations<cr>


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
" nnoremap <leader>lds :TroubleToggle<cr>


" Using buffer maps here: ~/.config/nvim/plugin/tools_rescript.vim#/nnoremap%20<silent><buffer>%20ged
" nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
" Todo: make these maps general per languge and put them here or
" ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make


" This might be an interesting tool function. (otherwise i might use :Trouble)
func! DiagnosticsShow ()
  let resLines = v:lua.vim.lsp.diagnostic.get(0)
  let resLines = functional#map( 'string', resLines )
  " let resLines = SubstituteInLines( resLines, '\n', '' )
  " call FloatWin_ShowLines( resLines )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )

  " silent call FloatWin_FitWidthHeight()
  " silent wincmd p
endfunc

