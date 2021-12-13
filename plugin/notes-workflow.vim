" Utils And Docs: ----------

" TODO:
" show a type mismatch error in two lines in the code view:
" redirect command echo text to register: :redir @t,
" take the last line.
" src/Callback1.purs|222 col 24 error| 222:65:  Could not match type ( console ∷ CONSOLE , timeout ∷ TIMEOUT | t1 ) with type ( timeout ∷ TIMEOUT | eff0 ) while trying to match type Eff ( console ∷ CONSOLE , timeout ∷ TIMEOUT | t1 ) with type Eff ( timeout ∷ TIMEOUT | eff0 ) while checking that expression (apply ContT) (\k → (setTimeoutImpl mills) (k unit) ) has type ContT Unit (Eff ( timeout ∷ TIMEOUT | eff0 ) ) Unit in value declaration setTimeoutCont where eff0 is a rigid type variable t1 is an unknown type
" find 'while' 4 words 'v' find 'with' find 'while' again
" src/Callback1.purs|222 col 24 error| 222:65:  Could not match type ( console ∷ CONSOLE , timeout ∷ TIMEOUT | t1 ) with type ( timeout ∷ TIMEOUT | eff0 ) while trying to match type
" IS:
" Eff ( console ∷ CONSOLE , timeout ∷ TIMEOUT | t1 ) with type
" SHOULD BE:
" Eff ( timeout ∷ TIMEOUT | eff0 )
" while checking that expression (apply ContT) (\k → (setTimeoutImpl mills) (k unit) ) has type ContT Unit (Eff ( timeout ∷ TIMEOUT | eff0 ) ) Unit in value declaration setTimeoutCont where eff0 is a rigid type variable t1 is an unknown type

" ─   PURESCRIPT WORKFLOW                               ──
" "mkdir test1" && "cd test1" && "pulp init" && "nvim Main.purs"
" ":PursRepl" will start a pulp repl terminal session
" "gw" saving refeshes syntastic
" "dr" rebuilds syntastic and :r to pulp repl + imports
" "gei" works on commented expression, toplevel functions and just
" expression (until the end of the line)
" "gsd" and "gsh" for Pursuit
" use ":PursInstall maps" to "bower install --save purescript-maps" package
" "gas" to apply syntastic suggestions
" ":Pimport foldl" or "gip" to see an import menu
" use "gel" (it just runs the complete line on psci, (or gei) on an "import Control.Monad.Eff (Eff)" to import identifiers into psci
" use "gel" on ":kind Eff", will return # Control.Monad.Eff.Effect → Type → Type
" run "gel" on "import Control.Monad.Eff" (anywhere on the line), then to
" "gel" on ":kind Eff"
" -- :kind Const
" -- Type → Type → Type
" make sure to run do "gel" on "import Data.Const (Const(..))" first to
" import. TODO: command to run "gel" on all lines with "import .."
"
" Repl Eval Insert: ------------------------------------------------
" Evaluate a string in the Repl (purs or ghci) and insert the result of the evaluation
" gee → expr after -- (comment)
"       expr after =
"       selection
" gel → entire line
" gew → keyword
" (cursor-column is only significant for gew)
"
" --------------------------------------------------------------------------------
" "RUN IN NODE.JS - RUN A SIDE EFFECTING FUNCTION IN NODE"
" --------------------------------------------------------------------------------
" "pulp --watch run --main Learn3" will run the 'main' in Lear3 module in "node.js" with JS side-effects
" TODO: have a separate pulp run terminal process and paste output below main
" after each save.
" -- example:
" -- kima1 git:(master) ✗ pulp -w run -m Aff1
"
" --------------------------------------------------------------------------------
" "RUN IN BROWSER - LOAD PROJECT INTO BROWSER"
" --------------------------------------------------------------------------------
" 1. Create a "index.html" file in the project root using the html below.  ":e index.html"
" 2. make sure you are in the project root (run "dpr") then do "glt" to lanch a terminal
" 3. run "pulp -w build -to app.js" to watch-build an app.js bundle that will be loaded by index.html.
" 4. enable live reloading in chrome
" 5. you can run "PS.Main.myfunction(12)('secondarg')" in the Chrome console to call purescript function in the Main module.
" Eff functions can be called like "PS.Main.main()"
"
" Use this as "index.html":
" <html PUBLIC "-//W3C//DTD HTML 4.01//EN">
" <html>
"     <head>
"         <title>purescript</title>
"     </head>
"     <body>
"         <canvas id="canvas" width="300" height="300"></canvas>
"         <div id="aabb">aabb text</div>
"         <script src="app.js" type="text/javascript"></script>
"     </body>
" </html>
"
" Browserify is only needed when npn modules are used?
" "pulp --watch browserify --to dist/Main.js"
" TODO: have a separate --watch browserify process that can be killed or
"     : or, don't use --watch and just fire (via key-mapping e.g. "geb") and forget a browserify process that disposes itseft
"
" BUILD A SUB PROJECT/EXAMPLE IN A FOLDER:
" "pulp --watch build -I examples/counter/src --to examples/counter/app.js -m Counter.Main"
" TODO: attach callbacks to a visible terminal process
" TODO: past and then call a test-function, instead of reloading the whole
" Prob: can't redefine declarations! so could send this only once and would
" have to inc the index of the symbol next time
" file :paste
" … withError Nothing  err = Left err
" … withError (Just a) _   = Right a
" … ^D
" TODO: make a queue of caller/command ids: put e.g. "type-insert" into the queue when
" jobsend is issued. then in OnEv1 read (and delete) the last command id and
" use it to apply a specific parsing of the returned data.  TODO: errors in loclist should be wrapped, colored, unicoded

" TODO: What does Purscript project folder require so vim sets the working
" folder correctly? .DS_Store, .purs-repl, .git/??:

" TODO: use call PSCIDEListImports and send import statements to repl one by
" one to have the same symbols available in the repl as in the module.
"
" "PSCID" just run "pscid" in project root folder to get something similar to
" "ghcid" (see below)

" source "/Users/at/.vim/utils/termin1.vim"

" ─   HASKELL WORKFLOW                                  ──

" Creating a new project:
" cd into parent folder
" "stack new myproject simple", cd myproject
" "hpack-convert", "hpack --force" (as when the cabal file was manually changed Hpack (and vim) not update the cabel file)
" copy template excerpts into package.yaml from ~/Documents/Haskell/6/HsTrainingTypeClasses1/package.yaml#/library.
" "stack init" to create stack.yaml - this will be mostly empty/ only define a resolver. allows to install additional
" dependencies ~/Documents/Haskell/6/HsTrainingTypeClasses1/stack.yaml#/extra-deps.
" "git init" - important for project-root features. "leader og", add files and make initial commit
" "stack setup" - to download ghc version, packages, etc
" "stack build" - initial build of the project


" ─   Stack workflow                                     ■

" New project:
"   "stack new Test1"
" or for a simpler folder structure "stack new Test1 simple"
" setup/copy ghc version into the folder. may slowly download a 240md ghc version. But it should usually just copy this
" from what ghcup has downloaded/set for the OS.
""  "stack setup"
" now could do "stack ghci" / "stack repl" or build an executable: "stack bild", or install the app on the system: "stack install"
"
" If Intero shows a version conflict this can be added to the "stack.yaml":
"  "allow-newer: true"

" Ghc versions and ghcup:
" "ghc --version" shows the active global ghc version. Current "8.6.5"
" "ghcup list" lists the versions that can be switched to. Current:
  " ✗ ghc   8.6.2
  " ✔ ghc   8.6.3   recommended
  " ✗ ghc   8.6.4
  " ✔ ghc   8.6.5   latest
  "

" Install dependancy from Github (not hackage):
" 1. list in .cabal under build-depends: (as usual)
" 2. then in stack.yaml:
" extra-deps:
" - cabal-helper-0.7.3.0
" - github: mightybyte/map-syntax
"   commit: acebcf0a83ee639e1a0c49850b9c85821d53f621

" Global stack configuration: ~/.stack/config.yaml#/{allow-newer.%20true}

" stack install: copies executable to ~/.local/bin/
" stack uninstall is just to remove that executable: "rm ~/.local/bin/intero"
" there is also "ghc-pkg unregister <package>" - not sure when i would want to use this

" ─^  Stack workflow                                     ▲

" ─   Use Hpack to edit .cabal file                     ──
" Create a package.yaml file from a cabel file: "hpack-convert"
" editing package.yaml auto updates .cabal file using ~/.vim/utils/tools-intero.vim#/func.%20Hpack..
" In case the cabal file was edited manually use "hpack --force" in the project dir

" installed haskell-language-server:
" git clone https://github.com/haskell/haskell-language-server --recurse-submodules
" stack ./install.hs hls
" Copied executables to /Users/at/.local/bin:
" - ghcide
" - ghcide-bench
" - ghcide-test-preprocessor
" - haskell-language-server
" - haskell-language-server-wrapper
" # stack (for hls-8.8.3)
" Build completed in 15m25s
" "

" ─   old info Update HIE                                         ■
" Most recent update: 14-07-2019
" 1. Check the current version: hie --version
"    Current output is: Version 0.11.0.0, Git revision 58461a056abc6c23b01a4500bcef3095d2afe229 (dirty) (2932 commits) x86_6 4 ghc-8.6.5
" 2. Check if there is a new release (0.11.0.0 the current as of 07-2019) https://github.com/haskell/haskell-ide-engine/releases
" 3. Run git pull in /Users/at/Documents/Haskell/haskell-ide-engine/
" 4. Run stack ./install.hs hie-8.6.5
"    - this will take a long time (like 20 mins)

"    - stack ./install.hs help
"    - Will finish with the following output:
"        Copied executables to /Users/at/.local/bin:
"        - hie
"        - hie-wrapper
"        # stack (for stack-hie-8.6.5)
"        Build completed in 11m28s



" ─   Intero test workflow                               ■

"   <leader>io to open intero
"   <leader>ih to hide the intero window
"   <leader>il to load the module
"           dr to type-check the file
"           qq to show errors
"           ]e to jump to next error
"
"   tt or tw or tg to insert type
"   gei to insert return val → works also on commented lines
"   gew to just run a symbol
"   `,ti` to insert type hole to get the type of a do bind. `,tu` to undo
"   <leader>kk run it in the vim-terminal mode:
"                            use i to type and c-\ c-n to leave insert mode

" ─^  Intero test workflow                               ▲


" use this to format imports/code
" noremap <leader>ci :call StylishHaskell()<cr>
" important: you have to save bofore otherwise new code will be deleted and
" the can't be undoed!!
" also for new projects the ".stylish-haskell" file form "hello44" has to be
" copied to the project root. Important setting is grouping the language
" pragmas
" use ":browse Web.Spock" in Intero/Ghci to see all loaded vars
" use <leader>to and <leader>th to open and close "Tagbar" (a list of the the
" top-level functions) hit return to jump to a functions, see the focus light
" update in 500ms intervals.
" Find A Typesignature In The Project: run ":Find 'Value → Parser'" also just "//" on the visual selection to search in the same buffer
" Get the type of do-binds by producing a type error:
" nnoremap <leader>cco "tyiwolet (xb0 ∷ Int) = <esc>"tp^
" Use Hoogle In Vim: "gsd" "go search docs" or "gsh" "go seach hoogle" on visual selection (including type signatures!)
" or keyword to view the search results, then <c-]> on a specific line to see details.
" then "gsd" again on the keyword to go back to the overview.
" Details don't seem to work currently
" Import Haskell Identifiers Using Hoogle And Hsimport:
" 1. Use "gsd" ("go search docs") on a missing identifier or e.g. ":Hoogle replicateM"/ or "Hoogle (Applicative m) ⇒ Int → m a → m [a]"
" 2. In the hoogle list of available identifiers, go to the line/version you want to import and
" run <leader>ii to import the identifier (confirm the import section of your source file has added the identifier)
" See HoogleImportIdentifier in vimrc and /Users/at/.vim/plugged/vim-hoogle/plugin/hoogle.vim
" also note the "HOOGLE INCLUDE NEW LIBS:" comment in vimrc

" Ghc Warnings:
" let g:intero_ghci_options = '-Wall -fno-warn-name-shadowing -Wno-unused-matches -Wno-missing-signatures -Wno-type-defaults -Wno-unused-top-binds'
" https://downloads.haskell.org/~ghc/7.8.3/docs/html/users_guide/flag-reference.html

" GHCID:
" RELOAD WEBSERVER:
" e.g. reload any long running process with "ghcid" by calling a test-suite
" function
" 1. In the .cabal file change the "main-is:" to the file/module of the main
" function that ghcid should call:
" test-suite hello44-test
"   type:                exitcode-stdio-1.0
"   hs-source-dirs:      test
"   main-is:             src/Spock3.hs
" 2. Launch a terminal with "glt" + "ghcid -T :main"
" this now runs independant of Intero and compiles+reloads on save file,
" showing errors, ect.

" Just run an app based on a mobule file: xstack runghc helloworld.hs"

" Ale: -------------------------------------------------------------------------------
" shows the underlined warning (Data.Char)
" and the listing in the loclist
" navigation via ]w [w
" Updates live/no safe required
" Does not require intero running
" This will be hlint based + errors!? For Hlint config use :Hlint… command
"
" Neomake: ---------------------------------------------------------------------------
" shows the intero (ghci) warnings
" /requires intero to run. Requires a “dr” /reload to update
" Example screenshot in Evernote shows “-Wunused-imports warning
" Warnings show in quickfix-list: navigate via ]e [e
" Configured via intero_ghci_options:
" let g:intero_ghci_options = '-Wall -Wno-unused-matches -Wno-missing-signatures -Wno-type-defaults -Wno-unused-top-binds'
"
" <leader>oq opens all warnings? (how to exclude .vimrc warnings?)

" VIM WORKFLOW: ----------------------------------------------------------------------
" Vim Help: use "K" e.g. on this word: session_autoload
" use ":hg<space to expand HelpGrep> <searchterm>", "]q/[q[Q" to browse. it uses ":cwindow" to fill the quickfix list!
" Redirecting Messages: run "RedirMessagesTab messages"
" Temp Split Buffer: - "<c-w>N"
" Check Error Messages: quick error messages that occur on startup can be seen with ":messages" command, and then copied, etc.
" Question: how can I copy echoed text?  Open Url In Browser: "glb" "Go launch browser" on the visual selection of the URL
" Insert Mode Movement: Use Fn Key + "h,j,k,l" to navigate in insert mode (see Karabiner setup: )
" normal movement while in insert mode: use this prefix/leaderkeystroke: "<c-o>" then e.g. "$"/"0"/"b"
" Find Commands: use e.g. ":filter Intero command"
" Repeat Last Command: use "<leader>."
" Nerdtree: "go", Use "o" - "u", "C" to focus, "I" for hidden
" Find Free Mapping: e.g. use ":map <leader>i" to see all mappings that start like this
" run ":map <intended first keys>". ":unmap <first key><tab" .. shows what second
" key mappings need to be deleted to allow a fast/not delayed one key mapping
" Auto Format Code: e.g. json element: "=a}" ("format arount bracket"), document: "gg=G"

" Jump To Matching Bracket: simply "%"
" Previous Buffer: - "c-6"
" Insert File Context: - ":r <path-to-file>" to insert the content of a file!
" Command Suggestions: after "<Tab>" highlighted the first command suggestions, you can "<shift-tab>" to go back the the text you entered and type more chars to get better suggestions.
" Change Inner Big Word: - "abc" or (abc) can be changed nicely with "ciW"!
" Toggle Line Number And Wrap: - "yon", "yow"
" Repeat Last Command: - "<leader>." or just "@:"
" Find In Code Search: - "gsb" / "gsf" on code-word or visual selection to search buffers or project root files
"                        ":f " → ":Find " search from project root or ":fb " → ":Findb " to search in buffer
"                        This will open the file and seach/grepper side split in a Tab.
"                        Use "}" / "{" to jump files, then "n" to a specific occurence, then "o" to open the buffer in the left window
"                        now to continue collecting results, do "<c-w>n" "
"                        do "m<abcd>" at a found result, then go to your original tab/window and do "'<abcd>" to load the result here
"                        "cd (..)" the current working dir to search across a specific folder
"                        use ":cd %" in Dirvish buffer to first set working dir, then ":Find <searchstring>"
"                        Issue: currently only this seems to work: go into small git project, run "dpr", then "Find .."
" Read Grep Results Into Buffer: - "0r! grep -rn 'tab' ~/.vim/plugged", then "c-w F" to on a result/line to open win-split with that exact line!
" Grep Searches: (in zsh and vim!) - "grep -R 'abc' ." (works without quotes). recursive search from the current dir. "grep -F '<*>' **/*.hs" - '-F' = no regex
" Regex In Visual Search: - \v^[.+\] - finds text in angle brackets if at start of line. also see https://regexr.com/45174
" [will find] that text if this line is uncommented
" Search Regex Within Quotes: - "\v`[^`]*`" search and highlight strings within backtick quotes/ wrapped in backticks
" Match "ib" string or "n" sting in "ein": echo "ein" =~ '\v(ib|n)'
" Match Last Comma In Line: /.*\zs,/ - .*\zs\.   .*\zs,  \zs,
" Testing: Visually select a regex e.g. `[^`]*` an hit // to search for it. Then do q/ to edit search history. Even better: 
" Realtime Testing: Hit / then c-p to get back the prev search and edit in command line → seeing the highlightes matches update as you type
" Regex Html Tag: like "<a href=..> .. <\a>" - "/\v\<\/?\w+>" find "\<", "\/?" is optional, "\w+" any num of word chars, ">" end char
" Vimgrep Search Quickfix: - "vimgrep /\v`[^`]*`/g %" then "]q" and "[Q"
"                          - "vim[grep] <term> .vim/notes/*.md", "vim" is a shortcut for vimgrep
" Search In Vim Plugin Folder: - vim /conceal/g ~/.vim/plugged/**
" Quickfix Navigation: - "leader qq", "]q" with cursor in code, "c-n/p" and "go" with cursor in quickfix list
" Populate Arglist: - ":arg *.html" - or with subdirectories ":arg **/*.html", "argadd *.hs", then "argdo %s/abc/xyz/ge | update"
"                     or use Dirvish, then use `##` special symbol to search through these files "vimgrep test ##"
" Search In Files Range: - ":vim /<pattern>/g %", "vim /abc/g ##", "vim /abc/g `find . -type f`"(?) (test backtick expansion
" Use Last Search Pattern: - do "/abc<cr>" (a normal search), then "vim /<c-r>/g %" → "c-r" will expand to the last search
" Proposed Workflow: - 1. Test search expression with regular search, then 2. use the same expression with vimgrep

" Copy Paste File Path: "%p to put the name of the current file after the cursor. echo @% let @*=@% Also:  put =@%
" Jump To File Path: in split below "<c-w>f", in tab "<c-w>gf"
" View A Folder Env Variable: e.g. VIMRUNTIMEPATH Folder: - "i<c-r>=$VIM<tab><cr>" in buffer, then "<c-w>f" to open Nerdtree.  Or ":NERDTree $VIM<tabs>"

" Spell Checking And Dictionaries: Toggle with "yos" ":Spell"/ "SpellDE"/ "SpellEN" on. "set nospell" turns it off
" Navigate errors: "]s" - "[s", show suggestions: "z=", rather: "ea" to go to insert mode at the end of the word, then
" "c-x s" to open suggestion menu! TODO prevent proposing capitalized suggestions.
" add to dictionary: "zg" undo "zug"
" Go To Line: - ":123"! or "123gg" / "222G" to stay in normal mode

" Filenames And Paths: The folder (head): "echo fnamemodify( @%, ':h')" and the filename without extension "echo fnamemodify( @%, ':t:r')"
" Debugging: Prefix ":verbose " to a command, e.g. ":verb e .vim/utils/termin1.vim"
" What script has defined a mapping: ":verb map <leader>s"
" use "set verbose=1 to 15", start without plugins/vimrc: "nvim -u NONE",
" other vimrc: "nvim -u ~/.vim/bak/vimrc-22-09-2018.vim"
" Debug Vimrc Technique: put "finish" at the beginning of vimrc, restart, test, then move "finish" progressivly further down the vimrc/source more potentially problem causing setting
" Debug Test With Mini VIMRC One Plugin: - Start nvim loading vimrc from Gist!: nvim -Nu <(curl https://gist.githubusercontent.com/junegunn/6936bf79fedd3a079aeb1dd2f3c81ef5/raw/vimrc) "https://gist.githubusercontent.com/andreasthoelke/f223558ed5d89341c0f21c41868c92b0/raw/27028c93e046aa4a021fc97f8a59e60b774e0e38"
" Not Yet Read This: https://vimways.org/2018/debugging-your-vim-config/
" Logging Autocommands: - :set verbose=9 - set verbosefile=filename.txt - session_autosave_periodic - http://inlehmansterms.net/2014/10/31/debugging-vim/
" set verbosefile=~/.vim/logs/autocmds0220194.log
" set verbosefile=''
" Show Source Of Autocmds: - "verbose autocmd BufWritePost *"
" Debug a function: ":debug call FunctionName(arg)"
" Startup time: "nvim --startuptime ~/.vim/Logs/startup1.log"
" Performance Profile:
" profile start profile.log
" profile func *
" profile file *
"  At this point do slow actions
" profile pause
" noautocmd qall!
" Repeatable Map Setup: e.g. repeat <leader>abb by typing "."! Example RepeatVim Setup:
" nmap <Plug>Eins ieins<esc>:call repeat#set("\<Plug>Eins")<cr>
" nmap <leader>abb <Plug>Eins
" Note: <Plug> maps don't work with "noremap"!
" Registers: Default register: ("), Yank register: (0), Black hole register (_),
" Access - "Ctrl-r" in insert and command mode, ("[name]) in normal mode
" Read Only Registers: Last insert ".", last command ":"
" Copy Between Registers: - "let @+=@%" (Copy current filepath to clipboard)
" Replace a word: On source word: "yiw" - on target: ("_diw) - then "P"
" Append Lines: - ":y a", ":y A", "," (repeat)
" map <Plug>YankCollectAsRowsInRegC <esc>:let @C=" \n " . Get_visual_selection()<cr>"Cy map <leader>yc
" map <leader>yc <Plug>YankCollectAsRowsInRegC

" Insert Mode: - "c-x" - "c-w" - "c-g, c-k"
" Insert Variable Content: - "<c-r>=ab<cr>" (that simple) using: let ab = "eins" . "\n" . "zwei"
" Visual Selection Mode: - use "o" to switch to control the start of the selection (see ":help v_o")
" use ":<c-U>" to delete '<,'> . but then how to refer to the selection? TODO
" This '<,'> reads: beginning: '< - comma - '> end
" use "gv" to reactive the prev selection or a selection created with "m<", "m>"

" VIM Plug Plugins:
" Use "PlugDiff" to see what has been updated. Recreate a Plugin Snapshot, specifying commits: .vim/Plug-Snapshots/Snap-02-11-2018.vim
" Diff Compare Files: - With two files side by side in a vertical split, use ":set scrollbind" to lock scrolling

" Get String From Terminal: - ":echo system('ls')"

" Substitute Replace Text: - ":s/zwei/xx/g" -  Examp text: eins zwei drei vier zwei acht
" Substitute flags: "g" = all occurances, "e" = surpress/continue at errors
" Substitute With Expression: Instead to replacing the matched pattern with a string, use expression after "\="
let g:aab = 'XY'
" .+1s/aa/\=g:aab
" xx aa cc
" The "\%V" flag/atom makes the pattern effective only in the visual selection
" This will only replace aa in the next line when there was a vis-selection before → 'gv' will be used if there isn't any
" %s/\%Vaa/XX/g
" xx aa cc
" in a range of files: ":argdo %s//Practical/g"
" Prepolulate Command Map With Positioned Moved Cursor:
" Substitute Replace Selected String:
xnoremap <localleader>su y:%s/<C-r>"//g<Left><Left>
" Let assignment accum strings
let g:aab = 'A'
let g:aab .= 'B'
" echo g:aab
" Normal KeyCmds As Command: - "normal c3whi" runs c2w- "hi" on the current line
" Copy To T Dublicate Command: - "\t." to dublicate line below, ".,.+1t$" short: ",+t$", "t0" to linenum, uns "m" /move to move lines
" Range Linewise Commands: - "[range]delete, yank, put" (from register), "[range] copy, move" to target line, "[range]join" lines, "[range]normal <cmds>"

" Vim Pattern: For applying a function via an operator map, visual selection and command!
" ~/.vim/plugin/code-line-props.vim#/Vim%20Pattern.%20For

" Global  Run Ex Commands On Select Lines:- "/zwei<cr>" search, then ":g//" to just print (default cmd) the lines that contain a match. reusing the prev search patthern
" Global works on all line vs. the line-wise commands which it can be combined with.  "vglobal" or "g!" or "v" in[v]erts the selection "v/:" to show lines that have no ":" in it "Grep" = [g]lobal [re]gular expr [p]rint
"    Delete Lines: - "v/abc/d" only keep lines with abc in the file - use in Dirvish
"    Copy Lines: - "/abc<cr>" then "g//d" deletes all lines that don't have abc in it, "g/todo/t$" copy all lines with 'todo' to the end of the buffer
"                - "qaq" clear reg a, "g/todo/y A" to append-yank each line with 'todo' into the 'a' register! exact keys: "qaq" - ":g/todo/y A<cr>" - "tabe<cr" - "p" - "\sv"
"    Collect Selected Todo Lines Across Multiple Files Arglist In Register: - dirvish 'x', "argdo g/abc/y A" - "c-w N" "P"
" Globs  Work On Selection Of Files With Arglist: - run ":args src/**/*.hs" or start vim like this: "nvim **/*.hs". "globs" get replaced by the filenames they match. http://reasoniamhere.com/2014/01/11/outrageously-useful-tips-to-master-your-z-shell/
" use "arga[dd] %" or "argd[elete] %" to add/remote files from the list. Note that "arga % | next" makes the newly added file the currently selected
" "arglocal" to make a window local list. overwrite/init with "arglocal! newfiles" or "dax" dirvish
" Relate a tab with a task and a group of files https://blog.tommcdo.com/2014/03/manage-small-groups-of-related-files.html
" Explore And Come Back: - ":argu[ment]" goes back to the latest 'argument' file after you may have used "c-]" or quickfix search to explore related code
" Load Arglist From File: - "args `cat .toc`" using backtick expression
" Make a local copy
" nnoremap <Leader>al :arglocal<CR>
" Add the current buffer
" nnoremap <Leader>aa :argadd % <Bar> next<CR>
" Start a new arglist from the current file
" nnoremap <Leader>as :arglocal! %<CR>
" Delete the current index
" nnoremap <Leader>ad :<C-R>=argidx()+1<CR>argdelete<CR>
" Go to current arg file
" nnoremap <Leader>ac :argument<CR>
" TODO add this to the status line
function! StatuslineArglistIndicator()
    " return '%{argc()>0?("A[".repeat("-",argidx()).(expand("%")==argv(argidx())?"+":"~").repeat("-",argc()-argidx()-1)."]"):""}'
    return '%{argc()>0?("A[".repeat("-",argidx()).(expand("%")==argv(argidx())?"+":"~").repeat("-",argc()-argidx()-1)."]"):""}'
endfunction
" General Vim Notes: https://github.com/mhinz/vim-galore
" Variables: note ":pwd" vs ":echo $PWD". Option var can be "set bg=light" or "let &bg=light".
" Prefixes: [b]uffer, [w]indow, [t]ab, [l]=function, [a]rguments, [s]ourced file, [g]lobal, [v]im predefined. to view: "let v:"
" History: - "hist a/:/i" to view a history of cmds or inserts
" Paste Last Command: - ":%s/abc/cde/g" - "argdo <c-r>:" to paste the prev cmd/ apply it to the arglist
" Get Count To A Keymap: - use "v:count1". e.g. noremap <silent> <s-F8> :<c-u>exe 'norm 0f\|e' . v:count1 . 'W'<cr>
" Ignore Range: The CTRL-U is used to remove the range that Vim may insert.


" VIM WORKFLOW: ----------------------------------------------------------------------


" Shell WORKFLOW: {{{----------------------------------------------------------------------
" Suspending Background Jobs In Same Terminal: - "<c-z>" to suspend, in terminal: "fg" to bring it back. "jobs" to see all suspended jobs, "fg %2" to bring back second job, "kill %2" to kill it, "bg" to have it running in the background, "ps T" will show a "T" for stopped processes
" Man Pages: - `man ranger` will now use nvim to show the man page, thanks to in .zshrc: export MANPAGER="nvim -c 'set ft=man' -"
" VMan To Read ManPages As PDF: -- "vman ls" from terminal to view ls man page in vim.
" Man And Help Outline: - "gO" content outline
" Search Zsh Command History: - "c-r" then type e.g. "vim"
" Get Past Zsh Arguments: - example "ls somepath", then you might want "ls -a !!1" hit <tab> to get "ls -a somepath"
" Install Paths: -- "which zsh".
" Brew Installs: Brew installs here: "/usr/local/bin/" - actually here: "ls -la /usr/local/Cellar/" Use "ls -la /usr/local/bin/zs*" or "brew list", "brew info", "brew list | grep python"
" NeoVim Binary Path: - /usr/local/Cellar/neovim/0.3.3/bin
" Brew Cask: - "brew tap caskroom/versions" then `brew cask install iterm2-nightly`
" Brew Switch Version: - "brew list --versions nvim" - "brew switch neovim 0.3.1"

" Python install: https://opensource.com/article/19/5/python-3-default-mac#what-to-do
" https://realpython.com/intro-to-pyenv/
" "pyenv versions" -> "*" indicates to currently set version.
" "python -V" - the currently active version
" "pyenv which python" - shows the actuall install path.
" "pyenv global 3.8.0" - sets the global Python version!
" "python -m test" - runs

" Read User Shell From Directory Service: - "dscl . -read /Users/$USER UserShell"
" ITerm Windows: - "Arrangements" tab specifies init window arrangement, "Profiles" tab specifies how a new window is opened
" Quickly create and delete folders: "mkcd test2" then "rmcurdir"
"           Or just the classic way: "mkdir test3 && cd $_", "echo 'test' > test3", "rm *", "cd ..", "rmdir test3"
"           Note: - "&_" involves the argument to the previous command
" Create Hard File Link: - "link target.txt linkname.something" - linkname reads and write to the same data on disk
" Symlink To Folder: - "ln -s ~/Documents/temp ~/Documents/temp2"
" Move Reference Of File Into Current Dir: - "ln subfolder/another/myfile.c" - now has "myfile.c" in the current dir.
" Append To File: - "echo 'next line ..' >> linkname". NOTE: "echo 'i deleted all!' > linkname" deletes the previous content of the file!
" "echo 'zwei' >> test1 | cat", the appended "| cat" only echos the 'zwei', it's not reading the longer content of the 'test' file, as "cat test" does. So this is sort of surprising behavior.
" Search In Filenames: - "ls -la ~/ | grep vim"
" View Pipe STDOUT STDIN In Vim: - "grep 'vim' ~/.vimrc | nvim -" or "nvim <(ls -la)" (process substitution)
" Exmode Shell: - "gQ" to launch. used to run multiple commands. Breakout: "visual<cr>" / "vi"
" Get A List Of Filenames: - using "find"
"  I  ⋯  Haskell  4  abc2  tree
" .
" ├── LICENSE
" ├── Setup.hs
" ├── abc2.cabal
" ├── app
" │   └── Main.hs
" ├── src
" │   └── Lib.hs
" ├── stack.yaml
" └── test
"     └── Spec.hs
" 3 directories, 7 files
"  I  ⋯  Haskell  4  abc2  "find . -name '*.hs'"
" ./Setup.hs
" ./app/Main.hs
" ./test/Spec.hs
" ./.stack-work/dist/x86_64-osx/Cabal-1.24.2.0/build/autogen/Paths_abc2.hs
" ./src/Lib.hs
" Recursive Wildcard: - "ls /var/**.log" will show "/var/run/sntp.log/" and "/var/someotherfolder/file.log"
" Shell WORKFLOW: }}} ----------------------------------------------------------------------


" Tmux Workflow: -----------------------------------------------------------------------
" Lookup Manual: use "K" on a keyword in "~/.tmux.conf" to open manual entryj
" Run Tmux Commands: - "g!"

" Tmux Workflow: -----------------------------------------------------------------------

" TIP:  --------------------------------------------------------------------------
" NEOVIM REMOTE: start nvim like this: "NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
" "nvr -l thefilename.hs" from terminal mode to open file in other window.
" https://github.com/mhinz/neovim-remote
" parametrising a vim-command (examples):
"    echo "echo 'hi'" | nvr -c -
"    nvr -c "cd $(pwd) | pwd"
" --------------------------------------------------------------------------------


" VIMIUM WORKFLOW:
" "f" to open link,
" "<c-[>" to cancel
" "J" - "K" for prev - next tab
" "T" - Tab menu! "<c-j>"/ "<c-k" for up/down, "<c-[" to cancel, also use "^" for previous tab!
" "x" to close tab, "X" restore cloed tab!
" "vc" for carret mode, "ve" to select word, "y" to copy to clipboard
" "gi" to select text input (mode!), <shift><tab>, <tab> to select input field, "<c-[" to exit!
" "?" for help/command overview
" "H" - "L" navigate back/forward! instead of backspace!
" "ge" to edit URL, "gE" to open the changed URL in a new tab
" "t" for new tab, "yt" to dublicate tab.
" "<<" and ">>" to move tab!
" Move Tab To Other Window: - "yy", <c-arrowKey> to move to other space/window, "P" to open a new tab for the copied URL in the new window.
" Select Copy Paste Text: With source text area in view, hit "vc" and confirm 'carret mode' is active. use regular movements,
" hit "v" for visual selection ode, use "o" to switch to adapt the beginning of the selection. the
" "y" to copy. In VIM, do "*P to past the clipboard.
" Google Search Copied Text: just hit "P" to search in a new Tab!

" JSON Workflow: ----------------------------------------
" use "set foldmethod=syntax"
"
"
"
" JSON Workflow: ----------------------------------------



" Tests: ----------------------------



" Tests: ----------------------------



" DO THIS TO PUT A FILTERED ERROR LIST FROM NEOMAKE INTO A BUFFER:
" 1. create an empty buffer:
" :e temp2
" 2. prevent automatic line breaks:
" set textwidth?
" set textwidth=400
" 3. yank the filter code:
" filter(getqflist(), 'v:val.type == "w"')
" 4. Run and insert the result into the buffer:
" i<c-r>=<c-r>"<cr>
" insert mode, control + r, =, (then in the comman line:) (again!) control + r, ", return!

" {'lnum': 8, 'bufnr': 2, 'col': 1, 'valid': 1, 'vcol': 0, 'nr': -1, 'type': 'w', 'pattern': '', 'text': '[-Wunused-imports]'}
" {'lnum': 11, 'bufnr': 2, 'col': 1, 'valid': 1, 'vcol': 0, 'nr': -1, 'type': 'w', 'pattern': '', 'text': '[-Wunused-imports]'}
" {'lnum': 16, 'bufnr': 2, 'col': 1, 'valid': 1, 'vcol': 0, 'nr': -1, 'type': 'w', 'pattern': '', 'text': '[-Wunused-imports]'}

" convert markdown to simple html tags
" :%!/usr/local/bin/Markdown.pl --html4tags
" also shows how to run a perl script!




" Vim Anywhere:
command! CopyAndQuit :%y+ | :q!
nnoremap <leader>ccl :CopyAndQuit<cr>
" nnoremap <leader>ccl :%y+<cr>:q!<cr>

" command! SourceLine :normal yy:@"<cr>:echo 'Line sourced!'<cr>


" ----------------------------------------------------------------------------------



" ----------------------------------------------------------------------------------
" Tryouts:

" idea for insert mode mappings:
" go to just before the first non-blank text of the line
" inoremap II <Esc>I

" Set Syntax:
nnoremap <localleader>sh :set syntax=html<cr>
nnoremap <localleader>sj :set syntax=javascript<cr>
nnoremap <localleader>sv :set syntax=vim<cr>
nnoremap <localleader>sm :set syntax=markdown<cr>
nnoremap <localleader>sp :set syntax=purescript<cr>
nnoremap <localleader>sP :set syntax=purescript1<cr>
nnoremap <localleader>SP :set syntax=python<cr>
nnoremap <localleader>sd :set syntax=dirvish<cr>
" TODO Note: a different leader key for all "set" operations? "set syntax help" = "\sh"

" nnoremap <leader>sp :set syntax=purescript<cr>:call HaskellSyntaxAdditions()<cr>
" nnoremap <leader>sP :set syntax=purescript1<cr>:call HaskellSyntaxAdditions()<cr>

" demos:
abbrev mul Multiple<CR>lines




" Defining Commands And Utility Example Commands: -----------------------------------------------------
" Rename the current buffer
command! -nargs=1 -bang -complete=file RenameBuffer file <args>|w<bang>
" Replace a range with the contents of a file
command! -range -nargs=1 -complete=file Replace <line1>-pu_|<line1>,<line2>d|r <args>|<line1>d
" Count the number of lines in the range
command! -range -nargs=0 Lines  echo <line2> - <line1> + 1 "lines"
" Only works if that file is not open in a buffer
command! -bang -range -nargs=1 -complete=file SelectionToFile       <line1>,<line2>write<bang> <args>
command! -bang -range -nargs=1 -complete=file SelectionToFileAppend <line1>,<line2>write<bang> >> <args>

" Call a user function (example of <f-args>)
command! -nargs=* SomeTest1 call SomeTest1(<f-args>)
" Note: that function SomeTest1 only has one arg. Could use "..." in the arg or limit arg in the command to 1.
" Use normal mode in a command: "command! SourceLine :normal yy:@"<cr>:echo 'Line sourced!'<cr>
" Ex commands can be run from a command prefixing the ":" but not the "<cr>"
" command! CopyAndQuit :%y+ | :q!
" command! -nargs=1 Find  :Grepper -side -query <args>
" but alternatively you could/should? use exec:
" Chaining Commands:
command! -nargs=1 HelpGrep  exec ':helpgrep' <q-args> | exec ':cwindow'

" Expr Maps: right side is an expression, conditional ( <test-exp> ? <exp1> : <exp2> )
noremap <expr> <leader>sn demo4 == 'ein' ? ":echo 'ja'<cr>" : ":echo 'nein'<cr>"
let demo4 = 'eins'
" calling a function to get a condition:
" noremap <expr> <leader>aab Demo5() ? ":echo 'ja'<cr>" : ":echo 'nein'<cr>"
func! Demo5()
  return 0
endfunc
" Testing expressions:
" echo (3==4) ? 11 : 22
" echo (3==4 || 2==3) ? 11 : 22
" echo (3==3 && 2==2) ? 11 : 22

" Mappings: 
" https://vimways.org/2018/for-mappings-and-a-tutorial/
" https://vimways.org/2018/the-mapping-business/
" inoremap <expr> jk pumvisible() ? "<C-e>" : "<Esc>"
" onoremap <expr> il ':<C-u>norm! `['.strpart(getregtype(), 0, 1).'`]<cr>'
" Open vis-selected file path in preview window
xnoremap <silent> <Leader>gf y:pedit <C-r><C-r>"<cr>
" Insert from expression register. [02/Feb/19 17:00]
inoremap <C-g><C-t> [<C-r>=strftime("%d/%b/%y %H:%M")<cr>]
" Insert last command line command
cnoremap <C-x>_ <C-r>=split(histget('cmd', -1))[-1]<cr>
" Insert filename under the cursor
nnoremap <silent> <Leader>gf :pedit <C-r><C-f><cr>

" using counts in a map
" :map _x :<C-U>echo "the count is " . v:count<CR>
" nnoremap <silent> <Plug>(dirvish_up) :<C-U>exe 'Dirvish %:p'.repeat(':h',v:count1)<CR>
" echo repeat('hi', 0)
" echo v:count1
" echo v:count





" copy a folder: cp -a /source/. /dest/

" "<Plug>" is setting up a reference to a (public/API) function in a Plugin that can be called from a mapping like this:
" nmap _p <Plug>ScriptFunc

" Normal maps can call a command by prefixing ":" and appending "<cr>"
" nnoremap <leader>ccl :CopyAndQuit<cr>
" Expression mapping example: build a string and run it as an expression
" nnoremap <expr> GG ":echom " . screencol() . "\n"
" nnoremap <silent> GG :echom screencol()<CR>

" Insert mode mappings: can work with <c-o>, which pauses insert-mode for one char/command
" imap <c-y> <c-o>:echo "hi"<cr><c-o>:echo "again"<cr>
" List of what control-char do: https://www.reddit.com/r/vim/comments/4w0lib/do_you_use_insert_mode_keybindings/

" Get time in command mode: "echo now" → "echo strftime('%X')"
" cabbrev now strftime('%X')

" Defining Commands And Utility Example Commands: -----------------------------------------------------


" Running Commands: ------------------------------------------------------------
" Calling a command with args. Is there no nicer way?
fun! SomeTest2( ar1 )
  exec "Find " shellescape( a:ar1 )
endfun
" call SomeTest2( 'replicateM' )
" call SomeTest2( 'Terminal' )

" Run Terminal Commands:
" run any command with ':!{cmd}' or use <C-z> to suspend nvim, then run 'fg'
" to bring nvim back to the foreground
" Uncomment line then run "<leader>sl"
" exec "!osascript -e 'tell application \"Finder\" to make new Finder window'"
" exec '!osascript' '-e' shellescape( 'tell application "Finder" to make new Finder window' )
" silent exec "!osascript -e 'tell application \"Finder\" to make new Finder window'"
" Issue: silent does produce artefacts on the lower bar of vim. this can be avoided with ":redraw!"
" Discard Return Dialog: example: "silent !echo Hello" then use ":redraw!" to refresh screen
" This closed (but flashes) the return message:
command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'
" example: "Silent ps" instead of ":!ps"
" Using Vim Dispatch:
" Dispatch! osascript -e 'tell application "Finder" to make new Finder window'
" Start! osascript -e 'tell application "Finder" to make new Finder window'
func! DemoOpenFinderWindow ()
  silent exec "!osascript -e 'tell application \"Finder\" to make new Finder window'" | redraw!
  Dispatch! osascript -e 'tell application "Finder" to make new Finder window'
  " It's sort of surprising this this works, you usually need "exec" to run commands
endfunc
" call DemoOpenFinderWindow()
" Todo: jobsend example!

" Timers Timeouts Intervals:
" call timer_start(1000, 'TestHandler', {'repeat': 3})
let g:cnt = 0
func! TestHandler( timer )
  let g:cnt = g:cnt + 1
  if g:cnt > 1
    call timer_stop( a:timer )
    echo 'done'
  endif
  echo ('yes ' . g:cnt)
endfunc

" Vim Vars In Command Line:
" "!echo This-is-the-dir:% >> ccdd" use the dirvish path in the echo >> command/ write it to a file

" Set Searchword: - "let @/='test'"
" Put Command Uses: - 'put a/t/"/%' registers, "put =g:test2/&filetype" variables, (always linewise)
" Insert Text Into Buffer: 1. "put ='Some Text:'"
"                          2. "exe 'normal iSome Text:'"
"                          3. "r!echo 'Some Text:'"
"                          4. "call append( line('.'), 'Some Text:'"
" New Vs Split: - "new", "vnew", "tabnew" (and "tabe") create an empty new buffer even if no filename is provided
"               - "split", "vs[plit]" behave the same if a new file name is provided
" Ranges Of Lines:
" ".,.+5s/er/XXXX/g" Replace in the following 5 lines. A range to the "s" command is ","-separeted tuple of (interpreted) Ints/linenumbers
" ".,.+5write temp.txt" Write the following 5 lines to a file
" ".,$g/vim" show/select all following lines that contain "vim"
" "'a,'bs/in/XXXX" substitute from marker 'a' to marker 'b'
" ".,.+2move $" move the following lines to the end of the file. "'<,'>copy 0" copy visual selection to before the fist line
" Visual Selection:
" Note the "\%V" flag/atom makes the pattern effective only in the visual selection
" test aabb cd ef xyz
" test gh aabb xf xaabb
" %s/\%Vaabb/XX/g
" Example Collecting Lines:
" "'<,'>! >> .vim/notes/acd2.md | cat" - creates a new file if needed, respects linebreaks, updates/write also to open buffer, however it only works on a line, not a selection basis.
" Same as "'<,'>!cat >> .vim/notes/acd2.md | cat" note the echo-like behavior of 'cat'
" Put String Into Open File: - ":silent !echo 'test' >> tt.txt"
" Using Filepath In Shell: - ":silent !echo %-evenmore >> Documents/temp/aa/ccdd"
" Using Registers And Variables In Shell: - ":exe 'silent !echo' @a '>>' 'ccdd'",
" "exe 'silent !echo' g:colors_name '>>' 'ccdd'" - "exe" basically runs a string. args are integreted as vim
" expressions, converted to a string and then concatinated (interposed with <space>) with the overall string/command
" Backtick Expressions: - ":vnew `=tempname()`"
" Run Vim Function Per Selected Line: '<,'>call echom(getline('.'))
" Loop Map Over Range Of Selected Lines: - "'<,'>call SomeTest1( getline('.'))" - this sort of moves to each selected line, so every command that works on a current line will be run n-line times on each line
" Delete A Range Of Files: - "'<,'>call delete(getline('.'))"

" Vim Pattern: For applying a function via an operator map, visual selection and command!
" ~/.vim/plugin/code-line-props.vim#/Vim%20Pattern.%20For


" echo join( getline(".", line(".") + 3), "\n" )
" Piping Text Selection To Shell Command: Select the following lines:
" B
" C
" A
" then run ":'<,'>!sort | pbcopy | ps". The sorted lines are put into the clipboard, the selected text is replaced
" This has a similar effect: ":'<,'>!call DemoPipeRange()"
" Note how "a:firstline/lastline" are enabled by adding the "range" arg
function! DemoPipeRange() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")).'| sort | pbcopy | ps')
endfunction
" Also note the usage of terminal "echo" cmd to start a pipe and the vim-shell "echo" that uses a concatinated string from shellescaped args as it's arg.
" Similarly "-range" for commands allows to use "<line1/2>" for start end linenums on the right side:
command! -range=% -nargs=0 DemoPipeRange1 :<line1>,<line2>call DemoPipeRange()

" Running Commands: ------------------------------------------------------------





" Testfunctions: -------------------------------------------------------------

" Example function moving cursor
function! GoToSelErrorLine()
  call cursor( getqflist()[0].lnum, getqflist()[0].col)
endfunction
" same things can be done with ":cr"!

" Autocommands Events: ----------------------------
" Give a preview window local settings on WinEnter:
" Note: the use of "if" in one line!
" augroup PreviewAutocmds
"   autocmd!
"   autocmd WinEnter * if &previewwindow | setlocal nonumber | endif
" augroup END
" autocmd! WinEnter *.vim :echo strftime('%X') . " xx " . @%
" autocmd! FocusGained * :echo "focus gained!"
" Bufferlocal Autocmd: needs to be attached when a buffer is created, e.g. via a map
" autocmd! WinEnter <buffer> echom 'Buffer-local event from buffer: ' . bufname('%')
" Dynamically Create And Revoke AutoCmds: 
" function! markdown_preview#start() abort
"   " Set up an autocommand that passes the buffer text into the plugin
"   augroup plugin-mdprev-watcher
"     autocmd!
"     execute 'autocmd' TextChanged "<buffer> call rpcnotify(0, 'markdown-preview:update', join(getline(1, '$'), \"\\n\"))"
"     autocmd BufUnload,BufHidden <buffer> call markdown_preview#stop()
"   augroup END
"   call rpcnotify(0, 'markdown-preview:update', join(getline(1, '$'), "\n"))
" endfunction
" function! markdown_preview#stop() abort
"   silent! autocmd! plugin-mdprev-watcher
"   call rpcnotify(0, 'markdown-preview:update', '')
" endfunction

" Highlight Specific Strings Patterns:
" highlight MyGroup guibg=green
" hi! MyGroup guifg=yellow
" hi! MyGroup guifg=red
" hi! clear MyGroup
" let m = matchadd("MyGroup", "WinEnter")
" call matchdelete(m)
" call clearmatches()
" [B] Some filename
" (B) Some {filename} and more

" highlight MDCode guifg=red
" autocmd BufEnter,WinEnter *.vim call matchadd('MDCode', '`[^`]*`', -1)
" Highlight Text In Quotes: let m = matchadd("MDCode", '`(.*?)`') - https://regexr.com/43o7i
" TODO: 1. The highlight should be within the quotes but not including the quotes
"       2. Could copy the conceil setting with the .MD syntax?!

" Codeformatting Examples: -----------------------------------------------------
" from: https://github.com/sdothum/dotfiles/blob/master/vim/.vim/config/buffer.vim
" TODO there must be a script the facilites this ..

