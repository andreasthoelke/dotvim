" ─   fzf preview                                        ■

nmap <leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" Todo: configure the preview - hidden, size 60, linenum highlighted!
" I don't know how to switch the resources.
nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChanges<CR>
nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationList<CR>

" let g:fzf_preview_command = 'bat --color=always --plain {-1} --highlight-line {3} {1}'
" let g:fzf_preview_command = 'bat --style=numbers --color=always --highlight-line 1:1 {}'
" unlet g:fzf_preview_command
" put =g:fzf_preview_command
" Original:
" let g:fzf_preview_command = "bat --theme=ansi --color=always --plain --number {-1}"
" let g:fzf_preview_command = "bat --theme=ansi --color=always --plain --highlight-line 10 --number {-1}"

" let $FZF_PREVIEW_COMMAND="COLORTERM=truecolor bat --style=numbers --highlight-line 1:1 {} --color=always {}"
" unlet $FZF_PREVIEW_COMMAND

" FzfPreviewProjectMrwFiles
" FzfPreviewVistaBufferCtags
" FzfPreviewProjectGrep grep
" CocCommand fzf-preview.ProjectGrep grep

" This is not needed as the echo $COLORTERM
" augroup fzf_preview
"   autocmd!
"   autocmd User fzf_preview#remote#initialized call s:fzf_preview_settings() " fzf_preview#remote#initialized or fzf_preview#coc#initialized
" augroup END

" function! s:fzf_preview_settings() abort
"   let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command
"   let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
" endfunction

" echo g:fzf_preview_custom_processes['open-file']
" echo g:fzf_preview_custom_processes

nnoremap <Leader><leader>fg :<C-u>FzfPreviewProjectGrep --add-fzf-arg=--nth=3<space>
" echo fzf_preview#remote#process#get_default_processes('open-file', 'remote')



" ─^  fzf preview                                        ▲


