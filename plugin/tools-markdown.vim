
" Plugins config:

" ─   Markdown-Preview                                   ■

nnoremap glm :call StopChromium()<cr>:MarkdownPreview<cr>
nnoremap gsm :call StopChromium()<cr>


let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_command_for_global = 1

" let g:mkdp_browser = '/Applications/Chromium.app/Contents/MacOS/Chromium'
" this function will receive url as param
let g:mkdp_browserfunc = 'LaunchChromium'

let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'relative',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {}
    \ }

" Status:
" On ":MarkdownPreview" this opens Chromium in frameless (--app) window.
" On the first run I need to position Chromium
" Chromium need an F5 reload so Vimium can be used in Chromium
" TODO set up start- and stop maps. the stop map should also stop/reset the LaunchChromium job
" also see ## NOTES .MD EDITOR in ~/.vim/notes/notes-todos.md

" ─^  Markdown-Preview                                   ▲


" ─   Markdown-Composer                                  ■

let g:markdown_composer_autostart = 0

" https://github.com/euclio/vim-markdown-composer
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

" This also updates on keystroke and has Pandoc support!
" but developing the scrolling feature might be tricky as it's all Rust?


" ─^  Markdown-Composer                                  ▲


" ─   Other Config                                       ■

let g:vim_markdown_follow_anchor = 1
" Just a fix, because insert-mode return creates an indented list?
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_no_extensions_in_markdown = 0
" let g:vim_markdown_edit_url_in = 'vsplit'
let g:vim_markdown_anchorexpr = "'# '.v:anchor"
let g:vim_markdown_anchorexpr = "v:anchor"

augroup markdown_config
  autocmd!
  " Example: buffer local maps. Note: <Plug> maps don't work with "noremap"!
  " Follow a markdown hyperlink, add position to jumplist to allow "c-o" to jump back
  autocmd FileType markdown nmap <silent><buffer> <c-]> m'<Plug>Markdown_EditUrlUnderCursor
augroup END


" ─^  Other Config                                       ▲



" ─   Simple Grip Server in Chromium                     ■

" This works! Opens a terminal with the running grip server process and moves the cursor to the browser
command! Demo1Markdown Dispatch grip -b %
" But below is better - hides the terminal

" 
command! Markdown :call OpenMarkdownPreview()
" nnoremap glm :call OpenMarkdownPreview()<cr>

" function! OpenMarkdownPreview() abort
"   " stops any previous/running job!
"   if exists('s:markdown_job_id')
"     silent! call jobstop(s:markdown_job_id)
"     unlet s:markdown_job_id
"   endif
"   let s:markdown_job_id = jobstart(
"     \ 'grip ' . shellescape(expand('%:p')) . " 0 2>&1 | awk '/Running/ { printf $4 }'",
"     \ { 'pty': 1, 'on_stdout': {_, output → system('open ' . output[0])} }
"     \ )
" endfunction

" a simpler version of the above
function! OpenMarkdownPreview() abort
  if exists('g:markdown_job_id') && g:markdown_job_id > 0
    call jobstop(g:markdown_job_id)
    unlet g:markdown_job_id
  endif
  " let g:markdown_job_id = jobstart('grip ' . shellescape(expand('%:p')))
  let g:markdown_job_id = jobstart('grip ' . g:accountsGithub . ' ' . shellescape(expand('%:p')))
  if g:markdown_job_id <= 0 | return | endif
  " call system('open http://localhost:6419')
  call LaunchChromium( 'http://localhost:6419' )
endfunction

" ─^  Simple Grip Server in Chromium                     ▲


