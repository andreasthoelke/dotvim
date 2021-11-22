
" To review any config data changes (e.g. styling) source the following 3 lines
" To reload config data, then change tab to refresh
" call lightline#init()
" call lightline#update()
" call lightline#colorscheme()

command! CursorColumnInStatusline call CursorColumnInStatusline()
" Can also just use "g<c-g>" to output the cursor position

func! CursorColumnInStatusline()
  let g:lightline.active.right = [ ['scrollbar'], ['column', 'line'] ]
  call lightline#init()
  call lightline#update()
endfunc

command! StatuslineMoreInfos call StatuslineMoreInfos()
func! StatuslineMoreInfos()
  " Show more on inactive windows
  let g:lightline.inactive.right = [ ['scrollbar'], ['line'] ]
  call CursorColumnInStatusline()
endfunc

func! TagInStatusline()
  let g:lightline.active.right = [ ['scrollbar'], ['column', 'line', 'tagbar'] ]
  call lightline#init()
  call lightline#update()
endfunc

let g:lightline = {}
let g:lightline.colorscheme = 'wombat1'
" let g:lightline.colorscheme = 'default'

let g:lightline.active = {}
let g:lightline.inactive = {}
let g:lightline.active.left = [ ['relativepath'] ]
let g:lightline.inactive.left = [ ['relativepath'] ]

" let g:lightline.active.right = [ ['lineinfo', 'percent']
"                              \ , ['fpathBNum', 'percent']
"                              \ , ['filename', 'fpathBNum'] ]

let g:lightline.active.right = [ ['scrollbar'], ['line'] ]
let g:lightline.inactive.right = [ ['scrollbar'] ]
" let g:lightline.active.right = [ ['scrollbar'], ['line', 'column'] ]
" let g:lightline.active.right = [ ['line', 'percent'] ]
" let g:lightline.inactive.right = [ ['scrollbar'] ]
" let g:lightline.inactive.right = [ [] ]
" \ , ['gitbranch']
" \ ]

let g:lightline.tabline = {}
let g:lightline.tabline.left  = [ [ 'tabs' ] ]
let g:lightline.tabline.right = []

let g:lightline.tab = {
      \ 'active':   [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

" let g:lightline.subseparator = { 'left': '|', 'right': '|' }
let g:lightline.subseparator = { 'left': '', 'right': '|' }

" {noscrollbar#statusline(30,'\ ','■')}

let g:lightline.component = {}
let g:lightline.component.helloworld = 'hi there!'
let g:lightline.component.fpathBNum = '%f%n'

let g:lightline.component_function = {}
let g:lightline.component_function.gitbranch = 'fugitive#head'
let g:lightline.component_function.scrollbar = "LightlineScrollbar"
let g:lightline.component_function.tagbar = 'LightlineTagbar'

func! LightlineScrollbar()
  return noscrollbar#statusline(20,' ','■')
endfunc

func! LightlineTagbar()
  return tagbar#currenttag('%s', '')
endfunc

" Powerline symbols (work)
" let g:lightline = {
"   \ 'component': {
"   \   'lineinfo': ' %3l:%-2v',
"   \ },
"   \ 'component_function': {
"   \   'readonly': 'LightlineReadonly',
"   \   'fugitive': 'LightlineFugitive'
"   \ },
"   \ 'separator': { 'left': '', 'right': '' },
"   \ 'subseparator': { 'left': '', 'right': '' }
"   \ }
" function! LightlineReadonly()
"   return &readonly ? '' : ''
" endfunction
" function! LightlineFugitive()
"   if exists('*fugitive#head')
"     let branch = fugitive#head()
"     return branch !=# '' ? ''.branch : ''
"   endif
"   return ''
" endfunction


" Example: Overwriting the readonly component function
" let g:lightline.component_function.readonly = 'LightlineReadonly'
" Show a vim var dependant to the filetype var
func! LightlineReadonly()
  " return &readonly && &filetype !=# 'gitcommit' ? 'RO' : '-|-'
  return &readonly && &filetype !~# '\v(help|gitcommit)' ? 'RO' : ''
endfunc

" Lightline Settings: -------------------------------}}}



" ─   Promptline                                         ■

" Workflow: To produce a .promptline.sh (referenced in .zshrc) based on theme and symbols defiled below:
" Source this file once more - ":so %"! - otherwise symbols are not recognized
" Then do "PromptlineSnapshot! ~/.promptline.sh" to overwrite, then Alacritty
" (this does not need airline any more!)

" Creates a (zsh) command prompt based on vim-airline style: "PromptlineSnapshot ~/.promptline.sh airline" then in zsh: "source .promptline.sh"
" sections (a, b, c, x, y, z, warn) are optional
" This is a main value of promptline: it allows to easily configure how the terminal/shell prompt is set up:
let g:promptline_preset = {
      \'b' : [ '$vim_mode' ],
      \'c' : [ promptline#slices#cwd({ 'dir_limit': 3 }) ],
      \'y' : [ promptline#slices#vcs_branch() ],
      \'z' : [ promptline#slices#jobs() ],
      \'warn' : [ promptline#slices#last_exit_code() ]}

hi PromptlineB_vimMode    guifg=#EAEAEA guibg=#284954
hi PromptlineC_folderPath guifg=#42606B guibg=#0E0E0E
hi PromptlineY_gitBranch  guifg=#EFEFEF guibg=#2F2F2F
hi PromptlineZ_bgJobs     guifg=#3C6B7C guibg=#030303
hi PromptlineWarn         guifg=#A22E44 guibg=#030303

let g:promptline_theme =  {
      \'b'    : GetHiGuiColorList( 'PromptlineB_vimMode' ),
      \'c'    : GetHiGuiColorList( 'PromptlineC_folderPath' ),
      \'y'    : GetHiGuiColorList( 'PromptlineY_gitBranch' ),
      \'z'    : GetHiGuiColorList( 'PromptlineZ_bgJobs' ),
      \'warn' : GetHiGuiColorList( 'PromptlineWarn' )}

" Some colors used:
" let g:color_ming_green_dark = '#3C6B7C '
" let g:color_ming_green = '#3A768C '
" let g:color_sacramento_green_brighter = '#077D67'

let g:promptline_powerline_symbols = 0
let g:promptline_symbols = {
      \ 'left'           : '',
      \ 'right'          : '',
      \ 'left_alt'       : '>',
      \ 'right_alt'      : '<',
      \ 'dir_sep'        : ' / ',
      \ 'truncation'     : '⋯',
      \ 'vcs_branch'     : '',
      \ 'battery'        : '',
      \ 'space'          : ' '}

" ─^  Promptline                                         ▲


" https://unicode-table.com

" two charater unicode symbols can ge displayed in vim, but not in promptline/alacritty?
"   ⁞⋮  ⬜ ｜  ︱

" function! StatuslineArglistIndicator()

" Statusline: -----------------------------------------------------
" The setup I like
" set statusline=%<%f\ %h%m%r%=%.(%l,%c%V%)\%{noscrollbar#statusline(30,'\ ','■')}


" https://hackernoon.com/the-last-statusline-for-vim-a613048959b2
" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{noscrollbar#statusline()}
" Highres
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{noscrollbar#statusline(20,'■','◫',['◧'],['◨'])}

" set statusline=%f
" set statusline=%{StatuslineArglistIndicator()}
" set statusline=[%n]
" StatuslineArglistIndicator()
" %{noscrollbar#statusline(20,'■','◫',['◧'],['◨'])}
" %{argc()>0?("A[".repeat("-",argidx()).(expand("%")==argv(argidx())?"+":"~").repeat("-",argc()-argidx()-1)."]"):""}gcc
" showmode

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" airline /statusline config

" Statusline: -----------------------------------------------------


" Tabline: -----------------------



