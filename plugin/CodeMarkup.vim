" leader ch   - heading
" leader cs   - close section
" leader cr   - refresh heading/section
" leader cd   - delete/strip heading/section
" >>>>>>>
" leader ehs  - heading
" leader ehe  - close section
" leader ehr  - refresh heading/section
" leader ehd  - delete/strip heading/section


" This highlights Headings, Sections and Labels in Black
func! CodeMarkupSyntaxHighlights()
  " Comment sections use the unicode dash at the start and end of the line
  " call matchadd('CommentSection', '\v^("|--)\s─(\^|\s)\s{2}\u.*\S\s*──', -1, -1 )

  " call matchadd('CommentSection', '\v^("|--)\s─(\^|\s)\s{2}\S.*', 11, -1 )
  call matchadd('CommentSection', '\v("|--)\s─(\^|\s)\s{2}\S.*', 11, -1 )

  " And even: more
  " Comment sections can be terminated using the ^ char
  " ─^  Comment Section Example end                        ──
  " Comment label: This is a simple label for some highlighted info to come
  " Note that:this does not match - the scoping of vim vars e.g. g:myvar would otherwise match

  call matchadd('CommentLabel', g:labelPttn, -1, -1 )

  " call matchadd('CommentLabel', '\v^\s*("|--)\s\zs\S[^.]{,18}:(\S)@!', -1, -1 )
  " Note: ":\ze(\s\S)=" allows "..: eins" and "..:", but not "..:eins"
endfunc
" Test: qqq and QQQ - make sure jumps are only to highlighted labels
" An ano othe:
" one

" class Functor f => Align (f :: * -> *) where

" TODO
" set commentstring=\ --\ \%s

let g:headingPttn = '\v^("|--)\s─\s'
" let g:labelPttn = '\v^\s*("|--)\s\zs\S[^.]{,30}:(\S)@!'
" let g:labelPttn = '\v^\s*("|--|\#)\s\zs\S[^.]{,50}:(\S)@!'

" Note: This is a negative look behind - makes sure that the ':' does not appear before the other ':'
" (:@<!)
" It prevents haskell type colons e.g. :: to match:
" class Functor f => Align (f :: * -> *) where

let g:labelPttn = '\v^\s*("|--|\#)\zs\s*\S[^.]{,50}(:@<!):(\S)@!'
let g:headingOrLabelPttn = '\v^(\s*("|--)\s\zs\S[^.]{,50}:(\S)@!|("|--)\s─\s)'

" ─   Move to Headings and Sections                      ■
nnoremap œ :call HeadingForw()<cr>
" Note that œ is triggerd by a Karabiner Tab map
func! HeadingForw()
  call search( g:headingPttn, 'W' )
  call ScrollUpFromMiddle( 10 )
  " Issue: I used 20 as a convenient offset form the middle - but that prevented proper movement when window is split
  " horizontal/ is too narrow.
endfunc

nnoremap Œ :call HeadingBackw()<cr>
" Note that Œ is triggerd by a Karabiner Tab map
func! HeadingBackw()
  call search( g:headingPttn, 'bW' )
  call ScrollUpFromMiddle( 10 )
endfunc

nnoremap ,œ :call GoSectionEndAbort('')<cr>
" Go to specific (via name) or current section end
" func! GoSectionEndAbort( headerText )
func! GoSectionEndAbort( ... )
  let l:winview = winsaveview()
  normal! ll
  call HeadingBackw()
  " Go to either next start or end marker
  if a:0
    let headerText = (a:1 != '') ? a:1 : GetHeadingTextFromHeadingLine( line('.') )
    call search('\v^("|--)\s─(\^|\s)\s{2}' . headerText, 'W')
  else
    call search('\v^("|--)\s─(\^|\s)', 'W')
  endif
  let isEndMarker = MatchesInLine(line('.'), '\^')
  if isEndMarker " Confirm we have moved to matching end marker
    return 1
  else " Roll back
    call winrestview(l:winview)
    return 0
  endif
endfunc
" ─^  Move to Headings and Sections                      ▲


" ─   Labels                                             ■
nnoremap q :call LabelForw()<cr>
func! LabelForw()
  call search( g:headingOrLabelPttn, 'W' )
endfunc

nnoremap Q :call LabelBackw()<cr>
func! LabelBackw()
  call search( g:headingOrLabelPttn, 'bW' )
endfunc
" ─^  Labels                                             ▲




" ─   Textobjs for inside name and inside content        ■
onoremap <silent> ihn :<c-u>call LabelAndHeading_VisSel_Name()<cr>
vnoremap <silent> ihn :<c-u>call LabelAndHeading_VisSel_Name()<cr>o
onoremap <silent> ihc :<c-u>call LabelAndHeading_VisSel_Content()<cr>
vnoremap <silent> ihc :<c-u>call LabelAndHeading_VisSel_Content()<cr>o
" Tests: sel this ..

func! LabelAndHeading_VisSel_Name()
  " Move back slightly so the current label/heading is found
  normal! m'll
  call search( g:headingOrLabelPttn, 'cbW' )
  normal! ^
  if MatchesInLine( line('.'), '─' )
    normal! ww
    let [sLine, sCol] = getpos('.')[1:2]
    " Move to the end of the last word of the heading name
    call search('\v\S\s*(▲|■|──)')
    let [eLine, eCol] = getpos('.')[1:2]
  else
    normal! w
    let [sLine, sCol] = getpos('.')[1:2]
    call search('.:')
    let [eLine, eCol] = getpos('.')[1:2]
  endif
  call setpos( "'<", [0, sLine, sCol, 0] )
  call setpos( "'>", [0, eLine, eCol, 0] )
  normal! gv
endfunc

func! LabelAndHeading_VisSel_Content()
  normal! m'll
  call search( g:headingOrLabelPttn, 'cbW' )
  normal! ^
  if MatchesInLine( line('.'), '─' )
    normal! j
    let [sLine, sCol] = getpos('.')[1:2]
    if !GoSectionEndAbort('') " Go to end of a section or next heading
      call HeadingForw()
    endif
    normal! k$
    let [eLine, eCol] = getpos('.')[1:2]
  else
    call search(':')
    normal! w
    let [sLine, sCol] = getpos('.')[1:2]
    normal! $
    let [eLine, eCol] = getpos('.')[1:2]
  endif
  call setpos( "'<", [0, sLine, sCol, 0] )
  call setpos( "'>", [0, eLine, eCol, 0] )
  normal! gv
endfunc

" Address the heading specifically as there may be labels in the way
onoremap <silent> ihn :<c-u>call Heading_VisSel_Name()<cr>
vnoremap <silent> ihn :<c-u>call Heading_VisSel_Name()<cr>o
onoremap <silent> ihc :<c-u>call Heading_VisSel_Content()<cr>
vnoremap <silent> ihc :<c-u>call Heading_VisSel_Content()<cr>o
func! Heading_VisSel_Name()
  call search( g:headingPttn, 'cbW' )
  call LabelAndHeading_VisSel_Name()
endfunc
func! Heading_VisSel_Content()
  call search( g:headingPttn, 'cbW' )
  call LabelAndHeading_VisSel_Content()
endfunc

" ─^  Textobjs for inside name and inside content        ▲

" ─   Test                                             ──


" ─   Create, Update, Delete Headings and Sections    ──
nnoremap <leader>ehs :call CreateHeading(0, '', 0)<cr>
" Create Section header start or end markers
" Uses the current line text if headerText is empty string
func! CreateHeading( isEnd, headerText, isSection )
  let lineTargetLength = 64
  let sectionHeaderText = len(a:headerText) ? a:headerText : getline('.')
  normal dd
  let lineFirstPart = a:isEnd ? ' ─^  ' : ' ─   '
  let lineFirstPart = GetLangCommentStr() . lineFirstPart
  let foldMarkerText = a:isEnd ? ' ▲' : ' ■'
  " Start and end section markers imply fold start and end markers and not dashes at the end of the line!
  let lineLastPart = a:isSection ? foldMarkerText : '──'
  let numOfFillChars = lineTargetLength - (len(lineFirstPart) + len(sectionHeaderText) + len('──'))
  let fillChars = repeat( ' ', numOfFillChars)
  let lineText = lineFirstPart . sectionHeaderText . fillChars . lineLastPart
  call append( line('.') -1, lineText )
  normal k
endfunc
" call CreateHeading(0, 'Some Text', 0)
" call CreateHeading(0, 'Some Text', 1)
" call CreateHeading(1, 'Some Text', 1)


" "CodeMarkup Section" - sort of closes the previous heading at the current line - turning it into a section
nnoremap <leader>ehe :call CloseSection()<cr>
" Create section end marker using the header text of the previous header start line
func! CloseSection()
  " Make sure that folding does not interfere. this now works with foldlevel=0 → section will autocollapse
  let l:fl = &foldlevel
  set foldlevel=99
  let [oLine, oCol] = getpos('.')[1:2]
  " winview works as an alternative. It does not move the window
  " let l:winview = winsaveview()
  " Go to preceding header, get its title and overwrite it/ chance ending of line
  call HeadingBackw()
  if getline('.') =~ '\^' | echoe 'No preceding start header!' | return | endif
  if getline('.') =~ '■'  | echoe 'Heading has a foldmarker!' | return | endif
  let headerText = GetHeadingTextFromHeadingLine( line('.') )
  " Just overwrite/recreate the header
  call CreateHeading(0, headerText, 1)
  redraw
  " Go back to the original line and set the end marker
  call setpos('.', [0, oLine, oCol, 0] )
  " call winrestview(l:winview)
  call append('.', '')
  normal! j
  call CreateHeading(1, headerText, 1)
  exec 'set foldlevel=' . l:fl
endfunc
" call CloseSection()


nnoremap <leader>ehd :call StripHeaderOrSection()<cr>
func! StripHeaderOrSection()
  normal! j
  call HeadingBackw()
  if GoSectionEndAbort('')
    normal dd
    call HeadingBackw()
  endif
  call StripMarker()
endfunc

func! StripMarker()
  let headerText = GetHeadingTextFromHeadingLine( line('.') )
  call append('.', headerText)
  normal dd
endfunc

" Run this after changing the section header text. Will update and marker and re-align line spacing
nnoremap <leader>ehr :call RefreshHeadingOrSection()<cr>
func! RefreshHeadingOrSection()
  let l:winview = winsaveview()
  let isSectionHeadering = MatchesInLine( line('.'), '■' )
  " Note that this will turn normal headings with a foldmarker into a section heading
  let headerText = GetHeadingTextFromHeadingLine( line('.') )
  call CreateHeading( 0, headerText, isSectionHeadering )
  if GoSectionEndAbort()
    call CreateHeading(1, headerText, 1)
  endif
  call winrestview(l:winview)
endfunc


" Extract headline text from section header line
func! GetHeadingTextFromHeadingLine( lineNum )
  return matchstr( getline(a:lineNum), '\v^("|--)\s─(\^|\s)\s{2}\zs\S.*\S\ze\s*(▲|■|──)')
endfunc
" echo GetHeadingTextFromHeadingLine( line('.') +1 )
" ─^  Some Hxadline Text                                ──
" ─   Some Headline Text                                 ■




