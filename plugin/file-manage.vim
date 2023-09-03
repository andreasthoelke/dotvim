


" nnoremap ,ts :SessionTabSave tab-
" nnoremap ,to :tabnew<cr>:SessionTabOpen! tab-

" Shortcuts to popular folders:
nnoremap <leader>ou :tabe ~/.config/nvim/utils/<cr>
nnoremap <leader>or :vnew ~/.config/nvim/plugin/<cr>
nnoremap <leader>oR :tabe ~/.config/nvim/plugin/<cr>
nnoremap <leader>on :vnew ~/.config/nvim/notes/<cr>
nnoremap <leader>oN :tabe ~/.config/nvim/notes/<cr>
nnoremap <leader>ov :vnew ~/.config/nvim/<cr>
nnoremap <leader>oV :tabe ~/.config/nvim/<cr>
" nnoremap <leader>od :vnew ~/Documents/<cr>
nnoremap <leader>oD :tabe ~/Documents/<cr>
nnoremap <leader>op :vnew ~/Documents/PS/A/<cr>
nnoremap <leader>oP :tabe ~/Documents/PS/A/<cr>
nnoremap <leader>ok :vnew ~/Documents/MobileDev/JPCompose/<cr>
nnoremap <leader>oK :tabe ~/Documents/MobileDev/JPCompose/<cr>

" nnoremap <leader>ovp :FzfFilesCustom1 ~/.config/nvim/plugin<cr>
" nnoremap <leader>ovv :FzfFilesCustom1 ~/.config/nvim/<cr>
" nnoremap <leader>ovv :FzfFilesCustom1 ~/.config/nvim/<cr>


" ─   Dirvish 'newWin' maps                             ──
" TODO: might want to make these consistent with: ~/.config/nvim/plugin/utils-fileselect-telescope.lua#/["<c-s><c-u>"]%20=%20open_above,
" TODO: might want to make these consistent with: ~/.config/nvim/plugin/file-manage.vim#/Dirvish%20'newWin'%20maps

nnoremap <silent> <leader>-  :Dirvish .<cr>
nnoremap <silent> ,o         :call Dirvish_Float( expand("%:h") )<cr>
nnoremap <silent> ,,o        :call Dirvish_Float( getcwd() )<cr>
nnoremap <silent> ,v         :call Dirvish_newWin( "vnew" )<cr>
nnoremap <silent> ,,v        :exec "vnew ."<cr>
nnoremap <silent> ,<leader>v :exec "vnew " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <leader>,v :exec "vnew " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w>F :exec "vnew " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>v :exec "vnew " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>s :exec "new " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>t :exec "tabedit " . GetFullLine_OrFromCursor()<cr>
nnoremap <silent> <c-w><leader>o :call FloatingBuffer( GetFullLine_OrFromCursor() )<cr>

nnoremap <silent> ,V         :call Dirvish_newWin( "leftabove 30vnew" )<cr>
nnoremap <silent> ,,V        :exec "leftabove 30vnew ."<cr>
nnoremap <silent> ,tn        :call Dirvish_newWin( "tabe" )<cr>
nnoremap <silent> ,,tn       :exec "tabe ."<cr>
nnoremap <silent> ,sn        :call Dirvish_newWin( "new" )<cr>
nnoremap <silent> ,,sn       :exec "new ."<cr>
nnoremap <silent> ,Sn        :call Dirvish_newWin( "above 13new" )<cr>
nnoremap <silent> ,,Sn       :exec "above 13new ."<cr>

" nnoremap <leader>of :FzfPreviewGitFiles<cr>
" nnoremap <leader>of :CocCommand fzf-preview.GitFiles<cr>
" nnoremap <leader>oF :FzfGFiles<cr>

" nnoremap <leader>oh :call FloatingBuffer( '~/.config/nvim/help.md' )<cr>
nnoremap <leader>oh :vnew ~/.config/nvim/help.md<cr>
nnoremap <leader>oH :tabe ~/.config/nvim/help.md<cr>

nnoremap <leader>ol :call FloatingBuffer( "/Users/at/.vim/notes/links2022.md" )<cr>
nnoremap <leader>os :call FloatingBuffer( "/Users/at/Documents/Notes/scratch2023.md" )<cr>
" nnoremap <leader>ob :call FloatingBuffer( "/Users/at/.vim/notes/scratch2022.md" )<cr>:Telescope vim_bookmarks all<cr>
nnoremap <leader>ob :Telescope vim_bookmarks all<cr>

nnoremap <leader>P :<c-u>call PreviewPathInFloatWin( GetLineFromCursor() )<cr>
xnoremap <leader>P :<c-u>call PreviewPathInFloatWin_vs()<cr>
" nnoremap <leader>of :call FloatingBuffer( GetFilePathAtCursor() )<cr>

" func! PreviewPathInFloatWin( filePath )
"   if isdirectory( a:filePath )
"     let lines = systemlist( 'ls ' . a:filePath )
"   else
"     let lines = readfile( a:filePath, "\n" )
"   endif
"   call FloatWin_ShowLines( lines )
" endfunc

func! PreviewPathInFloatWin_vs()
call PreviewPathInFloatWin( GetVisSel() )
endfunc

func! PreviewPathInFloatWin( filePath )
" let fp = fnameescape( fnamemodify( a:filePath, ":p") )
let fp = fnamemodify( a:filePath, ":p")
" if IsFolderPath( fp )
if isdirectory( fp )
" let lines = systemlist( 'ls ' . fp )
" let lines = systemlist( 'exa -T --icons --level=2 ' . fp )
let lines = systemlist( 'exa -T --icons --level=2 --ignore-glob=".git|node_modules" ' . fp )
else
let lines = readfile( fp, "\n" )
endif
call FloatWin_ShowLines( lines )
endfunc
" call PreviewPathInFloatWin( "/Users/at/.vim/notes/links" )
" call PreviewPathInFloatWin( "/Users/at/.vim/notes/" )
" call PreviewPathInFloatWin( "~/.config/karabiner/karabiner.json" )

func! PreviewFileInFloatWin( filePath )
" call FloatWin_ShowLines( readfile( a:filePath, "\n" ) )
call FloatWin_ShowLines( readfile( fnameescape(a:filePath), "\n" ) )
endfunc
" call PreviewPathInFloatWin( '/Users/at/.vim/notes/links' )
" call PreviewPathInFloatWin( '/Users/at/.vim/notes/my folder/' )
" call PreviewPathInFloatWin( '/Users/at/.vim/notes/my folder/ei.txt' )
" call PreviewPathInFloatWin( '/Volumes/GoogleDrive/My Drive/temp/' )
" call PreviewPathInFloatWin( '/Volumes/GoogleDrive/My Drive/temp/drei.txt' )

func! PreviewFolderDetailedFloatWin( filePath )
let fp = fnameescape( a:filePath )
if IsFolderPath( fp )
" let lines = systemlist( 'ls ' . fp )
let lines = systemlist( 'exa -T --git --long --icons --level=2 ' . fp )
else
let lines = readfile( a:filePath, "\n" )
endif
call FloatWin_ShowLines( lines )
endfunc


" https://stackoverflow.com/questions/1534835/how-do-i-close-all-buffers-that-arent-shown-in-a-window-in-vim

function! DeleteInactiveBufs()
"From tabpagebuflist() help, get a list of all buffers in all tabs
let tablist = []
for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
endfor
"Below originally inspired by Hara Krishna Dara and Keith Roberts
"http://tech.groups.yahoo.com/group/vim/message/56425
let nWipeouts = 0
for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
    "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
        " silent exec 'bwipeout!' i
        silent exec 'bdelete!' i
        let nWipeouts = nWipeouts + 1
    endif
endfor
echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()
command! BufferDeleteInactive :call DeleteInactiveBufs()




" ─   CtrlP                                              ■

" Notes:
" ctrlP custom menu: seems quite involved ~/.vim/autoload/ctrlpArgs.vim#/call%20add.g.ctrlp_ext_vars

let g:ctrlp_cmd = 'CtrlPBuffer'
" let g:ctrlp_cmd = 'CtrlPMRU'
" let g:ctrlp_map = '<localleader>a'
let g:ctrlp_map = 'gO'
nnoremap <leader><leader>gp :CtrlPMRU<cr>

" Don't list files fromm certain folders:
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.cache$\|\.stack$\|\.stack-work$\|vimtmp\|undo\bower_components$\|dist$\|node_modules$\|project_files$\|test$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
" This needs a restart to take effect.

let g:ctrlp_root_markers = ['src/', '.gitignore', 'package.yaml', '.git/']
let g:ctrlp_by_filename = 1
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:20,results:40'

" Use the nearest .git directory as the cwd
let g:ctrlp_working_path_mode = 'w'

" Select multiple files with <c-z> then do <c-o> to load the first into the current window (r) and
" the others in vertical splits (v), jump to the first window (j)
let g:ctrlp_open_multiple_files = 'vjr'
" include hidden files (of course!)
let g:ctrlp_show_hidden = 1
let g:ctrlp_follow_symlinks = 2

" <c-v> to reveal/go to buffer if it's shown in a tab-window anywhere
" otherwise opens a vertical split.
let g:ctrlp_switch_buffer = 'V'

let g:ctrlp_match_current_file = 1

" Customize CtrlP mappings:
let g:ctrlp_prompt_mappings = {
  \ 'PrtDeleteEnt()':       ['<c-x>'],
  \ 'PrtClearCache()':      ['<c-R>', '<F5>'],
  \ 'AcceptSelection("h")': ['<c-cr>', '<c-s>'],
  \ }

" let g:ctrlp_extensions = ['dir', 'undo', 'line', 'changes']
" let g:ctrlp_extensions = ['dir', 'line']
" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
"                          \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir']
" let g:ctrlp_extensions = ['undo', 'line', 'changes']
" let g:ctrlp_extensions = ['tag', 'line', 'changes']
let g:ctrlp_extensions = ['dir']


let g:ctrlp_max_files = 2000
let g:ctrlp_max_depth = 10
let g:ctrlp_clear_cache_on_exit = 0
" --- quickfix & loclist ----


" Demo function:
" Set up a "Delete Buffer" map:
" let g:ctrlp_buffer_func = { 'enter': 'MyCtrlPMappings' }
" func! MyCtrlPMappings()
"     nnoremap <buffer> <silent> <c-x> :call <sid>DeleteBuffer()<cr>
" endfunc
" func! s:DeleteBuffer()
"     let line = getline('.')
"     " let bufid = line =~ '\[\d\+\*No Name\]$' ? str2nr(matchstr(line, '\d\+')) : fnamemodify(line[2:], ':p')
"     let bufid = fnamemodify(line[2:], ':p')
"     exec "bd" bufid
"     exec "norm \<F5>"
" endfunc

" ─^  CtrlP                                              ▲



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
  let path = getline('.')
  if IsInFloatWin()
    wincmd c
    if     a:pos ==# 'cr'
      exec "edit" path 
    elseif a:pos ==# 'u'
      exec "leftabove" "30new" path 
    elseif a:pos ==# 'v'
      exec "vnew" path 
    elseif a:pos ==# 's'
      exec "new" path 
    elseif a:pos ==# 'y'
      exec "leftabove" "30vnew" path 
    elseif a:pos ==# 't'
      exec "tabedit" path 
    else
      echo "not supported"
    endif
  endif

endfunc


func! Dirvish_centered_float() abort
    let width  = float2nr(&columns * 0.5)
    let height = float2nr(&lines * 0.8)
    let top    = ((&lines - height) / 2) - 1
    let left   = (&columns - width) / 2
    let opts   = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal' }
    let fdir = expand('%:h')
    let path = expand('%:p')
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    if fdir ==# ''
        let fdir = '.'
    endif
    call dirvish#open(fdir)
    if !empty(path)
        " NOTE: this moves the cursor to the current file!
        call search('\V\^'.escape(path, '\').'\$', 'cw')
    endif
endfunction
" strftime('%c', getftime(getline('.')))

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






