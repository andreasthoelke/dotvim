
" Also note the formatting related settings:
" Settings in ftplugin:
" ~/.vim/ftplugin/purescript.vim#/setlocal%20comments=s1fl.{-,mb.-,ex.-},.--%20commentstring=--\
" setlocal comments=s1fl:{-,mb:-,ex:-},:-- commentstring=--\ %s
" setlocal formatoptions-=t formatoptions+=croql
" ~/.vim/indent/purescript.vim#/setlocal%20indentexpr=GetHaskellIndent..

" Learn: \hu, \hU, \ht, leader if
" TODO ?

" tj00 ∷ a
" tj00 = undefined

" Try: - "gqaf"
" Issue: this behaved strangely when tried in 5.2019
" set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" If the 'formatexpr' option is not empty it will be used instead formatprg
" In HsSyntaxAdditions
" setlocal formatprg=stylish-haskell


" Reduce a paragraph (purs repl type output) to one line, deleting 2+ space seperations between words
nnoremap <leader>ccu "td}:call TransfTRegAndAppend( function('StripNewlinesAndMultispaces') )<cr>k

" Get the type of do-binds by producing a type error:
" nnoremap <leader>cco "tyiwolet (xb0 :: Int) = <esc>"tp^
nnoremap <leader>cco "tyiwolet (xb0 :: Int) = <esc>$"tp^
" "$" is needed because EasyClip jumps back
" Note: It's easier to see the type with this, but then it requires 3 keypesses to undo
nmap <leader>cci wi∷ _ <esc>^dr
nmap <leader>ccu wdwdw^dr
" These work fine - conflict with bracket/comma navigation
" nmap ,ti wi∷ _ <esc>^dr
" nmap ,tu wdwdw^dr


" Apply 'fn' to the 't'/temp and append the result after the current line
func! TransfTRegAndAppend ( fn )
  call append( line('.') - 1, a:fn( @t ))
endfunc
" Testfn: Use of TransfTRegAndAppend with higher order function
nnoremap <leader>cci "tdd:call TransfTRegAndAppend( function('toupper') )<cr>


" Note: ~/.vim/plugin/utils-align.vim#/command.%20-range=%%20StripAligningSpaces
" and: ~/.vim/plugin/HsAPI.vim#/func.%20CleanupBrowseOutput..
func! StripNewlinesAndMultispaces( str ) " 1. delete all newlines:
  let l:str1 = substitute(  a:str,  '\n',  '', 'ge' )
  " 2. replace sections/words that have more than one space (regex: ' \+') with one space
  let l:str2 = substitute( l:str1, ' \+', ' ', 'ge' )
  return l:str2
  " the same in one 's' command:
  " exec 's/\n//ge | s/ \+/ /ge'
endfunc

func! StripString( original, stripThisString )
  return substitute(  a:original, a:stripThisString, '', 'ge' )
endfunc


" ─   Hs format utils from HsAPIExplore                 ──


  " Put modules in separate line. For all lines, line break after big-word (no trailing whitespace), comment the module line
command! SplitModulesInLines exec 'g/--/d' | exec 'g/./normal! Whiki-- ' | StripWhitespace | exec 'normal! gg0'

command! JoinModulesFromLines exec 'g/./normal! dwJ' | exec 'StripAligningSpaces' | exec 'normal! gg0'


func! PreserveKleisliInUnicodeReplace( listListMap ) "{{{
  call insert( a:listListMap, ['>=>', '>#>'] )
  call add   ( a:listListMap, ['>#>', '>=>'] )
  return a:listListMap
endfunc
" echo PreserveKleisliInUnicodeReplace( [['=>', '⇒'], ['c', 'd']] )}}}

" Require Space Before Operator Chars
func! ExtendOperatorPattern( listListMap )
  let augmentedListList = []
  for [fst, snd] in a:listListMap
    call add( augmentedListList, [ '\s\zs' . fst, snd ] )
  endfor
  return augmentedListList
endfunc
" echo ExtendOperatorPattern( [['aa', 'bb'], ['=>', '⇒']] )


" ─   Haskell unicode conversion                         ■

nnoremap <leader><leader>sm :exec 'SplitModulesInLines'<cr>
nnoremap <leader><leader>jm :exec 'JoinModulesFromLines'<cr>

nnoremap <leader><leader>ht :exec 'HsTabu'<cr>
nnoremap <leader><leader>hT :exec 'StripAligningSpaces'<cr>
nnoremap <leader><leader>sa :exec 'StripAligningSpaces'<cr>

nnoremap <leader><leader>hu :exec 'HsUnicode'<cr>
nnoremap <leader><leader>hU :exec 'HsUnUnicode'<cr>



command! -range=% HsUnicode call HsUnicode( <line1>, <line2> )
command! -range=% HsUnUnicode call HsUnUnicode( <line1>, <line2> )

func! HsUnicode( startLine, endLine )
  call ReplaceInRange( a:startLine, a:endLine, g:HsReplacemMap_CharsToUnicode )
endfunc

func! HsUnUnicode( startLine, endLine )
  call ReplaceInRange( a:startLine, a:endLine, g:HsReplacemMap_UnicodeToChars )
endfunc

" Note: Replacing even the custom unicode (conceal) symbols only makes sense to simplyfiy visual alignment code
" TODO: test this. slow?
func! HsUnicodeAll( startLine, endLine )
  call ReplaceInRange( a:startLine, a:endLine, g:HsCharsToUnicode )
endfunc

func! HsUnUnicodeAll( startLine, endLine )
  call ReplaceInRange( a:startLine, a:endLine, FlipListList( g:HsCharsToUnicode ) )
endfunc


" Setup:
" TODO now obsolete? see ~/.vim/syntax/purescript.vim#/let%20g.HsCharsToUnicode%20=
let g:HsReplacemMap_CharsToUnicode = [['->', '→'], ['=>', '⇒'], ['::', '∷'], ['forall', '∀'], ["<-", "←"]]
let g:HsReplacemMap_CharsToUnicodePtts = ExtendOperatorPattern( g:HsReplacemMap_CharsToUnicode )
let g:HsReplacemMap_UnicodeToChars = FlipListList( g:HsReplacemMap_CharsToUnicode )


" obsolete?
command! -range=% CharsToUnicode :<line1>,<line2>call ReplaceStringsInRange( ExtendOperatorPattern( g:HsReplacemMap_CharsToUnicode ) )
command! -range=% UnicodeToChars :<line1>,<line2>call ReplaceStringsInRange( g:HsReplacemMap_UnicodeToChars )
" .,+6HsReplaceCharsToUnicode
" .,+6HsReplaceUnicodeToChars
" .+3HsReplaceCharsToUnicode
" Control.Monad replicateM :: (Applicative m) => Int -> m a -> m [a]
" unfold :: Monad m => (b -> Maybe (a, b)) -> b -> Producer m a
" kleisli :: forall e. Example e >=> Line
" kleisli = do aa <- example

" Note:  ~/.vim/syntax/purescript.vim#/let%20g.HsCharsToUnicode%20=
" let g:HsCharsToUnicode = [
"   \  ['\s\zs->',           '→']
"   \, ['\s\zs<-',           '←']
"   \, ['\s\zs=>',           '⇒']
"   \, ['\s\zs<=',           '⇐']
"   \, ['::',                '∷']
"   \, ['\s\zsforall',       '∀']
"   \, ['\\\%([^\\]\+\)\@=', 'λ']
"   \, [' \zs\.',            '∘']
"   \, [' \zs<\$>',          '⫩']
"   \, [' \zs<\*>',          '⟐']
"   \, [' \zs>>',            '≫']
"   \, [' \zs>>=',           '⫦']
"   \, [' \zs\`elem\`',      '∈']
"   \, [' \zs\`flipElem\`',  '∋']
"   \, [' \zs>=>',           '↣']
"   \, [' \zs<=<',           '↢']
"   \, [' \zs==',            '≡']
"   \, ['==\ze ',            '≡']
"   \, [' \zs/=',            '≠']
"   \, ['/=\ze ',            '≠']
"   \, [' \zs<>',            '◇']
"   \, ['<>\ze ',            '◇']
"   \, [' \zsmempty',        '∅']
"   \, [' \zs++',            '⧺']
"   \, [' \zs<=',            '≤']
"   \, [' \zs>=',            '≥']
"   \, ['Integer',           'ℤ']
"   \]


" ─^  Haskell unicode conversion                         ▲


" ─   Formatting Haskell Imports                         ■
let g:stylish_haskell_command = 'stylish-haskell'
noremap <leader>hfi :call StylishHaskell()<cr>
command! FormatImports :call StylishHaskell()
command! Indent :call StylishHaskell()

" Issue: other windows loose their focus!
function! StylishHaskell()
  write
  " write any changes as otherwise those would be lost - no undo possible!
  let output = system(g:stylish_haskell_command . " " . bufname("%"))
  let errors = matchstr(output, '\(Language\.Haskell\.Stylish\.Parse\.parseModule:[^\x0]*\)')
  if v:shell_error != 0
    echom output
  elseif empty(errors)
    call s:OverwriteBuffer(output)
    write
  else
    echom errors
  endif
endfunction

" taken from stylish-haskell plugin
function! s:OverwriteBuffer(output)
  let winview = winsaveview()
  silent! undojoin
  normal! gg"_dG
  call append(0, split(a:output, '\v\n'))
  normal! G"_dd
  call winrestview(winview)
endfunction
" ─^  Formatting Haskell Imports                         ▲





