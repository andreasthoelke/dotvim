
func! ScalaSyntaxAdditions ()

  call tools_scala#bufferMaps()
  call clearmatches()

  syntax match Normal "\v\=\=" conceal cchar=≡
  syntax match Normal "===" conceal cchar=≣
  " syntax match Normal "\s\zs\>\=\ze\s" conceal cchar=≥
  syntax match Normal "\v\+\+" conceal cchar=⧺
  syntax match Normal "\v\|\|" conceal cchar=‖
  syntax match Normal "\v\&\&" conceal cchar=﹠

  " syntax match Normal '\vInt\ze(\W|\_$)' conceal cchar=I
  syntax match Normal '\vstring\ze(\W|\_$)' conceal cchar=S
  syntax match Normal 'String\.' conceal cchar=S
  syntax match Normal 'String' conceal cchar=S
  " syntax match Normal 'Int\.' conceal cchar=I
  syntax match Normal '\vBool\ze(\W|\_$)' conceal cchar=B

  " syntax match Normal 'List\ze\W' conceal cchar=⟬
  syntax match Normal 'List' conceal cchar=L
  " syntax match Normal 'Array\ze\W' conceal cchar=⟦
  syntax match Normal 'Array' conceal cchar=A
  syntax match Normal 'Tuple' conceal cchar=T
  syntax match Normal 'tuple\:\s' conceal cchar=T
  syntax match Normal 'tuple\:\[' conceal cchar=T

  " syntax match Normal "def\ze\s" conceal cchar=→
  syntax match Normal "def\s" conceal
  syntax match Normal 'Unit\ze\s' conceal cchar=✴

  syntax match Normal "<-\ze\s" conceal cchar=←

  syntax match Normal "()" conceal cchar=∘

  syntax match Normal "\v\=\>" conceal cchar=⇒

  " The collon before a type or an object value
  syntax match Normal "\w\zs:\ze\s" conceal
  syntax match Normal ")\zs:" conceal cchar=˃
  syntax match Normal ")\s\zs=>\ze\s.*=>" conceal cchar=⇾

  syntax match Normal "val\s" conceal

  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅

  " TS conceals
  " TODO: can't match "export" twice? ~/Documents/Server-Dev/d_gql_edb/src/b_ramda_pipe_async_examples.ts#/export%20function%20ac
  " syntax match Normal "export\s\zsfunction\ze\s" conceal cchar=→
  syntax match Normal "\v\(\)\s\=\>" conceal cchar=ˍ
  syntax match Normal "\v_\s\=\>" conceal cchar=ˍ

  syntax match Normal '\s\zs>\ze\s' conceal cchar=▷
  syntax match Normal '\s\zs<\ze\s' conceal cchar=◁

  syntax match Normal 'i => {i' conceal cchar=_
  syntax match Normal 'x => x\ze\s' conceal cchar=_
  syntax match Normal 'x => x\ze\.' conceal cchar=_

  syntax match Normal 'ZIO\ze\[' conceal cchar=ᴱ
  syntax match Normal 'ZIO\.' conceal cchar=⁝
  syntax match Normal 'ZIO\.\$\.' conceal cchar=⁝
  syntax match Normal 'flatMap' conceal cchar=↣

  syntax match Normal '\s\zs\.' conceal cchar=ˍ
  syntax match Normal '\S\zs\.\ze\S' conceal cchar=ˍ

  syntax match InlineTestDeclaration '\v^val\se\d_\i{-}\s\=' conceal cchar=‥
  syntax match InlineTestDeclaration '\v^val\sa\d_\i{-}\s\=' conceal cchar=…

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




