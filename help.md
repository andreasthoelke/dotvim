# help

More help/comments:
~/.vim/notes/notes-navigation.md#/#%20Navigate%20Containers
~/.vim/notes/releases.md#/##%20Release%20notes

## Links
notes/links


# Homebrew

brew list
brew list | grep python
brew info python
brew ls
brew ls -t -l
brew ls ffmpeg
brew ls gh
brew ls --casks --version
brew ls --formulae --versions

brew install --HEAD luajit
brew install --HEAD neovim
to update: brew reinstall neovim

Install location: /opt/homebrew/bin
notes/brew-list-dump-2021-12-23.txt

# Node, NPM

/Users/at/.vim/notes/notes-node-npm.md

## Typescript project setup, lsp, tslint, prettier
~/Documents/Server-Dev/a_tssetup/notes-typescript-node.md#/##%20TS-Node


# JS React Gatsby NextJS

notes/notes-js-react-gatsby.md

# Git control of Config files using stow

## Controlled apps

lst --level=4 /Users/at/.config_git/
 /Users/at/.config_git
├──  alacritty
│ └──  .config
│ └──  alacritty
│ └──  alacritty.yml
├──  git
│ └──  .gitconfig
├──  ideavim
│ └──  .ideavimrc
├──  karabiner
│ └──  .config
│ └──  karabiner
│ ├──  assets
│ └──  karabiner.json
├──  kitty
│ └──  .config
│ └──  kitty
│ └──  kitty.conf
├──  lvim
│ └──  .config
│ └──  lvim
│ ├──  plugin
│ ├──  config.lua
│ └──  lv-settings.lua
├──  zsh
│ ├──  .zprofile
│ ├──  .zshenv
│ └──  .zshrc
└──  README.md

/Users/at/.vim/notes/notes-stow-config_git.md

# do-next

# notes/do-next

notes/chrome-cli
- run js file. see this approach: ~/.config/nvim/notes/chrome-cli#/##%20TODO%20Run
- package:
    const observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
    and callback info an include/require file, so I can quickly integrate this in a React page.

note the job sequence summary here:
https://alpha2phi.medium.com/faster-neovim-plugin-development-with-plenary-nvim-e5ba8dcd12a3

note Code Runner approach
https://alpha2phi.medium.com/neovim-code-runner-cd9dcf871f20

## Caching asyc repl
~/.config/nvim/notes/inline-values-repl.md#/#%20Caching%20asyc

filter Ms, all with sed,
just python with 'command' will be synchronous
but i could just open a temp terminal! in a float


note: search these notes:
notes/notes-todos.md


## Snippets
Todo:
For console.log and JSON.stringify
using luasnip?
~/.config/nvim/plugin/setup-lsp.lua#/local%20luasnip%20=

--Remap for dealing with word wrap
lua vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
lua vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end]]

Debugger: https://github.com/mfussenegger/nvim-dap
https://github.com/Pocco81/TrueZen.nvim
Search and replace: https://github.com/nvim-pack/nvim-spectre
Watch file changes: https://github.com/rktjmp/fwatch.nvim

HsMotions should be reworked using treesitter. ~/.vim/plugin/HsMotions.vim#/TODO%20make%20a

## the current cursor in alacritty

- the current cursor has these shifting colors depending on the foreground color the cursor is on.
- and when I leave insert mode and jump somewhere it blinks once!!
- and it becomes hollow when the window is not active.

* still, a slightly thicker insert mode cursor

vs code command line options - jump to cursor lock in vscode and back to nvim
manage /Library/Application Support/ in source control?


### Unix pipe examples

echo 'one two three' | xargs mkdir
find . -name '_.txt' | xargs rm
fzf | xargs ls -l
nvim -l `fzf` main
cd ** or cd ../**
kill -9 .. then <c-i> .. e.g. 'textEdit'<cr> .. to end the app
find _ -type f | fzf -m > selected

c-t - use ctrl-t in terminal at an argument position in say 'cp myfile.txt <c-t>..' to fill in a path.

$_ - the last argument given to the previous command. As in `mkdir pytest1 && $_`

### 'fzf.vim'

See maps here: ~/.vim/help.md#/##%20Files%20open

Previous notes:
Has simple commands that open in a split. see
help fzf-vim
Commands: Files, BLines, Lines(?), GFiles?, BCommits, Maps, Helptags ~/.vim/plugged/fzf.vim/doc/fzf-vim.txt#/Command%20|%20List
GFiles? - all changed files

### Multi-files lines search (grep & co)

Step1: Full text search using Rg (ripgrep) and Ag (silversearcher), Step 2: Preview & filter found lines with fzf.
FzfAg marks
FzfRg marks
vim /v\^gs.\*web **
Ag divish /Users/at/.vim/**
Ag divish %**
FzfRg dirvish **
FzfAg dirvish **
FzfAg marks **
FzfAg marks
FzfAg marks %**
GGrep marks **
!mv 'vimrc' vimrc.vim
FzfAg dirvish
FzfFiletypes
FzfFiles
FzfFiles!
FzfHelptags bang

### Seach syntax

sbtrkt fuzzy-match
'wild exact-match (quoted) - use the --exact flag to invert the meaning of '!
^music prefix-exact-match
.mp3$ suffix-exact-match
!fire inverse-exact-match
!^music inverse-prefix-exact-match
!.mp3$ inverse-suffix-exact-match
^core go$ | rb$ | py$ - start with core and end with either go, rb, or py.

### 'fzf preview'

Uses the floating-window. See
help fzf-preview-vim
CocCommand fzf-preview.ProjectFiles
CocCommand fzf-preview.GitStatus
CocCommand fzf-preview.GitActions
CocCommand fzf-preview.VistaCtags
CocCommand fzf-preview.CocReferences
CocCommand fzf-preview.Marks

GREP??

## telescope.nvim

leader te    - to see options. but not all (e.g. session is missing)

Telescope <c-i>
Telescope gh gist
~/.vim/plugin/utils-fileselect-telescope.vim#/Find%20files%20using
https://github.com/nvim-telescope/telescope.nvim\#default-mappings
https://github.com/nvim-telescope/telescope.nvim/blob/master/README.md\#default-mappings

# Lunavim
notes/notes-lunarvim.md

# Lua

reload a lua file with <leader>sr

## Lua tricks
~/.config/nvim/notes/notes-lua-asyc-loop.md#/###%20Plenary%20reload

## Basics
~/.config/nvim/notes/notes-lua-asyc-loop.md#/##%20Global%20variables

do i need to specifically source lua files?
~/.config/nvim/init.vim#/luafile%20~/.config/nvim/lua/utils_general.lua

https://teukka.tech/luanvim.html
https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
https://neovim.io/doc/user/lua.html
https://github.com/nanotee/nvim-lua-guide/blob/master/README.md

## Async vim.loop
~/.config/nvim/notes/notes-lua-asyc-loop.md

### Preview a file in terminal/shell with cat -> bat

Note you can scroll and search like in vim.

## Markdown

help vim-markdown
help vim-markdown-folding
plugin config: ~/.vim/plugin/tools-markdown.vim#/let%20g.vim_markdown_follow_anchor%20=

## Pandoc markdown docx conversion

~/.vim/notes/docx-markdown#/we%20would%20need

### Markdown live preview

glm - start markdown preview
gsm - stop markdown preview
~/.vim/plugin/tools-markdown.vim#/Markdown-Preview

mdbook https://rust-lang.github.io/mdBook/format/mdbook.html#including-portions-of-a-file

## Video

see notes/video.md

## MySQL, H2

~/Documents/DBs/Projects1/mysqltest1/steps.md

## Android Studio / Kotlin

Path to Android Studio config files:
~ Library / ApplicationSupport / Google / AndroidStudioPreview2020.3 git add colors/Munsell-blue\ Kotlin.icls -f

# LSP Language server / client

## Disable/enable diagnostic displays
leader ltv/s/u   - lsp toggle virtual-text/signs/underline
ToggleDiagOff    - turn off diagnostic messages
config: ~/.config/nvim/plugin/setup-lsp.vim#/nmap%20<leader>ltu%20<Plug>.toggle-lsp-diag-underline.

## Diagnostics filter/disable rules /types of warnings
config: ~/.config/nvim/plugin/setup-lsp.lua#/local%20handler_JSON_filterDiagnCodes%20=

## Workspace diagnostics with telescope and trouble
Trouble document_diagnostics
Trouble lsp_definitions
Trouble workspace_diagnostics
Telescope lsp_workspace_symbols query=port
Telescope buffers (then <c-t> to open results in trouble

## LspInfo
very useful help functions: ~/.config/nvim/lua/utils_lsp.lua#/function%20M.type..

help lspconfig-server-configurations
plugin/setup-lsp.lua

https://neovim.io/doc/user/lsp.html
some language servers are installed here: (?)
echo v:lua.vim.fn.stdpath("data")
/Users/at/.local/share/nvim/lsp_servers/
Install location for language servers: ~/.local/share/nvim/lsp_servers/
Other local app settings: ~/.local/share/
installer used on lunarvim:
https://github.com/williamboman/nvim-lsp-installer

## treesitter

TSInstallInfo
TSInstall <language>
help nvim-treesitter-commands
TSModuleInfo

TSHighlightCapturesUnderCursor   - show the highlight groups under the cursor
nvim-treesitter-playground.hl-info
lua require('nvim-treesitter-playground.hl-info').show_hl_captures()
https://www.youtube.com/watch?v=dPQfsASHNkg

# Html / CSS

~/Documents/UI-Dev/React1/css1/css1.md#/#%20CSS


# Purescript
~/Documents/PS/setup-tests/a_pss/purescript-setup-2022.md#/##%20Lsp%20errors

notes/notes-purescript.md
notes/purs-setup.md


# Python

" Example of how to run a Python function: ~/.vim/plugin/utils-stubs.vim#/Example%20of%20how

### other python tools

Black
i could at some point try a normal formatter: pip install black
isort manages/sorts import lines
flake8 style enforcement
mypy static typing

## pyenv virtualenv pip, conda and poetry
/Users/at/.config/nvim/notes/notes-python.md

### Poetry

Now using poetry from local installs and auto virturl envs:
~/.vim/notes/notes-python.md#/##%20Basic%20usage

### Conda

alternative to poetry.
~/.vim/notes/notes-python.md#/###%20conda

before running `pip install` <app>:
check what environment you are in: `pyenv virtualenvs`
(note the activated virtual env might autochange in a dir than contains a `.python-version` file)
run `pyenv activate <env>` e.g. my nvim python environment "py3nvim"
you can also `pyenv deactivate` any env - so it's not globally active.
then pip install should install in the currently active environment. (also notes `which pip` is now managed as a
pyenv shim

General maintainance notes: ~/.vim/notes/notes-python.md#/###%20pyenv%20virtualenv

### python links

activating and using python virtual envs for nvim lsp
https://www.reddit.com/r/neovim/comments/n5gcsx/pyright_luaconfig_not_getting_my_pyenv_environment/
https://www.reddit.com/r/neovim/comments/ca91hq/pipenv_for_neovim_pythondependencies_what_is_the/
https://github.com/LunarVim/LunarVim/issues/1357

https://develop.spacemacs.org/layers/+lang/python/README.html#backends

## Language client (old)

[g / ]g - prev/next error/warning
ged - show diagnostic message in float-win (Lang client)
gsi - coc diagnostic - the same as above?
\gd ,gd/D - go to definition in floating/split
lead lg/lG - go to definition/ in split
lead lb - show references of current symbol
lead ls/S Ls - list symbols
leader lk - Symbol documentation
leader hK - coc showDocumentation
leader la - Code action → import symbol!
all options: ~/.vim/plugin/tools-langClientHIE-completion.vim#/nnoremap%20<leader>lm%20.call
insert c-i - show completions with type sig!
insert c-p /n/p - open drop down list
insert c-xu - this shows language client type sigs!!
leader ld - CocList diagnostics
gsd/D - language client fuzzy search - with sources link
gsb/B - browse module via :browse in psci. use 2leader ht, leader t[,c-l | ip | J] and leader as [ip | ect]
:set ft=text, leader sp - deactivate diagnostic in a buffer

### Types of bindings in scope

gw - Coc hover type
get - get types of in scope/context bindings at cursor position
geT - get type of identifier under cursor in do-bind. also gst, gsT
~/.vim/plugin/tools-langClientHIE-completion.vim#/Get%20types%20and

## Completion

### Coc.nvim

CocConfig - opens ~/.vim/coc-settings.json, defined by let g:coc_config_home = '~/.vim'
CocList symbols - allows to fuzzy-search and jump to all loaded symbols!
CocList commands
CocList sources - how to prioritise completion sources!
CocList <c-i> - to see all useful! options
CocList extensions
extensions are installed here: ~/.config/coc/extensions/node_modules/
note ~/.config/coc/
call CocAction('toggleExtension', 'browser')
CocList extensions
and then <tab> on browser, then 'd' for disable

CocList marketplace - search and install extensions. or use:
CocInstall coc-jedi - install an extension
all extensions: https://www.npmjs.com/search?q=keywords%3Acoc.nvim
https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions

Config: ~/.config/nvim/plugin/setup-lsp.vim#/coc-nvim
old:
~/.vim/plugin/tools-langClientHIE-completion.vim#/Completion

### Fzf

~/.vim/plugin/utils-fileselect-fzf.vim#/inoremap%20<expr>%20<c-x><c-k>

## Fonts

Custom fonts
https://www.nerdfonts.com/font-downloads

# Live code integration / repl

## Local webserver
python -m http.server   - to serve a folder of files

## Purs repl

~/.config/nvim/plugin/utils-repl.vim#/New%20Purescript%20REPL

ReplStart
ReplEval
ReplSimpleResponseHandler

e.g. this may become a subject again:
~/.config/nvim/notes/notes-todos.md#/##%20Pretty%20printing


## research links
https://www.reddit.com/r/neovim/comments/qag4ib/python_devs_out_there_what_are_you_using_to_get_a/

.. hmm https://github.com/michaelb/sniprun/blob/master/README.md

Use print statements:
https://github.com/meain/vim-printer

### Jaq
plugin/setup-jaq.lua
https://github.com/is0n/jaq-nvim
:Jaq   works, also on markdown

### abstract code runners
https://github.com/jbyuki/dash.nvim
https://github.com/thinca/vim-quickrun
https://github.com/formulahendry/vscode-code-runner

### literate programming
https://github.com/jbyuki/ntangle.nvim/blob/master/doc/ntangle.txt

### Codi
https://github.com/metakirby5/codi.vim
https://github.com/metakirby5/codi.vim/blob/master/doc/codi.txt

Jupyter notebook
https://alpha2phi.medium.com/jupyter-notebook-vim-neovim-c2d67d56d563

Terminal helpers
https://github.com/kassio/neoterm

### basically a notebook in vim
https://github.com/sillybun/vim-repl

### via SSH
https://github.com/abhishekkrthakur/colabcode
uses ngrok

### ngrok
https://bruhtus.github.io/posts/ssh-google-colab/

### Use Jupytext
https://jupytext.readthedocs.io/en/latest/
vim plugin: https://github.com/goerz/jupytext.vim

### magma nvim
https://github.com/dccsillag/magma-nvim
might get image preview support on mac: https://github.com/dccsillag/magma-nvim/issues/15

similar for just vim https://github.com/jupyter-vim/jupyter-vim

## Image Media preview
https://github.com/edluffy/hologram.nvim
in Chrome:
nnoremap glwf :call ShowLocalWebFile( GetLineFromCursor() )<cr>


## Purs repl / Ghci/ Intero

leader io/l/k/h - intero open/load/kill/hide
leader il - load just the current module
dr - reload ghci
leader ic - InteroCancelRunningProcessInGhci
gw, gW - show instantiated type at/vis-sel / generic type
guardP :: Alternative f => (a -> Bool) -> a -> f a
-> instantiated ((a, [a]) -> Bool) -> (a, [a]) -> Maybe (a, [a])
~/Documents/Haskell/6/HsTrainingTypeClasses1/src/Patterns.hs#/utakeWhile%20p%20=
not active:
get - show type of symbol or vis sel (also works when module not compiles)
,gw - insert type above
gek - kind at symbol or vis sel
gei - run symbol
gei vis-sel - run expression!
gel }/iI/ip - run multiple lines, e.g. imports
currently off
gel/c/C - show list of strings as lines
'gel' needs a list of strings, e.g. 'fmap (fmap show) $'
ger - Curl send sting in line to localhost, show response
get/T - type hole. at cursor/ in do block (Todo: should not affect undo)
leader cv - VirtualtextClear
gen/N - runs an top-level val/function with no args in NodeJS.

## Hs API Explore

gsd/D - to edit vis-sel and search for it
gsk - to insert info into buffer - using the module name (cursor on module shows module info!)
gsK - show info in float-win
gsb/B - browse module
leader t<motion> - tabularise type
off? ,atip/iB - to HsTabu Type-sig align a range: Use l, \j or 'v' visual-sel
2leader sm - SplitModulesInLines
2leader jm - JoinModulesFromLines
2leader ht - HsTabu
2leader hT - StripAligningSpaces
2leader sa - StripAligningSpaces
2leader sw - StripWhitespace
2leader hu - HsUnicode
2leader hU - HsUnUnicode

## Imports

### Haskell

leader Hii/I - (in HsAPI) import identifier
leader lHi - import identifier via LClient
leader hfi - format imports

### purescript

leader hii/I - (in HsAPI) import identifier
leader lhi - import identifier via LClient
leader hfi - format imports

TODO make Stubs and Markup maps consistent

## Stubs

leader eu/U - anonymous binding /+ signature
leader es - add signature type stub
leader eb - add function to type-sig/ expand signature
leader eif - add an index/num to the signature-symbol name
leader et - create inline test stub
leader ea - create assertion

## Code Markup & headings

leader ehs - heading
leader ehe - close section (does not include the header text in the end?)
leader ehr - refresh heading/section (currently on this updates the end text)
leader ehd - delete/strip heading/section

Might need to adapt this search pattern per language: ~/.vim/plugin/CodeMarkup.vim#/let%20g.headingPttn%20=
.. just tested it here and it worked: ~/.vim/plugin/search-replace.vim#/Operator%20And%20Movement

### Motions & text-objects

q/Q - Label/ Heading motion
ihc - 'inside heading content' text object

## Search & Docs

gsR/r - Grep search in the current repo! cursor-word editable.
use { and } to navigate found contexts. 'o' to open an item in the left split. <cr> to close
Fhask, Frepo - search local haskell code exampes: /6/HsTraining1/** 6/HsTrainingBook2/** - use single quotes for :Frepo 'multiple words'
}{ - jump files on search results
Fdeleted - deleted code in repo
Lines, GFiles?, BCommits, Maps, Helptags
gso, gsO - to search on websites e.g. pursuit.org
gsI - (deprecated) :GithubSearch of word or visSel
gsi - show coc diagnostic info of cursor position (cursor needs to be on the error or info)
gsd - hoogle search word under cursor or vis-sel
gsD <c-f> - hoogle edit vis-sel or wuc: gsD then <c-f> .. <c-c><cr> (?)
gsh - search hoogle.org
gse - explore definition (haskell-code-explorer.com)

### Search in project folder

Go to search root folder in Dirvish then
:Ag searchterm %\*\*
<c-n/p> to navigate results quickfixlist

### Search in select files with vimgrep

vim dirvish \*\* -- seach for 'dirvish' in all files. then use :cw/copen and ]q[q
collect the files and folder in the arglist ~/.vim/help.md#/###%20Arglist

vim[grep] writes to the quickfix / location list. example:
exec "1lvimgrepa /" . expand('<cword>') . "/ %"
lopen
https://gist.github.com/seanh/a866462a27cb3ad7b084c8e6000a06b9

## Karabiner Key maps

c-' - Next Mac app. See definition here: ~/.config/karabiner/karabiner.json#/"description".%20"Left%20Control

Older config (with tab remap?) /Users/at/.config/karabiner/karabiner.json.bak

## Window, Buffer Navigation


c-w n/N - SymbolNext SplitTop (??)
c-w i - jump into float-win
leader wp[ap/af] - pin a function/paragraph (or imports) to the top
c-w dk - close the window above
c-w \ - to jump to rightmost/mark/tag bar window
c-w p - to jump back
\t] - TabmoveRight /Left (this works with . repeat command!)
leader wi/I - Pin [and jump to cword] Haskell imports
c-w I - resize/fit floatwin height width
c-w x/S h/l/k/j - Swap with / Shift a window with the other adjacent window
1<c-w>x - swap window with the one above/at top of screen (2 is below)

Move a Buffer to a different window (potentially in a different tab)
leader cp     - copy file path of the source buffer
in the target window:
leader sp     - to set the buffer of this window to the filepath in the register
leader sP     - same as above, but copies the buffer filename
                that got replaced. So you can 'leader sp' that buffer into a different window.



### Window scrolling

c-e/y - up/down
zt/b - bottom/top

### Chromium tool windows
are launched via <space>glC
~/.config/nvim/plugin/tools-external.vim#/func.%20LaunchChromium.%20url

they may overlap with :MarkdownPreview window. There's also:
~/.config/nvim/plugin/tools-external.vim#/func.%20LaunchChromium2.%20url

To go to the next (overlapping) window:
  Cmd + *`*


### Buffers

]f [f   - next/prev file in folder
]b [b   - next/prev buffer in buffer list
help unimpaired

go - bufferlist: ~/.vim/plugin/file-manage.vim#/New%20file%20openers.
c-j/k, c-x - close a buffer in the ctrlP buffer list without opening it
c-ov/h to open offer in split
\^ <c-^> - to load the alternate (past) file or \e3 <c-^>

:BufferDeleteInactive or :Bdi - to wipe out all buffers not open in a window!

deactivated: Bdelete / Bwipeout - will delete buffers but not close related windows! https://github.com/moll/vim-bbye

## Files open

\v \T - browse-open file in new split/tab from the same project
:e %mynewfile - this creates a new buffer in the current Dirvish folder!
leader of - FzfPreviewGitFiles
leader oF - FzfGFiles

## MRU files, history
yegappan/mru

is usually based on the shada setting
#~/.config/nvim/plugin/setup-general.vim#/set%20shada=.,'1000,<50,s10,h


# Files fuzzy open

op - FzfPreviewFromResources project_mru. has nice color syntax
oP - FzfHistory
can tab multi sel. can use c-t or cv to open multiple wins/tabs. or! .. us <c-q> to open a single new tab with the
quickfix list open and ]q ready to go through the selected files.
~/.vim/plugin/file-manage.vim#/New%20file%20openers.
leader gp - ctrlP. use <c-o>v - browse-open recent file in a split e.g. from a different project

## Fzf how to custom setup
~/.config/nvim/plugin/utils-fileselect-fzf.vim#/Fzf%20config%20summary

### Fuzzy file selection

vim \*\*<TAB> - Files under the current directory - You can select multiple items with TAB key
vim ../fzf\*\*<TAB> - Files under parent directory that match `fzf`
cd \*\*<TAB> - Directories under current directory (single-selection)

' - exact matches
.sh$ - match at the end of the string
!vim - negate matching

Examples integrating with e.g. Chrome, NPM, etc https://github.com/junegunn/fzf/wiki/examples
More technical usecases https://github.com/junegunn/fzf/blob/master/README.md#advanced-topics


## Dirvish

Dirvish conf: ~/.config/nvim/plugin/file-manage.vim#/Dirvish
New file ops: ~/.config/nvim/ftplugin/dirvish.vim#/Maps

:vs ./   - open the cwd in a split! you can use <c-i> in command line to drill into sub-folders
a - open file in right split, then use ]f [f to go back forth the files in the dir!
x - add some files to the arglist that you want to work with. then open the first file (with a or i), then use
]a [a [A ]A - to go through the marked files (instead of opening tabs for all files)
2\. - to go to Shdo! prompt
. - on a file, then 'rm' or 'mv %..' to delete, more file.

t - open in new tab
.. leader of - open file under cursor in float-win. cursor is in float win so you can scroll right away.
P - preview in float-win
p - preview in (currently open?) split. only good if there is no other open split?
:e %mynewfile - this creates a new buffer in the current Dirvish folder!
g? - show help
K - file info/ dir size/ last write
leader df - delete file with relative path
vis-sel . - doesn't insert the full path: https://github.com/justinmk/vim-dirvish/issues/188
:!touch %newFile .. :!mkdir %newfolder
g; - to get :! in the vim command panel.
T - expands a the folder under the cursor.
:vs ~/Doc.. - then use <c-i> to expand path
I - edit divish buffer to execute shell commands with path
y$ - copy file name - note the cursor is at a specific pos in the _concealed_ file path!
0y$ - yank abs file path! - note the cursor is now at the start of the (concealed) line

## Tips

:cd % - set working dir to the current dirvish folder
:%!ls - to replace the text is the current buffer with
:'<,>call delete(getline('.'))

Dirvish settings and custom maps: ~/.vim/plugin/file-manage.vim#/augroup%20dirvish_config

" TODO Currently trying out: set the a local current dir (lcd) for the Shdo buffer ~/.vim/plugged/vim-dirvish/autoload/dirvish.vim#/execute%20'silent%20split'

# MacOS

## file rights executable chmod
~/.config/nvim/plugin/file-manage.vim#/func.%20SetExecutableFlag%20.

## Finder
Open a folder in Finder:
- open the folder in Dirvish, <leader>cdl or :lcd %<cr>, then glf. ~/.config/nvim/plugin/tools-external.vim#/command.%20Finder%20.call

## Preview
c-s j/k   - to scroll a pdf page in preview app.
(Control + right Shift key) .. note the karabiner config.

## Ranger
:set show_hidden!      - to enter command mode and show hidden files

### Ranger-like setup

"Win navigate right to left and use 'p'"
\T - new tab, go to a 'root' folder
,tn - new empty tab
c-w v c-w = - make 3 columns
c-w | - go to the next 'last window', then c-w h/l, then 'p' to fill the previous win with the content of the node
TODO some simple maps/commands for 'p' could achieve a basic ranger functionality!?

# Using file-paths

c-i - autocompeting filepaths only works at the beginning of the line. c-i is prefered as it allows fuzzy-filtering the suggested filenames. BTW the autocomplete menu shows the [F] at the end of the item.
c-x c-f - works only on paths without space. but now testing :set isfname+=32 .
c-w c-f - to open this path in dirvish. note this does not work with the "% 20" formatting of the whitespace in the second line
vis-sel of the path text will also make the 3rd line (with the plain whitepace) work!
gk - (rel-link) to open the second path in vertical divish. Note this _only_ works with the "% 20" formatting of the whitespace!
/Users/at/Library/Application\ Support/
/Users/at/Library/Application%20Support/
/Users/at/Library/Application Support/Google/AndroidStudioPreview2021.2/plugins/IdeaVim/lib/
"/Users/at/Library/Application Support/"

TODO test this option: :set isfname+=32 ~/.vim/vimrc#/Makes%20whitespace%20be
this lets me use spaces in paths! and complete with c-x c-f. but now paths have to start at the beginning of the line.

## Symlinks

Now using vim-symlink https://github.com/aymericbeaumet/vim-symlink to load the _target path_ of a file that is a symlink.
Note 'symlink' setting ~/.vim/plugin/setup-general.vim#/let%20g.symlink_loaded%20=

### hard link a file to a git repo for backup
I can just hard link any (notes) file into nvim/notes and it will be packed up
ln /Users/at/Documents/Server-Dev/server-setup.md /Users/at/.config/nvim/notes/server-setup.md
TODO: write a vim helper to back up a notes file.

limitation: pulling the file back from the remote repo (note I have never done this) would bread the link to the original file
therefore it would be better to have the original file in the repo and a related symlink somewhere in the documents folder.

### Network volumes / Google Drive

:sp /Volumes/GoogleDrive/My\ Drive/Sample\ upload.txt - load a Google Drive file with quoted spaces
/Volumes/GoogleDrive/My%20Drive/Sample%20upload.txt - this line works with 'gk' map. Note the hidden % 20
The next line/path only works with <c-w>f !
/Volumes/GoogleDrive/My\ Drive/Sample\ upload.txt

## Watching folders and filepaths
https://github.com/rktjmp/fwatch.nvim

## Control Chrome
### trigger function calls on page
notes/chrome-cli
~/.config/nvim/notes/chrome-cli#/##%20TODO%20Run

### Filepaths & Urls

c-w f - (on path or vis-sel) preview file content in horz-split
leader P - (on path or vis-sel) preview file or folder(!) in float-win
leader of - open filepath under cursor in float win
glc - open Url in line in Chromium
leader fpc/C - :FilepathCopy[Abs]. also :PasteFilepath (put =@% and let @\*=@% )

### Path expand and modify
echo expand('%:t')
echo expand('%:t:r')
echo expand('%:h')
echo expand('%:p:h')
echo expand('%:p')
echo fnamemodify('.gitignore', ':p')
echo fnamemodify('../scratch/.testsDefault', ':t:r')

help filename-modifiers
https://learnvimscriptthehardway.stevelosh.com/chapters/40.html
h expand()


## Links / code links / vim rel-link

glc - open Url in line in Chromium
glb - open URL in browser (note: hashes for anchor-links need to be quoted by \
 https://github.com/nvim-telescope/telescope.nvim\#default-mappings
leader ol - open 'links' file in float-win, then glc to view in Chromium

gk - follow rel-link
lead lg/lG - go to definition/ in split
gd ,gd - go to definition /in split

leader cl - to copy a rel-link to the clipboard
~/.vim/plugin/general-helpers.vim#/func.%20LinkRefToClipBoard..
help Rel
Substitude vim echoed locations with rel-lins: %s/ line /#:/ e.g. ~/.vim/plugin/HsAPI-haddock.vim line 37 => ~/.vim/plugin/HsAPI-haddock.vim#:37
leader fpc - copy current file path

### Arglist

leader oa - to show. or :ar<cr>
leader X - to reset/clear arglist
dirvish x - toggle to from arglist (x, vis-sel, line-motion) - " Tip: can add popular folders as well, then CtrlP-v/t to open the dirvish pane
leader oa - show arglist in CtrlP. v/t to open. <c-s> to delete

:arg \*.html or :argadd \**/*md

leader xiB  - toggle all dirvish files to the arglist

help argument-list
[a :previous
]a :next
[A :first
]A :last

maps and helpers: ~/.config/nvim/plugin/file-manage.vim#/Arglist

Populate Arglist: ~/.vim/plugin/notes-workflow.vim#/Populate%20Arglist.%20-

## autosave
~/.config/nvim/plugin/setup-general.vim#/Autosave

## quickfixlist

leader qq   - to open/close
copen / cw[indow] / cclose - to open/close the quickfix list
p/P - previews item in split / closes the preview split
]q [q   - next / prev item
[Q ]Q   - cfirst clast
leader qa   - to add cursor pos to qf list
leader M    - to add cursor pos to qf list

Maps: ~/.config/nvim/plugin/utils-quickfix-list.vim#/func.%20QuickfixMaps..
Note the 'go' command and the distinction with the location list maps

note the lua code here: ~/.config/nvim/lua/tools_external.lua#/local%20function%20setQF..
comprehensive article: https://vimways.org/2018/colder-quickfix-lists/

## Change Working Directory CWD Project Root

" Set the root to a specific folder - not necessarily a git root folder.
nnoremap <leader>cdg :cd %:p:h<cr>:pwd<cr>
nnoremap <leader>cdl :lcd %:p:h<cr>:pwd<cr>
nnoremap <leader>cdt :tcd %:p:h<cr>:pwd<cr>

There is also 'cds[earch]l/t/g'

leader dpr ":lcd " . projectroot#guess() . "\n"
leader dpR ":cd " . projectroot#guess() . "\n"
" Also consider using ":ProjectRootCD"
~/.config/nvim/plugin/setup-general.vim#/Change%20Working%20Directory.

### Use the CWD
- for search
- for terminal commands (gwt). Example: run gwt on the next two chars: lsl

:e .     - to just go back to the cwd in dirvish
:vs ./   - open the cwd in a split! you can use <c-i> in command line to drill into sub-folders

### Copy the CWD
in dirvish folder: leader Fpc, then in target window: :lcd <c-r>"<cr>


## Move / Copy files

in dirvish, "." on the file, then mv/cp, then <c-f>A to go to the end of the line to specify the
target path: - use %.. to move/copy to the parent folder.
             - use %subfoder/ to *keep* the filename and move/copy to the subfolder. (note the "/" at the end!)

manual/low level:
yy in Dirvish - copy the full file path
navigate to the destination path in Dirvish then `glT` to open a terminal at that location
mv or cp ("cp -r" to copy a folder) then <c-[> to go to normal mode then `p` to paste then insert and `.` to copy/move into current folder
assisted:

- put two dirvish folders side by side. use e.g. \T\v
- the win/folderpath that has the cursor is the source (the other window/folder is the target of the file-move) (left/right does not matter)
- add files to the arglist (highlighted in red). use ,x(l/}/vis-sel)
  - reset arglist with leader X
  - show arglist with leader oa (CtrlPArgs)
- run the shell command with leader mv
- alternatively preview/edit the command with leader mV
  detailed description: ~/.vim/plugin/file-manage.vim#/Move%20Files

### Rename files / buffers
RenameBuffer .bak%   - to  disable  / backup a file. (could also more into .bak/ folder?
!mv '.bak.eslintrc.js' .bak/

### Move / copy text (vim registers)

leader "   - to show registers in telescope

" Vim clipboard features: Delete is not yank, substitute operator, yank buffer.
vim-easyclip plugin: ~/.vim/vimrc#/Vim%20clipboard%20features. https://github.com/svermeulen/vim-easyclip
help easyclip

https://www.brianstorti.com/vim-registers/
help reg
leader" - show register bar (vim-peekaboo: https://github.com/junegunn/vim-peekaboo)
\"pyiw - yank into the 'parameter'
put =@" - put/refer to the content of a register
:@" - execute the content of the register (needs two <cr><cr> .. don't know why)
:@0/1/2/a/b - run a specific register
leader sr - exec the string in the normal \" register

some test text
let @_ = getline(line('.')-1)
let @_ = 'just a test'
put =@"\*
put =@"

put =@1
call setreg('1', 'hi')
call setreg('1', [])

#### clear all registers
let regs=split('12345678', '\zs')
call functional#map( {r -> setreg(r,[])}, regs )



### Shell system clipbord

Simple usecase of how to use pbcopy:
cat .gitignore | pbcopy
pbpaste | bat
ls -l | fzf | pbcopy

## Command window

; - then c-n and c-i and c-x c-f for completion.
" - c-cr/return to commit in insert mode. leader se in normal mode

            mkCounter = component "Counter " \props -> Hooks.do

# Git

notes/notes-git.md

## clone a github subdirectory/ folder
utils/git_clone_subfolder.sh

hmm, this doesn't seem to work:
sh /Users/at/.config/nvim/utils/git_clone_subfolder.sh examples https://github.com/hayes/pothos
sh /Users/at/.config/nvim/utils/git_clone_subfolder.sh tree/master/examples https://github.com/hayes/pothos



## Intero Errors or Warnings

leader qq - open QFL
[Q [q ]q - go to first/prev/next error (while in main win)
c-n/p - next/prev (while in QFL)
go (in QFL) - jump to line (but stay in QFL)
p - to open file:loc in preview window, `c-w z` or `P` to close preview

## LC Warnings AND Errors

leader ll - open Loclist
[L [l ]l - go to first/prev/next error/warning (while in main win)
important: do exactly as in above and below line!! this goes through errors and warnings - but not a big problem
changes update right away in the LocList win!
Go (in LLi) - jump to line (but stay in LocList)
c-m/i - next/prev in QFL
p - does not work! .. could set up a split?
censor/filter warnings: ~/.vim/plugin/tools-langClientHIE-completion.vim#/\%20,%20'censorWarnings'.

## Align, Indent, format

,,l/j/} - indent range of lines to current cursor-column
.. idea/todo: align/push only the vis-selected part of the line
dw - align/pull inwards to the cursorH the first char to the right
`>ii` - shift lines of indent block to the right
,a(motion)(sel) - run a multi-col align template on motion or vis sel
,aii= - will align to "=" inside indent block
leader al - easy align
leader a-ii - align a 'case' block! to '->'
leader t<motion> - tabularise type sig
off? leader ha (+m/vs) - type-sig align (motion or vis-sel) 'aB'-> error?
TODO leader haiB show missing function
leader hA - type-sig align entire buffer. or "viB<space>ha<c-o>"
]e,[e - move/shift line. (lines using vis-sel)
,> - push / shift text to the right ~/.vim/plugin/utils-align.vim#/Push%20shift%20text
leader sb/n - break line at cursor, indent to cursor col
,,l/} - intent the line to the current cursor col
TODO: use visual-sel to intent from a specific point of the line string. ~/.vim/plugin/utils-align.vim#/TODO.%20use%20visual-sel
Note: the custom indentexpr that is used: ~/.vim/indent/purescript.vim#/setlocal%20indentexpr=GetHaskellIndent..
yow - to toggle line wrapping

Align templates using UserChoiceAction/ quickmenu: ~/.vim/plugin/utils-align.vim#/Align%20Templates

## Purs Browse Module

# Format

leader leader sm 'SplitModulesInLines'<cr>
leader leader jm 'JoinModulesFromLines'<cr>
leader leader ht 'HsTabu'<cr> in entire buffer
leader leader hT 'StripAligningSpaces'<cr>
leader leader sa 'StripAligningSpaces'<cr>
leader leader hu 'HsUnicode'<cr>
leader leader hU 'HsUnUnicode'<cr>

## JSON format

%!jq
or
%!python -m json.tool

## JSON encode / decode

func! tools_js#json_stringify( expressionCodeStr )

vimscript: json_decode()
lua: vim.fn.json_decode(response.body)

# Curl / http requests
~/.config/nvim/notes/notes-lua-asyc-loop.md#/##%20Curl
but rather use ->
## Node axios
~/Documents/Server-Dev/b_tssetup/src/httptests.ts#/import%20http%20from

# Unicode
c-x g    - after key-characters in insert mode. e.g. type "->" and then <c-g>g to select the symbol
Telescope symbols
UnicodeTable
help unicode-pugin

Nice symbols in use with conceal in purescript and typescript syntax files:
~/.config/nvim/syntax/purescript.vim#/https.//unicode-table.com/en/blocks/miscellaneous-mathematical-symbols-b/
~/.config/nvim/syntax/typescript.vim#/let%20g.TsCharsToUnicode%20=

# Motions

now using https://github.com/chaoren/vim-wordmotion
with "," prefix g:wordmotion_prefix ~/.config/nvim/plugin/setup-general.vim#/let%20g.wordmotion_prefix%20=

g; - to revert the InsertLeave jump
gI^- <cr> - to prefix the current line with a '- ' without moving the cursor
leader j - break line (with indention)
<BS> - Join line below with current line
imap <BS> " - This 'undo's a line break while staying in insert mode
q/Q - labels
tab/s-t/,t - Headers next/prev /end of header
c-i/m - ballparks
]b[b - binding-type sig (incl where, let)
cib - to change the binding name in consequtive lines
Y/I - columns - based on unaligned syntax e.g do bindings
J/K - Word column corners Forw/Backw (based on aligned visibleColumns)
t/T - next/prev list item
]t/[t - into next/prev inner list
]T - end of list (to append new elements) brackets
TODO - this got overwritten by coc diagnostic next/prev
[g ]g - go back to last insert start/end. or native \`[ \`]
z] z[ zk - beginning/end of current fold/prev fold
[c ]c - prev/next git hunk (TODO: make ]c or c] consistent?)
,j/k - beginning of next/prev line
,J/K - end/start of indent block
g]/g[ - first/last char of prev yanked text
\e - move to the end of the previous word

q/Q - Label/ Heading motion
ihc - 'inside heading content' text object



## Sneak & easymotion
~/.config/nvim/plugin/setup-general.vim#/Sneak%20Code%20Navigation

Sneak - forward OR Backward motion
f/F - f<char> to jump to next char. L/H to next

Easymotion - forward AND backward (!) motion:
,f - then type first char, then the label keys that show up. Use this when you have already spotted/focused/read a particular char/word.

,j/k - line motion


## Text-objects

Can look up the textobjects here:
https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/javascript/textobjects.scm
https://github.com/nvim-treesitter/nvim-treesitter-textobjects\#built-in-textobjects

Then define select, move (and shift) maps here:
~/.config/nvim/plugin/setup-treesitter.lua#/textobjects%20=%20{

help text-objects
iB - inside entire buffer ~/.vim/plugin/HsMotions.vim#/Textobjects.%20

### vim (welle-) targets
~/.config/nvim/notes/notes-navigation.md#/###%20Targets
~/.config/nvim/plugin/setup-general.vim#/Vim%20targets

### Html tags
vit/vat  - work nicely for html tags. these maps are *native*



### Comma
vIt      - comma separated item (experimental see: ~/.config/nvim/plugin/HsMotions.vim#/Comma%20textobjects




### Command Insert Mode Movement

c-f - into command edit mode!! test with <leader>s$: call append('.', input('--: ', 'eins zwei'))
Use Fn Key + "h,j,k,l" to navigate in insert mode (see Karabiner setup: ). normal movement while in insert mode: use this prefix/leaderkeystroke: "<c-o>" then e.g. "$"/"0"/"b"
Insert Mode motions: - "c-x" - "c-w" - "c-g, c-k"

## Actions Changes Edits

S$ - substitute / replace to the end of the line
cs['"/{(] - change surrounding quotes/brackets e.g. {these once} to "these"
<op>J/K - yank, source lines to the end of the block. e.g.
,dJ (with cursor at start of line) - delete / cut into register
yip - yank the paragraph
leader" - show register bar (peekaboo)
c-r - paste while in insert mode(!) using register bar

## Folds, Folding

`zf` `zd` create/delete fold markers via motions/vis select
`zk` `zj` to navigate
`]z` `[z` go to end/beginning of current fold
`zo` `zc` `z<space>` to open/close/toggle individual folds
`zM` `zR` to close/open all folds
`zm` `zr` progressively close/open the fold levels (of nested folds)
`zx` / `zX` update /re apply

## Tools

leader og - Git magit. Also :GitcommitAuthor
leader oG - Git gitV viewer
leader ot - Tagbar
leader om - Markbar
leader oU - Undo tree (Mundo)
:StripWhitespace - removes whitespace

## Tags, Vista, Tagbar, Symbols Outline

leader / - Search for tags
leader ? - FzfPreviewBufferTags
leader2 - FzfTags - searches tags everywhere?!

leader ot/T - open Vista / Tagbar
c-w \ - jump to it from leftmost win (c-w p to jump back to prev win)
? in win - show help
p in win - to jump to tag but cursor stays in tagbar

this actually works:
call TagInStatusline()

now using SymbolsOutline:
~/.config/nvim/plugin/setup-symbols-outline.lua#/vim.g.symbols_outline%20=%20{
~/.config/nvim/plugin/setup-general.vim#/nnoremap%20<leader>ot%20.SymbolsOutline<cr>

### Vista usage

use fold interaction: ~/.vim/help.md#/##%20Folds,%20Folding

config: ~/.config/nvim/plugin/setup-general.vim#/Vista.

## Marks

leader om - open Markbar
m[A-Z,a-z] - create global,local mark
'[A-z] - go to mark. \` jumps to cursor pos
M[A-z] - delete mark
in markbar:
c-n/p - next/prev mark
o - open mark at cursor
c-x - delete mark
DelLocalMarks, DelGlobalMarks
gz'M - Open a mark position in a floating-win. Use empty floating win with marks jumps: e.g. gz'M

Markbar config: ~/.config/nvim/plugin/setup-general.vim#/Marks.

## Vim-Bookmarks

~/.config/nvim/plugin/setup-general.vim#/Vim-Bookmarks
https://github.com/MattesGroeger/vim-bookmarks
https://github.com/tom-anders/telescope-vim-bookmarks.nvim

### Jumplist

leader c-o - FzfPreviewJumps

## Bookmarks Shortcuts / Popular links

also consider:
<leader>ts <cmd>Telescope sessions<cr>
<leader>tr <cmd>Telescope repo list layout_strategy=vertical<cr>

~/.vim/plugin/file-manage.vim#/Shortcuts%20to%20popular
leader ou :tabe ~/.vim/utils
leader or :vnew ~/.vim/plugin
leader oR :tabe ~/.vim/plugin
leader on :vnew ~/.vim/notes
leader oN :tabe ~/.vim/notes
leader ov :vnew ~/.vim
leader oV :tabe ~/.vim
leader od :vnew ~/Documents
leader oD :tabe ~/Documents/
leader oh :vnew ~/Documents/Haskell/6/
leader oH :tabe ~/Documents/Haskell/6/
leader op :vnew ~/Documents/PS/A/
leader oP :tabe ~/Documents/PS/A/

noremap \v :exec "vnew " . expand('%:p:h')<cr>
nnoremap \T :exec "tabe " . expand('%:p:h')<cr>

## Rename, replace, substitute

https://vim.fandom.com/wiki/Power_of_g

<!-- '<,'>s/old/new/g -->

.+1,.+2s/old/new/g
exec( '.+1,.+2s/old/new/g' )
eins old
old zwei
drei old

Comment out all highlight command lines:
%s/^hi/" hi/g

More tricks: ~/.vim/plugin/notes-workflow.vim#/Substitute%20Replace%20Text.
Turn abs system path into home-dir path: <!-- '<,'>s/\/Users\/at/\~/ -->
or use plugin? https://github.com/nvim-pack/nvim-spectre
To remove ^M characters (windows line breaks?) use exec "%s/\r//g"

### Substitute in buffer example
help substitute
cautious with the following commands!
they comment and uncommend lines (insert "// ") when a pattern matches
exec '%substitute/^\zelet\se\d_/\/\/ /ge'

exec '.+1substitute/\/\/\s\zelet\se\d_//ge'
let e1_greetMore = greetMore("abcc")

eins test

// let e1_someLet2 = someLet2()

ranges
exec '.+1,.+8s/\zelet\se\d_/\/\/ /ge'



### Commandline-ranges

help cmdline-ranges
https://vim.fandom.com/wiki/Ranges

### Replace variable names

leader lr/m - rename symbol with all it's live/active references
ga \raf - highlight/search symbol, \r + range of the replace. leader-rb is a sortcut for a haskell function rename
leader rb - to rename a binding and its occurences

## Patterns & regex

help pattern.txt
help pattern-overview
Extract string from a line example: ~/.vim/plugin/CodeMarkup.vim#/Extract%20headline%20text
useful examples:
  ~/.config/nvim/plugin/search-replace.vim#/func.%20PatternToMatchOutsideOfParentheses.%20searchStr,
  ~/.config/nvim/notes/notes-navigation.md#/*%20Lookarounds

optional atoms:
/\v^(async\s)?function
async function ()

note the single quotes!
elseif resLines[0] =~ '\v(with)|(select)'

character-classes:
h character-classes
\W is a non-word character

# Vim

### vim help

leader K - Vim help. Use :HelpGrep .. ':hg nnoremap'<cr> for a text search
leader vh - FzfHelptags only allow a simple <enter>. no preview. it's still good.
:Help w<c-i> - complete help terms

### vim-infos

leader Sm - :MessagesShow - show past vim echoed text (show messages) in preview window - output of any single command: RedirMessagesWin verb set comments?
put =g:maplocalleader - put the content of a variable into the buffer!
nvim -V10vimlog - debug vim startup and sourcing process

### Debug with test.vim
Have a file name test.vim and put this in your file (this file use vim-plug as an example, you should use your own plugin manager), remember to change your language server.

call plug#begin('~/.vim/plugged')
    Plug 'neovim/nvim-lsp'
    Plug 'nvim-lua/completion-nvim'
call plug#end()
lua require'nvim_lsp'.sumneko_lua.setup{on_attach=require'completion'.on_attach}
au Filetype lua setl omnifunc=v:lua.vim.lsp.omnifunc
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
Use nvim -u test.vim {your_file} to open your file.


## List of commands, maps and vim-sets (settings)

leader vm - FzfMaps
leader vc :Telescope commands<cr>

:filter function \*stat<c-i> - just text seach in function names
Find where a vim-command, function or map is defined

:set <c-i> - list of vim settings: /Users/at/.vim/notes/vimdump-set.txt
:verb command [first letter: T] <c-i> - list of commands: /Users/at/.vim/notes/vimdump-command.txt
:verb function [fist letter: S] <c-i> - list of function: /Users/at/.vim/notes/vimdump-functions.txt
:verb map [first key: g]<c-i> - list of vim-maps: /Users/at/.vim/notes/vimdump-map.txt
then use <c-n/p> to navigate all mappings starting with e.g. 'g'
:scriptnames - List of vim-script files: ~/.vim/notes/vimdump-scriptnames.txt

:echo g:mapl<c-i> - list of g:/global variable starting with mapl .. maplocalleader

### Show internal lists/ paths

put =&packpath
/Users/at/.vim,/Users/at/.config/nvim,/etc/xdg/nvim,/Users/at/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime,/opt/homebrew/Cellar/neovim/0.6.0/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/at/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/at/.config/nvim/after,/Users/at/.vim/after
put =split(getline(line('.')-1), ',')

### vimdump files updating

:RedirMessagesWin verb map - put any vim command echo text into a new buffer
Substitute vim echoed locations with rel-lins: %s/ line /#:/ e.g. ~/.vim/plugin/HsAPI-haddock.vim line 37 => ~/.vim/plugin/HsAPI-haddock.vim#:37
Collapse two lines into one: %s/\n.\*Last set from/ | /

toggle vim settings: ~/.vim/vimrc#/function.%20ToggleOption.option_name,%20....

## Vim-commands

leader . - releat last command
verb command Colo<c-n> - get a list of commands and where they are defined
verb map Colo<c-n> - get a list of maps and where they are defined
\sm - set syntax markdown - see ~/.vim/plugin/notes-workflow.vim#/Set%20Syntax.
:Alacritty - open new terminal and then vim instance
c-g u - will set an undo-mark
leader cv - clear virtual text
leader cs - clear signs column
leader vo/O - open current file/PS folder in new vim instance
~/.vim/plugin/syntax-color.vim#/STEP1.%20FIND%20THE
Find color: nnoremap <leader><leader>hsc :call SyntaxColor()<CR>
Find syntax: nnoremap <leader><leader>hhsg :call SyntaxStack()<CR>

## Sourcing vim files

leader so - source the current file
leader se - source/run the current line
leader leader sv - :so $MYVIMRC
leader saf/p - source function or paragraph
~/.vim/plugin/utils-vimscript-tools.vim#/Sourcing%20Parts%20Of

### Vim Quickmenu / UserChoiceAction

~/.vim/plugin/ui-userChoiceAction.vim#/User%20Choice%20Menu

# Maps, Mappings, Expression maps

~/.vim/plugin/notes-workflow.vim#/Mappings.



## Mapping Control ctrl keys to Option alt key
The problem: vim can only receive/map some <c-..> keys.
some control keys can be nicely mapped. e.g.:
nnoremap <c-n> :echo 123<cr>
other are not possible to map. e.g.:
nnoremap <c-.> :echo 123<cr>
even other where possible to map before, they have now stopped working. e.g.:
nnoremap <c-m> :echo 123<cr>
The workaround: You can remap these impossible control-.. key in karabiner to an option / alt key!
See how control-m is remapped to option-m here: ~/.config/karabiner/karabiner.json#/"description".%20"Control%20m
Related to this there is another challenge: ->
### Mapping Alt / Option keys
This does not (seem to) work:
nnoremap <A-m> :echo 123<cr>
Vim can only receive special character corresponding to these Alt-key. These character can be found like this:
In insert mode press control-k .. the a ? will show up. Then the Option-key combination (twice?!) to get the special char.
nnoremap µ :echo 124<cr>
Now this map works with option-m AND with control-m (because control-m is mapped to option-m in karabiner setting)

See also: ~/.config/nvim/plugin/utils-navigation.vim#/nnoremap%20≥%20.vertical
~/.config/nvim/plugin/HsMotions.vim#/nnoremap%20<silent>%20µ

### Defining operator maps

This is a current example with some documentation:
~/.config/nvim/plugin/code-line-props.vim#/Run%20list%20of

help map-operator

Basic example: ~/.vim/plugin/utils-vimscript-tools.vim#/func.%20OpSourceVimL.%20motionType, ~/.vim/plugin/search-replace.vim#/Operator%20Map.%20The
Examples with generic operator functions

- template for opfunc mappings (+vis-sel +command range) is here: ~/.vim/plugin/utils-align.vim#/command.%20-range=%%20StripAligningSpaces
- Gen_opfunc2: applying a function via an operator map, visual selection and command ~/.vim/plugin/code-line-props.vim#/Vim%20Pattern.%20For

## Syntax color, highlights

Telescope highlights
we now have a fast Colorizer
Filter ansi color escape codes: ~/.config/nvim/plugin/search-replace.vim#/func.%20RemoveTermCodes%20.lines.
  and potentially convert them to html/vim highlighting using ansifilter

i used this before:
" set filetypes as typescript.tsx
" autocmd! BufNewFile,BufRead *.js,*.tsx,*.jsx set filetype=typescript.tsx

colorscheme munsell-blue-molokai


## Configure a color
~/.config/nvim/plugin/syntax-color.vim#/STEP1.%20FIND%20THE

## Colorizer.nvim
to highligh colors in code (CSS, JS, HTML, VIM)
~/.config/nvim/plugin/setup-general.vim#/require%20'colorizer'.setup%20{

# Notes

~/.vim/plugin/notes-workflow.vim#/Defining%20Commands%20And

# Shell / ZSH

read shell variables: ~/.config/nvim/plugin/tools-tab-status-lines.vim#/func.%20PyVimVirtualEnvExt%20..

## Command line $PATH

(note that I'm now using ~/.zprofile like this to add to my $PATH)
~/.vim/notes/notes-node-npm.md#/.note%20that%20I

Previous approach:
To set the system-wide $PATH, run "sudo nvim /etc/paths"
~/.zshrc#/#%20Previous%20$PATH.
https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7

lead lead ls - uses ShellReturn() to show the result of 'ls' ~/.vim/plugin/tools-external.vim#/func.%20ShellReturn.%20cmd

## Zshrc & Oh-my-zsh

lst - ls/list tee. Some alias's (e.g. for tree/lst) use 'exa': ~/.zshrc#/alias%20lst='exa%20--sort=type

Plugins are installed via git here: /Users/at/.oh-my-zsh/custom/plugins/

# Terminal settings

## Alacritty

/Users/at/.config/alacritty/alacritty.yml
Man alacritty
:!alacritty - to open a new Alacritty MacOS App!/ window
grt on "alacritty" will launch - alacritty
Install locations via brew - /opt/homebrew/bin/alacritty

## Kitty

Kitty uses the system shell which is set to zsh: echo $SHELL .. /bin/zsh
reload shell settings with 'exec $0' or 'source ~/.zshrc'
'which'/'type -a' <shell-cmd> - shows info about a shell command

cmd , - to open Kitty settings
crt cmd , - to refresh settings
c-z - to suspend vim and go to the terminal - then if done in the terminal do fg ('foregr') to resume the vim session
c-s-t - new tab in kitty! use ctrl+shift + arrows l/r to navigate tabs. see: https://sw.kovidgoyal.net/kitty/overview/

# Terminal buffer

gwt - run command from cursor pos via shellreturn()
,gwt - make the command editable
gwT - run in asym terminal buffer

glt/T - open a new terminal buffer in project root (also works in dirvish)
gLt/T - to prefill and edit line command string to running it in a hidden/visible term-buffer
:Term! npm run serve - run command in terminal buffer. (!) optionally opens the buffer in a split.
<ctl>\n - to leave terminal insert mode but stay in buffer. to e.g. scroll/copy text
need to keep control pressed for both successive key strokes: \ and n
c-w-c - cancels the terminal process and deletes the terminal buffer
when in terminal insert mode, else just closes the window.

" TODO: Run commands in hidden buffers!
glt - runs the current line text in a hidden terminal buffer. find it in buffer list by the command string!

#### Terminal maps

c-r - to search through past commands in terminal. (use repeatedly! to search further)
note: ~/.zsh_history
c-w h - to delete the last word in insert mode. this is needed bc c-w jumps to buffer above

### Vim -> terminal commands

gwt - run command in terminal (command is string in line from cursor or vis-sel)
gwT - with editable command string

:%! - execute all lines if the current buffer as shell commands!
:put =system('ls')<cr> - put the return value of 'ls' into the current buffer!

## Spell Checking

Toggle with "yos" ":Spell"/ "SpellDE"/ "SpellEN" on. "set nospell" turns it off
" Navigate errors: "]s" - "[s", show suggestions: "z=", rather: "ea" to go to insert mode at the end of the word, then
" "c-x s" to open suggestion menu! TODO prevent proposing capitalized suggestions.
" add to dictionary: "zg" undo "zug"

currently only z= works for suggestions?

# Scratch window, temp notes file

leader os - ScratchWindow
<c-w>c - just close the window / buffer will reopen after leader os
leader bd/D - delete the buffer. bD for :bd! is not needed
leader oS af/ip/\j or visSel - put lines into a scratch window
note this alternative:
leader wp af/ip ..

## DB / Databases

notes/notes-db-sql.md
plugin/tools_db.vim
help dadbod-ui


## Startup screen
leader st
https://github.com/mhinz/vim-startify/wiki/Plugin-features-in-detail

SLoad <c-i>    - load sessions

## Repos & Projects
leader tp   - to manage projects https://github.com/nvim-telescope/telescope-project.nvim
  d	delete currently selected project
  r	rename currently selected project
  c	create a project*
  s	search inside files within your project
  b	browse inside files within your project
  w	change to the selected project's directory without opening it
  R	find a recently opened file within your project
  f	find a file within your project (same as <CR>)

leader tr   - select a repo



## Sessions

Now using: ~/.config/nvim/plugin/setup-general.vim#/Neovim%20session%20manager
but not autoloading


Maps: ~/.config/nvim/plugin/setup-general.vim#/Vim%20Sessions.
Commands: https://github.com/Shatur/neovim-session-manager\#commands

outdated:
  leader So <c-i> - open a named session
  leader Sn - show name of the current session
  leader Ss - save/update the currently active session
  Rather do this: Save useful tab layout with a descriptive name:
  SessionTabSave nvim-lua-config
  SessionTabSave gatsby-tut1
  SessionTabSave nextjs-tut1
  You can open them as a session
  SessionOpen gatsby-tut1
  But this would switch out the current session:
  SessionOpen nextjs-tut1
  You could rather do this:
  tabn
  SessionTabOpen gatsby-tut1
  i.e. load an additional tab layout into a new tab

  leader Sd - load default session
  leader Ss - save to default session


## Infos

leader2 lc[iB/ip] - count lines of code

### Todo

getnextscratchpath from project root + create that dir, count files
Ag search
list all autocmd mksession
search in :ChromeBookmarks
tabline should show dirvish foldername

highlight standalone 'state' and onClick. on(capital letter) - 'on' dark - but a lighter color for the rest

### Todo:

highlight halogen and react-basic hooks functions
like 'state' and 'onClick'
this is overwriting my syntax-state matches?
~/.vim/syntax/purescript.vim#/syn%20match%20purescriptIdentifierDot1
should turn these into syntax statements ~/.vim/syntax/purescript.vim#/call%20matchadd.'purescriptStateKey',%20'\vstate\.\zs\w{-}\ze_s',
use 2leader hhsg - to show syntax groups
read the documentation here!: ~/.vim/plugin/syntax-color.vim#/STEP2A.%20If%20you

function argument highlighing ~/.vim/syntax/purescript.vim#/TODO%20rather%20highlight
https://github.com/pboettch/vim-highlight-cursor-words/blob/master/plugin/hicursorwords.vim
https://stackoverflow.com/questions/1551231/highlight-variable-under-cursor-in-vim-like-in-netbeans


Show purescript syntax in Coc completion menu
