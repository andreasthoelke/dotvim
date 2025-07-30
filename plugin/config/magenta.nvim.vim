
" example file
" ~/.local/share/nvim/parrot/chats/2025-07-29.12-13-51.md
" call MagentaBufferMaps()

func! MagentaBufferMaps()

  nnoremap <silent><buffer> I :call Vim_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Vim_ColonBackw()<cr>

  nnoremap <silent><buffer> <c-p>         :call Mgn_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Mgn_MainStartBindingForw()<cr>:call ScrollOff(27)<cr>

  nnoremap <silent><buffer> <leader><c-p> :call Mgn_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Mgn_TopLevBindingForw()<cr>:call ScrollOff(22)<cr>

  nnoremap <silent><buffer> t :call BracketStartForw()<cr>
  vnoremap <silent><buffer> t <esc>:call ChangeVisSel(function('BracketStartForw'))<cr>
  nnoremap <silent><buffer> T b:call BracketStartBackw()<cr>w
  vnoremap <silent><buffer> T <esc>:call ChangeVisSel(function('BracketStartBackw'))<cr>
  nnoremap <silent><buffer> <leader>]t :call BracketEndForw()<cr>
  nnoremap <silent><buffer> ]T :call BracketEndForw()<cr>
  vnoremap <silent><buffer> ]T <esc>:call ChangeVisSel(function('BracketEndForw'))<cr>h

  nnoremap <silent><buffer>]b :call MD_BoldNext()<cr>
  nnoremap <silent><buffer>[b :call MD_BoldPrev()<cr>

endfunc


let g:Mgn_MainStartPattern = '\v(\#\s|\d\)\s|\d\.\s|---|☼\:|⌘\:|.*─|function|func\!|\i.*function\(|local\sfunction\s)'
" the *\S{-}\* patterns is searching vim help headlines
let g:Mgn_TopLevelPattern = '\v^(\=\=|\#\s|.*─|☼\:|⌘\:)'

func! Mgn_MainStartBindingForw()
  normal! jj
  call search( g:Mgn_MainStartPattern, 'W' )
  call Mgn_goFistWord()
endfunc

func! Mgn_MainStartBindingBackw()
  normal! ^kk
  call search( g:Mgn_MainStartPattern, 'bW' )
  normal! kk
  call search( g:Mgn_MainStartPattern, 'W' )
endfunc

func! Mgn_TopLevBindingForw()
  normal! jj
  call search( g:Mgn_TopLevelPattern, 'W' )
endfunc

func! Mgn_TopLevBindingBackw()
  normal! ^
  call search( g:Mgn_TopLevelPattern, 'bW' )
  normal! kk
  call search( g:Mgn_TopLevelPattern, 'W' )
endfunc

