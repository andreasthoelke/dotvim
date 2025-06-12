
" v:lua.putt( v:lua.require("nvim-web-devicons").get_icon("toml") )


func! SmithySyntaxAdditions ()
  call clearmatches()

  " syntax match Normal '@\i*' conceal cchar=❈

  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅
  syntax match Normal "\v\S\zs:" conceal
  " syntax match Normal "{" conceal
  " syntax match Normal "}" conceal
  syntax match Normal "(" conceal cchar= 
  syntax match Normal ")" conceal
  syntax match Normal "\/\/\s" conceal

  syntax match Normal 'use\s' conceal cchar=⁝
  syntax match Normal 'namespace\ze\s' conceal cchar=⊟

  syntax match Normal '^service' conceal cchar=≡
  syntax match Normal '^structure' conceal cchar=˽
  syntax match Normal '^operation' conceal cchar=→
   " ⟄

  " syntax match Normal '\s\zswith\ze\s' conceal cchar=⊃
  " syntax match Normal '\s\zsas\ze\s' conceal cchar=⊂

  syntax match Normal 'input:' conceal cchar=⊃
  syntax match Normal 'output:' conceal cchar=⊂
  syntax match Normal 'errors:' conceal cchar=⊖

  syntax match Normal 'input :=' conceal cchar=⊃
  syntax match Normal 'output :=' conceal cchar=⊂

  syntax match Normal '@error' conceal cchar=⊖
  syntax match Normal 'Error' conceal cchar=⊖

  syntax match Normal 'version:' conceal cchar=𝑣

  syntax match Normal 'string' conceal cchar=s
  syntax match Normal 'String' conceal cchar=s
  syntax match Normal 'Integer' conceal cchar=ɪ
  syntax match Normal 'integer' conceal cchar=ɪ
  syntax match Normal '^list' conceal cchar=⟦
  syntax match Normal 'Boolean' conceal cchar=ʙ

  syntax match Normal '@idempotent' conceal cchar=𝑖
  syntax match Normal '@readonly' conceal cchar=𝑟
  syntax match Normal '@http' conceal cchar=ʜ
  syntax match Normal '@httpHeader' conceal cchar=^
  syntax match Normal '@httpQuery' conceal cchar=𝑞
  syntax match Normal '@simpleRestJson' conceal cchar=
  syntax match Normal 'method:\s' conceal
  syntax match Normal 'member:\s' conceal
  syntax match Normal 'uri:\s' conceal
  syntax match Normal 'code:\s' conceal

  syntax match Normal '@required' conceal cchar=.

  syntax match BlackBG '\v─(\^|\s)\s{2}\S.*'

  set conceallevel=2
  set concealcursor=ni

  " setlocal commentstring=\ \/\/%s
  " setlocal commentstring=//\ %s
endfunc




func! ScalaSyntaxAdditions ()

  call clearmatches()
  " return

  syntax match Normal "\v\=\=" conceal cchar=≡
  syntax match Normal "===" conceal cchar=≣
  " syntax match Normal "\s\zs\>\=\ze\s" conceal cchar=≥
  syntax match Normal "\v\+\+" conceal cchar=⧺
  syntax match Normal "\v\|\|" conceal cchar=‖
  syntax match Normal "\v\>\+\>" conceal cchar=»
  " syntax match Normal "\v\&\&" conceal cchar=﹠

  " syntax match Normal '\vInt\ze(\W|\_$)' conceal cchar=I
  " syntax match Normal '\vstring\ze(\W|\_$)' conceal cchar=s
  " syntax match Normal 'String\.' conceal cchar=s
  syntax match Normal 'String' conceal cchar=s
  syntax match Normal '\W\zsString' conceal cchar=s
  syntax match Normal '\v\W\zsInt\ze(\W|\_$)' conceal cchar=ɪ
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
  syntax match Normal 'NonEmptyList' conceal cchar=ᴻ

  " syntax match Normal '\v(py\.)?Dynamic\.global\.' conceal cchar=⠃
  " syntax match Normal 'py_' conceal cchar=⠃
  " syntax match Normal 'py\ze\"' conceal cchar=⠃
  " syntax match Normal 'py\.module' conceal cchar=𝑖

  " protoquill:
  syntax match Normal 'lift' conceal cchar=ᴵ

  syntax match Normal '\v(py\.)?Dynamic\.global\.' conceal cchar=⁝
  syntax match Normal 'py_' conceal cchar=ᴵ
  syntax match Normal 'kyo' conceal cchar=𝑘
  syntax match Normal 'Py_' conceal cchar=ᴵ
  syntax match Normal 'py\ze\"' conceal cchar=⁝
  syntax match Normal 'py\.eval' conceal cchar=⁝
  " syntax match Normal '\.\zsas\ze\[' conceal cchar=⁝
  syntax match Normal 'py\.module' conceal cchar=𝑖
  syntax match Normal 'py\.\`with\`' conceal cchar=⊃
  " syntax match Normal '\.bracketAccess' conceal cchar=⟦
  " syntax match Normal '\.bracketUpdate' conceal cchar=⟦

  " syntax match Normal '\.toPythonProxy' conceal cchar=‹


  " syntax match Normal '\.toPythonCopy' conceal cchar=‹
  " syntax match Normal '\v\s\zspy\ze(\W|\_$)' conceal cchar=𝑝
  " syntax match Normal '\vSeq\ze(\W|\_$)' conceal cchar=ᵛ
  " syntax match Normal '\vSet\ze(\W|\_$)' conceal cchar=ᴺ
  syntax match Normal '\v\s\zsSet\ze(\W|\_$)' conceal cchar=ᴺ
  syntax match Normal '\vArray\ze(\W|\_$)' conceal cchar=ᴬ
  syntax match Normal 'Map\ze\W' conceal cchar=ʺ
  syntax match Normal 'empty' conceal cchar=∅
  syntax match Normal 'Empty' conceal cchar=∅
  syntax match Normal 'Iterable' conceal cchar=⟦
  " syntax match Normal 'Array\ze\W' conceal cchar=⟦
  " syntax match Normal 'Tuple' conceal cchar=T
  " syntax match Normal 'tuple\:\s' conceal cchar=T
  " syntax match Normal 'tuple\:\[' conceal cchar=T

  " syntax match Normal "def\ze\s" conceal cchar=→
  syntax match Normal "def\s" conceal
  syntax match Normal 'unit' conceal cchar=✴
  syntax match Normal 'void' conceal cchar=✴
  syntax match Normal 'Unit' conceal cchar=✴

  syntax match Normal "<-" conceal cchar=←
  " syntax match Normal "<--" conceal cchar=←
  syntax match Normal "<--" conceal cchar=⊂
  syntax match Normal "\v\--\>" conceal cchar=⊃
  " syntax match Normal "_\s<-\ze\s" conceal cchar=•
  " syntax match Normal "_\ze\s*<-\s" conceal cchar= 
 " ⟄  ⟃
  syntax match Normal "()" conceal cchar=∘
  syntax match Normal "():" conceal

  syntax match Normal "\v\=\>" conceal cchar=⇒

  " The collon before a type or an object value
  " syntax match Normal "\w\zs:\ze\s" conceal
  " When the type collon is the last char e.g. in enum defs
  syntax match Normal "\v:\ze$" conceal
  " all :?
  " syntax match Normal ":" conceal
  syntax match Normal "\v\S\zs:" conceal
  syntax match Normal ")\zs:" conceal cchar=˃
  syntax match Normal "\s\zs:\ze(" conceal cchar=˃
  " syntax match Normal ")\s\zs=>\ze\s.*=>" conceal cchar=⇾
  syntax match Normal '::' conceal cchar=∷
  " syntax match Normal ':=' conceal cchar=⠃
  syntax match Normal ':=\s' conceal
  syntax match Normal ':::' conceal cchar=☷
  syntax match Normal '=>>' conceal cchar=⋗

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
  syntax match Normal 'Function0' conceal cchar=➔
  syntax match Normal 'Function1' conceal cchar=➔
  syntax match Normal 'Function2' conceal cchar=➔
  syntax match Normal 'Function1:' conceal cchar=➔
  syntax match Normal "\v\-\>" conceal cchar=➔
  syntax match Normal '@tailrec' conceal cchar=↵
  syntax match Normal 'inline' conceal cchar=⇐

  " syntax match Normal 'div' conceal cchar=⋮
  syntax match Normal 'Element' conceal cchar=⟃
  " syntax match Normal 'children' conceal cchar=⋿
  syntax match Normal 'children' conceal cchar=ᴟ
  syntax match Normal 'unsafeChild' conceal cchar=ᴟ


  syntax match Normal '\s\zs@\i*' conceal cchar=❈
  syntax match Normal '@query' conceal cchar=𝑞
  syntax match Normal 'uri\ze\"' conceal cchar=⁝

  syntax match Normal '\vfor\ze(\W|\_$)' conceal cchar=⊃
  syntax match Normal 'yield' conceal cchar=⊂
  syntax match Normal '>>=' conceal cchar=⫦
  " andThen
  syntax match Normal 'chain' conceal cchar=⋊
  syntax match Normal 'andThen' conceal cchar=⫕
  " syntax match Normal 'Then' conceal cchar=˃
  " syntax match Normal 'and\zeT' conceal cchar=∧
  syntax match Normal '>>>' conceal cchar=↣
  " compose
  syntax match Normal '<<<' conceal cchar=∘
  " syntax match Normal 'compose' conceal cchar=∘

  " syntax match Normal 'ZIO\ze\[' conceal cchar=ᴱ
  syntax match Normal 'ZIO' conceal cchar=♽
  syntax match Normal 'RIO' conceal cchar=♽
  syntax match Normal 'UIO\ze\[' conceal cchar=♽
  syntax match Normal 'IO\ze\[' conceal cchar=♽
  syntax match Normal 'IO\ze\]' conceal cchar=♽
  syntax match Normal '\[\zsIO' conceal cchar=♽
  " syntax match Normal 'ZIO\.' conceal cchar=⁝
  " syntax match Normal 'ZIO\.\$\.' conceal cchar=⁝
  syntax match Normal 'flatMap' conceal cchar=↣
  syntax match Normal 'flatMap:' conceal cchar=↣
  syntax match Normal 'WithZIO' conceal cchar=↣
  " syntax match Normal 'tap\ze\W' conceal cchar=⌄
  " syntax match Normal 'collect\ze\W' conceal cchar=≚
  " syntax match Normal 'collect\zeZ' conceal cchar=≚
  " syntax match Normal 'collect\zeH' conceal cchar=≚
  " syntax match Normal 'collect' conceal cchar=ꜛ
  syntax match Normal 'Any' conceal cchar=װ
  syntax match Normal 'Nothing' conceal cchar=╌
  syntax match Normal '\vError(:)?' conceal cchar=⊖
  syntax match Normal 'Throwable' conceal cchar=⊡
  syntax match Normal 'fail\ze\W' conceal cchar=⊖
  syntax match Normal 'Http' conceal cchar=ʜ
  " syntax match Normal '\vApp(:)?' conceal cchar=≡
  syntax match Normal 'ZIO.service' conceal cchar=≡
  syntax match Normal 'package\ze\s' conceal cchar=⊟

  syntax match Normal 'Var\ze\W' conceal cchar=≀
  syntax match Normal 'signal' conceal cchar=⬿
  " syntax match Normal '\vSignal(:)?' conceal cchar=~
  syntax match Normal '\vSignal(:)?' conceal cchar=⋞
  syntax match Normal '\vObserver(:)?' conceal cchar=⋟
  syntax match Normal 'SignallingRef' conceal cchar=≈
  syntax match Normal '\W\zs\Stream' conceal cchar=⋻
  syntax match Normal 'through' conceal cchar=↷
  syntax match Normal 'combineWithFn' conceal cchar=◇

  " Kyo direct style
  syntax match Normal "defer\ze\:" conceal cchar=•
  syntax match Normal "await\ze\:" conceal cchar=≀


  syntax match Normal 'IOs' conceal cchar=♽
  syntax match Normal '\vLive(:)?' conceal cchar=≈
  syntax match Normal 'ZLayer' conceal cchar=⊟
  syntax match Normal 'Envs' conceal cchar=≣
  syntax match Normal '\vLayer\ze\F' conceal cchar=⋞
  " syntax match Normal '\vFinal\ze\[' conceal cchar=⋮
  syntax match Normal '\vFinal\[' conceal cchar=|
  syntax match Normal '\vFinal\:' conceal cchar=|
  syntax match Normal '\vFinal\ze\.' conceal cchar=|
  syntax match Normal '\vFinal\ze(\s|\_$)' conceal cchar=|
  " syntax match Normal '\vLayerFinal\ze\[' conceal cchar=⋞
  " syntax match Normal '\v\]\.\zslayer\:' conceal cchar=⋞
  syntax match Normal '\vlayer\:' conceal cchar=⋞
  syntax match Normal '\vlayer\ze(\s|\_$)' conceal cchar=⋲
  syntax match Normal '\vval layer\:' conceal cchar=⋲
  syntax match Normal '\vlayer\zeF' conceal cchar=⋲
  syntax match Normal '\v\i\zslayer' conceal cchar=⋲
  syntax match Normal '\v\i\zsLayer' conceal cchar=⋲
  syntax match Normal '\v\s\zsLayer\ze\[' conceal cchar=⋞

  " syntax match Normal "===" conceal cchar=≣
  " syntax match Normal 'live\ze\s' conceal cchar=≈
  " syntax match Normal 'live' conceal cchar=≈
  " syntax match Normal 'live:' conceal cchar=⬿

  syntax match Normal 'Resource' conceal cchar=⊟
  syntax match Normal 'Resources' conceal cchar=ѱ
  syntax match Normal 'ULayer' conceal cchar=⊟
  " syntax match Normal '\vLayer(:)?' conceal cchar=⊟
  syntax match Normal 'fromFunction' conceal cchar=˽
  " syntax match Normal 'ULayer' conceal cchar=﬘
  " syntax match Normal 'Layer' conceal cchar=﬘
  syntax match Normal 'Method\.' conceal cchar=⁝
  syntax match Normal '\vRequest(s)?' conceal cchar=≻
  syntax match Normal 'Response' conceal cchar=≺
  syntax match Normal '\vRandom(s)?' conceal cchar=⌘
  syntax match Normal 'extends' conceal cchar=⟔
  syntax match Normal 'with' conceal cchar=⟔
  " syntax match Normal 'with\ze(\s|\_$)' conceal cchar=⟔

  syntax match Normal 'Nil' conceal cchar=◻
  syntax match Normal 'None' conceal cchar=≢
  syntax match Normal 'Some' conceal cchar=≡
  syntax match Normal 'some' conceal cchar=≡
  syntax match Normal 'Option' conceal cchar=≟
  syntax match Normal 'Options' conceal cchar=≟
  syntax match Normal 'Aborts\ze\W' conceal cchar=∥
  syntax match Normal 'Either' conceal cchar=∥

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
  syntax match Normal '\vapply(:)?' conceal cchar=∝

  syntax match Normal '\s\zsif\ze\W' conceal cchar=˻
  syntax match Normal 'else' conceal cchar=˺
  syntax match Normal 'else\sif' conceal cchar=˼
  " syntax match Normal 'then\ze(\W|\_$)' conceal cchar=˹
  syntax match Normal '\v(\s|^)\zsthen\ze(\s|\_$)' conceal cchar=˹
  " syntax match Normal 'when' conceal cchar=?

  syntax match Normal 'case' conceal cchar=˰
  syntax match Normal '\vmatch\ze(\W|\_$)' conceal cchar=⌋

  syntax match Normal '\.\zsmap' conceal cchar=➚
  syntax match Normal 'mapTo\:' conceal cchar=↓
  syntax match Normal 'mapTo' conceal cchar=↓
  syntax match Normal 'mapToValue' conceal cchar=↓
  syntax match Normal 'map\:' conceal cchar=➚
  " syntax match Normal '\(\#.*\)\@<!filter' conceal cchar=⇡
  syntax match Normal '\vfilter\ze\W' conceal cchar=⇡
  syntax match Normal 'contramap' conceal cchar=↖
  syntax match Normal '\.\zsas\ze(' conceal cchar=ꜜ
  syntax match Normal '\veach(\:)?' conceal cchar=✴
  syntax match Normal 'for\zee' conceal cchar=↗
  syntax match Normal '\vlMap(\:)?' conceal cchar=∘
  syntax match Normal 'eva\zelM' conceal cchar=↗
  syntax match Normal 'map\zeE' conceal cchar=↗


  " Refs
  " syntax match Normal 'getAndUpdate' conceal cchar=➚
  syntax match Normal 'getAn' conceal cchar=‹
  syntax match Normal 'dUpdate' conceal cchar=✴
  syntax match Normal 'mo\zedify' conceal cchar=↤
  " syntax match Normal 'Mo\zedify' conceal cchar=↤
  syntax match Normal 'dify' conceal cchar=✴
  syntax match Normal 'enqueue' conceal cchar=«
  syntax match Normal 'dequeue' conceal cchar=»
  syntax match Normal 'complete\ze(\W)' conceal cchar=⟢
  " syntax match Normal '\vget\ze(\W|\_$)' conceal cchar=⟡

  syntax match Normal '\vself(:)?' conceal cchar=∝
  syntax match Normal 'withSelf\:' conceal cchar=⟄
  syntax match Normal 'this' conceal cchar=∝
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
  syntax match Normal 'given' conceal cchar=∘
  syntax match Normal 'extension' conceal cchar=𝑒
  syntax match Normal 'import\s' conceal cchar=⁝
  syntax match Normal 'class\ze\s' conceal cchar=□
  syntax match Normal 'case class' conceal cchar=˽
  syntax match Normal 'case object' conceal cchar=˾
  syntax match Normal 'copy\ze\W' conceal cchar=˽
  syntax match Normal '\vcopy(:)?' conceal cchar=˽
  syntax match Normal 'trait' conceal cchar=⟣
  syntax match Normal '^type\s' conceal
  syntax match Normal 'type' conceal cchar=𝑡
  syntax match Normal 'enum' conceal cchar=|
  syntax match Normal 'derive\ze\W' conceal cchar=⌇
  " syntax match Normal 'object' conceal cchar=⟯
  syntax match Normal 'object' conceal cchar=˪
  " syntax match Normal 'make' conceal cchar=˖
  syntax match Normal 'unbounded' conceal cchar=˖
  syntax match Normal 'succeed' conceal cchar=ꜜ

  syntax match Normal 'spec\ze\W' conceal cchar=

  syntax match Normal '\s\zs\.' conceal cchar=ˍ
  " syntax match Normal '\S\zs\.\ze\S' conceal cchar=ˍ
  " syntax match Normal '\.\ze\S' conceal cchar=ˍ
  syntax match Normal '\.\ze\S' conceal cchar= 

  syntax match Normal 'curried' conceal cchar=‹

  syntax match Normal '\.toPythonProxy' conceal cchar=≀
  syntax match Normal '\.toPythonCopy' conceal cchar=≀
  syntax match Normal '\.as\ze\[' conceal cchar=⁝
  syntax match Normal '\.bracketAccess' conceal cchar=⠰
  syntax match Normal '\.bracketUpdate' conceal cchar=ꜜ


  " display Type variables as small cursive letters
  " syntax match Normal '\v(\s|\(|\[|(\+|\-))\zsU\ze(:|,|\]|\)|\_$|\s\=\>|\s*(\>|\<|\=|\/))' conceal cchar=𝑢
  " syntax match Normal '\v(\s|\(|\[|(\+|\-))\zsK\ze(:|,|\]|\)|\_$|\s\=\>|\s*(\>|\<|\=|\/))' conceal cchar=𝑘

  syntax match Normal '\[\zsF\ze\W' conceal cchar=𝑣
  syntax match Normal 'F\ze\[' conceal cchar=𝑣

  " syntax match Normal '\s\zsA\ze\*' conceal cchar=𝑎
  " syntax match Normal '\s\zsR\ze\*' conceal cchar=𝑟

  " TODO: can somehow not match this properly
  " syntax match Normal ': \A$' conceal cchar=𝑎
  " syntax match Normal ': \zsB$' conceal cchar=𝑏

  syntax match Normal '@js.native' conceal cchar=𝑗
  syntax match Normal 'JSImport\.Default' conceal cchar=𝑑
  syntax match Normal 'JSImport\.Namespace' conceal cchar=𝑛
  " syntax match Normal '@JSImport' conceal cchar=𝑖
  " syntax match Normal 'js\.Object' conceal cchar=J
  syntax match Normal 'js\.Object' conceal cchar=

  syntax match InlineTestDeclaration '\v^(\s\s)?\zs(lazy\s)?val\se\d(\d)?_\i{-}\s\=' conceal cchar=‥
  " syntax match InlineTestDeclaration '\v^val\se\d_\i{-}\s\=\s' conceal cchar=⠃
  " syntax match InlineTestDeclaration '\v^val\sa\d_\i{-}\s\=' conceal cchar=…

  syntax match Normal '\v\/\/\>\susing\slib\s' conceal

  " Hide comment character at beginning of line
  " syntax match Normal '\v\s*\zs\/\/\s' conceal
  " syntax match Comment '\v\s\zs\/\/.*'
  " syntax match BlackBG '\v\/\/' conceal
  " syntax match Comment '\v\/\/\s\zs.*'
  " syntax match BlackBG '\v\/\/\s\zsi{-}'

  " This is effective in preventing the conceal unicode in normal comments
  " TODO: BUT .. it also breaks match pairs! here: .query(varchar * int2)
  syntax match Comment '\v\/\/\s\zs.*'
  syntax match Comment '\v^\s\*\s\zs\zs.*'

  " TODO: this case doesn't 'unmatch' the conceals in the comment. seems minor.
  " /** Decomposes the `NonEmptyList` into an element and a (possibly empty) `List` */
  " syntax match Comment '\v\*\*\zs\zs.*'

  " Only matchadd can coneal the comment chars when those are already match by the above syntax match!
  call matchadd('Conceal', '\/\/\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '\p\s\zs\/\/', 12, -1, {'conceal': '⠃'})
  call matchadd('Conceal', '^\/\/\s', 12, -1, {'conceal': ''})

  " syntax match scalaSignal '\v\s\zs\w{-}S\ze(\W|\_s|:)'
  " call matchadd('scalaSignal', '\v\s\zs\w{-}S\ze(\W|\_s)', 12, -1)
  " Note the \U non uppercase char to exclude all caps var names. w{1,} mandates at least 1 word character
  " example
  " private val currentFilterModeV = Var[FtrMode]( FtrMode.ShowAll )
  " note that \w{1,}\l{1,]}  allows camelCasing before the V
  call matchadd('scalaVar',    '\v(\(|\s)\zs\w{1,}\l{1,}V\ze(\W|\_s)', 12, -1)
  call matchadd('scalaSignal', '\v(\(|\s)\zs\w{1,}\l{1,}S\ze(\W|\_s)', 12, -1)
  call matchadd('scalaChannelBus', '\v(\(|\s)\zs\w{1,}\l{1,}(C|B|O)\ze(\W|\_s)', 12, -1)

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
  " this is for doc comments that are indented. while preventing to affect multiplication e.g. 3 * 4
  call matchadd('Conceal', '\v\s\zs\s\*\s', 12, -1, {'conceal': ''})
  syntax match Normal '\v\s\*\/' conceal

  " syntax region InnerSql matchgroup=InnerSqlGr start='sql"""' end='"""' contains=String

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
  " Correct setting of the scala and sbt commentstring:
  set commentstring=\ \/\/%s

  " setl isk+=<,>,$,#,+,-,*,/,%,&,=,!,:,124,~,?,^
  setl isk+=?

  " this is also set as global
  setlocal foldmarker=\ ■,\ ▲
  set foldmethod=marker

endfunc


