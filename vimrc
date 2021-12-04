filetype plugin indent on

" vim-plug:
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'
" This is probl. just to have the help/docs available

" File Selectors Browsers: ------------------------------------------
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-mark'
Plug '/usr/local/opt/fzf'
" Plug 'junegunn/fzf.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

" CtrlPArgs will show the arglist
" Plug 'kshenoy/vim-ctrlp-args'

Plug 'justinmk/vim-dirvish'
" TODO Currently trying out: set the a local current dir (lcd) for the Shdo buffer ~/.vim/plugged/vim-dirvish/autoload/dirvish.vim#/execute%20'silent%20split'
Plug 'kristijanhusak/vim-dirvish-git'
" Added a convenient "silent" 'z' buffer local map for the Shdo command window
" Plug 'andreasthoelke/vim-dirvish'

" Browser Integration: ---------
" Plug 'carlosrocha/vim-chrome-devtools', { 'do': 'npm install && npm run build' }

" Tools: ------------------------------------------
" Show Tags. Note: There is a Haskell integration, but it does not work :Tag.. not..  Update 11-12-2018: It currently does seem to work for Haskell .. see the spock project TODO just purescript does not work
Plug 'majutsushi/tagbar'
" this showed channel errors after quitting nvim
" Plug 'ludovicchabant/vim-gutentags'
" Make the preview window more convienient to use. use in quickfix via 'p'
Plug 'skywind3000/vim-preview'
" Display registers on '"' or "c-r" or @
Plug 'junegunn/vim-peekaboo'
" Vim clipboard features: Delete is not yank, substitute operator, yank buffer
" Plug 'svermeulen/vim-easyclip'
" " Changes: Add every yank position to the jumplist, comment out 'repeat#invalidate()' as it seems to cause jump to the top of the file
Plug 'andreasthoelke/vim-easyclip'
" TODO replace with smaller plugins
" Briefly highlight the yanked region
Plug 'machakann/vim-highlightedyank'
" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" Display marks with nearby code
Plug 'Yilin-Yang/vim-markbar'
" Changed header style
" Plug 'andreasthoelke/vim-markbar'
" Creates vertical window-splits from visual-selections
Plug 'wellle/visual-split.vim'
Plug 'camspiers/lens.vim'

" Used as tool functions for working with jumps
Plug 'inkarkat/vim-ingo-library'
Plug 'andreasthoelke/vim-EnhancedJumps'

" Just a default split command
" Plug 'vimlab/split-term.vim'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'

" Git: --------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'
" No longer supported
" Plug 'gregsexton/gitv', {'on': ['Gitv']}
Plug 'rbong/vim-flog'

" Search: -----------------------------------------------
" Currently using this via "Find"
Plug 'mhinz/vim-grepper'
" Plug 'mileszs/ack.vim'
" Search integration
Plug 'rking/ag.vim'

" Tabline Statusline: -----------------------------------------------------------
" Faster than airline and cleaner config?
Plug 'itchyny/lightline.vim'
" Lightline complient buffer/tabline
" Plug 'mengelbrecht/lightline-bufferline'

" May activate this at times to create styled promptline
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Minimal script that shows all buffernames of a tab
" Plug 'kcsongor/vim-tabbar'

" Shows Tabs as numbers on the right and the buffers of the tab on the left side of the tabline
" Clean code. Extend/ modify this?
" Plug 'pacha/vem-tabline'
" Plug 'pacha/vem-statusline'

Plug 'gcavallanti/vim-noscrollbar'
" Plug 'drzel/vim-line-no-indicator'

" Outside Of Vim:
" Creates tmux colors e.g. at ".tmuxline.conf"
" Plug 'edkolev/tmuxline.vim'
" This inserts unicode icons file-type into airline/bufferline, nerdtree and ctrlp!
" Requires a patched font ("Nerd Font" e.g. "family: MesloLGLDZ Nerd Font") which is set in "alacritty.yaml" or "kitty.conf" or ITerm2 settings.
" Plug 'ryanoasis/vim-devicons'
" Creates a (zsh) command prompt based on vim-airline style: ":PromptlineSnapshot ~/.promptline.sh airline" then in zsh: "source .promptline.sh"
" Plug 'edkolev/promptline.vim'
" True color support:
Plug 'plexigras/promptline.vim'
" Tabline Statusline: -----------------------------------------------------------



" Colorschemes: ------------------
" Plug 'tomasr/molokai'
" Plug 'NLKNguyen/papercolor-theme'
" Another colorscheme used (where?)
" Plug 'dim13/smyck.vim'
" Plug 'yosiat/oceanic-next-vim'
" Plug 'cormacrelf/vim-colors-github'

Plug 'chrisbra/Colorizer'
Plug 'KabbAmine/vCoolor.vim'



" Highlight
" Plug 't9md/vim-quickhl'
" fullscreen mode
Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Note taking with vim
" Plug 'fmoralesc/vim-pad', { 'branch': 'devel' }

" Plug 'kshenoy/vim-signature'

Plug 'AndrewRadev/linediff.vim'

" Session: --------------------------------------------------------------
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
" Restore folding
" Plug 'vim-scripts/restore_view.vim'
" TODO test this
" Plug 'Twinside/vim-haskellFold'
Plug 'dbakker/vim-projectroot'
" Plug 'xolox/vim-shell'
" iTerm2 integration
Plug 'sjl/vitality.vim'
" Show undotree with inline diffs and search
" Plug 'simnalamburt/vim-mundo'
Plug 'andreasthoelke/vim-mundo' " removed the string 'ago ' to shorten lines in display
" Autosaves buffers on specific events
Plug '907th/vim-auto-save'
" Plug 'skywind3000/quickmenu.vim'
" This fork allows to define letter shorcuts per menu-item
Plug 'skywind3000/vim-quickui'
Plug 'CharlesGueunet/quickmenu.vim'
Plug 'andreasthoelke/quickmenu_ix'

" Mappings: -----------------
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'

" Language Support: -----------------------------------------------------
Plug 'jelera/vim-javascript-syntax'
Plug 'elzr/vim-json'
Plug 'kevinoid/vim-jsonc'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'mityu/vim-applescript'
Plug 'vmchale/dhall-vim'
Plug 'jparise/vim-graphql'
Plug 'udalov/kotlin-vim'
Plug 'pantharshit00/vim-prisma'

" Flutter/Dart
" Plug 'dart-lang/dart-vim-plugin'
" Does things like go to definition
" Plug 'natebosch/vim-lsc'
" Plug 'natebosch/vim-lsc-dart'
" Plug 'thosakwe/vim-flutter'

Plug 'inkarkat/vim-SyntaxRange'


" Tmux .config features
Plug 'tmux-plugins/vim-tmux'
" Allows listening to Tmux focus events to allow autoloading files changed outside vim
Plug 'tmux-plugins/vim-tmux-focus-events'
" Vimscript debugging
" Plug 'tpope/vim-scriptease'
" This works, but not sure I need it often
Plug 'chrisbra/csv.vim'

" Nyaovim for realtime markdown writing
" Plug 'andreasthoelke/nyaovim-markdown-preview'

" Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'euclio/vim-markdown-composer'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" Code Navagation Editing: ---------------------------------------------
" Plug 'easymotion/vim-easymotion'
Plug 'andreasthoelke/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'bkad/camelcasemotion'
Plug 'tomtom/tcomment_vim'
Plug 'joereynolds/place.vim'

Plug 'kana/vim-textobj-user'
" This does fail many function types - search alternative - new using HaskellMaps() in HsMotion!
" Plug 'gilligan/vim-textobj-haskell'
" textobj#function#haskell#select
" TODO test/document this
Plug 'kana/vim-textobj-fold'
Plug 'coachshea/vim-textobj-markdown'
" Plug 'kana/vim-textobj-function'
" Plug 'blackheaven/vim-textobj-function'
" Add haskell function textobject
Plug 'andreasthoelke/vim-textobj-function'
" Provides around/inner line 'al'/'il' objects
Plug 'kana/vim-textobj-line'
" Plug 'kana/vim-operator-user'

" Aligning: ------------------------------------------------------------
Plug 'junegunn/vim-easy-align'
Plug 'godlygeek/tabular'
" Sorting lines by vis-sel column :Vissort
Plug 'navicore/vissort.vim'

" Markdown: -------------
" Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
" depends on 'godlygeek/tabular' coming first(?)
Plug 'plasticboy/vim-markdown'

Plug 'jszakmeister/markdown2ctags'
Plug 'aklt/rel.vim'


" Plug 'purescript-contrib/purescript-vim'
" TODO this was causing a mapping for 'w' and "e" that would jump across ":" and "."
" it't not clear why I would need the plugin - it's also unmaintained
" Plug 'andreasthoelke/purescript-vim'
" issue: Purs ide throws an error, can't find the project root folder? - it's deactivated now

" ─   Haskell IDE features                               ■

" Plug 'parsonsmatt/intero-neovim'
" Plug 'andreasthoelke/intero-neovim'

" Plug 'Twinside/vim-hoogle'
Plug 'andreasthoelke/vim-hoogle'

" lookup ":h vim2hs", e.g. Tabularize haskell_types is useful
" Plug 'goolord/vim2hs'
Plug 'andreasthoelke/vim2hs'
Plug 'andreasthoelke/haskell-env'
" Interact with Hoogle Haskell API
" now in vim folder
" Plug 'andreasthoelke/HsAPIExplore'
" Add an identifier to the import section of a hasell file
Plug 'dan-t/vim-hsimport'
" This does show some nice unicode symbols (see "conceal" screenshots).
" TODO customize some symbols e.g return looks not destinct enough. also apply to purescript
" TODO this has some nice unicode conceal suggestions  ~/.vim/plugged/vim-haskellConcealPlus/after/syntax/haskell.vim
" Plug 'enomsg/vim-haskellConcealPlus'
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
" Plug 'eagletmt/ghcmod-vim'
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }

Plug 'Shougo/vimproc.vim', {'do': 'make'}

" Plug 'bitc/vim-hdevtools'
" still can't get it to work 9-2018
" create a new project then run: "hdevtools check 'src/Lib.hs'" - runs
" indefinetly
" crashes vim on :HdevtoolsType command


" Problem: this did not indent Record syntax properly
" Plug 'neovimhaskell/haskell-vim'
" Unicode supporting fork
" Plug 'unclechu/haskell-vim'
" TODO not sure why is used this
" Plug 'unclechu/haskell-vim', { 'branch': 'my-fork' }
" Plug 'idris-hackers/idris-vim'
Plug 'itchyny/vim-haskell-indent'
" Plug 'alx741/vim-hindent'

" compliant with brittany
Plug 'sbdchd/neoformat'

" Syntax Checkers:
" Plug 'jaspervdj/stylish-haskell'
" Plug 'w0rp/ale'
" Just 10 lines of code. uses "to" default map
" Plug 'mpickering/hlint-refactor-vim'
Plug 'neomake/neomake'
" TODO: do I still need syntasic when having coc-vim
" Plug 'vim-syntastic/syntastic'


" coc nvim:
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"  https://blog.claude.nl/tech/howto/Setup-Neovim-as-Python-IDE-with-virtualenvs/
" Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-tabnine', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
" runtime coc-init.vim



" Plug 'FrigoEU/psc-ide-vim'
" Plug 'sriharshachilakapati/vimmer-ps'
Plug 'takiyu/lightline-languageclient.vim'

" does this really echo PS diagnostics?
Plug 'Shougo/echodoc.vim'

" old:
" Plug 'coot/psc-ide-vim', { 'branch': 'vim' }


" Haskell IDE Engine HIE:
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': './install.sh'
      \ }

" backup old: HIE and deoplete
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " Plug 'ncm2/ncm2'
  " Plug 'ncm2/float-preview.nvim'
  " Plug 'roxma/nvim-yarp'
  " Plug 'ncm2/ncm2-bufword'
  " Plug 'ncm2/ncm2-path'
" else
"   Plug 'Shougo/deoplete.nvim'
  " Plug 'roxma/nvim-yarp'
  " Plug 'roxma/vim-hug-neovim-rpc'
" endif
" Now substituted by HIE
" Plug 'eagletmt/neco-ghc'
" Plug 'ervandew/supertab'
" did not work with omnicomplete so far

Plug 'thalesmello/webcomplete.vim'

" ─^  Haskell IDE features                               ▲



call plug#end()
" ----------------------------------------------------------------------------------

" This deletes all autocmds that have the 'ag' tag/group so they aren't registered again when the vimrc is re-sourced
augroup ag
  au!
augroup end

" 


" This needs to be set early in the vimrc, as the mappings below will refer to it!
let mapleader="\<Space>"
let maplocalleader="\\"

" Enables 'setlocal' for filestypes
filetype plugin on


" Increase this for debugging
" set verbose=0
" Will write a log file with debug level 9
" vim -V9myVim.log

" let g:python_host_prog = '/usr/bin/python2'
" let g:python3_host_prog = '/opt/homebrew/bin/python3'
let g:python_host_prog = '/Users/at/.pyenv/versions/py3nvim/bin/python'
let g:python3_host_prog = '/Users/at/.pyenv/versions/py3nvim/bin/python'


" TODO experiment with textobject?
" /Users/at/.vim/plugged/vim-textobj-haskell/python/haskell-textobj.py
" let abj = '~/.vim/plugged/vim-textobj-haskell/python/haskell-textobj.py'

" Nice Python Integration Tutorial:
" https://vimways.org/2018/a-python-interface-cookbook/



" ─   Flutter / Dart                                     ■
let g:dart_format_on_save = 0



" ─^  Flutter / Dart                                     ▲



" Messages: ----------------------------------------------------------------------
" avoid |hit enter| prompts
" set shortmess+="mW"
set shortmess=aoOtT
" Cut completion messages?
set shortmess+=c

" Persistence Saving: -----------------------------------------------------------------

" Undo: -----------------------

" This was somehow set to 1000 before
set undolevels =300

function! ClearUndo()
  let choice = confirm("Clear undo information?", "&Yes\n&No", 2)
  if choice == 1
    let old_undolevels = &undolevels
    set undolevels=-1
    exe "normal a \<Bs>\<Esc>"
    let &undolevels = old_undolevels
    echo "done."
  endif
endfunction
command! ClearUndo :call ClearUndo()<CR>
" echom undofile('.')
" /Users/at/vimtmp/undo/%Users%at
" echo &undolevels 

" Mundo: ----------------------
let g:mundo_width = 50
let g:mundo_preview_height = 35
let g:mundo_right = 1
let g:mundo_auto_preview_delay = 10
let g:mundo_verbose_graph = 0
let g:mundo_mirror_graph = 0
let g:mundo_inline_undo = 1

" Z Maps Unimpaired:
" There is only one instance/window of Mundo. Whenever a Mundo window is open, Autosave should be off
nnoremap <leader>oU :MundoToggle<cr>:AutoSaveToggle<cr>

" Mundo: ----------------------


" Autosave: -------------------
" Use "AutoSaveToggle" enable/disable
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_events = ["CursorHold", "WinLeave", "VimLeavePre"]
" VimLeavePre does not save before Vim displays it's alerts
" Maybe need this?
" let g:auto_save_postsave_hook = 'TagsGenerate'  " this will run :TagsGenerate after each save
" this doesn't work. how to add more project root markers?
" let g:gutentags_add_default_project_roots = ['.gitignore', 'README.md']

" Note: Plugin will "set updatetime=200"
func! AttachAutosaveStopEvents()
  autocmd! BufEnter,WinEnter <buffer> let g:auto_save = 0 | echo "Autsave off"
  autocmd! BufHidden,WinLeave <buffer> let g:auto_save = 1 | echo "Autsave on"
endfunc
" Autosave: -------------------

" Example: Auto insert/update info in source files!
" autocmd BufWritePre,FileWritePre *.vim ks | call LastMod() | 's
" Issue: This clutters the undo-history when used with autosave
" func! LastMod()
"   if line("$") > 20
"     let l = 20
"   else
"     let l = line("$")
"   endif
"   exe "1," . l . "g/Last modified: /s/Last modified: .*/Last modified: " . strftime("%Y %b %d")
" endfun


au ag VimEnter * cd ~/Documents

" Cleanup: ----------------------------------------------------------------------------
" NOTE This might slow down exiting vim
au ag VimLeavePre * call VimLeaveCleanup()
func! VimLeaveCleanup()
  " TODO close all Markbar wins, other tool windows?
  " tabdo windo if &buftype == 'nofile' | close | endif
  Tabdofast Windofast if &buftype == 'nofile' | close | endif
endfunc

" Vim Sessions: -----------------------------------------------------------------------

" new maps!
nnoremap <leader>Sd :SessionOpen! default<cr>
nnoremap <leader>Ss :SessionSave<cr>

" Load locked session after a vim crash
command! SessionLoadLocked OpenSession!
command! SessionShowName echo xolox#session#find_current_session()

let g:session_autosave = 'no'
let g:session_autoload = 'no'
let g:session_command_aliases = 1
let g:session_menu = 0
let g:session_verbose_messages = 0

" 'sessionoptions' (default: "blank,buffers,curdir,folds,
" 					       help,tabpages,winsize"

" Session settings
set sessionoptions+=folds
set sessionoptions+=curdir
" TODO test this effect?
set sessionoptions+=tabpages
set sessionoptions+=winsize
set sessionoptions+=help
" Don't save hidden and unloaded buffers
set sessionoptions-=buffers

let g:session_persist_font = 0
let g:session_persist_colors = 0
let g:session_autosave_periodic = 0

" Falls back to writing undo file into cwd if "vimtmp/undo" is not available(?)
set undodir=~/vimtmp/undo,.
" Just activates saving the undo history
set undofile

" Default undo steps
" set undolevels=1000

" Restore view settings
set viewoptions=cursor,folds,slash,unix
" set viewdir=$HOME/.vim_view//
set viewdir=~/vimtmp/view//
" au BufWritePost,BufLeave,WinLeave ?* mkview
" au BufWritePost ?* mkview
" au BufWinEnter ?* silent loadview

" Local Plugin Patch:
" ~/.vim/plugged/vim-session/autoload/xolox/session.vim modefied code: commented this line:
  " call xolox#session#save_qflist(a:commands)
" to prevent "call setqflist([])" as this sometimes throws errors on session load.
" Troubleshooting: look at: "e ~/.vim/sessions/default.vim" delete that file or the "...lock" addition
" Issue: "badd" is commented out and only one buffer is reloaded: Solutions: unsolved.


" Shada: (Shared Persistence) ---------
command! ShadaClear :call ClearShada()
" abbrev sc ShadaClear
function! ClearShada()
    echo "Shada file deleted!"
    silent exec "!rm" . ' ~/.local/share/nvim/shada/main.shada'
endfunction

command! ShadaLoad :call LoadShada()
function! LoadShada()
    exec       ':e ~/.local/share/nvim/shada/main.shada'
endfunction

" define what is saved/restored from ~/.local/share/nvim/shada/main.shada
if has('nvim')
  " set shada=",'10,f1,<10,h
  " set shada="!,'100,<50,s10,h,f0"
endif
" only save marks of 10 files, save global marks and only 10 lines in registers
" see: *21.3*	Remembering information; ShaDa

" f0 disables global marks
" uncomment this line to ignore marks on load! (Markers, Marks persisting)
" TODO: as there is a bug that causes that marks can't be deleted, one could just
" delete the shada file to delete the marks
" Shada: ---------


" Vim Sessions: -----------------------------------------------------------------------

" Undotree Mundo: ---------------------------------------------------------------------------


" let g:undotree_WindowLayout = 4
" let g:undotree_ShortIndicators = 1
" In after/plugin/zmaps \bc unimpaired:
" nnoremap you :UndotreeToggle<cr>

" Undotree Mundo: ---------------------------------------------------------------------------


" Fonts: -------------------------------------------------------------------------

" Set Font Props in Alacritty or ITerm2. This is Used for MacVim only:
" set guifont=Menlo:h11.5
" set guifont=Menlo\ for\ Powerline:h11.5
" set guifont=MesloLGSDZ\ Nerd\ Font:h11.5
if has("gui_macvim")
  " "Mono" means: with small icons:
  " set guifont=MesloLGSDZ\ Nerd\ Font\ Mono:h11
  " set guifont=MesloLGSDZ\ Nerd\ Font:h11
  " set guifont=Hasklig:h11
  " set guifont=FuraCode\ Nerd\ Font:h11
  set guifont=Hasklug\ Nerd\ Font:h11
  set linespace=1
  set macligatures
endif



" Fonts: -------------------------------------------------------------------------

" finish

" Color:  ------------------------------------------------------------------------

if !exists('g:colors_name')
  " && g:colors_name != 'munsell-blue-molokai'
  set background=dark
  colorscheme munsell-blue-molokai
endif

" set background=light
" colorscheme PaperColor

" let g:airline_theme = 'papercolor'
" let g:lightline = { 'colorscheme': 'PaperColor' }

" colorscheme github
" let g:github_colors_soft = 0

" if has("termguicolors")
"     let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"     set termguicolors
" else
"     set t_Co=256
" endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15


let g:colorizer_use_virtual_text = 1

" Style Colors: ----------------------------{{{
" Change colors in the colorscheme: Open vimfiles/colors/molokai
" save and run colorscheme molokai
" colorscheme molokai
" colorscheme OceanicNext
" let g:rehash256 = 1}}}

" TODO: show some colors e.g. for TODO: in purescript comments
"       show syntax highlight in purescript comments (within `..code..`)
" Left margin aesthetics

" Set up a rather small column width on the left
set foldcolumn=0
" TODO switch to foldcolumn = 1
set numberwidth=2
set nonumber

" Don't show the Pipe "|" character vertical window split borders
" set fillchars+=vert:\  
" This is to allow a <Space> at the end of an expression
" Note that the \ to escape the ' ' also needs to be escaped, hence the \\
exec "set fillchars+=vert:\\ "
"hsl(348, 100%, 83%) Could also use the "VertSplit" highlight group

" Trailing Whitespace:
" vim-better-whitespace plugin
let g:better_whitespace_guicolor='#333333'
let g:better_whitespace_filetypes_blacklist=['gitcommit', 'unite', 'qf', 'help']
" Notes: highlight TrailingWhitespace guibg=#333333 match TrailingWhitespace /\s\+$/ Remove trailing whitespace: ":%s/\s\+$//e" autocmd BufEnter,WinEnter * call matchadd('Error', '\v\s+$', -1) autocmd BufEnter * call matchadd('Error', '\v\s+$', -1)

" use "StripWhitespace" and "ToggleWhitespace"  
nnoremap <leader>sw :StripWhitespace<cr>
nnoremap <leader><leader>sw :StripWhitespace<cr>
nnoremap yoW :ToggleWhitespace<cr>


noremap <leader><leader>ytw :call ToggleOption('wrap')<cr>
function! ToggleOption(option_name, ...)
  let option_scope = 'local'
  if a:0 | let option_scope = '' | endif
  exe 'let enabled = &' . a:option_name
  let option_prefix = enabled ? 'no' : ''
  exe 'set' . option_scope . ' ' . option_prefix . a:option_name
endfunction



" Tested: unprintable chars, tabs, show trailing whitespace chars
" set list
" set listchars=tab:>-,trail:_,extends:#,nbsp:_

" Try this approach:■■
" augroup myTodo
"   autocmd!
"   autocmd Syntax * syntax match myTodo /\v\_.<(TODO|FIXME).*/hs=s+1 containedin=.*Comment
" augroup END
" highlight link myTodo Todo
" https://vi.stackexchange.com/questions/15505/highlight-whole-todo-comment-line
 "▲▲

" setlocal formatoptions=jcroql
" setlocal formatoptions=cr
" set formatoptions=tcqj

" Settings in ftplugin:
" ~/.vim/ftplugin/purescript.vim#/setlocal%20comments=s1fl.{-,mb.-,ex.-},.--%20commentstring=--\
" setlocal comments=s1fl:{-,mb:-,ex:-},:-- commentstring=--\ %s
" setlocal formatoptions-=t formatoptions+=croql

" With the curson no one side of a parentheses / bracket the matching side will be highlighted
set matchpairs+=<:>
" these are not needed!
" packadd! matchit
" let match_skip = "0"

" Style Colors: ----------------------------


" General Settings: ------------------------
set cmdheight=3
set ignorecase
set fileencoding=utf-8
set encoding=utf-8
" set backspace=indent,eol,start

" Use only spaces for indentation
set expandtab
set shiftwidth=2
set softtabstop=2
" http://vim.wikia.com/wiki/Indenting_source_code

" Makes whitespace be considered part to a filepath. this enables to use c-x c-f repeadedly to drill into paths.
" Issue: but now paths have to start at the beginning of the line.
set isfname+=32

" prevents unnecessary execution when sourcing vimrc
if !exists("g:syntax_on")
  syntax enable
endif

set smartcase

" Not compatible with classic "vi" is ok
set nocompatible

" Note: this inverts what 'g' does in substitute!! avoid this
" set gdefault
set incsearch
set showmatch
" Allows to switch buffers without saving
set hidden
set nowrap
" wrapmargin=0
" vim automatically breaks the line/starts a new line after 100 chars
set textwidth=120

set noequalalways

" activate line wrapping for a window:
" command! -nargs=* Wrap set wrap linebreak nolist
" Todo: do I want linebreak and nolist?
" Update: linebreak avoids words being split across lines. so I want this, but when wrap is enabled?
" use "set wrap" and "set nowrap" instead?
" command! -nargs=* Wrap set wrap linebreak nolist
" use `gq<motion` or gqq to merely wrap a range/line

set linebreak

" Auto load files that have changed outside of vim! (only when there are no unsaved changes!). This requires
" tmux focus events "FocusGained".
set autoread

" This seems needed to reload files that have changed outside of vim (https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044)
" autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
au ag FocusGained,BufEnter * if mode() != 'c' | checktime | endif
" Issue: CursorHold would auto-reload the buffer in a split-window - but causes an error in search-window
" au ag CursorHold,FocusGained,BufEnter * if mode() != 'c' | checktime | endif
" autocmd FileChangedShellPost *
"   \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
" Issue: This is throwing an error in Command history window

set noswapfile
if has('nvim')
  set cursorline
endif


" augroup CursorLine
"   au!
"   au VimEnter,WinEnter,BufWinEnter * setlocal nocursorline
"   au WinLeave * setlocal nocursorline
" augroup END


" set autochdir
" CAREFUL! this sets the current working directory the the current file on
" every buffer change!!

" TODO do I need all of these?
set wildignorecase
set smartcase
set ignorecase
set infercase
set wildmenu
set wildmode=longest:list,full
" Well behaved flat menu
" set wildmode=longest:full

" Tab navigate the file system while in insert mode
" inoremap <Tab> <c-x><c-f>
" In command mode use <c-d> and Tab

cnoremap <C-t> <C-\>e(<SID>RemoveLastPathComponent())<CR>
function! s:RemoveLastPathComponent()
  return substitute(getcmdline(), '\%(\\ \|[\\/]\@!\f\)\+[\\/]\=$\|.$', '', '')
endfunction

set lazyredraw
set selection=inclusive
" this allows to move the cursor where there is no actual chracter
set virtualedit=all
" Console integration
" Send more characters for redraws
set ttyfast
" Enable mouse use in all modes
set mouse=a

" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
" set ttymouse=xterm2

set guioptions =
" set guioptions-=T
" set guioptions-=m
" set guioptions-=r
" set guioptions-=L
" " No graphical tabline in Macvim
" set guioptions-=e

" disable sounds
set noerrorbells
set novisualbell
" why this?
set t_vb=

" General Settings: ------------------------



" GENERAL MAPPINGS: ----------------------------------------------

" TIP: ---------------------------------------------------------------------------
" Python: install from git repo: "pip3 install -e ." in repo, "pip3 list" to confirm

" windows should not be kept at equal size
set noequalalways
set nostartofline


" COMMAND HISTORY: --------------------------------------------
" Use c-n and c-i and c-x c-f for completion.
" c-cr/return to commit in insert mode. leader se in normal mode
noremap : q:i
noremap ; :
" noremap ; q:i
noremap <leader>; :!
noremap g: q:i!
noremap <leader>: q:i!
" This requires that all maps that use ":" (commands!) need to be defined with "nnoremap"/ "vnoremap"
" TODO suspend this. wanted to use this to silence/non-<cr> the dirvish shell commands. → fnid a different map for this
" nnoremap : :silent !

" Open command history with the cursor on the last command. Avoids conflicts with bufferlocal/plugin "q"/quick maps.
" Also avoid accidential Exmode shell, can still be accessed by "gQ"
" TODO change this as Q is now used in CodeMarkup.vim
" nnoremap Q q:k
" vnoremap Q q:k

" *hist-names*
"cmd"	 or ":"	  command line history
"search" or "/"   search pattern history
"expr"	 or "="   typed expression history
"input"  or "@"	  input line history
" call histdel('cmd')

" Default command history is 20
set history =200

" Issue: Using "q" as sort of a leader key in a custom mapping will delay plugin "q" = quit maps! e.b. in Gstats.
" workaround may be to double/ "qq" or to "q<space" instead.
" Issue: needs two c-c to exit?

" Repeat last command
" To Learn: use "@:"
map <leader>. @:
" nnoremap , @:

" Editing Past Commands: (usage example)
" run "call SomeTest1( 'hithere4' )", do "q;www<c-a><cr>" to see "hithere5" echoed.
" "<cr>" in insert mode runs the command, no need for "<esc>"
" you can "/" seach for past commands in the command history!
" Enter Editing A Command: hit "<c-f>" in command mode!
" Edit Partially Typed Commands: When you are stuck writing out e.g. a path on the command line,
" type "<c-f>" then e.g. "yy" to later either "q:jP" or ':<c-r>"'
" Find in all user commands: - ":filter Intero command" or just ":command"

" nnoremap <leader>pe :call PasteLastEchoText()<cr>
func! PasteLastEchoText()
  exec "RedirMessagesBuf" histget("cmd", -1)
endfunc

nnoremap <leader>Sm :call ShowMessages()<cr>
command! EchoTextPaste :call PasteLastEchoText()
command! MessagesShow call ShowMessages()
command! MessagesClear messages clear

func! ShowMessages()
  " call FloatWin_ShowLines( RedirMessages( 'messages', '' ) )
  call ActivateScratchWindow('messages')
  normal! ggVGd
  call RedirMessages( 'messages', '' )
  set syntax=vim
  exec 'normal! G0'
endfunc

" COMMAND HISTORY: --------------------------------------------

" Tab key remap:
" This is documented in .vim/notes/notes-todos.md . Use the following lines to Test <Tab> and <S-Tab>:
" nnoremap œ :echo col('.')<cr>
" nnoremap Œ :echo line('.')<cr>
" TODO currently Tab in command line mode can only be triggered by "c-i"! Now I could set up a command map like this:
" cnoremap œ <C-\>=Tee1()<CR>
" cnoremap œ <c-i>
" nnoremap <leader>abb :call Tee1()<cr>
" func! Tee1()
"   call feedkeys("\<Tab>", 'tn')
" endfunc
" However this does not trigger the Tab completion!




" ─   Movement                                          ──

" also note  ~/.vim/plugin/utils-align-old.vim#/Join%20line%20below

" ─   General                                           ──
" Go up/down in wrapped lines mode as well
" nnoremap j gj
" nnoremap k gk

" Add start of visual mode to jumplist
nnoremap v m'v

" Want to go to last visible char most of the times and g_ is tricky to type
nnoremap $ m'g_
onoremap $ g_
vnoremap $ g_

" Add line motions to jumplist
nnoremap ^ m'^
nnoremap 0 m'0

nnoremap zz m'zz

" Note L and H are used for Sneak
noremap ,L L
noremap ,H H
vnoremap ,L L
vnoremap ,H H

" Go back to insert start (+ jumplist)
" autocmd! InsertLeave * exec "normal! m'`["
" au! ag InsertLeave * call InsertLeave()
" au ag InsertEnter * exec "normal! m'"
" au! ag InsertEnter * call InsertEnter()

" Note: adding to the jumplist on insert Enter/Leave does not seem to work?!
" Now go to insert start/end explicitly

" nnoremap g[ `[
" nnoremap g] `]
" nnoremap g[ `[
" nnoremap g] `]
" currently used for coc.nvim diagnostics

func! InsertEnter()
  " echo 'hi'
  " call feedkeys( '<c-[', 'x' )
  " normal! m'
endfunc

func! InsertLeave()
  " Put end of inserted text into jumplist, then go to the beginning of the insert
  " normal! `[h
  " normal! m'
  " normal! `[
  " Test if character under cursor is a <space>
  " if getline('.')[col('.')-1] == ' '
  "   normal! w
  " endif
  " call JumpsToQuickfix()
endfunc


" Example autocmd timeout jumplist: ■
" This saves the cursor pos to the jumplist when the cursor rested for 4 seconds. See ISSUE below.
" augroup JumplistTimeout
"   au!
"   autocmd CursorHold,CursorMoved * call JumplistTimeout_WaitStart( 5 )
" augroup END
" function! JumplistTimeout_WaitStart( secs )
"   if !exists('g:jumplisttimeout_starttime')
"     " When the cursor-wait starts
"     let g:jumplisttimeout_starttime = localtime()
"     let g:jumplisttimeout_waitloc = getpos('.')
"     " echo "----- WAIT START ------"
"   else
"     " A first cursor-motion happened after a wait was had been started
"     if (localtime() - g:jumplisttimeout_starttime) >= a:secs
"       " this wait was long enought - add the wait loc to the jumplist
"       call AddLocToJumplist( g:jumplisttimeout_waitloc )
"       " echo "saved to loclist!"
"       unlet g:jumplisttimeout_starttime
"     endif
"   endif
" endfunction
" call JumplistTimeout_WaitStart( 3 )
 " ▲

" Add a location (a list as returned by getpos() - [bufnum, lnum, col, off]) to the jumplist, 
" restoring the cursor pos. (Note: this fills in to what I think setpos("''", <loc>) is supposed to do)
func! AddLocToJumplist ( loc )
  let l:maintainedCursorPos = getpos('.')
  " Store the arg-location in the jumplist (there is seemingly no other way to do this)
  " ISSUE: this line jumps the viewport!
  call setpos('.', a:loc)
  normal! m'
  " Go back to original cursor pos
  call setpos('.', l:maintainedCursorPos)
  " This does the same but requires indivitual arg handling: call cursor(a:cursor_pos[1], a:cursor_pos[2])
endfunc
" Test: This is the loc of this >> X << character: [0,1158,30,0]. Run the next the next line, then <c-o> to jump to that char
" call AddLocToJumplist([0,1158,30,0])


" Jumplist: --------------------------------------

" Add cursor-rests to jumplist
augroup JumplistTimeout
  au!
  autocmd CursorHold * exec "normal! m'"
  " Example Debug Jumplist:
  " autocmd CursorHold * call JumpsToQuickfix()
  " autocmd CursorHold * exec "normal! m'" | call JumpsToQuickfix()
  " autocmd CursorHold * exec "normal! m'" | echo localtime()
augroup END
" TODO try this with updatime
" Issue: this interval is also used for tagbar loc update
set updatetime=300
" Note: This also defines the time you have to c-o to get to the insert end location. And after this time the jumplist
" will also get cleaned up/ suffled a bit. Typically c-i is not useful *after* this time - the jumps then basically become c-o jumps

" Skip cursor-rest jump if cursor hasn't moved (unfortunate fix) 
noremap <silent> <c-o> :call JumpBackSkipCurrentLoc()<cr>
func! JumpBackSkipCurrentLoc ()
  let l:origCursorPos = getpos('.')
  exec 'normal!' "\<C-o>"
  if getpos('.') == l:origCursorPos
    " Jump back one more, /bc the jump back was to the JumplistTimeout autocmd (see below)
    exec 'normal!' "\<C-o>"
  endif
endfunc

nnoremap <leader>cj :clearjumps<cr>

func! JumpsToQuickfix ()
  call setqflist(map( EnhancedJumps#Common#GetJumps('jumps'), function('MapJumpLineToDict') ) )
endfunc
func! MapJumpLineToDict (_, line)
  return EnhancedJumps#Common#ParseJumpLine( a:line )
endfunc

" Example Quickfix Lambda: {{{
" call setloclist(0, map(systemlist('ls -a ~/'), {_, p -> {'filename': p}}))
" call setloclist(0, map(systemlist('ls .vim/notes'), {_, p -> { 'filename': fnamemodify('~/.vim/notes/' . p, ':p:.'),   'text': 'The text: ' . p }}))
" let Abb = { idx, path -> { 'filename': fnamemodify('~/.vim/notes/' . path, ':p:.'), 'lnum': idx, 'text': 'Index: ' . idx }}
" call setloclist(0, map(systemlist('ls .vim/notes'), Abb))
" let Abb = { idx, path -> { 'filename': fnamemodify('~/.vim/notes/' . path, ':p:.'), 'lnum': idx, 'text': 'Index: ' . idx }}
" call setloclist(0, map(systemlist('ls .vim/notes'), Abb))
" Without Lambda: using "v:val" magic var
" call setloclist(0, map(systemlist('ls .vim/notes'), "{'filename': v:val}"))
" call setloclist(0, map( ['.vim/notes/release-notes1.txt', '.vim/notes/color-scheme-doc.md'], "{'filename': v:val, 'col': 2, 'lnum': 4, 'type': '', 'text': 'hi there'}"))
" call setqflist(map( ['.vim/notes/release-notes1.txt', '.vim/notes/color-scheme-doc.md'], "{'filename': v:val, 'col': 2, 'lnum': 4, 'type': '', 'text': 'hi there'}"))
" }}}

" Jumplist: --------------------------------------


" General: -----------------------------------------------------------------------------


" This is now ignored - see checkhealth
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

let &t_SI = "\<Esc>]50;CursorShape=0\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

set termguicolors
" set guicursor=n:block-iCursor
" Option: Blinking cursor: (in ITerm only)
" set guicursor=n:block-iCursor-blinkwait300-blinkon200-blinkoff150
" Cursor Speed: run this in terminal (seemed to not have an effect when last tested): "defaults write NSGlobalDomain KeyRepeat -int 0" for max speed - "2" is the setting from system preferences

" General: ---------------------------------------------------------------------------

" Goyo Zen view:

nnoremap <silent> <leader>oz :Goyo<cr>
nnoremap <silent> <leader>z :Goyo<cr>
let g:goyo_width = '80%'
let g:goyo_height = '80%'

func! s:goyo_leave()
  hi VertSplit       guifg=#000000 guibg=#080808
endfunc

autocmd! User GoyoLeave nested call <SID>goyo_leave()
" Issue: Re-applying the colorscheme causes my conceal chars to be highlighted in white - which I could not fix. On
" the other had the below line does not seem needed except for my "hi VertSplit       guifg=#000000 guibg=#080808"
" setting
" execute 'colo '. get(g:, 'colors_name', 'default')
" Note/ TODO: I had disable this line in the goyo plugin:
" ~/.vim/plugged/goyo.vim/autoload/goyo.vim#/execute%20'colo%20'.


" ALE: --------------------------------------------------------
" let g:hindent_on_save = 0
" let g:ale_linters = {'haskell': ['stack-ghc-mod', 'hlint', 'hdevtools']}
let g:ale_linters = {'haskell': ['stack-ghc-mod', 'hlint'],
                    \'javascript': ['eslint'],}
" let g:ale_linters = {'haskell': ['hlint']}
" let g:ale_linters = {'haskell': ['ghc']}
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_enabled = 0
" let g:ale_set_quickfix = 1
" Note: Ale sets the loclist, not the quickfix-list!
let g:ale_emit_conflict_warnings = 0
nnoremap <leader>aa :ALEToggle<cr>

" let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_sign_error = '•'

let g:sign_warning = '⚠'
let g:sign_error = '•'

let g:ale_fixers = {
\   'javascript': ['eslint'],
\}

" let g:ale_set_highlights = 0
" hi link ALEErrorSign    Error
" hi link ALEWarningSign  Warning
" highlight clear ALEErrorSign
" highlight clear ALEWarningSign

" otherwise the bg-color looks off
hi AleErrorSign   ctermfg=white

" let g:airline#extensions#ale#enabled = 1
" needed?

" Configure Hline/Ale warnings!
command! HlintConf :exec (':e ' . projectroot#guess() . '/.hlint.yaml')



" Mappings in the style of unimpaired-next
" nmap <silent> [W <Plug>(ale_first)
" nmap <silent> [w <Plug>(ale_previous)
" nmap <silent> ]w <Plug>(ale_next)
" nmap <silent> ]W <Plug>(ale_last)
" ALE: --------------------------------------------------------


" UNIMPAIRED: -------------------------------------------------

" Note: have to copy maps to ~/.vim/after/plugin/zmaps.vim because unimpaired overwrites

" Todo: add to the dictionary
" Issue: this does not seem to be recognized: (therefore using after/plugins script)
" let g:nnoremap = {"]a": "", "[a": ""}
" let g:nnoremap = {"]a": ':<C-U>call signature#mark#Goto("next", "spot", "global")', "[a": ""}
" "]a" is used for mark navigation

" Disable certain unimpaired maps!:
let g:nremap = {'[b': '', ']b': '', '[t': '', ']t': '', '[T': '', ']T': ''}


" UNIMPAIRED: -------------------------------------------------


" SYNTASIC: ---------------------------------------------------

" Deactivate Syntasic for haskell dev in favour of Ale
let g:syntastic_haskell_checkers = []
let g:syntastic_javascript_checkers = ['jshint']

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
" turn off initially
let g:syntastic_check_on_wq = 0

" let g:psc_ide_syntastic_mode = 1

hi SyntasticErrorSign   ctermfg=white
hi SpellBad term=reverse ctermbg=darkgreen

let g:syntastic_error_symbol = "•"
let g:syntastic_style_error_symbol = "⚠"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_style_warning_symbol = "⚠"

" Todo Temp:
" nmap <leader>ss :SyntasticToggle<cr>
" nnoremap <leader>sc :SyntasticCheck<cr>
" nnoremap <leader>st :SyntasticToggleMode<cr>
" nnoremap <leader>sr :SyntasticReset<cr>

" SYNTASIC: ---------------------------------------------------


" Neomake: ----------------------------------------------------
" Neomake does the same as Ale
" While Hlint (and stack-ghc-mod?) uses Ale for signs in the signcolumn,
" Intero uses Neomake to show error and ghc warnings
hi NeomakeErrorSign   ctermfg=white
hi NeomakeWarningSign ctermfg=white
hi NeomakeInfoSign    ctermfg=white
hi NeomakeMessageSign ctermfg=white
hi link NeomakeWarning Comment
hi link NeomakeError Comment
hi link NeomakeInfo Comment
hi link NeomakeMessage Comment
hi link NeomakeVirtualtextError Comment
hi link NeomakeVirtualtextWarning Comment
hi link NeomakeVirtualtextInfo Comment
hi link NeomakeVirtualtextMessage Comment
let g:neomake_virtualtext_prefix = ''

hi ErrorSign   ctermfg=white
hi WarningSign ctermfg=white
hi IntoSign    ctermfg=white
hi MessageSign ctermfg=white


" Autoexpand quickfix list not always wanted? controlling this elsewhere
" let g:neomake_open_list=2
" let g:neomake_list_height=10

let g:neomake_highlight_columns = 1
let g:neomake_highlight_line = 1
" Uses NVIMs nvim_buf_add_highlight feature

nnoremap <leader>cs :sign unplace *<cr>

command! SignsClear :sign unplace *
command! ClearSigns :sign unplace *
" Neomake defaults
let g:neomake_error_sign = {'text': '✖', 'texthl': 'Comment'}
let g:neomake_warning_sign = {
   \   'text': '⚠',
   \   'texthl': 'Comment',
   \ }
let g:neomake_message_sign = {
    \   'text': '➤',
    \   'texthl': 'Comment',
    \ }
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

" Issue: prevent intero+neomake to clear the LC warnings/loclist. temp neomake patch  ~/.vim/plugged/neomake/autoload/neomake/cmd.vim#/call%20setloclist.0,%20[],
" Neomake: ----------------------------------------------------


" Replacing: ---------------------------------------------
" nnoremap <leader>re "_die"0P`[
" nmap <leader>re ve"0pb
" nmap <leader>re "_die"0Pb
" nmap <leader>rf "_daf"0PB

" Replace inner word
nnoremap <leader>rw "_diw"0Pb
" nmap yrw "_diw"0Pb
nnoremap yriw "_diw"0Pb
nnoremap yrw Pl"_dwb
" Register, black hole, delete, inner word, paste from yank register, go to beginning

" Replace words
" nmap <leader>rw "_diw"0Pb
" nmap <leader>rW "_diW"0PB
" beginning of pasted text.

" Replace rest of the line
nnoremap <leader>r0 "_d$"0p`[

" Make deleting to black hole register easier?
nnoremap D "_d
" Replacing: ---------------------------------------------



" Folding Folds: ------------------------------------------------

set foldenable
set foldmethod=marker
set foldmarker=\ ■,\ ▲
set foldlevelstart=1

" Partially expand syntax and expression based folding (of markdown and gitv plugins)
" au ag Syntax git set foldlevel=1
" au ag FileType markdown set foldlevel=1
" au ag FileType vim set foldlevel=1
" au ag FileType haskell set foldlevel=1

" Go to the beginning not the end of a previous fold section
nnoremap zk zk[z

" nnoremap z<space> za
" Use this on top of "zj" and "zk"?
" nnoremap ]z :call GoToOpenFold("next")<cr>
" nnoremap [z :call GoToOpenFold("prev")<cr>

" Go to beginning/end of the current fold
nnoremap z] ]z
nnoremap z[ [z

" Example (not used) set ]z and [z go to find open folds{{{
function! GoToOpenFold(direction)
  if (a:direction == "next")
    normal zj
    let start = line('.')
    while foldclosed(start) != -1
      let start = start + 1
    endwhile
  else
    normal zk
    let start = line('.')
    while foldclosed(start) != -1
      let start = start - 1
    endwhile
  endif
  call cursor(start, 0)
endfunction "}}}

set foldtext=DefaultFoldtext()
func! DefaultFoldtext()
  let l:line = getline(v:foldstart)
  let l:subs = substitute(l:line, '{\|"\|--\|▲\|■', '', 'g')
  " return ' ●' . l:subs
  return '▶ ' . l:subs
endfunc

" set fillchars=fold:\

" Don't show the default '.' in the fold text
exec "set fillchars=fold:\\ "
" exec .. is to allow a <Space> at the end of an expression
" Note that the \ to escape the ' ' also needs to be escaped, hence the \\

" Folding: ------------------------------------------------


" Comments: --------------------------

" Issue: this seems needed to prevent the cursor from jumping to the beginning of the line on the first vertical motion after commenting
nnoremap <silent> gcc :TComment<cr>lh
" → zmaps

" Deactivate the TComment "ic" inside comment textobject - as this is mapped to "inside content" with CodeMarkup
let g:tcomment_textobject_inlinecomment = ''

" Comments: --------------------------


" CamelCaseMotion: ------------------------------------------------------
call camelcasemotion#CreateMotionMappings(',')
" map <silent> w <Plug>CamelCaseMotion_w
" map <silent> b <Plug>CamelCaseMotion_b
" map <silent> e <Plug>CamelCaseMotion_e
" sunmap w
" sunmap b
" sunmap e
" omap <silent> iw <Plug>CamelCaseMotion_iw
" xmap <silent> iw <Plug>CamelCaseMotion_iw
" omap <silent> ib <Plug>CamelCaseMotion_ib
" xmap <silent> ib <Plug>CamelCaseMotion_ib
" omap <silent> ie <Plug>CamelCaseMotion_ie
" xmap <silent> ie <Plug>CamelCaseMotion_ie
" imap <silent> <S-Left> <C-o><Plug>CamelCaseMotion_b
" imap <silent> <S-Right> <C-o><Plug>CamelCaseMotion_w
" CamelCaseMotion: ------------------------------------------------------

" ─   " Vim Place (insterting without moving the cursor)──
nmap gi <Plug>(place-insert)
nmap gI <Plug>(place-insert-multiple)
let g:place_blink = 0

" Sneak Code Navigation: ------------------------------------------------
" 1-character enhanced 'f'
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
" 1-character enhanced 't'
" nmap ,t <Plug>Sneak_t
" nmap ,T <Plug>Sneak_T
" xmap ,t <Plug>Sneak_t
" xmap ,T <Plug>Sneak_T
" omap ,t <Plug>Sneak_t
" omap ,T <Plug>Sneak_T
" Use L/H for next so ";" and "," can be used elsewhere
map L <Plug>Sneak_;
map H <Plug>Sneak_,
" let g:sneak#label = 1
" let g:sneak#absolute_dir = 1 " 'L' alway navigates forward
let g:sneak#use_ic_scs = 1 " 1 : Case sensitivity is determined by 'ignorecase' and 'smartcase'.
" let g:sneak#target_labels = "funqt/FGHLTUNRMQZ?0"
hi! link Sneak Cursor
augroup colsneak
  autocmd!
  autocmd ColorScheme * hi! link SneakScope Normal
  " autocmd ColorScheme * hi! Sneak guifg=green guibg=orange
  autocmd ColorScheme * hi! link Sneak Cursor
augroup END
" Disables default s-map
nmap <Plug>(go_away_sneak) <Plug>Sneak_s
" Sneak Code Navigation: ------------------------------------------------


" ─   Easymotion Code Navigation                         ■
" Endhanced word and line motions
map <localleader>w <Plug>(easymotion-w)
map <localleader>b <Plug>(easymotion-b)
map <localleader>j <Plug>(easymotion-j)
map <localleader>k <Plug>(easymotion-k)
" Jump to paragraphs
map <localleader><c-l> :call EasyMotion#Paragraph(0, 0)<cr>
map <localleader><c-h> :call EasyMotion#Paragraph(0, 1)<cr>
" Jump to typical spots
map <localleader>l <Plug>(easymotion-lineforward)
map <localleader>h <Plug>(easymotion-linebackward)
" Jump to specific char within a word
" nmap <localleader>f <Plug>(easymotion-overwin-f)
nmap <localleader>f <Plug>(easymotion-bd-f)
xmap <localleader>f <Plug>(easymotion-bd-f)
omap <localleader>f <Plug>(easymotion-bd-f)
" map t <Plug>(easymotion-tl)
" Search replacement
" nmap / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)

let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_do_shade = 0
let g:EasyMotion_disable_two_key_combo = 0
let g:EasyMotion_verbose = 0
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
hi EasyMotionTarget guifg=black guibg=white ctermfg=black ctermbg=white
hi EasyMotionTarget2First guifg=black guibg=white ctermfg=black ctermbg=white
hi EasyMotionTarget2Second guifg=black guibg=white ctermfg=black ctermbg=white
hi EasyMotionIncSearch guifg=black guibg=white ctermfg=black ctermbg=white
" let g:EasyMotion_re_anywhere = '\v' .
"   \ '(<.|^$)' . '|' .
"   \ '(.>|^$)' . '|' .
"   \ '(\l)\zs(\u)' . '|' .
"   \ '(_\zs.)' . '|' .
"   \ '(#\zs.)'

" ─^  Easymotion Code Navigation                         ▲



" Color: ----------------------------------

" Hex Color editor vCooler.vim
" let g:vcoolor_map = 'glc'
command! ColorPicker VCoolor
let g:vcoolor_disable_mappings = v:true

" Files Buffer:  --------------------------------------------


"  --- Project Root --------------------------------------------

" let g:rootmarkers = ['.projectroot', 'bower.json', 'package.json', 'stack.yaml', '*.cabal', 'README.md', '.git']
" Prioritise looking for git repo roots
let g:rootmarkers = ['package.json', '.git', 'spago.dhall', '.gitignore', 'stack.yaml', '*.cabal', 'README.md']

"
" open file relative to project-root
" nnoremap <expr> <leader>ep ':e '.projectroot#guess().'/'
" well, not really needed?!

" remove/delete a file relative to project-root
nnoremap <expr> <leader>df ':!rm '.projectroot#guess().'/'

command! DelFile :call delete(expand('%')) | bdelete!

" Spell check
command! Spell   :set spell
command! SpellDE :set spelllang=de
command! SpellEN :set spelllang=en

" Show suggestion:
nmap z<c-\> z=

" Open file rel to current buffer dir
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>

" TODO Test Bufenter - TabNewEntered is only for nvim
" Whenever a new tab is created, set the tab-working dir accordingly
" autocmd! TabNewEntered * call OnTabEnter(expand("<amatch>"))
autocmd! ag BufWinEnter * call OnTabEnter(expand("<amatch>"))
func! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
    " TODO " test not using auto local project roots
  " else
  "   let dirname = projectroot#guess( a:path )
  "   if isdirectory( dirname )
  "     exec 'lcd' dirname
  "   endif
  endif
endfunc

" autocmd! ag BufWinEnter * call SetWorkingDirectory(expand("<amatch>"))
func! SetWorkingDirectory(path)
  let dirname = projectroot#guess( a:path )
    " let dirname = fnamemodify(a:path, ":h")
  execute "lcd ". dirname
endfunc

" Change Working Directory: ---------------
nnoremap <expr><leader>dpr ":lcd " . projectroot#guess() . "\n"
nnoremap <expr><leader>dpR ":cd "  . projectroot#guess() . "\n"
" Also consider using ":ProjectRootCD"


" set to current file path
nnoremap <leader>dcf :cd %:p:h<cr>:pwd<cr>
nnoremap <leader>dclf :lcd %:p:h<cr>:pwd<cr>

function! <SID>AutoProjectRootCD()
  try
    if &ft != 'help'
      ProjectRootCD
    endif
  catch
    " Silently ignore invalid buffers
  endtry
endfunction



" Quickfix List: -------------------------------------------------

" Refesh/force some style on the quickfix list:
" autocmd! QuickFixCmdPost * :call QuickfixRefeshStyle()
" autocmd! QuickFixCmdPost * botright copen 8
" autocmd! QuickFixCmdPost * echom "hii"
" TODO test this. This is what Intero uses?
au ag User NeomakeJobFinished call QuickfixRefeshStyle()

function! QuickfixRefeshStyle()
  if len( filter(getqflist(), 'v:val.type == "e"') ) > 0
    exec 'copen'
    exec 'set syntax=purescript1'
    exec 'setlocal modifiable'
    " exec 'call PurescriptUnicode()'
    exec 'setlocal nomodifiable'
    wincmd p
  else
    exec 'cclose'
  endif
endfunction

" Demo Examples: this also worked:
" autocmd BufReadPost quickfix :call QuickfixRefeshStyle()
" autocmd QuickFixCmdPost * :call WinDo( winnr(), "set syntax=purescript" )
" num of 'valid' entries in quickfixlist:
" echo len(filter(getqflist(), 'v:val.valid'))

command! -nargs=0 -bar QfToArgs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" Quickfix List: -------------------------------------------------





" Show syntax highlighting groups for word under cursor
nnoremap <F4> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" ---------------------------------------------------------
" Edit MACRO:
" Record it into the register t: qt---q
" show the t register :reg t
" paste the t register :put t or "tp
" into the d register
" alternativly you can v-select the following let statement
" type y, then deselect and then
" paste it into the command line with <leader><alt>p and return
" you can now run the macro by typing @d
" ---------------------------------------------------------

" Delete-CUT element and black hole delete the space after it, to
" be able to paste the cut element
" Todo: ? does not work
" nmap de die"_dl

" Diffing: --------------------------------------------------------
nnoremap <silent> <F5><F5> :call DiffToggle()<CR>
function! DiffToggle()
    if &diff
        diffoff
    else
        diffthis
    endif
endfunction

vnoremap <leader>di :Linediff<cr>
nnoremap <leader>dr :LinediffReset<cr>

set diffopt+=vertical


" Show a Git diff of the current file
command! Diff execute 'w !git diff --no-index % -'
" - "RedirMessagesTab Diff" creates a file of only the code that has changed (nice for searching).
"   just delete the first column (the "+") to see syntax highlighting.

" Diffing: --------------------------------------------------------


" Don't show "-- INSERT --" in command line when in insert mode?
set noshowmode

" Unicode: -----------------
" https://unicode-table.com
" https://unicode-table.com/en/blocks/supplemental-mathematical-operators/


" -----------------------------------------------------------------
" -----------------------------------------------------------------



" Tagbar: --------------------------------------------------------------------------
" In ~/.vim/after/plugin/zmaps.vim
" nnoremap yot :TagbarToggle<cr>
" Use this because tagbar is the rightmost win?
" nnoremap to :TagbarOpen j<cr>
nnoremap <leader>ot :TagbarToggle<cr>
" discontinued maps
" nnoremap <leader>th :TagbarClose<cr>
" nnoremap <leader>to :TagbarOpen j<cr>
let g:tagbar_width = 23
let g:tagbar_zoomwidth = 0
let g:tagbar_indent = 1
let g:tagbar_autoshowtag = 0
let g:tagbar_autopreview = 0
let g:tagbar_silent = 1
let g:tagbar_compact = 1

" don't use the defaul <space> map
let g:tagbar_map_showproto = ''

" Tagbar: --------------------------------------------------------------------------

" Peekaboo: -------------------"
" Delay to display the peedaboo window"
" let g:peekaboo_delay = 1000
" let g:peekaboo_delay = 0
let g:peekaboo_prefix = '<leader>'

" A yank in vim writes to the system clipboard, and a system copy is available to paste in vim. but gets overwritten at the first yank.
set clipboard=unnamed

" Easyclip: ----------------------------------------
let g:EasyClipUseYankDefaults = 1
let g:EasyClipUseCutDefaults = 0
let g:EasyClipUsePasteDefaults = 1

let g:EasyClipEnableBlackHoleRedirect = 1
let g:EasyClipEnableBlackHoleRedirectForSelectOperator = 0

let g:EasyClipUsePasteToggleDefaults = 0
let g:EasyClipUseSubstituteDefaults = 0

" Paste features
let g:EasyClipAutoFormat = 1
nmap <leader>cf <plug>EasyClipToggleFormattedPaste
imap <c-v> <plug>EasyClipInsertModePaste
cmap <c-v> <plug>EasyClipCommandModePaste
" Also use

" This keeps the cursor at the position where the paste occured
" nmap p <Plug>G_EasyClipPasteAfter`[
" nmap P <Plug>G_EasyClipPasteBefore`[
nmap p <Plug>G_EasyClipPasteUnformattedAfter`[
nmap P <Plug>G_EasyClipPasteUnformattedBefore`[

" Note: not sure what these do - the cursor pos is not maintained. now added "`[" which moves the cursor to the beginning
xmap p <Plug>XEasyClipPaste`[
xmap P <Plug>XEasyClipPaste`[
" xmap S <Plug>XEasyClipPaste`[
" Subtitute motion
nmap S <Plug>G_SubstituteOverMotionMap
" nmap S <Plug>G_SubstituteToEndOfLine
nmap SS <Plug>SubstituteLine

" Cut Move:
nmap <localleader>d <Plug>MoveMotionPlug
xmap <localleader>d <Plug>MoveMotionXPlug
nmap <localleader>dd <Plug>MoveMotionLinePlug

" Yank Buffer History: Save yank history to file - allows to paste in other vim instance
let g:EasyClipShareYanks = 1
" Prefer to have a clean view in the visual menu
let g:EasyClipYankHistorySize = 6
" Use a menu to select from the yank buffer
" Note: use <leader>"<regnumber> instead
" nnoremap <leader>P :IPasteBefore<cr>

nmap ,p <plug>EasyClipPasteUnformattedAfter
nmap ,P <plug>EasyClipPasteUnformattedBefore

" Easyclip: ----------------------------------------


" Vim Highlighedhank:
let g:highlightedyank_highlight_duration = 700
" hi! HighlightedyankRegion guibg=#585858
hi! link HighlightedyankRegion Search


" Marks: ----------------------------------------------------------------

let g:markbar_marks_to_display = 'abcdefghijklnpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

" generate maps to include a markbar update in the map
func! MapMarks ()
  " Note this lacks the o, m! for open an update maps
  let l:labels = split( g:markbar_marks_to_display, '\zs')
  for label in l:labels
    exec 'nnoremap m'  . label .  ' m' . label . ':call MarkbarUpdate()<cr>'
    " exec "nmap \'" . label . " \'" . l:label
    exec 'nnoremap M'  . label .  ' :delm ' . l:label . '<cr>' . ':MarkbarUpdate<cr>' . ':call ForceGlobalRemovalMarks()<cr>'
  endfor
endfunc
call MapMarks()

command! MarkbarUpdate call MarkbarUpdate()

func! MarkbarUpdate()
  if exists('g:__active_controller') && WinIsOpen( '( Markbar )' )
    " echoe 'hi?'
    call markbar#ui#RefreshMarkbar(g:__active_controller)
  endif
endfunc

command! DelLocalMarks  exec 'delmarks a-z' | call ForceGlobalRemovalMarks()
command! DelGlobalMarks exec 'delmarks A-Z' | call ForceGlobalRemovalMarks()


" TODO Ctrlp-mark plugin useful?
" nnoremap <leader>om :CtrlPMark<cr>

" Issue: Deleted markers are currcntly recreated after session save/load a temp fix is to "ShadaClear".
" Adopted from https://github.com/kshenoy/vim-signature/blob/eaa8af20ac4d46f911a083298d7a19e27be180e0/autoload/signature/mark.vim#L324
function! ForceGlobalRemovalMarks()
  " Description: Edit viminfo/shada file to forcibly delete Global mark since vim's handling is iffy
  if has('nvim') | wshada! | else | wviminfo! | endif
endfunction

" Markbar: --------------------------------------------------------------------------"
nmap <leader>om <Plug>ToggleMarkbar
" nmap mo <Plug>OpenMarkbar | wincmd p
" nmap mo :call g:standard_controller.toggleMarkbar()<cr>:wincmd p<cr>
" nmap mm :call markbar#ui#RefreshMarkbar(g:__active_controller)<cr>
let g:markbar_enable_peekaboo = v:false
let g:markbar_width = 30
" Default mark name should just be the plain filename- no extension
func! MarkbarPlainFName(mark_data) abort
    return fnamemodify( a:mark_data['filename'], ':t:r')
    " return printf('l: %4d, c: %4d', a:mark_data['line'], a:mark_data['column'])
endfunc
" For win-local marks
let g:markbar_mark_name_format_string = ''
let g:markbar_mark_name_arguments = []
" For global/file marks
let g:markbar_file_mark_format_string = '%s'
let g:markbar_file_mark_arguments = [ function('MarkbarPlainFName') ]
" let g:markbar_file_mark_format_string = '-- %s'
" let g:markbar_file_mark_arguments = ['fname']
" No indent
let g:markbar_context_indent_block = ''
" No highlighting
let g:markbar_enable_mark_highlighting = v:false
let g:markbar_context_indent_block_NOWARN = 1

" number of lines of context to retrieve per mark
let g:markbar_num_lines_context = 2
" TODO: changing this global var updates the markbar display automatically!

let g:markbar_close_after_go_to = v:false

" markbar-local mappings
let g:markbar_jump_to_mark_mapping  = 'o'
let g:markbar_next_mark_mapping     = '<c-n>'
let g:markbar_previous_mark_mapping = '<c-p>'
let g:markbar_rename_mark_mapping   = '<c-r>'
let g:markbar_reset_mark_mapping    = '<c-b>'
let g:markbar_delete_mark_mapping   = '<c-x>'


" Markbar: --------------------------------------------------------------------------


" Rel Links: -------------
nmap gk <Plug>(Rel)
" see "h rel-links" or help:rel.txt#/should%20refer
" example: ~/.vimrc#/set
" Rel Links: -------------


" Quickfix loclist ----
" Quickfix Navigation: - "leader qq", "]q" with cursor in code, "c-n/p" and "go" with cursor in quickfix list
au ag BufWinEnter quickfix call QuickfixMaps()
func! QuickfixMaps()
  nnoremap <buffer> go :.cc<cr>:wincmd p<cr>
  nnoremap <buffer> Go :.ll<cr>:wincmd p<cr>
  nnoremap <buffer> <c-n> :cnext<cr>:wincmd p<cr>
  nnoremap <buffer> <c-p> :cprev<cr>:wincmd p<cr>
  nnoremap <buffer> <c-m> :lnext<cr>:wincmd p<cr>
  nnoremap <buffer> <c-i> :lprev<cr>:wincmd p<cr>
  nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  nnoremap <silent><buffer> P :PreviewClose<cr>
  " autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  " autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
endfunc

" nmap <leader>ll :lopen<cr>:Wrap<cr>
nnoremap <leader>ll :call Location_toggle()<cr>
" nmap <leader>qq :copen<cr>
" Todo: this get's overwrittern on quickfix refesh:
" nnoremap <leader>qq :copen<cr>:set syntax=purescript<cr>
nnoremap <leader>qq :call QuickFix_toggle()<cr>

" Toggle quickfix window
function! QuickFix_toggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction

function! s:BufferCount() abort
  return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

" Toggle Location List window
function! Location_toggle()
  " https://github.com/Valloric/ListToggle/blob/master/plugin/listtoggle.vim
  let buffer_count_before = s:BufferCount()
  " Location list can't be closed if there's cursor in it, so we need
  " to call lclose twice to move cursor to the main pane
  silent! lclose
  silent! lclose
  if s:BufferCount() == buffer_count_before
    lopen
  endif
endfunction


hi Directory guifg=#11C8D7 ctermfg=DarkMagenta


let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ';': { 'pattern': ';\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   }
\ }






