

func! GetTextWithinLineColumns_asLines( startLine, startColumn, endLine, endColumn )
  let lines = getline( a:startLine, a:endLine )
  " The last (-1) line
  let lines[-1] = lines[-1][: a:endColumn - 1]
  let lines[0]  = lines[0][a:startColumn - 1:]
  return lines
endfunc
" echo GetTextWithinLineColumns_asLines( 10, 1, 10, 10 )

function! Get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0]  = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

func! GetVisSel()
  return Get_visual_selection()
endfunc

func! GetUrlFromLine ( lineNum )
  let str = matchstr(getline( a:lineNum ), '[a-z]*:\/\/[^ >,;"]*')
  return ReplaceStringsInLines( [str], [["'", ""]] )[0]
endfunc
" echo GetUrlFromLine( line('.') +1 )
" call LaunchChromium2( 'https://www.stackage.org/lts-14.1/hoogle?q=map' )
" call LaunchChromium2( "https://www.stackage.org/lts-14.1/hoogle?q=map" )

func! GetFilePathAtCursor ()
  let str = expand('<cWORD>')
  let filepath = ReplaceStringsInLines( [str], [["'", ""], ['"', ''], [',', ''], [':', '']] )[0]
  if filereadable( filepath )
    return filepath
  else
    echoe ("Not a valid file path: " . filepath)
  endif
endfunc
" echo GetFilePathAtCursor()
" echo split('" call FloatingBuffer( "/Users/at/.vim/notes/links2"', '"' )
" /Users/at/Documents/PS/A/TestsA/webpack-reload/.spago/console/v4.4.0/src/Effect/Class/Console.purs#:10:1


func! GetEncloseInQuotesFromLine ( lineNum )
  " let lastEncloseString = split( getline( a:lineNum ), '"' )[-1]
  let str = matchstr(getline( a:lineNum ), '\v"\zs\S([^"]*)\ze"')
  " The "\S" is to exclude vim-comments
  return str
endfunc
" echo GetEncloseInQuotesFromLine( line('.') +1 )
" /Users/at/.vim/notes/links2
" call FloatingBuffer( "/Users/at/.vim/notes/links2" )
" echo split('" call FloatingBuffer( "/Users/at/.vim/notes/links2"', '"' )[-1]
" echo split('" call FloatingBuffer( "/Users/at/.vim/notes/links2"', '"' )
" echo split('/Users/at/.vim/notes/links2 something', '\s' )
" echo split('call FloatingBuffer( "/Users/at/.vim/notes/links2"', '"' )[-1]
" call LaunchChromium2( "https://www.stackage.org/lts-14.1/hoogle?q=map" )
" echo filereadable( "eins" )

func! VisualCol()
  return VisualColLine( line('.'), col('.'), virtcol('.') )
endfunc

" The visible column index of a character column index (recognising conceals/replacements)
func! VisualColLine( lineNum, sourceCharIdx, sourceVirtualCharIdx )
  if a:sourceVirtualCharIdx > a:sourceCharIdx
    " Once the cursor is the virtual (beyond the real chars) area of the line, virtcol() *does* return the visualColumn index!
    return a:sourceVirtualCharIdx
  else
    return a:sourceCharIdx - ReducedColumnsInVisualDisplay( a:lineNum, a:sourceCharIdx )
  endif
endfunc

func! ReducedColumnsInVisualDisplay( lineNum, sourceCharIdx ) " ■
  let concealedCharCount = 0
  let concealInstanceIds = []
  let lineStr = getline(a:lineNum)
  for charIdx in range(1, max([a:sourceCharIdx -1, 0]))
    let [charConcealed, replacementChar, groupId] = synconcealed( a:lineNum, charIdx )
    if charConcealed
      let concealedCharCount += 1 " this char is concealed, but ..
      if replacementChar != ''
        " .. it is replaced by a one char wide replacement char, which might represent multiple concealed chars in one
        " conceal instance. This conceal instance is represented by a (syntax-group) Id which is unique over the line (is it?)
        call add( concealInstanceIds, groupId ) " track all instance Ids that had replacement chars
      endif
      " " TODO test this
    elseif lineStr[charIdx-1] == '"' || lineStr[charIdx-1] == '`'
      let concealedCharCount += 1 " quotes are concealed by matchadd in syntax-additions
    endif
  endfor
  let replacementInstances = len( uniq( concealInstanceIds ) )
  let reducedColumnCount = concealedCharCount - replacementInstances
  return reducedColumnCount
endfunc " ▲

" Set the cursor to a visual-colomn index
func! SetCursorVisualCol( lineNum, visualCol )
  call setpos('.', [0, a:lineNum, CharIdxOfVisualCol(a:lineNum, a:visualCol), 0] )
endfunc

" Find the first char(idx) that displays at a visualColumn index
func! CharIdxOfVisualCol( lineNum, searchVisualColIdx ) " ■
  let lineStr = getline(a:lineNum)
  let currVisualIdx = 0
  let currConcealInstance = 0
  let reducedColumnCount = 0
  let charIdx = -2
  " Run through all the source-chars in the targetLine accessing how they accumulate visual-columns
  for charIdx in range(1, len(getline(a:lineNum)))
    let [iCharConcealed, iReplacementChar, iGroupId] = synconcealed( a:lineNum, charIdx )
    if !iCharConcealed
      " This char is not concealed and is therefore increasing the visual-column count (at this source char)
      " if lineStr[charIdx-2] == '"'
      " " TODO test this
      if lineStr[charIdx-2] == '"' || lineStr[charIdx-2] == '`'
        " echo 'got'.charIdx
        " .. unless it's a quote, then this char will not be visible
        let reducedColumnCount += 1
      else
        let currVisualIdx += 1
      endif
    elseif iReplacementChar != ''
      " This source char is concealed but replaced by a char. ..
      if currConcealInstance != iGroupId
        " .. It only adds to the visual-col count if the conceal instance (-> groupId) is new - all following source char
        " concealed by this conceal instance will *not* add to the visual-column count. Thus only increase the count
        " in the event of replacementChar != '' *and* new groupId
        let currConcealInstance = iGroupId
        let currVisualIdx += 1
      else
        " This char is concealed and *has* a replacement, but is not the first char in this conceal-instance/groupId - so that is does not add a visible column
        let reducedColumnCount += 1
      endif
    else
      " This char is concealed and *has no* replacement - so that is does not add a visible column
      let reducedColumnCount += 1
    endif

    " Check if the accumulated visual-colums have reached the visible-column-index we where looking for
    if currVisualIdx == a:searchVisualColIdx
      " we can then return the source-character index/count that was needed to get to this visible column-width
      return charIdx
      break
    endif
  endfor
  " We ran through all chars until the end of this line, but the a:searchVisualColIdx is beyond this in the 'virtual' column range of this line
  " setting the cursor in the virtual range actually happens according to *visible* columns!
  " echo 'end'.charIdx
  if a:searchVisualColIdx < (charIdx + 2)
    return charIdx + 2
  else
    return a:searchVisualColIdx
  endif
  " Previous solution: does not work, because setting in the vitual column area does reflect the visual column/compensate conceals!
    " To match this visual column via source-chars (extending into the virtual range), we have to add the columnsCount that the chars in this line hides/reduced
    " return a:searchVisualColIdx + reducedColumnCount
endfunc " ▲
" Tests:
" call setpos('.', [0, line('.'), CharIdxOfVisualCol(line('.'), 20), 0] )


func! VisualBlockMode()
  " Activate visual block mode. 'x' option is needed to exec right away.
  call feedkeys("\<c-v>", 'x')
endfunc


" ─   Run list of commands                            ──
" The 1st item of the list is the function name that will be called with startLine, endLine. The return value of this
" function call will be passed to the function name in the 3rd list item.
nnoremap <leader>gwt :let g:opProcessAction=['ListOfLines',[],'RunListOfCommands',[]]<cr>:set opfunc=Gen_opfunc2<cr>g@
vnoremap <leader>gwt :<c-u>let g:opProcessAction=['ListOfLines',[],'RunListOfCommands',[]]<cr>:call Gen_opfunc2(0,1)<cr>
" Note this example is not including a related vis-sel command

" " Test lines paragraph (leader gwtip)

" touch temp
" echo "8drei" >> temp
" echo "9drei" >> temp
" echo "vier" >> temp

" cat temp
" del temp



func! ListOfLines( startLine, endLine )
  return getline( a:startLine, a:endLine )
endfunc

" Vim Pattern: For applying a function via an operator map, visual selection and command
nnoremap <leader><leader>lc      :let g:opProcessAction=['LinesOfCodeCount',[],'Echo',['Lines of code']]<cr>:set opfunc=Gen_opfunc2<cr>g@
vnoremap <leader><leader>lc :<c-u>let g:opProcessAction=['LinesOfCodeCount',[],'Echo',['Lines of code']]<cr>:call Gen_opfunc2(0,1)<cr>g@
command! -range=% LinesOfCodeCount echo LinesOfCodeCount( <line1>, <line2> )


" An opFunction (operation on lines of code (very common in vim!)) has to be an action/side-effect.
" This allows to write processing code into a pure/resusabel function and then run an action just on the result.
func! Gen_opfunc2( _, ...)
  " First arg is sent via op-fn. presence of second arg indicates visual-sel
  let [startLine, endLine] = a:0 ? [line("'<"), line("'>")] : [line("'["), line("']")]
  let processorFn   = g:opProcessAction[0]
  let processorArgs = g:opProcessAction[1]
  let actionFn   = g:opProcessAction[2]
  let actionArgs = g:opProcessAction[3]

  let processResult = call( processorFn, processorArgs + [startLine, endLine] )
  call call( actionFn, actionArgs + [processResult] )
endfunc
" TODO: test/unify this with ~/.vim/plugin/utils-align.vim#/func.%20Gen_opfunc.%20_,

" Count non-commented and non-empty lines
func! LinesOfCodeCount( startLine, endLine )
  let lines = getline( a:startLine, a:endLine )
  let count = 0
  for line in lines
    if line =~ '^.*--.*$' || line =~ '^$'
    else
      let count += 1
    endif
  endfor
  return count
endfunc

func! Echo( label, val )
  echom a:label . ': ' . string( a:val )
endfunc
" call Echo( 'My list', [2, 3, 4] )


" Returns the indent level (column num) of lineNum
func! IndentLevel( lineNum )
  return matchstrpos( getline( a:lineNum ), '\S')[1] + 1
endfunc
" echo matchstrpos("    sta", "\S")
" echo matchstrpos("     st :: a", "::")[1]
" echo matchstrpos( getline('.'), "::")[1]
   " echo IndentLevel( line('.') )

" Returns the visual column nums of word starts in a:lineNum as a list
func! WordStartVisualColumns( lineNum )
  let charColumns = WordStartColumns( getline(a:lineNum) )
  return functional#map( {charCol-> charCol - ReducedColumnsInVisualDisplay( a:lineNum, charCol )}, charColumns )
endfunc

" Returns the column nums of word starts in a:str as a list
func! WordStartColumns( str )
  let workStr = a:str
  let wordStartColumns = [0]
  while v:true
    let apos = matchstrpos( workStr, '\s\zs\S')[1] + 1
    if apos > 0
      let fullPos = apos + wordStartColumns[-1]
      call add( wordStartColumns, fullPos )
      let workStr = workStr[apos:]
    else
      return wordStartColumns[1:]
    endif
  endwhile
endfunc
" echo WordStartColumns( getline('.') )

" Returns the column num of the first (min two spaces) column
func! IndentLevel1stColumn( lineNum )
  return matchstrpos( getline( a:lineNum ), '\S\s\s\+\zs\S')[1] + 1
endfunc
" echo IndentLevel1stColumn     ( line('.') )

" WordStartColumns seems the better approach
func! IndentLevelWordStarts( lineNum )
  let lineStr = getline( a:lineNum )
  let words = split( getline( a:lineNum ) )
  let wordStarts = []
  for word in words
    " echo a:lineNum . word .' - '. lineStr
    " let apos = matchstrpos( lineStr, EscapeSpecialChars(word) )[1] +1
    " let apos = matchstrpos( lineStr, '\V\'.word )[1] +1
    let apos = FindPosInStr( lineStr, word )
    if apos > 0
      let vispos = apos - ReducedColumnsInVisualDisplay( a:lineNum, apos )
      call add( wordStarts, vispos )
      " Issue: what happens when one word appears twice?
    else
      " echoe 'IndentLevelWordStarts-word: '. word .' not found in line'
    endif
  endfor
  return wordStarts
endfunc
" echo IndentLevelWordStarts(line('.'))

func! GetLineFromCursor()
  return getline('.')[col('.')-1:]
endfunc
" echo GetLineFromCursor()

func! GetFullLine_OrFromCursor()
  let isCommentLine = getline( '.' ) =~ '\(\/\/\|\*\|\"\)'
  if isCommentLine
    return getline('.')[col('.')-1:]
  else
    return getline('.')
    " return substitute( getline('.'), " ", "\ ", "" )
  endif
endfunc

" Return the character under the cursor
func! GetCharAtCursor()
  return getline('.')[col('.')-1]
endfunc
" echo GetCharAtCursor()

" echo getline('.')[col('.')-1:col('.')]
func! Get2CharsFromCursor()
  return getline('.')[col('.')-1:col('.')]
endfunc

func! GetCharAtColRelToCursor( offset )
  return getline('.')[ col('.') + a:offset -1 ]
endfunc
" echo GetCharAtColRelToCursor( -1 )

func! IsEmptyLine( linenum )
  return getline( a:linenum ) == ''
endfunc

func! MatchesInLine( linenum, pttn )
  " return len( matchstr( getline( a:linenum ), a:char ) ) ? 1 : 0
  return getline( a:linenum ) =~ a:pttn
endfunc
" echo MatchesInLine( line('.') -1, 'a' )

func! IsImportLine( linenum )
  return getline( a:linenum ) =~ 'import '
endfunc
" echo IsImportLine( line('.') )

func! IsDoStartLine( linenum )
  return getline( a:linenum ) =~ ' do'
endfunc
" echo IsImportLine( line('.') )

func! IsTypeSignLine( linenum )
  return getline( a:linenum ) =~ '\(∷\|::\)'
endfunc
" echo IsTypeSignLine( line('.') )

func! ContainsPunctuation( str )
  return a:str =~ '\(\.\|:\)'
endfunc
" echo ContainsPunctuation( 'eins.zwei' )
" echo ContainsPunctuation( 'eins,zwei' )

func! IsTypeSignLineWithArgs( linenum )
  return getline( a:linenum ) =~ '\(∷\|::\).*→'
endfunc
" echo IsTypeSignLineWithArgs( line('.') )

func! ColOfFirstChar()
  return searchpos('^\s*\zs', 'cnb')[1]
endfunc

func! IsColOfFirstChar( col )
  return ColOfFirstChar() == a:col
endfunc
" echo IsColOfFirstChar( col('.') )


func! ColOfLastChar()
  return strlen(getline('.'))
endfunc
" echo ColOfLastChar()

func! IsColOfLastChar( col )
  return ColOfLastChar() == a:col
endfunc
" echo IsColOfLastChar( col('.') )


func! CursorIsAtStartOfWord()
  return GetCharAtColRelToCursor( -1 ) =~ '\s' && GetCharAtColRelToCursor( 0 ) =~ '\S'
endfunc
" echo  CursorIsAtStartOfWord()

" Returns Ascii code of multi-byte characters like '→'
func! GetCharAtCursorAscii()
  return strgetchar( getline('.'), virtcol('.')-1 )
endfunc
" echo GetCharAtCursorAscii() " a → ( b → c) [()] ⇒ d "


func! CursorIsInsideString()
  let curCar = GetCharAtCursor()
  if curCar == '"' || curCar == "'"
    " Cursor is on quote/ start/end of the string
    return 0
  else
    return GetSyntaxIDAtCursor() =~ 'string'
  endif
endfunc
" nnoremap <leader>bb :echo searchpair('(', 'e', ')', 'W', 'CursorIsInString()')<cr>
" Demo: Note how the 'e' in the 'vimCommentString' gets skipped
" a E b e a (f E a e d) d E "a e" f E

func! CursorIsEol()
  return GetCharAtCursor() == ''
endfunc

func! CursorIsOnSpace()
  return GetCharAtCursorAscii() == 32
endfunc


func! CursorIsOnClosingBracket()
  let ac = GetCharAtCursorAscii()
  return ac == 41 || ac == 93 || ac == 125
endfunc
" Test: () [] {}

func! CursorIsOnOpeningBracket()
  let ac = GetCharAtCursorAscii()
  return ac == 40 || ac == 91 || ac == 123
endfunc
" Test: () [] {}


func! IsInsideString( line, col )
  return synIDattr( synID( a:line, a:col, 0), 'name' ) =~ 'string'
endfunc

func! IsInsideSyntaxStackId( line, col, testStr )
  let synList = map(synstack( a:line, a:col ), 'synIDattr(v:val,"name")')
  for synID in synList
    if synID =~ a:testStr
      return 1
    endif
  endfor
  return 0
endfunc
" echo IsInsideSyntaxStackId( line('.'), col('.'), 'function' )
" echo IsInsideSyntaxStackId( line('.'), col('.'), 'comm' )

func! CursorIsInsideComment()
  return GetSyntaxIDAtCursor() =~ 'comment'
endfunc

func! CursorIsInsideStringOrComment()
  return CursorIsInsideComment() || CursorIsInsideString()
endfunc

func! ParagraphStartEndLines()
  let [lstart, cstart] = searchpos( '^$', 'nWb')
  let [lend, cend] = searchpos( '^$', 'nW')
  return [ lstart + 1, lend - 1 ]
endfunc
" echo ParagraphStartEndLines()

