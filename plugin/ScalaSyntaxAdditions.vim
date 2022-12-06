

  " ➔  ⇾  →  ˃ ➟ ⇢ ˲ ↗ → →   ˷ ˍˍ ˳     ⟣ ◦ פּ ﬘   璘

func! ScalaSyntaxAdditions ()

  call tools_scala#bufferMaps()
  call clearmatches()

  syntax match Normal "\v\=\=" conceal cchar=≡
  syntax match Normal "===" conceal cchar=≣
  " syntax match Normal "\s\zs\>\=\ze\s" conceal cchar=≥
  syntax match Normal "\v\+\+" conceal cchar=⧺
  syntax match Normal "\v\|\|" conceal cchar=‖
  " syntax match Normal "\v\&\&" conceal cchar=﹠

  " syntax match Normal '\vInt\ze(\W|\_$)' conceal cchar=I
  syntax match Normal '\vstring\ze(\W|\_$)' conceal cchar=S
  syntax match Normal 'String\.' conceal cchar=S
  syntax match Normal 'String' conceal cchar=S
  " syntax match Normal 'Int\.' conceal cchar=I
  syntax match Normal '\vBoolean\ze(\W|\_$)' conceal cchar=B
  " syntax match Normal 'true' conceal cchar=𝗍
  " syntax match Normal 'false' conceal cchar=𝖿
  syntax match Normal 't\zsrue' conceal
  syntax match Normal 'f\zsalse' conceal

  " syntax match Normal 'List\ze\W' conceal cchar=⟬
  syntax match Normal 'List' conceal cchar=ˆ
  syntax match Normal 'Set\ze\W' conceal cchar=ʽ
  syntax match Normal 'Map\ze\W' conceal cchar=ʺ
  syntax match Normal 'empty' conceal cchar=∅
  syntax match Normal 'Iterable' conceal cchar=⟦
  syntax match Normal '::' conceal cchar=∷
  " syntax match Normal 'Array\ze\W' conceal cchar=⟦
  syntax match Normal 'Array' conceal cchar=A
  " syntax match Normal 'Tuple' conceal cchar=T
  " syntax match Normal 'tuple\:\s' conceal cchar=T
  " syntax match Normal 'tuple\:\[' conceal cchar=T

  " syntax match Normal "def\ze\s" conceal cchar=→
  syntax match Normal "def\s" conceal
  syntax match Normal 'Unit' conceal cchar=✴
  syntax match Normal 'Option' conceal cchar=∦
  syntax match Normal 'Either' conceal cchar=∥

  syntax match Normal "<-" conceal cchar=←
  " syntax match Normal "_\s<-\ze\s" conceal cchar=•
  syntax match Normal "_\ze\s*<-\s" conceal cchar= 

  syntax match Normal "()" conceal cchar=∘

  syntax match Normal "\v\=\>" conceal cchar=⇒

  " The collon before a type or an object value
  syntax match Normal "\w\zs:\ze\s" conceal
  syntax match Normal ")\zs:" conceal cchar=˃
  syntax match Normal "\s\zs:\ze(" conceal cchar=˃
  " When the type collon is the last char e.g. in enum defs
  syntax match Normal "\v:\ze$" conceal
  " syntax match Normal ")\s\zs=>\ze\s.*=>" conceal cchar=⇾

  syntax match Normal "^val\s" conceal
  syntax match Normal "\s\zsval\s" conceal

  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅
  syntax match Normal "\s\zss\"" conceal cchar="

  " TODO: can't match "export" twice? ~/Documents/Server-Dev/d_gql_edb/src/b_ramda_pipe_async_examples.ts#/export%20function%20ac
  " syntax match Normal "export\s\zsfunction\ze\s" conceal cchar=→
  syntax match Normal "\v\(\)\s\=\>" conceal cchar=ˍ
  syntax match Normal "\v_\s\=\>" conceal cchar=ˍ

  syntax match Normal '\s\zs>\ze\s' conceal cchar=▷
  syntax match Normal '\s\zs<\ze\s' conceal cchar=◁

  syntax match Normal 'i => {i' conceal cchar=_
  syntax match Normal 'i => i' conceal cchar=»
  syntax match Normal 'x => x\ze\s' conceal cchar=_
  syntax match Normal 'x => x\ze\.' conceal cchar=_

  syntax match Normal 'PartialFunction' conceal cchar=➔
  syntax match Normal "\v\-\>" conceal cchar=➔

  syntax match Normal '\vfor\ze(\W|\_$)' conceal cchar=⊃
  syntax match Normal 'yield' conceal cchar=⊂
  syntax match Normal '>>=' conceal cchar=⫦
  " andThen
  syntax match Normal '>>>' conceal cchar=↣
  " compose
  syntax match Normal '<<<' conceal cchar=∘
  syntax match Normal 'compose' conceal cchar=∘

  " syntax match Normal 'ZIO\ze\[' conceal cchar=ᴱ
  syntax match Normal 'ZIO' conceal cchar=ᴱ
  syntax match Normal 'UIO\ze\[' conceal cchar=ᴱ
  syntax match Normal 'IO\ze\[' conceal cchar=ᴱ
  syntax match Normal 'ZIO\.' conceal cchar=⁝
  syntax match Normal 'ZIO\.\$\.' conceal cchar=⁝
  syntax match Normal 'flatMap' conceal cchar=↣
  syntax match Normal 'collect\ze\W' conceal cchar=≚
  syntax match Normal 'collect\zeZ' conceal cchar=≚
  syntax match Normal 'collect\zeH' conceal cchar=≚
  " syntax match Normal 'collect' conceal cchar=ꜛ
  syntax match Normal 'Any' conceal cchar=װ
  syntax match Normal 'Nothing' conceal cchar=╌
  syntax match Normal 'Error' conceal cchar=⊖
  syntax match Normal 'Throwable' conceal cchar=⊖
  syntax match Normal 'fail' conceal cchar=⊖
  syntax match Normal 'Http' conceal cchar=ʜ
  syntax match Normal 'App\ze\W' conceal cchar=≡
  syntax match Normal 'ZIO.service' conceal cchar=⊟
  syntax match Normal 'package\ze\s' conceal cchar=⊟
  syntax match Normal 'package\ze\s' conceal cchar=⊟
  syntax match Normal 'live' conceal cchar=
  syntax match Normal 'live:' conceal cchar=
  syntax match Normal '\vLive(:)?' conceal cchar=
  syntax match Normal 'ZLayer' conceal cchar=﬘
  syntax match Normal 'ULayer' conceal cchar=﬘
  syntax match Normal 'Layer' conceal cchar=﬘
  syntax match Normal 'Method\.' conceal cchar=⁝
  syntax match Normal 'Request' conceal cchar=≻
  syntax match Normal 'Response' conceal cchar=≺
  syntax match Normal 'Random' conceal cchar=⌘
  syntax match Normal 'extends' conceal cchar=⟔

  syntax match Normal 'Exception' conceal cchar=◌
  " syntax match Normal 'IO\zeException' conceal cchar=⫠
  syntax match Normal 'IOException' conceal cchar=⊝

  syntax match Normal '"""' conceal cchar=❞

  syntax match Normal 'orElse' conceal cchar=◇
  syntax match Normal '<>' conceal cchar=◇
  syntax match Normal '*>' conceal cchar=▷
  syntax match Normal 'applyOrElse' conceal cchar=⇾
  syntax match Normal 'apply' conceal cchar=∝

  syntax match Normal 'if\ze\W' conceal cchar=˻
  syntax match Normal 'else' conceal cchar=˼
  syntax match Normal 'then' conceal cchar=˹
  syntax match Normal 'when' conceal cchar=?

  syntax match Normal 'case' conceal cchar=˰
  syntax match Normal 'match' conceal cchar=⌋

  syntax match Normal 'map' conceal cchar=➚
  syntax match Normal 'contramap' conceal cchar=↖
  syntax match Normal 'as\ze(' conceal cchar=ꜜ

  syntax match Normal 'self' conceal cchar=∝
  syntax match Normal 'override' conceal cchar=⟑
  syntax match Normal 'lazy' conceal cchar=~
  syntax match Normal 'final' conceal cchar=.
  syntax match Normal 'sealed' conceal cchar=.
  syntax match Normal 'private' conceal cchar=ˌ
  syntax match Normal 'private\sval\s' conceal cchar=ˌ
  syntax match Normal 'implicit' conceal cchar=𝑖
  syntax match Normal 'implicitly' conceal cchar=𝑖
  syntax match Normal 'import\s' conceal cchar=⁝
  syntax match Normal 'class' conceal cchar=C
  syntax match Normal 'case class' conceal cchar=˽
  syntax match Normal 'trait' conceal cchar=⟣
  syntax match Normal 'type\s' conceal
  syntax match Normal 'enum' conceal cchar=|
  syntax match Normal 'derive\ze\W' conceal cchar=⌇
  syntax match Normal 'object' conceal cchar=
  syntax match Normal 'make' conceal cchar=˖
  syntax match Normal 'succeed' conceal cchar=ꜜ

  syntax match Normal '\s\zs\.' conceal cchar=ˍ
  " syntax match Normal '\S\zs\.\ze\S' conceal cchar=ˍ
  " syntax match Normal '\.\ze\S' conceal cchar=ˍ
  syntax match Normal '\.\ze\S' conceal cchar= 

  syntax match Normal '\vA\ze(,|\]|\s\=\>)' conceal cchar=𝑎
  syntax match Normal '\vR\ze(,|\])' conceal cchar=𝑟
  syntax match Normal '\vE\ze(,|\])' conceal cchar=𝑒
  syntax match Normal '\vB\ze(,|\])' conceal cchar=𝑏
  syntax match Normal '\vC\ze(,|\])' conceal cchar=𝑐
  syntax match Normal '\vS\ze(,|\])' conceal cchar=𝑠
  syntax match Normal '\vT\ze(,|\]|\s\])' conceal cchar=𝑡
  syntax match Normal '\vV\ze(,|\])' conceal cchar=𝑣

" /**
"  * Accum the `produce`d values `T` until `p` holds.
"  */
  syntax match Normal '\v^\/\*\*' conceal cchar=⠃
  syntax match Normal '\v^\s\*\s' conceal
  syntax match Normal '\v^\s\*\/' conceal

  syntax match InlineTestDeclaration '\v^(lazy\s)?val\se\d_\i{-}\s\=' conceal cchar=‥
  " syntax match InlineTestDeclaration '\v^val\se\d_\i{-}\s\=\s' conceal cchar=⠃
  syntax match InlineTestDeclaration '\v^val\sa\d_\i{-}\s\=' conceal cchar=…

  syntax match Normal '\v\/\/\>\susing\slib\s' conceal



  " Hide comment character at beginning of line
  syntax match Normal '\v^\s*\zs\/\/\s' conceal
  " call matchadd('Conceal', '\v^\s*\zs#\s', 12, -1, {'conceal': ''})
  " call matchadd('Conceal', '\v^\s*\zs\/\/\s', 12, -1, {'conceal': ''})

  " This replaces: call CodeMarkupSyntaxHighlights()
  syntax match BlackBG '\v─(\^|\s)\s{2}\S.*'
  " Hilde \" before comment after code
  " call matchadd('Conceal', '\s\zs\#\ze\s', 12, -1, {'conceal': ''})
  " call matchadd('Conceal', '\s\zs\\/\/\ze\s', 12, -1, {'conceal': ''})
  " Conceal "%20" which is used for "h rel.txt" with space
  " call matchadd('Conceal', '%20', 12, -1, {'conceal': ' '})
  " call matchadd('Conceal', '#/', 12, -1, {'conceal': '|'})
  " ~/.vim/notes/notes-navigation.md#/Create%20hyperlink%20to

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  " set commentstring=\ \/\/%s

endfunc




