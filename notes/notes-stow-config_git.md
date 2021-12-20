
# Git control of Config files
now using stow inside of ~/.config_git/
https://alexpearce.me/2016/02/managing-dotfiles-with-stow/

## Example
Nav into the 'dotconfig' repo folder:
  cd ~/.config_git
Create a new stow package (which can be recreated at a different machine separately). It needs to be represented by a folder on the top level of the repo root.
mkdir karabiner
Now the file I want to track (could also be a folder?) is here: ~/.config/karabiner/karabiner.json
Create the folder in-between: (cd ~/.config/karabiner)
!mkdir -p %.config/karabiner
!mv /Users/at/.config/karabiner/karabiner.json %
mkdir -p ~/.config/karabiner/.config; mv karabiner.json $_:h

## Easy repeatable process!
mkdir -p ~/.config_git/kitty/.config; mv ~/.config/kitty/ $_
mkdir -p ~/.config_git/lvim/.config; mv ~/.config/lvim/ $_
mkdir -p ~/.config_git/zsh; mv ~/.zshrc $_
mv ~/.zshrc ~/.config_git/zsh/
mv ~/.zprofile ~/.config_git/zsh
mkdir -p ~/.config_git/ideavim; mv ~/.ideavimrc $_
mkdir -p ~/.config_git/git; mv ~/.gitconfig $_


If I now run cd ~/.config  && stow karabiner  I can see the following symbolic link has been created by stow
I  ~ / .config / karabiner  lsl
drwxr-xr-x@   - at  9 Nov 15:41  assets
drwx------    - at 11 Dec 16:47  automatic_backups
.rw-------  25k at 10 Dec 08:24  karabiner.json.bak
lrwxr-xr-x   60 at 19 Dec 18:13  karabiner.json -> ../../.config_git/karabiner/.config/karabiner/karabiner.json

After moving the assests folder I get:
I  ~ / .config_git / karabiner  ls -T
.
└── .config
   └── karabiner
      ├── assets
      │  └── complex_modifications
      │     ├── 1526137298.json
      │     ├── 1526137639.json
      │     └── 1526293903.json
      └── karabiner.json


Old attemps bak:
Using vcsh at ~/.config/vcsh/repo.d/vim.git/ to git-version control config files
Alternative: :! config  - to interact with git version control of dotfiles in ~/.cfg see: /Users/at/.zshrc#/#%20using%20'config'
Run git commands, e.g.:
vcsh vim config --local status.showUntrackedFiles no
vcsh vim status




