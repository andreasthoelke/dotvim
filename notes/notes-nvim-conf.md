
# NVIM config

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



