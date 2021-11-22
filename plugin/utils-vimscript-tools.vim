
" Documentation:
" https://vim-jp.org/vimdoc-en/index.html
" https://w0rp.com/blog/post/vim-script-for-the-javascripter/

"  see PasteListAsLines - not needed any more
nnoremap <leader>bb :call HsStringListToLines()<cr>
func! HsStringListToLines()
  let a = eval( getline('.') )
  call append('.', a)
endfunc
" ["eins","eins","eins"]


" EDIT VIM SCRIPT: ---------------------------------------------------------------------

" Sourcing Parts Of Vimscript:
" the current file
nnoremap <silent><leader>so :w<cr>:so %<cr>
" the vimrc
nnoremap <silent><leader><leader>sv :so $MYVIMRC<cr>
" the following paragraph/lines
nnoremap <leader>s} "ty}:@t<cr>
nnoremap <leader>sip m'"tyip:@t<cr>``
" Uses "h textobj-function"
" nmap     <leader>saf m'"tyaf:@t<cr>``
nnoremap <leader>ss :exec getline('.')<cr>:echo 'Line sourced!'<cr>
nnoremap <leader>se :exec getline('.')<cr>
" same as above, but clutters the register
" nnoremap <leader>si "tyy:@t<cr>

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
  let tmpsofile = tempname()
  call writefile(getline(a:firstline, a:lastline), l:tmpsofile)
  execute "source " . l:tmpsofile
  call delete(l:tmpsofile)
endfunc
" TIP: Range example function

func! SourceLines( lines )
  let tmpsofile = tempname()
  call writefile( a:lines, l:tmpsofile)
  execute "source " . l:tmpsofile
  call delete(l:tmpsofile)
endfunc

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
  call SourceLines( l:selectedVimCode )
  " Flash the sourced text for 500ms
  call highlightedyank#highlight#add( 'HighlightedyankRegion', getpos(startMark), getpos(endMark), a:motionType, 500)
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


