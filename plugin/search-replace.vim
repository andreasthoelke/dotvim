
" This uses a list of lines, not a range in the code like below
" Note: this returns lines list and needs to replace in the buffer
fun! SubstituteInLines ( lines, origDelim, newDelim )
  let l:idx = 0
  while l:idx < len(a:lines)
    let l:line = a:lines[l:idx]
    let a:lines[l:idx] = substitute(l:line, a:origDelim, a:newDelim, 'ge')
    let l:idx = l:idx + 1
  endwhile
  return a:lines
endfun

func! ReplaceInRange( startLine, endLine, replacementMaps )
  let rangeStr = a:startLine . ',' . a:endLine
  for [target, replacement] in a:replacementMaps
    exec 'silent ' . rangeStr 's/' . target . '/' . replacement . '/ge'
  endfor
endfunc

" Enhance SubstituteInLines to multiple replacements
func! ReplaceStringsInLines( lines, listListMap )
  for [target, replacement] in a:listListMap
    call SubstituteInLines( a:lines, target, replacement )
  endfor
  return a:lines
endfunc
" echo ReplaceStringsInLines( [getline( line('.') +1)], g:HsReplacemMap_CharsToUnicodePtts )
" unfold :: Monad m => (b -> Maybe (a, b)) -> b -> Producer m a

" Substitute flags: "g" = all occurances, "e" = surpress/continue at errors

" Note: this only works on vis-sel(?!)
func! ReplaceStringsInRange( listListMap ) range
  let rangeStr = a:firstline . ',' . a:lastline
  for [target, replacement] in a:listListMap
    " Exec the substitute- 's/' command with '/ge' flags. Note the "\%V" flag/atom makes the pattern effective only in the visual selection
    exec 'silent ' . rangeStr 's/\%V' . target . '/' . replacement . '/ge'
  endfor
endfunc
command! -range -nargs=1 ReplaceStringsInRange :<line1>,<line2>call ReplaceStringsInRange( <args> )
" source (<leader>se) the following line to test
" .+1,.+2MapStringsInRange [['ab', 'CD'], ['x', 'Y']]
" test ab cd ef xyz
" test gh ab xf xab
" Note the "\%V" flag/atom makes the pattern effective only in the visual selection
" %s/\%Vab/XX/g


" What is an operator?:
" operator for motion/ range/selection of text
" can transform this text in place
"   - replace all chars with _
"   - hs unicode replace
" side effect/action with this text/string (or further filtered) as input
" copy motion below paragraph
" ====

" Operator And Movement: {{{
" Operator pending map: to fill in the movement after an operator key has been pressed
" - If your operator-pending mapping ends with some text visually selected, Vim will operate on that text.
" - Otherwise, Vim will operate on the text between the original cursor position and the new position.
" Search to the prev ===..= regex, then at the line above set a visual highlight to the end of the line
onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
" Find vimcommentTitle then visualselect till end of the line
onoremap ih :<c-u>execute "normal! ?^.*:\rv$"<cr>
" Exec will substitute special characters before running. \r means "carriage return". The double backslash puts a literal backslash in the string.
" call append( 39, '**')
" exe sl.','.el 's/\%'.sc.'c\|\%'.ec.'c.\zs/\=s/g|norm!``'
" .+1s/aa/bb
" xx aa cc
" let g:aab = 'XY'
" .+1s/aa/\=g:aab
" xx aa cc
" Replace within a range of columns
" .+2s/\%>7caa/XX/g
" .+1s/\%>2c\%<7caa/XX/g
" xx aa cc aa xx
" exec ".+2s/\\%>2c\\%<7caa/XX/g"
" exec ".+1s/aa/XX/g"
" xx aa cc ee ll aa xx
" .+1s//XX/g
" xx aa cc ee ll aa xx
" Run A Regex Search: Note this uses literal strings *only* for the regex part
" exec "normal! gg" . '/for .\+ in .\+:' . "\<cr>"
" Note Question: why does the very magic mode not work here? vimscript book chapter 31
" exec "normal! gg" . '/\vfor .\+ in .\+:' . "\<cr>"
" }}}

" Operator Map: The operator key map "\r" should be followed by a motion (e.g. W, $ or 'a) or textobject "af/ip/iv/iB ..".
" It's a function that operates on a range of text from a motion, textobj or vis-selection. It then transforms that text or does some other side effect.
nnoremap <silent> <localleader>r :set opfunc=ReplaceLastPattern<cr>g@
vnoremap <silent> <localleader>r :<c-u>call ReplaceLastPattern(visualmode(), 1)<cr>

func! ReplaceLastPattern( motionType, ...)
  normal! m'
  " Get the the search patterns form the search history
  let lastPattern = histget( 'search', -1 )
  " Show user dialog to get the new text
  let replacementText = input('Enter replacement text: ')
  " a:0 is the number of optional args. Passing (e.g. 1) as the second arg in the visual mode map
  let linesRangeMarkersStr = a:0 ? "'<,'>" : "'[,']"
  " The substitute command is stated with a range string. it will get appended to using the ".=" in the following lines
  let substituteCmd = l:linesRangeMarkersStr . 's/'
  " Line and column of start+end of either vis-sel or motion
  let [startLine, startColumn] = getpos(a:0 ? "'<" : "'[")[1:2]
  let [endLine,   endColumn]   = getpos(a:0 ? "'>" : "']")[1:2]

  if a:motionType == 'char'
    " Note the special syntax to limit the affected columns of text
    let substituteCmd .= '\%>' . startColumn . 'c\%<' . endColumn . 'c'
  endif
  let substituteCmd .= lastPattern . "/" . replacementText . "/ge"
  call ExecKeepView( substituteCmd )
  " exec substituteCmd
  " exec 'normal!' "\<C-o>"
  call JumpBackSkipCurrentLoc()
  " Notes: {{{
  " call ExecKeepView( "'[,']s/\\%>15c/_/ge|norm!``" )
  " let debugStr = startLine . ' ' . endLine . ' ' . startColumn . ' ' . endColumn
  " let insertChar = nr2char( getchar() )
  " Issue: this does not work in this function
  " call highlightedyank#highlight#add( 'Search', getpos("'<"), getpos("'>"), 'char', 4000)
  " this does work
  " call nvim_buf_add_highlight( bufnr(''), g:nsid_def, 'Search', line('.')-3, 1, 100)
  " if a:motionType == 'line' || a:motionType == 'V'
  " elseif a:motionType == 'block' || a:motionType == "\<c-v>"}}}
endfunc
" Todo: make the function more reusable by making it a "ReplacePattern" that takes a pattern or else uses the last search{{{
" Regex Demo: run next line then put cursor on 'aa' in next line, them opfunction = $ motion
" add something to the searchhistory for demonstartion purposes
" call histadd( 'search', '[ew]\s' )
" then  | here do "\r$"
" xx ww aa at cc ee ax ww ll aa xx
" xx ww aa at cc ee ax ww ll aa xx}}}


func! ReplacePattern( linesRangeStr, pattern )
  normal! m'
  " Show user dialog to get the new text
  let replacementText = input('Enter replacement text: ')
  " The substitute command is stated with a range string. it will get appended to using the ".=" in the following lines
  let substituteCmd = a:linesRangeStr . 's/'
  let substituteCmd .= a:pattern . "/" . replacementText . "/ge"
  call ExecKeepView( substituteCmd )
  call JumpBackSkipCurrentLoc()
endfunc


" ─   Utils                                             ──

func! PatternToMatchOutsideOfParentheses( searchStr, openStr, closeStr )
  return '\(([^' . a:closeStr . ']*' . a:openStr . '\)\@<!' . a:searchStr . '\([^' . a:openStr . ']*' . a:closeStr . '\)\@!'
endfunc
" prevent matches (in brackets) - but not outsider (other) -- [this e actually works!!] (elems)
" call matchadd('MatchParen', PatternToMatchOutsideOfParentheses( 'e', '(', ')' ), -1, -1 )
" call matchadd('MatchParen', PatternToMatchOutsideOfParentheses( 'e', '\[', '\]' ), -1, -1 )

" Note: Search Regex Within Quotes: - "\v`[^`]*`" search and highlight strings within backtick quotes/ wrapped in backticks
" Search within bracket - (works with (limitations)) ...
" call matchadd('MatchParen', '([^)]*', -1, -1 )


