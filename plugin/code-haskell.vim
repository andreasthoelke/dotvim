
func! GetTopLevSymbolName( lineNum )
  " return matchstr( getline(a:lineNum), '^\S*\ze\s')
  " return matchstr( getline(a:lineNum), '\v\S+\ze\s')
  return matchstr( getline(a:lineNum), '\v(--\s*)?\zs\S+\ze\s')
endfunc
" echo GetTopLevSymbolName( line('.') +1 )
" Control.Monad replicateM :: (Applicative x) => Int -> x a -> X [a]

" Return the previous function name
func! GetTopLevSymbolNameBackw()
  let lineNum = TopLevBackwLine()
  return GetTopLevSymbolName( lineNum )
endfunc
" echo GetTopLevSymbolNameBackw()

func! GetStringInQuotesFromLine( lineNum )
  return matchstr( getline( a:lineNum ), '\"\zs.*\ze\"')
endfunc
" echo GetStringInQuotesFromLine( line('.') +1 )
" req "abc def"

" Like <cword> but includes Haskell symbol characters
func! HsCursorKeyword()
  return expand("<cword>")
  " TODO temp: stop here as this currently errors in purescript
  let isk = &l:isk
  " Tempoarily extend the isKeyword character range
  " setl isk+=.,<,>,$,#,+,-,*,/,%,',&,=,!,:,124,~,?,^
  setl isk+=<,>,$,#,+,-,*,/,%,&,=,!,:,124,~,?,^
  let kword = expand("<cword>")
  let &l:isk = isk
  if kword[0] =~ '\a'
    return kword
  else
    return '('.kword.')'
  endif
endfunc
"  == (.) (>>=) >>= [ext, more]

nnoremap <leader><leader>ca :echo HsCursorKeyword_findModule()<cr>

" Prefix the identifier with the module name. Module name is derived from the context (via conventions not the repl)
func! HsCursorKeyword_findModule()
  let kw = HsCursorKeyword()
  " 1) Already fully qualified identifier: Control.Monad.replicateM
  if     kw =~ '\..*\.' " Keyword already contains full module, e.g. 'Control.Monad.sequence' not just M.sequence
    return kw
  " 2) Just a module: Control.Monad
  elseif kw =~ '\.\u' " kw includes a shortcut e.g. 'Map.lookup'
    return kw
    " import qualified Data.Zwei        as M
    " import qualified Data.Test        as Map
  " 3) Shortcut qualified identifier: Map.lookup or M.lookup
  elseif kw =~ '\.\a' " kw includes a shortcut e.g. 'Map.lookup'
    let fullModuleName = ModuleName_fromQualifiedShortname( CropLastElem( kw , '\.' ) )
    if fullModuleName == ''
      echo 'no module name found: ModuleName_fromQualifiedShortname HsCursorKeyword_findModule'
    endif
    let identifier = GetLastElem( kw, '\.' )
    return fullModuleName . '.' . identifier
  " 4) HsAPI view 1:
    " -- Data.Zip
    " alignWith :: Semialign f => (These a b -> c) -> f a -> f b -> f c
  elseif getline( line('.')-1 ) =~ '--\s\S\+\.\S\+$' " we are in HsAPI view with commented modules in separate lines
    let fullModuleName = matchstr( getline( line('.')-1 ), '--\s\zs\S\+')
    return fullModuleName . '.' . kw
  " 5) HsAPI view 2:
  " Control.Monad replicateM :: (Applicative m) => Int -> m a -> m [a]
  " elseif getline('.') =~ '\..*' . kw . '\s\:\:' " we are in a different HsAPI view with module name preceding the identifier separated by a space
  " elseif getline('.') =~ '^\u\S*\s\+(\?' . kw . ')\?\s\+\:\:' " we are in a different HsAPI view with module name preceding the identifier separated by a space
  elseif getline('.') =~ '^\u\S\+\s\+.\+' . kw . '\s' " we are in a different HsAPI view with module name preceding the identifier separated by spaces or other keywords like data, newtype, etc
    return GetTopLevSymbolName( line('.') ) . '.' . kw
  " 6) HsAPI view 3: browse module output
  elseif getline(1) =~ '-- browse '
    let fullModuleName = ModuleName_fromCommandLabel()
    return fullModuleName . '.' . kw
  " 7) Listed import:
  " import           Text.Parsec              (replicateM)
  " replicateM
  else
    let fullModuleName = ModuleName_fromListedImport( kw )
    if fullModuleName == ''
      echo 'no module name found: ModuleName_fromListedImport HsCursorKeyword_findModule'
      return kw
    else
      return fullModuleName . '.' . kw
    endif
  endif
endfunc
" Tests:
" Control.Monad.replicateM
" Control.Monad
" Map.lookup or M.lookup
" -- Data.Zip
" alignWith :: Semialign f => (These a b -> c) -> f a -> f b -> f c
" Control.Monad replicateM :: (Applicative m) => Int -> m a -> m [a]
" Prelude                              (.)      ::      (b -> c) -> (a -> b) -> a -> c
" Data.Function                        (.)      ::      (b -> c) -> (a -> b) -> a -> c
" Prelude                              (<$>)      ::      (b -> c) -> (a -> b) -> a -> c
" Distribution.Compat.Prelude.Internal (.)      :: () => (b -> c) -> (a -> b) -> a -> c
" Data.Composition                     compose ::      (b -> c) -> (a -> b) -> a -> c
" Data.Eq                              (==)                             :: Eq a => a -> a -> Bool
" Control.Applicative                  (.)      ::      (b -> c) -> (a -> b) -> a -> c
" import qualified Data.Zwei        as M
" import qualified Data.Test        as Map
" import qualified Data.ByteString            as BS
"   Map.lookup or M.lookup
"   String
"   ShowS
" Data.Monoid           newtype Sum a


func! GetLastElem( str, separator )
  let items = split( a:str, a:separator )
  if len( items )
    return items[-1]
  else
    return a:str
  endif
endfunc
" echo GetLastElem( 'Data.Profunctor.Mapping.somefn', '\.' )
" echo GetLastElem( 'somefn', '\.' )

func! CropLastElem( str, separator )
  let items = split( a:str, a:separator )
  if len( items )
    return join( items[:-2], '.' )
  else
    return ''
  endif
endfunc
" echo CropLastElem( 'Data.Profunctor.Mapping.somefn', '\.' )
" echo CropLastElem( 'somefn', '\.' )

func! LastChar( str )
  if len( a:str )
    return a:str[ len(a:str)-1 ]
  else
    return ''
  endif
endfunc
" echo GetLastChar('eins')

func! CropLastChar( str )
  if len( a:str )
    return a:str[ : len(a:str)-2 ]
  else
    return ''
  endif
endfunc
" echo CropLastChar('eins')


" Get the type signature from line
func! HsExtractTypeFromLine( lineNum )
  let line  = getline( a:lineNum )
  let pattern = '\v^.*(∷|:)\ze'
  return substitute( line, pattern, '', '')
endfunc
" Control.Monad replicateM :: (Applicative m) => Int -> m a -> m [a]
" echo HsExtractTypeFromLine( line('.')-1 )
" Control.Monad replicateM ∷ (Applicative m) => Int -> m a -> m [a]
" echo HsExtractTypeFromLine( line('.')-1 )

" Issue: this will have problems with functions as args. (a -> b) would have to ignore the '->' in brackets
" Use HsExtractArgTypesFromTypeSigStr instead
func! SplitTypeSignStr( typeSigStr )
  let list = split( a:typeSigStr, '\v(-\>|→|::|∷|\=\>|⇒)' )
  return TrimListOfStr( list )
endfunc
" Control.Monad replicateM ∷ (Applicative m) ⇒ Int → m a → m [a]
" Control.Monad replicateM :: (Applicative m) => Int -> m a -> m [a]
" echo SplitTypeSignStr( getline( line('.')-1 ) )

func! HsExtractReturnTypeFromTypeSigStr( typeSigStr )
  let list = SplitTypeSignStr( a:typeSigStr )
  return list[ len( list ) -1 ]
endfunc

func! HsExtractArgTypesFromTypeSigStr( typeSigStr )
  let mainPartsList = split( a:typeSigStr, '\v(∷\s|::\s|⇒\s|\=\>\s)' )
  " let signatureTypes = split( mainPartsList[-1], '\v→' )
  let signatureTypes = split( mainPartsList[-1], PatternToMatchOutsideOfParentheses( '\(→\s\|->\s\)', '(', ')' ) )
  let argumentsTypes = signatureTypes[:-2]
  return TrimListOfStr( argumentsTypes )
endfunc

" Control.Monad replicateM ∷ (Applicative m) ⇒ Int → m a → m [a]
" echo HsExtractArgTypesFromTypeSigStr( getline( line('.')-1 ) )
" Control.Monad replicateM :: (Applicative m) => Int -> m a -> m [a]
" echo HsExtractArgTypesFromTypeSigStr( getline( line('.')-1 ) )
" Control.Monad replicateM ∷ (Applicative m) ⇒ Int → (a → b) → m a → m [a]
" echo HsExtractArgTypesFromTypeSigStr( getline( line('.')-1 ) )


func! HsGetTypeFromSignatureStr( signStr )
  return matchstr( a:signStr, '\v(∷|::)\s\zs.*')
endfunc
" Control.Monad replicateM ∷ (Applicative m) ⇒ Int → m a → m [a]
" echo HsGetTypeFromSignatureStr( getline( line('.')-1 ) )

func! UndefinedVarName ()
  return &filetype=="purescript" ? "u" : "i"
endfunc


func! ArgsPlacehoderStr ( argumentTypesList )
  return functional#foldr( {nextStr, acc -> acc . '(' . UndefinedVarName() . ':: ' . nextStr . ') '}, '', a:argumentTypesList )[0:-2]
endfunc
" echo ArgsPlacehoderStr( ['a → b', 'Maybe a'] )

func! Uppercased( str )
  return a:str[0] =~ '\u'
endfunc
" echo Uppercased( 'Monad.bind' )
" echo Uppercased( 'fmap' )

func! ModuleName_fromQualifiedShortname( shortName )
  let lineNum = searchpos( 'import qualified .*as '.a:shortName.'$', 'nbW' )[0]
  return matchstr( getline( lineNum ), 'import qualified \zs\S\+\ze\s')
endfunc
" import qualified Data.Zwei        as M
" import qualified Data.Test        as Map
" echo ModuleName_fromQualifiedShortname( 'Map' )
" echo ModuleName_fromQualifiedShortname( 'M' )

func! ModuleName_fromListedImport( identifier )
  let lineNum = searchpos( 'import .*(.*'.a:identifier, 'nbW' )[0]
  return matchstr( getline( lineNum ), 'import\s\+\zs\u\S\+\ze\s')
endfunc
" import           Text.Parsec              (many)
" import qualified Data.ByteString            as BS
" echo ModuleName_fromListedImport( 'many' )
" echo ModuleName_fromListedImport( 'String' )

func! ModuleName_fromCommandLabel()
  let lineNum = searchpos( '-- browse \u\S*$', 'nbW' )[0]
  return matchstr( getline( lineNum ), '-- browse\s\zs\S\+\ze$')
endfunc
" -- browse Data.ByteString.Lazy.Char8
" import qualified Data.Test        as Map
" echo ModuleName_fromCommandLabel()

function! GetModuleName()
  for lineNum in [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    " skip empty lines as those seem to confuse the if == 'module'
    if split( getline( lineNum ) ) == []
      continue
    endif
    let firstWord  = get( split( getline( lineNum ) ), 0 )
    let moduleName = get( split( getline( lineNum ) ), 1 )
    if firstWord == "module"
      break
    endif
  endfor
  return moduleName
endfun

" Extracts the project name, e.g. "pragmaticServant" from the Stack "package.yaml" file
fun! HaskellProjectName()
  let firstLine = readfile('package.yaml')[0:0][0]
  return split(firstLine)[1]
endfun
" These are the first two lines from "package.yaml" at the root of the project folder/working directory:
" name:                pragmaticServant
" version:             0.1.0.0

" Alternative approach: use name of working directory
" expand('%:p:h:t')
fun! HaskellProjectName1()
  return fnamemodify('package.yaml', ':p:h:t')
endfun

function! GetImportedIdentifiers()
  let words = []
  for lineNum in [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    let line = getline( lineNum )
    if ! line =~ 'Concur'
      continue
    endif
    " get text within brackets
    let firstWord  = get( split( getline( lineNum ) ), 0 )
    let moduleName = get( split( getline( lineNum ) ), 1 )
    if firstWord == "module"
      break
    endif
  endfor
  return moduleName
endfun


