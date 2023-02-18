

" Terminal: ------------------------------------------------------------------------
" open a terminal window
" nnoremap <silent> glt :below 20Term<cr>
" Demo Expression Map:
" In dirvish buffers use the filename % to cd terminal to this folder
" nnoremap <expr> glT (&ft=='dirvish') ? ':below 20Term! cd %<CR>' : ':below 20Term!<CR>'
nnoremap <silent><expr> glT (&ft=='dirvish') ? ':silent call TermInNextFolder(20)<cr>' : ':below 20Term!<cr>'
nnoremap <silent><expr> glt (&ft=='dirvish') ? ':silent call TermInNextFolder(v:false)<cr>' : ':below Term!<cr>'

func! TermInNextFolder (winsize)
  let folderpath = shellescape( CurrentNextFolderPath() )
  call Term( "cd " . folderpath, a:winsize, v:true)
  " call Term("cd '/Volumes/GoogleDrive/My Drive/temp'", 10, v:true)
endfunc

" TODO: Run commands in hidden buffers!
" glt     - runs the current line text in a hidden terminal buffer. find it in buffer list by the command string!
" nnoremap <silent><expr> glt (':Term ' . getline('.') . '<cr>:wincmd p<cr>')
" nnoremap <silent><expr> glt (':Term ' . input( 'Cmd: ' ) . ' ' . GetLineFromCursor() . '<cr>')
" nnoremap <silent><expr> gLt (':Term ' . input('Cmd: ', getline('.')) . '<cr>:wincmd p<cr>')
nnoremap <silent><expr> gLT (':Term! ' . input('Cmd: ', getline('.')) . '<cr>:wincmd p<cr>')


" nnoremap <silent> gwt :echo "Running terminal command .."<cr>:call T_DelayedCmd( "echo ''", 2000 )<cr>:call ShellReturn( GetLineFromCursor() )<cr>
nnoremap <silent> gwt :echo "Running terminal command .."<cr>:call T_DelayedCmd( "echo ''", 2000 )<cr>:call System_Float( getline('.') )<cr>
vnoremap gwt :<c-u>call ShellReturn( GetVisSel() )<cr>
nnoremap <leader><leader>gwt :call ShellReturn( input('Cmd: ', GetLineFromCursor() )) )<cr>

nnoremap gej :call RunTerm_showFloat()<cr>
nnoremap geJ :call TermOneShot_FloatBuffer( getline('.') )<cr>
nnoremap <leader>gej :call TermOneShot( getline('.') )<cr>

func! RunTerm_showFloat()
 echo "Running terminal command .."
 call T_DelayedCmd( "echo ''", 2000 )
 call System_Float( getline('.') )
endfunc

" ─   One shot async Terminal                            ■

nnoremap gwT :call TermOneShot( GetLineFromCursor() )<cr>
nnoremap ,gwt :call TermOneShot_FloatBuffer( GetLineFromCursor() )<cr>

func! TermOneShot( cmd )
  exec "8new"
  let g:TermID = termopen( a:cmd )
  normal G
endfunc
" The following line works (only) without shellescape()
" echo 'hi'

func! TermOneShotCB (job_id, data, event)
  let resLines = RemoveTermCodes( a:data )
  call append('.', resLines )
  silent call FloatWin_FitWidthHeight()
endfunc

func! TermOneShotCB_exit (job_id, data, event)
  call append('.', 'done' )
  silent wincmd p
  " silent call FloatWin_FitWidthHeight()
endfunc

let g:TermOneShotCBs = {
      \ 'on_stdout': function('TermOneShotCB'),
      \ 'on_stderr': function('TermOneShotCB'),
      \ 'on_exit': function('TermOneShotCB_exit')
      \ }

func! TermOneShot_FloatBuffer( cmd )
  echo "Running terminal command .."
  call T_DelayedCmd( "echo ''", 2000 )
  " silent let g:floatWin_win = FloatingSmallNew ( [ a:cmd . ': ..' ] )
  silent let g:floatWin_win = FloatingSmallNew ( [] )
  silent call FloatWin_FitWidthHeight()
  let g:TermID = jobstart( a:cmd, g:TermOneShotCBs )
endfunc





" ─^  One shot async Terminal                            ▲


" Else the cursor in the termanal is red when not in insert mode .. which is informative - but how to adjust the color/look?
hi! TermCursorNC guibg=grey guifg=white

" Terminal: ------------------------------------------------------------------------

" newer, recommended
func! System_Float( cmd )
  let resLines = systemlist( a:cmd )
  let resLines = RemoveTermCodes( resLines )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc

func! ShellReturn( cmd )
  " let resultLines = split( system( a:cmd ), '\n' )
  let resultLines = systemlist( a:cmd )
  call FloatWin_ShowLines( resultLines )
endfunc
" call ShellReturn( 'ls' )
" echo systemlist( 'ls' )

func! RunListOfCommands( list )
  for cmd in a:list
    call system( cmd )
  endfor
  echo 'Ran ' . len( a:list ) . ' commands'
endfunc
" call RunListOfCommands( ['touch temp', 'echo "drei" >> temp', 'echo "vier" >> temp'] )
" cat temp
" Example usage: ~/.config/nvim/plugin/code-line-props.vim#/Run%20list%20of




" TODO testing this as off! Keep term buffers running/open when closing the window might want to consider 'winfixheight'
" augroup custom_term
"   autocmd!
"   autocmd TermOpen * setlocal bufhidden=hide
" augroup END

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
  let count = a:count ? a:count : ''
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




" TERMINAL MODE: ----------------------------------------------------------
" nnoremap <leader>af ipwd<cr><C-\><C-n>kyy:cd <c-r>"<cr>
nnoremap <leader>af ipwd<cr><C-\><C-n>yy
nnoremap <leader>ag :cd <c-r>"<cr>

" jump window up from terminal mode
tnoremap <c-w>k <C-\><C-n><c-w>k
tnoremap <c-w>j <C-\><C-n><c-w>j
tnoremap <c-w>h <C-\><C-n><c-w>h
tnoremap <c-w>l <C-\><C-n><c-w>l
" Wipe the terminal buffer
tnoremap <silent><c-\>x <C-\><C-n>:bw!<cr>
nnoremap <silent><c-\>x <C-\><C-n>:bw!<cr>
tnoremap <c-w>c <C-\><C-n>:bw!<cr>

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








