

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

func! Tab_complete_label( currentCompl, fullLine, pos )
  return v:lua.Tab_complete_label( a:currentCompl, a:fullLine, a:pos )
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


" augroup lightline_statusline
"   autocmd!
"   autocmd FileType * call LightlineFiletype()
" augroup END

" func! LightlineFiletype()
"   " let ext = expand('%:e')
"   " if &filetype == 'neo-tree'
"   if &filetype == 'TelescopePrompt'
"     call StatusLine_default()
"     " call StatusLine_neotree()
"   else
"   endif
" endfunc

" lightline#highlight

func! StatusLine_default()
  let g:lightline.active.left   = [ [], ['projectRootFolderName'], ['relativepath_fresh'] ]
  let g:lightline.active.right = [ ['scrollbar'], ['line'], ['db', 'pyVirtEnvStr', 'scalaMetalsStatus'] ]
  call lightline#init()
  call lightline#update()
endfunc

func! StatusLine_neotree()
  " seems needed bc/ telescope prompts don't seem to fire the neo-tree leave event / enter events properly
  if &filetype != 'neo-tree' | echoe "status event shouldn't happen" | return | endif
  " The 6 highlight slots are fixed to 6 functions (outputting path segments) below.
  " this is needed bc/ in the troot_out_cwd__cwd_in_troot case the cwd is inside/to the right of the tree-root path.
  " This case will not use the normal1 and cwd1 highlight segments. Only normal3 and cwd2 follow-up to the troot highlight.
  let g:lightline.active.left   = [ ['Rpi_normal1'], ['Rpi_cwd1'], ['Rpi_normal2'], ['Rpi_troot'], ['Rpi_normal3'], ['Rpi_cwd2'] ]
  let g:lightline.active.right =  [ ['Rpi_captureDummy'] ]
  call lightline#init()
  call lightline#update()
endfunc


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

  let troot_minus_cwd_L = split( troot_minus_cwd, '/')
  let cwd_minus_troot_L = split( cwd_minus_troot, '/')
  let cwd_L             = split( BasePath_shorten( a:cwd ), '/')
  let tree_root_L       = split( BasePath_shorten( a:tree_root ), '/')

  if     troot_changed && !cwd_changed
    return [ 'troot_in_cwd', cwd_L[:-2], ['‖'], troot_minus_cwd_L[:-2], [troot_minus_cwd_L[-1]] ] " H Documents Proj _repos ‖ src main |scala|
  elseif troot_changed && cwd_changed
    return [ 'troot_is_cwd', cwd_L[:-2], ['‖'] ] " H Documents Proj _repos |‖|
  elseif !troot_changed && cwd_changed
    return [ 'troot_out_cwd__cwd_in_troot', tree_root_L[:-2], [tree_root_L[-1]], cwd_minus_troot_L[:-2], ['‖'] ] " P _repos ‖ 
  elseif !troot_changed && !cwd_changed
    return [ 'troot_out_cwd__cwd_out_troot', tree_root_L[:-2], [tree_root_L[-1]] ] " P _repos 11_spoti_gql_muse src |test|
  else
    echoe "unmatched case in RootPathInfo_RenderCaseAndSegments"
  endif
endfunc

" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala" )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3" )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj" )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/11_spoti_gql_muse/src/test" )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/ab/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/ab" )

" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3/src/main/scala" )[1:]->map( { _, v -> v->join(" ") } )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3" )[1:]->map( { _, v -> v->join(" ") } )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj" )[1:]->map( { _, v -> v->join(" ") } )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/_repos/11_spoti_gql_muse/src/test" )[1:]->map( { _, v -> v->join(" ") } )
" RootPathInfo_RenderCaseAndSegments( "/Users/at/Documents/Proj/ab/_repos/2_realworld-tapir-zio3", "/Users/at/Documents/Proj/ab" )[1:]->map( { _, v -> v->join(" ") } )

func! Rpi_filePath()
  return &filetype == 'neo-tree' ? v:lua.Ntree_currentNode().rootpath : expand('%')
endfunc

func! Rpi_data()
  let [cid; infoL] = RootPathInfo_RenderCaseAndSegments( getcwd(winnr()), Rpi_filePath() )
  return [ cid, infoL->map( { _, v -> v->join(" ") } ) ]
endfunc

" [ h_normal, h_cwd, h_normal, h_troot, h_normal, h_cwd ]

func! Rpi_normal1()
  let [cid, segs] = Rpi_data()
  return (cid == 'troot_in_cwd') || (cid == 'troot_is_cwd') ? segs[0] : ""
endfunc

func! Rpi_cwd1()
  let [cid, segs] = Rpi_data()
  return (cid == 'troot_in_cwd') || (cid == 'troot_is_cwd') ? segs[1] : ""
endfunc

func! Rpi_normal2()
  let [cid, segs] = Rpi_data()
  return    (cid == 'troot_in_cwd')                ? segs[2] :
     \ (cid == 'troot_out_cwd__cwd_in_troot') || (cid == 'troot_out_cwd__cwd_out_troot')  ? segs[0] : ""
endfunc

" The tree-root folder is not highlighted in the troot_is_cwd case.
" In the troot_in_cwd the tree_root folder name is at pos 3 of the segs array.
" In the other cases it is at pos 1.
func! Rpi_troot()
  let [cid, segs] = Rpi_data()
  return    (cid == 'troot_in_cwd')                ? segs[3] :
     \ (cid == 'troot_out_cwd__cwd_in_troot') || (cid == 'troot_out_cwd__cwd_out_troot') ? segs[1] : ""
endfunc
" echo Rpi_troot()

" In the troot_out_cwd__cwd_in_troot case the cwd is inside/to the right of the tree-root path.
" This case will not use the normal1 and cwd1 highlight segments. Only normal3 and cwd2 follow-up to the troot highlight.
func! Rpi_normal3()
  let [cid, segs] = Rpi_data()
  return (cid == 'troot_out_cwd__cwd_in_troot') ? segs[2] : ""
endfunc

func! Rpi_cwd2()
  let [cid, segs] = Rpi_data()
  return (cid == 'troot_out_cwd__cwd_in_troot') ? segs[3] : ""
endfunc


let g:RootPathInfo_string = ""
let g:RootPathInfo_trootStr = ""

func! Rpi_captureString()
  let outl = [ Rpi_normal1(), " " . Rpi_cwd1() . " ", Rpi_normal2(), " " . Rpi_troot() . " ", Rpi_normal3(), " " . Rpi_cwd2() . " " ]
  " let outl = [ Rpi_normal1(), Rpi_cwd1(), Rpi_normal2(), Rpi_troot(), Rpi_normal3(), Rpi_cwd2() ]
  return outl->join(" ")
endfunc
" echo Rpi_captureString()

func! Rpi_captureDummy()
  let newStr = Rpi_captureString()
  " call writefile([newStr], "event.log", "a")
  " The reason for this hack is: I wanted to use a cached version of the rendered string while neo-tree is not active,
  " not to waste performance. However I couldn't find a "before leave" event that would update this string. So I'm using
  " this captureDummy function. However it apparently captures "nil"? values on leave.
  " The below if-clause skips the "nil" updates.
  if newStr[0] != "0"
    let filtStr = newStr->matchstr( '\v\zs\i.*' )
    let filtStr = filtStr->substitute( "   ", " ", "g" )
    let g:RootPathInfo_string = filtStr
    let g:RootPathInfo_trootStr = Rpi_troot()->len() ? Rpi_troot() : '‖'
    " lua vim.opt.winbar = vim.g.RootPathInfo_string
    let &l:winbar = filtStr
  endif
  return ""
endfunc




func! RootPathInfo1()
  let infoL = RootPathInfo_RenderCaseAndSegments( getcwd(), v:lua.Ntree_currentNode().rootpath)
  let infoLf = infoL[1:]->map( { _, v -> v->join(" ") } )
  return infoLf[1]
endfunc

func! RootPathInfo2()
  let infoL = RootPathInfo_RenderCaseAndSegments( getcwd(), v:lua.Ntree_currentNode().rootpath)
  let infoLf = infoL[1:]->map( { _, v -> v->join(" ") } )
  return infoLf[2]
endfunc

func! RootPathInfo3()
  let infoL = RootPathInfo_RenderCaseAndSegments( getcwd(), v:lua.Ntree_currentNode().rootpath)
  let infoLf = infoL[1:]->map( { _, v -> v->join(" ") } )
  return infoLf[3]
endfunc



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
  let pathList = split( v:lua.Ntree_currentNode().rootpath, '/' )
  return pathList[ len( pathList ) - 1 ]
endfunc

func! Ntree_rootDirRel()
  let path = v:lua.Ntree_currentNode().rootpath 
  let cwd = getcwd()
  let cwdList = split( cwd, '/' )
  let relPath = substitute( path, cwd, '', '' )
  let relPath = substitute( relPath[1:], 'Users/at/', '~/', 'g' )
  " return len( relPath ) ? relPath : cwdList[ len(cwdList) - 1 ]
  return len( relPath ) ? relPath : "|"
endfunc



func! Ntree_parentDir()
  let pathList = split( v:lua.Ntree_currentNode().rootpath, '/' )
  return "|" . pathList[ len( pathList ) - 2 ]
endfunc

func! Ntree_linepath()
  return v:lua.Ntree_currentNode().linepath
endfunc

func! CwdInfo()
  return 'ein'
  let cwd = getcwd()
  let cwdList = split( cwd, '/' )
  return "ˍ" . cwdList[ len( cwdList ) - 1 ] . "ˍ"
endfunc


" ─   Lightline setup                                    ■

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
      \ 'active':   [ 'tabnum', 'InfoStr_ActiveBufferInTab' ],
      \ 'inactive': [ 'tabnum', 'InfoStr_ActiveBufferInTab' ] }

      " \ 'active':   [ 'tabnum', 'filename', 'modified' ],
      " \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

let g:lightline.subseparator = { 'left': '', 'right': '|' }

" {noscrollbar#statusline(30,'\ ','■')}

let g:lightline.component = {}
let g:lightline.component.eins = 'hi there!'
let g:lightline.component.helloworld = 'hi there!'
let g:lightline.component.fpathBNum = '%f%n'
let g:lightline.component.projectRootFolderName = '%{ProjectRootFolderName()}'
let g:lightline.component.relativepath_fresh = '%{CurrentRelativeFilePath()}'

let g:lightline.component_function = {}
let g:lightline.component_function.cwdinfo = 'CwdInfo'

let g:lightline.component_function.Rpi_normal1 = 'Rpi_normal1'
let g:lightline.component_function.Rpi_cwd1    = 'Rpi_cwd1'
let g:lightline.component_function.Rpi_normal2 = 'Rpi_normal2'
let g:lightline.component_function.Rpi_troot   = 'Rpi_troot'
let g:lightline.component_function.Rpi_normal3 = 'Rpi_normal3'
let g:lightline.component_function.Rpi_cwd2    = 'Rpi_cwd2'
let g:lightline.component_function.Rpi_captureDummy = 'Rpi_captureDummy'

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
let g:lightline.component_function.relativepathOfWin = 'LightlineRelativeFilePathOfWin'
let g:lightline.component_function.hithere = 'Testthere'
let g:lightline.component_function.InfoStr_ActiveBufferInTab = 'InfoStr_ActiveBufferInTab'
let g:lightline.component_function.relativepath_fresh1 = 'CurrentFilePath1'

let g:lightline.tab_component_function = {}
let g:lightline.tab_component_function.InfoStr_ActiveBufferInTab = 'InfoStr_ActiveBufferInTab'


" ─^  Lightline setup                                    ▲


func! ScalaMetalsStatus()
  return g:metals_status
endfunc

func! GetCwdType_info()
  let en = GetCwdType()
  return   en == 'local' ? '˼' : 
    \ en == 'tab'   ? '˺' : ''
endfunc

func! GetCwdType()
  let local = haslocaldir( 0, 0 )
  let tab = haslocaldir( -1, 0 )
  return local ? 'local' : tab ? 'tab' : 'global'
endfunc

" GetCwdType()


func! DBUIInfos ()
  return db_ui#statusline({
        \ 'show': ['db_name', 'schema', 'table'],
        \ 'separator' : ' - ',
        \ 'prefix': ''
        \ })
endfunc

func! LightlineLocalRootFolder()
  let str = ProjectRootFolderNameOfWin() . GetCwdType_info()
  if     &filetype =~# '\v(help|gitcommit)'
    return str
  elseif &filetype == 'neo-tree'
    return str
  elseif !&buflisted
    return ''
  else
    return str
  endif
endfunc

func! LightlineRelativeFilePathOfWin()
  return &filetype !~# '\v(neo-tree)' ? CurrentRelativeFilePathOfWin() : g:RootPathInfo_string
endfunc


func! InfoStr_ActiveBufferInTab (tab_count)
  let buflist = tabpagebuflist(a:tab_count)
  let winnr = tabpagewinnr(a:tab_count)
  let bufNum = buflist[winnr-1]
  let bufFt = getbufvar(bufNum, '&filetype')
  if bufFt == 'neo-tree'
    return g:RootPathInfo_trootStr
  else
    let path = expand('#' . bufNum)
    return GetFilenameOrFolderStrFromPath( path )
  endif
endfunc
" InfoStr_ActiveBufferInTab( tabpagenr() )
" From ~/.vim/plugged/lightline.vim/autoload/lightline/tab.vim#/function.%20lightline#tab#filename.n.%20abort
" getbufvar(6, '&filetype')


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
  " return noscrollbar#statusline(20,' ','▬')
  return noscrollbar#statusline(20,' ','▆')
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


function! T_RenameTab(...)
  if a:0 == 1
    let t:tabname = a:1
  else
    unlet t:tabname
  end
  redrawtabline
endfunction

" T_RenameTab( "eins" )
" T_RenameTab()


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



