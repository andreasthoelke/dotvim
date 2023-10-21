
" au ag BufNewFile,BufRead,WinNew *.vim,*.lua,*.md call VScriptToolsBufferMaps()


let g:rgx_main_symbol_vimLua = '^(func|local\sfunction|command!|-- ─ |" ─ |#).*'

func! VScriptToolsBufferMaps()
  call tools_scala#bufferMaps_shared()

  " the below should overwrite the default/scala maps

  nnoremap <silent><buffer> I :call Vim_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Vim_ColonBackw()<cr>

  nnoremap <silent><buffer> <c-p>         :call Vim_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Vim_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>

  " nnoremap <silent><buffer> ge:  :call v:lua.require( 'utils_general' ).RgxSelect_Picker([], g:rgx_main_symbol_vimLua, ["-g", ".vim", ".lua"], [expand('%:p')] )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.require('utils_general').RgxSelect_Picker([], "[A-Z]{3,}", ["-g", ".txt", ".vim", ".lua"], [expand('%:p')] )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.require( 'utils_general' ).RgxSelect_Picker( [], g:rgx_main_symbol_vimLua, [], [ "/Users/at/.config/nvim/plugin", "/Users/at/.config/nvim/lua"] )<cr>

  nnoremap <silent><buffer> ge;  :call v:lua.Search_mainPatterns( expand("%:p") )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.Search_mainPatterns( expand("%:p:h") )<cr>
  nnoremap <silent><buffer> ge:  :call v:lua.Search_mainPatterns( getcwd(), g:rgx_main_symbol_vimLua )<cr>

  nnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( getcwd(), expand('<cword>'), "normal" )<cr>
  xnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( getcwd(), GetVisSel(), "normal" )<cr>

  nnoremap <silent><buffer> gei :call PrintVimOrLuaLine()<cr>
endfunc


let g:Vim_colonPttn = MakeOrPttn( ['\:', '\#', '--', '=', 'or', 'and\s', 'not\s', '\.\.', 'if\s', 'elseif', 'then\s', 'return'] )

func! Vim_ColonForw()
  call SearchSkipSC( g:Vim_colonPttn, 'W' )
  normal w
endfunc

func! Vim_ColonBackw()
  normal bh
  call SearchSkipSC( g:Vim_colonPttn, 'bW' )
  normal w
endfunc


" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Vim_MainStartPattern = '\v^(\#|function|func\!|\i.*function|local|.{-}\*\S{-}\*)'
" the *\S{-}\* patterns is searching vim help headlines


func! Vim_MainStartBindingForw()
  " normal! }
  normal! jj
  call search( g:Vim_MainStartPattern, 'W' )
endfunc

func! Vim_MainStartBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Vim_MainStartPattern, 'bW' )
  " normal! {
  normal! kk
  call search( g:Vim_MainStartPattern, 'W' )
endfunc










