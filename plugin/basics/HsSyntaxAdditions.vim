augroup ag
  au!
augroup end

" ─   Filetype Specific Maps Tools Syntax               ──

au ag BufRead,BufNewFile * if &ft == "" && expand('%:t') !~ '\.' | set filetype=markdown | endif
au ag BufRead,BufNewFile *.txt set filetype=markdown

" au ag BufWinEnter,BufRead * if expand('%:t') =~ 'git' | setfiletype gitdiff | endif
" au ag BufWinEnter,BufRead * if 1 | echoe expand('%') | endif

au ag BufNewFile,BufRead,WinNew *.gel,*.edgeql,*.esdl call Gel_bufferMaps()
au ag BufNewFile,BufRead,WinNew *.gel,*.edgeql,*.esdl call EdgeQLSyntaxAdditions()

au ag BufWinEnter *.tql,*.tqls call TypeDB_bufferMaps()
au ag BufWinEnter,BufReadPost *.tql,*.tqls call TypeQLSyntaxAdditions()
" NOTE: BufReadPost fires when nvim reads the files after it was written with 'writefile'

au ag BufNewFile,BufRead,WinNew *.hs call HaskellSyntaxAdditions()
au ag BufNewFile,BufRead        *.hs call HaskellMaps()
au ag BufNewFile,BufRead,WinNew *.purs call HaskellSyntaxAdditions()

" au ag BufNewFile,BufRead,WinNew *.sc,*.scala call ScalaSyntaxAdditions()
" BufWinEnter is needed to refresh the comment conceals when that buffer was hidden, e.g. using gq in dirvish/nvt
au ag BufWinEnter *.sc,*.scala,*.java,*.sbt call ScalaSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.sc,*.scala,*.java,*.sbt,*.css call Scala_bufferMaps()

" the filetype .shtp is used in rlist to separate active .sh script from mere command templates.
au ag BufNewFile,BufRead,WinNew *.sh,*.shtp,r call ShellSyntaxAdditions()

" au ag BufRead,BufNewFile *.smithy		setfiletype smithy
au ag BufNewFile,BufRead,WinNew *.smithy  call SmithySyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.smithy  call SmithyBufferMaps()
au ag FileType smithy setlocal commentstring=//%s
au ag FileType smithy setlocal commentstring=//%s

" au ag BufNewFile,BufReadPost,WinNew *.res,*.mli call RescriptSyntaxAdditions()
" au ag BufNewFile,BufRead,WinNew *.res,*resi,*.mli,*.ml call RescriptSyntaxAdditions()
" au ag BufNewFile,BufRead,WinNew *.jsx,*.js,*.ts,*.tsx,*mjs,*.json,*.html call TsSyntaxAdditions()
au ag BufWinEnter *.jsx,*.js,*.ts,*.tsx,*mjs,*.json,*.html call TsSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.jsx,*.js,*.ts,*.tsx,*mjs,*.json,*.html,*.less,*.scss,*.sass call JS_bufferMaps()
au ag BufNewFile,BufRead,WinNew *.graphql call GraphQLSyntaxAdditions()
" au ag BufNewFile,BufRead,WinNew *.sql call SQLSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.sql call EdgeQLSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.sql call Sql_bufferMaps()

" au ag BufNewFile,BufRead,WinNew *.sct set filetype=purescript_scratch | set syntax=purescript1
au ag BufWinEnter *.sct set filetype=purescript_scratch | set syntax=lua | call LuaSyntaxAdditions()


" au ag BufNewFile,BufRead *.purs setfiletype purescript
" this is now moved to ftdetect folder - not sure if this is needed
" ~/.vim/ftdetect/purescript.vim#/au%20BufNewFile,BufRead%20*.purs
au ag BufNewFile,BufRead        *.purs call HaskellMaps()

" au ag BufNewFile,BufRead,WinNew *.lua call LuaSyntaxAdditions()
au ag BufWinEnter *.lua call LuaSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.py call PythonSyntaxAdditions()
" TODO migrate to using FileType?
" au ag FileType python call PythonSyntaxAdditions()
" au ag BufNewFile,BufRead,WinNew *.yaml call PythonSyntaxAdditions()

" au ag BufNewFile,BufRead,WinNew *.vim,*.vimrc call VimScriptSyntaxAdditions()
au ag BufWinEnter *.vim,*.vimrc call VimScriptSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.vim,*.lua,*.txt,.zshrc,*.bak call VScriptToolsBufferMaps()

au ag BufWinEnter *.md          call MarkdownSyntaxAdditions()
au ag BufWinEnter *.md,*.markdown   call MarkdownBufferMaps()
au ag FileType markdown,codecompanion,mcphub call MarkdownBufferMaps()

au ag BufNewFile,BufRead,WinNew *.zshrc       call CodeMarkupSyntaxHighlights()
" au ag BufNewFile,BufRead        *.vim,*.vimrc call VimScriptMaps()
" ─^  Filetype Specific Maps Tools Syntax               ──

let g:Winid_previous = 0
let g:Ntree_prevWinid = 0

" Temp hack to fix the treesitter error "no parser for buffer" e.g. in gp.nvim :GpFindChat
" augroup DefaultToBash
"   autocmd!
"   autocmd BufWinEnter,BufRead * if empty(&filetype) | setfiletype bash | endif
"   " IMPORTANT: this works: ".conf" files don't have a treesitter parser, this just uses bash. 2025-01. not perfect though as the other filetype might trigger e.g. lsp.
"   autocmd BufWinEnter,BufRead * if &filetype=='conf' | setfiletype bash | endif
" augroup END

augroup PythonComment
    autocmd!
    autocmd FileType python setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:>,fb:-
    autocmd FileType python setlocal formatoptions+=cro
augroup END

augroup track_window
   autocmd!

   autocmd BufLeave * if &ft !~ "neo-tree" | let g:Winid_previous = win_getid() | endif    
   autocmd BufEnter * if &ft == "neo-tree" | let g:Ntree_prevWinid = g:Winid_previous | endif
 
   autocmd BufEnter * if &ft == "dirvish" | let g:Ntree_prevWinid = g:Winid_previous | endif

   " TODO now there's a way to install treesitter parses. see the treesitter-conf lua file at the bottom.
   " autocmd FileType zsh set filetype=bash | set syntax=zsh
   " autocmd FileType less set filetype=css
   " autocmd FileType sass set syntax=scss
   " autocmd FileType sass set syntax=scss
   " autocmd FileType scss set filetype=css | set syntax=scss

   " This is needed because of a treesitter "no parser for 'edgeql' language, see :help treesitter-parsers" error.
   " autocmd FileType edgeql,esdl set filetype=graphql
   " NOTE: this treesitter setting actually works! but the parser still needs to be installed
   " so I could just use some other language i dont use. use it's filetype but deactivate it in treesitter.
   " disable = {"graphql"},

   " autocmd FileType edgeql lua require'nvim-treesitter.configs'.setup { highlight = { enable = false, }, }


augroup END




" ─   Syntax Color                                     ──



func! ShellSyntaxAdditions()
  if &ft == 'dirvish'
    return
  endif
  set ft=sh
  " call tools_scala#bufferMaps()
  call VScriptToolsBufferMaps()
endfunc


func! HaskellTools()
  " call haskellenv#start()
  " TODO test these
  " call vim2hs#haskell#editing#includes()
  " call vim2hs#haskell#editing#keywords()
  " call vim2hs#haskell#editing#formatting()
endfunc


nnoremap <silent><leader>cm :call clearmatches()<cr>


func! SQLSyntaxAdditions()
  " call Sql_bufferMaps()
  call clearmatches()

  set conceallevel=2
  set concealcursor=ni
  set commentstring=\#%s

  syntax match Normal "->" conceal cchar=→
  syntax match Normal "::" conceal cchar=|
  syntax match Normal ":=" conceal cchar=⫶

  syntax match sqlKeyword "returning"
  syntax match sqlKeyword "\s\zsdo"
  syntax match sqlStatement "conflict"

  call matchadd('BlackBG', '\v("|--|//|#)\s─(\^|\s)\s{2}\S.*', 11, -1 )
  call matchadd('Conceal', '"""', -1, -1, {'conceal': ''})
  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})
endfunc



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
" ʲ ʳ ʺ ʽʹ ˂ ˄ ˆ ˌ ˓ ₊˖⁺﹢+ ˠ ˡ ˣ ˶ ˽  ᴺ ᵀ ᵈ ᵑ ᵓ ʺ 
" ”  ⍘ ’ ⍞  ⍣ ⍤⍦⍪⍳ ⍽ ⍿ ⎅ ⎇  ⎎ ⎚
  " ➔  ⇾  →  ˃ ➟ ⇢ ˲ ↗ → →   ˷ ˍˍ ˳     ⟣ ◦ פּ ﬘   璘

" « » ˝ ˚ ˙ ⧧˖͜ ͝˘˟ˢˡˤ˳ ╎𝑎 α β  ⟯⟮⟦╌ ∥,a͡,b, e ͢ e  װ ∗ ⇣ ⇨ ⇢ ⁝ ⁇‼  ⃪ ⁞  ⃩⁽⁵⁾ ⃦ ⃟      e⃨
"  ↻  ↶ ↷ ⇵ ⇠ ⇽ |⇾| ⇿ ∩ ∴ ∹  ≀ ∿  ≻  ⊂ ʀ ɢ ᴳ ɍ  ͬr⊃ ᴅ 𝑑 ⊆  ⊇ ≓ ⊍ ⊐ ⊔ ⊝ ⊟  ⋮ ⌇ ⌒  ⌔  ⌗ ⌘✱〈
"  ⋋  ⋐  ⋘  ⋯  ⌘ ∘   ☾  ♽ ♺   ☳     ⚐ ⚀   ∟  ∩        𝑟S  ʀS
"  ˃ ˲  ˲ ˿  ͐ ͢  ⃗  ⃯  →   ↘   ↗   ↣  ➙ ⇧ ⇡ ⇑ ↥↥  ➔ ➚  ➟  ➢ ➝  ➩  ➲   ➳  ➽  ⟀  ⟄  ⟃  ⟔  ⟥  ⟣
"  ⌁  →  ⃯  ˃ ˪
"  ⟛   ⟩ ⟫  ⟯  ⟶   ⧵ ⠃ ⠈ ⠁ ⠌     ﹚ ﹜ ⭡   ￪ ↑ ꜛ      ᐨ
"  ☉⊙⊙◎⊖  ⊘ ⫞  ˻ˌ¨ ⊟  ⊡ | ⊖  ⊙
"   ◌  ●  ◎  ◘  ◦ ◫  ◯  ▿ ▸ ▭  ▪  ▫  ▬  ▢  □ ▗   ◖  ☉  •⋆• ▪
"   ◆  ◇  ◈  ◻  ◽  ☀  ☼  ٭  ⋆ ★  ☆  ✷✴  ✱ ❂ ❈  ♽
" ➔  ⇾  →  ˃ ➟ ⇢ ˲ ↗ → →   ˷ ˍˍ ˳
" Ɛ  𝑓 𝑡ƒ ɱ ᙆ ｔ ᵀᴵᴺ ɴ ɳ ᴟ

endfunc



" Nice example unicode symbols
" ~/.config/nvim/syntax/purescript.vim#/func.%20HsConcealWithUnicode%20..



func! GraphQLSyntaxAdditions()
  " Note: this sequence of clearmatches, CodeMarkup, matchadd conceal and conceallevel seems to be important
  call clearmatches()

  " doesn't seem to work?
  syntax keyword aqlKeywords
        \ LET
        \ FOR
        \ IN
        \ FILTER
        \ UPDATE
        \ WITH

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


func! LuaSyntaxAdditions() " ■
  call clearmatches()
  " set filetype=purescript_scratch
  " convertion: only conceal single quotes
  syntax match Normal "'" conceal
  syntax match Normal '\[\[' conceal cchar=❞
  syntax match Normal '\]\]' conceal cchar=❞

  " This is effective in preventing the conceal unicode in normal comments
  syntax match Comment '\v--\s\zs.*'

  " syntax match Normal '--\s' conceal
  " Only matchadd can coneal the comment chars when those are already match by the above syntax match!
  call matchadd('Conceal', '--\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '---', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '---@param\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '---@', 12, -1, {'conceal': ''})

  syntax match Normal 'local\s' conceal cchar=ˍ
  syntax match Normal '^local\s' conceal
  syntax match Normal 'function' conceal cchar=→
  syntax match Normal '\vend\ze(\W|\_$)' conceal cchar=˻
  syntax match Normal 'return' conceal cchar=←
  syntax match Normal 'require' conceal cchar=⊟
  syntax match Normal 'vim\.' conceal cchar=v
  syntax match Normal 'vim.keymap\.set' conceal cchar=⊂
  syntax match Normal 'vim.print' conceal cchar=⌘

  " syntax match CommentMinus '\:'
  " note this gets overwritten by sematic lsp setting VarDec. now changed this in colorscheme

  " This replaces: call CodeMarkupSyntaxHighlights()
  syntax match BlackBG '\v─(\^|\s)\s{2}\S.*'
  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  set commentstring=\ \--%s
endfunc " ▲

func! MarkdownSyntaxAdditions()
  " set syntax=markdown
  " temp fix bc/ underscores are hidden with markdown syntax e.g. in ~/Documents/Proj/k_mindgraph/_plan/a_graph_sql/schema_.sql
  " set syntax=js
  call clearmatches()
  " syntax match Normal '\`\`\`' conceal cchar=⊃
  " call matchadd('Conceal', '%20', 12, -1, {'conceal': ' '})
  call matchadd('Conceal', '^\`\`\`$', 12, -1, {'conceal': '˹'})
  call matchadd('Conceal', '^\`\`\`\i\i.*', 12, -1, {'conceal': '˻'})
  call matchadd('Conceal', '^\`\`\`_', 12, -1, {'conceal': '˻'})

  " set foldmethod=marker
endfunc

func! VimScriptSyntaxAdditions ()
  call clearmatches()

  " syntax match Normal '^"\s' conceal
  " This is effective in preventing the conceal unicode in normal comments
  syntax match Comment '\v^"\s\zs.*'
  syntax match Comment '\v^\s\s\zs"\s\zs.*'

  syntax match Normal 'func!' conceal cchar=→
  syntax match Normal 'return' conceal cchar=←
  syntax match Normal 'endfunc' conceal cchar=˻
  syntax match Normal 'endif' conceal cchar=˻
  syntax match Normal '\v\\' conceal cchar=ˍ
  syntax match Normal 'let ' conceal
  syntax match Normal 'call ' conceal

  " Only matchadd can coneal the comment chars when those are already match by the above syntax match!
  call matchadd('Conceal', '^"\s', 12, -1, {'conceal': ''})
  call matchadd('Conceal', '^\s\s\zs"\s', 12, -1, {'conceal': ''})

  syntax match Normal 'lua\s<<\sEOF' conceal cchar=˻
  syntax match Normal '^EOF' conceal cchar=˹

  syntax match BlackBG '\v─(\^|\s)\s{2}\S.*'

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  set commentstring=\ \"%s
endfunc



" Some experiments. delete this ■
  " TODO: this might be interesting to try in .md file or scala comments
  " call SyntaxRange#Include('python\s<<\sEOF', 'EOF', 'python', 'CommentLabel')
  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{
  " set commentstring=\ \"%s
  set commentstring=\ \"%s
  " Original vim foldmarker string
  " set foldmarker={{{,}}}
  " set foldmarker=■■,▲▲
  " set foldmarker=\ ■,\ ▲
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








"  ▲
