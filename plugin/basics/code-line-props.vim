

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

func! Get_visual_selection_lines()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0]  = lines[0][col1 - 1:]
  return lines
endfunc


" deprecated. use: vim.getVisualSelection() ~/.config/nvim/plugin/config/maps.lua‖/functionˍvi
func! GetVisSel()
  return Get_visual_selection()
endfunc

func! GetUrlFromLine ( lineNum )
  let str = matchstr(getline( a:lineNum ), '[a-z]*:\/\/[^ >,;"]*')
  return ReplaceStringsInLines( [str], [["'", ""], ["\)", ""]] )[0]
endfunc
" GetUrlFromLine( line('.') +1 )
" - [Paper](https://mui.com/material-ui/react-paper/)
" call LaunchChromium2( 'https://www.stackage.org/lts-14.1/hoogle?q=map' )
" call LaunchChromium2( "https://www.stackage.org/lts-14.1/hoogle?q=map" )

func! GetFilePathAtCursor ()
  let str = expand('<cWORD>')
  let filepath = ReplaceStringsInLines( [str], [["'", ""], ['"', ''], [',', ''], [':', '']] )[0]
  if filereadable( filepath )
    return filepath
  else
    echo ("Not a valid file path: " . filepath)
  endif
endfunc
" echo GetFilePathAtCursor()
" echo split('" call FloatingBuffer( "/Users/at/.vim/notes/links2"', '"' )
" /Users/at/Documents/PS/A/TestsA/webpack-reload/.spago/console/v4.4.0/src/Effect/Class/Console.purs#:10:1

func! GetAbsFilePathInLine ()
  let words = getline('.')->split()
  for word in words
    let filepath = ReplaceStringsInLines( [word], [["'", ""], ['"', ''], [',', ''], [':', '']] )[0]
    let filepathAbs = fnamemodify( filepath, ':p' )
    if filereadable( filepathAbs )
      return filepath
    endif
  endfor
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

func! GetLineFromCursor_dirvish()
  if &ft == 'dirvish'
    return getline('.')
  else
    return getline('.')[col('.')-1:]
  endif
endfunc

func! GetFullLine_OrFromCursor()
  let isCommentLine = getline( '.' ) =~ '\(\/\/\|\*\|\"\)'
  if isCommentLine
    return getline('.')[col('.')-1:]
  else
    return getline('.')
    " return substitute( getline('.'), " ", "\ ", "" )
  endif
endfunc

" A path or url is often the longest word in a line
func! GetPath_fromLine()
  let full_line = trim(getline('.'))
  " Remove markdown bold/italic markers to avoid matching them
  let full_line = substitute(full_line, '\*', '', 'g')

  " SIMPLE: If line contains ‖, return the full line (handles spaces in paths)
  if full_line =~ '‖'
    if filereadable(full_line)
      return expand(full_line)
    endif
  endif

" ─     Folder paths in md files                        ──
" notes this a folder path now needs to contain a "/", e.g. 
" ./plugin
" or
" lua/utils

  let line_words = substitute( getline('.'), '[\[\<\>\](){}]', ' ', 'g' ) 
  let line_words = line_words->split()
  " Filter to only words that contain a "." or "/"
  let line_words = filter(line_words, 'v:val =~ "[./]"')
  " return line_words
  let path = line_words->sort('CompareLength')[-1]
  " return path

  " Support for http links
  let httppattern = '\[\([^\]]*\)\](\(https\?://[^)]*\))'
  let httpmatches = matchlist(full_line, httppattern)
  " matches[0] = full match
  " matches[1] = link text
  " matches[2] = URL

  if len(httpmatches) >= 3
    return "http‖" . httpmatches[2]
  endif
  

" ─   Github markdown links support                      ■
  " Support for github link info .. 
  " and a [system prompt](node/providers/system-prompt.ts#L305) into 
  let ghpattern = '\[\([^\]]*\)\](\([^#)]*\)\%(#L\(\d\+\)\)\?)'
  let ghmatches = matchlist(full_line, ghpattern)
  
  " matches[0] = full match
  " matches[1] = link text
  " matches[2] = path
  " matches[3] = line number (may be empty)

  " echo ghmatches
  if len(ghmatches) >= 4
    let ghpath = ghmatches[2]
    " Relative paths in github markdown
    " - [Set up your first module container](./tutorial-module-container.md)
    " ~/Documents/Proj/k_mindgraph/y_fullstack/f_context-modules/docs/getting-started.md
    if ghpath[0:1] == "./"
      let folderPath_of_currentFile = fnamemodify(expand('%:p'), ':h')
      let path = folderPath_of_currentFile . ghpath[1:]
      " - **[Basic Module Container](../examples/01-module-container/)** - A simple module exposing components
    elseif ghpath[0:1] == ".."
      let folderPath_of_currentFile = fnamemodify(expand('%:p'), ':h')
      let path = folderPath_of_currentFile . "/" . ghpath
    else
      let path = ghpath
    endif
    " return path
    if len(ghmatches[3])
      return path . "‖:" . ghmatches[3]
    else
      return path
    endif
  endif

" ─^  Github markdown links support                      ▲

  " Check for Markdown links: [text](path/to/file#heading) or [text](#heading) for in-document refs
  let markdown_match = matchlist(getline('.'), '\[[^]]*\](\([^)#]*\)\(#[^)]*\)\?)')
  if !empty(markdown_match)
    let filepath = markdown_match[1]
    let heading = get(markdown_match, 2, '')
    
    " Remove the # from the heading
    if !empty(heading)
      let heading = heading[1:]
    endif
    
    " Get current directory for relative paths
    let current_folder = fnamemodify(expand('%:p'), ':h')
    let current_file = expand('%:p')
    
    " Check if this is an in-document reference (empty filepath)
    if empty(filepath)
      " Handle in-document link references like [text](#heading)
      let heading_parts = split(heading, '-')
      
      " For headings with special characters like 'search-operations-gs', 
      " just look for the main text part ('Search Operations')
      if len(heading_parts) >= 3 && len(heading_parts[-1]) <= 2  " Added test comment
        let heading_parts = heading_parts[:-2]
      endif
      
      let heading_text = map(heading_parts, 'toupper(v:val[0]) . v:val[1:]')
      let heading_text = join(heading_text, ' ')
      
      " Search for the heading text pattern
      return current_file . '‖/# ' . heading_text
    endif
    
    " Check if it's a direct file reference
    if filereadable(filepath)
      let path = filepath
    elseif filepath[0] != '/' && filereadable(current_folder . '/' . filepath)
      let path = current_folder . '/' . filepath
    else
      " Not a direct file reference - don't try to be clever with README.md
      " Just pass the path through 
      let path = filepath[0] == '/' ? filepath : current_folder . '/' . filepath
    endif
    
    if !empty(heading)
      " For file#heading references, convert heading-id to heading text
      let heading_parts = split(heading, '-')
      
      " For headings with special characters like 'search-operations-gs', 
      " just look for the main text part ('Search Operations')
      if len(heading_parts) >= 3 && len(heading_parts[-1]) <= 2  " Added test comment
        let heading_parts = heading_parts[:-2]
      endif
      
      let heading_text = map(heading_parts, 'toupper(v:val[0]) . v:val[1:]')
      let heading_text = join(heading_text, ' ')
      return path . '‖/# ' . heading_text
    else
      return path
    endif
  endif

  " Check for backtick-enclosed paths
  let backtick_match = matchstr(full_line, '`\zs[^`]*\ze`')
  if !empty(backtick_match)
    let path = backtick_match
    
    if filereadable(path) || isdirectory(path)
      return path
    endif
    
    let current_folder = fnamemodify(expand('%:p'), ':h')
    let folder_rel_path = current_folder . '/' . path
    
    if filereadable(folder_rel_path) || isdirectory(folder_rel_path)
      return folder_rel_path
    endif
  endif

  " Check for double-quotes-enclosed paths
  let quotes_match = matchstr(full_line, '"\zs[^"]*\ze"')
  if !empty(quotes_match)
    let path = quotes_match
    
    if filereadable(path) || isdirectory(path)
      return path
    endif
    
    let current_folder = fnamemodify(expand('%:p'), ':h')
    let folder_rel_path = current_folder . '/' . path
    
    if filereadable(folder_rel_path) || isdirectory(folder_rel_path)
      return folder_rel_path
    endif
  endif

  " Check for single-quotes-enclosed paths
  let single_quotes_match = matchstr(full_line, "'\\zs[^']*\\ze'")
  if !empty(single_quotes_match)
    let path = single_quotes_match
    
    if filereadable(path) || isdirectory(path)
      return path
    endif
    
    let current_folder = fnamemodify(expand('%:p'), ':h')
    let folder_rel_path = current_folder . '/' . path
    
    if filereadable(folder_rel_path) || isdirectory(folder_rel_path)
      return folder_rel_path
    endif
  endif


  if filereadable( path ) || isdirectory(path)
    return path
  endif

  let abspath = fnamemodify( path, ':p' )
  if filereadable(abspath) || isdirectory(abspath)
    return abspath
  endif

  " LINE NUM AFTER COLLON
  " Support popular line link format: /Users/at/.config/nvim/plugin/config/telescope.lua:393: in function 'HighlightRange'
  if path =~ ':'
    let [path_sub; line_num] = path->split( ":" )
    if filereadable( path_sub )
      return path_sub . "‖:" . line_num[0]
    endif
  endif

  let current_folder = fnamemodify( expand('%:p'), ':h' )
  let folder_rel_path = current_folder . '/' . path

  if filereadable(folder_rel_path) || isdirectory(folder_rel_path)
    return folder_rel_path
  endif

  " Fallback: if path is not readable, try the full line (handles paths with spaces)
  let fallback_full_line = trim(getline('.'))
  let expanded_fallback_line = expand(fallback_full_line)
  if filereadable(expanded_fallback_line) || isdirectory(expanded_fallback_line)
    return expanded_fallback_line
  endif
  
  " echo 'Path is not readable: ' . path
  return path
endfunc
" split( "ea bbbb ccccccc dfddfdfdfdf we" )->sort('CompareLength')
" /Users/at/.config/nvim/plugin/config/telescope.lua:393: in function 'HighlightRange'
    " -   [Getting Started for New Coders](getting-started-new-coders/README.md)


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
" GetCharAtCursorAscii() " a → ( b → c) [()] ⇒ d "


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

func! WrapWith(inner, around)
  return a:around . a:inner . a:around
endfunc



