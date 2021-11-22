" NyaoVim: {{{-----------------------
" Plug 'andreasthoelke/nyaovim-markdown-preview'
" Plug 'andreasthoelke/nyaovim-mini-browser'
" Plug 'andreasthoelke/nyaovim-popup-tooltip'

" Plug 'rhysd/nyaovim-popup-tooltip'
" Plug 'rhysd/nyaovim-mini-browser'
" Plug 'rhysd/nyaovim-markdown-preview'
" Plug 'rhysd/nyaovim-tree-view'
" }}}


" Change width of markdown viewer:
"  style="width: 640px"
"  max-width: 1500px;
"  width: 1500px;

" <canvas id="screen" width="1298" height="2100" style="width: 640px; height: 1050px;"></canvas>
" <style>:host {
"   width: auto;
"         height: auto;
"         max-width: 1500px;
"         overflow: auto;
" }
"
" #markdown-scroll-parent {
"   height: 1050px;

"         width: 1500px;

" }
"
" #markdown-root {
"   width: 100%;
"         height: 100%;
"         font-size=7
"         box-sizing: border-box;
"         margin: 0 auto;
"         padding: 10px;
" }

" </style>


" NyaoVim Markdown: ------------------------{{{
let g:markdown_preview_eager = 1
let g:markdown_preview_auto = 0
let g:markdown_preview_no_default_mapping = 1
nnoremap <leader>mp :call MarkdownPreviewToggle()<cr>
func! MarkdownPreviewToggle()
  if exists( "g:markdown_preview_active" )
    StopMarkdownPreview
    unlet g:markdown_preview_active
  else
    StartMarkdownPreview
    let g:markdown_preview_active = 1
  endif
endfunc
nnoremap <leader>kk <Plug>(markdown-preview-scroll-up)
nnoremap <leader>jj <Plug>(markdown-preview-scroll-down)
command! -nargs=1 NyaoVim exec ':Dispatch' 'npm run app --prefix ~/Documents/temp/NyaoVim --' <q-args>
command! OpenInNyaoVim exec ':Dispatch' 'npm run app --prefix ~/Documents/temp/NyaoVim --' expand('%:p')
nnoremap gln :OpenInNyaoVim<cr>


" This works. But scolling the current line to the top of the markdown preview. Would need to center screen and
" highlight that line. Problem is that Nyaovim lags a bit and the fonts are not as nice as in Alacritty
" augroup Mardownpreview
"   au!
"   autocmd CursorHold *.md call rpcnotify( 0, 'markdown-preview:scrollToLine', line('.') )
" augroup end


" NyaoVim Markdown: ------------------------

" NyaoVim Popup: ------------------------
let g:nyaovim_popup_tooltip_default_mapping = 1
" nnoremap <silent><leader>gi <Plug>(nyaovim-popup-tooltip-open)
" vmap <silent><localleader>gi <Plug>(nyaovim-popup-tooltip-open)
" Test: ~/Documents/logo.png
" NyaoVim Popup: ------------------------

" Scroll NyaoVim split wins with the same map, only if they are active
func! NyaoSplitScroll(direction)
  if exists( "g:markdown_preview_active" )
    call markdown_preview#scroll( a:direction )
  endif
  if exists( "g:mini_browser_active" )
    if a:direction == 'up'
      call rpcnotify( 0, 'mini-browser:scrollBy', 0, -50)
    else
      call rpcnotify( 0, 'mini-browser:scrollBy', 0, 50)
    endif
  endif
endfunc

func! NyaoSplitScrollTo(direction)
  if exists( "g:markdown_preview_active" )
    call markdown_preview#scroll( a:direction )
  endif
  if exists( "g:mini_browser_active" )
    if a:direction == 'top'
      call rpcnotify( 0, 'mini-browser:scrollTo', 0, 0)
    else
      call rpcnotify( 0, 'mini-browser:scrollTo', 0, 4000)
    endif
  endif
endfunc

" NyaoVim MiniBrowser: ------------------------
" nnoremap <leader>gx :<c-u>MiniBrowser! <c-r><c-p><cr>
" nnoremap <leader>gx :<c-u>Chromium <c-r><c-p><cr>
" TODO clean up
nnoremap <leader>gx :<c-u>Chromium1 <c-r><c-p><cr>
nnoremap <leader>bo :MiniBrowser!<cr>
nnoremap <leader>bc :MiniBrowserClose<cr>

" Note: have to copy these maps to ~/.vim/after/plugin/zmaps.vim because EasyClip is diffcult to control
nnoremap <silent> Y :call NyaoSplitScroll('up')<cr>
nnoremap <silent> E :call NyaoSplitScroll('down')<cr>
" nnoremap Y :call rpcnotify( 0, 'mini-browser:scrollBy', 0, -50)<cr>
" nnoremap E :call rpcnotify( 0, 'mini-browser:scrollBy', 0, 50)<cr>
" TODO map \e to 'big' E

nnoremap <silent> ,gg :call NyaoSplitScrollTo('top')<cr>
nnoremap <silent> ,G  :call NyaoSplitScrollTo('bottom')<cr>

nnoremap <silent> ,zz :call rpcnotify( 0, 'markdown-preview:scrollToLine', line('.') -12 )<cr>

" nnoremap ,gg :call rpcnotify( 0, 'mini-browser:scrollTo', 0, 0)<cr>
" nnoremap ,G  :call rpcnotify( 0, 'mini-browser:scrollTo', 0, 4000)<cr>


" call markdown_preview#setRootStyle( [
"                                   \ ['fontFamily', 'SF Pro Text'],
"                                   \ ['fontFamily', 'SF Pro Text'],
"                                   \ ])

func! MDSetRootStyle( id )
  call markdown_preview#setRootStyle( MDStyle( 'sf1' ) )
  echo rpcnotify( 0, 'markdown-preview:setRootStyle', MDStyle( 'sf1' ) )
endfunc

func! MDStyle( id )
  let styleOb = {}
  let styleOb['sf1'] = [
        \ 'fontFamily', 'SF Pro Text',
        \ 'fontSize', '79%',
        \ 'fontWeight', 400,
        \ 'letterSpacing', '.005em',
        \ 'lineHeight', 1.4,
        \ ]
  let styleOb['ny1'] = [
        \ ['fontFamily', 'New York Medium'],
        \ ['fontSize', '79%'],
        \ ['fontWeight', ''],
        \ ['letterSpacing', ''],
        \ ['lineHeight', 1.4],
        \ ]
  let selStyle = styleOb[ a:id ]
  return selStyle
endfunc
" echo MDStyle('sf1')[1][0]
" echo MDStyle('ny1')[0][1]

" Launch DevTools
nnoremap gld :call nyaovim#open_devtools('undocked')<cr>
nnoremap <leader>do :call nyaovim#open_devtools('undocked')<cr>
" Require Electorn API, close DevTools
nnoremap <leader>dc :call nyaovim#execute_javascript('(function(){ var win1 = require("electron").remote.getCurrentWindow(); win1.closeDevTools()})()')<cr>

function! Devdocs(query) abort
  if a:query ==# ''
    let cword = expand('<cword>')
    if cword ==# ''
      MiniBrowser! http://devdocs.io/
    else
      execute 'MiniBrowser!' 'http://devdocs.io/#q='.escape(cword, ' \')
    endif
    return
  endif
  execute 'MiniBrowser!' 'http://devdocs.io/#q='.escape(a:query, ' \')
endfunction
command! -nargs=* DevDocs call Devdocs(<q-args>)
" NyaoVim MiniBrowser: ------------------------}}}

" Oni: {{{----------------------------------
if exists('g:gui_oni')
  set nocompatible              " be iMproved, required
  filetype off                  " required

  set number
  set noswapfile
  set smartcase

  " Enable GUI mouse behavior
  set mouse=a

  " If using Oni's externalized statusline, hide vim's native statusline, 
  set noshowmode
  set noruler
  set laststatus=0
  set noshowcmd
endif

" }}} Oni: ----------------------------------


