filetype plugin indent on

" vim-plug:
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'
" This is probl. just to have the help/docs available

" Keeps window layout when closing buffer.
" Plug 'moll/vim-bbye' " optional dependency
" This was causing the BufRead autocommand invalid bufferid errors!
" Plug 'aymericbeaumet/vim-symlink'

" doesn't seem to work, now using plenary.collections.py_list
" Plug 'derekthecool/luafun_neovim'
Plug 'github/copilot.vim'

" Plug 'robitx/gp.nvim'
" Plug 'pasky/claude.vim'

" https://github.com/jondkinney/aider.nvim
" modified:
" - ~/.config/nvim/plugged/aider.nvim/lua/aider.lua‖/functionˍM.AiderOpen(
" Plug 'jondkinney/aider.nvim'

" The plugged claude_code folder is a patch of aider.nvim!
" ~/.config/nvim/plugged/claude_code
Plug 'andreasthoelke/claude_code'

" too simplistic using a patch of aider for claude_code
" claude-code.nvim: https://github.com/greggh/claude-code.nvim
" Plug '/Users/at/Documents/Proj/k_mindgraph/h_mcp/claude-code.nvim/'

" ~/.config/nvim/plugged/parrot.nvim/CHANGELOG.md
" ~/.config/nvim/plugged/parrot.nvim
Plug 'frankroeder/parrot.nvim'

" https://github.com/dlants/magenta.nvim
Plug 'dlants/magenta.nvim', { 'do': 'npm install --frozen-lockfile' }
" Plug '/Users/at/Documents/Proj/k_mindgraph/h_mcp/b_mga', { 'do': 'npm install --frozen-lockfile' }
" Plug '/Users/at/Documents/Proj/k_mindgraph/h_mcp/d_magenta', { 'do': 'npm install --frozen-lockfile' }
" Plug('dlants/magenta.vim', {
"   ['do'] = 'npm install --frozen-lockfile',
" })

Plug 'olimorris/codecompanion.nvim'
" Plug 'olimorris/codecompanion.nvim', { 'branch': 'feat/move-to-function-calling' }
" move-to-function-calling

Plug 'ravitemer/codecompanion-history.nvim'
Plug 'Davidyz/VectorCode'

" https://github.com/yetone/avante.nvim
" Plug 'yetone/avante.nvim'
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make', 'source': 'true' }
" Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }

" optional deps:
Plug 'stevearc/dressing.nvim'
Plug 'HakonHarnes/img-clip.nvim'

" TODO, setup instead of copilot.vim? https://github.com/zbirenbaum/copilot.lua
Plug 'zbirenbaum/copilot.lua'

Plug 'ravitemer/mcphub.nvim'
" Plug 'ravitemer/mcphub.nvim', { 'branch': 'native-servers' }

" https://github.com/piersolenski/wtf.nvim
" Plug 'piersolenski/wtf.nvim'

" File Selectors Browsers: ------------------------------------------
" Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" PlugUpdate neo-tree.nvim
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'mrbjarksen/neo-tree-diagnostics.nvim'
Plug 'miversen33/netman.nvim'
Plug 's1n7ax/nvim-window-picker'

Plug 'kelly-lin/ranger.nvim'

" Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-mark'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug '/opt/homebrew/opt/fzf'
"  This does the same as: rtp+=/opt/homebrew/opt/fzf
Plug 'junegunn/fzf.vim'

" Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }

Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }

Plug 'ibhagwan/fzf-lua'


Plug 'MattesGroeger/vim-bookmarks'
" Plug 'tom-anders/telescope-vim-bookmarks.nvim'
" just a PR for del bookmarks fix
Plug 'mrsflv/telescope-vim-bookmarks.nvim'

Plug 'dhruvmanila/browser-bookmarks.nvim', { 'tag': '*' }
Plug 'kkharji/sqlite.lua'

" Lua and telescope:
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

" Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.6'}
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'romgrk/fzy-lua-native', { 'do': 'make' }

Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-project.nvim'

Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'axkirillov/easypick.nvim'
Plug 'crispgm/telescope-heading.nvim'
Plug 'ghassan0/telescope-glyph.nvim'
Plug 'softinio/scaladex.nvim'
Plug 'LinArcX/telescope-env.nvim'
Plug 'kelly-lin/telescope-ag'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'

Plug 'Marskey/telescope-sg'

Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }


Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
" this is for lsp loading progress like in lua_ls. 
" note this is active below!
" Plug 'j-hui/fidget.nvim'

" Plug 'rmagatti/auto-session'
" Plug 'rmagatti/session-lens'

Plug 'cljoly/telescope-repo.nvim'

Plug 'tpope/vim-commentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" Plug 'suy/vim-context-commentstring'

" CtrlPArgs will show the arglist
" Plug 'kshenoy/vim-ctrlp-args'

" Plug 'vim-denops/denops.vim'

" Plug 'ekalinin/Dockerfile.vim'
" run language servers in docker containers. i don't need
" Plug 'lspcontainers/lspcontainers.nvim'

Plug 'lambdalisue/guise.vim'

Plug 'justinmk/vim-dirvish'
" TODO Currently trying out: set the a local current dir (lcd) for the Shdo buffer ~/.vim/plugged/vim-dirvish/autoload/dirvish.vim#/execute%20'silent%20split
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'roginfarrer/vim-dirvish-dovish'


" Added a convenient "silent" 'z' buffer local map for the Shdo command window
" Plug 'andreasthoelke/vim-dirvish'

" Browser Integration: ---------
" Plug 'carlosrocha/vim-chrome-devtools', { 'do': 'npm install && npm run build' }
Plug 'carlosrocha/vim-chrome-devtools', { 'do': 'bash install.sh' }

" enhance the quickfix list
Plug 'kevinhwang91/nvim-bqf'
" Tools: ------------------------------------------
" this showed channel errors after quitting nvim
" Plug 'ludovicchabant/vim-gutentags'
" Make the preview window more convienient to use. use in quickfix via 'p'

Plug 'stevearc/aerial.nvim'
Plug 'hedyhli/outline.nvim'

" Old:
" Also for Tags, but from language server
Plug 'liuchengxu/vista.vim'
" Plug 'simrat39/symbols-outline.nvim'
" Show Tags. Note: There is a Haskell integration, but it does not work :Tag.. not..  Update 11-12-2018: It currently does seem to work for Haskell .. see the spock project TODO just purescript does not work
" Plug 'majutsushi/tagbar'

Plug 'skywind3000/vim-preview'
" Display registers on '"' or "c-r" or @
" Plug 'junegunn/vim-peekaboo'
" Vim clipboard features: Delete is not yank, substitute operator, yank buffer
" Plug 'svermeulen/vim-easyclip'
" " Changes: Add every yank position to the jumplist, comment out 'repeat#invalidate()' as it seems to cause jump to the top of the file
if !exists('g:vscode')
  Plug 'andreasthoelke/vim-easyclip'
endif

Plug 'gbprod/substitute.nvim'

" TODO replace with smaller plugins
" Briefly highlight the yanked region
" Plug 'machakann/vim-highlightedyank'
" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" Display marks with nearby code
Plug 'Yilin-Yang/vim-markbar'
" Changed header style
" Plug 'andreasthoelke/vim-markbar'
" Creates vertical window-splits from visual-selections
Plug 'wellle/visual-split.vim'

" Used as tool functions for working with jumps
Plug 'inkarkat/vim-ingo-library'
Plug 'andreasthoelke/vim-EnhancedJumps'

Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'

" Websockets:
" " This is not neovim jobcontrol compliant
" Plug 'dhleong/vim-wildwildws', {'do': 'npm i -g wildwildws-d'}

" DBs:
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

Plug 'nanotee/sqls.nvim'

" Plug 'memgraph/cypher.vim'
" Plug 'neo4j-contrib/cypher-vim-syntax'
Plug 'edgedb/edgedb-vim'
" Plug 'typedb-osi/typeql.vim'

" ─   Git related plugins                               ──

Plug 'sindrets/diffview.nvim'

Plug 'tpope/vim-fugitive'
" Plug 'jreybert/vimagit'
" Plug 'airblade/vim-gitgutter'

" Lua version of gitgutter!
Plug 'lewis6991/gitsigns.nvim'

" https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-diff.md
Plug 'echasnovski/mini.diff'
Plug 'echasnovski/mini.pick'

" No longer supported
" Plug 'gregsexton/gitv', {'on': ['Gitv']}
Plug 'rbong/vim-flog'

Plug 'akinsho/git-conflict.nvim'


" Search: -----------------------------------------------
" Currently using this via "Find"
Plug 'mhinz/vim-grepper'
" Plug 'mileszs/ack.vim'
" Search integration
" Plug 'rking/ag.vim'

" Tabline Statusline: -----------------------------------------------------------
" Plug 'itchyny/lightline.vim'

Plug 'nvim-lualine/lualine.nvim'
" enables color tab file icons
" Plug 'Slotos/lualine.nvim', { 'branch': 'tabs-highlight-formatting' }
Plug 'WhoIsSethDaniel/lualine-lsp-progress.nvim'
Plug 'j-hui/fidget.nvim'

Plug 'nanozuki/tabby.nvim', {'tag': 'v2.4.1'}
" Plug 'nanozuki/tabby.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" May activate this at times to create styled promptline
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Minimal script that shows all buffernames of a tab
" Plug 'kcsongor/vim-tabbar'

" Shows Tabs as numbers on the right and the buffers of the tab on the left side of the tabline
" Clean code. Extend/ modify this?
" Plug 'pacha/vem-tabline'
" Plug 'pacha/vem-statusline'

" A vertical scrollbar!
" Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
" Plug 'dstein64/nvim-scrollview'
" A small horizontal scrollbar
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

Plug 'rktjmp/fwatch.nvim'

" ─   Colors, style                                      ■
" Plug 'tomasr/molokai'
" Plug 'NLKNguyen/papercolor-theme'
" Another colorscheme used (where?)
" Plug 'dim13/smyck.vim'
" Plug 'yosiat/oceanic-next-vim'
" Plug 'cormacrelf/vim-colors-github'

Plug 'echasnovski/mini.colors'

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
" didn't allow window splits
Plug 'folke/zen-mode.nvim'
Plug 'pocco81/true-zen.nvim'
" Plug 'junegunn/limelight.vim'

" ─^  Colors, style                                      ▲

" Note taking with vim
" Plug 'fmoralesc/vim-pad', { 'branch': 'devel' }

" Plug 'kshenoy/vim-signature'

Plug 'AndrewRadev/linediff.vim'

Plug 'yegappan/mru'

Plug 'mhinz/vim-startify'

" Session:
Plug 'xolox/vim-misc'
" Plug 'xolox/vim-session'
" Plug 'Shatur/neovim-session-manager'
Plug 'jedrzejboczar/possession.nvim'
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
" Plug '907th/vim-auto-save'
" https://github.com/okuuva/auto-save.nvim
" Plug 'okuuva/auto-save.nvim'
" https://github.com/0x00-ketsu/autosave.nvim

" https://github.com/0x00-ketsu/autosave.nvim
" NOTE:  ~/.config/nvim/plugin/config/autosave.lua‖*InsertˍstartˍmarkˍFiX
Plug '0x00-ketsu/autosave.nvim'

" Plug 'skywind3000/quickmenu.vim'
" This fork allows to define letter shortcuts per menu-item
Plug 'CharlesGueunet/quickmenu.vim'
" a functional duplicate that required a lot of renaming
" Plug 'andreasthoelke/quickmenu_ix'
" other classic menu types
" Plug 'skywind3000/vim-quickui'

" Mappings: -----------------
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'


Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'

" ─   LSP                                                ■
Plug 'neovim/nvim-lspconfig'
" Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvimtools/none-ls.nvim'

Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
Plug 'ray-x/navigator.lua'

Plug 'folke/trouble.nvim'
" https://github.com/folke/lsp-colors.nvim
Plug 'folke/lsp-colors.nvim'

Plug 'SmiteshP/nvim-navic'
Plug 'numToStr/Comment.nvim'
Plug 'SmiteshP/nvim-navbuddy'
Plug 'stevanmilic/nvim-lspimport'

" not needed to get vim diagnostic messages?!
" Plug 'creativenull/diagnosticls-configs-nvim'

" Completion engine
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-cmdline'

" Plug 'saghen/blink.cmp'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" https://github.com/petertriho/cmp-git
Plug 'petertriho/cmp-git'

Plug 'onsails/lspkind.nvim'

Plug 'phenax/cmp-graphql'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'f3fora/cmp-spell'

Plug 'luckasRanarison/tailwind-tools.nvim'

Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'

" https://github.com/DNLHC/glance.nvim/blob/master/README.md
Plug 'dnlhc/glance.nvim'

" ─^  LSP                                                ▲

" couldn't get this to work
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz1/cmp_luasnip'

" " quite promising but a bit rough, would need time to setup up 
" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

" Language Support: -----------------------------------------------------
" deprecated
" Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
" might consider https://github.com/yioneko/vtsls 

Plug 'b0o/SchemaStore.nvim'

Plug 'scalameta/nvim-metals'

" Plug 'derekwyatt/vim-scala'


Plug 'mfussenegger/nvim-dap'

" Plug 'jelera/vim-javascript-syntax'
" Plug 'elzr/vim-json'

Plug 'kyoh86/vim-jsonl'

" https://github.com/cuducos/yaml.nvim
Plug 'cuducos/yaml.nvim'

" Plug 'kevinoid/vim-jsonc'
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'

" seemed to have no effect. not needed with treesitter?
" Plug 'yuezk/vim-js'
" Plug 'maxmellon/vim-jsx-pretty'

" Plug 'mityu/vim-applescript'
Plug 'vmchale/dhall-vim'
" I think tree-sitter is now handling this?

Plug 'inkarkat/vim-SyntaxRange'


" Tmux .config features
Plug 'tmux-plugins/vim-tmux'
" Allows listening to Tmux focus events to allow autoloading files changed outside vim
Plug 'tmux-plugins/vim-tmux-focus-events'
" Vimscript debugging
" Plug 'tpope/vim-scriptease'
" This works, but not sure I need it often
Plug 'chrisbra/csv.vim'


Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'

" Code Navagation Editing: ---------------------------------------------
" Plug 'easymotion/vim-easymotion'
Plug 'andreasthoelke/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'phaazon/hop.nvim'
" Plug 'tpope/vim-surround'
Plug 'kylechui/nvim-surround'
Plug 'wellle/targets.vim'
Plug 'tomtom/tcomment_vim'
Plug 'joereynolds/place.vim'

Plug 'windwp/nvim-autopairs'
" Plug 'windwp/nvim-ts-autotag'
Plug 'tronikelis/ts-autotag.nvim'

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

" ─   Markdown                                          ──

" note:
" https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/autolinked-references-and-urls

" https://github.com/jghauser/follow-md-links.nvim
" Plug 'jghauser/follow-md-links.nvim'

" https://github.com/jakewvincent/mkdnflow.nvim
" Plug 'jakewvincent/mkdnflow.nvim'

" Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'euclio/vim-markdown-composer'
" https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file#commands
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'ellisonleao/glow.nvim'

Plug 'toppair/peek.nvim', { 'do': 'deno task --quiet build:fast' }

Plug 'davidmh/mdx.nvim'

" Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
" depends on 'godlygeek/tabular' coming first(?)
" Plug 'plasticboy/vim-markdown'

Plug 'jszakmeister/markdown2ctags'
" NOTE: I modified the souce to stop http link highlighting: ~/.config/nvim/plugged/rel.vim/plugin/rel.vim#/au%20BufWinEnter%20*
Plug 'aklt/rel.vim'

Plug 'jceb/vim-orgmode'

" Plug 'purescript-contrib/purescript-vim'
" TODO this was causing a mapping for 'w' and "e" that would jump across ":" and "."
" it't not clear why I would need the plugin - it's also unmaintained
" Plug 'andreasthoelke/purescript-vim'
" issue: Purs ide throws an error, can't find the project root folder? - it's deactivated now

Plug 'rescript-lang/vim-rescript'
" Plug 'nkrkv/nvim-treesitter-rescript'

" ─   Repl IDE features                               ■

" Plug 'sillybun/vim-repl'
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
" Plug 'dan-t/vim-hsimport'
" This does show some nice unicode symbols (see "conceal" screenshots).
" TODO customize some symbols e.g return looks not destinct enough. also apply to purescript
" TODO this has some nice unicode conceal suggestions  ~/.vim/plugged/vim-haskellConcealPlus/after/syntax/haskell.vim
" Plug 'enomsg/vim-haskellConcealPlus'
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
" Plug 'eagletmt/ghcmod-vim'
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }

Plug 'Shougo/vimproc.vim', {'do': 'make'}

" Plug 'itchyny/vim-haskell-indent'
" Plug 'alx741/vim-hindent'

" compliant with brittany
Plug 'sbdchd/neoformat'

Plug 'stevearc/conform.nvim'


" coc nvim:
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

"  https://blog.claude.nl/tech/howto/Setup-Neovim-as-Python-IDE-with-virtualenvs/
" Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-tabnine', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
" runtime coc-init.vim



Plug 'thalesmello/webcomplete.vim'




call plug#end()
" ----------------------------------------------------------------------------------

lua << EOF

-- could use this area.
-- ~/.config/nvim/plugin/setup-general.lua‖:515

EOF



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
  " The startup color theme - light during time
  " colorscheme munsell-blue-molokai_light_1
  " colorscheme munsell-blue-molokai_20250214_180417
endif

" nnoremap <leader>sc :colorscheme munsell-blue-molokai<cr>

" lua require('plugin.config.telescope')
" lua require("config.lazy")

" this file is odd, it is required as a module, but also has _G functions, which require an initial sourcing here?
luafile ~/.config/nvim/lua/utils/general.lua
" luafile ~/.config/nvim/plugin/config/telescope.lua
" luafile ~/.config/nvim/plugin/ui_virtualTx.lua
" luafile ~/.config/nvim/lua/utils_lsp.lua
" luafile ~/.config/nvim/plugin/setup-symbols-outline.lua
" luafile ~/.config/nvim/plugin/setup-lsp.lua



if exists('g:vscode')
  " echo "in vscode!"

  " doesn't work
  " let g:easyclip_yank_stack_file = '/Users/at/.config/nvim/easyclip_yank_stack.txt'
else
    " ordinary Neovim
endif

