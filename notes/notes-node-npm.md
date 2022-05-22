
## Changing node versions
using n i get:
   installed : v16.15.0 to /usr/local/bin/node
      active : v18.0.0 at /opt/homebrew/bin/node

Todo: how to keep using n?

But i can change the node version with brew:
brew link --overwrite node@16
brew info node@16
brew install node@16



## Yarn upgrade packages
yarn outdated - to see a list of new/wanted version numbers
yarn upgrade-interactive --latest - select which packages to upgrade
yarn list --pattern @pothos

# Node, npm

npm list -g
npm list -g --depth 0
sudo npm uninstall -g moment
n --help   .. let's install and select node versions


## Changed global package install path
https://github.com/sindresorhus/guides/blob/main/npm-global-without-sudo.md
https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally

Note: There is an :SessionOpen npm-config

This is where node is installed
  /usr/local/bin/
But it's (probably) set/linked from here:
  /usr/local/n/versions/node/16.13.0/bin/node

This is here npm i --global packages were installed:
  /usr/local/lib/node_modules/
Packages installed so far (before prefix change):
    corepack/
    gatsby-cli/
    neovim/
    npm/
    pyright/
    yarn/
    ytdl/

The executable is then linked to:
  /usr/local/bin

This is the default npm cache folder:
  ~/.npm
(I'll reuse this prominent location for a global package folder ..)

I have created a new install location for npm global packages:
  ~/.npm/global-packages/

I have activated it with:
npm config set prefix '~/.npm/global-packages'
npm config set prefix ''

Verify/ change this setting here
  ~/.npmrc
  ~/.npmrc#/prefix=~/.npm/global-packages

I have then added this to the $PATH like so:
  export PATH=~/.npm/global-packages/bin:$PATH
in
  ~/.zprofile
  (note that I'm now using ~/.zprofile like this to add to my $PATH)

Note: -/.zprofile only gets sourced when a new kitty login shell terminal is started. It's not sourced what a nvim terminal is started!

After installing a test package:
npm install -g jshint

I see the following stucture:
   /Users/at/.npm/global-packages
  ├──  bin
  │  └──  jshint -> ../lib/node_modules/jshint/bin/jshint
  └──  lib
     └──  node_modules

   /Users/at/.npm/global-packages/lib/node_modules
  └──  jshint
     ├──  bin
     ├──  CHANGELOG.md
     ├──  data
     ├──  dist
     ├──  LICENSE
     ├──  node_modules
     ├──  package.json
     ├──  README.md
     └──  src

There is only one global package listed now:
npm list -g
/Users/at/.npm/global-packages/lib
└── jshint@2.13.1

npm uninstall -g jshint
npm list -g

## Migrating some packages to the new install folder
npm list -g
    /usr/local/lib
    ├── corepack@0.10.0
    ├── gatsby-cli@4.4.0
    ├── neovim@4.10.0
    ├── npm@8.1.0
    ├── pyright@1.1.195
    ├── yarn@1.22.17
    └── ytdl@1.4.1

sudo npm uninstall -g ytdl
sudo npm uninstall -g gatsby-cli
sudo npm uninstall -g neovim
sudo npm uninstall -g pyright
sudo npm uninstall -g yarn

just leaving out npm and corepack
npm list -g
    /usr/local/lib
    ├── corepack@0.10.0
    └── npm@8.1.0

npm install -g ytdl
npm install -g gatsby-cli
npm install -g neovim
npm install -g yarn

not yet installed .. just to test other install methods?
npm install -g pyright

we are now at
    /Users/at/.npm/global-packages/lib
    ├── gatsby-cli@4.4.0
    ├── neovim@4.10.1
    ├── yarn@1.22.17
    └── ytdl@1.4.1

