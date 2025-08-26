


func! PythonSyntaxAdditions() " ■
  call Py_bufferMaps()
  " nnoremap <silent><buffer> gei :call repl_py#eval_line( line('.') )<cr>

  call clearmatches()

  syntax region String start=/"/ end=/"/ contains=@Spell
  syntax region String start=/'/ end=/'/ contains=@Spell
  syntax region String start=/`/ end=/`/ contains=@Spell,TSInterpolation

  syntax region Comment start=/\/\// end=/$/
  syntax region Comment start=/\/\*/ end=/\*\//


  syntax match ConcealQuotes "'" conceal
  syntax match ConcealQuotes '"' conceal
  " call CodeMarkupSyntaxHighlights()

  " Quotes
  syntax match Normal '""' conceal cchar=∅
  syntax match Normal '"""' conceal cchar=❞
  syntax match Normal 'f"' conceal cchar=❞
  syntax match Normal "f'" conceal cchar=❞

  syntax match Normal '(Base' conceal cchar= 
  syntax match Normal 'Model):' conceal cchar=

  syntax match Normal '@tool' conceal cchar=⋺
  syntax match Normal '@step' conceal cchar=⋻
  syntax match Normal '@step()' conceal cchar=⋻
  syntax match Normal '@step(workflow=' conceal cchar=⋻

  syntax match Normal 'set_entry_point' conceal cchar=󰶡
  syntax match Normal 'flow' conceal cchar=
  syntax match Normal 'workflow' conceal cchar=
  syntax match Normal 'graph_builder' conceal cchar=
  syntax match Normal 'builder' conceal cchar=
  syntax match Normal 'add_node' conceal cchar=❇
  syntax match Normal 'add_edge' conceal cchar=󰔰
  syntax match Normal 'add_conditional_edges' conceal cchar=⭄

  syntax match Normal "async\ze\s" conceal cchar=•
  syntax match Normal "await\ze\s" conceal cchar=≀

  syntax match Normal "Annotated" conceal cchar=⁝
  syntax match Normal "Literal" conceal cchar=⟮
  syntax match Normal "Union" conceal cchar=|
  syntax match Normal '\vField\ze\(' conceal cchar=˾
  syntax match Normal 'Optional' conceal cchar=≟

  syntax match Normal 'try:' conceal cchar=⋊
  syntax match Normal 'except' conceal cchar=◌

  syntax match Normal '\s\zsif\ze\W' conceal cchar=˻
  syntax match Normal 'else:' conceal cchar=˺
  syntax match Normal 'elif' conceal cchar=˼

  syntax match Normal 'for\ze\W' conceal cchar=↖

  syntax match Normal 'isinstance' conceal cchar=˰

  " syntax match Normal '\vlist\ze(\W|\_$)' conceal cchar=˄
  syntax match Normal '\vlist\ze(\W|\_$)' conceal cchar=⟬
  syntax match Normal '\v\W\zsdict\ze(\W|\_$)' conceal cchar=ʺ
  " syntax match Normal 'Map\ze\W' conceal cchar=ʺ
  syntax match Normal '\vset\ze(\W|\_$)' conceal cchar=ᴺ
  syntax match Normal '\vtuple\ze\[' conceal cchar=T
  syntax match Normal '\W\zsstr\ze\W' conceal cchar=s
  syntax match Normal '\W\zsstr\:' conceal cchar=s
  syntax match Normal '\vint\ze(\,|\]|\))' conceal cchar=ɪ
  syntax match Normal '\vint\ze\s\=' conceal cchar=ɪ
  " syntax match Normal '\vint\:' conceal cchar=ɪ
  " syntax match Normal '\vfloat\ze(\,|\]|\)|\:)' conceal cchar=𝑓
  syntax match Normal '\vfloat\ze(\,|\]|\))' conceal cchar=ɪ
  syntax match Normal '\vfloat\ze\s\=' conceal cchar=ɪ

  syntax match Normal '\s\zswith\ze\s' conceal cchar=⊃
  syntax match Normal '\s\zsas\ze\s' conceal cchar=⊂

  syntax match Normal 'from' conceal cchar=⊃
  syntax match Normal 'import\s' conceal cchar=⁝
  syntax match Normal 'class\ze\s' conceal cchar=□
  syntax match Normal 'self' conceal cchar=∝
  syntax match Normal 'lambda' conceal cchar=→

  syntax match Normal "def\s" conceal

  syntax match Normal "()" conceal cchar=∘
  syntax match Normal "():" conceal

  syntax match Normal ")\zs:" conceal cchar=˃
  syntax match Normal "\s\zs:\ze(" conceal cchar=˃

  syntax match Normal "\v\-\>" conceal cchar=➔
  " syntax match Normal "return\ze\s" conceal cchar=←
  syntax match Normal "return" conceal cchar=▂

  syntax match Normal "\v\S\zs:" conceal

  syntax match InlineTestDeclaration '\v^e\d_\i{-}\s\=' conceal cchar=‥
  syntax match InlineTestDeclaration '\v^def\se\d_\k{-}\(\)\:\sreturn' conceal cchar=‥
  syntax match InlineTestDeclaration '\v^async def\se\d_\k{-}\(\)\:\sreturn' conceal cchar=‥

  " This is effective in preventing the conceal unicode in normal comments
  syntax match Comment '\v#\s\zs.*'
  syntax match Normal '\.\ze\S' conceal cchar=ˍ

  " syntax match Normal '\.strip' conceal cchar=≣
  syntax match Normal '\.strip' conceal

  " Hide comment character at beginning of line
  call matchadd('Conceal', '\v^\s*\zs#\s', 12, -1, {'conceal': ''})
  " Hilde \" before comment after code
  call matchadd('Conceal', '\s\zs\#\ze\s', 12, -1, {'conceal': ''})
  " Conceal "%20" which is used for "h rel.txt" with space
  call matchadd('Conceal', '%20', 12, -1, {'conceal': ' '})
  call matchadd('Conceal', '#/', 12, -1, {'conceal': '|'})
  " ~/.vim/notes/notes-navigation.md#/Create%20hyperlink%20to

  " call matchadd('Conceal', '"', -1, -1, {'conceal': ''})
  " call matchadd('Conceal', "'", -1, -1, {'conceal': ''})

  set conceallevel=2
  set concealcursor=ni
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  set commentstring=\ \#%s

  syntax match BlackBG '\v─(\^|\s)\s{2}\S.*'

endfunc " ▲

