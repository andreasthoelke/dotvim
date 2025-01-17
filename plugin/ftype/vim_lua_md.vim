
" au ag BufNewFile,BufRead,WinNew *.vim,*.lua,*.md call VScriptToolsBufferMaps()


let g:rgx_main_symbol_vimLua = '^(func|local\sfunction|command!|-- ─ |" ─ |#).*'


func! MarkdownBufferMaps()
  call VScriptToolsBufferMaps()

  nnoremap <silent><buffer><leader>ot :Vista<cr>
  " nnoremap <silent><buffer>gdi :lua require("follow-md-links").follow_link()<cr>

  nnoremap <silent><buffer> gdp  :call NewBuf_fromCursorMarkdownRef( "preview_back" )<cr>
  nnoremap <silent><buffer> gdo  :call NewBuf_fromCursorMarkdownRef( "float" )<cr>
  nnoremap <silent><buffer> gdi  :call NewBuf_fromCursorMarkdownRef( "full" )<cr>
  nnoremap <silent><buffer> gdt  :call NewBuf_fromCursorMarkdownRef( "tab" )<cr>
  nnoremap <silent><buffer> gdT  :call NewBuf_fromCursorMarkdownRef( "tab_bg" )<cr>
  " _                       
  nnoremap <silent><buffer> gdv  :call NewBuf_fromCursorMarkdownRef( "right" )<cr>
  nnoremap <silent><buffer> gdV  :call NewBuf_fromCursorMarkdownRef( "right_back" )<cr>
  nnoremap <silent><buffer> gda  :call NewBuf_fromCursorMarkdownRef( "left" )<cr>
  nnoremap <silent><buffer> gdu  :call NewBuf_fromCursorMarkdownRef( "up" )<cr>
  nnoremap <silent><buffer> gdU  :call NewBuf_fromCursorMarkdownRef( "up_back" )<cr>
  nnoremap <silent><buffer> gds  :call NewBuf_fromCursorMarkdownRef( "down" )<cr>
  nnoremap <silent><buffer> gdS  :call NewBuf_fromCursorMarkdownRef( "down_back" )<cr>

  " v:lua.MarkdownBufferMapsLua()
endfunc


func! SmithyBufferMaps()
  call Scala_bufferMaps_shared()

  nnoremap <silent><buffer> <leader><c-p> :call Scala_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <c-p>         :call Scala_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Scala_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <c-n>         :call Scala_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>

  " nnoremap <silent><buffer><leader>ot :Vista<cr>
endfunc


func! VScriptToolsBufferMaps()
  call Scala_bufferMaps_shared()

  " the below should overwrite the default/scala maps

  nnoremap <silent><buffer> <leader>ot  :Vista<cr>
  nnoremap <silent><buffer> ,ot  :Vista nvim_lsp<cr>

  " Untested
  " nnoremap <silent><buffer> <c-]> m'<Plug>Markdown_EditUrlUnderCursor

  nnoremap <silent><buffer> I :call Vim_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Vim_ColonBackw()<cr>

  nnoremap <silent><buffer> <c-p>         :call Vim_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Vim_MainStartBindingForw()<cr>:call ScrollOff(27)<cr>

  nnoremap <silent><buffer> <leader><c-p> :call Vim_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Vim_TopLevBindingForw()<cr>:call ScrollOff(22)<cr>

  " nnoremap <silent><buffer> ge:  :call v:lua.require( 'utils_general' ).RgxSelect_Picker([], g:rgx_main_symbol_vimLua, ["-g", ".vim", ".lua"], [expand('%:p')] )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.require('utils_general').RgxSelect_Picker([], "[A-Z]{3,}", ["-g", ".txt", ".vim", ".lua"], [expand('%:p')] )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.require( 'utils_general' ).RgxSelect_Picker( [], g:rgx_main_symbol_vimLua, [], [ "/Users/at/.config/nvim/plugin", "/Users/at/.config/nvim/lua"] )<cr>

  " nnoremap <silent><buffer> ge;  :call v:lua.Search_mainPatterns( 'file' )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.Search_mainPatterns( 'global' )<cr>

  nnoremap <silent><buffer> gei :call PrintVimOrLuaLine()<cr>
  nnoremap <silent><buffer> gew :call PrintVimOrLuaParag()<cr>
endfunc


let g:Vim_colonPttn = MakeOrPttn( ['\:', '\#', '-', '=', '\$', '\sor\s', '?', 'and\s', 'not\s', '\.\.', 'if\s', 'elseif', 'then\s', 'return'] )
" let g:Vim_colonPttn = MakeOrPttn( ['\:', '\#', '-', '=\s', 'or\s', '?', 'and\s', 'not\s', '\.\.', 'if\s', 'elseif', 'then\s', 'return'] )

func! Vim_ColonForw()
  " call SearchSkipSC( g:Vim_colonPttn, 'W' )
  call search( g:Vim_colonPttn, 'eW' )
  " 'e' move to the end of the match, making sure the normal w jumps to after the column seperator
  call Vim_ColgoFistWord()
endfunc

func! Vim_ColonBackw()
  normal bh
  call SearchSkipSC( g:Vim_colonPttn, 'bW' )
  call Vim_ColgoFistWord()
endfunc


" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Vim_MainStartPattern = '\v^(\#|.*─|function|func\!|\i.*function\(|local\sfunction\s|.{-}\*\S{-}\*)'
" the *\S{-}\* patterns is searching vim help headlines
let g:Vim_TopLevelPattern = '\v^(\=\=|\#\s|.*─)'


func! Vim_MainStartBindingForw()
  normal! jj
  call search( g:Vim_MainStartPattern, 'W' )
  call Vim_goFistWord()
endfunc

func! Vim_MainStartBindingBackw()
  normal! ^
  call search( g:Vim_MainStartPattern, 'bW' )
  normal! kk
  call search( g:Vim_MainStartPattern, 'W' )
  call Vim_goFistWord()
endfunc

func! Vim_TopLevBindingForw()
  normal! jj
  call search( g:Vim_TopLevelPattern, 'W' )
  call Vim_goFistWord()
endfunc

func! Vim_TopLevBindingBackw()
  normal! ^
  call search( g:Vim_TopLevelPattern, 'bW' )
  normal! kk
  call search( g:Vim_TopLevelPattern, 'W' )
  call Vim_goFistWord()
endfunc

func! Vim_goFistWord()
  if &ft == 'vim'
    normal! W
  elseif &ft == 'lua'
    normal! ww
    let char = GetCharAtCursor()
    if char == '.' 
      normal! l
    endif
    if char == '=' 
      normal! b
    endif

  elseif &ft == 'markdown'
    normal! w
  endif
endfunc

func! Vim_ColgoFistWord()
  if &ft == 'vim'
    normal! w
  elseif &ft == 'lua'
    normal! w
  elseif &ft == 'markdown'
    normal! w
  elseif &ft == 'sh'
    normal! l
    " cover name=val syntax
  endif
endfunc
" GetCharAtCursor()





