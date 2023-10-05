

let g:metals_status = ""

" NVIM-scrollview config:

let g:scrollview_current_only = 1
let g:scrollview_column = 1
" Transparency only works when scrollview_character is ''/empty
" let g:scrollview_winblend = 90
let g:scrollview_character = '▐'
" let g:scrollview_character = '▌'
" let g:scrollview_character = ''

" hi ScrollView guibg=none guifg=#121416
" ~/.vim/colors/munsell-blue-molokai.vim#/hi%20ScrollView%20guibg=none


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

" This only sources colors relevant to the statusline:
source ~/.vim/colors/wombat_2.vim

let g:lightline = {}
let g:lightline.colorscheme = 'wombat_2'
" let g:lightline.colorscheme = 'default'

func! TestSL()
  " let g:lightline.active.right = [ ['scrollbar'], ['column', 'line'] ]
  " let g:lightline.inactive.right = [ ['winnr', 'line'] ]
  " let g:lightline.inactive.right = [ ['projectRootFolderNameOfWin', 'line'] ]
  " let g:lightline.active.right = [ ['winnr', 'line'] ]
  call lightline#init()
  call lightline#update()
endfunc


" ─   Status-line left & right components               ──
let g:lightline.active = {}
let g:lightline.inactive = {}


func! StatusLine_default()
  let g:lightline.active.left   = [ [], ['projectRootFolderName'], ['relativepath_fresh'] ]
  let g:lightline.active.right = [ ['scrollbar'], ['line'], ['db', 'pyVirtEnvStr', 'scalaMetalsStatus'] ]
  call lightline#init()
  call lightline#update()
endfunc

func! StatusLine_neotree()
  let g:lightline.active.left   = [ ['ntree_rootdirrel'], ['cwdinfo'] ]
  let g:lightline.active.right = []
  call lightline#init()
  call lightline#update()
endfunc
"   ~/.config/nvim/notes/minor
"   ~/.config | nvim | notes/minor
"   ~/Documents/Proj/_repos/6_smithy-jobby/modules/backend/src/main/scala/
"   ~/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala/com/softwaremill/realworld/articles/comments/api
"   P _repos || src/main/scala/com/softwaremill/realworld/articles/comments/api


"   H Documents Proj _repos ╎ src/main/scala/com/softwaremill/realworld/articles/comments/api

"   H Documents Proj _repos ∥ src/main/scala/com/softwaremill/realworld/articles/comments/api

"   H Documents Proj _repos ‖ src/main/scala/com/softwaremill/realworld/articles/comments/api

"   H Documents Proj _repos ‖ src main scala com softwaremill realworld articles comments

"   ‖ src main scala com softwaremill realworld articles comments

"   P _repos ‖ src main

"   H Documents |Proj| _repos ‖

"   H Documents Proj |_repos| ‖

"   H Documents Proj |d_diff_proj|
"
"   just replace the cdw with || (highlighted?)
"   highlight the tail / tree root?
"   replace the base
"   use space when joining
"
"   two abs paths
"   tree-root, cwd

"   inner tree root = subtract cwd from treeroot
"   when inner-tree-root == tree-root => tree-root outside cwd
"   else                              => tree-root inside cwd

"   inner cwd = subtract treeroot from cwd
"   when inner-cwd == cwd => cwd outside tree-root
"   else                  => cwd inside tree-root

" ─   tree-root  <>  cwd   4 relationship cases         ──

" 1 troot_in_cwd
"   /Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3
"   /Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala" )
"   H Documents Proj _repos ‖ src main scala com softwaremill realworld articles |comments|
"   H Documents Proj _repos ‖ src |main|
  " -> 3 path segments

" 2 troot_is_cwd
"   /Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3
"   /Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3
"   H Documents Proj _repos |‖|
  " -> 1 path segment

" 3 troot_out_cwd__cwd_in_troot
"   /Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3
"   /Users/at/Documents/Proj
"   H Documents |Proj| _repos ‖
"   -> 3 path segments

" 4 troot_out_cwd__cwd_out_troot
"   /Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3
"   /Users/at/Downloads/temp
"   /Users/at/Documents/Proj/_repos/11_spoti_gql_muse/src/test
"   H Documents |Proj|
"   -> 1 path segment


func! RootPathInfo_RenderCaseAndSegments( cwd, tree_root )
  let troot_minus_cwd = a:tree_root->substitute( a:cwd, '', '' )
  let cwd_minus_troot = a:cwd->substitute( a:tree_root, '', '' )
  let troot_changed = a:tree_root > troot_minus_cwd
  let cwd_changed   = a:cwd > cwd_minus_troot
  " return [ troot_changed, troot_minus_cwd, cwd_changed, cwd_minus_troot ]

  let troot_minus_cwd_L = split( BasePath_shorten( troot_minus_cwd ), '/')
  let cwd_minus_troot_L = split( BasePath_shorten( cwd_minus_troot ), '/')
  let cwd_L             = split( BasePath_shorten( a:cwd ), '/')
  let tree_root_L       = split( BasePath_shorten( a:tree_root ), '/')

  if     troot_changed && cwd_changed
    return [ 'troot_is_cwd', cwd_L[:-2], '‖' ] " H Documents Proj _repos |‖|
  elseif !troot_changed && !cwd_changed
    return [ 'troot_out_cwd__cwd_out_troot', tree_root_L[:-2], tree_root_L[-1] ] " H Documents |Proj|
  elseif troot_changed && !cwd_changed
    return [ 'troot_in_cwd', cwd_L[:-2], '‖', troot_minus_cwd_L[:-2], troot_minus_cwd_L[-1] ] " H Documents Proj _repos ‖ src |main|
  elseif !troot_changed && cwd_changed
    return [ 'troot_out_cwd__cwd_in_troot', tree_root_L[:-2], tree_root_L[-1], cwd_minus_troot_L[:-2], '‖' ] " H Documents Proj _repos ‖ src |main|
  else
    echoe "unmatched case in RootPathInfo_RenderCaseAndSegments"
  endif
endfunc

" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala" )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3" )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj" )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/11_spoti_gql_muse/src/test" )

func! BasePath_shorten( absPath )
  let p = a:absPath->substitute( '/Users/at/Documents/Proj', 'P', '' )
  let d = a:absPath->substitute( '/Users/at/Documents', 'D', '' )
  let c = a:absPath->substitute( '/Users/at/.config', 'C', '' )
  let h = a:absPath->substitute( '/Users/at', 'H', '' )
  if p[0] != '/' | return p | endif
  if d[0] != '/' | return d | endif
  if c[0] != '/' | return c | endif
  if h[0] != '/' | return h | endif
endfunc
" BasePath_shorten("/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3")
" BasePath_shorten("/Users/at/Documents/another/innerfolder")
" BasePath_shorten("/Users/at/.config/nvim/plugin")
" BasePath_shorten("/Users/at/Downloads/temp")

func! Ntree_rootDir()
  let pathList = split( v:lua.Ntree_current().rootpath, '/' )
  return pathList[ len( pathList ) - 1 ]
endfunc

func! Ntree_rootDirRel()
  let path = v:lua.Ntree_current().rootpath 
  let cwd = getcwd()
  let cwdList = split( cwd, '/' )
  let relPath = substitute( path, cwd, '', '' )
  let relPath = substitute( relPath[1:], 'Users/at/', '~/', 'g' )
  " return len( relPath ) ? relPath : cwdList[ len(cwdList) - 1 ]
  return len( relPath ) ? relPath : "|"
endfunc



func! Ntree_parentDir()
  let pathList = split( v:lua.Ntree_current().rootpath, '/' )
  return "|" . pathList[ len( pathList ) - 2 ]
endfunc

func! Ntree_linepath()
  return v:lua.Ntree_current().linepath
endfunc

func! CwdInfo()
  let cwd = getcwd()
  let cwdList = split( cwd, '/' )
  return "ˍ" . cwdList[ len( cwdList ) - 1 ] . "ˍ"
endfunc



" Left side:
let g:lightline.active.left   = [ [], ['projectRootFolderName'], ['relativepath_fresh'] ]
let g:lightline.inactive.left   = [ ['projectRootFolderNameOfWin'], ['relativepathOfWin'] ]
" Right side:
let g:lightline.active.right = [ ['scrollbar'], ['line'], ['db', 'pyVirtEnvStr', 'scalaMetalsStatus'] ]
let g:lightline.inactive.right = [ ]

" Tabs:
let g:lightline.tabline = {}
let g:lightline.tabline.left  = [ [ 'tabs' ] ]
let g:lightline.tabline.right = []

let g:lightline.tab = {
      \ 'active':   [ 'tabnum', 'fnameOrFolder', 'modified' ],
      \ 'inactive': [ 'tabnum', 'fnameOrFolder', 'modified' ] }

      " \ 'active':   [ 'tabnum', 'filename', 'modified' ],
      " \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

let g:lightline.subseparator = { 'left': '', 'right': '|' }

" {noscrollbar#statusline(30,'\ ','■')}

let g:lightline.component = {}
let g:lightline.component.helloworld = 'hi there!'
let g:lightline.component.fpathBNum = '%f%n'
let g:lightline.component.projectRootFolderName = '%{ProjectRootFolderName()}'
let g:lightline.component.relativepath_fresh = '%{CurrentRelativeFilePath()}'

let g:lightline.component_function = {}
let g:lightline.component_function.cwdinfo = 'CwdInfo'
let g:lightline.component_function.ntree_rootdir = 'Ntree_rootDir'
let g:lightline.component_function.ntree_parentdir = 'Ntree_parentDir'
let g:lightline.component_function.ntree_rootdirrel = 'Ntree_rootDirRel'
let g:lightline.component_function.gitbranch = 'fugitive#head'
let g:lightline.component_function.scrollbar = "LightlineScrollbar"
let g:lightline.component_function.db = "DBUIInfos"
let g:lightline.component_function.scalaMetalsStatus = "ScalaMetalsStatus"
let g:lightline.component_function.tagbar = 'LightlineTagbar'
let g:lightline.component_function.pyVirtEnvStr = 'PyVirtEnvStr'
let g:lightline.component_function.projectRootFolderNameOfWin = 'LightlineLocalRootFolder'
let g:lightline.component_function.relativepathOfWin = 'CurrentRelativeFilePathOfWin'
let g:lightline.component_function.hithere = 'Testthere'
let g:lightline.component_function.fnameOrFolder = 'FilenameOrFolderStrOfCurrentBuffer'
let g:lightline.component_function.relativepath_fresh1 = 'CurrentFilePath1'

let g:lightline.tab_component_function = {}
let g:lightline.tab_component_function.fnameOrFolder = 'FilenameOrFolderStrOfCurrentBuffer'


func! ScalaMetalsStatus()
  return g:metals_status
endfunc


func! DBUIInfos ()
  return db_ui#statusline({
        \ 'show': ['db_name', 'schema', 'table'],
        \ 'separator' : ' - ',
        \ 'prefix': ''
        \ })
endfunc

func! LightlineLocalRootFolder()
  return ProjectRootFolderNameOfWin( winnr() )
endfunc

func! Testthere()
  return col('.')
endfunc

func! PyVirtEnvStr ()
  return join( split( PyVimVirtualEnv(), '/' )[-2:], '/' )
  " return split( PyVimVirtualEnv(), '/' )[-2]
endfunc

" This is the py-virtual-env that was active in the shell *when vim started!*
func! PyVimVirtualEnv ()
  return execute( "echo $VIRTUAL_ENV" )
endfunc

" This might read the env variable from the shell https://vim.fandom.com/wiki/Environment_variables
func! PyVimVirtualEnvExt ()
  " return expand( "$VIRTUAL_ENV" )
  return expand( "$VIRTUAL_ENV_PROMPT" )
endfunc

func! LightlineScrollbar()
  " return noscrollbar#statusline(20,' ','■')
  return noscrollbar#statusline(20,' ','▬')
  " return noscrollbar#statusline(20,' ','█',['▐'],['▌'])
endfunc
" %{noscrollbar#statusline(20,'■','◫',['◧'],['◨'])}

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
      \'x' : [ promptline#slices#python_virtualenv() ],
      \'y' : [ promptline#slices#vcs_branch() ],
      \'z' : [ promptline#slices#jobs() ],
      \'warn' : [ promptline#slices#last_exit_code() ]}

hi PromptlineB_vimMode    guifg=#EAEAEA guibg=#284954
hi PromptlineC_folderPath guifg=#42606B guibg=#0E0E0E
hi PromptlineX_python_virtualenv  guifg=#42606B guibg=#0E0E0E
hi PromptlineY_gitBranch  guifg=#EFEFEF guibg=#2F2F2F
hi PromptlineZ_bgJobs     guifg=#3C6B7C guibg=#030303
hi PromptlineWarn         guifg=#A22E44 guibg=#030303

let g:promptline_theme =  {
      \'b'    : GetHiGuiColorList( 'PromptlineB_vimMode' ),
      \'c'    : GetHiGuiColorList( 'PromptlineC_folderPath' ),
      \'x'    : GetHiGuiColorList( 'PromptlineX_python_virtualenv' ),
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



