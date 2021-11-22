
" Todo: set purescript syntax!
" ~/.vim/plugged/coc.nvim/autoload/coc/util.vim#/call%20coc#util#do_autocmd.'CocOpenFloat'.

" autocmd! User CocOpenFloat call CocCustomFloatStyle()

" call nvim_set_current_win( g:coc_last_float_win )

" autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})
" autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)

" autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})

" TODO invalid win ID error
func! CocCustomFloatStyle()
  call nvim_win_set_option( g:coc_last_float_win, 'syntax', 'purescript1')
endfunc


" optional: change highlight, otherwise Pmenu is used
" call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')

command! -range=% ShowInFloatWin :<line1>,<line2>call ShowInFloatWin()

func! ShowInFloatWin() range
  let lines = getline( a:firstline, a:lastline )
  call FloatWin_ShowLines( lines, line('.'), col('.'), 120, 1 )
endfunc
" 4,11ShowInFloatWin

let testText1 = ["-- Partially applying a binary Type constructor (type level function) to a type wild card",
      \ "  -- Either _ ∷ * -> *",
      \ "",
      \ "mapToEither1 ∷ (a → b) → Either d a → Either d b",
      \ "mapToEither1 f (Right v)",
      \ "        = Right $ f v",
      \ "mapToEither1 _ (Left lv) = Left lv",
      \ "    where",
      \ "     some = eins" ]


let g:floatWin_scratchBuf_Id = 0
let g:floatWin_win = 0
let g:floatWin_win_Pers = 0


" let g:floatWin_scratchBuf_Id = nvim_create_buf( v:false, v:true )
" let g:floatWin_opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0, 'row': 1, 'anchor': 'NW'}
" let g:floatWin_opts = {'relative': 'cursor', 'width': 30, 'height': 30, 'col': 0, 'row': 1, 'anchor': 'NW'}
" let g:floatWin_win_Id = 0


" func! FloatWin_ShowLines1( lines )
"   call nvim_buf_set_lines( g:floatWin_scratchBuf_Id, 0, -1, v:true, a:lines )
"   let g:floatWin_win_Id = nvim_open_win( g:floatWin_scratchBuf_Id, 0, g:floatWin_opts )
" endfunc
" call FloatWin_ShowLines( ['eins', 'zwei drei'])
nnoremap <leader>abb :call nvim_win_close( g:floatWin_win, v:false )<cr>
nnoremap <leader>acc :call ExecRange( "ShowInFloatWin", 10, 20 )<cr>
nnoremap <leader>aff :call FloatWin_ShowLines( testText1 )<cr>
" let info = split(info, "\n", 1)

nnoremap <silent> <c-w>[ :call FloatWin_close()<cr>
" there is also a "<c-[>" map
" nnoremap <c-w>i :call nvim_set_current_win( g:coc_last_float_win )<cr>
nnoremap <silent> <c-w>i :call nvim_set_current_win( nvim_win_is_valid( g:coc_last_float_win ) ? g:coc_last_float_win : g:floatWin_win )<cr>gg
" nnoremap <c-w>i <Plug>(coc-float-jump)

nnoremap <silent> <c-w>I :call FloatWin_FitWidthHeight()<cr>

" Copied most parts from https://github.com/ncm2/float-preview.nvim

" let g:floatWin_winhl = 'Normal:Pmenu,NormalNC:Pmenu'
let g:floatWin_winhl = ''
let g:floatWin_max_height = 0
let g:floatWin_auto_close = 1
let g:floatWin_docked = 0

" only used for g:floatWin_docked == 0
let g:floatWin_max_width = 120

" Show lines in float-win at cursor loc by default. Or pass column, row for win relative position.
func! FloatWin_ShowLines( linesToShow, ... )
  if !len( a:linesToShow )
    return
  endif
  " TODO move this to intero
  if join( a:linesToShow ) =~ 'CInterrupted'
    return
  endif
  let opt = { 'focusable': v:true,
        \ 'width': 50,
        \ 'height': 10,
        \ 'anchor': 'NW'
        \}
  if a:0
    let opt.relative = 'win'
    let opt.col = a:1 -1
    let opt.row = a:2 -1
  else
    let opt.relative = 'cursor'
    let opt.col = 0
    let opt.row = 1
  endif

  " Create a scratch buffer on first invocaion:
  if !g:floatWin_scratchBuf_Id
    " unlisted-buffer & scratch-buffer (nobuflisted, buftype=nofile, bufhidden=hide, noswapfile)
    let g:floatWin_scratchBuf_Id = nvim_create_buf( v:false, v:true )
    call nvim_buf_set_option( g:floatWin_scratchBuf_Id, 'syntax', 'purescript1')
  endif

  " Just push the text into the buffer:
  call nvim_buf_set_lines( g:floatWin_scratchBuf_Id, 0, -1, 0, a:linesToShow )

  " TODO this could be replaced with the FloatWin_FitWidthHeight()? ■
  " if g:floatWin_docked
  "   let prevw_width = winwidth(0)
  " else
  "   let prevw_width = FloatWin_display_width( a:linesToShow, g:floatWin_max_width)
  " endif
  " let prevw_height = FloatWin_display_height( a:linesToShow, prevw_width )

  " let opt = { 'focusable': v:true,
  "       \ 'width': prevw_width,
  "       \ 'height': prevw_height
  "       \}
  " if g:floatWin_docked
  "   let opt.relative = 'win'
  "   let winline = winline()
  "   let winheight = winheight(0)
  "   " use down
  "   let opt.row = winheight - prevw_height
  "   let opt.col  = 0
  " else
  "   " let opt.relative = 'cursor'
  "   " let opt.col = 0
  "   " let opt.row = 1
  "   let opt.anchor = 'NW'
  "   " TODO there are many redundant options here. could focus this on just absolute positioning
  "   let opt.relative = 'win'
  "   let opt.col = a:locX
  "   let opt.row = a:locY + 1
  "   " let g:floatWin_opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0, 'row': 1, 'anchor': 'NW'}
  " endif ▲

  let winargs = [ g:floatWin_scratchBuf_Id, 0, opt ]

  " close the old one if already opened
  call FloatWin_close()

  let g:floatWin_win = call('nvim_open_win', winargs)
  call nvim_win_set_option(g:floatWin_win, 'foldenable', v:false)
  call nvim_win_set_option(g:floatWin_win, 'wrap', v:false)
  call nvim_win_set_option(g:floatWin_win, 'winhl', g:floatWin_winhl)
  call nvim_win_set_option(g:floatWin_win, 'number', v:false)
  call nvim_win_set_option(g:floatWin_win, 'relativenumber', v:false)
  call nvim_win_set_option(g:floatWin_win, 'cursorline', v:false)

  silent doautocmd <nomodeline> User FloatPreviewWinOpen

  echo 'hi'
  call FloatWin_FitWidthHeight()
  return g:floatWin_win
endfunc
" call FloatWin_ShowLines( ['eins', 'zwei'] )
" call FloatWin_ShowLines( testText1 )
" call FloatWin_ShowLines( testText1, col('.') -10, BufferLineToWinLine( line('.') +3) )

" Test this:
" autocmd User FloatPreviewWinOpen call DoSomething()

func! BufferLineToWinLine( bufferLineNum )
  let l:winview = winsaveview()
  call cursor( a:bufferLineNum, 0 )
  let winLine = winline()
  call winrestview(l:winview)
  return winLine
endfunc
" echo BufferLineToWinLine( line('.') ) == winline()

" func! BufferLineToWinLine_nofolds( bufferLineNum )
"   return a:bufferLineNum - winsaveview()['topline']
" endfunc
" echo BufferLineToWinLine( line('.') )

" nmap <leader>ccu <Plug>(coc-float-jump)

func! FloatWin_FitWidth()
  " get the current buffer lines
  let lines = nvim_buf_get_lines( g:floatWin_scratchBuf_Id, 0, line('$'), 0 )
  let newWidth = FloatWin_display_width( lines, g:floatWin_max_width )
  call FloatWin_SetProp( 'width', newWidth )
endfunc

func! FloatWin_SetProp( propName, val )
  call nvim_win_set_config( g:floatWin_win, { a:propName : a:val } )
endfunc
" call FloatWin_SetProp( 'height', 10 )

func! FloatWin_FitWidthHeight()
  let lines = nvim_buf_get_lines( g:floatWin_scratchBuf_Id, 0, line('$'), 0 )
  let newWidth = FloatWin_display_width( lines, g:floatWin_max_width )
  if newWidth
    call nvim_win_set_config( g:floatWin_win, { 'width' : newWidth, 'height': len( lines ) } )
  endif
endfunc


func! FloatWin_do( cmd )
  let originalWinHandle = nvim_get_current_win()
  call nvim_set_current_win( g:floatWin_win )
  exec a:cmd
  call nvim_set_current_win( originalWinHandle )
endfunc
" call FloatWin_do( 'normal! dd' )


func! s:auto_close()
  if g:floatWin_auto_close || !g:floatWin_docked
    call FloatWin_close()
  endif
endfunc

func! FloatWin_reopen()
  " call s:log('reopen')
  call FloatWin_close()
  call FloatWin_start_check()
endfunc

func! FloatWin_close()
  if g:floatWin_win
    let id = win_id2win(g:floatWin_win)
    if id > 0
      execute id . 'close!'
    endif
    let g:floatWin_win = 0
    let s:last_winargs = []
  endif
  " call coc#util#float_hide()
endfunc

func! FloatWin_display_width(lines, max_width)
  let width = 0
  for line in a:lines
    let w = strdisplaywidth(line)
    if w < a:max_width
      if w > width
        let width = w
      endif
    else
      let width = a:max_width
    endif
  endfor
  return width
endfunc

func! FloatWin_display_height(lines, width)
  " 1 for padding
  let height = 1

  for line in a:lines
    let height += (strdisplaywidth(line) + a:width - 1) / a:width
  endfor

  let max_height = g:floatWin_max_height ?
        \ g:floatWin_max_height : &previewheight

  return height > max_height ? max_height : height
endfunc

func! FloatWin__s(name, ...)
  if len(a:000)
    execute 'let s:' . a:name ' = a:1'
  endif
  return get(s:, a:name)
endfunc


" ─   More general Floating win                          ■

" use this with marks jumps: e.g. gz'M
nnoremap <silent> gz :call FloatingBuffer( "/Users/andreas.thoelke/.vim/notes/empty" )<cr>
" nnoremap <silent> gZ :call FloatingBuffer(expand('%'))<cr>
nnoremap <silent> gZ :call FloatingBuffer(expand('%'))<cr>

scriptencoding utf-8

" This function originates from https://www.reddit.com/r/neovim/comments/eq1xpt/how_open_help_in_floating_windows/; it isn't mine
function! CreateCenteredFloatingWindow() abort
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    let l:textbuf = nvim_create_buf(v:false, v:true)
    let g:floatWin_win = nvim_open_win(l:textbuf, v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
    return l:textbuf
endfunction

func! FloatingBuffer( filePath )
  let opts = { 'focusable': v:true,
        \ 'width': 65,
        \ 'height': 15,
        \ 'anchor': 'NW'
        \}
  let opts.relative = 'cursor'
  let opts.col = 0
  let opts.row = 1

  " let l:textbuf = nvim_create_buf(v:false, v:true)
  let g:floatWin_win_Pers = nvim_open_win( bufnr(a:filePath, v:true), v:true, opts)
  " let g:floatWin_win = nvim_open_win(l:textbuf, v:true, opts)
endfunc
" call FloatingBuffer( "/Users/andreas.thoelke/.vim/notes/links2" )
" call FloatingBuffer( "/Users/andreas.thoelke/.vim/notes/links" )
" let g:floatWin_win = nvim_open_win( "/Users/andreas.thoelke/.vim/notes/links", v:true, opts)
" call PreviewFileInFloatWin( "/Users/andreas.thoelke/.vim/notes/links" )

function! FloatingWindowHelp(query) abort
    let l:buf = CreateCenteredFloatingWindow()
    call nvim_set_current_buf(l:buf)
    setlocal filetype=help
    setlocal buftype=help
    execute 'help ' . a:query
endfunction

command! -complete=help -nargs=? Help call FloatingWindowHelp(<q-args>)

" func! FloatingBuffer ( filePath )
"   let l:buf = CreateCenteredFloatingWindow()
"   call nvim_set_current_buf(l:buf)
"   " setlocal filetype=help
"   execute 'e ' . a:filePath
" endfunc



" ─^  More general Floating win                          ▲






