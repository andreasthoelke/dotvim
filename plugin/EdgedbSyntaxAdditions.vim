


func! EdgeQLSyntaxAdditions() " ■
  call tools_edgedb#bufferMaps()

  call clearmatches()
  set conceallevel=2
  set concealcursor=ni

  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', ';', 12, -1, {'conceal': ''})

  syntax match CommentMinusMinus "{"
  syntax match CommentMinusMinus "}"
  syntax match CommentMinusMinus "("
  syntax match CommentMinusMinus ")"

  call matchadd('FunctionDec', '\vtype\s\zs\w*', 11, -1)
  call matchadd('FunctionDec', '\vinsert\s(\w*::)?\zs\w*', 11, -1)
  call matchadd('FunctionDec', '\vselect\s(\w*::)?\zs\w*', 11, -1)
  call matchadd('FunctionDec', '\vINSERT\s(\w*::)?\zs\w*', 11, -1)
  call matchadd('FunctionDec', '\vSELECT\s(\w*::)?\zs\w*', 11, -1)
  call matchadd('Trait', '\vabstract\stype\s\zs\w*', 11, -1)

  " properties
  " call matchadd('Comment',      '\v\w*\ze:', 11, -1)
  call matchadd('purescriptConstructor',      '\v\w*\ze:', 11, -1)
  " namespaces
  call matchadd('CommentMinus', '\v\w*\ze::', 11, -1)

  " comments are overwriting other matchadds
  call matchadd('CommentMinus', '\#\s\zs.*', 11, -1)
  call matchadd('CommentMinus', '\#\s\zs.*', 11, -1)

  syntax match Normal "\v\S\zs:" conceal

  syntax match Normal 'with' conceal cchar=˪
  syntax match Normal 'WITH' conceal cchar=˪
  syntax match Normal 'update' conceal cchar=☼
  syntax match Normal 'UPDATE' conceal cchar=☼
  syntax match Normal 'select' conceal cchar=⁝
  syntax match Normal 'insert' conceal cchar=⌄
  syntax match Normal 'SELECT' conceal cchar=⁝
  syntax match Normal 'INSERT' conceal cchar=⌄
  syntax match Normal 'filter' conceal cchar=⇡
  syntax match Normal 'FILTER' conceal cchar=⇡
  syntax match Normal 'for\ze\s' conceal cchar=⊃
  syntax match Normal 'FOR' conceal cchar=⊃
  syntax match Normal 'in\ze\s' conceal cchar=⊂
  syntax match Normal 'IN\ze\s' conceal cchar=⊂

  syntax match Normal 'function' conceal cchar=➔
  syntax match Normal 'type ' conceal
  syntax match Normal 'abstract ' conceal
  syntax match Normal 'property ' conceal
  syntax match Normal 'module' conceal cchar=⊟
  syntax match Normal 'required ' conceal cchar=ˌ
  syntax match Normal 'link' conceal cchar=←
  syntax match Normal 'multi ' conceal cchar=≡
  " single is assumed if multi isn't given for links
  syntax match Normal 'single ' conceal
  syntax match Normal 'optional ' conceal cchar=≟
  syntax match Normal 'extending' conceal cchar=⟔
  syntax match Normal 'constraint' conceal cchar=˽

  syntax match Normal 'set' conceal cchar=∥
  syntax match Normal 'SET' conceal cchar=∥
  syntax match Normal 'union' conceal cchar=‖
  syntax match Normal 'UNION' conceal cchar=‖

  syntax match Normal 'std::str' conceal cchar=s
  syntax match Normal 'str' conceal cchar=s
  syntax match Normal '<str>' conceal cchar=s
  syntax match Normal '<json>' conceal cchar=⫕
  syntax match Normal 'std::int32' conceal cchar=ɪ
  syntax match Normal 'std::int64' conceal cchar=ɪ
  syntax match Normal 'int32' conceal cchar=ɪ
  syntax match Normal 'int64' conceal cchar=ɪ
  syntax match Normal '<int64>' conceal cchar=ɪ
  syntax match Normal 'std::float64' conceal cchar=ɪ
  syntax match Normal 'Boolean' conceal cchar=ʙ

  syntax match Normal 'using' conceal cchar=⊨

  syntax match Normal 'if\ze\W' conceal cchar=˻
  syntax match Normal 'else' conceal cchar=˼
  syntax match Normal 'else\sif' conceal cchar=˼
  " syntax match Normal 'then\ze(\W|\_$)' conceal cchar=˹
  syntax match Normal '\v\s\zsthen\ze(\s|\_$)' conceal cchar=˹


  syntax match Normal "->" conceal cchar=→
  syntax match Normal "::" conceal cchar=ˍ
  syntax match Normal ":=" conceal cchar=⫶
  set commentstring=\#%s

endfunc " ▲

