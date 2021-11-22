" Vim color file
"
" Munsell-blue Color scheme. (Custom Matarial Design colors 2018-12)

" Based on Molokai colorscheme:
" Author: Tomas Restrepo <tomas@winterdom.com>
" https://github.com/tomasr/molokai
"
" Note: Based on the Monokai theme for TextMate
" by Wimer Hazenberg and its darker variant
" by Hamish Stuart Macpherson

hi clear

let g:colors_name="munsell-blue-molokai"

" set background=light
set background=dark

hi vimString guifg=#009900

hi Boolean         guifg=#AE81FF
hi Character       guifg=#E6DB74
hi Number          guifg=#AE81FF
hi String          guifg=#E6DB74
" hi Conditional     guifg=#F92672               gui=bold
hi Conditional     guifg=#F92672
hi Constant        guifg=#AE81FF               gui=bold
hi Debug           guifg=#BCA3A3               gui=bold
hi Define          guifg=#66D9EF
" hi Delimiter       guifg=#8F8F8F
hi DiffAdd                       guibg=#13354A
hi DiffChange      guifg=#89807D guibg=#4C4745
hi DiffDelete      guifg=#960050 guibg=#1E0010
hi DiffText                      guibg=#4C4745 gui=italic,bold"

hi Directory       guifg=#A6E22E               gui=bold
hi Error           guifg=#960050 guibg=#1E0010
" hi ErrorMsg        guifg=#F92672 guibg=#232526 gui=bold
hi ErrorMsg        guifg=#960050 guibg=#151719
hi Exception       guifg=#A6E22E               gui=bold
hi Float           guifg=#AE81FF

" hi FoldColumn      guifg=#465457 guibg=#000000
" hi Folded          guifg=#465457 guibg=#000000
hi FoldColumn      guifg=#465457 guibg=#000000
hi Folded          guifg=#465457 guibg=#111111

" Now set as part of munsell colors below
" hi Keyword        guifg=#2C9E71
hi Identifier      guifg=#FD971F
hi Ignore          guifg=#808080 guibg=bg
hi IncSearch       guifg=#C4BE89 guibg=#000000
hi Label           guifg=#3A768C               gui=none
hi Macro           guifg=#C4BE89               gui=italic
hi SpecialKey      guifg=#66D9EF               gui=italic

hi MatchParen      guifg=#000000 guibg=#FD971F gui=bold
hi ModeMsg         guifg=#E6DB74
hi MoreMsg         guifg=#E6DB74
" hi Operator        guifg=#E0306F

" complete menu
hi Pmenu           guifg=#54868E guibg=black
hi PmenuSel        guifg=#54868E guibg=#1C2020
" hi Pmenu           guifg=none guibg=none
" hi PmenuSel        guifg=none guibg=none

hi PreCondit       guifg=#A6E22E               gui=bold
hi PreProc         guifg=#A6E22E
hi Question        guifg=#66D9EF
hi Repeat          guifg=#F92672               gui=bold
hi SpecialChar     guifg=#F92672               gui=bold
hi SpecialComment  guifg=#7E8E91
hi Special         guifg=#2F646E guibg=bg      gui=italic
if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl
    hi SpellCap    guisp=#7070F0 gui=undercurl
    hi SpellLocal  guisp=#70F0F0 gui=undercurl
    hi SpellRare   guisp=#FFFFFF gui=undercurl
endif
hi Statement       guifg=#F92672               gui=bold
" hi StatusLine      guifg=#455354 guibg=fg
" hi StatusLineNC    guifg=#808080 guibg=#080808
hi StatusLine guibg=#000000 gui=bold
hi StatusLineNC guibg=#000000 gui=bold


" hi StorageClass    guifg=#FD971F               gui=italic
hi StorageClass    guifg=#3A768C               gui=none
hi Structure       guifg=#66D9EF
hi Tag             guifg=#F92672               gui=italic
" hi Title           guifg=#ef5939
" hi Todo            guifg=#FFFFFF guibg=bg      gui=bold

hi Typedef         guifg=#66D9EF
hi Type            guifg=#66D9EF               gui=none
hi Underlined      guifg=#808080               gui=underline

hi VertSplit       guifg=#000000 guibg=#080808
hi WarningMsg      guifg=#FFFFFF guibg=#333333 gui=bold
hi WildMenu        guifg=#66D9EF guibg=#000000

hi TabLineFill     guifg=#1B1D1E guibg=#1B1D1E
hi TabLine         guibg=#1B1D1E guifg=#808080 gui=none

" Copied from https://github.com/dim13/smyck.vim ----------------------------------------------------------------------
" ----------------------------------------------------------------------------
" Syntax Highlighting
" ----------------------------------------------------------------------------
hi Function              cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
" hi Delimiter            cterm=none ctermbg=none ctermfg=15          gui=none        guifg=#F7F7F7
hi Identifier           cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi Structure            cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#9DEEF2
hi Ignore               cterm=none ctermbg=none ctermfg=8           gui=none        guifg=bg
hi Constant             cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi PreProc              cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
hi Type                 cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#72BCD6
hi Statement            cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
" hi Special              cterm=none ctermbg=none ctermfg=6           gui=none        guifg=#d7d7d7
hi String               cterm=none ctermbg=none ctermfg=3           gui=none        guifg=#F6DC69
hi Number               cterm=none ctermbg=none ctermfg=3           gui=none        guifg=#F6DC69
hi Underlined           cterm=none ctermbg=none ctermfg=5           gui=underline   guibg=#272727
hi Symbol               cterm=none ctermbg=none ctermfg=9           gui=none        guifg=#FAB1AB
hi Method               cterm=none ctermbg=none ctermfg=15          gui=none        guifg=#F7F7F7
hi Interpolation        cterm=none ctermbg=none ctermfg=6           gui=none        guifg=#2EB5C1

" Code copied from: --------------------------------------------------------------------------
" https://github.com/skielbasa/vim-material-monokai
if ! exists("g:materialmonokai_gui_italic")
    let g:materialmonokai_gui_italic = 1
endif

if ! exists("g:materialmonokai_italic")
    let g:materialmonokai_italic = 0
endif

let g:materialmonokai_termcolors = 256 " does not support 16 color term right now.

" function! s:h(group, style)
"   let s:ctermformat = "NONE"
"   let s:guiformat = "NONE"
"   if has_key(a:style, "format")
"     let s:ctermformat = a:style.format
"     let s:guiformat = a:style.format
"   endif
"   if g:materialmonokai_italic == 0
"     let s:ctermformat = substitute(s:ctermformat, ",italic", "", "")
"     let s:ctermformat = substitute(s:ctermformat, "italic,", "", "")
"     let s:ctermformat = substitute(s:ctermformat, "italic", "", "")
"   endif
"   if g:materialmonokai_gui_italic == 0
"     let s:guiformat = substitute(s:guiformat, ",italic", "", "")
"     let s:guiformat = substitute(s:guiformat, "italic,", "", "")
"     let s:guiformat = substitute(s:guiformat, "italic", "", "")
"   endif
"   if g:materialmonokai_termcolors == 16
"     let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm16 : "NONE")
"     let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm16 : "NONE")
"   else
"     let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
"     let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
"   end
"   execute "highlight" a:group
"     \ "guifg="   (has_key(a:style, "fg")      ? a:style.fg.gui   : "NONE")
"     \ "guibg="   (has_key(a:style, "bg")      ? a:style.bg.gui   : "NONE")
"     \ "guisp="   (has_key(a:style, "sp")      ? a:style.sp.gui   : "NONE")
"     \ "gui="     (!empty(s:guiformat) ? s:guiformat   : "NONE")
"     \ "ctermfg=" . l:ctermfg
"     \ "ctermbg=" . l:ctermbg
"     \ "cterm="   (!empty(s:ctermformat) ? s:ctermformat   : "NONE")
" endfunction




" Munsell Blue Colors: -------------------------
" Colorscheme: https://coolors.co/0087af-76e0d9-aab27c-983b4d-065143

" Tools:
" > current Highlights
" command! HighlightTest exec "source $VIMRUNTIME/syntax/hitest.vim"
" > disable highlighting for a group
" hi clear DataConstructor
" > where was the highlight set?
" verbose hi DataConstructor

" * Syntax stack
" `<leader>hsg :call SyntaxStack()`
" * Syntax group → Highlight group
" `<leader>hhg :call SyntaxGroup()`
" * Highlight group - color values
" `<leader>hsc :call SyntaxColor()
" `
" > Highligh color values in the current line
" `nnoremap <leader>hcc :,ColorHighlight<CR>`
" `nnoremap <leader>hcd :ColorClear<CR>`

" Get syntax group
" echo synIDattr( synID( line('.'), col('.'), 0), 'name' )

" PURESCRIPT HASKELL COLORS: ---------------------------

" purescriptFunction > Function
" hi! Function guifg=#0087AF "munsell blue"
hi! Function guifg=#008EB8 "munsell blue"

hi! purescriptFunction guifg=#008EB8 guibg=#000000

" purescriptIdentifier > purescriptIdentifier
" hi! purescriptIdentifier guifg=#E7F4F7 "anti flash white"
hi! purescriptIdentifier guifg=#BECACD "white-grey"
"sort of nice soft yellow ..
" hi! purescriptIdentifierDot1 guifg=#BECA00
hi! purescriptIdentifierDot1 guifg=#8E989A
hi! purescriptLens1 guifg=#6E7B84
hi! purescriptRecordKeys guifg=#42727A
hi! purescriptDelimiter guifg=#2D4F54
" hi! purescriptOperator guifg=#32575E
hi! purescriptOperator guifg=#3A666E
hi! purescriptColon guifg=#2D4E54
hi! Operator guifg=#335A60



" purescriptType > Type
" hi! Type guifg=#76E0D9 "middle blue"
" hi! Type guifg=#6DC2BC "middle blue"
hi! Type guifg=#548F84
" hi! hsTypeComment guifg=#45837F "Types in comments - toned down: brightness: 88 -> 51
hi! link hsTypeComment Comment
" hi! link hsForall Comment

" purescriptTypeVar > Identifier
hi! Identifier guifg=#AAB27C "Misty moss - shift sage yellow from red to green"
hi! hsTypeVarComment guifg=#4C5037 "Type vars in comment - toned down: 70 -> 32

" purescriptConstructor
hi! DataConstructor guifg=#983B4D "smoky topaz red"
" hi! def link purescriptConstructor DataConstructor
" hi! purescriptConstructor guifg=#73615B
" hi! purescriptConstructor guifg=#5C6C60
hi! purescriptConstructor guifg=#607062

" purescipt Import section
hi! def link purescriptModule Comment
hi! def link purescriptImport Comment
hi! def link purescriptImportParams Statement
hi! def link purescriptImportAs Type
" hi! def link purescriptRecordKeys Identifier

let g:color_sacramento_green_brighterD = '#066150'
let g:color_sacramento_green_brighter = '#077D67'

" purescriptNumber > Number
hi! def link purescriptNumber Number
exec 'hi! Number guifg=' . g:color_sacramento_green_brighter

" purescriptFloat > Float
exec 'hi! Float guifg=' . g:color_sacramento_green_brighter

" purescriptString > String
exec 'hi! String guifg=' . g:color_sacramento_green_brighter

" purescriptBoolean > Boolean
" exec 'hi! Boolean guifg=' . g:color_sacramento_green_brighter
hi! Boolean guifg=#66A279
hi! String guifg=#66A279

hi! hsTopLevelBind guifg=#459AB3 guibg=#0C0C0C
hi! tsBind guifg=#459AB3

hi! purescriptState guibg=#141414 guifg=#3A3935
hi! purescriptStateKey guibg=none guifg=#807A6F
" hi! purescriptEvent guibg=black guifg=#99714F
hi! purescriptEventKey guibg=none guifg=#884137

hi! purescriptClasses guibg=none guifg=#364347
" hi! purescriptClassesTW guifg=#7A8183
hi! purescriptClassesBG guibg=none guifg=#364347

" hi! purescriptStateKey guibg=none guifg=#807460
" hi! purescriptState guifg=#BECACD guibg=#13354A
" hi! purescriptState guifg=#BECACD guibg=#54320A
" hi! purescriptState guibg=black guifg=#544136
" hi! purescriptStateKey guibg=black guifg=#483F2F
" hi! purescriptStateKey guibg=black guifg=#42727A
" hi! purescriptStateKey guibg=none guifg=#938877
" hi! purescriptState guibg=black guifg=#555C2E

let g:color_ming_green_dark = '#3C6B7C '
let g:color_ming_green_dark2 = '#284753 '
let g:color_ming_green = '#3A768C '

" purescriptStructure (data) > Keyword
exec 'hi! Keyword guifg=' . g:color_ming_green

" purescriptOperator > Operator
" exec 'hi! Operator guifg=' . g:color_ming_green
" Note: Operator is (automatically?!) linked to all concealed symbols!
exec 'hi! Operator guifg=' . g:color_ming_green_dark
" exec 'hi! Operator guifg=' . g:color_ming_green_dark2

" purescriptDelimiter > Delimiter
exec 'hi! Delimiter guifg=' . g:color_ming_green

" purescriptStatement (do and let) > Statement
exec 'hi! Statement guifg=' . g:color_ming_green

hi! fnWireframe guifg=#2B5766 guibg=#0C0C0C

" purescriptConditional > Conditional
exec 'hi! Conditional guifg=' . g:color_ming_green


" Magit Git colors
hi! def link fileEntry Function
hi! def link diffAdded Type
hi! def link diffRemoved Macro
hi! def link gitHunk Comment
hi! def link diffSubname Comment

" VimScript colors
hi! Todo guibg=bg guifg=#F92672
hi! def link vimCommentTitle Type
hi! def link vimString String
hi! def link vimCommand purescriptStructure
hi! def link vimFunction purescriptFunction
hi! def link vimUserFunc vimFuncName
hi! def link vimOperParen purescriptIdentifier
hi! def link vimIsCommand purescriptIdentifier
hi! def link vimFgBgAttrib String
hi! def link vimHiAttrib String
hi! VimOption guifg=#F92672
hi! def link vimOption String
" hi! link vimMapRhs purescriptRecordKeys
" hi! link vimMapRhs purescriptConstructor
hi! link vimMapRhs purescriptIdentifierDot1
" hi! link vimVar purescriptTypeVar
hi! link vimVar purescriptIdentifierDot1
hi! link vimFuncVar purescriptTypeVar


" Vim help colors
hi! def link helpHyperTextEntry Type
hi! def link helpHyperTextJump DataConstructor
hi! def link helpOption DataConstructor
hi! def link helpStar DataConstructor
hi! def link helpExample DataConstructor
hi! def link helpCommand DataConstructor

" Tagbar colors
hi! def link TagbarSignature Type
hi! def link TagbarScope Function
hi! def link TagbarType Keyword
hi! def link TagbarKind Type

" Markdown colors
hi! Title gui=bold guifg=#0087AF "munsell blue"
hi! Highlight1 guifg=#F6DC69

hi! def link mkdHeading Operator
hi! def link mkdNonListItemBlock purescriptIdentifier
hi! def link mkdListItemLine purescriptIdentifier
hi! def link mkdListItemLine mkdListItemLine
hi! def link mkdCode Statement
hi! def link mkdListItem Type
" hi! Underlined2 guifg=#3C6B7C guibg=#0C0C0C gui=italic
" hi! Underlined2 guifg=#BECACD guibg=#0C0C0C gui=italic
hi! Underlined2 guifg=#077D67 guibg=#0C0C0C gui=italic
hi! def link mkdInlineURL Underlined2
hi! def link mkdLink Underlined2
" hi! def link htmlBold htmlBold
" hi! def link htmlItalic htmlItalic

" Dirvish{{{
hi! def link DirvishPathTail Function
hi! def link DirvishArg DataConstructor

" Markbar
exec 'hi! DarkHeader guifg=' . g:color_ming_green_dark
hi! link markbarHeader DarkHeader
hi! link markbarID Highlight1

" Editor & Quickfix
" hi LineNr guifg=#404040
hi FoldColumn guibg=gray10 guifg=gray20
hi Folded     guifg=#3D5862 guibg=#121212

hi SignColumn guifg=#3D5862 guibg=#121212


hi link QuickmenuHeader htmlLink
hi link QuickmenuBracket Comment
hi link QuickmenuSection Comment
hi link QuickmenuOption purescriptIdentifier
hi link QuickmenuNumber hsTypeComment
" QuickmenuSelect			Title
" QuickmenuSection		Statement
" QuickmenuSelect			Title
" QuickmenuNumber			Number
" QuickmenuSpecial		Comment
" QuickmenuHeader			Title
" QuickmenuOption			Identifier
" QuickmenuHelp			Comment

" Vim Native HighlighGroups:
" This is where to set the main background color
" hi Normal          guifg=#F8F8F2 guibg=#1B1D1E
" hi Normal          guifg=#F8F8F2 guibg=#151719
" hi Normal          guifg=#48636E guibg=#151719
hi Normal          guifg=#3F5C66 guibg=#151719
" I made the Normal color a 'default grey' - similar to how Comment was before
" to distinguish I dimmed down the comment brightness

" hi Comment         guifg=#3D5862
hi Comment         guifg=#344B53

" Conceal: Leaving the default link to Operator currently
" hi conceal         guifg=#BCBCBC guibg=none
" exec 'hi conceal guifg=' . g:color_ming_green

" Note: Cursor is show with inverted bg-fg colors by alacritty.
" Could alternatively activate custom colors in alacretty settings
" Not sure when this is unsed
hi Cursor          guifg=#000000 guibg=#F8F8F0
" Only bg color seems to have an effect in nvim + Alacritty
hi iCursor         guibg=#727272

" Contrast Of CursorLine:
hi CursorLine                    guibg=#1C2020

hi CursorLineNr    guifg=#FD971F               gui=none
hi LineNr          guifg=#303030
hi NonText         guifg=#465457
hi SpecialKey      guifg=#465457

" Seach
hi Search guibg=#3E3E3E guifg=#FFFFFF gui=none

" Visual selection
hi Visual guibg=#2E2E2E gui=none

" Hides the tilde at non-existent lines at the end of the buffer
hi! EndOfBuffer guifg=bg

" Comment syntax additions
hi BlackBG guibg=#000000
hi GreyBG guibg=#262626
hi CommentSection guifg=#42606B guibg=#0E0E0E
hi CommentLabel   guifg=#42606B guibg=#030303

hi htmlLink guifg=#42606B guibg=#030303

" run: RedirMessagesBuf hi Folded
" to get:
" guifg=#4B5B61 guibg=#0B0B0B
" Folded         xxx ctermfg=4 ctermbg=248 guifg=#0087af guibg=#afd7ff
" → write command so input color into code
" JSON colors for ".vim/plugged/vim-json/syntax/json.vim" syntax file
hi link jsonPadding   Operator
hi link jsonString    vimString
hi link jsonTest			Label
hi link jsonEscape		Special
hi! link jsonNumber		Function
hi link jsonBraces		Delimiter
hi link jsonNull			Include
hi link jsonBoolean		Boolean
hi link jsonKeyword		Keyword
hi link jsonCommentError				Error

" Custom Coloring: --
" Examples: 1. run "leader hh / SyntaxStack" to get the syntax group under the cursor
"           2. this links the vimCommentTitle systax group to the Error highlight group
" highlight! def link vimCommentTitle Error
" This removes any highlighs (colors) defined for the syntax group
" highlight! link vimCommentTitle NONE

" Overwrite the 'Normal' highlight group
" highlight! Normal guifg=Yellow guibg=Green
" highlight! Normal guifg=White guibg=Black

highlight! def link vimMapRhs Macro

" highlight! Normal guifg=Yellow guibg=Green
" Function       xxx ctermfg=10 guifg=#D1FA71

hi link yamlBlockMappingKey Define
hi link yamlBlockCollectionItemStart Delimiter
hi link yamlKeyValueDelimiter Delimiter
hi link yamlPlainScalar purescriptIdentifier

" cabalStatement -> Statement
" yamlBlockMappingKey -> Identifier
" cabalDelimiter -> Delimiter
" yamlBlockCollectionItemStart -> Label
" yamlPlainScalar -> yamlPlainScalar
" yamlKeyValueDelimiter -> Special

hi link dhallLabel Define


hi link CocErrorHighlight NONE
hi link CocWarningHighlight NONE
" underline seems not visible?
hi link CocErrorFloat purescriptIdentifier
hi link CocWarningFloat purescriptIdentifier

hi link CocErrorSign purescriptIdentifier
hi link CocWarningSign purescriptIdentifier
hi link CocInfoSign purescriptIdentifier

" BG color of floating win?
hi Quote ctermbg=109 guifg=#83a598


" ─   Typescript / React                                ──

" hi! def link tsRecordKeys purescriptRecordKeys
hi! tsRecordKeys guifg=#2C5B62

" dark red
" hi tsxTagName guifg=#E06C75
hi! def link tsxTagName Function
" hi tsxComponentName guifg=#E06C75
hi! def link tsxComponentName Function
" hi tsxCloseComponentName guifg=#E06C75
" hi! def link tsxCloseComponentName Function
hi tsxCloseComponentName guifg=#008EB8
" orange
" hi tsxCloseString guifg=#F99575
hi! def link tsxCloseString purescriptIdentifier

" hi tsxCloseTag guifg=#F99575
" hi! def link tsxCloseTag Normal
hi tsxCloseTagName guifg=#1C6277
" orange

" hi! def link tsxCloseTag Function

" hi tsxCloseTagName guifg=#F99575
" hi! def link tsxCloseTagName purescriptFunction

" hi tsxAttributeBraces guifg=#F99575
hi! def link tsxAttributeBraces Conditional

" hi tsxEqual guifg=#F99575
hi! def link tsxEqual Keyword

" yellow
" hi tsxAttrib guifg=#F8BD7F cterm=italic
hi! def link tsxAttrib purescriptRecordKeys
" hi! def link tsxAttrib Type
" hi tsxAttrib guifg=#006666

" light-grey
hi tsxTypeBraces guifg=#999999
" dark-grey
hi tsxTypes guifg=#666666
" hi! foldBraces guifg=#666666

" hi ReactState guifg=#000000
hi! def link ReactState DataConstructor

hi ReactProps guifg=#607062 gui=italic
" hi! def link ReactProps purescriptConstructor

hi ApolloGraphQL guifg=#CB886B
hi Events ctermfg=204 guifg=#56B6C2
hi ReduxKeywords ctermfg=204 guifg=#C678DD
" hi HooksKeywords ctermfg=204 guifg=#C176A7
" hi! def link HooksKeywords DataConstructor
hi! HooksKeywords guifg=#804D57
hi! def link ReduxHooksKeywords HooksKeywords
" hi! def link typescriptGlobalObjects purescriptConstructor
hi! typescriptGlobalObjects guifg=#607062 gui=italic
hi! typescriptGlobalNodeObjects guifg=#607062 gui=italic
hi! def link graphqlType purescriptType
hi! def link graphqlString purescriptLineComment

hi WebBrowser ctermfg=204 guifg=#56B6C2
hi ReactLifeCycleMethods ctermfg=204 guifg=#D19A66

hi! def link typescriptEndColons Comment
hi! def link typescriptBraces Comment
hi! def link tsxTag Comment
hi! def link tsxCloseTag Comment

hi! def link foldBraces purescriptIdentifier





