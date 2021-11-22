" Vim color file
"
" Author: Tomas Restrepo <tomas@winterdom.com>
" https://github.com/tomasr/molokai
"
" Note: Based on the Monokai theme for TextMate
" by Wimer Hazenberg and its darker variant
" by Hamish Stuart Macpherson
"

" haskell syntax highlighting"{{{
" ---------------------------------------------------------------------
" For use with syntax/haskell.vim : Haskell Syntax File
" http://www.vim.org/scripts/script.php?script_id=3034
" See also Steffen Siering's github repository:
" http://github.com/urso/dotrc/blob/master/vim/syntax/haskell.vim
" ---------------------------------------------------------------------
"
"
" TODO: show some colors e.g. for TODO: in purescript comments
"       show syntax highlight in purescript comments
"
" Treat True and False specially, see the plugin referenced above
let hs_highlight_boolean=1
" highlight delims, see the plugin referenced above
let hs_highlight_delimiters=1



hi clear

if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="molokai"

if exists("g:molokai_original")
    let s:molokai_original = g:molokai_original
else
    let s:molokai_original = 0
endif

" set background=light
set background=dark

" hi link treeDir  vimString



" hi cPreCondit 
"
" hi VarId                guifg=#F08D24 
" hi ConId                guifg=#F08D24 
" " hi hsImport              
" hi hsString             guifg=#167E6F  gui=italic 
"
" hi hsStructure          guifg=#F08D24 
" hi hs_hlFunctionName    guifg=#F08D24 
" hi hsStatement          guifg=#F08D24 
" " hi hsImportLabel         
" " hi hs_OpFunctionName     
" " hi hs_DeclareFunction    
" hi hsVarSym    guifg=#F08D24          
" hi hsType      guifg=#F08D24         
" hi hsTypedef           guifg=#F08D24 
" hi hsModuleName         
" hi hsModuleStartLabel   



" highlight Normal guibg=#cceeff 

hi vimString guifg=#009900

" darker comments are difficult to view in bright rooms ..
" hi clojureComment guifg=#434547
hi clojureComment guifg=#6D7174
" colorscheme molokai


hi Boolean1         guifg=#8E69C9
hi Boolean2         guifg=#ff6600
hi Boolean3         guifg=#F08D24
hi Boolean4         guifg=#1AEAEA
hi Boolean5         guifg=#3AADAD
hi Boolean6         guifg=#B01C1C
hi Boolean7         guifg=#494B4D
hi Boolean8         guifg=#45F132
hi Boolean8         guifg=#23DD0F
hi Boolean9         guifg=#2097EE
hi Boolean10         guifg=#F1E11D
hi Boolean11         guifg=#F0E624
hi Boolean12         guifg=#F08D24
hi Boolean13         guifg=#8a5c8d  gui=italic


hi Boolean         guifg=#AE81FF
hi Character       guifg=#E6DB74
hi Number          guifg=#AE81FF
hi String          guifg=#E6DB74
hi Conditional     guifg=#F92672               gui=bold
hi Constant        guifg=#AE81FF               gui=bold
hi Cursor          guifg=#000000 guibg=#F8F8F0
" hi Cursor          guifg=#000000 guibg=#F8F800
" test slight yellow
" hi iCursor         guifg=#000000 guibg=#F8F8F0
hi iCursor         guibg=#808080
" hi iCursor gui=reverse guifg=NONE guibg=NONE
" hi iCursor gui=NONE guifg=bg guibg=fg
hi Debug           guifg=#BCA3A3               gui=bold
hi Define          guifg=#66D9EF
hi Delimiter       guifg=#8F8F8F
" hi DiffAdd                       guibg=#13354A
hi DiffChange      guifg=#89807D guibg=#4C4745
hi DiffDelete      guifg=#960050 guibg=#1E0010
hi DiffText                      guibg=#4C4745 gui=italic,bold

hi Directory       guifg=#A6E22E               gui=bold
hi Error           guifg=#E6DB74 guibg=#1E0010
hi ErrorMsg        guifg=#F92672 guibg=#232526 gui=bold
hi Exception       guifg=#A6E22E               gui=bold
hi Float           guifg=#AE81FF
hi FoldColumn      guifg=#465457 guibg=#000000
hi Folded          guifg=#465457 guibg=#000000
" hi Function        guifg=#A6E22E
" hi Keyword        guifg=#88BB29
" hi Keyword        guifg=#2C9E71
hi Keyword        guifg=#2C9E71
" hi purescriptKeyword guifg=#882C9E
" hi purescriptClassName guifg=#882C9E
" hi purescriptType guifg=#882C9E

" Function is purescript signature head and import symbol
hi Identifier      guifg=#FD971F
hi Ignore          guifg=#808080 guibg=bg
hi IncSearch       guifg=#C4BE89 guibg=#000000

" hi Keyword         guifg=#DD040A               gui=bold
hi Label           guifg=#E6DB74               gui=none
hi Macro           guifg=#C4BE89               gui=italic
hi SpecialKey      guifg=#66D9EF               gui=italic

hi MatchParen      guifg=#000000 guibg=#FD971F gui=bold
hi ModeMsg         guifg=#E6DB74
hi MoreMsg         guifg=#E6DB74
" hi Operator        guifg=#F92672
hi Operator        guifg=#E0306F

" complete menu
hi Pmenu           guifg=#66D9EF guibg=#000000
" hi PmenuSel                      guibg=#808080
" hi PmenuSbar                     guibg=#080808
hi PmenuThumb      guifg=#66D9EF

hi PreCondit       guifg=#A6E22E               gui=bold
hi PreProc         guifg=#A6E22E
hi Question        guifg=#66D9EF
hi Repeat          guifg=#F92672               gui=bold
" hi Search          guifg=#000000 guibg=#FFE792
" marks
" hi SignColumn      guifg=#A6E22E guibg=#232526
hi SpecialChar     guifg=#F92672               gui=bold
" hi SpecialComment  guifg=#7E8E91               gui=bold
hi SpecialComment  guifg=#7E8E91           
hi Special         guifg=#66D9EF guibg=bg      gui=italic
if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl
    hi SpellCap    guisp=#7070F0 gui=undercurl
    hi SpellLocal  guisp=#70F0F0 gui=undercurl
    hi SpellRare   guisp=#FFFFFF gui=undercurl
endif
hi Statement       guifg=#F92672               gui=bold
hi StatusLine      guifg=#455354 guibg=fg
hi StatusLineNC    guifg=#808080 guibg=#080808
hi StorageClass    guifg=#FD971F               gui=italic
hi Structure       guifg=#66D9EF
hi Tag             guifg=#F92672               gui=italic
hi Title           guifg=#ef5939
hi Todo            guifg=#FFFFFF guibg=bg      gui=bold

hi Typedef         guifg=#66D9EF
hi Type            guifg=#66D9EF               gui=none
hi Underlined      guifg=#808080               gui=underline

hi VertSplit       guifg=#000000 guibg=#080808 gui=bold
" hi VisualNOS                     guibg=#403D3D
" hi Visual                        guibg=#403D3D
hi WarningMsg      guifg=#FFFFFF guibg=#333333 gui=bold
hi WildMenu        guifg=#66D9EF guibg=#000000

hi TabLineFill     guifg=#1B1D1E guibg=#1B1D1E
hi TabLine         guibg=#1B1D1E guifg=#808080 gui=none

if s:molokai_original == 1
else
   hi Normal          guifg=#F8F8F2 guibg=#1B1D1E
   hi Comment         guifg=#7E8E91
   " hi CursorLine                    guibg=#293739
   hi CursorLine                    guibg=#222525
   hi CursorLineNr    guifg=#FD971F               gui=none
   " hi CursorColumn                  guibg=#293739
   " hi ColorColumn                   guibg=#232526
   hi LineNr          guifg=#303030 
   hi NonText         guifg=#465457
   hi SpecialKey      guifg=#465457
end

set fillchars+=vert:│
" hi VertSplit ctermbg=NONE guibg=NONE

" Copied from https://github.com/dim13/smyck.vim ----------------------------------------------------------------------
"
" Support for 256-color terminal
"
" ----------------------------------------------------------------------------
" Syntax Highlighting
" ----------------------------------------------------------------------------
" hi Function              cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
hi Function              cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
" hi Comment              cterm=none ctermbg=none ctermfg=8           gui=italic      guifg=#8F8F8F
hi Delimiter            cterm=none ctermbg=none ctermfg=15          gui=none        guifg=#F7F7F7
hi Identifier           cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi Structure            cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#9DEEF2
hi Ignore               cterm=none ctermbg=none ctermfg=8           gui=none        guifg=bg
hi Constant             cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi PreProc              cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
" hi Type                 cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi Type                 cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#72BCD6
hi Statement            cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
hi Special              cterm=none ctermbg=none ctermfg=6           gui=none        guifg=#d7d7d7
hi String               cterm=none ctermbg=none ctermfg=3           gui=none        guifg=#F6DC69
hi Number               cterm=none ctermbg=none ctermfg=3           gui=none        guifg=#F6DC69
hi Underlined           cterm=none ctermbg=none ctermfg=5           gui=underline   guibg=#272727
hi Symbol               cterm=none ctermbg=none ctermfg=9           gui=none        guifg=#FAB1AB
hi Method               cterm=none ctermbg=none ctermfg=15          gui=none        guifg=#F7F7F7
hi Interpolation        cterm=none ctermbg=none ctermfg=6           gui=none        guifg=#2EB5C1
" hi Keyword        cterm=none ctermbg=none ctermfg=6           gui=none        guifg=#2EB5C1


" Code copied from: --------------------------------------------------------------------------
" https://github.com/skielbasa/vim-material-monokai


if ! exists("g:materialmonokai_gui_italic")
    let g:materialmonokai_gui_italic = 1
endif

if ! exists("g:materialmonokai_italic")
    let g:materialmonokai_italic = 0
endif

let g:materialmonokai_termcolors = 256 " does not support 16 color term right now.


function! s:h(group, style)
  let s:ctermformat = "NONE"
  let s:guiformat = "NONE"
  if has_key(a:style, "format")
    let s:ctermformat = a:style.format
    let s:guiformat = a:style.format
  endif
  if g:materialmonokai_italic == 0
    let s:ctermformat = substitute(s:ctermformat, ",italic", "", "")
    let s:ctermformat = substitute(s:ctermformat, "italic,", "", "")
    let s:ctermformat = substitute(s:ctermformat, "italic", "", "")
  endif
  if g:materialmonokai_gui_italic == 0
    let s:guiformat = substitute(s:guiformat, ",italic", "", "")
    let s:guiformat = substitute(s:guiformat, "italic,", "", "")
    let s:guiformat = substitute(s:guiformat, "italic", "", "")
  endif
  if g:materialmonokai_termcolors == 16
    let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm16 : "NONE")
    let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm16 : "NONE")
  else
    let l:ctermfg = (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
    let l:ctermbg = (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
  end
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")      ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")      ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")      ? a:style.sp.gui   : "NONE")
    \ "gui="     (!empty(s:guiformat) ? s:guiformat   : "NONE")
    \ "ctermfg=" . l:ctermfg
    \ "ctermbg=" . l:ctermbg
    \ "cterm="   (!empty(s:ctermformat) ? s:ctermformat   : "NONE")
endfunction

" Palettes
" --------


let s:white       = { "gui": "#CDD3DE", "cterm": "253" }
let s:black       = { "gui": "#263238", "cterm": "235" }
let s:lightblack  = { "gui": "#2D2E27", "cterm": "234" }
let s:lightblack2 = { "gui": "#383a3e", "cterm": "236" }
let s:darkblack   = { "gui": "#1F292D", "cterm": "233" }
" let s:grey        = { "gui": "#3F565F", "cterm": "238" }
" let s:grey        = { "gui": "#516569", "cterm": "238" }
let s:grey        = { "gui": "#60777C", "cterm": "238" }
" Used for comments. Derived this from aqua
let s:lightgrey   = { "gui": "#575b61", "cterm": "241" }
let s:darkgrey    = { "gui": "#232E33", "cterm": "236" }
let s:coolgrey    = { "gui": "#506E79", "cterm": "241" }

let s:pink        = { "gui": "#FC3488", "cterm": "197" }
let s:green       = { "gui": "#A6E22E", "cterm": "148" }
" let s:aqua        = { "gui": "#66D9EF", "cterm": "81" }
let s:aqua        = { "gui": "#50D6EF", "cterm": "81" }
" This is used for Keyword now - gave the aqua color 10% more saturation
let s:blue        = { "gui": "#82B1FF", "cterm": "81" }
let s:yellow      = { "gui": "#E6DB74", "cterm": "186" }
let s:orange      = { "gui": "#FD9720", "cterm": "208" }
let s:purple      = { "gui": "#ae81ff", "cterm": "141" }
let s:red         = { "gui": "#e73c50", "cterm": "196" }
let s:darkred     = { "gui": "#5f0000", "cterm": "52" }

let s:addfg       = { "gui": "#d7ffaf", "cterm": "193" }
let s:addbg       = { "gui": "#5f875f", "cterm": "65" }
let s:delbg       = { "gui": "#f75f5f", "cterm": "167" }
let s:changefg    = { "gui": "#d7d7ff", "cterm": "189" }
let s:changebg    = { "gui": "#5f5f87", "cterm": "60" }

" Highlighting
" ------------

" editor
" call s:h("Normal",        { "fg": s:white,      "bg": s:black })
" call s:h("ColorColumn",   {                     "bg": s:lightblack })
" call s:h("CursorColumn",  {                     "bg": s:lightblack2 })
" call s:h("CursorLine",    {                     "bg": s:darkblack })
" call s:h("NonText",       { "fg": s:lightgrey })
" call s:h("StatusLine",    { "fg": s:coolgrey,   "bg": s:black,        "format": "reverse" })
" call s:h("StatusLineNC",  { "fg": s:darkgrey,   "bg": s:coolgrey,     "format": "reverse" })
" call s:h("TabLine",       { "fg": s:white,      "bg": s:darkblack,    "format": "reverse" })
" call s:h("Visual",        {                     "bg": s:lightgrey })
" call s:h("Search",        { "fg": s:black,      "bg": s:yellow })
" call s:h("MatchParen",    { "fg": s:black,      "bg": s:purple })
" call s:h("Question",      { "fg": s:yellow })
" call s:h("ModeMsg",       { "fg": s:yellow })
" call s:h("MoreMsg",       { "fg": s:yellow })
" call s:h("ErrorMsg",      { "fg": s:black,      "bg": s:red,          "format": "standout" })
" call s:h("WarningMsg",    { "fg": s:red })
" call s:h("VertSplit",     { "fg": s:grey,       "bg": s:darkgrey })
" call s:h("LineNr",        { "fg": s:grey,       "bg": s:darkgrey })
" call s:h("CursorLineNr",  { "fg": s:aqua,       "bg": s:darkblack })
" call s:h("SignColumn",    {                     "bg": s:lightblack })
"
" " misc
" call s:h("SpecialKey",    { "fg": s:coolgrey })
" call s:h("Title",         { "fg": s:yellow })
" call s:h("Directory",     { "fg": s:aqua })
"
" " diff
" call s:h("DiffAdd",       { "fg": s:addfg,      "bg": s:addbg })
" call s:h("DiffDelete",    { "fg": s:black,      "bg": s:delbg })
" call s:h("DiffChange",    { "fg": s:changefg,   "bg": s:changebg })
" call s:h("DiffText",      { "fg": s:black,      "bg": s:aqua })
"
" " fold
" call s:h("Folded",        { "fg": s:coolgrey,   "bg": s:darkblack })
" call s:h("FoldColumn",    {                     "bg": s:darkblack })
" "        Incsearch"
"
" " popup menu
" call s:h("Pmenu",         { "fg": s:white,      "bg": s:darkblack })
" call s:h("PmenuSel",      { "fg": s:pink,       "bg": s:white,      "format": "reverse,bold" })
" call s:h("PmenuThumb",    { "fg": s:lightblack, "bg": s:grey })
" "        PmenuSbar"
"
" " Generic Syntax Highlighting
" " ---------------------------
"
" call s:h("Constant",      { "fg": s:purple })
" call s:h("Number",        { "fg": s:purple })
" call s:h("Float",         { "fg": s:purple })
" call s:h("Boolean",       { "fg": s:purple })
" call s:h("Character",     { "fg": s:yellow })
" call s:h("String",        { "fg": s:yellow })
"
" call s:h("Type",          { "fg": s:aqua })
" call s:h("Structure",     { "fg": s:aqua })
" call s:h("StorageClass",  { "fg": s:aqua })
" call s:h("Typedef",       { "fg": s:aqua })
"
" call s:h("Identifier",    { "fg": s:green })
" call s:h("Function",      { "fg": s:green })
"
" call s:h("Statement",     { "fg": s:pink })
" call s:h("Operator",      { "fg": s:pink })
" call s:h("Label",         { "fg": s:pink })
call s:h("Keyword",       { "fg": s:aqua })
" This is actually in use now - gave the aqua color 10% more saturation
" "        Conditional"
" "        Repeat"
" "        Exception"
"
" call s:h("PreProc",       { "fg": s:green })
call s:h("Include",       { "fg": s:coolgrey })
" call s:h("Define",        { "fg": s:pink })
" call s:h("Macro",         { "fg": s:green })
" call s:h("PreCondit",     { "fg": s:green })
"
" call s:h("Special",       { "fg": s:aqua })
" call s:h("SpecialChar",   { "fg": s:pink })
" call s:h("Delimiter",     { "fg": s:red })
" call s:h("SpecialComment",{ "fg": s:aqua })
" call s:h("Tag",           { "fg": s:pink })
" "        Debug"
"
call s:h("Todo",          { "fg": s:aqua,   "format": "bold,italic" })
call s:h("Comment",       { "fg": s:grey, "format": "italic" })
"
" call s:h("Underlined",    { "fg": s:green })
" call s:h("Ignore",        {})
" call s:h("Error",         { "fg": s:red, "bg": s:darkred })

" NerdTree
" --------

call s:h("NERDTreeOpenable",        { "fg": s:pink })
call s:h("NERDTreeClosable",        { "fg": s:pink })
call s:h("NERDTreeHelp",            { "fg": s:yellow })
call s:h("NERDTreeBookmarksHeader", { "fg": s:aqua })
call s:h("NERDTreeBookmarksLeader", { "fg": s:black })
call s:h("NERDTreeBookmarkName",    { "fg": s:yellow })
call s:h("NERDTreeCWD",             { "fg": s:pink })
call s:h("NERDTreeUp",              { "fg": s:white })
call s:h("NERDTreeDirSlash",        { "fg": s:grey })
call s:h("NERDTreeDir",             { "fg": s:coolgrey })

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
