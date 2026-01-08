" Semantic Web / Turtle LSP maps

func! Turtle_bufferMaps()

" ─   Lsp                                                ■

  nnoremap <silent><buffer> <leader>/   :lua require('telescope.builtin').lsp_document_symbols()<cr>
  nnoremap <silent><buffer> <leader>ot  :Outline<cr>

  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>
  nnoremap <silent><buffer>         geK :lua vim.lsp.buf.signature_help()<cr>

  nnoremap <silent><buffer> gsl :call v:lua.Telesc_launch('lsp_document_symbols')<cr>
  nnoremap <silent><buffer> gsL :call v:lua.Telesc_launch('lsp_dynamic_workspace_symbols')<cr>

  nnoremap <silent><buffer> ged :Trouble diagnostics toggle focus=false filter.buf=0<cr>
  nnoremap <silent><buffer> geD :Trouble diagnostics toggle focus=false<cr>

  nnoremap <silent><buffer> ger <cmd>Glance references<cr>
  nnoremap <silent><buffer> geR :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>

  nnoremap <silent><buffer> <leader>lr :lua vim.lsp.buf.rename()<cr>

endfunc
