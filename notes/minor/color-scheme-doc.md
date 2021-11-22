
# Colors

https://coolors.co/0087af-76e0d9-aab27c-983b4d-065143

## Tools
> current Highlights
command! HighlightTest exec "source $VIMRUNTIME/syntax/hitest.vim"
> disable highlighting for a group
hi clear DataConstructor
> where was the highlight set?
verbose hi DataConstructor

* Syntax stack 
nnoremap <leader>hsg :call SyntaxStack()
* Syntax group → Highlight group 
`<leader>hhg :call SyntaxGroup()`
* Highlight group - color values
`<leader>hsc :call SyntaxColor()
`
> Highligh color values in the current line
`nnoremap <leader>hcc :,ColorHighlight<CR>`
`nnoremap <leader>hcd :ColorClear<CR>`

> Example: 
hi! MyTest1 guifg=#E0306F
hi! def link vimCommentTitle MyTest1

Note: The main colors are now defined in ~/.vim/colors/munsell-blue-molokai.vim

## Purescript Haskell Colors

### purescriptFunction
> -> Function
hi! Function guifg=#0087AF "munsell blue"

### purescriptIdentifier
> -> purescriptIdentifier
hi! purescriptIdentifier guifg=#E7F4F7 "anti flash white"

### purescriptType
> -> Type
hi! Type guifg=#76E0D9 "middle blue"

### purescriptTypeVar
> -> Identifier
hi! Identifier guifg=#AAB27C "Misty moss - shift sage yellow from red to green"

### purescriptConstructor 
hi! DataConstructor guifg=#983B4D "smoky topaz red"
hi! def link purescriptConstructor DataConstructor 


### purescriptNumber 
> -> Number
hi! def link purescriptNumber Number
hi! Number guifg=#066150   "sacramentostate green +brighter"

### purescriptFloat 
> -> Float
hi! Float guifg=#066150   "sacramentostate green +brighter"

### purescriptString 
> -> String
hi! String guifg=#066150   "sacramentostate green +brighter"

### purescriptBoolean 
> -> Boolean
hi! Boolean guifg=#066150   "sacramentostate green +brighter"


### purescriptStructure (data)
> -> Keyword 
hi! Keyword guifg=#3C6B7C "ming"

### purescriptOperator 
> -> Operator
hi! Operator guifg=#3C6B7C "ming"

### purescriptDelimiter 
> -> Delimiter
hi! Delimiter guifg=#3C6B7C "ming"

### purescriptStatement (do and let)
> -> Statement 
hi! Statement  guifg=#3C6B7C "ming"

### purescriptConditional 
> -> Conditional
hi! Conditional guifg=#3C6B7C "ming"


## Magit Git colors
hi! def link fileEntry Function 
hi! def link diffAdded Type 
hi! def link diffRemoved Macro 

## Vim help colors
hi! def link helpHyperTextEntry Type 
hi! def link helpHyperTextJump DataConstructor 
hi! def link helpOption DataConstructor 
hi! def link helpStar DataConstructor 
hi! def link helpExample DataConstructor 
hi! def link helpCommand DataConstructor 

## Tagbar colors
hi! def link TagbarSignature Type 
hi! def link TagbarScope Function 
hi! def link TagbarType Keyword 

## Markdown colors
hi! Title gui=bold guifg=#0087AF "munsell blue"
hi! def link mkdHeading Operator 
hi! def link mkdNonListItemBlock purescriptIdentifier 
hi! def link mkdCode Statement 
hi! def link mkdListItem Type 
hi! Underlined2 guifg=#3C6B7C guibg=#0C0C0C gui=italic
hi! def link mkdInlineURL Underlined2 


## Current highlights
:so $VIMRUNTIME/syntax/hitest.vim

Number	links	Number	links to purescriptNumber
Float	links	Float	links to purescriptFloat
Boolean	links	Boolean	links to purescriptBoolean
Delimiter	links	Delimiter	links to purescriptDelimiter
Type	links	Type	links to purescriptType
Identifier	links	Identifier	links to purescriptTypeVar
Macro	links	Macro	links to purescriptConstructor
purescriptOperator	links	purescriptOperator	links to purescriptOperatorType
purescriptOperatorType	links	purescriptOperatorType	links to purescriptOperatorTypeSig
purescriptConstructor	links	purescriptConstructor	links to purescriptConstructorDecl
Function	links	Function	links to purescriptFunction
Operator	links	Operator	links to purescriptBacktick
purescriptKeyword	links	purescriptKeyword	links to purescriptClass
Type	links	Type	links to purescriptClassName
Operator	links	Operator	links to purescriptOperator
purescriptKeyword	links	purescriptKeyword	links to purescriptWhere
Include	links	Include	links to purescriptModuleName
purescriptKeyword	links	purescriptKeyword	links to purescriptModuleKeyword
purescriptDelimiter	links	purescriptDelimiter	links to purescriptModuleParams
Include	links	Include	links to purescriptModule
purescriptKeyword	links	purescriptKeyword	links to purescriptStructure
purescriptKeyword	links	purescriptKeyword	links to purescriptImportKeyword
Include	links	Include	links to purescriptImportAs
Include	links	Include	links to purescriptImport
purescriptKeyword	links	purescriptKeyword	links to purescriptAsKeyword
purescriptKeyword	links	purescriptKeyword	links to purescriptHidingKeyword
purescriptStatement	links	purescriptStatement	links to purescriptForall
Statement	links	Statement	links to purescriptLet
Conditional	links	Conditional	links to purescriptConditional
Statement	links	Statement	links to purescriptStatement
purescriptKeyword	links	purescriptKeyword	links to purescriptInfixKeyword
purescriptComment	links	purescriptComment	links to purescriptBlockComment
purescriptOperatorType	links	purescriptOperatorType	links to purescriptOperatorFunction
String	links	String	links to purescriptChar
String	links	String	links to purescriptString
String	links	String	links to purescriptMultilineString
purescriptComment	links	purescriptComment	links to purescriptLineComment
Keyword	links	Keyword	links to purescriptKeyword
Comment	links	Comment	links to purescriptComment
 
## Default purescript syntax - highlight links
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

highlight def link purescriptBoolean Boolean
highlight def link purescriptNumber Number
highlight def link purescriptFloat Float

highlight def link purescriptDelimiter Delimiter

highlight def link purescriptOperatorTypeSig purescriptOperatorType
highlight def link purescriptOperatorFunction purescriptOperatorType
highlight def link purescriptOperatorType purescriptOperator

highlight def link purescriptConstructorDecl purescriptConstructor
highlight def link purescriptConstructor purescriptFunction

highlight def link purescriptTypeVar Identifier
highlight def link purescriptForall purescriptStatement

highlight def link purescriptChar String
highlight def link purescriptBacktick purescriptOperator
highlight def link purescriptString String
highlight def link purescriptMultilineString String

highlight def link purescriptLineComment purescriptComment
highlight def link purescriptBlockComment purescriptComment

" purescript general highlights
highlight def link purescriptClass purescriptKeyword
highlight def link purescriptClassName Type
highlight def link purescriptStructure purescriptKeyword
highlight def link purescriptKeyword Keyword
highlight def link purescriptStatement Statement
highlight def link purescriptLet Statement
highlight def link purescriptOperator Operator
highlight def link purescriptFunction Function
highlight def link purescriptType Type
highlight def link purescriptComment Comment
 

## Experiments and alternative colors

-- magit
highlight! def link fileEntry Function 
highlight! def link diffAdded Type 
highlight! def link diffRemoved Macro 

-- purescriptFunction -> Function
highlight! Function guifg=#D1FA71 " default green"
highlight! Function guifg=#FF1744
highlight! Function guifg=#114B5F
highlight! Function guifg=#00AF5F "flash green"
highlight! Function guifg=#45C48A " ocean green"
highlight! Function guifg=#0087AF "munsell blue"

-- purescriptBacktick -> Operator (prefix(?) function)
highlight! def link purescriptBacktick purescriptIdentifier 
highlight! def link purescriptBacktick Operator 
-- purescriptType -> Type
highlight! Type guifg=#72BCD6 " old vim blue"
highlight! Type guifg=#FF80AB
highlight! Type guifg=#FF1744 "awesome red"
highlight! Type guifg=#92D7A1 " eton blue"
highlight! Type guifg=#F46036 "protland orange"
highlight! Type guifg=#0087AF "munsell blue"
highlight! Type guifg=#76E0D9 "middle blue"
-- purescriptIdentifier -> purescriptIdentifier
--                         purescriptIdentifier xxx cleared
-- purescriptConstructor -> Function
highlight! def link purescriptConstructor Macro 
highlight! Macro guifg=#C4BE89
highlight! Macro guifg=#FF80AB "tickle be pink"
highlight! Macro guifg=#B0E3C9 "magic mint" (too similar to middle blue)
highlight! Macro guifg=#D7C674 "straw yellow"
highlight! Macro guifg=#FFFFFF ".."
highlight! Macro guifg=#F6DC69 "vim flashy yellow"
highlight! Macro guifg=#FF80AB "tickle be pink"
highlight! Macro guifg=#C03B56 "awesome .."
highlight! Macro guifg=#A5324A "awesome .."
highlight! Macro guifg=#8C0D26 "awesome dark"
highlight! Macro guifg=#A53E54 "english red - awesome sweetspot"
highlight! Macro guifg=#995B54 "english red - awesome sweetspot"
highlight! Macro guifg=#935361 "english red - awesome sweetspot"
highlight! Macro guifg=#983B4D "smoky topaz"

-- purescriptTypeVar -> Identifier
highlight! Identifier guifg=#96D9F1 "greyblue"
highlight! Identifier guifg=#46A4C5 "greyblue"
highlight! Identifier guifg=#92D7A1 "eton blue - match ming and ocean" 
highlight! Identifier guifg=#39A171 "medium sea green" 
highlight! Identifier guifg=#C4BE89 "Sage - ex vim Macro. nicely pale - better than straw yellow"
highlight! Identifier guifg=#AAB27C "Misty moss - shift sage yellow from red to green"


-- purescriptIdentifier -> purescriptIdentifier
highlight! purescriptIdentifier guifg=#E6E6E6 ".."
highlight! purescriptIdentifier guifg=#FFFFFF ".."
highlight! purescriptIdentifier guifg=#E7F4F7 "anti flash white"

-- purescriptStructure -> Keyword (data)
highlight! Keyword guifg=#50D6EF
highlight! Keyword guifg=#FF1744
highlight! Keyword guifg=#76E0D9
highlight! Keyword guifg=#FF80AB
highlight! Keyword guifg=#109648
highlight! Keyword guifg=#265B6D
highlight! Keyword guifg=#3C6B7C "ming"
-- purescriptOperator -> Operator
highlight! Operator guifg=#FFFFC9
highlight! Operator guifg=#FF80AB
highlight! Operator guifg=#FF1744
highlight! Operator guifg=#5BB276
highlight! Operator guifg=#3C6B7C "ming"
-- purescriptOperatorType -> Operator
-- purescriptOperatorFunction -> Operator (lambda)
-- purescriptDelimiter -> Delimiter
highlight! Delimiter guifg=#F7F7F7
highlight! Delimiter guifg=#3C6B7C "ming"
-- purescriptStatement -> Statement (do and let can be dimmed)
highlight! Statement guifg=#D1FA71 "old soft green"
highlight! Statement gui=italic guifg=#3C6B7C  "ming"

-- purescriptConditional -> Conditional
highlight! Conditional gui=italic guifg=#3C6B7C "ming"

-- purescriptWhere -> Keyword
-- purescriptNumber -> Number
highlight! Number guifg=#F6DC69 "vim flashy yellow"
highlight! Number guifg=#C4BE89 
highlight! Number guifg=#065143   "sacramentostate green"

-- purescriptFloat -> Float
highlight! Float guifg=#065143   "sacramentostate green"
-- purescriptString -> String
highlight! String guifg=#F6DC69 "old yellow"
highlight! String guifg=#C6DABF "pastel gray"
highlight! String guifg=#F46036 "protland orange"
highlight! String guifg=#C4BE89   "pastel gray"
highlight! String guifg=#78606F   "middle red purple"
highlight! String guifg=#074F57   "midnight green"
highlight! String guifg=#065143   "sacramentostate green"
-- purescriptBoolean -> Boolean
highlight! Boolean guifg=#065143   "sacramentostate green"




