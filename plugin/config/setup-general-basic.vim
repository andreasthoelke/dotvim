

" ─   Basic general settings                             ■

" set cmdheight=3
set ignorecase
" set fileencoding=utf-8
" set encoding=utf-8
" set backspace=indent,eol,start

" Use only spaces for indentation
set expandtab
set shiftwidth=2
set softtabstop=2
" http://vim.wikia.com/wiki/Indenting_source_code

" Makes whitespace be considered part to a filepath. this enables to use c-x c-f repeadedly to drill into paths.
" Issue: but now paths have to start at the beginning of the line.
" set isfname+=32
" set isfname-=32

set isfname+=@-@
" After this, <C-x><C-f>, gf, and similar file-related motions should handle paths like packages/@local/effect-learning/... correctly.
" packages/@local/effect-learning/a_scratch.ts

" prevents unnecessary execution when sourcing vimrc
if !exists("g:syntax_on")
  syntax enable
endif

set smartcase

" Not compatible with classic "vi" is ok
set nocompatible

" Note: this inverts what 'g' does in substitute!! avoid this
" set gdefault
set incsearch
set showmatch
" Allows to switch buffers without saving
set hidden
" set wrap
" set nowrap
" wrapmargin=0
" vim automatically breaks the line/starts a new line after 100 chars
" set textwidth=120

set sidescroll=5
set listchars+=precedes:<,extends:>

set noequalalways

" activate line wrapping for a window:
" command! -nargs=* Wrap set wrap linebreak nolist
" Todo: do I want linebreak and nolist?
" Update: linebreak avoids words being split across lines. so I want this, but when wrap is enabled?
" use "set wrap" and "set nowrap" instead?
" command! -nargs=* Wrap set wrap linebreak nolist
" use `gq<motion` or gqq to merely wrap a range/line

set linebreak

" Auto load files that have changed outside of vim! (only when there are no unsaved changes!). This requires
" tmux focus events "FocusGained".
set autoread

" This seems needed to reload files that have changed outside of vim (https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044)
" autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" au ag FocusGained,BufEnter * if mode() != 'c' | checktime | endif

augroup vim_focus_update
  autocmd!
  autocmd FocusGained,BufEnter * if mode() != 'c' | checktime | endif
augroup END
" au ag FocusGained,BufEnter * if mode() != 'c' | checktime | endif

" Issue: CursorHold would auto-reload the buffer in a split-window - but causes an error in search-window
" au ag CursorHold,FocusGained,BufEnter * if mode() != 'c' | checktime | endif
" autocmd FileChangedShellPost *
"   \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
" Issue: This is throwing an error in Command history window

set noswapfile
set cursorline

" Alacritty cursor color fix - workaround for cursor turning white on certain
" cells after scroll commands or backspace-to-previous-line in vertical splits.
" nnoremap <silent> zz zz:mode<CR>
" nnoremap <silent> zt zt:mode<CR>
" nnoremap <silent> zb zb:mode<CR>
" this works but causes a noticable 'bump' 
" augroup AlacrittyInsertLeaveFix
"   autocmd!
"   autocmd InsertLeave * silent! mode
" augroup END

" augroup CursorLine
"   au!
"   au VimEnter,WinEnter,BufWinEnter * setlocal nocursorline
"   au WinLeave * setlocal nocursorline
" augroup END


" set autochdir
" CAREFUL! this sets the current working directory the the current file on
" every buffer change!!

" TODO do I need all of these?
set wildignorecase
set smartcase
set ignorecase
set infercase
set wildmenu
set wildmode=longest:list,full
" Well behaved flat menu
" set wildmode=longest:full



" Tab navigate the file system while in insert mode
" inoremap <Tab> <c-x><c-f>
" In command mode use <c-d> and Tab

cnoremap <C-t> <C-\>e(<SID>RemoveLastPathComponent())<CR>
function! s:RemoveLastPathComponent()
  return substitute(getcmdline(), '\%(\\ \|[\\/]\@!\f\)\+[\\/]\=$\|.$', '', '')
endfunction

" set lazyredraw
set selection=inclusive
" this allows to move the cursor where there is no actual chracter
set virtualedit=all
" Console integration
" Send more characters for redraws
set ttyfast
" Enable mouse use in all modes
set mouse=a

" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
" set ttymouse=xterm2

set guioptions =
" set guioptions-=T
" set guioptions-=m
" set guioptions-=r
" set guioptions-=L
" " No graphical tabline in Macvim
" set guioptions-=e

" disable sounds
set noerrorbells
set novisualbell
" why this?
set t_vb=


" ─^  Basic general settings                             ▲

