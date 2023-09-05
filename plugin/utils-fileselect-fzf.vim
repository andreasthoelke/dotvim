




" ─   fzf-vim                                            ■


" echo fzf#run({'source': 'ls'})
" echo fzf#wrap({'source': 'ls'})
" call fzf#run(fzf#wrap({'source': 'ls'}))
" FZF --reverse --info=inline plugin
" FZF --info=inline plugin
" FZF plugin

" shell command history. not sorted, 'tac'= reverse order
" history | fzf --tac --no-sort

" let g:spec1 = {
"   \ 'source': 'git ls-files',
"   \ 'sink': 'tabedit',
"   \ 'left': '40%',
"   \ 'options': '--multi --reverse'
"   \}

" let g:spec2 = {
"   \ 'source': g:testVimFilesnames,
"   \ 'sinklist': function('TestCollect'),
"   \ 'options': '--multi',
"   \ 'dir': '~/.vim/'
"   \}

func! ShowList (list)
  echo fzf#run( {'source': a:list, 'sink': function('TestEcho')} )
endfunc

let g:testCollection = ['eins', 'zwei', '/Users/at/Documents/Server-Dev/pothos/pothos/scratch/testSchema.graphql']
func! TestCollect (newItems)
  let g:testCollection += a:newItems
  call ShowList( g:testCollection )
endfunc

func! TestEcho (val)
  echo a:val
endfunc
" call TestEcho( 'hi there' )

" call fzf#run( g:spec2 )
" call fzf#run( fzf#wrap( "TestHistoryLabel1", g:spec2 ) )

" On :LS!, <bang> evaluates to '!', and '!0' becomes 1
command! -bang -complete=dir -nargs=? TestLS
      \ call fzf#run(fzf#wrap({'sinklist': function('TestCollect'), 'source': 'ls', 'dir': <q-args>}, <bang>0))

" TestLS /tmp

func! F_ReadOldFiles()
   return F_ReadLines( '~/.config/nvim/.vim_mru_files' )
endfunc

func! F_ReadLines( file )
  return readfile( a:file, '\n' )
endfunc

command! -bang -complete=dir -nargs=? FzfOldFilesCust1
      \ call fzf#run(fzf#wrap({'source': 'cat ~/.config/nvim/.vim_mru_files', 'dir': <q-args>}, <bang>0))

command! -bang -complete=dir -nargs=? FzfOldFilesCust2
      \ call fzf#run(fzf#wrap({'source': 'cat ~/.config/nvim/.vim_mru_files', 'dir': <q-args>, 'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0))

" {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}

command! -bang -complete=file -nargs=? FzfPathsFromFile
      \ call fzf#run(fzf#wrap({'source': 'cat '.shellescape(<q-args>), 'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0))

" This totally works:
" FzfPathsFromFile ~/.config/nvim/.vim_mru_files

" ─   Fzf config summary                                ──

" The command above shows how to read from a file (using the 'source' key) with a shell command. but I can also use a vim function call.
" Because 'sink' or 'sinklist' is not set, fzf uses the default file open features. like t to open in a tab.
" But you can use sinklist to call a function with a (tab selected) list of values!
" 'sinklist': function('TestCollect')



" Path completion with custom source command
" inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
" inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" Word completion with cu spec with popup layout option
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})


" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))


" Mapping selecting mappings
" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-l> <plug>(fzf-complete-line)


command! -bang -nargs=? -complete=dir FzfFilesCustom1
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)


command! -bang FzfDocuments call fzf#vim#files('~/Documents', fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir FzfDocsPath call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number -- '.shellescape(<q-args>), 0,
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" ─^  fzf-vim                                            ▲

" doesn't really work well. can't set
command! -bang -nargs=* TestFzfTags call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ "placeholder": "--tag {2}:{-1}:{3..}" }), <bang>0)

" command -nargs=? -bang TestGrep call fzf#vim#grep(command, [has_column bool], [spec dict], [fullscreen bool])

command! -bang -nargs=* TestRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading -U --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

command! -nargs=1 -bang FzfLocate call fzf#run(fzf#wrap(
      \ {'source': 'locate <q-args>', 'options': '-m'}, <bang>0))

" this let's me edit the seach word. but there seems to be a bug in that I can't search for multiple words?
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--layout=reverse', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)


command! -bang -nargs=? -complete=dir FzfOpenFiles
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

command! -bang -nargs=? -complete=dir FzfOpenHistory
    \ call fzf#vim#history(fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)


" The "--nth=3" option allows to match only the 3rd and following output fields
" rg -nSH . | fzf --nth=3..

" Preview config: --preview and --preview-window config options in shell script: ~/.vim/rg-fzf-vim.sh#/--preview%20'bat%20--color=always

" Multiline test: echo 'apple\norange\nbanana\nkiwi' | rg -U '(?s)orange.*kiwi' | fzf
" Interactive regex across multiple lines(?): ~/.vim/rg-fzf-restart.sh#/RG_PREFIX="rg%20--column%20-U
" Run with  ./rg-fzf-restart.sh marks.*something

" Press F1 to open the file with less without leaving fzf
" Press CTRL-Y to copy the line to clipboard and aborts fzf (requires pbcopy)
" fzf --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'
" See KEY BINDINGS section of the man page for details.

" Styling with colors: ~/.zshrc#/#%20Nice%20styling

" ─   Customization:                                     ■

let g:fzf_command_prefix = 'Fzf'

" Preview window on the upper side of the window with 40% height, hidden by default, ctrl-/ to toggle
" TODO: somehow this setting prevents that the preview is show when vim is in Alacritty terminal
" let g:fzf_preview_window = ['down:60%:hidden', 'ctrl-/']
let g:fzf_preview_window = ['down:66%']

let g:vista_fzf_preview = ['down:50%']

" This is the default extra key bindings
" let g:fzf_action = {
"   \ 'ctrl-t': 'tab split',
"   \ 'ctrl-x': 'split',
"   \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! Build_quickfix_list(lines)
  exec 'tab split'
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('Build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - Popup window (center of the screen)
" let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85} }
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.7} }
" - Popup window (center of the current window)
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }
" - Popup window (anchored to the bottom of the current window)
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }
" - down / up / left / right
" let g:fzf_layout = { 'up': '~70%' }
" - Window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme fzf#wrap translates this to a set of `--color` options
" More detailed info - https://github.com/junegunn/fzf/blob/master/README-VIM.md
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Normal'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" unlet g:fzf_colors

" Enable "per-command history" - History files will be stored in the specified directory When set, CTRL-N and CTRL-P will be bound to 'next-history' and 'previous-history' instead of 'down' and 'up'.
" Allows me to quickly go back to my past search queries.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" unlet g:fzf_history_dir

" ─^  Customization:                                     ▲

" Note the use of the local functions (therefore this file needs to be source with :so %)
function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! TestFZFLines call fzf#run({
\   'source':  <sid>buffer_lines(),
\   'sink':    function('<sid>line_handler'),
\   'options': '--extended --nth=3..',
\   'down':    '60%'
\})

function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

" CTRL-A to select all matches and list them in quickfix window
" CTRL-D to deselect all
command! -nargs=* TestFzAg call fzf#run({
\ 'source':  printf('ag --nogroup --column --color "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })


