" leader eu/U - anonymous binding /+ signature
" leader es   - add signature type stub
" leader eb   - add function to type-sig/ expand signature
" leader ei   - add an index/num to the signature-symbol name
" leader et   - create inline test stub
" leader ea   - create assertion

" TODO new feature - support Reader, State with 'runReader ... (r)'
" cbwl0 :: Reader Int String
" cbwl0 = asks report <*> asks ((/10).fromIntegral) <*> asks even
" e1_cbwl0 = runReader cbwl0 (i:: Int)
" "2. new feature: (x -> Bool) should be 'xp'

nnoremap <leader>et :call CreateInlineTestDec()<cr>
" e1_database4 = database4 (Just "eins") 123
func! CreateInlineTestDec()
  let typeSigLineNum = TopLevTypeSigBackwLineNum()
  let funcName       = GetTopLevSymbolName( typeSigLineNum )
  let argumentTypesList = HsExtractArgTypesFromTypeSigStr( getline( typeSigLineNum ) )
  let nextIndex = GetNextTestDeclIndex()
  let lineText = 'e' . nextIndex . '_' . funcName . ' = ' . funcName . ' ' . ArgsPlacehoderStr( argumentTypesList )
  call append( line('.') -1, lineText )
  normal k^ww
endfunc
" Tests:
" intStr :: Int -> String
" intStr i = show i
" Will produce
" e1_intStr = intStr (i:: Int)

func! GetNextTestDeclIndex()
  let lineNumPrevInlineTestDec = InlineTestDeclBackwLine()
  let thereIsAPrevTestDecl = lineNumPrevInlineTestDec > TopLevBackwLine()
  if thereIsAPrevTestDecl
    return 1 + eval( GetTestDeclIndex( lineNumPrevInlineTestDec ) )
  else
    return 1
  endif
endfunc
" database2 ∷ String → [(String, String, Int)]
" e1_database4 = database4 (Just "eins") 123
" echo GetNextTestDeclIndex()


nnoremap <leader>ea :call CreateAssertion()<cr>
" Tests: (uncomment)
" database4 ∷ String → [(String, String, Int)]
" e1_database4 = database4 (Just "eins") 123
" a11_database4 = id e1_database4 == (i∷ [(String, String, Int)])
func! CreateAssertion()
  let lineNumPrevInlineTestDec = InlineTestDeclBackwLine()
  if lineNumPrevInlineTestDec < TopLevBackwLine()
    echoe 'Please create the assertion after a test declaration!'
    return
  endif
  let typeSigLineNum = TopLevBackwLine()
  let funcName       = GetTopLevSymbolName( typeSigLineNum )
  let funcReturnType = HsExtractReturnTypeFromTypeSigStr( getline( typeSigLineNum ) )

  let nextIndex = GetNextAssertionIndex()
  let decSymbolName = GetTopLevSymbolName( lineNumPrevInlineTestDec )
  let lineText = 'a' . nextIndex . '_' . funcName . ' = identity ' . decSymbolName . ' == (u:: ' . funcReturnType . ')'
  call append( line('.') -1, lineText )
  normal k^ww
endfunc

func! GetNextAssertionIndex()
  let lineNumPrevInlineTestDec = InlineTestDeclBackwLine()
  let lineNumPrevAssertion     = InlineTestAssertionBackwLine()
  let thereIsAPrevTestDecl  = lineNumPrevInlineTestDec > TopLevBackwLine()
  let thereIsAPrevAssertion = lineNumPrevAssertion > lineNumPrevInlineTestDec
  if thereIsAPrevTestDecl
    if thereIsAPrevAssertion
      return 1 + eval( GetAssertionIndex( lineNumPrevAssertion ) )
    else
      return GetTestDeclIndex( lineNumPrevInlineTestDec ) . '1'
    endif
  else
    echoe 'Please create the assertion after a test declaration!'
    return 11
  endif
endfunc
" database2 ∷ String → [(String, String, Int)]
" e1_database4 = database4 (Just "eins") 123
" a14_database4 = id e1_database4 == (i∷ [(String, Int)])
" echo GetNextAssertionIndex()



func! InlineTestDeclBackwLine()
  return searchpos( '\v^e\d_', 'cnbW')[0]
endfunc
" echo InlineTestDeclBackwLine()

func! InlineTestAssertionBackwLine()
  return searchpos( '\v^a\d\d_', 'cnbW')[0]
endfunc
" echo TopLevBackwLine()

func! GetTestDeclIndex( lineNum )
  return matchstr( getline(a:lineNum), '^e\zs\d\ze_')
endfunc
" echo GetTestDeclIndex( 6 )
" echo GetTestDeclIndex( line('.') +1 )
" e2_database4 = database4 Nothing 99

func! GetAssertionIndex( lineNum )
  return matchstr( getline(a:lineNum), '^a\zs\d\d\ze_')
endfunc
" echo GetAssertionIndex( line('.') +2 )
" echo 10 + eval( GetAssertionIndex( line('.') +1 ) )
" a14_database4 = id e1_database4 == (i∷ [(String, Int)])


" ─   "unique functions"                                 ■
nnoremap <leader>eu ^icb<esc>:call RandFnName()<cr>A = u<esc>^2w
nnoremap <leader>eU ^icb<esc>:call RandSymbol()<cr>A :: String<esc>^ywo<esc>PA= u<esc>^2w
" produces a (test) haskell function with a random name, ejk.:
" cp0 = undefined
" "unique symbol"
" nnoremap <leader>hus :call RandSymbol()<cr>

" "expand function" expand a symbol name to a function stub
" nnoremap <leader>ef A ∷ String<esc>^ywo<esc>PA= undefined<esc>b
" nmap <leader>fe A :: String<esc>^ywjPA= undefined<esc>b
" Issue: This clutters the register
" nnoremap <localleader>ht ^yiwko<esc>PA :: a<esc>w

" TODO adapt other stub maps to not use yank register
nnoremap <leader>es :call Stubs_ExpandATypeSign()<cr>
func! Stubs_ExpandATypeSign()
  let symbName = GetTopLevSymbolName( line('.') )
  let indentChars = repeat( ' ', col('.')-1)
  let lineText = indentChars . symbName . ' :: _'
  call append( line('.') -1, lineText )
  normal! k$lb
endfunc
" Test:
" cbom0 :: a
" cbom0 = compare

" "expand signature" expand a signature to a function stub
nnoremap <leader>eb :call Stubs_ExpandTermLevelFromTypeSign()<cr>
" Issue: this produces doublicate var names. use  ~/Documents/Haskell/6/HsTrainingTypeClasses1/src/Exercises.hs#/indexDoublicateNames%20..%20[String]

func! Stubs_ExpandTermLevelFromTypeSign()
  let symbName = GetTopLevSymbolName( line('.') )
  let argTypes = HsExtractArgTypesFromTypeSigStr( getline( line('.') ) )
  let argTypesStr = join( ArgTypesToSuggestedArgNames( argTypes ), ' ' )
  let indentChars = repeat( ' ', col('.')-1)
  let lineText = indentChars . symbName . ' ' . argTypesStr . ' = u'
  call append( line('.'), lineText )
  normal! j$b
endfunc

" ─   ArgTypesToSuggestedArgNames                        ■

func! ArgTypesToSuggestedArgNames( types )
  return functional#map( 'ArgTypeToSuggArgName', a:types )
endfunc
" call append('.', join( ArgTypesToSuggestedArgNames( ['Maybe a', '(Av cc, Int)', 'Maybe Field', '[Maybe b]', '(a -> Ab c -> bcd)', 'Maybe Field -> Maybe bc'] ), ', ') )
                                                      " mayA,     tavCc_int,       mayFie,        lmayB,       fa_abC_bcd,            fmayFie_mayBc

" call append('.', join( ArgTypesToSuggestedArgNames( ['Maybe a', 'Maybe a', 'Int', 'Int', 'Maybe Field -> Maybe bc'] ), ', ') )


func! ArgTypeToSuggArgName( type )
  if a:type =~ '->'
    let listShorts = functional#map( 'AbbrevSimpleType', SplitArgs( RemoveBrackets( a:type ) ) )
    return 'f' . join( listShorts, '_' )
  elseif a:type =~ '[' " note there may be a list within the type
    " return 'l' . AbbrevSimpleType( RemoveBrackets( a:type ) )
    return AbbrevSimpleType( RemoveBrackets( a:type ) ) . 's'
  elseif a:type =~ '('
    let listShorts = functional#map( 'AbbrevSimpleType', SplitArgs( RemoveBrackets( a:type ) ) )
    return 't' . join( listShorts, '_' )
  else
    return AbbrevSimpleType( RemoveBrackets( a:type ) )
  endif
endfunc
" echo ArgTypeToSuggArgName( '(a -> Ab c -> Maybe Field)' )

" echo functional#map( 'UppercaseFirstChar', ['eins', 'zwei'] )
func! AbbrevSimpleType( str )
  let listShortened = functional#map( 'AbbrevSymbolName', split( trim( a:str ) )  )
  return join( CamelCaseListOfStr( listShortened ), '' )
endfunc
" echo AbbrevSimpleType( 'Maybe Field' )

func! AbbrevSymbolName( str )
  let camelCaseChar = tolower( matchstr( a:str, '\U\zs\u' ) )
  if camelCaseChar != ''
    let firstChars = tolower( a:str[0] )
  else
    let firstChars = tolower( a:str[0:1] )
  endif
  return firstChars . camelCaseChar
endfunc
" echo AbbrevSymbolName( 'HeaderField' )

func! AbbrevSymbolName2( str )
  let firstChars = LowercaseFirstChar( a:str[0:1] )
  let secondCamelCaseWordFirstChars = matchstr( a:str, '\U\zs\u.\?' )
  return firstChars . secondCamelCaseWordFirstChars
endfunc

func! RemoveBrackets( str )
  return substitute( a:str, '\v(\(|\)|\[|\])', '', 'g')
endfunc
" echo RemoveBrackets('(a -> Maybe cd)')
" echo RemoveBrackets('[Maybe cd]')
" echo RemoveBrackets('(Int, a)')

func! RemoveSpaces( str )
  return substitute( a:str, '\s', '', 'g')
endfunc

func! SplitArgs( str )
  return split( a:str, '\(\,\|->\)' )
endfunc
" echo SplitArgs('a -> Maybe cd')
" echo SplitArgs('a, Maybe cd, Int')

func! CropTo3Chars( str )
  return a:str[0:2]
endfunc
" echo AbbrevTo3Chars('Aber eins')

func! CamelCaseListOfStr( strList )
  let head = a:strList[0]
  let tail = a:strList[1:]
  return [LowercaseFirstChar(head)] + functional#map( 'UppercaseFirstChar', tail )
endfunc
" echo CamelCaseListOfStr( ['Abc', 'def', 'ghi'] )

func! UppercaseFirstChar( str )
  let head = a:str[0]
  let tail = a:str[1:]
  return toupper(head) . tail
endfunc

func! LowercaseFirstChar( str )
  let head = a:str[0]
  let tail = a:str[1:]
  return tolower(head) . tail
endfunc

" ─^  ArgTypesToSuggestedArgNames                        ▲


func! ExpandSignature()
  let identif = GetTopLevSymbolName()
  let fillChars = repeat( ' ', col('.'))
endfunc

" "expand undefined": expand a signature to a function stub
" nnoremap <leader>eu yiwo<esc>PA = undefined<esc>b
" nmap <leader>fe A :: String<esc>^ywjPA= undefined<esc>b


nnoremap <leader>uef <leader>us<leader>ef
" Test stub:
" nmap <leader>ts <leader>us<leader>ef
nmap <leader>hfs :call RandSymbol()<cr>A :: String<esc>^ywo<esc>PA= undefined<esc>wdx0rq0

" "index symbol" append postfix index to function name
nnoremap <leader>eif ea0^jea0^k
" nnoremap <leader>his ea0^jea0^k

" Increase/ decrease the index of TypeSig and term level binding together
nnoremap <leader><c-a> jk^
nnoremap <leader><c-x> <c-x>j<c-x>k^


function! RandFnName()
python << EOF
import string
import random
import vim
vim.current.line += ''.join(random.choice(string.ascii_lowercase) for _ in range(2)) + '0'
EOF
endfunction
" Note the Python code must not be indented in a Vim function

function! RandSymbol()
python << EOF
import string
import random
import vim
vim.current.line += ''.join(random.choice(string.ascii_lowercase) for _ in range(2)) + '0'
EOF
endfunction
" ─^  "unique functions"                                 ▲

" Example of how to run a Python function!!
" Note that you can't pass args - have to use a vim-var for this

python << EOF
import string
import random
import vim
def RandChars():
  cnt = int( vim.eval('g:pyarg') )
  rstr = ''.join(random.choice(string.ascii_lowercase) for _ in range(cnt))
  return rstr
EOF
" let g:pyarg = 5
" echo pyeval('RandChars()')


