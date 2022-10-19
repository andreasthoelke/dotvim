
func! TsSyntaxAdditions ()

  call tools_js#bufferMaps()
  call clearmatches()


  syntax match Normal "\v\=\=" conceal cchar=≡
  syntax match Normal "===" conceal cchar=≣
  " syntax match Normal "\s\zs\>\=\ze\s" conceal cchar=≥
  syntax match Normal "\v\+\+" conceal cchar=⧺
  syntax match Normal "\v\|\|" conceal cchar=‖
  syntax match Normal "\v\&\&" conceal cchar=﹠

  syntax match Normal '\vnumber\ze(\W|\_$)' conceal cchar=N
  syntax match Normal '\vstring\ze(\W|\_$)' conceal cchar=S
  syntax match Normal 'String\.' conceal cchar=S
  syntax match Normal 'String' conceal cchar=S
  syntax match Normal 'Number\.' conceal cchar=N
  syntax match Normal '\vboolean\ze(\W|\_$)' conceal cchar=B
  syntax match Normal 'array\ze\W' conceal cchar=⟦

  syntax match Normal 'i\zsdentity' conceal cchar=d

  " syntax match Normal 'List\ze\W' conceal cchar=⟬
  syntax match Normal 'List' conceal cchar=L
  " syntax match Normal 'Array\ze\W' conceal cchar=⟦
  syntax match Normal 'Array' conceal cchar=A
  syntax match Normal 'Tuple' conceal cchar=T
  syntax match Normal 'tuple\:\s' conceal cchar=T
  syntax match Normal 'tuple\:\[' conceal cchar=T

  syntax match Normal '({' conceal cchar=⟨
  syntax match Normal '})' conceal cchar=⟩

  syntax match Normal "()" conceal cchar=∘

  syntax match Normal "\v\=\>" conceal cchar=⇒

  " The collon before a type or an object value
  syntax match Normal "\w\zs:\ze\s" conceal
  syntax match Normal ")\zs:" conceal cchar=˃
  syntax match Normal ")\s\zs=>\ze\s.*=>" conceal cchar=⇾

  syntax match Normal "const\s" conceal
  syntax match Normal "readonly\s" conceal cchar=‧

  syntax match Normal "'" conceal
  syntax match Normal "''" conceal cchar=∅
  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅

  " JSDoc comments
  syntax match Normal "\/\*\*" conceal
  syntax match Normal "\/\*\*\s" conceal
  syntax match Normal "^\s\*\s" conceal
  syntax match Normal "^\*\s" conceal

  " TS conceals
  " TODO: can't match "export" twice? ~/Documents/Server-Dev/d_gql_edb/src/b_ramda_pipe_async_examples.ts#/export%20function%20ac
  " syntax match Normal "export\s\zsfunction\ze\s" conceal cchar=→
  syntax match Normal "function\ze\s" conceal cchar=→
  syntax match Normal "^export\ze\s" conceal cchar=∷
  syntax match Normal "gql`" conceal cchar=▵
  syntax match Normal "return\ze\s" conceal cchar=←
  syntax match Normal "return\zeA" conceal cchar=←
  syntax match Normal "async\ze\s" conceal cchar=•
  syntax match Normal "Async\ze\W" conceal cchar=•
  syntax match Normal "await\ze\s" conceal cchar=≀
  syntax match Normal "Promise" conceal cchar=~
  syntax match Normal "Deferred" conceal cchar=~
  syntax match Normal "undefined" conceal cchar=∪
  syntax match Normal "unknown" conceal cchar=⪦
  syntax match Normal "never" conceal cchar=ˍ
  syntax match Normal "null\ze\s" conceal cchar=⨆
  " syntax match Normal "this\." conceal cchar=⫶
  syntax match Normal "\v\(\)\s\=\>" conceal cchar=ˍ
  syntax match Normal "\v_\s\=\>" conceal cchar=ˍ
  syntax match Normal "void" conceal cchar=✴

  syntax match Normal '<' conceal cchar=⁽
  syntax match Normal '>' conceal cchar=⁾
  syntax match Normal '\s\zs>\ze\s' conceal cchar=▷
  syntax match Normal '\s\zs<\ze\s' conceal cchar=◁

  syntax match Normal '<div' conceal cchar=⋮
  syntax match Normal '<div>' conceal cchar=⋮
  syntax match Normal '</div>' conceal cchar=⋮
  syntax match Normal '/>' conceal cchar=˗
  syntax match Normal '|>' conceal cchar=⇾

  syntax match Normal '\s\zstype_=' conceal

" ➹  ⤤  ⬀  ⬈  ⧼  ⪦ ⇡ ⇞  ⇾  ~➚
" ᐣ ᐤ  ᐥ  ᐦᐧ  ᐨ  ᑆ   ᑄ   ᑋ  ᑓ   ᑣ   ᒾ  ᓋ  ᓩ  ᓫ ›

  syntax match Normal 'map' conceal cchar=➚
  syntax match Normal 'and\zeThen' conceal cchar=~
  syntax match Normal 'Then\ze\W' conceal cchar=➚
  syntax match Normal 'pipe' conceal cchar=→
  syntax match Normal 'flow' conceal cchar=⇾
  syntax match Normal 'i => i' conceal cchar=»
  syntax match Normal 'concat' conceal cchar=◇
  syntax match Normal 'combine' conceal cchar=◇

  syntax match Normal 'i => {i' conceal cchar=_
  syntax match Normal 'x => x\ze\s' conceal cchar=_
  syntax match Normal 'x => x\ze\.' conceal cchar=_

  syntax match Normal 'JSX.Element' conceal cchar=⊃
  syntax match Normal 'className=' conceal cchar=◇

  " Effect TS Plus ᴈ ᴇ ᴱ ᴲ ᵉ
  " syntax match Normal 'Effect' conceal cchar=⁝
  syntax match Normal 'Effect\ze<' conceal cchar=ᴱ
  syntax match Normal 'Effect\.' conceal cchar=⁝
  syntax match Normal 'Effect\.\$\.' conceal cchar=⁝
  syntax match Normal 'AssociativeIdentity\.' conceal cchar=⁝
  syntax match Normal 'Associative\.' conceal cchar=⁝
  syntax match Normal 'flatMap' conceal cchar=↣

  syntax match Normal '\s\zs\.' conceal cchar=ˍ
  syntax match Normal '\S\zs\.\ze\S' conceal cchar=ˍ

  " Match.tag( exp, {
  syntax match Normal 'Match.tag(' conceal cchar=⊂



  " const v1 = Do(($) => {
  syntax match Normal 'Do(($) => {' conceal cchar=⊇
  syntax match Normal '=\s\$(' conceal cchar=⇠
  syntax match Normal '$(' conceal cchar=ˍ

  " const v1 = Effect.Do()
  syntax match Normal 'Effect.Do()' conceal cchar=⊇
  syntax match Normal '\v.bind(Value)?\(' conceal
  syntax match Normal '$(' conceal cchar=ˍ

  " syntax match Normal '\v\s\zs\)$' conceal cchar=᛫
  syntax match Normal '\v\S\s\zs\)$' conceal
  syntax match Normal '\v\(\ze\s' conceal
  syntax match Normal '\v\s\zs\)' conceal
  " TODO use a lookaround
  " syntax match Normal '\v\$@!.*\zs\)$' conceal cchar=᛫

  " EdgeDB query builder object: e.select()
  syntax match Normal "\s\zse\." conceal cchar=᛫
  syntax match Normal "\s\zstrue" conceal cchar=᛫
  " syntax match Normal "ilike" conceal cchar=∼
  " syntax match Normal "like" conceal cchar=∼
  syntax match Normal "order_by\:" conceal cchar=ꜛ
  syntax match Normal "filter\:" conceal cchar=≚
  syntax match Normal "\.\.\." conceal cchar=…
  syntax match Normal "\*\/" conceal


  syntax match InlineTestDeclaration '\v^const\se\d_\i{-}\s\=' conceal cchar=‥
  syntax match InlineTestDeclaration '\v^const\sa\d_\i{-}\s\=' conceal cchar=…
  syntax match InlineTestDeclaration '\v^export\sconst\se\d_\i{-}\s\=' conceal cchar=‥
  syntax match InlineTestDeclaration '\v^export\sconst\sa\d_\i{-}\s\=' conceal cchar=…
  syntax match InlineTestDeclaration '\v^export\sconst\se\d_\i{-}\:' conceal cchar=‥
  " syntax match ConcealQuotes "'" conceal
  " syntax match ConcealQuotes '"' conceal

  call CodeMarkupSyntaxHighlights()
  " Hide comment character at beginning of line
  " call matchadd('Conceal', '\v^\s*\zs#\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '\v^\s*\zs\/\/\s', 12, -1, {'conceal': ''})
  " Hilde \" before comment after code
  " call matchadd('Conceal', '\s\zs\#\ze\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '\s\zs\\/\/\ze\s', 12, -1, {'conceal': ''})
  " Conceal "%20" which is used for "h rel.txt" with space
  call matchadd('Conceal', '%20', 12, -1, {'conceal': ' '})
  call matchadd('Conceal', '#/', 12, -1, {'conceal': '|'})
  " ~/.vim/notes/notes-navigation.md#/Create%20hyperlink%20to

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  " set commentstring=\ \/\/%s



endfunc




