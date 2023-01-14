
" ↔ ↕ ⇿ ⟷
" ɪ и ᵓᵔ ᵛ     ->    ⃣
" ➔  ⇾  →  ˃ ➟ ⇢ ˲ ↗ → →   ˷ ˍˍ ˳     ⟣ ◦ פּ ﬘   璘
" ⇛ ≈ ⊪ ⊩ ⊧ ⤎ ⫻ ⫽‹› ※ ∟ ⧽ ⨞ ⭢   ↤ ↣
" ⊎ ˽ ⊔ ⩅ u  ͭ ͨ  ૧ח  ૰ ˅ ⌄ ˯ ↡ ↧ ≏ ⊽ ⋓ ≗ ∿ ∾  ≀ ≁ ➳  ➺  ➽
" ⊟  ⊡ | ⊖  ⊙ ▲ ʲ ʳ ʺ ʽʹ ˂ ˄ ˆ ˌ ˓ ₊˖⁺﹢+ ˠ ˡ ˣ ˶ ˽  ᴺ ᵀ ᵈ ᵑ ᵓ ʺ 
" ”  ⍘ ’ ⍞  ⍣ ⍤⍦⍪⍳ ⍽ ⍿ ⎅ ⎇  ⎎ ⎚
" ➔  ⇾  →  ˃ ➟ ⇢ ˲ ↗ → →   ˷ ˍˍ ˳     ⟣ ◦ פּ ﬘   璘
" « » « ˝ ˚ ˙ ⧧˖͜ ͝˘˟ˢˡˤ˳ ╎𝑎 α β  ⟯⟮⟦╌ ∥,a͡,b, e ͢ e  װ ∗ ⇣ ⇨ ⇢ 
" ⁝ ⁇‼  ⃪ ⁞  ⃩⁽⁵⁾ ⃦ ⃟  e⃨  ⊍ ⊐ ⊔ ⊝ ⊟
" ↻  ↶ ↷ ⇵ ⇠ ⇽ |⇾| ⇿ ∩ ∴ ∹  ≀ ∿  ≻  ⊂ ʀ ɢ ᴳ ɍ  ͬr⊃ ᴅ 𝑑 ⊆  ⊇ ≓ 
" ⋮ ⌇ ⌒  ⌔  ⌗ ⌘✱〈  ˻ˌ¨ ⊟  ⊡ | ⊖  ⊙
" ⋋  ⋐  ⋘  ⋯  ⌘ ∘   ☾  ♽ ♺   ☳     ⚐ ⚀   ∟  ∩        𝑟S  ʀS
" ˃ ˲  ˲ ˿  ͐ ͢  ⃗  ⃯  →   ↘   ↗   ↣  ➙ ⇧ ⇡ ⇑ ↥↥  ➔ ➚  ➟  ➢ ➝  ➩  ➲ 
" ➳  ➽  ⟀  ⟄  ⟃  ⟔  ⟥  ⟣ ⌁  →  ⃯  ˃ ˪ ⑆ 𝌅 𝌀 ⋔ ⋕ ⋗ ⋲ ⋳ ⋵ ⋷ ⋺ ⋿ ⌇
" ⑂ ⑃ ⑄ ⫙ ⫗ ⫕ ⫖ ⫐ ⫴ ⫝
" ⟛   ⟩ ⟫  ⟯  ⟶   ⧵ ⠰ ⠂⠇ ⠃ ⠈ ⠁ ⠌  ﹚ ﹜ ⭡   ￪ ↑ ꜛ ᐨ ☉⊙⊙◎⊖  ⊘ ⫞ 
" ◌  ●  ◎  ◘  ◦ ◫  ◯  ▿ ▸ ▭  ▪  ▫  ▬  ▢  □ ▗   ◖  ☉  •⋆• ▪
" ◆  ◇  ◈  ◻  ◽  ☀  ☼  ٭  ⋆ ★  ☆  ✷✴  ✱ ❂ ❈  ♽
" ➔  ⇾  →  ˃ ➟ ⇢ ˲ ↗ → →   ˷ ˍˍ ˳ Ɛ  𝑓 𝑡ƒ ɱ ᙆ ｔ ᵀᴵᴺ ɴ ɳ ᴟ

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
  " syntax match Normal '\vstring\ze(\W|\_$)' conceal cchar=s
  syntax match Normal 'String\.' conceal cchar=s
  syntax match Normal 'String' conceal cchar=s
  syntax match Normal 'Int' conceal cchar=ɪ
  " syntax match Normal 'Int\.' conceal cchar=ɪ
  syntax match Normal '\vBoolean\ze(\W|\_$)' conceal cchar=ʙ
  " syntax match Normal 'true' conceal cchar=𝗍
  " syntax match Normal 'false' conceal cchar=𝖿
  syntax match Normal 't\zsrue' conceal
  syntax match Normal 'f\zsalse' conceal

  " syntax match Normal 'List\ze\W' conceal cchar=⟬
  syntax match Normal '\vList\ze(\W|\_$)' conceal cchar=˄
  " syntax match Normal '\vSeq\ze(\W|\_$)' conceal cchar=˅
  syntax match Normal '\vSeq\ze(\W|\_$)' conceal cchar=ᵘ
  " syntax match Normal '\vSeq\ze(\W|\_$)' conceal cchar=ᵛ
  syntax match Normal '\vSet\ze(\W|\_$)' conceal cchar=ᴺ
  syntax match Normal '\vArray\ze(\W|\_$)' conceal cchar=ᴬ
  syntax match Normal 'Map\ze\W' conceal cchar=ʺ
  syntax match Normal 'empty' conceal cchar=∅
  syntax match Normal 'Iterable' conceal cchar=⟦
  " syntax match Normal 'Array\ze\W' conceal cchar=⟦
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
  " all :?
  syntax match Normal ":" conceal
  " syntax match Normal ")\s\zs=>\ze\s.*=>" conceal cchar=⇾
  syntax match Normal '::' conceal cchar=∷

  syntax match Normal "^val\s" conceal
  syntax match Normal "\s\zsval\s" conceal

  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅
  syntax match Normal "\s\zss\"" conceal cchar="

  " TODO: can't match "export" twice? ~/Documents/Server-Dev/d_gql_edb/src/b_ramda_pipe_async_examples.ts#/export%20function%20ac
  " syntax match Normal "export\s\zsfunction\ze\s" conceal cchar=→
  " syntax match Normal "\v\(\)\s\=\>" conceal cchar=ˍ
  " syntax match Normal "\v_\s\=\>" conceal cchar=ˍ

  " syntax match Normal '\s\zs>\ze\s' conceal cchar=▷
  " syntax match Normal '\s\zs<\ze\s' conceal cchar=◁

  " syntax match Normal 'i => {i' conceal cchar=_
  " syntax match Normal 'i => i' conceal cchar=»
  " syntax match Normal 'x => x\ze\s' conceal cchar=_
  " syntax match Normal 'x => x\ze\.' conceal cchar=_

  syntax match Normal 'PartialFunction' conceal cchar=➔
  syntax match Normal "\v\-\>" conceal cchar=➔
  syntax match Normal '@tailrec' conceal cchar=↶

  syntax match Normal '\vfor\ze(\W|\_$)' conceal cchar=⊃
  syntax match Normal 'yield' conceal cchar=⊂
  syntax match Normal '>>=' conceal cchar=⫦
  " andThen
  syntax match Normal 'andThen' conceal cchar=↣
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
  syntax match Normal 'tap' conceal cchar=⌄
  " syntax match Normal 'tap' conceal cchar=≏
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
  syntax match Normal 'fromFunction' conceal cchar=≻
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
  syntax match Normal 'orDie' conceal cchar=╌
  syntax match Normal 'fork' conceal cchar=☼
  syntax match Normal '<>' conceal cchar=◇
  " syntax match Normal '\v\*\>' conceal cchar=▷
  call matchadd('Conceal', '\v\*\>', 12, -1, {'conceal': '▷'})
  syntax match Normal 'applyOrElse' conceal cchar=⇾
  syntax match Normal 'apply' conceal cchar=∝

  syntax match Normal 'if\ze\W' conceal cchar=˻
  syntax match Normal 'else' conceal cchar=˼
  syntax match Normal 'else\sif' conceal cchar=˼
  syntax match Normal 'then\ze\W' conceal cchar=˹
  syntax match Normal 'when' conceal cchar=?

  syntax match Normal 'case' conceal cchar=˰
  syntax match Normal '\vmatch\ze(\W|\_$)' conceal cchar=⌋

  syntax match Normal 'map' conceal cchar=➚
  syntax match Normal 'contramap' conceal cchar=↖
  syntax match Normal '\.\zsas\ze(' conceal cchar=ꜜ

  syntax match Normal 'self' conceal cchar=∝
  syntax match Normal 'override' conceal cchar=⟑
  syntax match Normal 'lazy' conceal cchar=~
  syntax match Normal 'final' conceal cchar=.
  syntax match Normal 'sealed' conceal cchar=.
  syntax match Normal 'private' conceal cchar=ˌ
  syntax match Normal 'private\sval\s' conceal cchar=ˌ
  syntax match Normal 'implicit' conceal cchar=𝑖
  syntax match Normal 'infix' conceal cchar=𝑖
  syntax match Normal 'implicitly' conceal cchar=𝑖
  syntax match Normal 'using' conceal cchar=⊨
  syntax match Normal 'extension' conceal
  syntax match Normal 'import\s' conceal cchar=⁝
  syntax match Normal 'class' conceal cchar=C
  syntax match Normal 'case class' conceal cchar=˽
  syntax match Normal 'copy\ze\W' conceal cchar=˽
  syntax match Normal 'trait' conceal cchar=⟣
  syntax match Normal 'type\s' conceal
  syntax match Normal 'enum' conceal cchar=|
  syntax match Normal 'derive\ze\W' conceal cchar=⌇
  syntax match Normal 'object' conceal cchar=
  syntax match Normal 'make' conceal cchar=˖
  syntax match Normal 'unbounded' conceal cchar=˖
  syntax match Normal 'succeed' conceal cchar=ꜜ

  syntax match Normal '\s\zs\.' conceal cchar=ˍ
  " syntax match Normal '\S\zs\.\ze\S' conceal cchar=ˍ
  " syntax match Normal '\.\ze\S' conceal cchar=ˍ
  syntax match Normal '\.\ze\S' conceal cchar= 

  syntax match Normal 'curried' conceal cchar=‹

  " display Type variables as small cursive letters
  syntax match Normal '\v(\s|\(|\[|\+)\zsA\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑎
  syntax match Normal '\v(\s|\(|\[|\+)\zsR\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑟
  syntax match Normal '\v(\s|\(|\[|\+)\zsE\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑒
  syntax match Normal '\v(\s|\(|\[|\+)\zsB\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑏
  syntax match Normal '\v(\s|\(|\[|\+)\zsC\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑐
  syntax match Normal '\v(\s|\(|\[|\+)\zsS\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑠
  syntax match Normal '\v(\s|\(|\[|\+)\zsT\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑡
  syntax match Normal '\v(\s|\(|\[|\+)\zsV\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑣
  syntax match Normal '\v(\s|\(|\[|\+)\zsU\ze(:|,|\]|\)|\s\=\>|\s(\>|\<|\=))' conceal cchar=𝑢


  syntax match InlineTestDeclaration '\v^(lazy\s)?val\se\d_\i{-}\s\=' conceal cchar=‥
  " syntax match InlineTestDeclaration '\v^val\se\d_\i{-}\s\=\s' conceal cchar=⠃
  syntax match InlineTestDeclaration '\v^val\sa\d_\i{-}\s\=' conceal cchar=…

  syntax match Normal '\v\/\/\>\susing\slib\s' conceal

  " Hide comment character at beginning of line
  " syntax match Normal '\v\s*\zs\/\/\s' conceal
  " syntax match Comment '\v\s\zs\/\/.*'
  " syntax match BlackBG '\v\/\/' conceal
  " syntax match Comment '\v\/\/\s\zs.*'
  " syntax match BlackBG '\v\/\/\s\zsi{-}'

  " This is effective in preventing the conceal unicode in normal comments
  syntax match Comment '\v\/\/\s\zs.*'

  " Only matchadd can coneal the comment chars when those are already match by the above syntax match!
  call matchadd('Conceal', '\/\/\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '\p\s\zs\/\/', 12, -1, {'conceal': '⠃'})
  call matchadd('Conceal', '^\/\/\s', 12, -1, {'conceal': ''})

  " This uses the same approach for the Java-Doc comments:
  " this line overwrites the unicode conceals
  " ISSUE: does it? .. it affected/prevented conceals after a multiplication (*) on normal lines
  " syntax match Comment '\v\*.*'

" /**
"  * Accum the `produce`d values `T` until `p` holds.
"  */
  syntax match Normal '\v\/\*\*' conceal cchar=⠃
  " .. we can't use a normal syntax match to conceal the comment chars
  " syntax match Normal '\v\s\*\s' conceal
  " but use matchadd instead
  call matchadd('Conceal', '\v^\s\*\s', 12, -1, {'conceal': ''})
  syntax match Normal '\v\s\*\/' conceal


  " call matchadd('BlackBG', '\v\*.*', 12, -1 )

  " call matchadd('Conceal', '\s\/\/', 12, -1, {'conceal': ''})
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


