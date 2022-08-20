augroup ag
  au!
augroup end

" ─   Filetype Specific Maps Tools Syntax               ──
au ag BufNewFile,BufRead,WinNew *.hs call HaskellSyntaxAdditions()
au ag BufNewFile,BufRead        *.hs call HaskellMaps()

au ag BufNewFile,BufRead,WinNew *.purs call HaskellSyntaxAdditions()
" au ag BufNewFile,BufReadPost,WinNew *.res,*.mli call RescriptSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.res,*resi,*.mli,*ml call RescriptSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.jsx,*.js,*.ts,*.tsx,*mjs,*.json call JsSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.esdl,*edgeql call EdgeQLSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.graphql call GraphQLSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.sql call SQLSyntaxAdditions()


" au ag BufNewFile,BufRead *.purs setfiletype purescript
" this is now moved to ftdetect folder - not sure if this is needed
" ~/.vim/ftdetect/purescript.vim#/au%20BufNewFile,BufRead%20*.purs
au ag BufNewFile,BufRead        *.purs call HaskellMaps()

au ag BufNewFile,BufRead,WinNew *.lua call LuaSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.py call PythonSyntaxAdditions()

" au ag BufNewFile,BufRead,WinNew *.vim,*.vimrc call VimScriptSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.md          call MarkdownSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.zshrc       call CodeMarkupSyntaxHighlights()
" au ag BufNewFile,BufRead        *.vim,*.vimrc call VimScriptMaps()
" ─^  Filetype Specific Maps Tools Syntax               ──


" ─   Syntax Color                                     ──

" This defines the color of the cchar
" hi! Conceal guibg=#000000
hi! link Conceal Operator


func! HaskellTools()
  " call haskellenv#start()
  " TODO test these
  " call vim2hs#haskell#editing#includes()
  " call vim2hs#haskell#editing#keywords()
  " call vim2hs#haskell#editing#formatting()
endfunc


nnoremap <leader>cm :call clearmatches()<cr>


func! SQLSyntaxAdditions()
  call tools_db#bufferMaps()
  call clearmatches()

  set conceallevel=2
  set concealcursor=ni
  set commentstring=\#%s

  syntax match Normal "->" conceal cchar=→
  syntax match Normal "::" conceal cchar=|
  syntax match Normal ":=" conceal cchar=⫶

  call matchadd('BlackBG', '\v("|--|//|#)\s─(\^|\s)\s{2}\S.*', 11, -1 )
  call matchadd('Conceal', '"""', -1, -1, {'conceal': ''})
  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})
endfunc



func! EdgeQLSyntaxAdditions() " ■
  call tools_edgedb#bufferMaps()

  call clearmatches()
  set conceallevel=2
  set concealcursor=ni

  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})
  syntax match Normal "->" conceal cchar=→
  syntax match Normal "::" conceal cchar=|
  syntax match Normal ":=" conceal cchar=⫶
  set commentstring=\#%s

endfunc " ▲

func! RescriptSyntaxAdditions()
  call tools_rescript#bufferMaps()

  set textwidth=0

  call clearmatches()

  " call TsConcealWithUnicode()


  syntax match Normal "\v\=\>" conceal cchar=⇒
  " syntax match Normal "\v\-\>" conceal cchar=→
  syntax match Normal "\v\-\>" conceal cchar=➔
  syntax match Normal "\v\~" conceal cchar=˙
  syntax match Normal "()" conceal cchar=‧
  " this hides/collapses all vars/args that start with an underscore, e.g. here (_abe) => setCount(x => x + 1)
  syntax match Normal "\v\W\zs_\i{-}\ze\W" conceal cchar=ˍ

  syntax match Normal "\v\=\=" conceal cchar=≡
  syntax match Normal "\v\=\=\=" conceal cchar=≣
  syntax match Normal "\v\+\+" conceal cchar=⧺
  syntax match Normal "\v\|\|" conceal cchar=‖
  syntax match Normal "\v\&\&" conceal cchar=﹠


  " syntax match Normal '\'a\ze\W' conceal cchar=𝑎
  " syntax match Normal '\W\zs\'b\ze\W' conceal cchar=𝑏
  " syntax match Normal '\W\zs\'c\ze\W' conceal cchar=𝑐

  syntax match Normal '\'a' conceal cchar=𝑎
  syntax match Normal '\'b' conceal cchar=𝑏
  syntax match Normal '\'c' conceal cchar=𝑐
  syntax match Normal '\'d' conceal cchar=𝑑
  syntax match Normal '\'e' conceal cchar=𝑒
  syntax match Normal '\'f' conceal cchar=𝑓
  syntax match Normal '\'g' conceal cchar=𝑔

  " syntax match Normal '\W\zsint\ze\W' conceal cchar=I
  " syntax match Normal '\W\zsstring\ze\W' conceal cchar=S
  " syntax match Normal '\W\zsfloat\ze\W' conceal cchar=F
  " syntax match Normal '\W\zsbool\ze\W' conceal cchar=B

  " Note: The following int type match works quite will in this file (search for int) ~/Documents/UI-Dev/rescript/setup-tests/a_rs/src/b_types.res#/let%20myInt%20=
  " syntax match Normal '\<\zsint\ze\W' conceal cchar=I
  " syntax match Normal 'string\ze\W' conceal cchar=S
  " syntax match Normal 'float\ze\W' conceal cchar=F
  syntax match Normal '\vint\ze(\W|\_$)' conceal cchar=I
  syntax match Normal '\vfloat\ze(\W|\_$)' conceal cchar=F
  syntax match Normal '\vstring\ze(\W|\_$)' conceal cchar=S
  syntax match Normal '\vbool\ze(\W|\_$)' conceal cchar=B

  " The convention for a main type in a module is MonduleName.t
  syntax match Normal '\v\.t\ze(\W|\_$)' conceal cchar=ᵀ

  " syntax match Normal 'bool\ze\_$' conceal cchar=B
  " syntax match Normal 'array\ze\W' conceal cchar=A
  syntax match Normal 'array\ze\W' conceal cchar=⟦
  syntax match Normal 'list\ze\W' conceal cchar=⟬

  " syntax match Normal '\w\zs<' conceal cchar=﹝
  " syntax match Normal '<' conceal cchar=﹝
  " syntax match Normal '>' conceal cchar=﹞
  " syntax match Normal '[^:]>' conceal cchar=﹞
  " syntax match Normal '\i\zs<' conceal cchar=⟨
  " syntax match Normal '>' conceal cchar=⟩

  syntax match Normal "\.\.\." conceal cchar=…

  " JSDoc comments
  syntax match Normal "\/\*\s" conceal
  syntax match Normal "\/\*\*\s" conceal
  syntax match Normal "^\s\*\s" conceal
  syntax match Normal "^\*\s" conceal
  syntax match Normal "\*\/" conceal


  syntax match Normal "\S\zs:\ze\s" conceal
  syntax match Normal "^let\s" conceal
  syntax match Normal "\s\zslet\s" conceal

  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅

  " Comment conceal
  syntax match Normal '\v\s*\zs\/\/\s' conceal


  " Keywords
  syntax match Normal "relay`" conceal cchar=▵
  syntax match Normal '\s\zsmutable' conceal cchar=⁎
  syntax match Normal 'rec\ze\s' conceal cchar=∩
  syntax match Normal '^and\ze\s' conceal cchar=∝
  syntax match Normal 'switch\ze\s' conceal cchar=⌋
  syntax match Normal 'true' conceal cchar=𝗍
  syntax match Normal 'false' conceal cchar=𝖿

  syntax match Normal '@react.component' conceal cchar=_
  syntax match Normal '@genType' conceal cchar=∷
  syntax match Normal '= { @genType @react.component let make = ' conceal
  syntax match Normal 'make\s=\s' conceal
  syntax match Normal 'ReactDOM.Style\.' conceal cchar=⁝
  syntax match Normal 'ReactDOM\.' conceal cchar=⁝
  syntax match Normal 'ReactEvent\.' conceal cchar=⁝
  syntax match Normal 'React\.' conceal cchar=𝑟
  " syntax match Normal 'element' conceal cchar=⊃
  syntax match Normal 'React.element' conceal cchar=⊃
  syntax match Normal 'className=' conceal cchar=◇
  " syntax match Normal 'Belt\.' conceal " cchar=⁝
  syntax match Normal 'Array\.' conceal cchar=⟦
  syntax match Normal 'List\.' conceal cchar=⟬
  syntax match Normal 'Int\.' conceal
  syntax match Normal 'list{' conceal cchar=⟬
  " syntax match Normal 'Belt.Array\.' conceal cchar=⁝
  " syntax match Normal 'Belt.List\.' conceal cchar=⁝
  syntax match Normal 'Belt.Int\.' conceal cchar=⁝
  syntax match Normal 'Belt.Result\.' conceal cchar=⁝
  syntax match Normal 'Belt.Option\.' conceal cchar=⁝
  syntax match Normal 'Js.Array2\.' conceal cchar=⁝
  syntax match Normal 'Js.Int\.' conceal cchar=⁝
  syntax match Normal 'Js.String2\.' conceal cchar=⁝
  syntax match Normal '\s\zsHook\.' conceal cchar=⁝
  syntax match Normal 'Option\.' conceal cchar=⁝
  syntax match Normal 'Promise' conceal cchar=~
  syntax match Normal 'Async' conceal cchar=≀
  " syntax match Normal 'option' conceal cchar=◘
  syntax match Normal 'option' conceal cchar=∦
  syntax match Normal 'result' conceal cchar=∥
  " syntax match Normal 'unit' conceal cchar=◘
  syntax match Normal 'unit' conceal cchar=✴

"  ⋋  ⁎ꜝ︕ ⋐  ⋘  ⋯  ⌘ ∘  ⋊ ☾  ♽ ♺  ⫐ ◘ ☳  ⌀ ⋄ ∝ 
"  ⊺ ⊱ ⚐ ⚀ ⊔ ∥  ∦ ∟ ∨ ∪ ∩  ◘      𝑟S  ʀS
"  ⊃ ⊃ 𝑒 𝑓

  " syntax match Normal '^module\ze\s' conceal cchar=
  syntax match Normal '^module\s' conceal
  syntax match Normal '^type\ze\s' conceal cchar=┆

  syntax match Normal 'toString' conceal cchar=≺



  syntax match Normal '<' conceal cchar=⁽
  syntax match Normal '>' conceal cchar=⁾

  syntax match Normal '<div' conceal cchar=⋮
  syntax match Normal '<div>' conceal cchar=⋮
  syntax match Normal '</div>' conceal cchar=⋮
  syntax match Normal '/>' conceal cchar=˗
  syntax match Normal '|>' conceal cchar=⇾

  syntax match Normal '\s\zstype_=' conceal

  syntax match Normal 'map(' conceal cchar=➚
  syntax match Normal 'i => i' conceal cchar=»
  syntax match Normal 'concat(' conceal cchar=◇

  syntax match Normal 'i => {i' conceal cchar=_
  syntax match Normal 'x => x\ze\s' conceal cchar=_

  " syntax match Normal ')\ze\s-' conceal
  " syntax match Normal ')\_$' conceal


" ─     Inline Tests                                    ──

" let e1_element = {React.string("Hello World")}
" let e1_element: React.element = {React.string("Hello World")}

  " Hide the autogenerated test-var name and the "=" of the test binding.
  syntax match InlineTestDeclaration '\v^let\se\d_\i{-}\s\=' conceal cchar=‥
  " In the test var has a type signature, show it
  syntax match InlineTestDeclaration '\v^let\se\d_\i{-}\:' conceal cchar=‥
  " syntax match InlineTestDeclaration '\v^let\:\se\d_\i{-}' conceal cchar=‥


" syntax region graphqlExtensionPoint start=+%\(graphql\|relay\)(+ end=+)+ contains=graphqlExtensionPointS
" syntax region graphqlExtensionPointS matchgroup=String start=+`+ end=+`+ contains=@GraphQLSyntax contained

" ─     Code Headings                                   ──

  call matchadd('CommentMarkup', '\v("|--|//|#)\s─(\^|\s)\s{2}\S.*', 11, -1 )

  " call CodeMarkupSyntaxHighlights() ■
  " Hide comment character at beginning of line
  " call matchadd('Conceal', '\v^\s*\zs\/\/\s', 12, -1, {'conceal': ''})
  " Hilde \" before comment after code
  " call matchadd('Conceal', '\s\zs\#\ze\s', 12, -1, {'conceal': ''})
  " call matchadd('Conceal', '\s\zs\\/\/\ze\s', 12, -1, {'conceal': ''})
  " Conceal "%20" which is used for "h rel.txt" with space

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  " set commentstring=\ \/\/%s

  " syntax match Normal '\:\>' conceal cchar=▷
  " call matchadd('Conceal', '\v\s\zs\:\>', -1, -1, {'conceal': '▷'})

  " frequently used constructors
  " syntax match Normal 'None' conceal cchar=⊖
  " syntax match Normal 'Some\ze(' conceal cchar=⊙
  " syntax match Normal 'Error\ze(' conceal cchar=⊟
  " syntax match Normal 'Ok\ze(' conceal cchar=⊡

"     ⊟  ⊡ | ⊖  ⊙ ▲

" new unicode symbols
" « » ˝ ˚ ˙ ⧧˖͜ ͝˘˟ˢˡˤ˳ ╎𝑎 α β  ⟯⟮⟦╌ ∥,a͡,b, e ͢ e  װ ∗ ⇣ ⇨ ⇢ ⁝ ⁇‼  ⃪ ⁞  ⃩⁽⁵⁾ ⃦ ⃟      e⃨
"  ↻  ↶ ↷ ⇵ ⇠ ⇽ |⇾| ⇿ ∩ ∴ ∹  ≀ ∿  ≻  ⊂ ʀ ɢ ᴳ ɍ r⊃ ᴅ 𝑑 ⊆  ⊇ ≓ ⊍ ⊐ ⊔ ⊝ ⊟  ⋮ ⌇ ⌒  ⌔  ⌗ ⌘〈
"  ⋋  ⋐  ⋘  ⋯  ⌘ ∘   ☾  ♽ ♺   ☳     ⚐ ⚀   ∟  ∩        𝑟S  ʀS
"  ˃ ˲  ˿  ͐  ⃗  ⃯  →   ↘   ↗   ↣  ➙ ⇧ ⇡ ⇑ ↥↥  ➔ ➚  ➟  ➢ ➝  ➩  ➲   ➳  ➽  ⟀  ⟄
"  ⟛   ⟩ ⟫  ⟯  ⟶   ⧵ ⠃ ⠈ ⠁ ⠌     ﹚ ﹜ ⭡   ￪ ↑ ꜛ      ᐨ
"  ⊝   ⊙  ⊖  ⊘ ⫞   ⊟  ⊡ | ⊖  ⊙
"   ◌  ●  ◎  ◘  ◦ ◫  ◯  ▿ ▸ ▭  ▪  ▫  ▬  ▢  □ ▗   ◖  ☉  • ▪
"   ◆  ◇  ◈  ◻  ◽  ☀  ☼  ٭  ⋆ ★  ☆  ✷✴  ✱ ❂ ❈
" ➔  ⇾  →  ˃ ➟ ⇢  ↗ → →

endfunc


func! JsSyntaxAdditions() " ■
  call tools_js#bufferMaps()
  call clearmatches()

  " set syntax=typescript
  call TsConcealWithUnicode()

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


endfunc " ▲

func! TsConcealWithUnicode ()

  " call matchadd('Conceal', "'", 12, -1, {'conceal': ''})

  " let g:TsCharsToUnicode = [
  "       \  ['->',           '→', 'hsArrow']
  "       \, ['\s\zs<-',           '←', 'hsArrowBackw']
  "       \, ['==',            '≡', 'Normal']
  "       \, ['===',            '≡', 'Normal']
  "       \, ['\s\zsstring\ze[\s|)|,|;|[|\n]',    'S', 'Normal']
  "       \, ['\s\zsnumber\ze[\s|)|,|;|[|\n]',    'N', 'Normal']
  "       \, ['\s\zsboolean\ze[\s|)|,|;|[|\n]',   'B', 'Normal']
  "       \, ['\<\zsstring\ze\s',            'S', 'Normal']
  "       \, ['\<\zsstring\ze)',            'S', 'Normal']
  "       \, ['\<\zsnumber\ze\s',            'N', 'Normal']
  "       \, ['\<\zsboolean',            'B', 'Normal']
  "       \, ['\s\zsFunction',            'F', 'Normal']
  "       \, ['\s\zsReact.Node',            '◻', 'Normal']
  "       \, ['\s\zs<=',           '⇐', 'hsConstraintArrowBackw']
  "       \]
  " for [pttn, concealUnicodeSym, syntaxGroup] in g:TsCharsToUnicode
  "   exec 'syntax match ' . syntaxGroup .' "'. pttn .'" conceal cchar='. concealUnicodeSym
  " endfor


  syntax match Normal "\v\=\=" conceal cchar=≡
  syntax match Normal "===" conceal cchar=≣
  " syntax match Normal "\s\zs\>\=\ze\s" conceal cchar=≥
  syntax match Normal "\v\+\+" conceal cchar=⧺
  syntax match Normal "\v\|\|" conceal cchar=‖
  syntax match Normal "\v\&\&" conceal cchar=﹠

  syntax match Normal '\vnumber\ze(\W|\_$)' conceal cchar=N
  syntax match Normal '\vstring\ze(\W|\_$)' conceal cchar=S
  syntax match Normal '\vboolean\ze(\W|\_$)' conceal cchar=B
  syntax match Normal 'array\ze\W' conceal cchar=⟦
  syntax match Normal 'Array\ze\W' conceal cchar=⟦

  syntax match Normal 'List\ze\W' conceal cchar=⟬
  syntax match Normal 'Tuple' conceal cchar=T
  syntax match Normal 'tuple\:\s' conceal cchar=T
  syntax match Normal 'tuple\:\[' conceal cchar=T

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

  syntax match Normal '<div' conceal cchar=⋮
  syntax match Normal '<div>' conceal cchar=⋮
  syntax match Normal '</div>' conceal cchar=⋮
  syntax match Normal '/>' conceal cchar=˗
  syntax match Normal '|>' conceal cchar=⇾

  syntax match Normal '\s\zstype_=' conceal

" ➹  ⤤  ⬀  ⬈  ⧼  ⪦ ⇡ ⇞  ⇾  ~➚

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


endfunc

" Nice example unicode symbols
" ~/.config/nvim/syntax/purescript.vim#/func.%20HsConcealWithUnicode%20..



" func! JsSyntaxAdditions()
"   call matchadd('Conceal', '"', -1, -1, {'conceal': ''})
"   call matchadd('Conceal', '// ', -1, -1, {'conceal': ''})
"   call matchadd('Conceal', "'", -1, -1, {'conceal': ''})
"   set conceallevel=2
" endfunc



func! GraphQLSyntaxAdditions()
  " Note: this sequence of clearmatches, CodeMarkup, matchadd conceal and conceallevel seems to be important
  call clearmatches()
  call CodeMarkupSyntaxHighlights()
  call matchadd('Conceal', '"""', -1, -1, {'conceal': ''})
  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})
  set conceallevel=2
  set concealcursor=ni
endfunc


" ─   Haskell                                           ──
func! HaskellSyntaxAdditions()
  call tools_purescript#bufferMaps()
  call CodeMarkupSyntaxHighlights()
  " call HsConcealWithUnicode()

  " syntax match Normal "String\ze\s" conceal cchar=S
  " syntax match Normal "Number\ze\s" conceal cchar=N
  " syntax match Normal "Int\ze\s" conceal cchar=I
  " syntax match Normal "Boolean\ze\s" conceal cchar=B

  call matchadd('Conceal', 'String', -1, -1, {'conceal': 'S'})
  call matchadd('Conceal', 'Number', -1, -1, {'conceal': 'N'})
  call matchadd('Conceal', 'Int', -1, -1, {'conceal': 'I'})
  call matchadd('Conceal', 'Boolean', -1, -1, {'conceal': 'B'})


  " Other Haskell unicode conceals: ~/.vim/plugged/purescript-vim/syntax/purescript.vim#/Conceal%20with%20unicode

  " Conceal foldmarker strings and display icon to indicate fold expanding
  " Note: escaping {'s instead of literal '' {'s avoids accidental folding
  " call matchadd('Conceal', "\{\{\{", -1, -1, {'conceal': '■'})
  " call matchadd('Conceal', '\}\}\}', -1, -1, {'conceal': ''})

  " Special symbols for composition and lambda - non syntax file
  " call matchadd('Conceal', ' \zs\.', -1, -1, {'conceal': '∘'})
  " call matchadd('Conceal', '\\\%([^\\]\+→\)\@=', -1, -1, {'conceal': 'λ'}) |

  " Don't show quotes around text. note you can only identify text via the syntax coloring!
  call matchadd('Conceal', '"', -1, -1, {'conceal': ''})
  call matchadd('Conceal', '""', -1, -1, {'conceal': '∅'})

  call matchadd('purescriptColon', '\v\zs\:\ze\s', -1, -1 )

  " syn match hsTopLevelBind '\v\w\s\zs\w{-}\ze\s.{-}\=\_s'
  " With const!!!
  " call matchadd('SpecialKey', '\w\s\zs\w{-}\ze\s.{-}\=\_s', -1, -1 )
  " call clearmatches()

  " TODO this conflicts with `elem` and it unicode replacement
  " call matchadd('Conceal', '`', -1, -1, {'conceal': ''})
  " conceallevel 1 means that matches are collapsed to one char. '2' collapses completely
  set conceallevel=2
  " When the concealcursor is *not* set, the conceald text will reveal when the cursor is in the line
  " concealcursor=n would keeps the text conceald even if the cursor is on the line 
  set concealcursor=ni
  " Run this line to see the concealed text if curso is on line
  " set concealcursor=
  " set syntax=purescript
  " This will add one space before the foldmarker comment with doing "zfaf"
  set commentstring=\ --\ \%s
  " This refresh of the highlight is needed to have a black icon/indicator for a folded function, e.g the following line
  " call matchadd('Conceal', '--{\{{', -1, -1, {'conceal': ' '})
  " hi! Conceal guibg=#000000
  " Issue: this also set the bg of other conceal chars

  " use this: ?
  " setlocal formatprg=stylish-haskell

  " setlocal foldmarker=\ ■,\ ▲
  " Highlight fn-wireframe keywords
  " Note: This *does* actually have a performance hit when scrolling through a file!
  " call matchadd('BlackBG', '\(\s\zswhere\ze\_s\|\s\zsdo\ze\_s\|\s\zsin\ze\_s\|\s\zscase\ze\_s\|\s\zsthen\ze\_s\|\s\zslet\ze\_s\)')
  " call matchadd('BlackBG', '\(^\%(.*--\)\@!.*\zs\s\zswhere\ze\_s\|^\%(.*--\)\@!.*\zs\s\zsdo\ze\_s\|^\%(.*--\)\@!.*\zs\s\zsin\ze\_s\|^\%(.*--\)\@!.*\zs\s\zscase\ze\_s\|^\%(.*--\)\@!.*\zs\s\zsthen\ze\_s\|^\%(.*--\)\@!.*\zs\s\zslet\ze\_s\)')
  " let g:fnWire2Pttns = PrependSpace( AppendExtSpace( ['where', 'do', 'in', 'case', 'then', 'let'] ))
  " let g:fnWire2Pttns = NotInCommentLine( PrependSpace( AppendExtSpace( ['where', 'do', 'in', 'case', 'then', 'let'] )) )
  " call append( line('.'), MakeOrPttn( g:fnWire2Pttns ) )
endfunc

" Syntax Color Haskell: --------------------

func! PythonSyntaxAdditions() " ■
  nnoremap <silent><buffer> gei :call repl_py#eval_line( line('.') )<cr>

  call clearmatches()

  syntax match InlineTestDeclaration '\v^e\d_\i{-}\s\=' conceal cchar=‥
  syntax match ConcealQuotes "'" conceal
  syntax match ConcealQuotes '"' conceal

  call CodeMarkupSyntaxHighlights()
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

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  set commentstring=\ \#%s


endfunc " ▲

func! LuaSyntaxAdditions() " ■
  call CodeMarkupSyntaxHighlights()
  " Hide comment character at beginning of line
  call matchadd('Conceal', '\v^\s*\zs--\s', 12, -1, {'conceal': ''})
  " Hilde \" before comment after code
  call matchadd('Conceal', '\s\zs\--\ze\s', 12, -1, {'conceal': ''})
  " Conceal "%20" which is used for "h rel.txt" with space
  call matchadd('Conceal', '%20', 12, -1, {'conceal': ' '})
  call matchadd('Conceal', '#/', 12, -1, {'conceal': '|'})
  " ~/.vim/notes/notes-navigation.md#/Create%20hyperlink%20to

  " call matchadd('Conceal', '"', -1, -1, {'conceal': ''})
  " call matchadd('Conceal', "'", -1, -1, {'conceal': ''})

  call SyntaxRange#Include('python\s<<\sEOF', 'EOF', 'python', 'CommentLabel')

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  set commentstring=\ \--%s
  " Original vim foldmarker string
  " set foldmarker={{{,}}}
  " set foldmarker=■■,▲▲
  " set foldmarker=\ ■,\ ▲
endfunc " ▲

func! MarkdownSyntaxAdditions()
  call clearmatches()
  call matchadd('Conceal', '%20', 12, -1, {'conceal': ' '})
  call matchadd('Conceal', '#/', 12, -1, {'conceal': '|'})
endfunc

func! VimScriptSyntaxAdditions() " ■
  " echoe "why is this called?"
  call clearmatches()
  call CodeMarkupSyntaxHighlights()
  " Hide comment character at beginning of line
  call matchadd('Conceal', '\v^\s*\zs"\s', 12, -1, {'conceal': ''})
  " Hilde \" before comment after code
  " Issue: this hides the second \" of a string
  " call matchadd('Conceal', '\s\zs\"\ze\s', 12, -1, {'conceal': ''})
  " Conceal "%20" which is used for "h rel.txt" with space
  call matchadd('Conceal', '%20', 12, -1, {'conceal': ' '})
  call matchadd('Conceal', '#/', 12, -1, {'conceal': '|'})
  " ~/.vim/notes/notes-navigation.md#/Create%20hyperlink%20to

  call SyntaxRange#Include('python\s<<\sEOF', 'EOF', 'python', 'CommentLabel')

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  set commentstring=\ \"%s
  " Original vim foldmarker string
  " set foldmarker={{{,}}}
  " set foldmarker=■■,▲▲
  " set foldmarker=\ ■,\ ▲
endfunc " ▲

" Testing: ■
" call matchadd('MatchParen', '\v"(\s)@=', -1, -1 ) ▲
" call matchadd('MatchParen', '\v^\s*\zs"\s', -1, -1 )
" call clearmatches()
" TODO find out if this alternative approach is needed
" This cleans up the matchadd if every Enter event
" au FileType haskell set concealcursor=ni
" au WinEnter,BufEnter,BufRead,FileType,Colorscheme *
"       \ if exists('w:lambda_conceal')                                                                  |
"       \     call matchdelete(w:lambda_conceal)                                                         |
"       \     unlet w:lambda_conceal                                                                     |
"       \ endif                                                                                          |
"       \ if &ft == 'haskell'                                                                         |
"       \     let w:lambda_conceal = matchadd('Conceal', '\\\%([^\\]\+→\)\@=', 10, -1, {'conceal': 'λ'}) |
"       \     hi! link Conceal Operator                                                                  |
"       \ endif

" Experiments:{{{
" let g:haskell_classic_highlighting = 1
" syn match haskellCompose ' \zs\.' conceal cchar=∘
" syn match haskellLambda '\\' conceal cchar=λ
" this conceals "->" into unicode "→". and is supposed to trun :: into big ":" - but is that char not available?
" Not needed?
" let g:haskell_conceal_wide = 1
" goolord/vim2hs us using this to display lambda symbol and fn compose dot
" let g:haskell_conceal = 1
" TODO use this for purescript syntax?
" TODO test these:
" function! vim2hs#haskell#conceal#wide() " {_{{
" function! vim2hs#haskell#conceal#bad() " {_{{
" let g:idris_conceal = 1}}}









