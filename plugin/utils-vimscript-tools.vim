
" Documentation:
" https://vim-jp.org/vimdoc-en/index.html
" https://w0rp.com/blog/post/vim-script-for-the-javascripter/

"  see PasteListAsLines - not needed any more
" nnoremap <leader>bb :call HsStringListToLines()<cr>
func! HsStringListToLines()
  let a = eval( getline('.') )
  call append('.', a)
endfunc
" ["eins","eins","eins"]


" EDIT VIM SCRIPT: ---------------------------------------------------------------------

" Sourcing Parts Of Vimscript:
" the current file
" nnoremap <silent><leader>so :w<cr>:so %<cr>
nnoremap <silent> <leader>so :call SourceFile()<cr>:echo 'Sourced ' . expand('%:t') . "!"<cr>

func! SourceFile ()
  silent exec "w"
  if &filetype == 'lua'
    lua require'plenary.reload'.reload_module( vim.fn.expand('%:t:r') )
    luafile %
  else
    exec 'source %'
  endif
endfunc

" seems to do the same with python
nnoremap geF :call ShellReturn( 'python ' . expand('%') )<cr>


" inoremap <expr> jk pumvisible() ? "<C-e>" : "<Esc>"


" the vimrc
nnoremap <silent><leader><leader>sv :so $MYVIMRC<cr>
" the following paragraph/lines
nnoremap <leader>s} "ty}:@t<cr>
nnoremap <leader>sip m'"tyip:@t<cr>``
" Uses "h textobj-function"
" nmap     <leader>saf m'"tyaf:@t<cr>``
" nnoremap <silent> <leader>ss :exec getline('.')<cr>:echo 'Line sourced!'<cr>
" nnoremap <silent> <leader>se :exec getline('.')<cr>

nnoremap <silent> <leader>ss :call SourceRange()<cr>
nnoremap <silent> <leader>se :call SourceRange()<cr>

" same as above, but clutters the register
" nnoremap <leader>si "tyy:@t<cr>

" Reload a lua module:
nnoremap <silent> <leader>sR :lua put( package.loaded[vim.fn.expand('%:t:r')] )<cr>
nnoremap <silent> <leader>sr :lua require'plenary.reload'.reload_module( vim.fn.expand('%:t:r'))<cr>:luafile %<cr>:echo 'reloaded!'<cr>
" nnoremap <silent> <leader><leader>sr :lua require( vim.fn.expand('%:t:r') )<cr>
" nnoremap <silent> <leader>sr :echo "use l so"<cr>

command! -nargs=+ Rld lua require'plenary'.reload.reload_module(<q-args>)
" Rld utils_general
" Rld tools_external
" exec 'Rld' expand('%:t:r')

" free mappings? <leader>s..
" TODO these map don't seem ideal. mnemonic not destinct enough?
command! SourceLine :normal yy:@"<cr>:echo 'Line sourced!'<cr>

" Call Func: call the function name in cursor line, without args
nnoremap <leader>cf (Wyw:call <c-r>"()<cr>^
" Todo: Call function with testarg. Example line below of function:
" testarg: 'tell application "Finder" to make new Finder window'
" find next testarg line, "Wy[to some other register])"
" nnoremap <leader>caf (Wyw:call <c-r>"(<c-r>[other reg])<cr>^

func! SourceRange() range
  silent exec "w"
  let tmpsofile = tempname()
  call writefile(getline(a:firstline, a:lastline), l:tmpsofile)
  if &filetype == 'lua'
    exec "luafile " . l:tmpsofile
  else
    exec "source " . l:tmpsofile
  endif
  call delete(l:tmpsofile)

  " Note: I can't access the range vars like this
  " echo ("Sourced " . a:lastline - a:firstline . " lines!")
  return RangeAux(a:firstline, a:lastline)
endfunc
" TIP: Range example function

func! SourceLines( cmd, lines )
  let tempSourceFile = tempname()
  call writefile( a:lines, tempSourceFile)
  exec a:cmd tempSourceFile
  call delete( tempSourceFile )
endfunc

func! SourcePrintCommented() " ■
  if &filetype == 'lua' || &filetype == 'purescript_scratch'
    let expr = getline('.')[3:]
    let code = 'vim.print( vim.inspect( ' . expr . ' ) )'
    " let code = 'vim.fn.FloatingSmallNew( ' . expr . ' )'
    let cmd = 'luafile'
  elseif &filetype == 'markdown' || &filetype == 'purescript_scratch' || &filetype == ''
    let expr = getline('.')
    let code = 'vim.print( vim.inspect( ' . expr . ' ) )'
    let code = expr
    " let code = 'vim.fn.FloatingSmallNew( ' . expr . ' )'
    let cmd = 'luafile'
  elseif &filetype == 'vim'
    " QUICKFIX: when using .lua files with ft=vim
    if getline('.')[0:1] == "--"
      let expr = getline('.')[3:]
      let code = 'vim.print( vim.inspect( ' . expr . ' ) )'
      " let code = 'vim.fn.FloatingSmallNew( ' . expr . ' )'
      let cmd = 'luafile'
    else
      let expr = getline('.')[1:]
      " let code = 'echo ' . expr
      let code = 'call v:lua.putt( ' . expr . ' )'
      " let code = 'call FloatingSmallNew( ' . expr . ' )'
      let cmd = 'source'
    endif
  else
    echoe &ft
    echoe "File type not supported!"
    return
  endif
  call SourceLines( cmd, [ code ] )
endfunc " ▲


func! PrintVimOrLuaLine()
  let line = getline('.')

  if &filetype == 'vim'
    let expr = line[1:]

    let code = [0,0]
    let code[0] = 'let ret = ' . expr
    let code[1] = 'if ret | call v:lua.putt(ret) | endif'

    call SourceLines( 'source', code )
    return
  endif

  let expr = line[0:1] == "--" ? 
    \ line[3:] : line

  let code = [0,0,0]
  let code[0] = 'local ret = ' . expr
  let code[1] = 'local printVal = ret and vim.inspect(ret) or ""'
  let code[2] = 'vim.print( printVal )'

  call SourceLines( 'luafile', code )
endfunc
" NOTE how to use vim dictionary to pass a lua table from vim
" v:lua.require("neo-tree.command").execute({ 'action': "show", 'position': "right" })
" v:lua.require("neo-tree.command").execute({ 'action': "close" })

" au ag BufNewFile,BufRead,WinNew *.vim,*.lua,*.md call VScriptToolsBufferMaps()


let g:rgx_main_symbol_vimLua = '^(func|local\sfunction|command!|-- ─ |" ─ |#).*'

func! VScriptToolsBufferMaps()

  nnoremap <silent><buffer> <c-p>         :call Vim_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Vim_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>

  " nnoremap <silent><buffer> ge:  :call v:lua.require( 'utils_general' ).RgxSelect_Picker([], g:rgx_main_symbol_vimLua, ["-g", ".vim", ".lua"], [expand('%:p')] )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.require('utils_general').RgxSelect_Picker([], "[A-Z]{3,}", ["-g", ".txt", ".vim", ".lua"], [expand('%:p')] )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.require( 'utils_general' ).RgxSelect_Picker( [], g:rgx_main_symbol_vimLua, [], [ "/Users/at/.config/nvim/plugin", "/Users/at/.config/nvim/lua"] )<cr>

  nnoremap <silent><buffer> ge;  :call v:lua.Search_mainPatterns( expand("%:p") )<cr>
  " nnoremap <silent><buffer> ge:  :call v:lua.Search_mainPatterns( expand("%:p:h") )<cr>
  nnoremap <silent><buffer> ge:  :call v:lua.Search_mainPatterns( getcwd(), g:rgx_main_symbol_vimLua )<cr>

  nnoremap <silent><buffer> gsd  :call v:lua.Search_mainPatterns( getcwd(), expand('<cword>') )<cr>
  xnoremap <silent><buffer> gsd  :call v:lua.Search_mainPatterns( getcwd(), GetVisSel() )<cr>

  nnoremap <silent><buffer> gei :call PrintVimOrLuaLine()<cr>
  call tools_scala#bufferMaps_shared()
endfunc


" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Vim_MainStartPattern = '\v^(\#|function|func\!|\i.*function|local)'


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






function! RangeAux(lnum1, lnum2) abort
  " echo a:lnum1 . ' - ' . a:lnum2
  " echo a:lnum2
  let pos1 = [0, a:lnum1, 1, 0]
  let pos2 = [0, a:lnum2, 1, 0]
  " call highlightedyank#highlight#add( 'HighlightedyankRegion', pos1, pos2, 'line', 500)
endfunction


nnoremap <silent> <leader>s m':set opfunc=OpSourceVimL<cr>g@
vnoremap <silent> <leader>ss :<c-u>call OpSourceVimL(visualmode(), 1)<cr>

" Uses "h textobj-function" .. ? it does not!?
" * SourceVimL Operator function allows e.g.
" * <leader>saf "source around function"
" * <leader>si" "source inside quotes"
func! OpSourceVimL( motionType, ...)
  " Use either the vis-select or the motion marks
  let [startMark, endMark] = a:0 ? ["'<", "'>"] : ["'[", "']"]
  " Line and column of start+end of either vis-sel or motion
  let [startLine, startColumn] = getpos( startMark )[1:2]
  let [endLine,   endColumn]   = getpos( endMark )[1:2]
  " echo a:motionType . ' ' . startLine . ' ' . startColumn . ' ' . endLine . ' ' . endColumn
  let [startColumn, endColumn] = (a:motionType == 'line') ? [1, 200] : [startColumn, endColumn]
  let selectedVimCode = GetTextWithinLineColumns_asLines( startLine, startColumn, endLine, endColumn )
  " call append( line('.'), GetTextWithinLineColumns_asLines( startLine, startColumn, endLine, endColumn ) )

  " call SourceLines( l:selectedVimCode )
  exec startLine . ',' . endLine 'call SourceRange()'
  " echoe startLine
  " echoe endLine

  " Flash the sourced text for 500ms
  " call highlightedyank#highlight#add( 'HighlightedyankRegion', getpos(startMark), getpos(endMark), a:motionType, 500)
  " call highlightedyank#highlight#add( 'HighlightedyankRegion', startLine, endLine, 'line', 500)
endfunc
" Tests: `leader s$` on [e]cho and visual-sel echo ..{{{
" Some text echo 'hi 2'
" Vis-Sel the following lines, also `leader sj` or `leader s\j..`
" echo 'hi 1'
" echo 'hi 2'
" call highlightedyank#highlight#add( 'HighlightedyankRegion', getpos("'<"), getpos("'>"), 'char', 500)
" call highlightedyank#highlight#add( 'HighlightedyankRegion', getpos("'<"), getpos("'>"), 'line', 500)}}}

" Source a range
command! -range Source <line1>,<line2>call SourceRange()
" Run a VimScript function and insert the returned result below the paragraph
nnoremap <leader>sh wwy$}i<c-r>=<c-r>"<cr><esc>{w
" Run a VimScript snippet (til end of the line) and insert the returned result!
nnoremap <leader>sy y$o<c-r>=<c-r>"<cr><esc>
" Run a VimScript snippet (til end of the line) and echo the result in the command line
nnoremap <leader>sx y$:echom <c-r>"<cr>


command! RuntimepathShow exec "new | call append( line('.'), split( &runtimepath , ',' ) )"


