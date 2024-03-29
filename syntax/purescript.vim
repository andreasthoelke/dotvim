" uyntax highlighting for purescript
"
" Heavily modified version of the purescript syntax
" highlighter to support purescript.
"
" author: raichoo (raichoo@googlemail.com)

if exists("b:current_syntax")
  finish
endif

" Values:
" syn match purescriptIdentifier "\<[_a-z]\(\w\|\'\)*\>"
syn match purescriptIdentifier "[_a-z]\(\w\|\'\)*"
" issue: _2  and  (_+10) need to be highlighted as identifier and number
syn match purescriptNumber "0[xX][0-9a-fA-F]\+\|0[oO][0-7]\|[0-9]\+"
" syn match purescriptNumber "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>\|\<0[bB][10]\+\>"
syn match purescriptFloat "[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\="
syn keyword purescriptBoolean true false
syn keyword purescriptState state

" syn match purescriptStateKey "\vstate\.\zs\w{-}\ze\_s"
" again, above line does not match - resorting to a matchadd
" TODO this doesn't match either?!
call matchadd('purescriptStateKey', '\vstate\.\zs\w{-}\ze(\W|\_s)', -1, -1 )

" Delimiters:
syn match purescriptDelimiter "[,;|.()[\]{}]"

" Type:
" syn match purescriptType "\%(\<class\s\+\)\@15<!\<\u\w*\>" contained
"   \ containedin=purescriptTypeAlias
"   \ nextgroup=purescriptType,purescriptTypeVar skipwhite
" Note: changed this! from the above
syn match purescriptType "\<[_A-Z]\(\w\|\'\)*\>" contained contains=hsInteger
      \ containedin=purescriptData,purescriptNewtype,purescriptTypeAlias,purescriptFunctionDecl
syn match purescriptTypeVar "\<[_a-z]\(\w\|\'\)*\>" contained
  \ containedin=purescriptClassDecl,purescriptData,purescriptNewtype,purescriptTypeAlias,purescriptFunctionDecl
syn region purescriptTypeExport matchgroup=purescriptType start="\<[A-Z]\(\S\&[^,.]\)*\>("rs=e-1 matchgroup=purescriptDelimiter end=")" contained extend
  \ contains=hsArrow,hsInteger,purescriptConstructor,purescriptDelimiter

syn match hsTypeComment "\<[_A-Z]\(\w\|\'\)*\>" contained
      \ containedin=hsFunctionDeclComment
syn match hsTypeVarComment "\<[_a-z]\(\w\|\'\)*\>" contained
      \ containedin=hsFunctionDeclComment

" Records:
syn match purescriptRecordKeys "\v\W\w{-}\ze\:\s"
syn match purescriptRecordKeys "\v\W\zs\w{-}\ze\s\:\:\s" contains=hsForall
" syn match purescriptRecordKeys "\v[{,].{-}\zs\w{-}\ze\s::"
" TODO this does not match?!
syn match purescriptIdentifierDot1 "\v\s\zs\w{-}\ze\.\w"
syn match purescriptLens1 "\v\s\zs_\w{-}\ze(\W|\_s)"
" highlight def link purescriptIdentifierDot1 purescriptIdentifier
" syn match purescriptIdentifierDot2 "\v\.\zs\w{-}\ze\s"
" could not get the above line to match RB.[json] this code:
" , content: RB.json <$> body
" so resorting to a matchadd
" TODO - does this actually work - as matchadd takes a highlight group!
" call matchadd('purescriptIdentifier', '\v\.\zs\w{-}\ze\_s', -1, -1 )
"  "\_s" matches space OR newline!

" Constructor:
syn match purescriptConstructor "\%(\<class\s\+\)\@15<!\<\u\w*\>"
syn region purescriptConstructorDecl matchgroup=purescriptConstructor start="\<[A-Z]\w*\>" end="\(|\|$\)"me=e-1,re=e-1 contained
  \ containedin=purescriptData,purescriptNewtype
  \ contains=hsTypeColon,purescriptType,purescriptTypeVar,purescriptDelimiter,purescriptOperatorType,purescriptOperatorTypeSig,@purescriptComment



" Function:
" syn match purescriptFunction "\%(\<instance\s\+\|\<class\s\+\)\@18<!\<[_a-z]\(\w\|\'\)*\>" contained
" note: uncommented this! -> hsMainSig
" syn match purescriptFunction "\%(\<instance\s\+\|\<class\s\+\)\@18<!\<[_a-z]\k*'\?" contained
" syn match purescriptFunction "\<[_a-z]\(\w\|\'\)*\>" contained
" syn match purescriptFunction "(\%(\<class\s\+\)\@18<!\(\W\&[^(),\"]\)\+)" contained extend

" Class:
syn region purescriptClassDecl start="^\%(\s*\)class\>"ms=e-5 end="\<where\>\|$"
  \ contains=hsArrow,hsTypeColon,hsConstraintArrow,hsConstraintArrowBackw,purescriptClass,purescriptClassName,purescriptDelimiter,purescriptOperatorTypeSig,purescriptOperatorType,purescriptOperator,purescriptType,purescriptWhere
  \ nextgroup=purescriptClass
  \ skipnl
syn match purescriptClass "\<class\>" containedin=purescriptClassDecl contained
  \ nextgroup=purescriptClassName
  \ skipnl
syn match purescriptClassName "\<[A-Z]\w*\>" containedin=purescriptClassDecl contained

" Module:
syn match purescriptModuleName "\(\u\w\*\.\?\)*" contained excludenl
syn match purescriptModuleKeyword "\<module\>"
syn match purescriptModule "^module\>\s\+\<\(\w\+\.\?\)*\>"
  \ contains=purescriptModuleKeyword,purescriptModuleName
  \ nextgroup=purescriptModuleParams
  \ skipwhite
  \ skipnl
  \ skipempty
syn region purescriptModuleParams start="(" skip="([^)]\{-})" end=")" fold contained keepend
  \ contains=purescriptClassDecl,purescriptClass,purescriptClassName,purescriptDelimiter,purescriptType,purescriptTypeExport,purescriptStructure,purescriptModuleKeyword,@purescriptComment
  \ nextgroup=purescriptImportParams skipwhite

" Import:
syn match purescriptImportKeyword "\<\(foreign\|import\|qualified\)\>"
syn match purescriptImport "\<import\>\s\+\(qualified\s\+\)\?\<\(\w\+\.\?\)*"
  \ contains=purescriptImportKeyword,purescriptModuleName
  \ nextgroup=purescriptImportParams,purescriptImportAs,purescriptImportHiding
  \ skipwhite
syn region purescriptImportParams
  \ start="("
  \ skip="([^)]\{-})"
  \ end=")"
  \ contained
  \ contains=purescriptClass,purescriptClass,purescriptStructure,purescriptType,purescriptIdentifier
  \ nextgroup=purescriptImportAs
  \ skipwhite
syn keyword purescriptAsKeyword as contained
syn match purescriptImportAs "\<as\>\_s\+\u\w*"
  \ contains=purescriptAsKeyword,purescriptModuleName
  \ nextgroup=purescriptModuleName
syn keyword purescriptHidingKeyword hiding contained
syn match purescriptImportHiding "hiding"
  \ contained
  \ contains=purescriptHidingKeyword
  \ nextgroup=purescriptImportParams
  \ skipwhite


" now supports operators: 'syn region purescriptFunctionDecl'
" like (>>) :: Monad m => m a -> m b -> m b
" \ excludenl start="^\z(\s*\)\(\(foreign\s\+import\)\_s\+\)\?[_a-z]\(\w\|\'\)*\_s\{-}\(::\|∷\)"
" ^\(\s*\)\(\(foreign\s\+import\)\_s\+\)\?\(\S\|\'\)*\_s\{-}\(::\|∷\)


" syn match hsMainSig "^[_a-z]\(\w\|\'\)*\s\::\s" conceal containedin=purescriptFunction
syn match hsMainSig "^[_a-z]\(\w\|\'\)*\s\::\s" conceal containedin=purescriptFunctionDeclStart
syn match hsSubSig "^\s*\zs[_a-z]\(\w\|\'\)*\s\::\s" conceal containedin=purescriptFunctionDeclStart

syn match hsForall "forall.*\w\.\s" conceal containedin=purescriptFunctionDeclStart

" todo: this needs a negative lookaround(?) to avoid matching on aa f {a = 11}
syn match hsTopLevelBind "\v^[_a-z](\w|\'){-}\ze\s.{-}\=\_s"
syn match hsTopLevelBind "\v^\s*\zs[_a-z](\w|\'){-}\ze\s.{-}\=\_s"

" Function declaration:
syn region purescriptFunctionDecl
  \ excludenl start="^\z(\s*\)\(\(foreign\s\+import\)\_s\+\)\?\(\S\|\'\)*\_s\{-}\(::\|∷\)"
  \ end="^\z1\=\S"me=s-1,re=s-1 keepend
  \ contains=concealedTLbindType,hsInteger,hsForall,hsArrow,hsArrowBackw,hsConstraintArrow,hsTypeColon,purescriptFunctionDeclStart,purescriptForall,purescriptOperatorType, purescriptOperator, purescriptOperatorTypeSig,purescriptType,purescriptTypeVar,purescriptDelimiter,@purescriptComment
syn region purescriptFunctionDecl
  \ excludenl start="^\z(\s*\)where\z(\s\+\)[_a-z]\(\w\|\'\)*\_s\{-}\(::\|∷\)"
  \ end="^\(\z1\s\{5}\z2\)\=\S"me=s-1,re=s-1 keepend
  \ contains=purescriptFunctionDeclStart,purescriptForall,purescriptOperatorType,purescriptOperatorTypeSig,purescriptType,purescriptTypeVar,purescriptDelimiter,@purescriptComment
syn region purescriptFunctionDecl
  \ excludenl start="^\z(\s*\)let\z(\s\+\)[_a-z]\(\w\|\'\)*\_s\{-}\(::\|∷\)"
  \ end="^\(\z1\s\{3}\z2\)\=\S"me=s-1,re=s-1 keepend
  \ contains=hsInteger,hsArrow,purescriptFunctionDeclStart,purescriptForall,purescriptOperatorType,purescriptOperatorTypeSig,purescriptType,purescriptTypeVar,purescriptDelimiter,@purescriptComment
syn match purescriptFunctionDeclStart "^\s*\(\(foreign\s\+import\|let\|where\)\_s\+\)\?\([_a-z]\(\w\|\'\)*\)\_s\{-}\(::\|∷\)" contained
  \ contains=hsInteger,hsTypeColon,hsArrow,purescriptImportKeyword,purescriptWhere,purescriptLet,purescriptFunction,purescriptOperatorType
" syn keyword purescriptForall forall
" syn match purescriptForall "∀"

syn region hsFunctionDeclComment
      \ excludenl start="\(::\|∷\)"
      \ end="$"me=s-1,re=s-1 keepend contains=hsConstraintArrow,hsTypeColon,hsArrow,hsTypeVarComment,hsTypeComment

" Keywords:
" syn keyword purescriptConditional if iF then else
" syn keyword purescriptConditional if iF
" syn keyword purescriptStatement do in ado
" syn keyword purescriptLet let
" syn keyword purescriptWhere where
syn match purescriptStructure "\<\(data\|newtype\|type\|kind\)\>"
  \ nextgroup=purescriptType skipwhite
syn keyword purescriptStructure derive
syn keyword purescriptStructure instance
  \ nextgroup=purescriptFunction skipwhite

" Highlight the FnWireframe navigation spots
syn keyword fnWireframe where do let otherwise in
" Infix
syn match purescriptInfixKeyword "\<\(infix\|infixl\|infixr\)\>"
syn match purescriptInfix "^\(infix\|infixl\|infixr\)\>\s\+\([0-9]\+\)\s\+\(type\s\+\)\?\(\S\+\)\s\+as\>"
  \ contains=purescriptInfixKeyword,purescriptNumber,purescriptAsKeyword,purescriptConstructor,purescriptStructure,purescriptFunction,purescriptBlockComment
  \ nextgroup=purescriptFunction,purescriptOperator,@purescriptComment

" Operators:
syn match purescriptOperator "\([-!#$%&\*\+/<=>\?@\\^|~:]\|\<_\>\)"
syn match purescriptOperatorType "\%(\<instance\>.*\)\@40<!\(::\|∷\)"
  \ nextgroup=purescriptForall,purescriptType skipwhite skipnl skipempty
syn match purescriptOperatorFunction "\(->\|<-\|[\\→←]\)"
syn match purescriptOperatorTypeSig "\(->\|<-\|=>\|<=\|::\|[∷∀→←⇒⇐]\)" contained
  \ nextgroup=purescriptType skipwhite skipnl skipempty

" syn match purescriptRecordColon "\v\zs\:\ze\s"
" again, I could not get the above line to match - using a matchadd instead
" call matchadd('purescriptColon', '\v\zs\:\ze\s', -1, -1 )
" call matchadd('MatchParen', '\v\s\w{-}\zs\:\ze\s', -1, -1 )
" call matchadd('MatchParen', '\v\s\w{-}\zs\:\ze', -1, -1 )
" call clearmatches()

" Type definition:
syn region purescriptData start="^data\s\+\([A-Z]\w*\)" end="^\S"me=s-1,re=s-1 transparent
syn match purescriptDataStart "^data\s\+\([A-Z]\w*\)" contained
  \ containedin=purescriptData
  \ contains=purescriptStructure,purescriptType,purescriptTypeVar
syn match purescriptForeignData "\<foreign\s\+import\s\+data\>"
  \ contains=purescriptImportKeyword,purescriptStructure
  \ nextgroup=purescriptType skipwhite

syn region purescriptNewtype start="^newtype\s\+\([A-Z]\w*\)" end="^\S"me=s-1,re=s-1 transparent
syn match purescriptNewtypeStart "^newtype\s\+\([A-Z]\w*\)" contained
  \ containedin=purescriptNewtype
  \ contains=purescriptStructure,purescriptType,purescriptTypeVar

syn region purescriptTypeAlias start="^type\s\+\([A-Z]\w*\)" end="^\S"me=s-1,re=s-1 transparent
syn match purescriptTypeAliasStart "^type\s\+\([A-Z]\w*\)" contained
  \ containedin=purescriptTypeAlias
  \ contains=purescriptStructure,purescriptType,purescriptTypeVar

" String:
syn match purescriptChar "'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'"
syn region purescriptString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell
syn region purescriptMultilineString start=+"""+ end=+"""+ fold contains=@Spell

" Marked infix:
" syn match purescriptBacktick "`[_A-Za-z][A-Za-z0-9_\.]*`"

" syn region infixBacktick start="`[_A-Za-z][A-Za-z0-9_\.]" end="[_A-Za-z]`" contains=infixBacktickTick,hsElem,abcd
syn match infixBacktickTick "`" conceal containedin=infixBacktick
" syn region markedInfix start=+\`+ end=+\`+ contains=@Spell,infixMarks,hsElem
" syn match Normal '`' conceal cchar=x contained
syn match hsElem "elem`" conceal cchar=∈ containedin=infixBacktick
syn match hsElemNot "notElem`" conceal cchar=∉ containedin=infixBacktick
" syn match hsCompForw "compForwBin`" conceal cchar=… containedin=infixBacktick
" syn match abcd "[_A-Za-z][A-Za-z0-9_\.]" containedin=infixBacktick
syn match infixBacktick "`[_A-Za-z][A-Za-z0-9_\.]*`" contains=infixBacktickTick,hsElem,hsElemNot,compForwBin
" Note: it was important to have this encompassing match *after* the included matches!!


        " \, ["^[_a-z]\(\w\|\'\)*\s\ze::",            '|', 'Normal']
" Tests:
" -- cbnb0 = `any` `eins` `elem` `test`
" Previous implementation
      " \, ['\`elem\`',         '∈', 'hsForall']
      " call matchadd('Conceal', '`', -1, -1, {'conceal': ''})


" Comment:
syn match purescriptLineComment "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$" contains=@Spell,concealedTLbindInComment,concealedCommentDashes,concealedTLbindTypeInComment,m4,mbr1,hsArrow,hsTypeColon,Normal,hsConstraintArrow
syn region purescriptBlockComment start="{-" end="-}" fold
  \ contains=purescriptBlockComment,@Spell
syn cluster purescriptComment contains=purescriptLineComment,purescriptBlockComment,@Spell

syn sync minlines=50



syntax match concealedCommentDashes '--\s' contained conceal
" syntax match concealedQuote '\s\zs"' contained conceal

syntax match concealedUndefinedType 'i::' conceal
syntax match concealedUndefinedType 'undefined::' conceal

syntax match concealedUndefinedType 'u:: forall a.' conceal


" ─   Conceal with unicode                               ■
        " \, ['forall\ze\s',       '∀', 'hsForall']

func! HsConcealWithUnicode ()

  let g:HsCharsToUnicode = [
        \  ['->',           '→', 'hsArrow']
        \, ['\s\zs<-',           '←', 'hsArrowBackw']
        \, ['\s\zs=>',           '⇒', 'hsConstraintArrow']
        \, ['\s\zs<=',           '⇐', 'hsConstraintArrowBackw']
        \, ['::',                '∷', 'hsTypeColon']
        \, ['\$',               '⦙', 'hsTypeColon']
        \, ['\s\zsUnit',         '◯', 'hsForall']
        \, ['\s\zsunit',         '○', 'hsForall']
        \, ['\\\%([^\\]\+\)\@=', 'λ', 'Normal']
        \, [' \zs\.\ze\_s',      '∘', 'Normal']
        \, ['<<<',      '∘', 'Normal']
        \, ['<\$>',          '⫩', 'Normal']
        \, ['<\$\ze\_s',          '◁', 'Normal']
        \, ['\s\zs\$>\ze\_s',     '▷', 'Normal']
        \, ['<\#>',          '⧕', 'Normal']
        \, [' \zs<\*>',          '⟐', 'Normal']
        \, [' \zs>>',            '≫', 'Normal']
        \, ['>>=\ze\_s',           '⫦', 'Normal']
        \, ['=<<',           '⫣', 'Normal']
        \, [' \zs-<',           '⩹', 'Normal']
        \, [' \zs\`flipElem\`',  '∋', 'Normal']
        \, [' \zs\`traverse_\`',  '≚', 'Normal']
        \, [' \zs\`traverse\`',  '≚', 'Normal']
        \, [' \zs<|>',           '‖', 'Normal']
        \, [' \zs>=>',           '↣', 'Normal']
        \, [' \zs<=<',           '↢', 'Normal']
        \, [' \zs<<<<\ze\s',      '…', 'Normal']
        \, ['\.\.',               '‥', 'Normal']
        \, [' \zs==',            '≡', 'Normal']
        \, ['==',            '≡', 'Normal']
        \, ['/=',            '≠', 'Normal']
        \, ['/=\ze ',            '≠', 'Normal']
        \, [' \zs<>',            '◇', 'Normal']
        \, ['<>',            '◇', 'Normal']
        \, ['pure\ze\s',        '⫐', 'Normal']
        \, ['subtract',        '-', 'Normal']
        \, ['flip\s',        '◖', 'Normal']
        \, ['map\s',        'ꜛ', 'Normal']
        \, ['fmap\s',        'ꜛ', 'Normal']
        \, ['lift\s',        '˄', 'Normal']
        \, ['liftEffect',        '▫', 'Normal']
        \, ['liftAff',        '•', 'Normal']
        \, ['void',        'ˍ', 'notInComment']
        \, ['bool\ze\s',        '?', 'Normal']
        \, ['if\s',        '⊺', 'notInComment']
        \, ['then\s',        '˼', 'notInComment']
        \, ['else\s',        '˼', 'notInComment']
        \, ['case\s',        '⌋', 'notInComment']
        \, ['\sof\_s',        ' ', 'notInComment']
        \, [' \zs\%[m]empty\ze(\W|\_s)',        '∅', 'notInComment']
        \, [' \zs++',            '⧺', 'Normal']
        \, ['<=\ze\s',            '≤', 'Normal']
        \, ['>=\ze ',            '≥', 'Normal']
        \, ['SProxy',       '▯', 'hsForall']
        \, ['SProxy :: SProxy',       '▯', 'hsForall']
        \, ['Integer',           'ℤ', 'hsInteger']
        \, ['Array\s',           '⟦', 'hsInteger']
        \, ['List\s',           '❲', 'hsInteger']
        \, ['Boolean',           '∪', 'hsInteger']
        \, ['Tuple\s',           'T', 'hsInteger']
        \, ['/\\',            '|', 'Normal']
        \]

  " \, [' \zs<|>',           '⦶', 'Normal']
  " \, [' \zs<|>',           '‖', 'Normal']
  " ε
  " \, ['<\#>',          '≚', 'Normal']
  " \, [' \zs/\\',            '⨆', 'Normal']
        " \, [' \zs<<<\ze\s',      '∘', 'Normal']

" https://en.wikipedia.org/wiki/Mathematical_operators_and_symbols_in_Unicode

  " https://unicode-table.com/en/blocks/miscellaneous-mathematical-symbols-b/
  " Telescope symbols                  ⟫
" ⟨⟩ mathematical right/left                      ⌟  ⌋ ⌈
" ◁ • ▵ ⌃ ˄ ⌤ ⌃ ^ ˆ ▴ ▴ ▵ ◭ △ ▵ ◬ ◿ ⧍ ˩ ⌋ ⦙ ⫶⌉ | ┘ ┙˼ ⟟ ⎒ ⍑ ⍝ ⍡ ⁐ ⁍ ⁕ ⁎ • ▪ ▫ ᛫ ⍛ ▫ ■▪▮▯▰▱▴◗◿
" ⍨ ⎨⎛⎭⎵⏠‣ ‥ ⬜ ⬚ ⭕ ⎧⍿⥰ ⌄ ⅀ ≀ ⋆ ⍿ ⊺      ∼
" ⨀ ⪽ ⟐ ⦷ ⦵ ⦿ ⧁ ⌀ ⌀ ⌓ ⌯ ⌔ ● ◊ ◇ ◆ ◁ ⨞ ⭘ ⌸ ◫ ∧ ⋁ ⟑ ⨆      ≔
" s ⦙ <- note that these fancy symbols can seemingly not be pasted into Vim from the website - so I open this file in
" TextEdit and paste these symbols there
"    ■

  for [pttn, concealUnicodeSym, syntaxGroup] in g:HsCharsToUnicode
    exec 'syntax match ' . syntaxGroup .' "'. pttn .'" conceal cchar='. concealUnicodeSym
  endfor

endfunc

" Note: These IDs need to be included in the 'contains=' section of e.g. 'purescriptFunctionDecl', etc
" syntax match hsArrow                '\s\zs->' conceal cchar=→
" syntax match hsArrowBackw           '\s\zs<-' conceal cchar=←
" syntax match hsConstraintArrow      '\s\zs=>' conceal cchar=⇒
" syntax match hsConstraintArrowBackw '\s\zs<=' conceal cchar=⇐
" syntax match hsTypeColon            '::' conceal cchar=∷
" syntax match hsForall               '\s\zsforall' conceal cchar=∀
"
" " Tests:
" " zipThese :: forall a b. Num a => [a] -> [b] -> [These a b]
" " class Functor f => Align (f :: * -> *) where
"
" " Show lambda and conceal unicode characters
" " Issue Question: The highlight group does not seem to have an effect here - the Conceal group is used. Would ideally
" " like to color the conceal character differently.
" " syntax match Normal '\\\%([^\\]\+->\)\@=' conceal cchar=λ
" syntax match Normal '\\\%([^\\]\+\)\@=' conceal cchar=λ
" syntax match Normal ' \zs\.' conceal cchar=∘
" syntax match Normal ' \zs<\$>' conceal cchar=⫩
" syntax match Normal ' \zs<\*>' conceal cchar=⟐
" syntax match Normal ' \zs>>' conceal cchar=≫
" syntax match Normal ' \zs>>=' conceal cchar=⫦
" syntax match Normal ' \zs\`elem\`' conceal cchar=∈
" syntax match Normal ' \zs\`flipElem\`' conceal cchar=∋
" syntax match Normal ' \zs>=>' conceal cchar=↣
" syntax match Normal ' \zs<=<' conceal cchar=↢
" " syntax match Normal ' \zs==' conceal cchar=≡
" syntax match Normal '==\ze ' conceal cchar=≡
" " syntax match Normal ' \zs/=' conceal cchar=≠
" syntax match Normal '/=\ze ' conceal cchar=≠
" " To allow filter (== 4) [1,2]
" " syntax match Normal ' \zs<>' conceal cchar=◇
" syntax match Normal '<>\ze ' conceal cchar=◇
" syntax match Normal ' \zsmempty' conceal cchar=∅
" syntax match Normal ' \zs++' conceal cchar=⧺
" syntax match Normal ' \zs<=' conceal cchar=≤
" syntax match Normal ' \zs>=' conceal cchar=≥
" syntax match hsInteger 'Integer' conceal cchar=ℤ
" Note: How to set up conceal: the following line has the same effect as the line above. The highlightgroup for syntax
" match seems to have no effect - still uses the Operator highlight?. For matchadd the 'Conceal' group is mandatory.
" call matchadd('Conceal', ' \zs\.', -1, -1, {'conceal': '∘'})


" ─^  Conceal with unicode                               ▲




" TODO rather highlight all function arguments
" call matchadd('purescriptState', '\vstate%[\.]', -1, -1 )
" call matchadd('purescriptStateKey', '\vstate\.\zs\w{-}\ze\_s', -1, -1 )
call matchadd('purescriptState', '\vH\.\zemodify_\_s', -1, -1 )
call matchadd('purescriptStateKey', '\vH\.\zsmodify_\ze\_s', -1, -1 )

" call matchadd('purescriptEvent', '\vE\zs\.on\ze\u\i', -1, -1 )
" call matchadd('purescriptEvent', '\vHE\.\zeon', -1, -1 )
call matchadd('purescriptEventKey', '\vE\.\zson\u\w{-}\ze\_s', -1, -1 )
call matchadd('purescriptEventKey', '\v\W\zson\u\w{-}\ze\W', -1, -1 )
call matchadd('purescriptEventKey', '\v\W\zson\u\w{-}\ze\_s', -1, -1 )
" drop this as there are different ways to do CSS
" call matchadd('purescriptClassesTW', '\vT\.\zs\w{-}\ze\W', -1, -1 )
" call matchadd('purescriptClasses', '\vclasses', -1, -1 )
" call matchadd('purescriptClassesBG', '\vclasses\s\[\zs.{-}\ze]', -1, -1 )
call matchadd('purescriptClassesBG', '\vclasses\s\zs\[.{-}]', -1, -1 )
" call matchadd('purescriptClassesBG', '\vcss\s\".{-}"', -1, -1 )
call matchadd('purescriptClassesBG', '\vcss\s\"\zs.{-}\ze"', -1, -1 )
call matchadd('purescriptClassesBG', '\vcss\ze\s\"', -1, -1 )

" ─   Inline Tests conceals                              ■

" Example data declaration 1-9: hides the first identifier (the function to be tested)
" e1_database4 = database4 (Just "eins") 123
" -- ①  (Just eins) 123
syntax match InlineTestDeclaration '\v^e\d_\i{-}\s\=' conceal cchar=‥

" syntax match InlineTestNum   'e1' conceal cchar=①
" syntax match InlineTestIdeSpace '\v_\i+\ze[\)\ ]' contained conceal cchar= 
" syntax match InlineTestIdeSpace '\v_\f{-}\ze\)?\_s' contained conceal cchar= 
" Notes: The '+' is needed to prevent concealing standalone '_'s
" syntax match InlineTestDecSpace '\v_\i{-}\s\=\ze\s' conceal cchar= 
" syntax match InlineTestDecSpace '\v_\f{-}\s\=\ze\s' contained conceal cchar= 
" syntax match InlineTestDecSpace '\v_\f{-}\s\=\ze\s' contained conceal cchar= 

" syntax match InlineTestIdentifier  '\ve\d_\i{-}\ze[\)| ]' contains=InlineTestNum,InlineTestIdeSpace
" syntax match InlineTestIdentifier  '\ve\d_\i{-}\ze[\_s|\)]' contains=InlineTestNum,InlineTestIdeSpace
" syntax match InlineTestDeclaration '\v^e\d_\i{-}\s\=\s\i{-}\s' contains=InlineTestNum,InlineTestDecSpace
" syntax match InlineTestDeclaration '\v^e\d_\i{-}\s\=\s' contains=InlineTestNum,InlineTestDecSpace

" added \_s and ')' as end of the test-identifier. now this works without space at the end of the line:
" e2_e1_consos12 = (replicateM 100 e1_consos12)
" e3_e1_consos12 = replicateM 100 e1_consos12

" syntax match InlineTestTypeSig '\v^e\d_.*\s::.*' conceal
" syntax match InlineTestDecT    '\v^e\d_\i{-}\ze\s\::' conceal cchar= 
" syntax match InlineTestDecTC   '\v^e\d_\i{-}\s\::\s\ze' contains=hsFunctionDeclComment,InlineTestDecT


" TODO this is sort of benefitial (but coincidential and i could not set up a separate HL-group for this when tried in
" 7-2019:
" a12_fcomposedNum = e1_fcomposedNum == e3_composedNum
" only "'e3_' gets concealed, but when i append a <space> the entire symbol gets concealed
"

" Assertions:
" a15__database3 = (snd <$> e1_database4) `flipElem` 123
" └ (snd <$> ① ) ∋ 123
" syntax match InlineTestAssertDec     '\v^a\d\d_\i{-}\s\=\ze\s' conceal cchar=├
" syntax match InlineTestAssertDecT    '\v^a\d\d_\i{-}\ze\s\::' conceal cchar=├
" syntax match InlineTestAssertDecTC   '\v^a\d\d_\i{-}\s\::\s\ze' contains=hsFunctionDeclComment,InlineTestAssertDecT
" syntax match InlineTestAssertLastDec '\v^a\d\d__\i{-}\s\=\ze\s' conceal cchar=└
" syntax match InlineTestAssertDecAndTestIdentif  '\v^a\d\d_\i{-}\s\=\se\d\i{-}\ze\s' conceal cchar=├

syntax match concealedSourceLink '\v\/Users\S{-}\ze\_s' conceal cchar=˙


" syntax match Normal '\v^e1_\S{-}\s\=\s\S{-}\ze\s' conceal cchar=①
" call matchadd('Conceal', '\v^txe10\s\=\s.{-}\ze\s', 12, -1, {'conceal': '①'})
" call matchadd('Conceal', 'txe10\s', 12, -1, {'conceal': '①'})
" -- could do this in a for loop to allow 9 example data sets:
" call matchadd('Conceal', '\v^txe20\s\=\s.{-}\ze\s', 12, -1, {'conceal': '②'})

" Assertions 1-9:
" call matchadd('Conceal', '\vtxa\d\d\s\=', 12, -1, {'conceal': '├'})
" -- if datasource is first symbol, conceal it
" call matchadd('Conceal', '\vtxa\d\d\s\=\stxe\d\d\s', 12, -1, {'conceal': '├'})

" ─^  Inline Tests conceals                              ▲

" ─   Concealed TL-Binds                                 ■

" syntax match concealedTLbind '\v^cb\i\i\d\s(::|\=)\s' contained conceal
syntax match concealedTLbindType '\v^cb\i\i\d\s::\s' contained conceal
" syntax match concealedTLbindType '\v^(--\s)?cb\i\i\d\s::\s' contained contains=hsFunctionDeclComment conceal
syntax match concealedTLbindTypeInComment '\v^--\scb\i\i\d\s::\s' contained contains=hsFunctionDeclComment conceal

" This allowed only identifier chars '\i' in the arguments to a function
" syntax match concealedTLbind '\v^(--\s)?cb\i\i\d\s\ze(\i+\s)*\=' conceal
" This also allows pattern matching, e.g. cbyi0 (C {a = a, b = b, c = c, d = d}) = a + b + c + d
syntax match concealedTLbind '\v^(--\s)?cb\i\i\d\s\ze([(),={}a-zA-Z0-9]+\s)*\=' conceal
" This specifies all chars that are allowed in function" args [(),={}a-zA-Z0-9]

syntax match concealedTLbindInComment '\v^(--\s)?cb\i\i\d\s\=\s' contained conceal

syntax match concealHlintComment '\v\{-\sHLINT.{-}-\}' conceal cchar=␣
" Test/Example: (uncomment to see the conceal)
" cbkt0 = sortBy compare [9,3,5,1,7] {- HLINT ignore cbkt0 -}

" ─^  Concealed Bindings                                 ▲


" Tools:
" leader hhsg to show the syntax stack: ~/.vim/plugin/syntax-color.vim#/nnoremap%20<leader>hhsg%20.call
" get syntax group
" echo synIDattr( synID( line('.'), col('.'), 0), 'name' )

" ─   Markbar                                            ■

" This will highlight only the "D" ID in this line:
" [D] file Name
" syn region markbarHeader start=/^\[/ end=/$/ contains=markbarID
syn region markbarHeader start=/^|/ end=/$/ contains=markbarID
syn region markbarID start=/|/hs=s+1 end=/|/he=e-1 contained
" - "contained" marks that this definition is only used in other groups
"   which explicitly reference it in "contains=<groupid>"
"   It does not match on the root level/ by itself

hi! def link markbarHeader Keyword
hi! def link markbarID Highlight1

" highlight vimscript comments. avoids triggring a multiline purescript string
" with prefixed whitespace
" Issue: Repl output String types are highlighted as vim-comments → temp disable this
" syn region markbarVimscriptComment1 start=/^\s\+\"\s/ end=/$/
" syn region markbarVimscriptComment start=/^\"/ end=/$/
" hi! def link markbarVimscriptComment Comment
" hi! def link markbarVimscriptComment1 Comment

" highlight markdown comment
syn region markbarMarkdownHeader start=/^\#\+\s/ end=/$/
syn region markbarMarkdownComment start=/^>/ end=/$/
hi! def link markbarMarkdownHeader Title
hi! def link markbarMarkdownComment Comment

" ─^  Markbar                                            ▲

" TODO: for some reason this must be here/at a later stage, to avoid white blocks at concealed chars when resourcing vimrc
call HsConcealWithUnicode()

" highlight links
highlight def link purescriptModule Include
highlight def link purescriptImport Include
highlight def link purescriptModuleKeyword purescriptKeyword
highlight def link purescriptImportAs Include
highlight def link purescriptModuleName Include
highlight def link purescriptModuleParams purescriptDelimiter
highlight def link purescriptImportKeyword purescriptKeyword
highlight def link purescriptAsKeyword purescriptKeyword
highlight def link purescriptHidingKeyword purescriptKeyword

highlight def link purescriptConditional Conditional
highlight def link purescriptWhere purescriptKeyword
highlight def link purescriptInfixKeyword purescriptKeyword

highlight def link purescriptBoolean Number
highlight def link purescriptNumber Number
highlight def link purescriptFloat Float

" highlight def link purescriptDelimiter Delimiter

highlight def link purescriptOperatorTypeSig purescriptOperatorType
highlight def link purescriptOperatorFunction purescriptOperatorType
highlight def link purescriptOperatorType purescriptOperator

highlight def link purescriptConstructorDecl purescriptConstructor
highlight def link purescriptConstructor purescriptFunction

highlight def link purescriptTypeVar Identifier
highlight def link purescriptForall purescriptStatement

highlight def link purescriptChar String
" highlight def link purescriptBacktick purescriptOperator
" highlight def link abcd purescriptOperator
highlight def link infixBacktick purescriptOperator
highlight def link purescriptString String
highlight def link purescriptMultilineString String

highlight def link purescriptLineComment purescriptComment
highlight def link purescriptBlockComment purescriptComment
highlight def link hsFunctionDeclComment purescriptComment

" purescript general highlights
highlight def link purescriptClass purescriptKeyword
highlight def link purescriptClassName Type
highlight def link purescriptStructure purescriptKeyword
highlight def link purescriptKeyword Keyword
highlight def link purescriptStatement Statement
highlight def link purescriptLet Statement
" highlight def link purescriptOperator Operator
highlight def link purescriptFunction Function
highlight def link purescriptType Type
highlight def link purescriptComment Comment


" highlight def link hsArrow Comment
" highlight! def link hsTopLevelBind Function
" hi! hsTopLevelBind guibg=none guifg=#554B37

let b:current_syntax = "purescript"
