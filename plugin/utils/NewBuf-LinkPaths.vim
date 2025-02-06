

" ─   Link paths                                        ──

" l cp/P
" l cl/L
" l cs/S
" l ct   - transform absolute > local or local to absolute

nnoremap <silent> <leader>cp  :call ClipBoard_LinkPath_plain  ( "shorten" )<cr>
nnoremap <silent> <leader>cP  :call ClipBoard_LinkPath_plain  ( "full" )<cr>
nnoremap <silent> <leader>cl  :call ClipBoard_LinkPath_linepos  ( "shorten" )<cr>
nnoremap <silent> <leader>cL  :call ClipBoard_LinkPath_linepos  ( "full" )<cr>
nnoremap <silent> <leader>cs  :call ClipBoard_LinkPath_linesearch  ( "shorten" )<cr>
nnoremap <silent> <leader>cS  :call ClipBoard_LinkPath_linesearch  ( "full" )<cr>

nnoremap <silent> <leader>ct                  :call ClipBoard_LinkPath_makeLocal()<cr>
nnoremap <silent> <leader><leader>ct          :call ClipBoard_LinkPath_makeAbsolute( "shorten" )<cr>
nnoremap <silent> <leader><leader><leader>ct  :call ClipBoard_LinkPath_makeAbsolute( "full" )<cr>

func! ClipBoard_LinkPath_makeLocal()
  let [path; maybeLinkExt] = @*->split('‖')
  let relPath = fnamemodify( path, ":.")
  let linkExt = len( maybeLinkExt ) ? maybeLinkExt[0] : ""
  call ClipBoard_LinkPath( relPath, linkExt, "don't shorten" )
endfunc

func! ClipBoard_LinkPath_makeAbsolute( shorten )
  let [path; maybeLinkExt] = @*->split('‖')
  let relPath = fnamemodify( path, ":p")
  let linkExt = len( maybeLinkExt ) ? maybeLinkExt[0] : ""
  call ClipBoard_LinkPath( relPath, linkExt, a:shorten )
endfunc

func! ClipBoard_LinkPath_plain( shorten )
  call ClipBoard_LinkPath( expand('%:p'), "", a:shorten )
endfunc

func! ClipBoard_LinkPath_linepos( shorten )
  let linkExtension = ":" . line('.') . ":" . col('.')
  call ClipBoard_LinkPath( expand('%:p'), linkExtension, a:shorten )
endfunc

func! LinkPath_linepos()
  let linkExtension = ":" . line('.') . ":" . col('.')
  return expand('%:p') . "‖" . linkExtension
endfunc


" now need to do this in the NewBuf_ functions. see comments
func! AlternateFileLoc_save()
  let w:AlternateFileLoc = LinkPath_linepos()
endfunc

" A neo-tree or dirvish window might (should generally) have an Alternate (origin) file location set.
" Once _restore is called, this window will show the alternate file.
" At the same time usually the (corresponding) AlternateTreeView
" is set: ~/.config/nvim/plugin/config/neo-tree.lua‖/vim.fn.Alte
func! AlternateFileLoc_restore( cmd )
  if !(exists( 'w:AlternateFileLoc' )) | return | endif
  let [path; maybeLinkExt] = w:AlternateFileLoc->split('‖')
  let w:AlternateFileLoc = v:null
  exec a:cmd path
  if len(maybeLinkExt) | call Link_jumpToLine( maybeLinkExt[0] ) | endif
endfunc
" AlternateFileLoc_save()
" AlternateFileLoc_restore('new')

func! AlternateFileLoc_info()
  " if !(exists( 'w:AlternateFileLoc' )) | return | endif
  let [path; maybeLinkExt] = w:AlternateFileLoc->split('‖')
  return fnamemodify( path, ':t' )
endfunc


" TODO why not use: (?) ~/.config/nvim/plugin/utils/NewBuf-LinkPaths.vim‖/LinkPath_get()
func! ClipBoard_LinkPath_linesearch( shorten )
  let filePath = expand('%:p')
  let lineStr = getline('.')
  if lineStr =~ '─'
    let searchStr = GetHeadingTextFromHeadingLine( line('.') )
    call ClipBoard_LinkPath( filePath, "*" . searchStr, a:shorten )
  else
    let searchStr = lineStr->LineSearchStr_skipLeadingKeywords()->LineSearch_makeShortUnique_orWarn()
    call ClipBoard_LinkPath( filePath, "/" . searchStr, a:shorten )
  endif
endfunc
" FOR TESTING GO: ~/.config/nvim/plugin/utils/NewBuf-LinkPaths.vim‖/NOTE:ˍthisˍ
" ClipBoard_LinkPath_linesearch( 'shorten' )
" echo ClipBoard_LinkPath_linesearch( 'full' )

func! ClipBoard_LinkPath( path, linkExtension, shorten )
  set clipboard=unnamedplus
  let path = a:shorten != 'shorten' ? a:path : substitute( a:path, '/Users/at/', '~/', 'g' )
  if len( a:linkExtension )
    let linkExtension = substitute( a:linkExtension, " ", "ˍ", "g" )
    let cp = path . "‖" . linkExtension
  else
    let cp = path
  endif
  let @+ = cp
  let @* = cp
  let @" = cp
  echom 'path:' path
  if len( a:linkExtension ) | echom 'ext:' a:linkExtension | endif
endfunc
" ClipBoard_LinkPath( getcwd(), '" ─   Link paths                                        ──', 'shorten')


func! LinkPath_get()
  let [path, linkExt] = LinkPath_as_tuple()
  return path . linkExt
endfunc

func! LinkPath_as_tuple()
  let filePath = expand('%:p')
  let filePath = substitute( filePath, '/Users/at/', '~/', 'g' )

  let lineStr = getline('.')
  if lineStr =~ '─'
    let searchStr = GetHeadingTextFromHeadingLine( line('.') )
    let searchStr = substitute( searchStr, " ", "ˍ", "g" )
    return [filePath, "‖*" . searchStr]
  else
    let searchStr = LinkPath_getKeyword()
    let searchStr = substitute( searchStr, " ", "ˍ", "g" )
    return [filePath, "‖/" . searchStr]
  endif
endfunc

func! LinkPath_getKeyword()
  let lineStr = getline('.')
  let searchStr = lineStr->LineSearchStr_skipLeadingKeywords()->LineSearch_makeShortUnique_orWarn()
  return searchStr
endfunc


func! Link_jumpToLine( linkExtension )
  let linkExtension = substitute( a:linkExtension, "ˍ", " ", "g" )
  let linkKey = linkExtension[0]
  let linkVal = linkExtension[1:]
  if linkKey == ":"
    let [lineNum; maybeColumn] = linkVal->split(":")
    let column = len(maybeColumn) ? maybeColumn[0] : 0
    " vim.api.nvim_win_set_cursor(win, {line, col})
    call setpos( '.', [0, lineNum, column, 0] )
  elseif linkKey == "*"
    " if !search( '\v─\s{-}' . escape(linkVal, '\'), 'cw' ) 
    if !search( '\v' . escape(linkVal, '\'), 'cw' ) 
      echo 'Header not found: ' linkVal
    endif
    normal ^
  elseif linkKey == "/"
    " Improvement 2024-02:
    " - proper(?) escaping of special chars in search code
    " - use highlight search to find alt search match (as a fallback)
    let escaped = EscapeSpecialChars( linkVal )
    if !search( '\v' . escaped, 'cw' ) 
      echo 'Keyword not found: ' linkVal
    else
      exec 'let @/ = "' .. escaped .. '"' 
      set hlsearch
    endif
  else
    echoe 'unsupported linkKey: ' . linkKey
  endif
endfunc

" Link_jumpToLine( ":44" )
" Link_jumpToLine( "/func! Link_jumpToLine( linkExtList )" )
" Link_jumpToLine( "/--ˍ─ˍaifb" )
" Link_jumpToLine( "/" . getline(3)[:10]  )
" "123:45"->split(":")
" "123"->split(":")
" ~/.config/nvim/plugin/utils-navigation.vim‖*someˍotherˍt
" ~/.config/nvim/plugin/utils-navigation.vim‖*Windows
" ~/.config/nvim/plugin/NewBuf-direction-maps.vim‖*NewBufˍfromˍpath
" ~/.config/nvim/plugin/NewBuf-LinkPaths.vim‖*Linkˍpaths

func! LineSearch_makeShortUnique_orWarn( fullString )
  " let attempts = [ a:fullString[:10], a:fullString[:15], a:fullString[:20], a:fullString[:25], a:fullString[:30], a:fullString ]
  let attempts = [ a:fullString[:25], a:fullString[:30], a:fullString ]
  let idx = attempts->functional#findP({ str -> LineSearch_isUniqueInBuf( str ) })
  if idx == -1 | echo "The current line is not unique in this buffer." | endif
  return attempts[ idx ]
endfunc
" echo LineSearch_makeShortUnique_orWarn("elseif typeMode == 'zio_collection'" )
" LineSearch_makeShortUnique_orWarn('abbcc 2abbcc 3abbcc 4abbcc 5abbcc 6abbcc 7abbcc' )
" LineSearch_makeShortUnique_orWarn('LineSearch_akeSortUnique_orWarn( fulltring )' )
" LineSearch_makeShortUnique_orWarn('-- ─       aifbbs t this other' )
" LineSearch_makeShortUnique_orWarn("CityId( '123' )" )
" abbcc 2abbcc 3abbcc 4abbcc 5abbcc 6abbcc 7abbcc


func! LineSearch_isUniqueInBuf( searchChars )
  " return search( escape(a:searchChars, '\'), 'nbw' ) == line('.')
  " return search( '\V\' . escape(a:searchChars, '\'), 'nbw' ) == line('.')
  let [oLine, oCol] = getpos('.')[1:2]
  call setpos('.', [0, oLine, 0, 0] )
  " let lineNum = search( '\V\' . '^' . escape(a:searchChars, '\'), 'nbw' )
  " let lineNum = search( '\V\' . escape(a:searchChars, '\'), 'nbw' )
  let esc1 = a:searchChars
  " NOTE: this line. there may be other char I would like to escape like this.
  let esc1 = substitute( a:searchChars, '=', '\\=', 'g' )
  let esc1 = substitute( esc1, '(', '\\(', 'g' )
  let esc1 = substitute( esc1, ')', '\\)', 'g' )
  let esc1 = substitute( esc1, '{', '\\{', 'g' )
  let esc1 = substitute( esc1, '}', '\\}', 'g' )
  " let esc1 = escape( esc1, '\' )
  let lineNum = search( '\v' . esc1, 'nbw' )
  call setpos('.', [0, oLine, oCol, 0] )
  return lineNum == 0 || lineNum == line('.')
endfunc
" substitute( "elseif typeMode == 'zio_collection'", '=', '\\=', 'g' )
" echo LineSearch_isUniqueInBuf( "elseif typeMode == 'zio_collection'" )
" echo LineSearch_isUniqueInBuf( "elseif type" )
" echo LineSearch_isUniqueInBuf( "elxseif type" )
" LineSearch_isUniqueInBuf( 'abbcc 2abbcc 3abbcc 4abbcc 5abbcc 6abbcc 7abbcc' )
" LineSearch_isUniqueInBuf("CityId( '123' )" )
" abbcc 2abbcc 3abbcc 4abbcc 5abbcc 6abbcc 7abbcc
" echo search( '\V\' . escape('elseif typeMode', '\'), 'nbw' )
" echo search( '\v' . escape('elseif typeMode', '\'), 'nbw' )
" echo search( '\v' . escape('elseif typeMode \=\=', '\'), 'nbw' )

let g:LineSearch_ScalaSkipWords = "sealed|inline|private|given|final|trait|override|def|abstract|type|val|lazy|case|enum|final|object|class"
let g:LineSearch_TsSkipWords = "export|const"
let g:LineSearch_VimSkipWords = ['let', '\"', '--', 'if', 'func', 'func!']
let g:LineSearch_SkipWords_ptn = '\v^(' . g:LineSearch_VimSkipWords->join('|') . '|' . g:LineSearch_ScalaSkipWords . '|' . g:LineSearch_TsSkipWords . ')$'

func! LineSearchStr_skipLeadingKeywords( sourceStr )
  " strip leading whitespace to save space in link text. (therefore searching for this key can not start at the beginning of the line.
  let sourceStr = a:sourceStr->substitute('\v^\s*', '', '')
  " prevent double whitespaces (after the first word) to get lost when using split into words
  let sourceStr =   sourceStr->substitute( "  ", " ", "g" )
  let words = split( sourceStr )
  let firstUsefulWordIdx = functional#findP( words, {x-> x !~# g:LineSearch_SkipWords_ptn} )
  " let sourceStr = substitute( a:sourceStr, "  ", " ", "g" )
  let keywordsSkippedText = words[firstUsefulWordIdx:]->join( " " )
  let final = keywordsSkippedText->substitute( "", " ", "g" )
  return final
endfunc

" functional#findP( ['let', 'func!', 'inline', 'def', 'de', 'ee'], {x-> x !~# g:LineSearch_SkipWords_ptn} )
" functional#findP( ['let', 'func!', 'inline', 'def', 'de', 'ee'], {x-> x !~# g:LineSearch_SkipWords_ptn} )
" ['let', 'func!', 'inline', 'def', 'de', 'ee']->functional#findP( {x-> x !~# g:LineSearch_SkipWords_ptn} )
" func! abcompletelabel( currentCompl )
" LineSearchStr_skipLeadingKeywords( getline( line('.')-1 ) )
" echo LineSearchStr_skipLeadingKeywords( getline( line('.') ) )
" LineSearchStr_skipLeadingKeywords( getline( 47 ) )
" LineSearchStr_skipLeadingKeywords( getline( 29 ) )
" -1 ? 'y' : 'n'
" "   abc"->substitute('\v^\s*', '', '')

















