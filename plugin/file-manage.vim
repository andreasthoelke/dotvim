


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
nnoremap <silent> ,v         :call Dirvish_newWin( "vnew" )<cr>
nnoremap <silent> ,,v        :exec "vnew ."<cr>
nnoremap <silent> ,<leader>v :exec "vnew " . getline('.')<cr>
nnoremap <silent> <leader>,v :exec "vnew " . getline('.')<cr>
nnoremap <silent> <c-w>F :exec "vnew " . getline('.')<cr>
nnoremap <silent> <c-w><leader>v :exec "vnew " . getline('.')<cr>
nnoremap <silent> <c-w><leader>s :exec "new " . getline('.')<cr>
nnoremap <silent> <c-w><leader>o :call FloatingBuffer( getline('.') )<cr>



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
nnoremap <leader>os :call FloatingBuffer( "/Users/at/.vim/notes/scratch2022.md" )<cr>
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


" New file openers:
" nnoremap <silent> gp :<C-u>FzfPreviewFromResources project_mru<CR>
" nnoremap <silent> gp :<C-u>FzfPreviewProjectMrwFiles<CR>
nnoremap <silent> gP :<C-u>FzfPreviewProjectMruFiles<CR>
" This allows to multiselect & c-q and open in *new tab* vs the above uses the current window.
" nnoremap <silent> gp :<C-u>FzfHistory<CR>
" This command uses a separate history file which should accumulate 2000 entries over time:
nnoremap <silent> ,gp :<C-u>FzfPathsFromFile ~/.config/nvim/.vim_mru_files<CR>
nnoremap <silent> ,,gp :<C-u>FzfPreviewOldFiles<CR>
" nnoremap <silent> ,gp :<C-u>FZFMru<CR>
nnoremap <silent> <leader>gp :topleft MRU<CR>
" nnoremap <silent> go :<C-u>FzfBuffer<cr>
nnoremap <silent> ,go <cmd>lua require('utils_general').fileView()<cr>

" nnoremap <silent> <leader>nf <cmd>NvimTreeFindFile<cr>
" nnoremap <silent> <leader>no <cmd>NvimTreeToggle<cr>
" nnoremap <silent> ,tt <cmd>lua require('utils_general').fileView()<cr>
nnoremap <silent> <leader>gs <cmd>NvimTreeFindFile<cr><c-w>p
nnoremap <silent> <leader>go <cmd>NvimTreeToggle<cr><c-w>p
nnoremap <silent> ,gs <cmd>NvimTreeFindFile<cr>
nnoremap <silent> ,go <cmd>NvimTreeToggle<cr>


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

augroup dirvish_config
  autocmd!

  " autocmd FileType dirvish call DirvishSetup()
  " Map `t` to open in new tab.
  " Example: buffer local maps
  " TODO: only these seem to work properly!!
  autocmd FileType dirvish
        \  nnoremap <silent><buffer>t :exec "tabe " . getline('.')<cr>
        \ |xnoremap <silent><buffer>t :call dirvish#open('tabedit', 1)<CR>
        \ |nnoremap <silent><buffer>s :call dirvish#open('split', 1)<CR>

  " Map `gr` to reload.
  " autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>
  autocmd FileType dirvish nnoremap <silent><buffer> X :argadd getline('.')<cr>
  autocmd FileType dirvish nnoremap <silent><buffer> P :call PreviewPathInFloatWin( getline('.') )<cr>
  autocmd FileType dirvish nnoremap <silent><buffer> <leader>P :call PreviewFolderDetailedFloatWin( getline('.') )<cr>
  " Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
  autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>
  autocmd FileType dirvish nnoremap <silent><buffer> T ddO<Esc>:let @"=substitute(@", '\n', '', 'g')<CR>:r ! find "<C-R>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d<CR>:noh<CR>

  " autocmd FileType dirvish nmap <silent><buffer> /
  " Todo: set a meaningful buffername to be seen in tabline
  " autocmd FileType dirvish exe "keepalt file" fnamemodify(bufname(), ':.')

  " autocmd FileType dirvish nnoremap <nowait><buffer><silent><C-V> :call dirvish#open("vsplit", 1)<CR>:q<CR>

  autocmd FileType dirvish nmap <silent> <buffer> <CR>  :call Dirvish_open('edit'   , 0)<CR>
  " autocmd FileType dirvish nmap <silent> <buffer> v     :call Dirvish_open('vsplit' , 0)<CR>
  " autocmd FileType dirvish nmap <silent> <buffer> V     :call Dirvish_open('vsplit' , 1)<CR>
  " autocmd FileType dirvish nmap <silent><buffer> s     :call Dirvish_open('split'  , 0)<CR>
  autocmd FileType dirvish nmap <silent><buffer> S     :call Dirvish_open('split'  , 1)<CR>
  " autocmd FileType dirvish nmap <silent> <buffer> t     :call Dirvish_open('tabedit', 1)<CR>
  " autocmd FileType dirvish nmap <silent> <buffer> T     :call Dirvish_open('tabedit', 1)<CR>
  autocmd FileType dirvish nmap <silent> <buffer> -     <Plug>(dirvish_up)
  " autocmd FileType dirvish nmap <silent> <buffer> <ESC> :bd<CR>
  autocmd FileType dirvish nmap <silent> <buffer> q     :bd<CR>
  autocmd FileType dirvish nnoremap <silent> <buffer> I I
augroup END

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

nnoremap <silent><leader>od :call Dirvish_toggle()<CR>

function! Dirvish_open(cmd, bg) abort
    let path = getline('.')
    if isdirectory(path)
        if a:cmd ==# 'edit' && a:bg ==# '0'
            call dirvish#open(a:cmd, 0)
        endif
    else
        if a:bg
            call dirvish#open(a:cmd, 1)
        else
            bwipeout
            execute a:cmd ' ' path
        endif
    endif
endfunction


function! Dirvish_toggle() abort
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
nnoremap <leader><leader>dm :call DirvishSortByModified()<cr>
nnoremap ,,dm :lua DirvishShowModified()<cr>
func! DirvishSortByModified()
  let lines = getline(1, line('$'))
  eval lines->sort( 'Compare_file_modified' )
  call setline(1, lines)
  lua DirvishShowModified()
  call timer_start(1, {-> execute( 'setlocal conceallevel=3' )})
endfunc

nnoremap <leader><leader>ds :call DirvishSortBySize()<cr>
nnoremap ,,ds :lua DirvishShowSize()<cr>
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
" call Path_Float( '/Users/at/Documents/Notes/laminar.md' )
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


" ─   Arglist                                            ■


" CtrlP support: Arglist can be shown in CtrlP. Files can be opened and items deleted with <c-s>
command! CtrlPArgs call ctrlp#init( ctrlpArgs#id() )
nnoremap <leader>sA :CtrlPArgs<cr>
nnoremap <leader>dA :call ArglistDelFiles()<cr>
nnoremap <leader>cA :call ArglistClear()<cr>

nnoremap <leader>oa :echo 'use sA (show Arglist)'<cr>
nnoremap <leader>X :echo 'use cA (clear Arglist)'<cr>

" Use "argg and argl" to switch to global and local arg list. Generally prefer the global arg list.

func! ReloadKeepView()
  let l:winview = winsaveview()
  exec 'e'
  exec 'normal!' "\<C-o>"
  call winrestview(l:winview)
endfunc

" Toggle arglist items: Single, vis-sel and line motion
nnoremap <leader>xx :call Arglist_toggleItems( [getline('.')] )<cr>:Dirvish %<cr>
vnoremap <leader>x :<c-u>call Arglist_toggleItems( getline("'<", "'>") )<cr>
nnoremap <leader>x :set opfunc=ArglistToggle_op<cr>g@
" Tip: can add popular folders as well, then CtrlP-v/t to open the dirvish pane
" Issue: Dotfolders e.g. ".git" can not be toggled in dirvish, only with CtrlP-s

" leader xiB  - toggle all dirvish files to the arglist

func! ArglistDelFiles()
  let msg = 'Deleting these files: ' . string( argv() ) . ' ?'
  let dres = confirm( msg, "&Yes\n&Cancel", 2 )
  if dres == 1
    for fname in argv()
      call system( 'del ' . fname )
      exec 'bdelete' fname
    endfor
    exec '%argdelete'
    normal R
  else
    redraw
    echo 'canceled'
  endif
  " clear the message area
  call feedkeys(':','nx')
endfunc

" Note: vim delete(<fname>) doesn't move to trash!
" call map ( argv(), {_, str -> delete( str, 'rf' )} )

func! ArglistClear()
  exec '%argdelete'
  normal R
endfunc

func! ArglistToggle_op( _ )
  call Arglist_toggleItems( getline( "'[", "']" ) )
endfunc

" Remove a string from the arglist if already present, add it otherwise.
func! Arglist_toggleItems( listOfStr )
  argglobal
  for argItem in a:listOfStr
    let currentIndex = index( ArgvFilenameTailOnly(), fnamemodify( argItem, ":t" ) )
    if currentIndex == -1
      exec '$argadd ' . argItem
    else
      exec (currentIndex+1) . "argd"
    endif
  endfor
  if &filetype == 'dirvish'
    Dirvish %
  endif
endfunc

func! ArgvAbsPath()
  return MakeFilenamesAbsolute( argv() )
endfunc

func! ArgvFilenameTailOnly()
  return map ( argv(), {_, str -> fnamemodify( str, ":t" )} )
endfunc

func! MakeFilenamesAbsolute ( listOfFilesnames )
  return map( a:listOfFilesnames, {_, str -> fnamemodify( str, ":p")} )
endfunc

" ─^  Arglist                                            ▲


" ─   fzf                                                ■
" 

let g:fzf_layout = { 'up': '~40%' }

command! -bang Args call fzf#run(fzf#wrap('args', {'source': argv()}, <bang>0))


" ─^  fzf                                                ▲



" ─   Move Files                                         ■
" Process:
" - put two Dirvish folders side by side (source -> target)
" - use ,x(l/j/vis-sel) in the left window to add to the arglist
"   - leader oa to show current arglist
"   - leader X to reset/clear arglist
"   - do this regularly (also R to refesh Dirvish)
" - leader mv will run the 'move' command.
"   - <c-w>l to see the moved file in the other folder in 'red' (auto added to the arg list)
"   - with the cursor still in the right win (related folder path is filtered as the tarket folder)
"     run leader mv again to undo/redo to operation in reverse direction
" - leader mV will show e.g.
  " Shdo! mv %{} /Users/at/Documents/PS/A/TestsA/webpack-reload/src/App/{}
  " in command edit mode. placeholder "{}" will insert the arglist! and I can now change "mv" to "cp" or "rm", etc
  " - <c-c><c-c> cancels the process
  " - <c-c><cr> runs the Shdo! command to will show a buffer with the full command
  " - leader leader z will run the shell script in that buffer
  " - leader bd to delete that temp buffer
  " - see the effect in the dirvish buffers. R? or leader X?
  " - <c-w>L/H to reverse the command?


" nnoremap <leader>mv :call MoveFilesFromLeftWinToRightWin( 0 )<cr>
" nnoremap <leader>mV :call MoveFilesFromLeftWinToRightWin( 1 )<cr>q:<leader>"tP^W

" The list of filenames in the current tab
func! TabWinFilenames()
  return map( tabpagebuflist( tabpagenr() ), {_, bufnum -> bufname( bufnum ) } )
endfunc


func! MoveFilesFromLeftWinToRightWin( prompt )
  let folderPathSource = bufname( bufnr('%') )
  " Of the other windows choose the leftmost as the target of the file move
  let [folderPathTarget;_] = functional#filter( {path-> path isnot# folderPathSource}, TabWinFilenames() )
  " if len(TabWinFilenames()) > 1
  " else
  "   let folderPathTarget = '%'
  " endif
  if !( IsFolderPath( folderPathSource ) && IsFolderPath( folderPathTarget ))
    echoe "You need to have source and target folders side by side"
    return
  endif

  " let cmdStr = 'Shdo! mv ' . folderPathSource.'{} ' . folderPathTarget.'{}'
  let cmdStr = 'Shdo! mv ' . '%{} ' . folderPathTarget.'{}'
  if a:prompt
    " TODO go directly into the command editing window - automate <c-f>k^w
    " normal! q:
    let @t = cmdStr
    " call feedkeys( ':' . cmdStr )
    " Stop at the pre-filled command prompt, don't auto-run and close the Shdo buffer
    return
  else
    " this opens a buffer with the full shell script!
    exec cmdStr
    " this runs the shell script
    call RunBufferAsShellScript()
    wincmd c
    call SetArglistfilesFolder( folderPathTarget )
  endif
  " wincmd p
  " if &filetype == 'dirvish'
  "   Dirvish %
  " else
  "   wincmd w
  "   Dirvish %
  " endif
  " wincmd w
endfunc

" ─^  Move Files                                         ▲


func! ExpandListGlobsToListFilespaths ( listOfGlobs )
  let listOfListsPaths = functional#map( 'GlobToPaths', a:listOfGlobs )
  return functional#concat( listOfListsPaths )
endfunc
" echo ExpandListGlobsToListFilespaths( g:testVimGlobs )
" echo glob( 'notes/*txt', v:true, v:true )
" echo globpath( join(['notes/', './'], ','), '*vim*' )
" echo map( ExpandListGlobsToListFilespaths(g:testVimGlobs), 'fnamemodify(v:val, ":t:r")' )

" let g:testVimGlobs = ['notes/*.txt', 'autoload/**.old', 'syntax/h*', 'plugin/*ma*']
" let g:testVimFilesnames = map( ExpandListGlobsToListFilespaths(g:testVimGlobs), 'fnamemodify(v:val, ":t:r")' )


func! GlobToPaths (glob)
  return glob( a:glob, v:true, v:true )
endfunc

func! IsFolderPath ( path )
  " return isdirectory( a:path )
  " This is technically faster as it's not checking the existence of the folder in the file system but only tests the last character of the string
  return (a:path[-1:] == '/')
endfunc

func! GetLastComponentFromPath (folderpath)
  let components = split( a:folderpath, '/' )[-1:]
  return !empty(components) ? components[0] : ''
endfunc

func! ProjectRootFolderName ()
  return GetLastComponentFromPath( getcwd() )
endfunc

func! ProjectRootFolderNameOfWin (winnr)
  return GetLastComponentFromPath( getcwd(a:winnr) )
endfunc

" When opening a file with Dirvish the filepath is not relative. This makes sure it is.
func! CurrentRelativeFilePath ()
  let path = expand('%:p')
  let cwd = getcwd()
  let relPath = substitute( path, cwd, '', '' )
  return relPath
endfunc
" echo CurrentRelativeFilePath()

func! CurrentRelativeFilePathOfWin ()
  let path = expand('%:p')
  let cwd = getcwd( winnr() )
  let relPath = substitute( path, cwd, '', '' )
  return relPath
endfunc

" A dirvish buffer will be the 'next folder path'
func! CurrentNextFolderPath ()
  let path = expand('%:p')
  let filename = expand('%:t') " filename in empty in Dirvish
  let folderpath = substitute( path, filename, '', '' )
  return folderpath
endfunc
" echo CurrentNextFolderPath()

func! GetFilenameOrFolderStrFromPath (path)
  let lastSegment = GetLastComponentFromPath( a:path )
  if IsFolderPath( a:path )
    let lastSegment .= '/'
  endif
  return lastSegment
endfunc
" echo GetFilenameOrFolderStrFromPath('/Users/at/.vim/plugged/csv.vim/')
" echo GetFilenameOrFolderStrFromPath('/Users/at/.vim/plugged/csv.vim/test.txt')

func! FilenameOrFolderStrOfCurrentBuffer (tab_count)
  let buflist = tabpagebuflist(a:tab_count)
  let winnr = tabpagewinnr(a:tab_count)
  let path = expand('#' . buflist[winnr - 1])
  return GetFilenameOrFolderStrFromPath( path )
endfunction
" echo FilenameOrFolderStrOfCurrentBuffer( tabpagenr() )
" From ~/.vim/plugged/lightline.vim/autoload/lightline/tab.vim#/function.%20lightline#tab#filename.n.%20abort


func! SetArglistfilesFolder( newFolder )
  let argvTail = ArgvFilenameTailOnly()
  %argdelete
  for argItem in argvTail
    exec '$argadd ' . a:newFolder . argItem
  endfor
endfunc

" nnoremap <buffer><silent> Z! :silent write<Bar>exe '!'.(has('win32')?fnameescape(escape(expand('%:p:gs?\\?/?'), '&\')):shellescape(&shell).' %')<Bar>if !v:shell_error<Bar>close<Bar>endif<CR>

nnoremap <leader><leader>z :call RunBufferAsShellScript()<cr>

func! RunBufferAsShellScript()
  exec '!'. shellescape( &shell ) .' %'
  if !v:shell_error
    close
  endif
endfunc

func! SetExecutableFlag ( path, val )
  let cmd = a:val ? 'chmod u+x ' : 'chmod u-x '
  call system( cmd . fnameescape(a:path) )
endfunc
" call SetExecutableFlag('/Users/at/.vim/notes/my folder/ei.txt', v:false)
" call SetExecutableFlag('/Users/at/.vim/notes/my folder/ei.txt', v:true)

" call SetExecutableFlag('~/apps_bin/nvim07/bin/nvim', v:true)
" call SetExecutableFlag('~/apps_bin/nvim061/bin/nvim', v:true)
"
" can also navigate to folder and then chmod +x nvim
" but then I just right-clicked and >open< the file .. also the lib...8.. file







