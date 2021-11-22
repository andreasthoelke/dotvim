
" Terminal: ------------------------------------------------------------------------
" open a terminal window
" nnoremap <silent> glt :below 20Term<cr>
" Demo Expression Map:
" In dirvish buffers use the filename % to cd terminal to this folder
nnoremap <expr> glT (&ft=='dirvish') ? ':below 7Term! cd %<CR>' : ':below 7Term!<CR>'

nnoremap <silent><expr> glt (':Term ' . getline('.') . '<cr>:wincmd p<cr>')
nnoremap <silent><expr> gLt (':Term ' . input('Cmd: ', getline('.')) . '<cr>:wincmd p<cr>')
nnoremap <silent><expr> gLT (':Term! ' . input('Cmd: ', getline('.')) . '<cr>:wincmd p<cr>')


hi! TermCursorNC guibg=grey guifg=white

" Terminal: ------------------------------------------------------------------------


" NEOVIM TERMINAL MODE: ----------------------------------------------------------
if has('nvim')
  " nnoremap <leader>af ipwd<cr><C-\><C-n>kyy:cd <c-r>"<cr>
  nnoremap <leader>af ipwd<cr><C-\><C-n>yy
  nnoremap <leader>ag :cd <c-r>"<cr>

  " jump window up from terminal mode
  tnoremap <c-w>k <C-\><C-n><c-w>k
  " jump window down from terminal mode
  tnoremap <c-w>j <C-\><C-n><c-w>j
  " Wipe the terminal buffer
  tnoremap <silent><c-\>x <C-\><C-n>:bw!<cr>
  nnoremap <silent><c-\>x <C-\><C-n>:bw!<cr>
  tnoremap <c-w>c <C-\><C-n>:bw!<cr>
endif

command! RestartNodeJs call jobsend( b:terminal_job_id, "\<C-c>npm run server\<CR>")


function! OnEv1(job_id, data, event) dict
  normal }k

  "TODO: echoe a:data, if =~ '>' → filter out these lines

  if a:event == 'stdout'
    " call append(line('.'), a:data[0])
    if a:data[0] =~ 'Error'
      call append(line('.'), a:data)
    else
      call append(line('.'), a:data)
      " call append(line('.'), a:data[0])
    endif

  elseif a:event == 'stderr'
    call append(line('.'), a:data)
    " let str = self.shell.' stderr: '.join(a:data)
  else
    call append(line('.'), "Unknown event?!")
    " let str = self.shell.' exited'
  endif

  " call PurescriptUnicode()
endfunction

" jobsend(7, "ls\n")

" TODO:
" function! PursPaste(expr)
"   call jobsend(g:PursReplID, ":paste " . a:expr . "^D\n")
" endfun

function! PursEval(expr)
  call jobsend(g:PursReplID, a:expr . "\n")
endfun

function! PursType(expr)
  call jobsend(g:PursReplID, ":type " . a:expr . "\n")
endfun

let Cbs1 = {
      \ 'on_stdout': function('OnEv1'),
      \ 'on_stderr': function('OnEv1'),
      \ 'on_exit': function('OnEv1')
      \ }

" command! PursRepl :let PursReplID = jobstart("spago repl", Cbs1)

" let Tid = jobstart("ls")

"--*

" echo jobsend(g:Tid, "ls /n")

"--*

" ----------------------------------------------------------------------------------



" INSTALLING A PACKAGE REQUIRES:
" "bower install --save <packagename> | pulp build"
" "spago install <packagename> && spago build"
" command! -nargs=1 -complete=custom,PSCIDEcompleteIdentifier
"       \ PursInstall
"       \ echom jobstart("spago install " . <q-args> . " && spago build", Cbs1)


" nnoremap <leader>sx y$:echom <c-r>"<cr>

"com! -buffer -nargs=* -complete=custom,PSCIDEcompleteIdentifier
"       \ Ptype
"       \ call PSCIDEtype(len(<q-args>) ? <q-args> : PSCIDEgetKeyword(), v:true)
" com! -buffer -nargs=1 -complete=custom,PSCIDEcompleteIdentifier
"       \ Psearch
"       \ call PSCIDEsearch(len(<q-args>) ? <q-args> : PSCIDEgetKeyword())


" ----------------------------------------------------------------------------------
" 1. <leader>su to compile this script
" 2. run this line with <leader>sx
" jobstart("pulp repl", Cbs1)
" 3. check that the returned int is 7
" ----------------------------------------------------------------------------------


" Tested Terminal Examples:
" ":sp term://zsh"
" echo termopen('zsh')
" echo chansend(3,['ls', 'date', ''])
" let g:testvar2 = system( "date" ) | echo g:testvar2

" Launch a terminal in split: ":DemoTermArgs npm search purescript"
command! -nargs=* DemoTermArgs split | resize 20 | terminal <args>
" Quotes args example: ":DemoQ eins zwei" note no quotes are needed!
command! -nargs=* DemoQArgs echo split(<q-args>)

" new | resize 20 | let g:latest_term_id = termopen('zsh') | call chansend( g:latest_term_id,['ls', ''] )

command! -nargs=* T new | resize 20 | let g:latest_term_id = termopen('zsh') | call chansend( g:latest_term_id, [<q-args>, ''] )

command! -nargs=* Ts call chansend( g:latest_term_id, [<q-args>, ''] )

" source a JS function in a running node repl
" send visual selection chars as command and replace the selection with the return val.
" - or should this rather append after a "⇒"?

let g:termCount = 0

" Open Terminal buffer in horizontal split
command! -bang -count -nargs=* Term call Term(<q-args>, <count>, <bang>0)
fun! Term(args, count, bang)
  let cmd = "split "
  let count = a:count ? a:count : 7
  let cmd = count . cmd
  if a:args == ""
    let cmd = cmd . 'term://zsh'
  else
    let cmd = cmd . 'term://' . a:args . "&& zsh"
    " Note that only "&& zsh" allows to use the terminal after the first command has finished.
  endif
  exec cmd
  " exec 'startinsert'
  if a:bang | startinsert | endif
  let g:termCount += 1
  exec 'keepalt' 'file' ('term' . g:termCount . ':' . a:args)
  call OnTermOpen()
  if !a:bang | wincmd c | endif
endf

" TODO consider using https://github.com/kassio/neoterm

" helpers from https://github.com/jeromedalbert/dotfiles/blob/master/.vim/init.vim
if has('nvim')
  augroup on_display_events
    autocmd!
    autocmd TermOpen * call OnTermOpen()
  augroup end
endif



function! OnTermOpen()
  if &buftype != 'terminal' | return | endif
  setlocal nonumber norelativenumber colorcolumn=
  nnoremap <silent><buffer> G G{}
  " tnoremap <buffer> <Esc> <C-\><C-n>
endfunction

command! -range=0 FocusSelection call FocusSelection(<count>)
cabbrev focus FocusSelection
function! FocusSelection(visual)
  if !a:visual | return | endif
  let filetype = &filetype
  normal gv"zy
  enew
  exe 'set filetype=' . filetype
  normal "zpggdd
endfunction


noremap <leader><leader>ytw :call ToggleOption('wrap')<cr>
function! ToggleOption(option_name, ...)
  let option_scope = 'local'
  if a:0 | let option_scope = '' | endif
  exe 'let enabled = &' . a:option_name
  let option_prefix = enabled ? 'no' : ''
  exe 'set' . option_scope . ' ' . option_prefix . a:option_name
endfunction

" Keep term buffers running/open when closing the window
" might want to consider 'winfixheight'
augroup custom_term
  autocmd!
  autocmd TermOpen * setlocal bufhidden=hide
augroup END




