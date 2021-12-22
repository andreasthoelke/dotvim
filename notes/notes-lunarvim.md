

# Install locations:
~/.config/lvim/
~/.local/bin

# Executable shell wrapper:
/Users/at/.local/bin/lvim

This shell script just set two env vars and execs an alias
#!/bin/sh

export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-/Users/at/.config/lvim}"
export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-/Users/at/.local/share/lunarvim}"

exec nvim -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" "$@"

## Path
/Users/at/perl5/bin
/opt/homebrew/Cellar/pyenv-virtualenv/1.1.5/shims
/Users/at/miniconda3/condabin
/Users/at/.npm/global-packages/bin
/opt/homebrew/bin
/opt/homebrew/sbin
/Users/at/.cargo/bin
/Users/at/.local/bin
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
/Library/Apple/usr/bin
/Applications/kitty.app/Contents/MacOS
/opt/homebrew/opt/fzf/bin

--
Previous $PATH:
/Users/at/perl5/bin
/opt/homebrew/Cellar/pyenv-virtualenv/1.1.5/shims
/Users/at/.pyenv/shims
/opt/homebrew/bin
/opt/homebrew/sbin
/Users/at/.cargo/bin
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
/Library/Apple/usr/bin
/Applications/kitty.app/Contents/MacOS
/opt/homebrew/opt/fzf/bin


Defined in /etc/paths:
/Users/at/.cargo/bin
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin


# Configuration:
lvim configuration files (basically the .vim folder):
~/.config/lvim/
folder with plugins:
~/.config/lvim/plugin

This is basically the 'vimrc' file:
~/.config/lvim/config.lua

But there is more of a complete vim folder here:
  ~/.local/share/lunarvim/lvim
├──  colors
│  └──  onedarker.vim
├──  CONTRIBUTING.md
├──  ftdetect
│  ├──  bicep.lua
│  ├──  fish.lua
│  ├──  fsautocomplete.lua
│  ├──  json.lua
│  ├──  julia.lua
│  ├──  nix.lua
│  ├──  plaintex.lua
│  ├──  sol.lua
│  └──  zig.lua
├──  init.lua
├──  LICENSE
├──  lua
│  ├──  lualine
│  ├──  lvim
│  └──  onedarker
├──  Makefile
├──  README.md
├──  tests
│  ├──  bootstrap_spec.lua
│  ├──  config_loader_spec.lua
│  ├──  lsp_spec.lua
│  ├──  minimal_init.lua
│  ├──  minimal_lsp.lua
│  └──  plugins_load_spec.lua
└──  utils
   ├──  bin
   ├──  ci
   ├──  desktop
   ├──  docker
   ├──  installer
   ├──  julia
   ├──  lush-template
   ├──  lv-vscode
   ├──  media
   └──  vscode_config

This is just a backup of the original config file.
~/.local/share/lunarvim/lvim/utils/installer/config.example.lua
cp ~/.local/share/lunarvim/lvim/utils/installer/config.example.lua ~/.config/lvim/config.lua

# Internal settings list
This is how you can run nvim in headless mode, running a function, quitting and then sorting the output of the nvim function in the shell
lvim --headless +'lua require("lvim.utils").generate_settings()' +qa && sort -o lv-settings.lua{,}

/Users/at/.config/lvim/lv-settings.lua


















