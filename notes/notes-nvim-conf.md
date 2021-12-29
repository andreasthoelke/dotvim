
# NVIM config

https://neovim.io/doc/user/lsp.html





## Chris at machine config

/Users/at/.config/nvim.cam/lua/user/lsp/

git clone https://github.com/LunarVim/Neovim-from-scratch.git ~/.config/nvim

~/.config/nvim
     /Users/at/.config/nvim
    ├──  init.lua
    ├──  LICENSE
    ├──  lua
    │  └──  user
    └──  README.md

~/.local/share/nvim/
     /Users/at/.local/share/nvim
    ├──  lsp_servers
    │  ├──  python
    │  ├──  rust
    │  ├──  sumneko_lua
    │  ├──  tsserver
    │  └──  vim
    ├──  rplugin.vim
    ├──  shada
    │  └──  main.shada
    ├──  swap
    └──  telescope_history


## Rename config folders
~/.config

mv '/Users/at/.config/nvim/' %nvim.l

mv '/Users/at/.config/nvim/' '/Users/at/.config/nvim.l/'

mv '/Users/at/.config/nvim.old/' '/Users/at/.config/nvim/'

mv '/Users/at/.config/nvim/' '/Users/at/.config/nvim.old/'
mv '/Users/at/.config/nvim.l/' '/Users/at/.config/nvim/'

## Lsp
gr    - show references of var under cursor in qf list
gd    - go to definition

gl    - diagnostic message
space lf - formats with prettier

space pu - packer update all plugins
space e  - explorer
L/H      - buffers
(ins)rfc  - snipped

## Plugins

lua require('popup').create({'another one', 'another two', 'another three'}, { line = 3, col = 25, minwidth = 20 })
lua require('popup').create('hello', {})


packpath

verb command IndentBlanklineDisable
!   IndentBlanklineDisable 0                   call s:try('lua require("indent_blankline.commands").disable("<bang>" == "!")')
	Last set from ~/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim/plugin/indent_blankline.vim line 18


## Coc Node/JS extensions
~/coc/extensions/node_modules/
    ├──  node_modules
    │  ├──  coc-browser
    │  ├──  coc-fzf-preview
    │  ├──  coc-jedi
    │  ├──  coc-json
    │  ├──  coc-kotlin
    │  ├──  coc-marketplace
    │  ├──  coc-python
    │  ├──  coc-tsserver
    │  └──  coc-yaml


~/.config/nvim.cam/init.vim
/Users/at/.config/nvim.cam/init.lua

/Users/at/.local/share/nvim.cam/site/pack/*/start/*
/Users/at/.local/share/nvim.cam/site/pack/packer/start/

## Changing the mini init.vim
http://vimdoc.sourceforge.net/htmldoc/options.html

:set runtimepath=~/vimruntime,/mygroup/vim,$VIMRUNTIME

echo $VIMRUNTIME
put =$VIMRUNTIME
  /opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime

put =v:lua.vim.fn.stdpath('data')
  ~/.local/share/nvim
put =v:lua.vim.fn.stdpath('cache')
  ~/.cache/nvim
put =v:lua.vim.fn.stdpath('config')
  ~/.config/nvim
put =v:lua.vim.fn.stdpath('config_dirs')
  /etc/xdg/nvim
put =v:lua.vim.fn.stdpath('data_dirs')
  /usr/local/share/nvim
  /usr/share/nvim


some test text
let @* = getline(line('.')-1)
let @* = 'just a test'
put =@"*


### Rtp with packer installed
let @*=&rtp
put =@"*
/Users/at/.config/nvim,/etc/xdg/nvim,/Users/at/.local/share/nvim/site,/Users/at/.local/share/nvim/site/pack/*/start/*,/usr/local/share/nvim/site,/usr/share/nvim/site,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit,/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim,/Users/at/.local/share/nvim/site/pack/*/start/*/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/at/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/at/.config/nvim/after
put =split(getline(line('.')-1), ',')
/Users/at/.config/nvim
/etc/xdg/nvim
/Users/at/.local/share/nvim/site
/Users/at/.local/share/nvim/site/pack/*/start/*
/usr/local/share/nvim/site
/usr/share/nvim/site
/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime
/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit
/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim
/Users/at/.local/share/nvim/site/pack/*/start/*/after
/usr/share/nvim/site/after
/usr/local/share/nvim/site/after
/Users/at/.local/share/nvim/site/after
/etc/xdg/nvim/after
/Users/at/.config/nvim/after

### A clean nvim runtimepath
/Users/at/.config/nvim,/etc/xdg/nvim,/Users/at/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit,/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/at/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/at/.config/nvim/after
put =split(getline(line('.')-1), ',')
/Users/at/.config/nvim
/etc/xdg/nvim
/Users/at/.local/share/nvim/site
/usr/local/share/nvim/site
/usr/share/nvim/site
/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime
/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit
/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim
/usr/share/nvim/site/after
/usr/local/share/nvim/site/after
/Users/at/.local/share/nvim/site/after
/etc/xdg/nvim/after
/Users/at/.config/nvim/after

I want to remove these:
/Users/at/.local/share/nvim/site
/Users/at/.local/share/nvim/site/after

Adding these two lines to init.vim:
set runtimepath-=/Users/at/.local/share/nvim/site
set runtimepath-=/Users/at/.local/share/nvim/site/after

### A clean VIM runtimepath
/Users/at/.vim,/usr/share/vim/vimfiles,/usr/share/vim/vim82,/usr/share/vim/vimfiles/after,/Users/at/.vim/after
put =split(getline(line('.')-1), ',')
/Users/at/.vim
/usr/share/vim/vimfiles
/usr/share/vim/vim82
/usr/share/vim/vimfiles/after
/Users/at/.vim/after

### A Vim8 setup
Using this alias:
alias vim8='vim -u ~/.config/vim8/init.vim'

" Don't use Vims the standard rtp because these folders still contain my nva / "old" nvim config:
set runtimepath-=/Users/at/.vim
set runtimepath-=/Users/at/.vim/after

" Use these corresponding folders instead:
set runtimepath^=~/.config/vim8
set runtimepath+=~/.config/vim8/after

#### conclusion
Colors only work in the nvim terminal: vim8
CtrlpMR .. throws some errors
vim-Plug und comment work


#### Vim-plug
https://github.com/junegunn/vim-plug

curl -fLo ~/.config/vim8/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

### My long nvim.old runtimepath
This is based on adding to the neovim runtimepath in the init.vim
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath=&runtimepath
    source ~/.vim/vimrc.vim

put =&rtp
/Users/at/.config/coc/extensions/node_modules/coc-fzf-preview,/Users/at/.vim,/Users/at/.vim/plugged/vim-plug,/Users/at/.vim/plugged/ctrlp.vim,/Users/at/.vim/plugged/ctrlp-mark,/opt/homebrew/opt/fzf,/Users/at/.vim/plugged/fzf.vim,/Users/at/.vim/plugged/fzf-preview.vim,/Users/at/.vim/plugged/plenary.nvim,/Users/at/.vim/plugged/telescope.nvim,/Users/at/.vim/plugged/telescope-fzf-native.nvim,/Users/at/.vim/plugged/fzy-lua-native,/Users/at/.vim/plugged/telescope-github.nvim,/Users/at/.vim/plugged/vim-dirvish,/Users/at/.vim/plugged/vim-dirvish-git,/Users/at/.vim/plugged/tagbar,/Users/at/.vim/plugged/vista.vim,/Users/at/.vim/plugged/vim-preview,/Users/at/.vim/plugged/vim-peekaboo,/Users/at/.vim/plugged/vim-easyclip,/Users/at/.vim/plugged/vim-highlightedyank,/Users/at/.vim/plugged/vim-better-whitespace,/Users/at/.vim/plugged/vim-markbar,/Users/at/.vim/plugged/visual-split.vim,/Users/at/.vim/plugged/lens.vim,/Users/at/.vim/plugged/vim-ingo-library,/Users/at/.vim/plugged/vim-EnhancedJumps,/Users/at/.vim/plugged/vim-dispatch,/Users/at/.vim/plugged/vim-dispatch-neovim,/Users/at/.vim/plugged/vim-fugitive,/Users/at/.vim/plugged/vimagit,/Users/at/.vim/plugged/vim-gitgutter,/Users/at/.vim/plugged/vim-flog,/Users/at/.vim/plugged/vim-grepper,/Users/at/.vim/plugged/ag.vim,/Users/at/.vim/plugged/lightline.vim,/Users/at/.vim/plugged/vim-noscrollbar,/Users/at/.vim/plugged/promptline.vim,/Users/at/.vim/plugged/Colorizer,/Users/at/.vim/plugged/vCoolor.vim,/Users/at/.vim/plugged/goyo.vim,/Users/at/.vim/plugged/linediff.vim,/Users/at/.vim/plugged/vim-misc,/Users/at/.vim/plugged/vim-session,/Users/at/.vim/plugged/vim-projectroot,/Users/at/.vim/plugged/vitality.vim,/Users/at/.vim/plugged/vim-mundo,/Users/at/.vim/plugged/vim-auto-save,/Users/at/.vim/plugged/vim-quickui,/Users/at/.vim/plugged/quickmenu.vim,/Users/at/.vim/plugged/quickmenu_ix,/Users/at/.vim/plugged/vim-unimpaired,/Users/at/.vim/plugged/vim-repeat,/Users/at/.vim/plugged/nvim-lspconfig,/Users/at/.vim/plugged/vim-javascript-syntax,/Users/at/.vim/plugged/vim-json,/Users/at/.vim/plugged/vim-jsonc,/Users/at/.vim/plugged/typescript-vim,/Users/at/.vim/plugged/vim-jsx-typescript,/Users/at/.vim/plugged/vim-applescript,/Users/at/.vim/plugged/dhall-vim,/Users/at/.vim/plugged/vim-graphql,/Users/at/.vim/plugged/kotlin-vim,/Users/at/.vim/plugged/vim-prisma,/Users/at/.vim/plugged/vim-SyntaxRange,/Users/at/.vim/plugged/vim-tmux,/Users/at/.vim/plugged/vim-tmux-focus-events,/Users/at/.vim/plugged/csv.vim,/Users/at/.vim/plugged/vim-markdown-composer,/Users/at/.vim/plugged/markdown-preview.nvim,/Users/at/.vim/plugged/vim-easymotion,/Users/at/.vim/plugged/vim-sneak,/Users/at/.vim/plugged/vim-surround,/Users/at/.vim/plugged/targets.vim,/Users/at/.vim/plugged/camelcasemotion,/Users/at/.vim/plugged/tcomment_vim,/Users/at/.vim/plugged/place.vim,/Users/at/.vim/plugged/vim-textobj-user,/Users/at/.vim/plugged/vim-textobj-fold,/Users/at/.vim/plugged/vim-textobj-markdown,/Users/at/.vim/plugged/vim-textobj-function,/Users/at/.vim/plugged/vim-textobj-line,/Users/at/.vim/plugged/vim-easy-align,/Users/at/.vim/plugged/tabular,/Users/at/.vim/plugged/vissort.vim,/Users/at/.vim/plugged/vim-markdown,/Users/at/.vim/plugged/markdown2ctags,/Users/at/.vim/plugged/rel.vim,/Users/at/.vim/plugged/vim-hoogle,/Users/at/.vim/plugged/vim2hs,/Users/at/.vim/plugged/haskell-env,/Users/at/.vim/plugged/vim-hsimport,/Users/at/.vim/plugged/ghcid/plugins/nvim,/Users/at/.vim/plugged/vimproc.vim,/Users/at/.vim/plugged/vim-haskell-indent,/Users/at/.vim/plugged/neoformat,/Users/at/.vim/plugged/neomake,/Users/at/.vim/plugged/coc.nvim,/Users/at/.vim/plugged/webcomplete.vim,/Users/at/.config/nvim,/etc/xdg/nvim,/usr/local/share/nvim/site,/usr/share/nvim/site,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit,/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/at/.config/nvim/after,/Users/at/.vim/plugged/vim-jsx-typescript/after,/Users/at/.vim/plugged/dhall-vim/after,/Users/at/.vim/plugged/vim-graphql/after,/Users/at/.vim/plugged/vim-markdown-composer/after,/Users/at/.vim/plugged/vim-textobj-markdown/after,/Users/at/.vim/plugged/vim-textobj-function/after,/Users/at/.vim/plugged/tabular/after,/Users/at/.vim/plugged/vim-markdown/after,/Users/at/.vim/plugged/vim2hs/after,/Users/at/.vim/after
/Users/at/.config/coc/extensions/node_modules/coc-fzf-preview,/Users/at/.vim,/Users/at/.vim/plugged/vim-plug,/Users/at/.vim/plugged/ctrlp.vim,/Users/at/.vim/plugged/ctrlp-mark,/opt/homebrew/opt/fzf,/Users/at/.vim/plugged/fzf.vim,/Users/at/.vim/plugged/fzf-preview.vim,/Users/at/.vim/plugged/plenary.nvim,/Users/at/.vim/plugged/telescope.nvim,/Users/at/.vim/plugged/telescope-fzf-native.nvim,/Users/at/.vim/plugged/fzy-lua-native,/Users/at/.vim/plugged/telescope-github.nvim,/Users/at/.vim/plugged/vim-dirvish,/Users/at/.vim/plugged/vim-dirvish-git,/Users/at/.vim/plugged/tagbar,/Users/at/.vim/plugged/vista.vim,/Users/at/.vim/plugged/vim-preview,/Users/at/.vim/plugged/vim-peekaboo,/Users/at/.vim/plugged/vim-easyclip,/Users/at/.vim/plugged/vim-highlightedyank,/Users/at/.vim/plugged/vim-better-whitespace,/Users/at/.vim/plugged/vim-markbar,/Users/at/.vim/plugged/visual-split.vim,/Users/at/.vim/plugged/lens.vim,/Users/at/.vim/plugged/vim-ingo-library,/Users/at/.vim/plugged/vim-EnhancedJumps,/Users/at/.vim/plugged/vim-dispatch,/Users/at/.vim/plugged/vim-dispatch-neovim,/Users/at/.vim/plugged/vim-fugitive,/Users/at/.vim/plugged/vimagit,/Users/at/.vim/plugged/vim-gitgutter,/Users/at/.vim/plugged/vim-flog,/Users/at/.vim/plugged/vim-grepper,/Users/at/.vim/plugged/ag.vim,/Users/at/.vim/plugged/lightline.vim,/Users/at/.vim/plugged/vim-noscrollbar,/Users/at/.vim/plugged/promptline.vim,/Users/at/.vim/plugged/Colorizer,/Users/at/.vim/plugged/vCoolor.vim,/Users/at/.vim/plugged/goyo.vim,/Users/at/.vim/plugged/linediff.vim,/Users/at/.vim/plugged/vim-misc,/Users/at/.vim/plugged/vim-session,/Users/at/.vim/plugged/vim-projectroot,/Users/at/.vim/plugged/vitality.vim,/Users/at/.vim/plugged/vim-mundo,/Users/at/.vim/plugged/vim-auto-save,/Users/at/.vim/plugged/vim-quickui,/Users/at/.vim/plugged/quickmenu.vim,/Users/at/.vim/plugged/quickmenu_ix,/Users/at/.vim/plugged/vim-unimpaired,/Users/at/.vim/plugged/vim-repeat,/Users/at/.vim/plugged/nvim-lspconfig,/Users/at/.vim/plugged/vim-javascript-syntax,/Users/at/.vim/plugged/vim-json,/Users/at/.vim/plugged/vim-jsonc,/Users/at/.vim/plugged/typescript-vim,/Users/at/.vim/plugged/vim-jsx-typescript,/Users/at/.vim/plugged/vim-applescript,/Users/at/.vim/plugged/dhall-vim,/Users/at/.vim/plugged/vim-graphql,/Users/at/.vim/plugged/kotlin-vim,/Users/at/.vim/plugged/vim-prisma,/Users/at/.vim/plugged/vim-SyntaxRange,/Users/at/.vim/plugged/vim-tmux,/Users/at/.vim/plugged/vim-tmux-focus-events,/Users/at/.vim/plugged/csv.vim,/Users/at/.vim/plugged/vim-markdown-composer,/Users/at/.vim/plugged/markdown-preview.nvim,/Users/at/.vim/plugged/vim-easymotion,/Users/at/.vim/plugged/vim-sneak,/Users/at/.vim/plugged/vim-surround,/Users/at/.vim/plugged/targets.vim,/Users/at/.vim/plugged/camelcasemotion,/Users/at/.vim/plugged/tcomment_vim,/Users/at/.vim/plugged/place.vim,/Users/at/.vim/plugged/vim-textobj-user,/Users/at/.vim/plugged/vim-textobj-fold,/Users/at/.vim/plugged/vim-textobj-markdown,/Users/at/.vim/plugged/vim-textobj-function,/Users/at/.vim/plugged/vim-textobj-line,/Users/at/.vim/plugged/vim-easy-align,/Users/at/.vim/plugged/tabular,/Users/at/.vim/plugged/vissort.vim,/Users/at/.vim/plugged/vim-markdown,/Users/at/.vim/plugged/markdown2ctags,/Users/at/.vim/plugged/rel.vim,/Users/at/.vim/plugged/vim-hoogle,/Users/at/.vim/plugged/vim2hs,/Users/at/.vim/plugged/haskell-env,/Users/at/.vim/plugged/vim-hsimport,/Users/at/.vim/plugged/ghcid/plugins/nvim,/Users/at/.vim/plugged/vimproc.vim,/Users/at/.vim/plugged/vim-haskell-indent,/Users/at/.vim/plugged/neoformat,/Users/at/.vim/plugged/neomake,/Users/at/.vim/plugged/coc.nvim,/Users/at/.vim/plugged/webcomplete.vim,/Users/at/.config/nvim,/etc/xdg/nvim,/Users/at/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit,/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/at/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/at/.config/nvim/after,/Users/at/.vim/plugged/vim-jsx-typescript/after,/Users/at/.vim/plugged/dhall-vim/after,/Users/at/.vim/plugged/vim-graphql/after,/Users/at/.vim/plugged/vim-markdown-composer/after,/Users/at/.vim/plugged/vim-textobj-markdown/after,/Users/at/.vim/plugged/vim-textobj-function/after,/Users/at/.vim/plugged/tabular/after,/Users/at/.vim/plugged/vim-markdown/after,/Users/at/.vim/plugged/vim2hs/after,/Users/at/.vim/after
/Users/at/.config/coc/extensions/node_modules/coc-fzf-preview,/Users/at/.vim,/Users/at/.vim/plugged/vim-plug,/Users/at/.vim/plugged/ctrlp.vim,/Users/at/.vim/plugged/ctrlp-mark,/opt/homebrew/opt/fzf,/Users/at/.vim/plugged/fzf.vim,/Users/at/.vim/plugged/fzf-preview.vim,/Users/at/.vim/plugged/plenary.nvim,/Users/at/.vim/plugged/telescope.nvim,/Users/at/.vim/plugged/telescope-fzf-native.nvim,/Users/at/.vim/plugged/fzy-lua-native,/Users/at/.vim/plugged/telescope-github.nvim,/Users/at/.vim/plugged/vim-dirvish,/Users/at/.vim/plugged/vim-dirvish-git,/Users/at/.vim/plugged/tagbar,/Users/at/.vim/plugged/vista.vim,/Users/at/.vim/plugged/vim-preview,/Users/at/.vim/plugged/vim-peekaboo,/Users/at/.vim/plugged/vim-easyclip,/Users/at/.vim/plugged/vim-highlightedyank,/Users/at/.vim/plugged/vim-better-whitespace,/Users/at/.vim/plugged/vim-markbar,/Users/at/.vim/plugged/visual-split.vim,/Users/at/.vim/plugged/lens.vim,/Users/at/.vim/plugged/vim-ingo-library,/Users/at/.vim/plugged/vim-EnhancedJumps,/Users/at/.vim/plugged/vim-dispatch,/Users/at/.vim/plugged/vim-dispatch-neovim,/Users/at/.vim/plugged/vim-fugitive,/Users/at/.vim/plugged/vimagit,/Users/at/.vim/plugged/vim-gitgutter,/Users/at/.vim/plugged/vim-flog,/Users/at/.vim/plugged/vim-grepper,/Users/at/.vim/plugged/ag.vim,/Users/at/.vim/plugged/lightline.vim,/Users/at/.vim/plugged/vim-noscrollbar,/Users/at/.vim/plugged/promptline.vim,/Users/at/.vim/plugged/Colorizer,/Users/at/.vim/plugged/vCoolor.vim,/Users/at/.vim/plugged/goyo.vim,/Users/at/.vim/plugged/linediff.vim,/Users/at/.vim/plugged/vim-misc,/Users/at/.vim/plugged/vim-session,/Users/at/.vim/plugged/vim-projectroot,/Users/at/.vim/plugged/vitality.vim,/Users/at/.vim/plugged/vim-mundo,/Users/at/.vim/plugged/vim-auto-save,/Users/at/.vim/plugged/vim-quickui,/Users/at/.vim/plugged/quickmenu.vim,/Users/at/.vim/plugged/quickmenu_ix,/Users/at/.vim/plugged/vim-unimpaired,/Users/at/.vim/plugged/vim-repeat,/Users/at/.vim/plugged/nvim-lspconfig,/Users/at/.vim/plugged/vim-javascript-syntax,/Users/at/.vim/plugged/vim-json,/Users/at/.vim/plugged/vim-jsonc,/Users/at/.vim/plugged/typescript-vim,/Users/at/.vim/plugged/vim-jsx-typescript,/Users/at/.vim/plugged/vim-applescript,/Users/at/.vim/plugged/dhall-vim,/Users/at/.vim/plugged/vim-graphql,/Users/at/.vim/plugged/kotlin-vim,/Users/at/.vim/plugged/vim-prisma,/Users/at/.vim/plugged/vim-SyntaxRange,/Users/at/.vim/plugged/vim-tmux,/Users/at/.vim/plugged/vim-tmux-focus-events,/Users/at/.vim/plugged/csv.vim,/Users/at/.vim/plugged/vim-markdown-composer,/Users/at/.vim/plugged/markdown-preview.nvim,/Users/at/.vim/plugged/vim-easymotion,/Users/at/.vim/plugged/vim-sneak,/Users/at/.vim/plugged/vim-surround,/Users/at/.vim/plugged/targets.vim,/Users/at/.vim/plugged/camelcasemotion,/Users/at/.vim/plugged/tcomment_vim,/Users/at/.vim/plugged/place.vim,/Users/at/.vim/plugged/vim-textobj-user,/Users/at/.vim/plugged/vim-textobj-fold,/Users/at/.vim/plugged/vim-textobj-markdown,/Users/at/.vim/plugged/vim-textobj-function,/Users/at/.vim/plugged/vim-textobj-line,/Users/at/.vim/plugged/vim-easy-align,/Users/at/.vim/plugged/tabular,/Users/at/.vim/plugged/vissort.vim,/Users/at/.vim/plugged/vim-markdown,/Users/at/.vim/plugged/markdown2ctags,/Users/at/.vim/plugged/rel.vim,/Users/at/.vim/plugged/vim-hoogle,/Users/at/.vim/plugged/vim2hs,/Users/at/.vim/plugged/haskell-env,/Users/at/.vim/plugged/vim-hsimport,/Users/at/.vim/plugged/ghcid/plugins/nvim,/Users/at/.vim/plugged/vimproc.vim,/Users/at/.vim/plugged/vim-haskell-indent,/Users/at/.vim/plugged/neoformat,/Users/at/.vim/plugged/neomake,/Users/at/.vim/plugged/coc.nvim,/Users/at/.vim/plugged/webcomplete.vim,/Users/at/.config/nvim,/etc/xdg/nvim,/Users/at/.local/share/nvim/site,/Users/at/.local/share/nvim/site/pack/*/start/*,/usr/local/share/nvim/site,/usr/share/nvim/site,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit,/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim,/Users/at/.local/share/nvim/site/pack/*/start/*/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/at/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/at/.config/nvim/after,/Users/at/.vim/plugged/vim-jsx-typescript/after,/Users/at/.vim/plugged/dhall-vim/after,/Users/at/.vim/plugged/vim-graphql/after,/Users/at/.vim/plugged/vim-markdown-composer/after,/Users/at/.vim/plugged/vim-textobj-markdown/after,/Users/at/.vim/plugged/vim-textobj-function/after,/Users/at/.vim/plugged/tabular/after,/Users/at/.vim/plugged/vim-markdown/after,/Users/at/.vim/plugged/vim2hs/after,/Users/at/.vim/after
put =split(getline(line('.')-1), ',')
/Users/at/.vim
/Users/at/.vim/plugged/fzf.vim
/Users/at/.config/nvim
/etc/xdg/nvim
/Users/at/.local/share/nvim/site
/Users/at/.local/share/nvim/site/pack/*/start/*
/usr/local/share/nvim/site
/usr/share/nvim/site
/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime
/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/pack/dist/opt/matchit
/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim
/Users/at/.local/share/nvim/site/pack/*/start/*/after
/usr/share/nvim/site/after
/usr/local/share/nvim/site/after
/Users/at/.local/share/nvim/site/after
/etc/xdg/nvim/after
/Users/at/.config/nvim/after
/Users/at/.vim/plugged/vim-jsx-typescript/after
/Users/at/.vim/plugged/dhall-vim/after
/Users/at/.vim/plugged/vim-graphql/after
/Users/at/.vim/plugged/vim-markdown-composer/after
/Users/at/.vim/plugged/vim-textobj-markdown/after
/Users/at/.vim/plugged/vim-textobj-function/after
/Users/at/.vim/plugged/tabular/after
/Users/at/.vim/plugged/vim-markdown/after
/Users/at/.vim/plugged/vim2hs/after
/Users/at/.vim/after


put =&packpath
/Users/at/.vim,/Users/at/.config/nvim,/etc/xdg/nvim,/Users/at/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime,/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/at/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/at/.config/nvim/after,/Users/at/.vim/after
put =split(getline(line('.')-1), ',')
/Users/at/.vim
/Users/at/.config/nvim
/etc/xdg/nvim
/Users/at/.local/share/nvim/site
/usr/local/share/nvim/site
/usr/share/nvim/site
/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime
/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim
/usr/share/nvim/site/after
/usr/local/share/nvim/site/after
/Users/at/.local/share/nvim/site/after
/etc/xdg/nvim/after
/Users/at/.config/nvim/after
/Users/at/.vim/after

## User shared local setting folder
~/.local/share/nvim/
     /Users/at/.local/share/nvim
    ├──  lsp_servers
    │  ├──  python
    │  ├──  rust
    │  ├──  sumneko_lua
    │  ├──  tsserver
    │  └──  vim
    ├──  project_nvim
    │  └──  project_history
    ├──  rplugin.vim
    ├──  shada
    │  └──  main.shada
    ├──  site
    │  └──  pack
    ├──  swap
    ├──  telescope_history
    └──  undo
       ├──  %Users%at%.config%nvim%lua%user%keymaps.lua
       └──  %Users%at%.config_git%kitty%.config%kitty%kitty.conf

~/.local/share/nvim/site/pack/packer
     /Users/at/.local/share/nvim/site/pack
    └──  packer
       ├──  opt
       └──  start

   /Users/at/.local/share/nvim/site/pack/packer
  ├──  opt
  └──  start
     ├──  alpha-nvim
     ├──  bufferline.nvim
     ├──  cmp-buffer
     ├──  cmp-cmdline
     ├──  cmp-nvim-lsp
     ├──  cmp-path
     ├──  cmp_luasnip
     ├──  Comment.nvim
     ├──  darkplus.nvim
     ├──  FixCursorHold.nvim
     ├──  friendly-snippets
     ├──  gitsigns.nvim
     ├──  impatient.nvim
     ├──  indent-blankline.nvim
     ├──  lualine.nvim
     ├──  LuaSnip
     ├──  nlsp-settings.nvim
     ├──  null-ls.nvim
     ├──  nvim-autopairs
     ├──  nvim-cmp
     ├──  nvim-lsp-installer
     ├──  nvim-lspconfig
     ├──  nvim-tree.lua
     ├──  nvim-treesitter
     ├──  nvim-ts-context-commentstring
     ├──  nvim-web-devicons
     ├──  packer.nvim
     ├──  plenary.nvim
     ├──  popup.nvim
     ├──  project.nvim
     ├──  telescope.nvim
     ├──  toggleterm.nvim
     ├──  vim-bbye
     └──  which-key.nvim


~/.local/share/nvim/site/pack/packer/start/packer.nvim
     /Users/at/.local/share/nvim/site/pack/packer/start/packer.nvim
    ├──  doc
    │  ├──  packer.txt
    │  └──  tags
    ├──  LICENSE
    ├──  lua
    │  ├──  packer
    │  └──  packer.lua
    ├──  Makefile
    ├──  README.md
    ├──  selene.toml
    ├──  stylua.toml
    ├──  tests
    │  ├──  helpers.lua
    │  ├──  local_plugin_spec.lua
    │  ├──  minimal.vim
    │  ├──  packer_plugin_utils_spec.lua
    │  ├──  packer_use_spec.lua
    │  └──  plugin_utils_spec.lua
    └──  vim.toml


## Kickstart.nvim
https://github.com/nvim-lua/kickstart.nvim


## Nix package manager

$ nix-shell -p nix-info --run "nix-info -m"



!cp ~/Documents/kickstart.nvim/init.lua ~/.config/nvim/















