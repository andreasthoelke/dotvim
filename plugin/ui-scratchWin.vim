" ─   Scratch Window                                     ■

" not sure if I still want this - the normal buffer version below seems better
command! ScratchWindow call ActivateScratchWindow( 'scratch' )

" Create or just activate/focus a disposable window
" TODO this currently writes a file names after bufferNameId - there is an option that would work without a written file
func! ActivateScratchWindow( bufferNameId )
  let bufNr = bufnr( a:bufferNameId )
  let winNr = bufwinnr( bufNr )

  " This makes sure we (1) have a buffer that (2) is visible and (3) the cursor is in it
  if bufNr == -1
    " There is no scratch buffer with 'bufferNameId' yet, so create a new buffer
    " this will also open a window (1)
    " exec 'new +resize20' . a:bufferNameId
    " exec 'botright 5new ' . a:bufferNameId
    exec 'belowright 5new ' . a:bufferNameId
    " exec 'keepalt silent botright vertical 30split | buffer! ' . bufNr
  else
    " In case there is a buffer, check if it's open in a win
    if winNr == -1
      " Open a split window of that buffer(nr) (2)
      exec 'sbuffer ' bufNr
    else
      " The win was already open
      if winNr != winnr()
        " The cursor is not already in that window, so jump to it (3)
        exec winNr . 'wincmd w'
      endif
    endif

  endif
  call MakeBufferDisposable()
  set filetype=purescript_scratch
  set syntax=purescript1
endfunc
" call ActivateScratchWindow('Test2')

" 
func! ScratchWin_Show( id, linesToShow )
  call ActivateScratchWindow( a:id )
  normal! ggVGd
  call append( line(1), a:linesToShow )
  exec 'normal! gg0'
endfunc
" call ScratchWin_Show( 'test1', ['hi there!', 'second line'] )
" call ScratchWin_Show( 'test1', ['.. just one line!'] )
" ─^  Scratch Window                                     ▲


func! ScratchWinNext_Show( linesToShow, resize )
  " let g:ScratchBufferCounter += 1
  " exec ('aboveleft new ~.vim/scratch/' . g:ScratchBufferCounter)
  exec ('aboveleft new ~/.vim/scratch/' . GetRandNumberString())
  " let filePath = GetNextScratchFilePath()
  " e ~/.vim/scratch/
  " exec ('belowright 5new Scratch' . g:ScratchBufferCounter)
  " call MakeBufferDisposable()
  set filetype=purescript_scratch
  set syntax=purescript1
  call append( line(1), a:linesToShow )

  if a:resize == 'auto'
    let l:height = min( [ 12, line('$') ] ) -1
  else
    let l:height = a:resize
  endif
  exec ('resize ' . l:height)
  exec 'normal! gg0'
endfunc
" call ScratchWinNext_Show(['eins zwei', 'drei'])

func! GetNextScratchFilePath()
  " project root
  " mkdir if not exsists
  " count files in dir
endfunc

" command! -range=% Scratchlines:<line1>,<line2>call ScratchlinesCmd()

command! -range=% Scratchlines call Scratchlines(<line1>,<line2>)

fun! ScratchlinesCmd () range
  call Scratchlines( a:firstline, a:lastline )
endfunc
" 4,11ScratchlinesCmd

func! ShowInFloatWin() range
  let lines = getline( a:firstline, a:lastline )
  call FloatWin_ShowLines( lines, line('.'), col('.'), 120, 1 )
endfunc


nnoremap <leader>oS :call ScratchWinNext_Show([], 7)<cr>

nnoremap <leader>os :let g:opContFn='Scratchlines'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
vnoremap <leader>os :<c-u>let g:opContFn='Scratchlines'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

func! Scratchlines( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  let l:lines = getline( startLine, endLine)

  call ScratchWinNext_Show( l:lines, 'auto' )
  " call PsShowLinesInBuffer( l:lines )
endfunc

" let winNr = bufwinnr( bufNr )
" let winNr = winnr()
" call nvim_win_set_config( winnr(), { 'height': 4 } )

func! GetRandNumberString ()
  return string(reltime()[1])[3:][:2]
endfunc

