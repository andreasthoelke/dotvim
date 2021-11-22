

# Repl scripts
~/.vim/plugin/utils-terminal.vim#/command.%20PursRepl%20.let

a long useful(?) list
> :show loaded
Concur.Core
Concur.Core.DOM
Concur.Core.DevTools
Concur.Core.Discharge
Concur.Core.ElementBuilder
Concur.Core.FRP
Concur.Core.Gen
Concur.Core.IsWidget
Concur.Core.LiftWidget
Concur.Core.Patterns
Concur.Core.Props
Concur.Core.Types
Concur.React
Concur.React.DOM
Concur.React.Props
Concur.React.Run
Concur.React.SVG
Concur.React.Widgets
Control.Alt
Control.Alternative


# Node install
Version manager 'n' in /user/local

# New project
mkdir my-project && cd my-project
spago init

spago build
spago test

spago install lists
spago repl

## Spago process
mkdir test1 & cd test1
spago init
spago install (redundant / 'build' does this too)
spago build (produces e.g. output/Main/index.js)
spago run (same as node -e "require('./output/Main/index').main()")
spago bundle-app && node .

spago bundle-module --to index1.js
node -e "console.log(require('./index1').main)"
node -e "console.log(require('./index').main)"

this is quite nice but it seems to build twice?
spago build --then "spago run" --watch --clear-screen

spago ls deps - to list dependencies
spago ls deps --transitive
spago ls packages - what is available in your current package-set

spago install lists - lib version from package set! - will show up in spago.dhall dependencies
spago ls deps - to confirm this shows up in dependencies

### Package install
" "spago install <packagename> && spago build"
PursInstall echom jobstart("spago install " . <q-args> . " && spago build", g:ReplCallbacks)
- Todo: " add :CocRestart and Prebuild to this

### React starter
λ npm init
λ npm install —save-dev purescript spago parcel-bundler
λ npm install —save react react-dom
λ npx spago init
λ npx spago install react react-dom web-html web-dom


# Zephyr
Copyed manually to Users⁩ ▸ ⁨andreas.thoelke⁩ ▸ ⁨.local⁩ ▸ ⁨bin⁩
https://github.com/coot/zephyr

  some: more stuff: and

purs docs --format ctags "src/**/*.purs" ".spago/**/src/**/*.purs"
which also can be done using spago directly:
spago docs -f ctags


# Tags
:Tags <start search str> browses the tags - but it does only navigate to the file not the definition in the file
:CtrlPTags - this does navigate to the function but it does not take a start/search val?
This throws errors: purs docs --format ctags "src/**/*.purs"
This does generate a tags file with "wc ~10000" lines but the namespace of the project is missing. I also cant filter
per file. Base on this, using 'cat/echo' I could have provided tagbar a stdout stream.
  spago docs -f ctags

# Language clients
Can't find it's root folder
" Plug 'FrigoEU/psc-ide-vim'
but the :Plist command somehow works

Not sure if I need the config


# vimmersps
this can actually do `Pimport traverse` - however that seems to be the only working feature?

TODO iskeyword is set - disabled now
~/.vim/plugged/vimmer-ps/ftplugin/purescript_vimmerps.vim#/setl%20isk+=.,48-57,<,>,$,#,+,-,*,/,%,',&,=,.,.,124,~,?,^

## purescript-vim and haskell-vim
they merely set the filetype? - for indentation there is  https://github.com/itchyny/vim-haskell-indent
~/.vimrc#/Plug%20'unclechu/haskell-vim',%20{

TODO: as a quick hack I just dublicated the indent/haskell.vim file as indent/purescript.vim:
~/.vim/plugged/vim-haskell-indent/indent/purescript.vim#/setlocal%20indentexpr=GetHaskellIndent..

## Go to definition
gd - uses Coc
leader lg - language client - it's a bit 'bumpy'
.. both only seem to work sometimes?

# Hotreloading
https://discourse.purescript.org/t/recommended-tooling-for-purescript-applications-in-2019/948#heading--6
works nicely with the concur starter repo

# Review old examples
I played around and commented the code whenever the Utils file is copied into the project


# Coc
CocAction has some interesting options - convert to snippet, etc

test Coc search :CocSearch Either

## List of warnings and errors
leader ld :CocList diagnostics will show a fuzzy/fzf list
<c-j/k> to navigate (don't bother to go to normal mode with <c-o>?)
<c-i>p to preview
<c-o>o to open that item/line in the main window
<c-o> normal mode, then <c-w>k is possible

in the line of the warning/error a gsi will refresh Coc-Diagnostic window
`ged` does the same with language client - is a bit more consise

censor/filter warnings:  ~/.vim/plugin/tools-langClientHIE-completion.vim#/\%20,%20'censorWarnings'.

alternatively:
:CocDiagnostics will show a quickfix list
leader qq, then ]q[q ]Q[Q p to preview
only 'p' to preview seems to work - <cr> to jump seems to work resort/invalidate items?
UX isn't great of this

useful workflow to overview errors and workings:
 leader qq, then set syntax=purescript
 yow to wrap messages, then <c-w>k and use ]q [q to see the focus highlight move in the QF list

Styling: ~/.vim/colors/munsell-blue-molokai.vim#/hi%20link%20CocErrorFloat

use <c-f> to close context menu
use :CocConfig then "suggest. (..)" to condig menue

use <c-o> to get to normal mode, then `?` to see help

### workspaces
CocList folders - then <c-i> to delete and edit (try this)
  `edit` allows to change the workspace path

### renaming
TODO? - there is support in language server
other utils are ~/.vim/plugin/HsMotions.vim#/nnoremap%20<leader>hrb%20.call
nnoremap <leader>hrb :call BindingRename()<cr>

### debugging
CocList services
try out? -> https://github.com/microsoft/language-server-protocol-inspector

### just some command i tried
CocList --normal location
CocNext
CocList files
CocList commands
CocList sources  - how to prioritise completion sources!
CocList <c-i> - to see all useful! options
CocInstall coc-actions
CocInstall coc-browser
CocList sources
CocInstall coc-explorer
CocCommand explorer
h coc-lists
CocList
h coc-list-links@en
CocInstall coc-lists
CocList symbols
CocList outline
CocInstall vimlsp
CocInstall tailwindcss
CocInstall coc-tailwindcss
CocInstall coc-vimlsp
CocInstall coc-markdownlint
CocInstall coc-git
CocInstall coc-fzf-preview
CocList extension
CocList extensions
CocCommand git.
CocCommand git.diffCached
CocCommand git.toggleGutters



### Bookmarks, Explorer
TODO:
~/.vim/plugin/tools-external.vim#/nnoremap%20<leader>bt%20.CocCommand

https://github.com/weirongxu/coc-explorer

## Syntax highlight
strangly the 'foldBraces' SyntaxID doesn't work:
~/.vim/colors/munsell-blue-molokai.vim#/hi.%20def%20link

## Debugging Coc
:CocCommand workspace.showOutput


customising the syntax/style
~/.vim/plugin/ui-floatWin.vim#/Todo.%20set%20purescript

### Go to definition
nmap <silent> ,gd :sp<CR><Plug>(coc-definition)
### Show documentation
nnoremap <silent> <leader>hK :call <SID>show_documentation()<CR>
- which is mostly type
- also works for Vim - docs (K is blocked currently by motion mappings)

# Hs/PsAPI search
gsd/D
- remove module prefix
- limit count?
- no tabu initiall?
how useful is switching the display with join/split module lines?
links to source and documentation
then there is this nice little floating window that HsAPI displays

### Type search & docs
TODO `spago search`

## Import identifier
PVimport <identifier> <module>
identifier is all I need, I think
<leader>hii :call PsImportIdentifier( HsCursorKeyword() )<cr>
<leader>hiI :call PsImportIdentifier( input( 'Import identifier: ', HsCursorKeyword()) )<cr>

# Psc-ide / purs ide / Language Server
"psc-ide-vim" and "vimmers PS" need "LanguageClient neovim"
these might launch a separate `purs ide` language server
it's needed for the 'fuzzy / completion' querry I use in 'gsd' PsAPI
which is originally based on `:Psearch length`

it somehow starts (and errors - with no issues later) when first querried?

## Server commands
Todo: how to issue commands like this:
" echo CocAction('runCommand', 'purescript.getAvailableModules')
" echo LanguageClient_workspace_executeCommand('purescript.restartPscIde', [])

works when started manually by
call PSCIDEstart(0)
call PSCIDEload(0, "")
  call PSCIDEtype()
  Papply
  messages
  Ptype
  Psearch count
  Psearch length
  Psearch abc
  echo PscAutoStart()
### Purs Language Server Documentation
Configuration of the language server now actually works - but has to be done
in CocConfig AND in vimmerps(!) config here: ~/.vim/plugin/tools-langClientHIE-completion.vim#/let%20g.vimmerps_config%20=
note there is also!  ~/.vim/plugged/LanguageClient-neovim/.vim/settings.json#/{


  https://github.com/purescript/documentation/blob/master/guides/psc-ide-FAQ.md#troubleshooting
  https://github.com/purescript/spago#build-and-run-my-project
  Purs ide configuration!:
  "https://github.com/nwolverson/vscode-ide-purescript/blob/110e9ac482708fd1bca7a71c95c600c3bcc9cda5/package.json#L79"
  .. this should mostly show the same:
  https://github.com/neovim/nvim-lspconfig/blob/60133c47e0fd82556d7ca092546ebfa8d047466e/README.md#purescriptls
  https://github.com/nwolverson/purescript-language-server/blob/master/src/LanguageServer/IdePurescript/Config.purs

  to see a language server log use :CocInfo then look at: ## Output channel: languageserver.purescript

## Vimmers PS
the Psearch results buffers shows a nicely syntax highlighted
while psc-ide Psearch results allow to navigate to the source code!

:Pimport also works nicer: it show an FZF menu and does not swallow import lines

## LanguageClient
these actually work but are not impressive UX:

" `leader lm` to open LanguageClient menu - e.g. to trigger a HIE codeAction
nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
" Documentation
map <Leader>lk :call LanguageClient#textDocument_hover()<CR>

## competion
<c-x-u> still works with some languageserver setting


    ### Deoplete
    does not seem to pick up language-server input - neighter from vimmer nor from psc-ide
    ~/.vim/plugin/tools-langClientHIE-completion.vim#/Backup%20old.%20using
    this mapping conflicts with
    ~/.vim/plugin/tools-langClientHIE-completion.vim#/inoremap%20<silent><expr>%20<TAB>

# TODOs
- integrate Psearch (vimmers) with HsAPI
- where do i actually need psc-ide? - it's a lot more potentailly useful code

- when is call PscAutostart needed? (it seems i just have to live with an intitial error on the first call after a vim restart)

- function stub mappings - currently not leader ht




this looks useful:
  systemlist("spago sources")


## Example projects
an extensive PS concur project - currently being worked at
~/Documents/PS/A/TestsA/concur-every-layout-test/src/Main.purs#/hello%20..%20forall

Elm UI in concur - npm start does (slow, non-hot) reloading
~/Documents/PS/A/Concur/purescript-concur-ui/src/Main.purs#/main%20=%20runWidgetInDom


## Get LanguageServer return json
~/.vim/plugged/psc-ide-vim/ftplugin/purescript_pscide.vim#/call%20append.'.',%20string.json_encode.a.resp...


quickfix / loclist compatible item
{'lnum': 257, 'col': 1, 'filename': '/Users/andreas.thoelke/Documents/PS/A/purescript-halogen-realworld/.spago/either/v4.1.1/src/Data/Either.purs', 'module': 'Data.Either                 ', 'text': 'fromLeft ∀ a b. Partial ⇒ Either a b → a'}

src/MyApp/Components/Counter.purs:6:1	Warning	[PureScript UnusedImport]   The import of Data.Field is redundant
src/MyApp/Components/Counter.purs:9:1	Warning	[PureScript UnusedImport]   The import of Effect is redundant

src/MyApp/Components/Counter.purs|12 col 1 warning| The import of module React.Basic.Hooks contains the following unused references: useEffect It could be replaced with: import React.Basic.Hooks (Component, component, useState') 
src/MyApp/Components/Counter.purs|10 col 1 warning| The import of module React.Basic.DOM contains the following unused references: div It could be replaced with: import React.Basic.DOM (button, div_, p_, text) 
src/MyApp/Components/Counter.purs|9 col 1 warning| The import of Effect is redundant 


stripAligningSpaces produces an error - so it's commented out
~/.vim/plugin/utils-align.vim#/call%20StripAligningSpaces.%20startLine,

nice example function
~/.vim/plugged/psc-ide-vim/ftplugin/purescript_pscide.vim#/call%20add.l.lines,%20"".






