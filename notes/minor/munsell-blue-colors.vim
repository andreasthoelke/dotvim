" Purescript Haskell Colors

" purescriptFunction
" > Function
hi! Function guifg=#0087AF "munsell blue"

" purescriptIdentifier
" > purescriptIdentifier
hi! purescriptIdentifier guifg=#E7F4F7 "anti flash white"

" purescriptType
" > Type
hi! Type guifg=#76E0D9 "middle blue"

" purescriptTypeVar
" > Identifier
hi! Identifier guifg=#AAB27C "Misty moss - shift sage yellow from red to green"

" purescriptConstructor 
hi! DataConstructor guifg=#983B4D "smoky topaz red"
hi! def link purescriptConstructor DataConstructor 


" purescriptNumber 
" > Number
hi! def link purescriptNumber Number
hi! Number guifg=#066150   "sacramentostate green +brighter"

" purescriptFloat 
" > Float
hi! Float guifg=#066150   "sacramentostate green +brighter"

" purescriptString 
" > String
hi! String guifg=#066150   "sacramentostate green +brighter"

" purescriptBoolean 
" > Boolean
hi! Boolean guifg=#066150   "sacramentostate green +brighter"


" purescriptStructure (data)
" > Keyword 
hi! Keyword guifg=#3C6B7C "ming"

" purescriptOperator 
" > Operator
hi! Operator guifg=#3C6B7C "ming"

" purescriptDelimiter 
" > Delimiter
hi! Delimiter guifg=#3C6B7C "ming"

" purescriptStatement (do and let)
" > Statement 
hi! Statement  guifg=#3C6B7C "ming"

" purescriptConditional 
" > Conditional
hi! Conditional guifg=#3C6B7C "ming"


" Magit Git colors
hi! def link fileEntry Function 
hi! def link diffAdded Type 
hi! def link diffRemoved Macro 

" Vim help colors
hi! def link helpHyperTextEntry Type 
hi! def link helpHyperTextJump DataConstructor 
hi! def link helpOption DataConstructor 
hi! def link helpStar DataConstructor 
hi! def link helpExample DataConstructor 
hi! def link helpCommand DataConstructor 

" Tagbar colors
hi! def link TagbarSignature Type 
hi! def link TagbarScope Function 
hi! def link TagbarType Keyword 

" Markdown colors
hi! Title gui=bold guifg=#0087AF "munsell blue"
hi! def link mkdHeading Operator 
hi! def link mkdNonListItemBlock purescriptIdentifier 
hi! def link mkdCode Statement 
hi! def link mkdListItem Type 
hi! Underlined2 guifg=#3C6B7C guibg=#0C0C0C gui=italic
hi! def link mkdInlineURL Underlined2 

