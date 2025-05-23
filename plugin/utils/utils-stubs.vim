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

nnoremap <silent><leader>ejd :call CreateJSDocComment_short()<cr>
nnoremap <silent><leader>ejD :call CreateJSDocComment_long()<cr>

nnoremap <silent><leader>ed :call CreateScalaDocComment_long()<cr>

func! CreateScalaDocComment_long()
  normal k
  " let hostLn = searchpos( '^(export\s)?const\s\(e\d_\)\@!', 'cn' )[0]
  let hostLn = searchpos( '^\(private\s\(lazy\s\)\?\)\?def\s\(e\d_\)\@!', 'cn' )[0]
  let hostDecName = matchstr( getline(hostLn ), '\vdef\s\zs\i*\ze(\:)?\s' )
  let strInParan = matchstr( getline(hostLn ), '\v\(\zs.{-}\ze\)' )
  " let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
  " echo paramNames
  " let fn_txt = len( [] ) == 0 ? hostDecName : hostDecName . ' ' . strInParan
  " let fn_txt = hostDecName . ' ' . strInParan
  let fn_txt = ''
  let lines = ['/**', ' * ' . fn_txt, ' */']
  call append( '.', lines )
  normal jjlll
endfunc


" trait Node {
"  def id: String
" } 

" trait Node:
"  def id: String

" div (
"   children <-- userElementsStream
" )

nnoremap <silent><leader>eba :call CreateScala_fewerBraces_a()<cr>

func! CreateScala_fewerBraces_a()
  let [oLine1, oCol1] = getpos('.')[1:2]
  normal! $
  let [oLine, oCol] = getpos('.')[1:2]
  normal! %xx
  call setpos('.', [0, oLine, oCol, 0] )
  let line = getline('.')
  if line =~ ' for '
    normal! x
  elseif line =~ ' = '
    normal! x
  elseif line =~ ' match '
    normal! x
  elseif line =~ ' yield '
    normal! x
  elseif line =~ ' => '
    normal! x
  else
    normal x$lr:
  endif
  call setpos('.', [0, oLine1, oCol1, 0] )
endfunc

  " ).implements[Node]{ case x: Person => x }


" Move an "end of the line" comma to indented new/ next line, or do nothing.
func! CreateScala_moveCommaToNextLine()
  let [oLine1, oCol1] = getpos('.')[1:2]
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  normal! $
  let [cLine, cCol] = searchpos('\v(\,)', 'cb')
  if cLine == oLine1
    if cCol + 2 > len( getline('.') ) 
      call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
    endif
  endif
  call setpos('.', [0, oLine1, oCol1, 0] )
endfunc


    " findAllActors.transact(xa)

nnoremap <silent><leader>em :call CreateScala_moveDotToNextLine()<cr>

func! CreateScala_moveDotToNextLine()
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  normal l
  call search('\v\.\i', 'cW')
  call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
  normal ^j
endfunc


  " val countAspect: Aspect[Database, Int, IOs] = 
  " def example(db: Database): Int < IOs =


nnoremap <silent><leader>eI :call CreateScala_moveSignatureToNextLine()<cr>

func! CreateScala_moveSignatureToNextLine()
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  normal $
  call search('\v\:\zs\s', 'cb')
  call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
  normal ^j
  call InsertStringAtLoc(' ', line('.'), col('.')-2)
endfunc


  " val stringToTE1Layer = Aborts[String].layer(str => Aborts[TestError1].fail(TestError1(str)))

nnoremap <silent><leader>e= :call CreateScala_moveTermToNextLine()<cr>

func! CreateScala_moveTermToNextLine()
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  normal l
  " call search('\v\=(\>)?\zs\s', 'cW')
  call search('\v\=\zs\s', 'cW')
  call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
  normal ^j
  call InsertStringAtLoc(' ', line('.'), col('.')-2)
endfunc


nnoremap <silent><leader>e> :call CreateScala_moveFnBodyToNextLine()<cr>

func! CreateScala_moveFnBodyToNextLine()
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  normal l
  call search('\v\=(\>)?\zs\s', 'cW')
  call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
  normal ^j
  call InsertStringAtLoc(' ', line('.'), col('.')-2)
endfunc



" def findActorsByName(initialLetter: String): IO[List[Actor]] = {

nnoremap <silent><leader>e( :call CreateScala_moveSingleMethodParamToNextLine()<cr>

func! CreateScala_moveSingleMethodParamToNextLine()
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  normal l
  call search('\v\(', 'cW')
  call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
  normal ^j
  call InsertStringAtLoc('  ', line('.'), col('.')-2)
endfunc



  " builder[IO, Int]{ (fb: FieldBuilder[IO, Int]) => fb },
  " <-- tickStream.mapTo(scala.util.Random.nextInt() % 100)

nnoremap <silent><leader>ebb :call CreateScala_fewerBraces_b()<cr>

func! CreateScala_fewerBraces_b()
  call CreateScala_moveCommaToNextLine()
  let [oLine1, oCol1] = getpos('.')[1:2]
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  call search('\v(\{|\()', 'c')
  " normal f{
  let [oLine, oCol] = getpos('.')[1:2]
  " call feedkeys("r\n", 'n')
  normal %x
  call setpos('.', [0, oLine, oCol, 0] )
  call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
  normal! ^j
  " call search('\v(\}|\))', 'c')
  normal! ^x
  call InsertStringAtLoc('  ', line('.'), col('.')-2)
  call setpos('.', [0, oLine, oCol, 0] )
  normal! r:
  call setpos('.', [0, oLine1, oCol1, 0] )
  " this is to avoid a jump in column when immediately going up or down.
  normal lh
endfunc
         " ab
" len(matchstr( getline(66), '\s*\ze\S'))


  " builder[IO, Int]{ (fb: FieldBuilder[IO, Int]) =>
  "   fb
  " }

  " input.withSelf { self =>

nnoremap <silent><leader>ebc :call CreateScala_fewerBraces_c()<cr>

func! CreateScala_fewerBraces_c()
  let [oLine1, oCol1] = getpos('.')[1:2]
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  call search('\v(\{|\()', 'c')
  let [oLine2, oCol2] = getpos('.')[1:2]
  call BreakLineAtLoc( indentStr, line('.'), col('.')-2)
  normal! j^
  let [oLine, oCol] = getpos('.')[1:2]
  normal! %x
  call setpos('.', [0, oLine, oCol, 0] )
  normal! x
  call InsertStringAtLoc(' ', line('.'), col('.')-2)
  normal j==
  call setpos('.', [0, oLine2, oCol2, 0] )
  normal $lr:
  call setpos('.', [0, oLine1, oCol1, 0] )
endfunc


" ─   typescript                                        ──

    " data.map(x => { return {v: JSON.stringify(x)} })
    " data.map(x => { return {v: JSON.stringify(x)}; }));

func! CreateJS_fewerBraces_c()
  let [oLine1, oCol1] = getpos('.')[1:2]
  let indentStr = matchstr( getline('.'), '\s*\ze\S')
  call search('\v(\{|\()', 'c')
  let [oLine2, oCol2] = getpos('.')[1:2]
  call BreakLineAtLoc( indentStr . '  ', line('.'), col('.')-1)
  normal! j^
  call StripSemicolonLine( line('.') )
  let [oLine, oCol] = getpos('.')[1:2]
  " normal! %x
  " call setpos('.', [0, oLine, oCol, 0] )
  " normal! x
  " call InsertStringAtLoc(' ', line('.'), col('.')-2)
  " normal j==
  " call setpos('.', [0, oLine2, oCol2, 0] )
  " normal $lr:
  " call setpos('.', [0, oLine1, oCol1, 0] )
endfunc



func! CreateJSDocComment_long()
  " let hostLn = searchpos( '^(export\s)?const\s\(e\d_\)\@!', 'cn' )[0]
  let hostLn = searchpos( '^\(export\s\(async\s\)\?\)\?const\s\(e\d_\)\@!', 'cn' )[0]
  let hostDecName = matchstr( getline(hostLn ), '\vconst\s\zs\i*\ze(\:)?\s' )
  let strInParan = matchstr( getline(hostLn ), '\v\(\zs.{-}\ze\)' )
  " let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
  " echo paramNames
  " let fn_txt = len( [] ) == 0 ? hostDecName : hostDecName . ' ' . strInParan
  let fn_txt = hostDecName . ' ' . strInParan
  let lines = ['/**', '* ' . fn_txt, '*/']
  call append( '.', lines )
  normal jjww
endfunc

func! CreateJSDocComment_short()
  let hostLn = searchpos( '^const\s\(e\d_\)\@!', 'cn' )[0]
  let hostDecName = matchstr( getline(hostLn ), '\vconst\s\zs\i*\ze\s' )
  let strInParan = matchstr( getline(hostLn ), '\v\(\zs.{-}\ze\)' )
  " let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
  " echo paramNames
  " let fn_txt = len( [] ) == 0 ? hostDecName : hostDecName . ' ' . strInParan
  let fn_txt = hostDecName . ' ' . strInParan
  let lines = ['/** ' . fn_txt . ' */']
  call append( line('.')-1, lines )
  normal kw
endfunc

nnoremap <silent> <leader>er :call CreateIndexedDec_js(v:false)<cr>
nnoremap <silent> <leader>eR :call CreateIndexedDec_js(v:true)<cr>

func! CreateIndexedDec_js( specialMaintainedVar )
  " const greeter = (person: Person) => {
  let hostLn1 = searchpos( '^const\s\([e|a]\d_\)\@!', 'cnb' )[0]
  " function selRegion (subStr: string) {
  let hostLn2 = searchpos( '\v^(async\s)?function', 'cnb' )[0]
  if hostLn1 > hostLn2
    let hostLn = hostLn1
    let hostDecName = matchstr( getline(hostLn ), '\vconst\s\zs\i*' )
  else
    let hostLn = hostLn2
    let hostDecName = matchstr( getline(hostLn ), '\vfunction\s\zs\i*' )
  endif
  let nextIndex = GetNextTestDeclIndex( hostLn )
  if a:specialMaintainedVar
    let lineText = 'const a' . nextIndex . '_' . hostDecName . ' = ' . hostDecName
  else
    let lineText = 'const e' . nextIndex . '_' . hostDecName . ' = ' . hostDecName
  endif
  call append( line('.') -1, lineText )
  normal kwww
endfunc

" nnoremap <silent> <leader>et :call CreateInlineTestDec()<cr>
" nnoremap <silent> <leader>eT :call CreateInlineTestDec_js_function()<cr>

func! CreateInlineTestDec()
  if &filetype == 'python'
    call CreateInlineTestDec_py()
  elseif &filetype == 'purescript'
    call CreateInlineTestDec_hs()
  else
    call CreateInlineTestDec_js('normal')
  endif
endfun



func! CreateInlineTestDec_rescript ()
  " const greeter = (person: Person) => {
    let hostLn = searchpos( '^let\s\(e\d_\)\@!', 'cnb' )[0]
    let hostDecName = matchstr( getline(hostLn ), '\vlet\s\zs\i*\ze\W' )

    " if getline(hostLn) =~ '\:.*='
    if getline(hostLn) =~ '\:'
      let lineText = hostDecName
    else
      " let add = (a, b) => a + b
      let strInParan = matchstr( getline(hostLn ), '\v\(\zs.{-}\ze\)' )
      if strInParan == ''
        " let greetMore = name => {
          let strInParan = matchstr( getline(hostLn ), '\v\=\zs.{-}\ze\=>' )
        endif

        let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
        let paramNames = substitute( paramNames, "'", '"', 'g')
        if len( paramNames ) > 2
          let lineText = hostDecName . '(' . paramNames[1:-2] . ')'
        else
          let lineText = hostDecName
        endif
      endif
        let nextIndex = GetNextTestDeclIndex( hostLn )
        let lineText = 'let e' . nextIndex . '_' . hostDecName . ' = ' . lineText
      call append( '.', lineText )
      " call search('(')
      normal dd
      normal ^www
endfunc


func! CreateInlineTestDec_js(mode)
  " const greeter = (person: Person) => {

  let hostLn1 = searchpos( '^const\s\w\(e\d_\)\@!', 'cnbW' )[0]
  let hostLn2 = searchpos( '^export\sconst\s\(e\d_\)\@!', 'cnbW' )[0]
" export async function runExample(): Promise<EvalResult<string, string>[]> {
  let hostLn3 = searchpos( '\v^(export\s)?(async\s)?function', 'cnbW' )[0]

  " echo( [hostLn1, hostLn2, hostLn3] )
  let hostLn = max( [hostLn1, hostLn2, hostLn3] )
  let hostDecName = matchstr( getline(hostLn ), '\v(const|function)\s\zs\i*\ze\W' )

  " echo hostDecName
  " return

  " if hostLn1 > hostLn2
  "   let hostLn = hostLn1
  "   " let hostDecName = matchstr( getline(hostLn ), '\vconst\s\zs\i*\ze\s' )
  "   let hostDecName = matchstr( getline(hostLn ), '\vconst\s\zs\i*\ze\W' )
  " else
  "   let hostLn = hostLn2
  "   let hostDecName = matchstr( getline(hostLn ), '\vfunction\s\zs\i*\ze\s' )
  " endif

  let strInParan = matchstr( getline(hostLn ), '\v\(\zs.*\ze\)' )
  let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
  " let lineText = hostDecName . '(' . paramNames[1:-2] . ')'
  let lineText = hostDecName
  " TODO: this doesn't work
  let nextIndex = GetNextTestDeclIndex( hostLn )
  if a:mode == 'async'
    let lineText = 'export const e' . nextIndex . '_' . hostDecName . ' = async () => ' . lineText
  else
    let lineText = 'export const e' . nextIndex . '_' . hostDecName . ' = () => ' . lineText
  endif
  call append( '.', lineText )
  normal dd
  normal $b
endfunc
" Tests:
" def mult(aa, bb):
"   return aa * bb
" e1_mult = mult('aa', 'bb')

func! CreateInlineTestDec_js_function()
  let hostLn = searchpos( 'function\s', 'cnb' )[0]
  let hostDecName = matchstr( getline( hostLn ), 'function\s\zs\i*' )
  let strInParan = matchstr( getline(hostLn ), '\v\(\zs.{-}\ze\)' )
  let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
  let lineText = hostDecName . '(' . paramNames[1:-2] . ')'
  let nextIndex = GetNextTestDeclIndex( hostLn )
  let lineText = 'const e' . nextIndex . '_' . hostDecName . ' = ' . lineText
  call append( line('.') -1, lineText )
  normal k0
  call search('(')
  normal l
endfunc

" export const e1_nvim_m = () => v(async (v) => {

func! CreateInlineTestDec_js_nvim()
  let hostLn = searchpos( 'function\s', 'cnb' )[0]
  let hostDecName = matchstr( getline( hostLn ), 'function\s\zs\i*' )
  let strInParan = matchstr( getline(hostLn ), '\v\(\zs.{-}\ze\)' )
  let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
  let lineText = hostDecName . '(' . paramNames[1:-2] . ')'
  let nextIndex = GetNextTestDeclIndex( hostLn )
  let lineText = 'export const e' . nextIndex . '_' . hostDecName . ' = () => v(async (nvim) => {'
  call append( line('.') -1, lineText )
  call append( line('.') -1, "  await note(nvim, 'ab1')" )
  call append( line('.') -1, '})' )
  normal kkw
  " call search('(')
  " normal l
endfunc


func! CreateInlineTestDec_scala1()
  let hostLn1 = searchpos( 'def\s\w\(e\d_\)\@!', 'cnbW' )[0]
  let hostLn2 = searchpos( '^val\s\(e\d_\)\@!', 'cnbW' )[0]
  let hostLn3 = searchpos( '^object\s\(e\d_\)\@!', 'cnbW' )[0]

  let hostLn = max( [hostLn1, hostLn2] )

  let hostDecName = matchstr( getline( hostLn ), '\v(object|def|val)\s\zs\i*' )
  let strInParan = matchstr( getline(hostLn ), '\v\(\zs.{-}\ze\)' )
  let strInParan = substitute( strInParan, ':', ' =', 'g')
  let strInParan = substitute( strInParan, 'String', '""', 'g')
  let strInParan = substitute( strInParan, 'Int', '0', 'g')
  " let paramNames = string( SubstituteInLines( split( strInParan, ',' ), '\s', '' ) )
  " let lineText = hostDecName . '(' . strInParan[0:-1] . ')'
  let lineText = hostDecName
  let nextIndex = GetNextTestDeclIndex( hostLn )
  let lineText = 'lazy val e' . nextIndex . '_' . hostDecName . ' = ' . lineText
  call append( line('.') -1, lineText )
  normal k0
  " call search('(')
  normal $B
endfunc

func! CreateInlineTestDec_scala()
  let hostLn = searchpos( '\v^(inline|val|lazy val|def|object|trait|enum|case\sclass)', 'cnbW' )[0]

  let hostDecName = matchstr( getline( hostLn ), '\v(val|def|object|trait|enum|case\sclass)\s\zs\i*' )
  let lineText = hostDecName
  let nextIndex = GetNextTestDeclIndex( hostLn )
  let lineText = 'lazy val e' . nextIndex . '_' . hostDecName . ' = ' . lineText
  call append( line('.') -1, lineText )
  normal k0
  normal $B
endfunc

func! CreateInlineTestDec_indent_scala()
  " let hostLn = searchpos( '\v^\s\s(inline|val|def|object|trait|enum|case\sclass)', 'cnbW' )[0]
  let hostLn = searchpos( '\v^\s\s(inline|val|def|object|trait|enum|case\sclass)\s(e\d_)@!', 'cnbW' )[0]

  let hostDecName = matchstr( getline( hostLn ), '\v(val|def|object|trait|enum|case\sclass)\s\zs\i*' )
  let lineText = hostDecName
  let nextIndex = GetNextTestDeclIndex( hostLn )
  let lineText = "  val e" . nextIndex . '_' . hostDecName . ' = ' . lineText
  call append( line('.') -1, lineText )
  normal k0
  normal $B
endfunc


" e1_database4 = database4 (Just "eins") 123
func! CreateInlineTestDec_hs()
  let typeSigLineNum = TopLevTypeSigBackwLineNum()
  let funcName       = GetTopLevSymbolName( typeSigLineNum )
  let argumentTypesList = HsExtractArgTypesFromTypeSigStr( getline( typeSigLineNum ) )
  let argumentTypesList = HsAddTypeVarsToAllArgTypes( argumentTypesList )
  let nextIndex = GetNextTestDeclIndex(typeSigLineNum)
  let lineText = 'e' . nextIndex . '_' . funcName . ' = ' . funcName . ' ' . ArgsPlacehoderStr( argumentTypesList )
  call append( line('.') -1, lineText )
  normal k^ww
endfunc
" Tests:
" intStr :: Int -> String
" intStr i = show i
" Will produce
" e1_intStr = intStr (i:: Int)

func! GetNextTestDeclIndex( fn_linenum )
  " let lineNumPrevInlineTestDec = InlineTestDeclBackwLine()
  let lineNumPrevInlineTestDec = searchpos( '\v(const\s|val\s|let\s)=[e|a]\d_', 'cnbW')[0]
  let thereIsAPrevTestDecl = lineNumPrevInlineTestDec > a:fn_linenum
  if thereIsAPrevTestDecl
    return 1 + eval( GetTestDeclIndex( lineNumPrevInlineTestDec ) )
  else
    return 1
  endif
endfunc
" database2 ∷ String → [(String, String, Int)]
" e3_database4 = database4 (Just "eins") 123
" echo GetNextTestDeclIndex()


" nnoremap <silent> <leader>ea :call CreateAssertion()<cr>
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
  " return searchpos( '\v^e\d_', 'cnbW')[0]
  return searchpos( '\v(const\s|let\s)=[e|a]\d_', 'cnbW')[0]
endfunc
" InlineTestDeclBackwLine()

func! InlineTestAssertionBackwLine()
  return searchpos( '\v^a\d\d_', 'cnbW')[0]
endfunc
" echo TopLevBackwLine()

func! GetTestDeclIndex( lineNum )
  " return matchstr( getline(a:lineNum), '^e\zs\d\ze_')
  return matchstr( getline(a:lineNum), '\v(const\s|let\s)=[e|a]\zs\d\ze_')
endfunc

" echo GetTestDeclIndex( line('.') +1 )
" let e2_database4 = database4 Nothing 99
" e3_database4 = database4 Nothing 99

func! GetAssertionIndex( lineNum )
  return matchstr( getline(a:lineNum), '^a\zs\d\d\ze_')
endfunc
" echo GetAssertionIndex( line('.') +2 )
" echo 10 + eval( GetAssertionIndex( line('.') +1 ) )
" a14_database4 = id e1_database4 == (i∷ [(String, Int)])


" ─   "unique functions"                                 ■
nnoremap <silent> <leader>eu ^icb<esc>:call RandFnName()<cr>A = u<esc>^2w
nnoremap <silent> <leader>eU ^icb<esc>:call RandSymbol()<cr>A :: String<esc>^ywo<esc>PA= u<esc>^2w
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
" nnoremap <leader>es :call Stubs_ExpandATypeSign()<cr>
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
" nnoremap <leader>eb :call Stubs_ExpandTermLevelFromTypeSign()<cr>
" Issue: this produces doublicate var names. use  ~/Documents/Haskell/6/HsTrainingTypeClasses1/src/Exercises.hs#/indexDoublicateNames%20..%20[String]

func! Stubs_ExpandTermLevelFromTypeSign()
  let symbName = GetTopLevSymbolName( line('.') )
  let argTypes = HsExtractArgTypesFromTypeSigStr( getline( line('.') ) )
  let argTypesStr = join( ArgTypesToSuggestedArgNames( argTypes ), ' ' )
  let indentChars = repeat( ' ', col('.')-1)
  let lineText = indentChars . symbName . ' ' . argTypesStr . ' = i'
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
    let listShorts = functional#map( 'AbbrevSimpleType', SplitArgs( RemoveBraces( a:type ) ) )
    return 'f' . join( listShorts, '_' )
  elseif a:type =~ '[' " note there may be a list within the type
    " return 'l' . AbbrevSimpleType( RemoveBraces( a:type ) )
    return AbbrevSimpleType( RemoveBraces( a:type ) ) . 's'
  elseif a:type =~ '('
    let listShorts = functional#map( 'AbbrevSimpleType', SplitArgs( RemoveBraces( a:type ) ) )
    return 't' . join( listShorts, '_' )
  else
    return AbbrevSimpleType( RemoveBraces( a:type ) )
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

func! RemoveBraces( str )
  return substitute( a:str, '\v(\(|\)|\[|\])', '', 'g')
endfunc
" echo RemoveBraces('(a -> Maybe cd)')
" echo RemoveBraces('[Maybe cd]')
" echo RemoveBraces('(Int, a)')

func! RemoveSpaces( str )
  return substitute( a:str, '\s', '', 'g')
endfunc

func! RemoveSemicolon( str )
  return substitute( a:str, '\;', '', 'g')
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


nnoremap <silent> <leader>uef <leader>us<leader>ef
" Test stub:
" nmap <leader>ts <leader>us<leader>ef
nmap <leader>hfs :call RandSymbol()<cr>A :: String<esc>^ywo<esc>PA= undefined<esc>wdx0rq0

" "index symbol" append postfix index to function name
nnoremap <silent> <leader>eai ea0^jea0^k
" nnoremap <silent> <leader>his ea0^jea0^k

" Increase/ decrease the index of TypeSig and term level binding together
nnoremap <silent> <leader><c-a> jk^
nnoremap <silent> <leader><c-x> <c-x>j<c-x>k^


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


