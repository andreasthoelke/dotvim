augroup ag
  au!
augroup end

" ─   Filetype Specific Maps Tools Syntax               ──
au ag BufNewFile,BufRead,WinNew *.hs call HaskellSyntaxAdditions()
au ag BufNewFile,BufRead        *.hs call HaskellMaps()

au ag BufNewFile,BufRead,WinNew *.purs call HaskellSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.js,*.ts,*.tsx,*.json call JsSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.esdl,*edgeql call EdgeQLSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.graphql call GraphQLSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.svelte call SvelteSyntaxAdditions()

" au ag BufNewFile,BufRead *.purs setfiletype purescript
" this is now moved to ftdetect folder - not sure if this is needed
" ~/.vim/ftdetect/purescript.vim#/au%20BufNewFile,BufRead%20*.purs
au ag BufNewFile,BufRead        *.purs call HaskellMaps()

au ag BufNewFile,BufRead,WinNew *.lua call LuaSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.py call PythonSyntaxAdditions()

au ag BufNewFile,BufRead,WinNew *.vim,*.vimrc call VimScriptSyntaxAdditions()
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


func! JsSyntaxAdditions() " ■
  nnoremap <silent><buffer> gel :call tools_js#eval_line( line('.'), v:true, v:false, v:false )<cr>
  nnoremap <silent><buffer> gei :call tools_js#eval_line( line('.'), v:true, v:false, v:true )<cr>
  nnoremap <silent><buffer> geL :call tools_js#eval_line( line('.'), v:true, v:true, v:false )<cr>
  nnoremap <silent><buffer> geI :call tools_js#eval_line( line('.'), v:true, v:true, v:true )<cr>
  nnoremap <silent><buffer> <leader>gel :call tools_js#eval_line( line('.'), v:false, v:false, v:false )<cr>
  nnoremap <silent><buffer> <leader>gei :call tools_js#eval_line( line('.'), v:false, v:false, v:true )<cr>
  nnoremap <silent><buffer> <leader>geL :call tools_js#eval_line( line('.'), v:false, v:true, v:false )<cr>
  nnoremap <silent><buffer> <leader>geI :call tools_js#eval_line( line('.'), v:false, v:true, v:true )<cr>

  nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>

  call clearmatches()

  " set syntax=typescript
  call TsConcealWithUnicode()

  syntax match InlineTestDeclaration '\v^const\se\d_\i{-}\s\=' conceal cchar=‥
  syntax match InlineTestDeclaration '\v^const\sa\d_\i{-}\s\=' conceal cchar=…
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

  let g:TsCharsToUnicode = [
        \  ['->',           '→', 'hsArrow']
        \, ['\s\zs<-',           '←', 'hsArrowBackw']
        \, ['==',            '≡', 'Normal']
        \, ['===',            '≡', 'Normal']
        \, ['\s\zsstring',            'S', 'Normal']
        \, ['\s\zsnumber',            'N', 'Normal']
        \, ['\s\zsboolean',            'B', 'Normal']
        \, ['\<\zsstring',            'S', 'Normal']
        \, ['\<\zsnumber',            'N', 'Normal']
        \, ['\<\zsboolean',            'B', 'Normal']
        \, ['\s\zsFunction',            'F', 'Normal']
        \, ['\s\zsReact.Node',            '◻', 'Normal']
        \, ['\s\zs=>',           '⇒', 'hsConstraintArrow']
        \, ['\s\zs<=',           '⇐', 'hsConstraintArrowBackw']
        \]

  for [pttn, concealUnicodeSym, syntaxGroup] in g:TsCharsToUnicode
    exec 'syntax match ' . syntaxGroup .' "'. pttn .'" conceal cchar='. concealUnicodeSym
  endfor

  syntax match Normal "\S\zs:\ze\s" conceal
  syntax match Normal "const\s" conceal

  syntax match Normal "'" conceal
  syntax match Normal "''" conceal cchar=∅
  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅

  " JSDoc comments
  syntax match Normal "\/\*\*" conceal
  syntax match Normal "\/\*\*\s" conceal
  syntax match Normal "^\s\*\s" conceal
  syntax match Normal "^\*\s" conceal

  " Other TS clean-up conceals
  syntax match Normal "function" conceal cchar=→
  syntax match Normal "\s\zse\." conceal cchar=᛫
  syntax match Normal "\s\zstrue" conceal cchar=᛫
  syntax match Normal "ilike" conceal cchar=∼
  syntax match Normal "like" conceal cchar=∼
  syntax match Normal "order_by\:" conceal cchar=ꜛ
  syntax match Normal "filter\:" conceal cchar=≚
  syntax match Normal "\.\.\." conceal cchar=…
  syntax match Normal "\*\/" conceal

endfunc

" Nice example unicode symbols
" ~/.config/nvim/syntax/purescript.vim#/func.%20HsConcealWithUnicode%20..

func! SvelteSyntaxAdditions() " ■
  nnoremap <silent><buffer> gei :call tools_js#eval_line( line('.'), v:false )<cr>
  nnoremap <silent><buffer> geI :call tools_js#eval_line( line('.'), v:true )<cr>

  call clearmatches()

  " set syntax=typescript
  call SvelteConcealWithUnicode()

  " call matchadd('CommentLabel', '\vscript', -1, -1 )
  " call matchadd('BlackBG', '\v\$\:\s\zs\i*\ze\I', 11, -1 )
  " call matchadd('BlackBG', '\v\$\:\s\i*\I\ze', 11, -1 )
  call matchadd('BlackBG', '\v\$\:\s\zs\i*\I\ze', 11, -1 )
  call matchadd('purescriptIdentifier', '\vlet\s\zs\i*\I\ze', 11, -1 )
  " Reactive value declaration:
  " call matchadd('BlackBG', '\v\$\:\s\i{-}\I\ze', 11, -1 )
  " call matchadd('BlackBG', '\v\<.*\{\s\zs\i*\ze\s\}', 11, -1 )
  " call matchadd('purescriptIdentifier', '\v\<.*\{\s\zs\S*\ze\s\}', 11, -1 )
  " Live variables in markup:
  " call matchadd('purescriptIdentifierDot1', '\v\<.{-}\{\s\zs\S*\ze\s\}', 11, -1 )
  call matchadd('purescriptIdentifierDot1', '\v\=\{\s\zs\S*\ze\s\}', 11, -1 )

  syntax match InlineTestDeclaration '\v^const\se\d_\i{-}\s\=' conceal cchar=‥
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

func! SvelteConcealWithUnicode ()

  " call matchadd('Conceal', "'", 12, -1, {'conceal': ''})

  let g:TsCharsToUnicode = [
        \  ['->',           '→', 'hsArrow']
        \, ['\s\zs<-',           '←', 'hsArrowBackw']
        \, ['\s\zs<-',           '←', 'hsArrowBackw']
        \, ['==',            '≡', 'Normal']
        \, ['===',            '≡', 'Normal']
        \, ['\s\zsstring',            'S', 'Normal']
        \, ['\s\zsboolean',            'B', 'Normal']
        \, ['\s\zsFunction',            'F', 'Normal']
        \, ['\s\zsReact.Node',            '◻', 'Normal']
        \, ['\s\zs=>',           '⇒', 'hsConstraintArrow']
        \, ['\s\zs<=',           '⇐', 'hsConstraintArrowBackw']
        \]

  for [pttn, concealUnicodeSym, syntaxGroup] in g:TsCharsToUnicode
    exec 'syntax match ' . syntaxGroup .' "'. pttn .'" conceal cchar='. concealUnicodeSym
  endfor

  syntax match Normal "\S\zs:\ze\s" conceal
  syntax match Normal "const\s" conceal
  " syntax match Normal "const" conceal cchar=⦙

  syntax match Normal "\s\zsnumber" conceal cchar=N

  syntax match Normal "<script.*>" conceal cchar=⌈
  syntax match Normal "</script>" conceal cchar=⌋
  syntax match Normal "<style>" conceal cchar=⌈
  syntax match Normal "</style>" conceal cchar=⌋

  syntax match Normal "<button" conceal cchar=B
  syntax match Normal "\/button>" conceal cchar=B
  syntax match Normal "<div" conceal cchar=D
  syntax match Normal "\/div>" conceal cchar=D
  syntax match Normal "<p" conceal cchar=P
  syntax match Normal "\/p>" conceal cchar=P
  syntax match Normal "<input" conceal cchar=I
  syntax match Normal "\/input>" conceal cchar=I
  syntax match Normal "<label" conceal cchar=L
  syntax match Normal "\/label>" conceal cchar=L
  syntax match Normal "<h\d" conceal cchar=H
  syntax match Normal "\/h\d>" conceal cchar=H
  syntax match Normal "<option" conceal cchar=O
  syntax match Normal "\/option>" conceal cchar=O
  syntax match Normal "<span" conceal cchar=S
  syntax match Normal "\/span>" conceal cchar=S

  " syntax match Normal "let\s" conceal cchar=᛫
  syntax match Normal "let\s" conceal
  syntax match Normal "\.\.\." conceal cchar=‥
  " syntax match Normal "\$:" conceal cchar=•
  " syntax match Normal "\$:\s" conceal cchar=⫶
  syntax match Normal "\$:\ze\s" conceal cchar=⫶
  " syntax match Normal "\$:\s" conceal

  syntax match Normal "bind:value=" conceal cchar=⁎
  syntax match Normal "bind:checked=" conceal cchar=⁎
  syntax match Normal "bind:group=" conceal cchar=⁎

  syntax match Normal "'" conceal
  syntax match Normal "''" conceal cchar=∅
  syntax match Normal '"' conceal
  syntax match Normal '""' conceal cchar=∅

  syntax match Normal '{' conceal cchar=⟨
  syntax match Normal '}' conceal cchar=⟩

  " syntax match Normal '</\i*>' conceal cchar=⌉

  " JSDoc comments
  syntax match Normal "\/\*\*" conceal
  syntax match Normal "\/\*\*\s" conceal
  syntax match Normal "^\s\*\s" conceal
  syntax match Normal "^\*\s" conceal
  syntax match Normal "function" conceal cchar=→
  syntax match Normal "\*\/" conceal

endfunc


" func! JsSyntaxAdditions()
"   call matchadd('Conceal', '"', -1, -1, {'conceal': ''})
"   call matchadd('Conceal', '// ', -1, -1, {'conceal': ''})
"   call matchadd('Conceal', "'", -1, -1, {'conceal': ''})
"   set conceallevel=2
" endfunc

func! GraphQLSyntaxAdditions()
  call matchadd('Conceal', '"""', -1, -1, {'conceal': ''})
  set conceallevel=2
endfunc


" ─   Haskell                                           ──
func! HaskellSyntaxAdditions()
  call CodeMarkupSyntaxHighlights()
  " call HsConcealWithUnicode()
  " Conceal comment marker string
  " call matchadd('Conceal', '-- ', -1, -1, {'conceal': ''})
  " call matchadd('Conceal', '-- ', 12, -1, {'conceal': ''})
  " Note: Priority is set to "12" to be > the CodeMarkup matchadd priority (11)
  " TODO reactivate" call matchadd('Conceal', '{- ', -1, -1, {'conceal': ''})
  " call matchadd('Conceal', '{-', -1, -1, {'conceal': ''})
  " TODO" call matchadd('Conceal', '-}', -1, -1, {'conceal': ''})

" ─   Conceal with unicode                               ■
  " This replaces the following insert maps
  " inoremap :: <c-k>::
  " inoremap -> <c-k>->
  " inoremap <- <c-k><-
  " inoremap => <c-k>=>
  " inoremap <= <c-k><=
  " inoremap forall <c-k>FA

  " syntax match Normal ' \zs<\$>' conceal cchar=⫩
  " call matchadd('Conceal', '::', 12, -1, {'conceal': '∷'})
  " call matchadd('Conceal', ' \zs->', 12, -1, {'conceal': '→'})
  " call matchadd('Conceal', ' \zs<-', 12, -1, {'conceal': '←'})
  " call matchadd('Conceal', ' \zs=\ze>', 12, -1, {'conceal': '⇒'})
  " call matchadd('Conceal', ' \zs<=', 12, -1, {'conceal': '⇐'})
  " call matchadd('Conceal', ' \zsforall', 12, -1, {'conceal': '∀'})

  " Other Haskell unicode conceals: ~/.vim/plugged/purescript-vim/syntax/purescript.vim#/Conceal%20with%20unicode
" ─^  Conceal with unicode                               ▲

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









