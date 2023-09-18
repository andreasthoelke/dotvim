

" ─   Link paths                                        ──

" l cp/P
" l cl/L
" l cs/S
" l ct   - transform absolute > local or local to absolute

nnoremap <silent> <leader>cp  :call ClipBoard_LinkPath_plain  ( "shorten" )<cr>
nnoremap <silent> <leader>cP  :call ClipBoard_LinkPath_plain  ( "full" )<cr>
nnoremap <silent> <leader>cl  :call ClipBoard_LinkPath_linenum  ( "shorten" )<cr>
nnoremap <silent> <leader>cL  :call ClipBoard_LinkPath_linenum  ( "full" )<cr>
nnoremap <silent> <leader>cs  :call ClipBoard_LinkPath_linesearch  ( "shorten" )<cr>
nnoremap <silent> <leader>cS  :call ClipBoard_LinkPath_linesearch  ( "full" )<cr>

nnoremap <silent> <leader>ct                  :call ClipBoard_LinkPath_makeLocal()<cr>
nnoremap <silent> <leader><leader>ct          :call ClipBoard_LinkPath_makeAbsolute( "shorten" )<cr>
nnoremap <silent> <leader><leader><leader>ct  :call ClipBoard_LinkPath_makeAbsolute( "full" )<cr>

func! ClipBoard_LinkPath_makeLocal()
  let [path; maybeLinkExt] = @*->split('#')
  let relPath = fnamemodify( path, ":.")
  let linkExt = len( maybeLinkExt ) ? maybeLinkExt[0] : ""
  call ClipBoard_LinkPath( relPath, linkExt, "don't shorten" )
endfunc

func! ClipBoard_LinkPath_makeAbsolute( shorten )
  let [path; maybeLinkExt] = @*->split('#')
  let relPath = fnamemodify( path, ":p")
  let linkExt = len( maybeLinkExt ) ? maybeLinkExt[0] : ""
  call ClipBoard_LinkPath( relPath, linkExt, a:shorten )
endfunc

func! ClipBoard_LinkPath_plain( shorten )
  call ClipBoard_LinkPath( expand('%:p'), "", a:shorten )
endfunc

func! ClipBoard_LinkPath_linenum( shorten )
  call ClipBoard_LinkPath( expand('%:p'), ":" . line('.'), a:shorten )
endfunc

func! ClipBoard_LinkPath_linesearch( shorten )
  let searchStr = getline('.')->LineSearchStr_skipLeadingKeywords()->LineSearch_makeShortUnique_orWarn()
  call ClipBoard_LinkPath( expand('%:p'), "/" . searchStr, a:shorten )
endfunc

func! ClipBoard_LinkPath( path, linkExtension, shorten )
  let path = a:shorten != 'shorten' ? a:path : substitute( a:path, '/Users/at/', '~/', 'g' )
  let cp = path . "#" . a:linkExtension
  let @+ = cp
  let @* = cp
  let @" = cp
  echom 'path:' path
  if len( a:linkExtension ) | echom 'ext:' a:linkExtension | endif
endfunc

func! Link_jumpToLine( linkExtList )
  let linkKey = a:linkExtList[0]
  let linkVal = a:linkExtList[1:]
  if linkKey == ":"
    call setpos( '.', [0, linkVal, 0, 0] )
  elseif linkKey == "/"
    if !search( '\V\' . escape(linkVal, '\'), 'cw' ) 
      echo 'Line not found: ' linkVal
    endif
  else
    echoe 'unsupported linkKey: ' . linkKey
  endif
endfunc
" Link_jumpToLine( [":44"] )
" Link_jumpToLine( ["/func! Link_jumpToLine( linkExtList )"] )
" Link_jumpToLine( ["/func! Link_jumpToLine( linkExtList )"] )
" Link_jumpToLine( ["/" . getline(3)[:10] ] )

func! LineSearch_makeShortUnique_orWarn( fullString )
  let attempts = [ a:fullString[:10], a:fullString[:15], a:fullString[:20], a:fullString[:25], a:fullString[:30], a:fullString ]
  let idx = attempts->functional#findP({ str -> LineSearch_isUniqueInBuf( str ) })
  if idx == -1 | echo "The current line is not unique in this buffer." | endif
  return attempts[ idx ]
endfunc
" LineSearch_makeShortUnique_orWarn('abbcc 2abbcc 3abbcc Xabbcc 5abbcc 6abbcc 7abbcc' )
" LineSearch_makeShortUnique_orWarn('LineSearch_akeSortUnique_orWarn( fulltring )' )
" abbcc 2abbcc 3abbcc 4abbcc 5abbcc 6abbcc 7abbcc

func! LineSearch_isUniqueInBuf( searchChars )
  " return search( escape(a:searchChars, '\'), 'nbw' ) == line('.')
  return search( '\V\' . escape(a:searchChars, '\'), 'nbw' ) == line('.')
endfunc
" LineSearch_isUniqueInBuf( 'abbcc 2abbcc 3abbcc 4abbcc 5abbcc 6abbcc 7abbcc' )

let g:LineSearch_ScalaSkipWords = "sealed|inline|private|given|final|trait|override|def|abstract|type|val|lazy|case|enum|final|object|class"
let g:LineSearch_VimSkipWords = ['let', 'if', 'func', 'func!']
let g:LineSearch_SkipWords_ptn = '\v(' . g:LineSearch_VimSkipWords->join('|') . '|' . g:LineSearch_ScalaSkipWords . ')'

func! LineSearchStr_skipLeadingKeywords( sourceStr )
  let words = split( a:sourceStr )
  let firstUsefulWordIdx = functional#findP( words, {x-> x !~# g:LineSearch_SkipWords_ptn} )
  return words[firstUsefulWordIdx:]->join()
endfunc
" functional#findP( ['let', 'func!', 'inline', 'def', 'de', 'ee'], {x-> x !~# g:LineSearch_SkipWords_ptn} )
" ['let', 'func!', 'inline', 'def', 'de', 'ee']->functional#findP( {x-> x !~# g:LineSearch_SkipWords_ptn} )
" LineSearchStr_skipLeadingKeywords( getline( 47 ) )
" LineSearchStr_skipLeadingKeywords( getline( 29 ) )
" -1 ? 'y' : 'n'

















