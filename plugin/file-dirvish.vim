

" ─   Dirvish 'newWin' maps                             ──
" TODO: might want to make these consistent with: ~/.config/nvim/plugin/utils-fileselect-telescope.lua#/["<c-s><c-u>"]%20=%20open_above,
" TODO: might want to make these consistent with: ~/.config/nvim/plugin/file-manage.vim#/Dirvish%20'newWin'%20maps


nnoremap <silent> <leader>-  :Dirvish .<cr>
nnoremap <silent> ,o         :call Dirvish_Float( expand("%:h") )<cr>
nnoremap <silent> ,,o        :call Dirvish_Float( getcwd() )<cr>
nnoremap <silent> ,v         :call Dirvish_newWin( "vnew" )<cr>
nnoremap <silent> ,,v        :exec "vnew ."<cr>
nnoremap <silent> ,V         :call Dirvish_newWin( "leftabove 30vnew" )<cr>
nnoremap <silent> ,,V        :exec "leftabove 30vnew ."<cr>
nnoremap <silent> ,tn        :call Dirvish_newWin( "tabe" )<cr>
nnoremap <silent> ,,tn       :exec "tabe ."<cr>
nnoremap <silent> ,sn        :call Dirvish_newWin( "new" )<cr>
nnoremap <silent> ,,sn       :exec "new ."<cr>
nnoremap <silent> ,Sn        :call Dirvish_newWin( "above 13new" )<cr>
nnoremap <silent> ,,Sn       :exec "above 13new ."<cr>


nnoremap <silent> ,<leader>v :exec "vnew " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <leader>,v :exec "vnew " . GetFullLine_OrFromCursor()<cr>

nnoremap <silent> <c-w>F :exec "vnew " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>v :exec "vnew " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>s :exec "new " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>t :exec "tabedit " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>o :call FloatingBuffer( GetFullLine_OrFromCursor() )<cr>




" nnoremap <leader>of :FzfPreviewGitFiles<cr>
" nnoremap <leader>of :CocCommand fzf-preview.GitFiles<cr>
" nnoremap <leader>oF :FzfGFiles<cr>



" ─   Dirvish                                            ■

" Example of how to set up custom maps
" autocmd FileType dirvish nnoremap <buffer><silent> <c-p> :CtrlP<cr>

" let g:dirvish_mode = ':sort ,^.*[\/],'
" let g:dirvish_mode = 2
let g:dirvish_mode = ":call DirvishSetup2()"

nnoremap <leader><leader>df :call Dirvish_filter_toggle()<cr>
let g:dirvish_filter = v:true
func! Dirvish_filter_toggle()
  let g:dirvish_filter = ! g:dirvish_filter
  if g:dirvish_filter
    let g:dirvish_mode = ":call DirvishSetup2()"
  else
    let g:dirvish_mode = ":call DirvishSetup1()"
  endif
  normal R
endfunc

func! DirvishSetup1()
  exec 'sort ,^.*[\/],'
endfunc

func! DirvishSetup2()
  exec 'sort ,^.*[\/],'
  exec 'silent keeppatterns g/\.metals\|\.scala-build\|\.bsp\|\.vscode\|scala-doc/d _'
endfunc


" NOTE: Dirvish buffer maps can also be put here:
" ~/.config/nvim/ftplugin/dirvish.vim#/Maps
" currently this contains the dovish maps for copy, move files

" augroup dirvish_config
"   autocmd!

"   " autocmd FileType dirvish call DirvishSetup()
"   " Map `t` to open in new tab.
"   " Example: buffer local maps
"   " TODO: only these seem to work properly!!
"   autocmd FileType dirvish
"         \ |nnoremap <silent><buffer>,<cr> :call NewBufferFromDirvish("cr")<cr>
"         \ |nnoremap <silent><buffer>I :call NewBufferFromDirvish("cr")<cr>
"         \ |nnoremap <silent><buffer>U    :call NewBufferFromDirvish("u")<cr>
"         \ |nnoremap <silent><buffer>A    :call NewBufferFromDirvish("v")<cr>
"         \ |nnoremap <silent><buffer>X    :call NewBufferFromDirvish("s")<cr>
"         \ |nnoremap <silent><buffer>Y    :call NewBufferFromDirvish("y")<cr>
"         \ |nnoremap <silent><buffer>T    :call NewBufferFromDirvish("t")<cr>
"         \ |nnoremap <silent><buffer>i    :call Dirvish_open("edit", 0)<cr>
"         \ |nnoremap <silent><buffer>a    :call Dirvish_open("vsplit", 0)<cr>
"         \ |xnoremap <silent><buffer>t :call dirvish#open('tabedit', 1)<CR>

"   " Map `gr` to reload.
"   " autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>
"   " autocmd FileType dirvish nnoremap <silent><buffer> X :argadd getline('.')<cr>
"   autocmd FileType dirvish nnoremap <silent><buffer> P :call PreviewPathInFloatWin( getline('.') )<cr>
"   autocmd FileType dirvish nnoremap <silent><buffer> <leader>P :call PreviewFolderDetailedFloatWin( getline('.') )<cr>
"   " Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
"   autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>
"   " autocmd FileType dirvish nnoremap <silent><buffer> T ddO<Esc>:let @"=substitute(@", '\n', '', 'g')<CR>:r ! find "<C-R>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d<CR>:noh<CR>

"   " autocmd FileType dirvish nmap <silent><buffer> /
"   " Todo: set a meaningful buffername to be seen in tabline
"   " autocmd FileType dirvish exe "keepalt file" fnamemodify(bufname(), ':.')

"   " autocmd FileType dirvish nnoremap <nowait><buffer><silent><C-V> :call dirvish#open("vsplit", 1)<CR>:q<CR>

"   autocmd FileType dirvish nmap <silent> <buffer> <CR>  :call Dirvish_open('edit'   , 0)<CR>
"   " autocmd FileType dirvish nmap <silent> <buffer> v     :call Dirvish_open('vsplit' , 0)<CR>
"   " autocmd FileType dirvish nmap <silent> <buffer> V     :call Dirvish_open('vsplit' , 1)<CR>
"   " autocmd FileType dirvish nmap <silent><buffer> s     :call Dirvish_open('split'  , 0)<CR>
"   " autocmd FileType dirvish nmap <silent><buffer> S     :call Dirvish_open('split'  , 1)<CR>
"   " autocmd FileType dirvish nmap <silent> <buffer> t     :call Dirvish_open('tabedit', 1)<CR>
"   " autocmd FileType dirvish nmap <silent> <buffer> T     :call Dirvish_open('tabedit', 1)<CR>
"   autocmd FileType dirvish nmap <silent> <buffer> -     <Plug>(dirvish_up)
"   " autocmd FileType dirvish nmap <silent> <buffer> <ESC> :bd<CR>
"   autocmd FileType dirvish nmap <silent> <buffer> q     :bd<CR>
"   " autocmd FileType dirvish nnoremap <silent> <buffer> I I
" augroup END

" https://github.com/roginfarrer/vim-dirvish-dovish
" ~/.config/nvim/ftplugin/dirvish.vim#/Maps

" Used for <Plug>(dovish_delete)
function! g:DovishDelete(target) abort
  return 'del ' . a:target
endfunction
" https://github.com/roginfarrer/vim-dirvish-dovish


" TODO: i tried to overwrite dirvishes custom search mapping here. Instead i've now just commented
" this out in the source here  ~/.vim/plugged/vim-dirvish/ftplugin/dirvish.vim#/if%20s.sep%20==

" This can only show one char, no column space. the git plugin shows more styling
" call dirvish#add_icon_fn({p -> p[-3:]=='.hs' ? "λ " : ''})

let g:dirvish_git_show_ignored = 1
let g:dirvish_git_indicators = {
      \ 'Modified'  : '₊',
      \ 'Staged'    : 'ˆ',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Ignored'   : '☒',
      \ 'Unknown'   : '?'
      \ }
" (btw, nice unicode symbols)

" from nvim-tree glyphs
" unstaged = "₊",
" staged = "ˆ",
" unmerged = "",
" renamed = "➜",
" untracked = "★",
" deleted = "",
" ignored = "◌",



" nnoremap _ :call LeftFloater()<cr>

" Not using this, just example code
" function! LeftFloater()
"   let height = float2nr(&lines)
"   let width = float2nr(&columns * 0.34)
"   let horizontal = float2nr(width - &columns)
"   let vertical = 1
"   let opts = { 'relative': 'editor', 'row': vertical, 'col': horizontal, 'width': width, 'style': 'minimal', 'height': height }
"   let buf = nvim_create_buf(v:false, v:true)
"   let win = nvim_open_win(buf, v:true, opts)
"   call setwinvar(win, '&winhl', 'NormalFloat:TabLine')
"   :Dirvish
" endfunction

" Using the float win: https://github.com/justinmk/vim-dirvish/issues/167
nnoremap <silent> - <Plug>(dirvish_up)



func! Dirvish_open(cmd, bg) abort
  let path = getline('.')
  if isdirectory(path)
    " if a:cmd ==# 'edit' && a:bg ==# '0'
    call dirvish#open(a:cmd, 0)
    " endif
  else
    if a:bg
      call dirvish#open(a:cmd, 1)
    else
      bwipeout
      execute a:cmd ' ' path
    endif
  endif
endfunc

" cr full
" u  top
" v  right
" s  bottom 
" y  left 
" t  new tab 

func! NewBufferFromDirvish( pos )
  let cmd = DirvishCmd( a:pos )
  if IsInFloatWin()
    wincmd c
  endif
  exec cmd
endfunc

" direction:
"    1 float | 2 full | 3 tab | 4 right | 5 left | 6 up | 5 down 

func! NewBufCmds_templ()
  let mp = {}
  let mp['float'] = 'call Path_Float( "_PATH_" )'
  let mp['full']  = 'edit _PATH_'
  let mp['tab']   = 'tabedit _PATH_'
  let mp['tab_bg'] = 'tabedit _PATH_ | tabprevious'
  let mp['right'] = 'vnew _PATH_'
  let mp['left']  = 'leftabove 30vnew _PATH_'
  let mp['up']    = 'leftabove 20new _PATH_'
  let mp['down']  = 'new _PATH_'
  return mp
endfunc

func! NewBufCmds( path )
  return NewBufCmds_templ()->map( {_idx, cmdTmp -> substitute( cmdTmp, '_PATH_', a:path, "" )} )
endfunc
" NewBufCmds( "src" )
" Exec( NewBufCmds( ".gitignore" )["tab_bg"] )
" Exec( NewBufCmds( ".gitignore" )["float"] )
" Exec( NewBufCmds( "src" )["float"] )
" Exec( NewBufCmds( "src" )["down"] )

func! Exec( cmd )
  exec a:cmd
endfunc

func! Dirvish_newWin( cmd )
  let folder = expand('%:h')
  let file = expand('%:p')
  exec a:cmd folder
  call search('\V\^'.escape(file, '\').'\$', 'cw')
endfunc
" Dirvish_newWin( 'vnew' )
" expand('%:p')
" expand('%:h')

func! Compare_file_modified(f1, f2)
  if PathInfoSkip( a:f1 ) | return 1 | endif
  return getftime(a:f1) < getftime(a:f2) ? 1 : -1
endfunc
" Compare_file_modified("/Users/at/.config/nvim/plugin/file-manage.vim", "/Users/at/.config/nvim/plugin/functional.vim")
" Compare_file_modified("/Users/at/.config/nvim/plugin/functional.vim", "/Users/at/.config/nvim/plugin/file-manage.vim")

func! Compare_file_size(f1, f2)
  return getfsize(a:f1) < getfsize(a:f2) ? 1 : -1
endfunc

func! Compare_path_size(f1, f2)
  if PathInfoSkip( a:f1 ) | return 1 | endif
  return v:lua.vim.loop.fs_stat(a:f1).size < v:lua.vim.loop.fs_stat(a:f2).size ? 1 : -1
endfunc

func! Compare_path_linescount(f1, f2)
  return LinesCountOfPath(a:f1) < LinesCountOfPath(a:f2) ? 1 : -1
endfunc
" Compare_path_linescount("/Users/at/.config/nvim/plugin/file-manage.vim", "/Users/at/.config/nvim/plugin/functional.vim")
" Compare_path_linescount("/Users/at/.config/nvim/plugin/functional.vim", "/Users/at/.config/nvim/plugin/file-manage.vim")


" CAUTION: Use only with Dirvish buffer. All lines need to represent file paths.
nnoremap <leader><leader>im :call DirvishSortByModified()<cr>
nnoremap ,,im :lua DirvishShowModified()<cr>
func! DirvishSortByModified()
  let lines = getline(1, line('$'))
  eval lines->sort( 'Compare_file_modified' )
  call setline(1, lines)
  lua DirvishShowModified()
  call timer_start(1, {-> execute( 'setlocal conceallevel=3' )})
endfunc

nnoremap <leader><leader>is :call DirvishSortBySize()<cr>
nnoremap ,,is :lua DirvishShowSize()<cr>
func! DirvishSortBySize()
  let lines = getline(1, line('$'))
  eval lines->sort( 'Compare_path_size' )
  call setline(1, lines)
  lua DirvishShowSize()
  call timer_start(1, {-> execute('setlocal conceallevel=3')})
endfunc

nnoremap <leader><leader>dS :call DirvishSortByLineCount()<cr>
func! DirvishSortByLineCount()
  let lines = getline(1, line('$'))
  eval lines->sort( 'Compare_path_linescount' )
  call setline(1, lines)
  lua DirvishShowSize()
  call timer_start(1, {-> execute('setlocal conceallevel=3')})
endfunc

func! PathInfoSkip( filePath )
  let fname = split( a:filePath, '/' )[-1]
  if fname == ".metals" || fname == ".git" || fname == ".scala-build" || fname == ".scala-doc"
    return v:true
  else
    return v:false
  endif
endfunc
" PathInfoSkip( "plugin/.metals/" )
" PathInfoSkip( "plugin/.metls" )

func! FilesCountOfFolder( filePath )
  if PathInfoSkip( a:filePath ) | return 0 | endif
  return v:lua.vim.loop.fs_stat( a:filePath ).nlink - 2
endfunc
" FilesCountOfFolder("plugin/")
" FilesCountOfFolder("plugin/syntax")

func! LinesCountOfPath( filePath )
  if PathInfoSkip( a:filePath ) | return 0 | endif
  return str2nr( split( systemlist( 'find ' . a:filePath . ' -name "*" -print0 | gwc -l --files0=-' )[-1] )[0] )
  " return split( system( "find " . a:filePath . " -type f -exec wc -l {} \\; \| awk \'{total += $1} END{print total}'" ) )[0]
endfunc
" LinesCountOfPath("plugin/")
" LinesCountOfPath("/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/.scala-build/")
" LinesCountOfPath("plugin/syntax")
" v:lua.vim.fn.LinesCountOfPath( "plugin/" )

func! LinesCountOfFile( filePath )
  return split( system("wc -l " . a:filePath) )[0]
endfunc
" LinesCountOfFile( "plugin/file-manage.vim" )
" LinesCountOfFile( "plugin/syntax/*" )
" find plugin/syntax/ -type f -exec wc -l {} \; | awk '{total += $1} END{print total}'
" find plugin/file-manage.vim -type f -exec wc -l {} \; | awk '{total += $1} END{print total}'
" find plugin/syntax -name "*" -print0 | gwc -l --files0=-



" ─   Path Select Dialog                                ──

func! PathSelect_withCB( startPath, cbFnName )
  let g:PathSelect_cbFnName = a:cbFnName
  call Dirvish_Float( a:startPath )
  nnoremap <silent><leader>i :call PathSelect_callCB()<cr>
endfunc
"  |
func! PathSelect_callCB()
  let folderPath = getline('.')
  call call( g:PathSelect_cbFnName, [folderPath] )
  " call FloatWin_close()
endfunc

command! -nargs=1 DirvishFloat1 call Dirvish_Float( <args> )
" DirvishFloat1 "/Users/at/Documents"


command! -nargs=1 PathFloat call Path_Float( <args> )

func! Path_Float( path )
  call Float1Show()
  if isdirectory( a:path )
    call dirvish#open( a:path )
  else
    exec 'edit' a:path
  endif
endfunc
" Path_Float( '/Users/at/Documents/Notes/laminar.md' )
" Path_Float( '/Users/at/Documents/Notes' )

func! Dirvish_Float( path )
  call Float1Show()
  call dirvish#open( a:path )
endfunc
" Dirvish_Float( '/Users/at/Documents/Bookmarks/' )
" call( function('Dirvish_Float'), ['/Users/at/Documents/Bookmarks/'] )

func! Float1Show()
  call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, FloatOpts1())
endfunc
" Float1Show()

func! FloatOpts1()
  let width  = float2nr(&columns * 0.5)
  let height = float2nr(&lines * 0.6)
  let top    = ((&lines - height) / 2) - 1
  let left   = (&columns - width) / 2
  let opts   = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal' }
  return opts
endfunc

func! IsInFloatWin()
  return v:lua.vim.api.nvim_win_get_config(0).relative != ""
endfunc
" IsInFloatWin()

" ─^  Dirvish                                            ▲








