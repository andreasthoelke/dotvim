

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

nnoremap <silent>gwj :call RunTerm_showFloat()<cr>
nnoremap <silent>gwJ :call RunTerm_parag_showFloat()<cr>
nnoremap <silent>,gwj :call TermOneShotFloat( getline('.') )<cr>
" nnoremap <silent><leader>gwj :call TermOneShot( getline('.') )<cr>
nnoremap <silent><leader>gwj :call RunTerm_showTerm()<cr>

nnoremap <silent><leader><leader>sd :call StartDevServer()<cr>
nnoremap <silent><leader><leader>sD :call StopDevServer()<cr>
nnoremap <silent><leader><leader>sr :call RestartDevServer()<cr>


func! RunTerm_showFloat()
 let line = matchstr( getline("."), '\v^(\s*)?(\/\/\s|\"\s|#\s|--\s)?\zs\S.*' ) 
 " echo line
 " return
 call System_Float( line )
endfunc

func! RunTerm_parag_showFloat()
 let [startLine, endLine] = ParagraphStartEndLines()
 let lines = getline(startLine, endLine)
 let concat_cmd = join( lines, ' ' )
 " let concat_cmd = join( lines, '\n' )
 call System_Float( concat_cmd )
endfunc


func! RunTerm_showTerm()
 let cmdline = matchstr( getline("."), '\v^(\s*)?(\/\/\s|\"\s|#\s|--\s)?\zs\S.*' ) 
 echo "running cmd: " . cmdline
 exec "26new"
 let opts = { 'cwd': getcwd( winnr() ) }
 let g:TermID = termopen( cmdline, opts )
 normal G
endfunc

func! StartDevServer()
  if exists('g:Vite1TermID')
    echo 'Vite1TermID is already running'
    return
  endif
  let cmdline = 'npm run dev'
  " echo "running cmd: " . cmdline
  exec "20new"
  let opts = { 'cwd': getcwd( winnr() ) }
  let g:Vite1TermID = termopen( cmdline, opts )

  call T_DelayedCmd( "call StartDevServer_resume()", 2000 )
endfunc
" v:lua.require('tools_external').Get_keyval('vite.config.ts', 'port')


func! StartDevServer_resume()

  " get the current buffer text
  let currentBufferText = getline(1, '$')
  " echo currentBufferText
  " ['', '> next-openai@0.0.0 dev', '> next dev', '', '   ▲ Next.js 15.3.3', '   - Local:        http://localhost:3000',
  " '   - Network:      http://192.168.2.124:3000', '   - Environments: .env.local', '', ' ✓ Starting...', '']

  let port = ''
  " let currentBufferText = ['', '> next-openai@0.0.0 dev', '> next dev', '', '   ▲ Next.js 15.3.3', '   - Local: http://localhost:3000', "   - Network:      http://192.168.2.124:3000", '   - Environments: .env.local', '', ' ✓ Starting...', '']

  for line in currentBufferText
    let localhost_pos = stridx(line, 'localhost:')
    if localhost_pos != -1
      let port_start = localhost_pos + len('localhost:')
      let port = strpart(line, port_start)
      " Remove any trailing characters that aren't part of the port
      let port = matchstr(port, '\d\+')
      break
    endif
  endfor

  if port == ''
    echo 'port not found in term buffer'
    return
  endif
  " echo port

  normal G
  " close the window without closing the terminal buffer
  silent wincmd c
  " call LaunchChromium( "http://localhost:5173/" )
  " let isNextJsProject = filereadable( getcwd() . '/pyproject.toml' )

  " let port = v:lua.require('tools_external').Get_keyval('vite.config.ts', 'port')

  call LaunchChrome( "http://localhost:" . port )
endfunc


func! StopDevServer ()
  if !exists('g:Vite1TermID')
    echo 'Vite1TermID is not running'
    return
  endif
  call jobstop( g:Vite1TermID )
  unlet g:Vite1TermID
  echo 'Vite1TermID closed!'
endfunc

func! RestartDevServer ()
  if exists('g:Vite1TermID')
    call StopDevServer()
  endif
  call StartDevServer()
endfunc



" ─   One shot async Terminal                            ■

nnoremap gwT :call TermOneShot( GetLineFromCursor() )<cr>
nnoremap ,gwt :call TermOneShot_FloatBuffer( GetLineFromCursor() )<cr>

func! TermOneShot( cmd )
  exec "16new"
  let opts = { 'cwd': getcwd( winnr() ) }
  let g:TermID = termopen( a:cmd, opts )
  normal G
endfunc
" The following line works (only) without shellescape()
" echo 'hi'

func! TermOneShotFloat( cmd )
  silent let g:floatWin_win = FloatingTerm()
  let g:TermID = termopen( a:cmd )
  " normal G
  call T_DelayedCmd( "call FloatWin_FitWidthHeight()", 500 )
endfunc
" NOTE: the above works with some httpie requests, where systemlist fails:
" http -v post localhost:8080/cities city=London country=UK


func! TermOneShotCB (job_id, data, event)
  let resLines = RemoveTermCodes( a:data )
  call append(line('$'), resLines )
  silent call FloatWin_FitWidthHeight()
endfunc

func! TermOneShotCB_exit (job_id, data, event)
  " call append('.', 'done' )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc

let g:TermOneShotCBs = {
      \ 'on_stdout': function('TermOneShotCB'),
      \ 'on_stderr': function('TermOneShotCB'),
      \ 'on_exit': function('TermOneShotCB_exit')
      \ }

" NOTE this one keeps appending lines to a floating buffer. while TermOneShot is a term buffer
func! TermOneShot_FloatBuffer( cmd )
  " echo "Running terminal command .."
  " call T_DelayedCmd( "echo ''", 2000 )
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
  silent let g:floatWin_win = FloatingSmallNew ( resLines, "cursor" )
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
















