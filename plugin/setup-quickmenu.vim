

" enable cursorline (L) and cmdline help (H) for left panel, use (T)
let g:quickmenu_options = 'LH'
let g:quickmenu_special_keys = 0
let g:quickmenu_padding_left = 0
let g:quickmenu_padding_right = 1
let g:quickmenu_max_width = 100
let g:quickmenu_disable_nofile = 0

" Examples of some commands

call g:quickmenu#current(0)
call g:quickmenu#reset()
call g:quickmenu#header('Test header 4')

call g:quickmenu#append('# Highlight', '')
call g:quickmenu#append('Turn spell %{&spell? "off":"on"}' , 'set spell!' , 'enable/disable spell check')

call g:quickmenu#append('# Help', '')
call g:quickmenu#append('Vim patterns help'      , 'help search-pattern' )

call g:quickmenu#append('# Actions'      , '')
call g:quickmenu#append('Strip Whitespace'    , 'StripWhitespace' , 'also via <leader>sw')
call g:quickmenu#append("Run %{expand('%:t')}", '!./%', "Run current file")
call g:quickmenu#append("Run %{expand('%:t')}", '!./%', "Run current file")

call g:quickmenu#append('# Tools'      , '')
call g:quickmenu#append('Git magit' , 'Magit'  , 'Auther commit' , '' , 0 , 'g')
call g:quickmenu#append('Git gitV' , 'Gitv'  , 'View commits')
call g:quickmenu#append('Marks markbar' , 'Markbar'  , 'Marks overview' , '' , 0 , 'm')
call g:quickmenu#append('Tagbar' , 'TagbarToggle'  , 'list tags' , '' , 0 , 't')

noremap <silent><leader><leader>q :call quickmenu#bottom(0)<cr>
noremap <silent><leader><leader>q :call quickmenu#toggle(0)<cr>
noremap <silent><leader>, :call quickmenu#bottom(1)<cr>


" Other

call g:quickmenu#current(1)
call g:quickmenu#reset()
call g:quickmenu#header('other2')

call g:quickmenu#append('# Util tools'          , '')
call g:quickmenu#append('first menu' , 'call quickmenu#bottom(0)'  , 'link to a submenu' , '' , 0 , 'l')
call g:quickmenu#append('Debug' , 'call quickmenu#bottom(13)'  , 'link to a submenu' , '' , 0 , 'd')
call g:quickmenu#append('Branches' , 'call quickmenu#bottom(12)'  , 'link to a submenu' , '' , 0 , 'b')

" " GIT BRANCHES PANEL

" Warning, work in current directory: where vim was launched
function! QuickBranches()
  call g:quickmenu#current(12)
  call g:quickmenu#reset()
  call g:quickmenu#header('Git branches')
  call g:quickmenu#append('# Branches', '')
  let l:branches = systemlist("git branch --list | sed 's/\*//g' | sed 's/ //g'")
  for l:branch in l:branches
    call g:quickmenu#append('' . l:branch, 'silent !git checkout ' . l:branch)
  endfor
endfunction

call QuickBranches()

" DEBUG PANEL

call g:quickmenu#current(13)
call g:quickmenu#reset()
call g:quickmenu#header('Vimmic: Debug')
call g:quickmenu#append('quickfix'              , 'copen'    , 'open'          , '' , 0 , 'q')
call g:quickmenu#append('quickfix'              , 'cclose'   , 'close'         , '' , 0 , 'Q')
if exists(':Termdebug')
  call g:quickmenu#append('Run'                , 'Run'      , 'gdb: run'      , '' , 0 , 'r')
  call g:quickmenu#append('Continue'           , 'Continue' , 'gdb: continue' , '' , 0 , 'c')
  call g:quickmenu#append('Step'               , 'Step'     , 'gdb: step'     , '' , 0 , 's')
  call g:quickmenu#append('Next line'          , 'Over'     , 'gdb: next'     , '' , 0 , 'n')
  call g:quickmenu#append('Finish'             , 'Finish'   , 'gdb: finish'   , '' , 0 , 'f')
  call g:quickmenu#append('Breakpoint '        , 'Break'    , 'gdb: break'    , '' , 0 , 'b')
  call g:quickmenu#append('Delete Breakpoint ' , 'Clear'    , 'gdb: delete'   , '' , 0 , 'd')
endif


