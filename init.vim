filetype plugin indent on

" vim-plug:
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'
" This is probl. just to have the help/docs available

" Keeps window layout when closing buffer.
" Plug 'moll/vim-bbye' " optional dependency
Plug 'aymericbeaumet/vim-symlink'

" File Selectors Browsers: ------------------------------------------
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-mark'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug '/opt/homebrew/opt/fzf'
"  This does the same as: rtp+=/opt/homebrew/opt/fzf
Plug 'junegunn/fzf.vim'

" Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }

Plug 'MattesGroeger/vim-bookmarks'
Plug 'tom-anders/telescope-vim-bookmarks.nvim'

" Lua and telescope:
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'romgrk/fzy-lua-native', { 'do': 'make' }

Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-project.nvim'

Plug 'nvim-telescope/telescope-file-browser.nvim'

" Plug 'rmagatti/auto-session'
" Plug 'rmagatti/session-lens'

Plug 'cljoly/telescope-repo.nvim'

Plug 'tpope/vim-commentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" Plug 'suy/vim-context-commentstring'

" CtrlPArgs will show the arglist
" Plug 'kshenoy/vim-ctrlp-args'

Plug 'vim-denops/denops.vim'

Plug 'lambdalisue/guise.vim'

Plug 'justinmk/vim-dirvish'
" TODO Currently trying out: set the a local current dir (lcd) for the Shdo buffer ~/.vim/plugged/vim-dirvish/autoload/dirvish.vim#/execute%20'silent%20split'
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'roginfarrer/vim-dirvish-dovish'


" Added a convenient "silent" 'z' buffer local map for the Shdo command window
" Plug 'andreasthoelke/vim-dirvish'

" Browser Integration: ---------
" Plug 'carlosrocha/vim-chrome-devtools', { 'do': 'npm install && npm run build' }
Plug 'carlosrocha/vim-chrome-devtools', { 'do': 'bash install.sh' }

" Tools: ------------------------------------------
" Show Tags. Note: There is a Haskell integration, but it does not work :Tag.. not..  Update 11-12-2018: It currently does seem to work for Haskell .. see the spock project TODO just purescript does not work
Plug 'majutsushi/tagbar'
" this showed channel errors after quitting nvim
" Plug 'ludovicchabant/vim-gutentags'
" Make the preview window more convienient to use. use in quickfix via 'p'

" Also for Tags, but from language server
Plug 'liuchengxu/vista.vim'

Plug 'simrat39/symbols-outline.nvim'

Plug 'skywind3000/vim-preview'
" Display registers on '"' or "c-r" or @
" Plug 'junegunn/vim-peekaboo'
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

" Websockets:
" " This is not neovim jobcontrol compliant
" Plug 'dhleong/vim-wildwildws', {'do': 'npm i -g wildwildws-d'}

" DBs:
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

Plug 'memgraph/cypher.vim'
Plug 'neo4j-contrib/cypher-vim-syntax'
Plug 'edgedb/edgedb-vim'

" Git: --------------------------------------------------
Plug 'tpope/vim-fugitive'
" Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'

" Lua version of gitgutter?
Plug 'lewis6991/gitsigns.nvim'

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
" Lightline compliant buffer/tabline
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
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }

Plug 'kyazdani42/nvim-web-devicons'

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
" https://github.com/norcalli/nvim-colorizer.lua\#commands
Plug 'norcalli/nvim-colorizer.lua'
Plug 'KabbAmine/vCoolor.vim'

Plug 'chrisbra/unicode.vim'
Plug 'nvim-telescope/telescope-symbols.nvim'

" Highlight
" Plug 't9md/vim-quickhl'
" fullscreen mode
Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Note taking with vim
" Plug 'fmoralesc/vim-pad', { 'branch': 'devel' }

" Plug 'kshenoy/vim-signature'

Plug 'AndrewRadev/linediff.vim'

Plug 'yegappan/mru'

Plug 'mhinz/vim-startify'

" Session:
Plug 'xolox/vim-misc'
" Plug 'xolox/vim-session'
Plug 'Shatur/neovim-session-manager'
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
" a functional duplicate that required a lot of renaming
" Plug 'andreasthoelke/quickmenu_ix'

" Mappings: -----------------
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'


Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'

" LSP Language server / client:
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
Plug 'ray-x/navigator.lua'

" Completion engine
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'

" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Language Support: -----------------------------------------------------
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'b0o/SchemaStore.nvim'

Plug 'leafOfTree/vim-svelte-plugin'

" Plug 'pigpigyyy/Yuescript-vim'
" Plug 'leafo/moonscript-vim'

" Plug 'jelera/vim-javascript-syntax'
" Plug 'elzr/vim-json'
" Plug 'kevinoid/vim-jsonc'
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'

" seemed to have no effect. not needed with treesitter?
" Plug 'yuezk/vim-js'
" Plug 'maxmellon/vim-jsx-pretty'

" Plug 'mityu/vim-applescript'
Plug 'vmchale/dhall-vim'
" Plug 'jparise/vim-graphql'
" Plug 'udalov/kotlin-vim'
" Plug 'pantharshit00/vim-prisma'

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
Plug 'tomtom/tcomment_vim'
Plug 'joereynolds/place.vim'

" Plug 'bkad/camelcasemotion'
Plug 'chaoren/vim-wordmotion'

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
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
" depends on 'godlygeek/tabular' coming first(?)
" Plug 'plasticboy/vim-markdown'

Plug 'jszakmeister/markdown2ctags'
Plug 'aklt/rel.vim'


" Plug 'purescript-contrib/purescript-vim'
" TODO this was causing a mapping for 'w' and "e" that would jump across ":" and "."
" it't not clear why I would need the plugin - it's also unmaintained
" Plug 'andreasthoelke/purescript-vim'
" issue: Purs ide throws an error, can't find the project root folder? - it's deactivated now

" ─   Repl IDE features                               ■

Plug 'sillybun/vim-repl'
Plug 'is0n/jaq-nvim'
" Plug 'jbyuki/dash.nvim'
" Plug 'metakirby5/codi.vim'
" Plug 'michaelb/sniprun', {'do': 'bash install.sh'}

" Plug 'parsonsmatt/intero-neovim'
" Plug 'andreasthoelke/intero-neovim'

" Plug 'Twinside/vim-hoogle'
Plug 'andreasthoelke/vim-hoogle'

" lookup ":h vim2hs", e.g. Tabularize haskell_types is useful
" Plug 'goolord/vim2hs'
" Plug 'andreasthoelke/vim2hs'
" Plug 'andreasthoelke/haskell-env'
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
" Plug 'neomake/neomake'
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
" Plug 'takiyu/lightline-languageclient.vim'

" does this really echo PS diagnostics?
" Plug 'Shougo/echodoc.vim'

" old:
" Plug 'coot/psc-ide-vim', { 'branch': 'vim' }


" Haskell IDE Engine HIE:
" Plug 'autozimu/LanguageClient-neovim', {
"       \ 'branch': 'next',
"       \ 'do': './install.sh'
"       \ }

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
" NOTE: Currently several .vim scripts are referring to the "ag" autogroup
augroup ag
  au!
augroup end


" This needs to be set early in the vimrc, as the mappings below will refer to it!
let mapleader="\<Space>"
let maplocalleader="\\"

" What is this?
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

if !exists('g:colors_name')
  " && g:colors_name != 'munsell-blue-molokai'
  set background=dark
  colorscheme munsell-blue-molokai
endif

nnoremap <leader>sc :colorscheme munsell-blue-molokai<cr>

luafile ~/.config/nvim/lua/utils_general.lua
luafile ~/.config/nvim/plugin/ui_virtualTx.lua
luafile ~/.config/nvim/plugin/setup-symbols-outline.lua
" luafile ~/.config/nvim/plugin/setup-lsp.lua



