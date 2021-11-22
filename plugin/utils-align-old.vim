


" Tabularize 1st and 2nd column of a motion or selected range of lines based on <space>
" nnoremap <silent> <leader>at :set opfunc=Align_op<cr>g@
" vnoremap <silent> <leader>at :<c-u>call Align_op( visualmode(), 1)<cr>

" nnoremap <silent> <leader>a> :let g:comEx = ['/->/']<cr>:set opfunc=Align_op<cr>g@
" nnoremap <silent> <leader>a- :let g:comEx = ['/-/']<cr>:set opfunc=Align_op<cr>g@


" Note for extending this:
" Below is an example of how to perform multiple easy-alignments on a (motion-) range of lines.
" So instead of running: "<leader>al,j "& "<leader>al,j2 ". you can just do "<leader>at,j"

" Perform an align operation on a range of lines. An operator function can/needs to access the range as shown below
func! Align_op( motionType, ...)
  normal! m'
  " motionType could e.g. be 'char' here - but aligning will only use linewise here
  let motionType = 'lines'
  " The align expression (EasyAlign DSL)
  " let comExpressions = ['\ ', '2\ ']
  " let comExpressions = ['/->/']
  " Get the range of lines from either visual mode ( "'<") or an (operator pending) motion or text object
  if a:0
    let [l1, l2] = ["'<", "'>"]
  else
    let [l1, l2] = [line("'["), line("']")]
  endif
  " Format the range string
  let range = l1.','.l2
  " Call the easyAlign main API function
  " function! easy_align#align(bang, live/preview-mode, visualmode, expr) range
  for comExpr in g:comEx
    execute range . "call easy_align#align(0, 0, motionType, comExpr)"
  endfor
  " call JumpBackSkipCurrentLoc()
endfunc
" Opfunction might be abstracted better using this approach? https://vi.stackexchange.com/questions/12555/how-to-allow-count-before-my-custom-operator 


" Tabularize in multiple runs based on a list of different patterns
" Skips lines where the pattern does not match
func! TabularizeListOfPttns( listOfColumnPatterns, startLine, endLine )
  " let range = a:startLine.','.a:endLine
  for pttn in a:listOfColumnPatterns
    " call ExecRange( "GTabularize " . '/' . pttn . '/', a:startLine, a:endLine )
    " call ExecRange( "call easy_align#align(0, 0, 'lines', " . '/' . pttn . '/' . ")", a:startLine, a:endLine )
    " execute range . "call easy_align#align(0, 0, 'lines', pttn)"
    call easy_align#easyAlign( startLine, endLine, pttn)
  endfor
endfunc
" Test with: call HsTabularizeTypeSigns( 2, 4 )

" Example of EasyAlign API usage:
" EasyAlign <line1>,<line2>call easy_align#align(<bang>0, 0, 'command', <q-args>)


func! AlignBufferAsTable( columnPttn )
  normal ggV,jo^
  exec "'<,'>Tabu /" . a:columnPttn
  normal Vl
endfunc

func! AlignBufferAsColumns( columnPtts )
  normal V,jo^
  normal V
  " motionType could e.g. be 'char' here - but aligning will only use linewise here
  let motionType = 'lines'
  " The align expression (EasyAlign DSL)
  " If no colums patterns are passed (empty list) then the default (two colums by space) is used
  let columnPtts = len( a:columnPtts ) ? a:columnPtts : ['\ ', '2\ ']
  " Get the range of lines from either visual mode ( "'<") or an (operator pending) motion or text object
  let [l1, l2] = ["'<", "'>"]
  " Format the range string
  let range = l1.','.l2
  " Call the easyAlign main API function
  " function! easy_align#align(bang, live/preview-mode, visualmode, expr) range
  for comExpr in columnPtts
    execute range . "call easy_align#align(0, 0, motionType, comExpr)"
  endfor
  " call JumpBackSkipCurrentLoc()
endfunc
" call AlignColumns( ['\,', '2\,'] )

" let pttns0 = ['/∷/', '/.*\(∷\zs\s\|\zs⇒\)/']
" let pttns1 = ['/∷/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/']
" let pttns2 = ['/∷/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '2/\(([^)]*\)\@<!→\([^(]*)\)\@!/']
" let pttns3 = ['/∷/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '/\(([^)]*\)\@<!.*\zs→\([^(]*)\)\@!/']


func! AlignBufferTypeSigs() " ■
  call ReplaceInRange( 1, line('$'), g:HsReplacemMap_CharsToUnicode )

  let pttns4 = ['/∷/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '2/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '/\(([^)]*\)\@<!.*\zs→\([^(]*)\)\@!/']

  for pttn in pttns4
    call easy_align#easyAlign(1, line('$'), pttn)
  endfor
  " call TabularizeListOfPttns( g:hsTypeSigColumnsUnicode, startLine, endLine )

  call ReplaceInRange( 1, line('$'), g:HsReplacemMap_UnicodeToChars )
endfunc " ▲




" let g:pttnArrowOutsideParan = '\(([^)]*\)\@<!->\([^(]*)\)\@!'
" let g:pttnArrowOutsideParanUnicode = '\(([^)]*\)\@<!→\([^(]*)\)\@!'
" " call matchadd('MatchParen', '\(([^)]*\)\@<!->\([^(]*)\)\@!', -1, -1 )
" " TODO replicate this with PatternToMatchOutsideOfParentheses()
" " let g:hsTypeSigColumns = [ "::", "=>", ".*\\zs\-\>" ]
" let g:hsTypeSigColumns = [ "::", "=>", g:pttnArrowOutsideParan, ".*\\zs\-\>" ]
" " let g:hsTypeSigColumnsUnicode = [ "∷", "⇒", ".*\\zs→" ]
" let g:hsTypeSigColumnsUnicode = [ "∷", "⇒", g:pttnArrowOutsideParanUnicode, ".*\\zs→" ]
"
" " Tabularizes patterns found in TypeSignatures over a range of lines
" func! HsTabularizeTypeSigns( startLine, endLine )
"   call TabularizeListOfPttns( g:hsTypeSigColumns, a:startLine, a:endLine )
" endfunc
"
" func! HsTabularizeTypeSignsUnicode( startLine, endLine )
"   call TabularizeListOfPttns( g:hsTypeSigColumnsUnicode, a:startLine, a:endLine )
" endfunc
" call HsTabularizeTypeSigns( 2, 4 )
" call HsTabularizeTypeSigns( 1, line('$') )

func! HsAlignTypeSigs(...)
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')

  let l:winview = winsaveview()
  call ReplaceInRange( startLine, endLine, g:HsReplacemMap_CharsToUnicode )
  call TabularizeListOfPttns( g:hsTypeSigColumnsUnicode, startLine, endLine )
  call ReplaceInRange( startLine, endLine, g:HsReplacemMap_UnicodeToChars )
  call winrestview(l:winview)
endfunc

" Obsolete ■
" func! HoogleAlignSinatures()
"   GTabularize /∷/
"   GTabularize /⇒/
"   GTabularize /.*\zs→/
" endfunc

" ALIGNING COLUMS OF HASKELL SIGS:{{{
" run: :browse Data.List.Split in GHCi and copy into a vim buffer
"
" align right to ∷ with padding 1:
" '<,'>Tabularize /::/r1c1l1
" move lines that contain "Splitter" to the bottom of the file!
" g/Splitter/m$
" move lines with two occurences of "Splitter" to the bottom
" g/Splitter.*Splitter/m$
" move lines with "Eq" to line 22!
" '<,'>g/Eq/m22
" ▲



nnoremap <silent> <leader>ha :set opfunc=AlignTypeSigs_op<cr>g@
vnoremap <silent> <leader>ha :<c-u>call AlignTypeSigs_op( visualmode(), 1)<cr>
" Note: This *does* work with "V"/ Visual-Block mode or "v"
nnoremap <silent> <leader>hA :call HsAlignTypeSigs()<cr>
" or "viB<space>ha<c-o>"

" Perform an align operation on a range of lines. An operator function can/needs to access the range as shown below
func! AlignTypeSigs_op( motionType, ...)
  normal! m'
  " motionType could e.g. be 'char' here - but aligning will only use linewise here
  " Get the range of lines from either visual mode ( "'<") or an (operator pending) motion or text object
  if a:0
    let [l1, l2] = ["'<", "'>"]
  else
    let [l1, l2] = [line("'["), line("']")]
  endif
  " call HsAlignTypeSigs( l1, l2 )
  call AlignTypeSigs( l1, l2 )
endfunc


" ─^  Haskell Align Type Sigs                            ▲




let g:haskell_tabular = 1
" let g:necoghc_enable_detailed_browse = 0

" vmap a= :Tabularize /=<CR>
" vmap a; :Tabularize /::<CR>
" vmap a- :Tabularize /-><CR>

" vmap <leader>ta :Tabularize /∷\|→\|⇒/<cr>
" vmap <leader>ta :Tabu /∷\\|→\\|⇒/<cr>
" note: to insert "\" into command line it needs to be escaped like "\\"


" EXTRACT SIGNATURES: ------------------------------------------------------------
" This makes a nice overview of the function signatures of a hakell file
" 1.copy/extract function signatures to the end of the file (run either of these)
nnoremap <leader>exs :g/∷.*→/t$<cr>
vnoremap <leader>exs :g/∷.*→/t$<cr>
nnoremap <leader>exg :g/∷.*⇒/t$<cr>
" 2. visual select the signatures
" 3. move only the generic sign out of the block
vnoremap <leader>exg :g/∷.*⇒/m$<cr>
" 4. visual select blocks and <leader>ta to tabularize the sigs
command! ExtractSigs :g/∷.*→/t$
command! ExtractGenSigs :g/∷.*⇒/t$
" --------------------------------------------------------------------------------

" Join line below with current line
nnoremap <BS> J

" This 'undo's a line break while staying in insert mode
" TODO this has confusing behavior
" inoremap <BS> <c-o>k<c-o>J

" Line break (with indention)
" nnoremap <leader>j hs<cr><c-[>l
nnoremap <leader>j gea<cr><c-[>l


" Insert line. Related to `]<space>`
" nnoremap O o<Esc> 

" also note these related map in vimrc  ~/.vimrc#/also%20note%20~/.vim/plugin/utils-align-old.vim#/Join%20line%20below

" TIP: indenting, inserting characters
function! ExampleIndentByNChars()
  let l:str1 = repeat('X', col('.'))

  " this line reads as follows:
  " from the current line (".")
  " to "+2" lines (after the ",")
  " substitute ("s/")
  " from any character ("^")
  " inserting the string using ". l:str1 ."
  " "g" mean global (see: "http://vim.wikia.com/wiki/Search_and_replace")
  exec '.,+2s/^/' . l:str1 . '/g'
  " Example: with cursor (') on column 18 / the "x"
  " XXXXXXXXXXXXXXXXXX  " testline 1111x11
  " XXXXXXXXXXXXXXXXXX  " testline 2222222
  " XXXXXXXXXXXXXXXXXX  " testline 3333333
endfun

" EasyAlign: -----------------------------
" 1. visually selecte the lines
" 2. type ':EasyAlign'
" 3. type '2 ' to align to the second space!!

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <leader>al <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <leader>eaip)
nmap <leader>al <Plug>(EasyAlign)

let g:easy_align_ignore_groups = ['Comment', 'String']

" Align Example:
" you can go from this: ..
" data Drawing
"   = Fill Shape FillStyle
"   | Outline Shape OutlineStyle
"   | Text Font Number Number FillStyle String
"   | Rotate Number Drawing
"   | Clipped Shape Drawing
"   | WithShadow Shadow Drawing

" .. to this:
" data Drawing
"   = Fill       Shape  FillStyle
"   | Outline    Shape  OutlineStyle
"   | Text       Font   Number Number FillStyle String
"   | Rotate     Number Drawing
"   | Clipped    Shape  Drawing
"   | WithShadow Shadow Drawing
" 1. uncomment this block first, then with the cursor on the second line:
" 2. "<leader>al,j2 "  ← new mapping
" 2. "<leader>ea}2 " aligns the rest of the block to the 2nd <space>, and then
" 3. "<leader>ea}3 " to align to the 3rd <space> as well

" Align Example:
" (using Tabularize or EasyAlign with regex)
" you can go from this: ..
" everywhere f = go
"   where
"   go (Many ds) = f (Many (map go ds))
"   go (Scale s d) = f (Scale s (go d))
"   go (Translate t d) = f (Translate t (go d))
"   go (Rotate r d) = f (Rotate r (go d))
"   go (Clipped s d) = f (Clipped s (go d))
"   go (WithShadow s d) = f (WithShadow s (go d))
"   go other = f other

" .. to this:
" everywhere f = go
"   where
"   go (Many ds)        = f (Many (map      go ds))
"   go (Scale s d)      = f (Scale s (      go d))
"   go (Translate t d)  = f (Translate t (  go d))
"   go (Rotate r d)     = f (Rotate r (     go d))
"   go (Clipped s d)    = f (Clipped s (    go d))
"   go (WithShadow s d) = f (WithShadow s ( go d))
"   go other            = f other
" 1. select all lines starting with "go"
" 2. ":Tabularize /=/" to align to `=`
" 3. ":Tabularize /go/" to align to `go`
" Also EasyAlign can align to words or other chars using regex like this:
" "<,'>EasyAlign */go/"
" "<,'>EasyAlign */(g/"
" "<,'>EasyAlign */(go/"
" "<,'>EasyAlign */(/"

" GTabularize applies only to lines that match!
" Regex ".*\zs," matches the last comma in the line
" Running the following will align the type signatures as shown below
" GTabularize /∷/
" GTabularize /⇒/
" GTabularize /.*\zs→/

" -- Control.Monad
" replicateM ∷ (Applicative m) ⇒ Int → abc a → m [a]
" -- Data.Sequence
" replicateM ∷ Monad m ⇒ Int → m a → m (Seq a)
" -- Data.Sequence.Internal
" replicateM ∷ Monad m ⇒ Int → m a → m (Seq a)
" -- Data.Conduit.List
" replicateM ∷ Monad m ⇒ Int → m a → Producer m a
" -- Control.Monad
" replicateM_ ∷ (Applicative m) ⇒ Int → m a → m ()
" -- Data.Conduit.Internal.List.Stream
" replicateMS ∷ Monad m ⇒ Int → m a → StreamProducer m a
"
" -- Control.Monad
" replicateM  ∷ (Applicative m) ⇒ Int → abc a → m [a]
" -- Data.Sequence
" replicateM  ∷ Monad m         ⇒ Int → m a   → m (Seq a)
" -- Data.Sequence.Internal
" replicateM  ∷ Monad m         ⇒ Int → m a   → m (Seq a)
" -- Data.Conduit.List
" replicateM  ∷ Monad m         ⇒ Int → m a   → Producer m a
" -- Control.Monad
" replicateM_ ∷ (Applicative m) ⇒ Int → m a   → m ()
" -- Data.Conduit.Internal.List.Stream
" replicateMS ∷ Monad m         ⇒ Int → m a   → StreamProducer m a

















