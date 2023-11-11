



" use c-w l o?!
nnoremap <silent><leader>P :<c-u>call PreviewPathInFloatWin( GetLineFromCursor_dirvish() )<cr>
xnoremap <silent><leader>P :<c-u>call PreviewPathInFloatWin_vs()<cr>
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
" PreviewPathInFloatWin( "/Users/at/.vim/notes/links" )
" PreviewPathInFloatWin( "/Users/at/.vim/notes/" )
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

func! File_InsertLineBeforePattern( pattern, newLine, filepath )
  " gsed -i '/doautoall SessionLoadPost/i\new line' ~/.local/share/nvim/sessions/__Users__at__.config__nvim
  " gsed -i '/doautoall SessionLoadPost/i\let g:SomeGlobal = '\''{"8":"aber7"}'\''' ~/.local/share/nvim/sessions/__Users__at__.config__nvim
  let cmd = "gsed -i '/" . a:pattern . "/i\\" . a:newLine . "' " . a:filepath
  " let cmd = "gsed -i '/" . a:pattern . "/i\\" . a:newLine . "' " . a:filepath
  " let cmd = 'gsed -i "/' . a:pattern . '/i\\' . string( a:newLine ) . '" ' . a:filepath
  " echo cmd
  " return
  return system( cmd )
endfunc
" File_InsertLineBeforePattern( "doautoall SessionLoadPost", "something", "~/.local/share/nvim/sessions/__Users__at__.config__nvim")


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





