
" ─   Filetype Specific Maps Tools Syntax               ──
au ag BufNewFile,BufRead,WinNew *.hs call HaskellSyntaxAdditions()
au ag BufNewFile,BufRead        *.hs call HaskellMaps()

au ag BufNewFile,BufRead,WinNew *.purs call HaskellSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.js,*.ts,*.tsx call JsSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.graphql call GraphQLSyntaxAdditions()

" au ag BufNewFile,BufRead *.purs setfiletype purescript
" this is now moved to ftdetect folder - not sure if this is needed
" ~/.vim/ftdetect/purescript.vim#/au%20BufNewFile,BufRead%20*.purs
au ag BufNewFile,BufRead        *.purs call HaskellMaps()

au ag BufNewFile,BufRead,WinNew *.vim,*.vimrc call VimScriptSyntaxAdditions()
au ag BufNewFile,BufRead,WinNew *.md          call VimScriptSyntaxAdditions()
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

func! JsSyntaxAdditions()
  call matchadd('Conceal', '"', -1, -1, {'conceal': ''})
  call matchadd('Conceal', '// ', -1, -1, {'conceal': ''})
  call matchadd('Conceal', "'", -1, -1, {'conceal': ''})
  set conceallevel=2
endfunc

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

func! VimScriptSyntaxAdditions() " ■
  call CodeMarkupSyntaxHighlights()
  " Hide comment character at beginning of line
  call matchadd('Conceal', '\v^\s*\zs"\s', 12, -1, {'conceal': ''})
  " Hilde \" before comment after code
  call matchadd('Conceal', '\s\zs\"\ze\s', 12, -1, {'conceal': ''})
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









