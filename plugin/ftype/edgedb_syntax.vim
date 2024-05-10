
" augroup edgedb
"     autocmd BufRead,BufNewFile *.esdl,*.edgeql :set filetype=edgeql
" augroup end
" autocmd BufNewFile,BufRead *.edgeql setf edgeql
" autocmd BufNewFile,BufRead *.esdl setf edgeql


" NOTE: I deactivated the edgedb syntax highlight, but might want to take
" inspiration from the regexes here: /Users/at/.config/nvim/plugged/edgedb-vim/syntax/edgeql.vim|1

" Character classes
" :help character-classes
" /opt/homebrew/Cellar/neovim/0.9.0/share/nvim/runtime/doc/pattern.txt|500

func! EdgeQLSyntaxAdditions() " ■

  " This is needed because of a treesitter "no parser for 'edgeql' language, see :help treesitter-parsers" error.
  " NOTE: ~/.config/nvim/plugin/HsSyntaxAdditions.vim‖/autocmdˍFileTypeˍedgeql,es

  " set ft=text
  set ft=edgeql
  call clearmatches()
  " set conceallevel=2
  " set concealcursor=ni

  set syntax=edgeql

  " call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})
  " call matchadd('Conceal', ';', 12, -1, {'conceal': ''})

  call matchadd('FunctionDec', '\vtype\s\zs\u\w*', 11, -1)
  " match only uppercase words and except an optional namespace part but don't match it.
  call matchadd('FunctionDec', '\vinsert\s(\w*::)?\zs\u\w*', 11, -1)
  call matchadd('FunctionDec', '\vselect\s(\w*::)?\zs\u\w*', 11, -1)
  call matchadd('FunctionDec', '\vupdate\s(\w*::)?\zs\u\w*', 11, -1)
  call matchadd('FunctionDec', '\vINSERT\s(\w*::)?\zs\u\w*', 11, -1)
  call matchadd('FunctionDec', '\vSELECT\s(\w*::)?\zs\u\w*', 11, -1)
  call matchadd('Trait', '\vabstract\stype\s\zs\u\w*', 11, -1)

  call matchadd('FunctionDec', '\v[is\s(\w*::)?\zs\u\w*', 11, -1)

  call matchadd('FunctionDec', '\v::\u\w*', 11, -1)

  call matchadd('Keyword', 'Resolved\. Schema is up to date now\.', 11, -1)

  " \(foo\)\@<!bar		any "bar" that's not in "foobar"
  " \(\/\/.*\)\@<!in	"in" which is not after "//"


  " properties
  " call matchadd('Comment',      '\v\w*\ze:', 11, -1)
  " call matchadd('purescriptConstructor',      '\w*\ze:', 11, -1)
  " Note the 'negative lookaround here - it actually works to prevent metches inside comments!
  call matchadd('purescriptConstructor',      '\(\#.*\)\@<!\w*\ze:', 11, -1)

  " namespaces
  call matchadd('CommentMinus', '\v\w*\ze::', 11, -1)

  " 
  " This is effective in preventing the conceal unicode in normal comments
  syntax match CommentMinus '\v#\s\zs.*'
  " IMPORTANT: this line would prevent the above effect!
  " syntax match Normal "\#\s" conceal

  " IMPORTANT: Only matchadd can coneal the comment chars when those are already match by the above syntax match!
  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})


  syntax match Normal "\v\S\zs:" conceal

  syntax match Normal 'with' conceal cchar=˪
  syntax match Normal 'WITH' conceal cchar=˪
  syntax match Normal 'update' conceal cchar=→
  syntax match Normal 'UPDATE' conceal cchar=→
  " syntax match Normal 'select' conceal cchar=⁝
  syntax match Normal '\(\#.*\)\@<!select' conceal cchar=⁝
  " syntax match Normal 'insert' conceal cchar=⌄
  " syntax match Normal 'insert' conceal cchar=⇣
  " syntax match Normal 'insert' conceal cchar=↘
  syntax match Normal '\(\#.*\)\@<!insert' conceal cchar=↘
  syntax match Normal 'SELECT' conceal cchar=⁝
  syntax match Normal 'INSERT' conceal cchar=⌄
  " syntax match Normal 'filter' conceal cchar=⇡
  syntax match Normal '\(\#.*\)\@<!filter' conceal cchar=⇡
  syntax match Normal 'FILTER' conceal cchar=⇡
  syntax match Normal 'for\ze\s' conceal cchar=⊃
  syntax match Normal 'FOR' conceal cchar=⊃
  syntax match Normal 'in\ze\s' conceal cchar=⊂
  syntax match Normal 'IN\ze\s' conceal cchar=⊂

  syntax match Normal 'like\ze\s' conceal cchar=≈
  syntax match Normal 'ilike\ze\s' conceal cchar=≋

  syntax match Normal 'and' conceal cchar=&
  syntax match Normal '\s\zsor\ze\s' conceal cchar=‖

  syntax match Normal 'function' conceal cchar=➔
  syntax match Normal ';' conceal
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


  " syntax match Normal 'set' conceal cchar=∥
  " syntax match Normal 'SET' conceal cchar=∥

  syntax match Normal 'set\ze\s{' conceal cchar=→
  syntax match Normal 'union' conceal cchar=⋿
  syntax match Normal 'UNION' conceal cchar=⋿

  syntax match Normal 'std::str' conceal cchar=s
  syntax match Normal 'str\ze\s' conceal cchar=s
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

  syntax match CommentMinusMinus "{"
  syntax match CommentMinusMinus "}"
  syntax match CommentMinus "("
  syntax match CommentMinus ")"
  syntax match CommentMinus "<"
  syntax match CommentMinus ">"
  syntax match CommentMinus "\["
  syntax match CommentMinus "\]"

  " This is effective in preventing the conceal unicode in normal comments
  " syntax match Comment '#\s\zs.*'

  " syntax match Comment '\#\s\zs.*'
  " syntax match Comment '\s\#\zs\zs.*'

  " This is effective in preventing the conceal unicode in normal comments
  " syntax match BlackBG '\v#\s\zs.*'

  " comments are overwriting other matchadds
  " call matchadd('CommentMinus', '\#\s\zs.*', 1001)

  set conceallevel=2 " ■
  set concealcursor=ni " ▲
  " This will add one space before the foldmarker comment with doing "zfaf": func! ..ns() "{{_{

  " setl isk+=<,>,$,#,+,-,*,/,%,&,=,!,:,124,~,?,^
  setl isk+=?

  " setlocal foldmarker=\ ■,\ ▲
  set foldmethod=marker

  set commentstring=\#%s

  " CodeMarkup Header
  syntax match BlackBG '\v─(\^|\s)\s{2}\S.*'


endfunc " ▲

