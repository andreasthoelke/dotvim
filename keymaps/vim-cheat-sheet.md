# Keymaps

## Color & Theme
,,cl                  - Light colorscheme + Claude light theme
,,cd                  - Dark colorscheme + Claude dark theme
<leader><leader>ts/S  - Show highlight colors
<leader><leader>ti    - Inspect cursor position

## AI & Assistants

### AI Chats list & search

<leader><leader>oc    - AI Chats list view (by date)
<leader>sfc           - AI Chats topics ~/.config/nvim/plugin/config/telescope.vim‖/nnoremapˍ<leader>sfcˍ<cmd>
<leader>sfC           - full text

                        NOTE that Codex chats contain:
                            To continue this session, run codex resume 019a081f-c340-7cc2-bc9f-3f9ee53cac17
                        So one could search for "codex resume"

<leader>sfa           - avanteHistory (deprecate)

### AI Command Selection
<c-g><c-g>o          - Select AI command (claude, codex, aider, etc.)

### Magenta
@ commands:
~/Documents/Proj/k_mindgraph/h_mcp/d_magenta/README.md‖/Automaticallyˍincludesˍthe

#### NEP edit prediction
<c-g><c-l>l           - Next edit predict
<c-g><c-l>g           - Next edit accept
<c-g><c-l>c           - Next edit cancel
<c-g><c-l>d           - Next edit debug


### Claude Code
<c-v><c-j>           - insert new line (not running the prompt yet) NOTE this is default terminal behavior!
\<cr>                - backslash + return is an alternative to the above. Also default behavior!
<c-g>V               - ClaudeCodeOpen agents.lua / codex cli (per tab!)
<c-g><c-v>           - reopen agents.lua (per tab!)
<c-g>S               - Claude in horizontal split
<c-g><c-j>           - Send parrot buffer user message to Claude
<c-g><c-s>           - Save Claude buffer to chat history
<c-g>b               - Send buffer to Claude
<c-g>p               - Send paragraph to Claude
<leader><c-g>p       - Send paragraph to Claude with markup (fallback to parrot and magenta)
<c-g>'               - Send clipboard to Claude
<leader><c-g>'       - Send clipboard to Claude with markup
<c-g>o               - Send linewise selection to Claude (operator)
<leader><c-g>o       - Send linewise selection to Claude with markup
<c-g>i               - Send inner selection to Claude (operator)
<leader><c-g>i       - Send inner selection to Claude with markup
<c-g><cr>            - Run current text in Claude terminal
<c-g>C               - Clear Claude text field
<c-g>mc              - Make commit with Claude
<c-g>,c              - Clear Claude chat
(v) <c-g>p           - Send visual selection to Claude
(v) <leader><c-g>p   - Send visual selection to Claude with markup

### Agents Worktrees
Run Claude and Codex agents in parallel git worktrees with automatic sync.
~/.config/nvim/lua/agents-worktrees.lua
~/.config/nvim/plugin/config/ai-maps.lua‖*Worktreeˍagent

#### Sending Text to Worktree Agents
<c-g>wp              - Send paragraph to worktree agents (creates tabs on first run, reuses after)
(v) <c-g>wp          - Send visual selection to worktree agents
<c-g>wo              - Send linewise selection to worktree agents (operator)
<c-g>w'              - Send clipboard to worktree agents
<c-g>wi              - Send inner selection to worktree agents (operator)

#### Vim Commands
:AgentsWorktreesRun <prompt>         - Run both Claude and Codex with prompt
:AgentsWorktreesRunClaude <prompt>   - Run only Claude worktree agent
:AgentsWorktreesRunCodex <prompt>    - Run only Codex worktree agent

:AgentsWorktreesResetAll             - Reset both worktrees to main (with backup tag)
:AgentsWorktreesResetClaude          - Reset Claude worktree to main (with backup)
:AgentsWorktreesResetCodex           - Reset Codex worktree to main (with backup)

:AgentsWorktreesSetupClaude          - Setup Claude worktree (create/rebase)
:AgentsWorktreesSetupCodex           - Setup Codex worktree (create/rebase)

#### Directory Navigation
<leader>cdC          - Change tab directory to claude worktree (tcd to ../project_claude)
<leader>cdO          - Change tab directory to codex worktree (tcd to ../project_codex)

#### How It Works
- First <c-g>wp: Creates new tabs with agents, rebases worktrees to main
- Subsequent <c-g>wp: Sends prompts to existing agents (no tab switching)
- Auto-commits WIP changes before rebasing on fresh starts
- Backup tags created before reset (backup-YYYYMMDD-HHMMSS)

### Parrot
<c-g><leader>p       - PrtProvider
<c-g><leader>m       - PrtModel
<c-g>v               - PrtChatNew
<c-g>s               - PrtChatNew split
<leader><c-g>p       - Send paragraph to Claude with markup (fallback to parrot and magenta)
<c-g><leader>C       - PrtChatWithAllBuffers
(v) <c-g>v           - PrtChatNew with context
(v) <c-g>s           - PrtChatNew split with context
(v) <c-g><leader>C   - PrtChatWithAllBuffers with context
(v) <c-g>r           - PrtRewrite
(v) <c-g>a           - PrtAppend
(v) <c-g><leader>r   - PrtRewriteFullContext
(v) <c-g><leader>a   - PrtAppendFullContext

## LLM Visual Mode
~/.config/nvim/plugin/config/ai-maps.lua‖*LLMˍVisualˍSelectionˍIntegration
~/.config/nvim/plugin/utils/ai.lua

### Primary Bindings
- **`<c-g>L`** - Open LLM prompt menu (capital L to avoid conflict with Magenta's `<c-g>l`)
- **`<c-g>T`** - Quick topic summary (single key for your main use case)

### Quick Commands (`<c-g>l` + letter)
- **`<c-g>lt`** - Topic summary
- **`<c-g>le`** - Explain code
- **`<c-g>li`** - Suggest improvements
- **`<c-g>lb`** - Find bugs
- **`<c-g>ld`** - Generate documentation

### Custom Prompts (`<leader><c-g>l`)
- **`<leader><c-g>l`** - Custom prompt (interactive)
- **`<leader><c-g>lg`** - Send to Gemini
- **`<leader><c-g>lc`** - Send to Claude


### Avante
<c-g><leader>v       - AvanteChatNew
<c-g><leader>M       - AvanteModel
<c-g><leader>h       - AvanteHistory
<c-g><leader>H       - CodeCompanionHistory
<c-g>l               - AvanteFocus
<c-g>c               - AvanteStop
<c-g><leader>c       - AvanteClear
<c-g><leader>P       - AvanteSwitchProvider (with autocomplete)

### CodeCompanion
<c-g><leader>V       - CodeCompanion chat (vertical layout)
<c-g><leader>C       - CodeCompanion chat (horizontal layout)



### MCP
<c-g>h               - MCPHub

## LSP & Diagnostics

### LSP Navigation
gel                  - LSP document symbols (Telescope)
geL                  - LSP dynamic workspace symbols (Telescope)
<leader>fr           - LSP references (cursor theme)
gd                   - Go to definition
gi                   - Go to implementation
<space>D             - Type definition
<space>rn            - Rename symbol

### Diagnostics
]d                   - Next diagnostic
[d                   - Previous diagnostic
<space>e             - Open diagnostic float
<space>q             - Set diagnostic loclist
ged                  - Show diagnostics (buffer trouble)
geD                  - Show diagnostics (workspace trouble)
<leader>ged          - Show diagnostics (workspace telescope)
ge]/[                - Next/prev error
<leader>lts          - Toggle LSP diagnostic signs

### Code Actions
<leader>cA           - LSP code action (generic)
<leader>ca           - LSP import action (lspimport)

### LSP Hover & Help
gek                  - LSP hover
gej                  - LSP signature help

## Git Operations

### Git Status & Log
<leader>gd           - Git commits viewer (5 commits, shows file list with M/A/D/R100 status)
<leader>gD           - Git file history viewer (5 commits for current file with git log --follow)
<leader>ogl          - Git commits picker (telescope)
<leader>ogL          - Git commits viewer (40 commits)
<leader>ogS          - Git status (telescope)
<leader><leader>gb   - Telescope git_branches
<leader><leader>og   - FzfGFiles?
<leader><leader>oG   - FzfGFiles?

### Git File History
<leader><leader>ogl  - Vim-Diffview DiffviewFileHistory (current file)
<leader><leader>ogL  - DiffviewFileHistory (all files, shows involved files per commit)

### Git worktrees
See: ### Agents Worktrees (AI & Assistants section) for full worktree agent workflow
<leader>cdC          - Change tab directory to claude worktree (tcd to ../project_claude)
<leader>cdO          - Change tab directory to codex worktree (tcd to ../project_codex)
<leader>cdM          - Change tab directory back to main branch/project root

### Git Diff-view
,gd                  - Toggle MiniDiff overlay
<leader><leader>gd   - Compare two files from consecutive lines (using git diff --no-index)
                       Place cursor on first file path, press map, uses current + next line
<localleader>gdd     - Compare two git refs from consecutive lines (branches/commits/HEAD~1/tags)
                       Place cursor on first ref, press map, uses current + next line
                       Shows file list with status (M/A/D/R100) and line counts
                       Press 'p' on file to see diff for that file
                       Press 'p' on header to see all changes between refs
                       Falls back to last valid refs if empty/invalid lines
                       Example refs: main, feature-branch, HEAD~2, abc123f, v1.0.0
<localleader>gdc     - Compare current branch with agent/claude
                       In main: shows main..agent/claude
                       In _claude worktree: shows agent/claude..agent/claude (no diff)
                       In _codex worktree: shows agent/codex..agent/claude
<localleader>gdo     - Compare current branch with agent/codex
                       In main: shows main..agent/codex
                       In _claude worktree: shows agent/claude..agent/codex
                       In _codex worktree: shows agent/codex..agent/codex (no diff)
<localleader>gdm     - Compare current branch with main
                       In main: shows main..main (no diff)
                       In _claude worktree: shows agent/claude..main
                       In _codex worktree: shows agent/codex..main

### Gitsigns & MiniDiff
<leader>gh           - change_base ~1
<leader>gH           - change_base (HEAD)
<leader>g1           - change_base ~1
<leader>g2           - change_base ~2
<leader>g3           - change_base ~3
<leader>g4           - change_base ~4
<leader>g5           - change_base ~5

### File History Stepping (consecutive commits)
<leader>g[           - Step back in file change history (older, auto-jumps to first change)
<leader>g]           - Step forward in file change history (newer, auto-jumps to first change)
<leader>g0           - Reset to HEAD comparison
]h/[h                - Jump to next/previous hunk (change)
]H/[H                - Jump to last/first hunk
Note: Shows diffs between consecutive commits where file changed, not accumulated from HEAD

MiniDiffAgainst HEAD~2
MiniDiffAgainst HEAD

## Search Patterns

### Telescope Search Maps
,sA                  - Search all code (global project)
,ss                  - Search Scala symbols (current)
,sS                  - Search Scala symbols (global)
,st                  - Search tags/comments (current)
,sT                  - Search tags/comments (global)
,sh                  - Search headers (current)
,sH                  - Search headers (global)
,sg                  - Search signatures (current)
,sG                  - Search signatures (global)
,si                  - Search signatures with collections
,sz                  - Search signatures with ZIO

### Code Symbol Search
ge;                  - Search symbols in current repo
ge:                  - Search symbols in external repos
gsr                  - Search cursor word globally
gst                  - AST grep search

### Vim-specific Search
,svs                 - Search vim symbols
,svm                 - Search vim keymaps
,svv                 - Search all vim code
,svh                 - Search vim headers

### Help Search
<leader>gsH          - Search help tags (cursor word)
(v) <leader>gsh      - Search help tags (visual selection)

## File Operations

### File Finders
gp                   - Telescope oldfiles
gP                   - Telescope frecency
g,p                  - Telescope frecency (CWD)
g,P                  - Telescope frecency (LSP)
go                   - Telescope find_files (hidden=true)
gb                   - Telescope buffers
,gb                  - Telescope file_browser

### Neo-tree
<leader>oa           - Neo-tree toggle
<leader>oo           - Neo-tree float
<leader>gs           - Neo-tree reveal current file

### Directory Operations
gsd                  - Directory/folder names
gsD                  - File browser
<leader>sff          - Find directory (shows dirvish)
<leader>sfb          - Browse Proj folder then search

## Navigation

### Window Management
<c-w>L/H/K/J         - Jump to rightmost/leftmost/top/bottom window
<leader><c-w>L/H/K/J - Push window to edge position
<c-w>S l/h/k/j       - Copy to adjacent window
<c-w>x l/h/k/j       - Swap with adjacent window
<c-w>d lhkj          - Close adjacent window
<c-w>dd              - Close other windows in tab

### Buffer Navigation
]a/[a                - Next/prev harpoon file
,1/2/3               - Jump to harpoon index file
<leader>db           - Delete current buffer

### Text Objects & Motions
,j/k                 - Hop to line forward/back
,f/F                 - Hop to character forward/back
J/K                  - Same column motion
]M                   - Treesitter next end
]r/[r                - Go to return statement
]b                   - End of JS block

## Editing

### Text Manipulation
<leader><leader>c<leader> - Clear trailing spaces
VSi                  - Insert surround (supports asymmetric)
VS)}}                - Surround with brackets/braces
VST                  - Wrap with triple backticks
VSD                  - Wrap with triple double quotes
VSS                  - Wrap with triple single quotes

### Alignment
,aJ/j                - Align with regex presets
,>                   - Push text to the right

### Paste Operations
p/P                  - Paste and return cursor to original position
<leader>"            - Show registers (Telescope)
"0p                  - Paste from previous yank register

## Specialized Tools

### Zen Mode
<leader>zm           - ZenMode
<leader>of           - Outline (hovers ZenMode!)
<leader>oo           - Neotree (hovers ZenMode!)
<leader>zn           - TZNarrow (visual selection only)

### Marks & Bookmarks
<leader>om           - Open Markbar
m[A-Z,a-z]          - Create global/local mark
'[A-z]               - Go to mark
M[A-z]               - Delete mark
<leader>bb           - Toggle bookmark
<leader>bs           - Show all bookmarks

### Session Management
<leader>ls           - Possession load (cwd)
<leader>lS           - Possession save (cwd)
<leader><leader>ls   - Possession select dialog

### External Tools
glc                  - Open URL/path in Chromium
glv                  - View in MPV player
<leader>Os           - System open (Finder/default app)
<leader>Oc           - Open in VS Code

### Database Tools
<leader><leader>du   - Toggle DBUI panel
<leader><leader>df   - Link SQL buffer to database
gej                  - Evaluate paragraph (SQL/EdgeDB)

## Terminal & REPL
<leader>ro           - Open IPython REPL
gep                  - Paste paragraph to REPL
(v) gep              - Paste visual selection to REPL
gwj                  - Run terminal command (float)
gwJ                  - Run paragraph as terminal command

<c-v><c-j>           - insert new line (not running the prompt yet) NOTE this is default terminal behavior!
\<cr>                - backslash + return is an alternative to the above. Also default behavior!

### TypeScript/JavaScript (Buffer-specific)
<leader>gen          - Run current buffer with npx tsx


## Startup & Sessions
ges                  - Open quick menu
<leader>st/T         - Startify (deprecated)
e                    - Close startify, edit new buffer (in startify)

## Configuration & Help
:PlugUpdate          - Update specific plugin
:PlugPreUpdateInfos  - Pre-update plugin info
<leader>se           - Execute vim/lua line
gei                  - Print vim/lua line
gej                  - Print vim/lua paragraph

## Quick Reference Links
~/.config/nvim/colors/munsell-blue-molokai_light_1.lua - Color configuration
~/.config/nvim/plugin/config/ai-maps.lua - AI keymaps
~/.config/nvim/plugin/config/maps.lua - General keymaps
~/.config/README.md - Main configuration guide




# colors
<leader><leader>ts/S - show highlight colors
<leader><leader>ti   - Inspect cursor pos

~/.config/nvim/colors/munsell-blue-molokai_light_1.lua‖*NewˍColors


# .config folder on github
https://github.com/andreasthoelke/.config
~/.config/README.md‖/#ˍ.config
~/.config

# macos apps start process via hammerspoon
<c-l>t/i/v        - starts alacritty big/small or neovide in Proj folder
~/.config/hammerspoon/init.lua‖*StartˍMacˍApps
gsp + j/k + w     - set cwd to project
<leader>ls        - load vim session via possession for that project dir.

## nvim-node / bunvim socket --listen flag
### update 2025-07-23!
this actually conflicts with starting 2 + instances of 'nvim'! since the port can only be used once!
~/.config/hammerspoon/init.lua‖/localˍfunctionˍnvim()
      "--command", "/bin/zsh", "-c", "-l", "cd ~/Documents/Proj && nvim --listen /tmp/bunvim.nvim.socket"


update 2025-07:
i'm now using "nvim --listen /tmp/nvim"
to start nvim with hammerspoon or alacritty.
use '<leader>se' on the next line:
echo serverlist()
note that ~/.config/mcp/neovim.json has this in its settings

When starting alacritty normally via Alfred i use this 'nvim' alias: ~/.config/zsh/.zshrc‖/aliasˍnvim='nvimˍ--listenˍ
~/.config/alacritty/alacritty.yml‖/shell:
In the hammerspoon startup map I now have this "--command", "/bin/zsh", "-c", "-l", "cd ~/Documents/Proj && nvim --listen /tmp/bunvim.nvim.socket"
here: ~/.config/hammerspoon/init.lua‖/localˍfunctionˍnvim()

# S_Menu quick info for repl setup
e.g. see the python env, sqlite db
ges     - open quick menu

# learn: open filepath in a split window
<leader>cp    - copy file path in ntree source node or buffer
<leader>ct    - the same but copy/yank a local path
<c-w>,u/v     - in target window

ExampleLog.md could be linked into Documents/Notes? a separate folder so can search only examples or in all notes

# learn: explore repo maps
gsl/<leader> - search lsp symbols
ge;/:        - search symbol patterns
<leader>fs   - find (dynamic workspace) symbols. 
               e.g. "initModel" can find all symbols with this name finds 14 results while gsg would find 34.

# vim Plug
cautiously update plugins selectively, e.g.:
PlugUpdate neo-tree.nvim
PlugPreUpdateInfos <autocomplete pluginname>

# Google Docs markdown Sync using gdoc script
leader><leader>dp   - push markdown to gdocs
leader><leader>df   - fetch markdown from gdocs (relates to the gdocs id in md frontformatter!)
leader><leader>dl   - list recent Google Docs

gdoc --help
gdoc pull 17TkoGbGHX3iyckiUKkly5GvfzIkc9Eb-F6UeTYDT9BQ mvd/agentic-workbench/notes/temp.md


# jupyter notebook / google colab navigation
<c-m>y    - copy cell
<c-v>     - past cell
<c-m>d    - delete cell
<c-m>i    - insert / create a new cell below.

# yaml
<leader>on     - langServer browser explorer
glj/y          - turn buffer into json and show in split ~/.config/nvim/plugin/ftype/yaml.lua‖/functionˍViewYamlAsJson()
:YAML..        - commands from https://github.com/cuducos/yaml.nvim


# AI MAPS / parrot claude-code code-companion

<c-g>h       - mcp hub
<c-g>l V     - code companion chat
               In buffer keymaps: ~/.config/nvim/plugin/config/codecompanion.lua‖/keymapsˍ=ˍ{
Maps:
~/.config/nvim/plugin/config/ai-maps.lua
~/.config/nvim/plugin/config/avante.lua‖*ˍˍˍKeymaps
Claude code
~/.config/nvim/plugin/config/ai-maps.lua‖/CLEARˍtextˍfieldˍbuffer

<leader>oc      - chat history
<leader>sfc     - search chat histroy
<c-g><c-s>      - save current claude_code buffer to chat history
<c-g>l h        - avante history

<c-g><c-j>      - send parrot buffer user prompt to claude code

<c-g>v/s        - Prt chat new
<c-g>r/a        - in visual mode: rewrite / append
<c-g>l p        - provider
<c-g>l m        - model


Repo:
https://github.com/frankroeder/parrot.nvim

Lua config:
~/.config/nvim/plugin/config/parrot.lua

Commands:
https://github.com/frankroeder/parrot.nvim?tab=readme-ov-file#commands

Source:
~/.config/nvim/plugged/parrot.nvim/lua/parrot

Chat store:
~/.local/share/nvim/parrot/chats

Config example: 
https://github.com/frankroeder/dotfiles/tree/5705713e66318e37a80d1060a458eaae2f1b6ff1/nvim/lua/plugins

command nvim -c "PrtChatNew"
ls -l | command nvim - -c "normal ggVGy" -c ":PrtChatNew" -c "normal p"

<leader>sfc   - AI Chats topics
<leader>sfC   - full text

source code:
Documents/file
Default config:
~/.config/nvim/plugged/parrot.nvim/lua/parrot/config.lua‖/localˍsystem_chat_promptˍ=
~/.config/nvim/plugged/parrot.nvim/lua/parrot/config.lua‖/hooksˍ=ˍ{

## claude code
<c-g>p        - *paste* paragrap or visual sel 
<c-g>o        - + linewise *operator* like 'j' ',j' 
<c-g>i        - + *inner* operator like 'aw' '$' 
<c-g>C        - clear claude text field
<c-g><cr>     - run current text in claude term field
<c-g><c-s>    - save claude code buffer e.g. /Users/at/.local/share/nvim/parrot/chats/claude_code_9790.md

~/.config/nvim/plugin/config/parrot-claude-code.lua

## parrot maps
<c-g>g  - run
<c-g>d  - delete chat
<c-g>s  - stop execution!

<c-g>n/N - new chat (also with visual sel included!) (vert / below)
<c-g>r   - rewrite selection
<c-g>a   - append to selection

<c-g>l p  - select provider
<c-g>l m  - select model

## avante maps
~/.config/nvim/plugin/config/ai-maps.lua‖*ˍˍˍAVANTE

<c-g><leader>v - AvanteChatNew
<c-g><leader>M - AvanteModel
<c-g><leader>h - AvanteHistory
<c-g><leader>H - CodeCompanionHistory
<c-g>l',       - AvanteFocus
<c-g>c',       - AvanteStop
<c-g><leader>c - AvanteClear


<c-g>m   - add file (neo tree)

apply_all = "A",
apply_cursor = "a",
retry_user_request = "r",
edit_user_request = "e",
switch_windows = "<Tab>",
reverse_switch_windows = "<S-Tab>",
remove_file = "dd",
add_file = "@",
close = { "q" },
close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }


# python uv & printer.py setup [2025-08]

current version!!
~/Documents/Proj/k_mindgraph/h_mcp/f_dspy/printer.py
older version:
cp ~/Documents/Proj/k_mindgraph/_temp/langextract/printer.py app
cp ~/Documents/Proj/k_mindgraph/_temp/langextract/langextract/_scratch/a_basic.py app

uv init
uv run hello.py
cp ~/Documents/Proj/k_mindgraph/b_yf_n4/a_bnd_py_basic/.gitignore .

git init
git add *
git commit -m 'initial commit'
cp ~/Documents/Proj/k_mindgraph/i_sync_db/d_livest_v4/.gitignore .
cp ~/Documents/Proj/k_mindgraph/i_sync_db/b_zero_ztunes/.gitignore .
cp ~/Documents/Proj/k_mindgraph/i_sync_db/d_eff_livest/.gitignore .
git add .gitignore
git commit -m 'gitignore'

gh repo create f_dspy --source=. --private
git push --set-upstream origin main

mkdir app
touch app/__init__.py

Here's a cleaned up (no printer_img.py, was needed for langgrap)
version of printer.py:
~/Documents/Proj/k_mindgraph/_temp/langextract/printer.py
and a basic starter file:
~/Documents/Proj/k_mindgraph/_temp/langextract/langextract/_scratch/a_basic.py
note the 
_scatch/__init__.py
is needed to allow this import in printer.py
from langextract._scratch.a_basic import e2_ab as symToEval

## uv add / install packages
~/.local/share/nvim/parrot/chats/2025-08-27.11-21-27.573.md

## ipython repl
<leader>ro   - open the repl / <leader>gq to quit
gep          - paste the code paragrah into the repl
(v)gep       - paste the vis-sel lines into the repl

To run a file:
<leader>ro  - start ipython
VG          - vis select all lines
gep         - to paste the vis-sel into the repl


## docs examples
~/Documents/Proj/g_edb_gql/m/_printer/ExampleLog.md
~/Documents/Proj/j_edb_smithy/m/_printer/ExampleLog.md
~/Documents/Proj/l_local_fst/m/_printer/ExampleLog.md

# startify
in screen:
    e   - close startify, edit new empty buffer. same as :new ?
    b s v t   - mark recent files, then <cr> to open them in diff windows
new screen:

<c-w>Go  float
<c-w>Gv  vnew
<c-w>Gs  new
<c-w>Gt  tabnew

<c-w>G v/tn/i - NewBuf startify screen
<leader>st/T  - old quick map, discontinue?

# session / possession
<leader>ls  - Possession load for cwd
<leader>lS  - Possession save for cwd
<leader><leader>ls - select dialog
PossessionSave <new name>  - to use a secondary session for the same cwd. then load it with <leader><leader>ls

Rename sessions: <c-w>l s
/Users/at/.local/share/nvim/possession

# open from dirvish float
I - full
U - up
A - right
X - down
Y - left
T - tab

requirements:
1. "server"
long running app
there should be a separate (permannent) visible sbt session running
there'll be an sbt:<package>run call for the server app to start
the thin server app file will not have routes as input but rather refer to services
i need to research/test a sequence of keystrokes to stop and restart the server app
so without restarting the terminal or even sbt!

2. "printer"
the same as above (with similar infrastructure, commands?) but will 
end after a value is printed

3. "test"
zio test may provide me with modular infrastructure
~testQuick incrementally build the project (in this sbt session)
i could also print in tests


# typescript printer client server

## inspect maps (voyager and graphiql / giql)
geec   - giql
geev   - voyager schema explorer
    Note that 
     - both windows can be open
     - viminum maps and reload allow basic key navigation
     - ^ allows to switch windows!
     - also not g?, go, ge maps

## printer
<leader>et  - creates an exported lazy identif (stub)
gei         - refetches the currentl set identif

## gql client server
gew   - set identif (of detected type based on name), schema, query, varia, resolver, ect
gef   - refetch the gql client

## vite dev server
<leader><leader>sd   - runs 'npm run dev' in visible term, finds localhost:<port>, open url in chrom, hides terms buffer!
                       ~/.config/nvim/plugin/utils/utils-terminal.vim‖/StartDevServer()

pnpm run dev
glc/b   - on http://localhost:5173/
<leader>glc   - chromium with http://localhost:5173/

## browse lsp symbols, navbuddy / vista tag bar outline
<leader>on - Navbuddy
<leader>ot - to open vista outline for .md files and lsp
             NOTE: config is in outline.lua!
<leader>of - open outline in float (above ZenMode!)
<leader>k  - now jumps to the marker while the cursor is staying in the vista window

~/.config/nvim/plugin/setup-general.vim#/nnoremap%20<silent>%20<leader>k
note the buffer map in vista window didn't work.

## vista
zc/o   - close/open folds
<leader>k    - focus symbol in editor
J/K    - jump parent

## Repl / source lua & vimscript actions vs printing return data
use gei in .md, .lua and .vim files. use <leader>se on pain vimscript lines in .md files. ~/.config/nvim/plugin/utils-vimscript-tools.vim‖/PrintVimOrLuaLine()
require("neo-tree.command").execute({ action = "show", position = "right" })
require("neo-tree.command").execute({ action = "close" })

## cleanup strip windows line feeds
command! StripWindowsCR %s/\r//g
<leader>sw   - strip whitespace

# tabline tabby
<leader>ts Tab_UserSetName 
<leader>tS persist_reset 
<leader>tl user_set_lspsym 
~/.config/nvim/plugin/config/tabline_tabby.lua‖*Mappings

in neo-tree:
<leader>td Tablabel_set_folder
~/.config/nvim/plugin/utils-fileselect-neo-tree.lua‖/["<leader>t

<leader>ts', Tab_UserSetName )
<leader>tS', persist_reset )
<leader>tu', Tab_toggle_hide )
<leader>l tu', Tabs_toggle_show_hidden )
<leader>l tU', Tabs_all_toggle_hide )


info about session persistance: ~/.config/nvim/plugin/config/tabline_tabby.lua‖*Userˍsetˍtabˍlabelˍ/ˍname

# NewBuf from path
p preview_back
o float
i full
t tab
T tab_bg / tab_left

v right
V right_back
a left
u up
U up_back
s down
S down_back

<c-w>    - SELF
,(,)     - PARENT & ROOT
           tn, an, An, sn  - to make maps a bit more unique
<c-w>l   - LINE-WORD
<c-w>,   - CLIP-BOARD
<c-w>r   - REPL-BUFFER
<c-w>t   - TODO: any terminal buffer?
<c-w>g   - SCRATCH-BUFFER
<c-w>    - TELESCOPE
           tn - tab
           tt - tab_back - go to new tab but keep open
           T  - tab_bg   - push to the right
gd       - CURSOR-LSP-REFERENCE

### project notes
<leader>nv   - Open project notes (vsplit)
<leader>ns   - Open project notes (split)
<leader>nT   - Open project notes (tab)
<leader>nd   - Open project notes directory
<leader>nD   - Open notes proj directory
<leader>nf   - Browse notes proj directory
<leader>nt   - Create new / "touch" note
           ~/.config/nvim/plugin/config/maps.lua‖*ProjectˍNotes

## newBuf from ntree
\v \s  - split in prev window
    The NewBuf split maps of all non-float tree windows create the split relative to the tree window
    note the use of p / "preview" as an exception.
    also using \v and \s creates the split relative to the previous window
    The NewBuf split maps of float tree windows create the split relative to the previous window. (see
    ~/.config/nvim/plugin/NewBuf-direction-maps.vim‖/IsInFloatWin()ˍ|ˍwincmdˍpˍ)


# Window move
window move is now e.g.:
nnoremap <leader><c-w>L <c-w>L

window resize (quick expand) horiz  = <c->.
window resize (quick expand) verti  = <c->,
window resize        shrink  horiz  = <c-w>.
window resize        shrink  verti  = <c-w>,,

## file view 2023-04
view a file path:
  right, below and float
<c-w>l v :exec "vnew " . getline('.')<cr>
<c-w>l s :exec "new " . getline('.')<cr>
<c-w>l t :exec "tabedit " . getline('.')<cr>

<c-w>l o :call FloatingBuffer( getline('.') )<cr>

## dovish
<leader>to <Plug>(dovish_create_file)
<leader>mk <Plug>(dovish_create_directory)
<leader>dd <Plug>(dovish_delete)
<leader>re <Plug>(dovish_rename)
<leader>yy <Plug>(dovish_yank)
<leader>yy <Plug>(dovish_yank)
<leader>pp <Plug>(dovish_copy) -- need to first yank
<leader>mv <Plug>(dovish_move) -- need to first yank

https://github.com/roginfarrer/vim-dirvish-dovish/blob/main/README.md

## ranger
<leader>gr  - open in float
~/.config/nvim/plugin/config/ranger.lua

### file infos
<leader>K   - in neotree
<leader><leader>is - show lines cound and file size in divish

## neo-tree
all maps: ~/.config/nvim/plugin/config/neo-tree.lua‖*Filesystemˍmappings

NEOTREE FOLDER PATH FROM LINE
(use <c-w><leader><leader>s)
~/Documents/Proj/j_edb_smithy/m/h4s_simple
~/Documents/Proj/_dbs

<leader>oa  - toggle open
<leader>oo  - open in float
              <c-w>i, jpjpjp  - to run through the files of a folder

zo   - expand subnodes
i    - toggles the subnode (in its currend expansion state)
zc   - collapse all subnodes
zC   - collapse all tree nodes

o    - float view of node!
       to try the native "P" preview feature: use the side view (<leader>go) then P on the file.

<leader><leader>om  - order (sort) by modified
    c = order_by_created
    d = order_by_diagnostics
    g = order_by_git_status
    m = order_by_modified"
    n = order_by_name
    s = order_by_size
    t = order_by_type

<leader>Os   - system open in MacOS default app e.g. a folder in Finder!
               [note](2025-01-15_note.md) this seems to only work on files that have no spaces
               note this also works on a buffer line like this: ~/Documents/Proj/e_ds/Screenshot.jpeg

<leader>Oc   - open path in VS Code (or use the cwd)
                e.g. test on this line .. ~/Documents/Proj/j_edb_smithy


\di  - switch to dirvish
\dt  - switch to tree
<c-l>  - previous mapping doesn't seem to work


echo v:lua.Util_is_subpath( getcwd(), expand('%:p') )

### neotree: copy, move & delete multiple files

#### with quick move
c     - to mark a file to be copied
x     - to mark a file to be cut
<leader>pp  - to copy or cut the selected files to the selected node

#### with visual select
<c-v>   - to activate visual sel
<leader>dd  - to delete sel files
<leader>yy  - to copy sel files
<leader>xx  - to cut sel files
<leader>pp  - to copy or cut the selected files to the selected node

note that delete is somewhat not consistent(..)



### outdated nvim tree might partially still apply

[root-level] [direction]      - open an nvimtree buffer
                                  * root-level: parent|zwd: ,(,)
                                  * direction: o i- t v an u sn

[EXAMPLE:]
,,a/sn    - tree left
<leader>go      - close in any window from anywhere.
<leader>go      - open tree in (normal) left column

[EXPANSIONS]
ggzr(zr)  - expand all subfolders (progressively)
            * combine this with using <leader>B to show only buffer-loaded files
zc        - close folders but keep folders with loaded buffers open
,j/k      - next/prev open buffer.
Y         - close parent folder (from all inner files)
I         - expand folder
<c-]>     - from dirvish(!): expand folder in treeview!

<leader>gs      - find current buffer in tree

[TREE-ROOT]
- / ,i     - move root up to parent
<leader>- / ,,i  - set root to cwd
<leader>b        - set root to node/directory 

[FILTERS]
<leader>I/G/B    - filter/show:  I: gitIgnore | G: gitClean | B: noBuffer

[PREVIEWING]
V..p       - opens a (dirvish or file) buffer, then use p to preview other files/dirs in this buffer


## file openers
~/.config/nvim/plugin/utils-fileselect-telescope.vim‖*Fileˍopeners

gp    Telescope oldfiles<cr>
gP    Telescope frecency<cr>
g,p   Telescope frecency workspace=CWD<cr>
g,P   Telescope frecency workspace=LSP<cr>
<leader>gp  MRU_show()<cr>
go    Telescope find_files hidden=true<cr>
<leader>go  Neotree show left toggle<cr>

gb <cmd>Telescope buffers<cr>
,gb <cmd>Telescope file_browser<cr>

nnoremap <silent> <leader>gs :call v:lua.require("neo-tree.command").execute({ 'action': "show", 'reveal_file': expand('%:p'), 'reveal_force_cwd': v:true })<cr>


i", action = "edit" },
p", action = "preview" },
<leader>dd", action = "trash" },
<leader>yy", action = "copy" },
<leader>re", action = "rename" },

<leader>I", action = "toggle_git_ignored" },
<leader>G", action = "toggle_git_clean" },

    *nvim-tree.filters.git_clean*
    Do not show files with no git status. This will show ignored files when
    |nvim-tree.git.ignore| is set, as they are effectively dirty.
    Toggle via the `toggle_git_clean` action, default mapping `C`.
      Type: `boolean`, Default: `false`


<leader>/", action = "search_node" }, -- can use regex and expand child folders!
<leader>rf", action = "run_file_command" }, -- vim shell with the abs file path
<leader>so", action = "system_open" }, -- opens finder explorer

<leader>re", action = "rename" },
<leader>pp", action = "paste_file", action_cb = tree_api.fs.paste },
<leader>pP", action = "paste_cut_file", action_cb = tree_api.fs.paste },

<leader>o", action = "dirvish_folder", action_cb = tree_openFolderDirvish },
<leader>i", action = "dirvish_folder", action_cb = tree_viewPathInPrevWin },
<leader>b", action = "base_dir", action_cb = tree_setBaseDir },
T", action = "open_tab_silent", action_cb = open_tab_silent },


maps: ~/.config/nvim/plugin/setup-general.lua#/--%20Mappings%20migrated
settings: 
highlights: ~/.config/nvim/colors/munsell-blue-molokai.vim#/Nvim%20Tree

TODO/Issues:
  can not have different roots in different tabs/wins

cleanup [buffers](2024-12-07_buffers.md):
<leader><leader>st  - %bdelete | Startify
 - telescope buffers (go) can 'm' multiselect and <c-d> to delete buffers
 - nvim tree's preview (p) doesn't keep the buffers in the list
 - or there '<leader>bd' when closing a window

### Marks/bookmarks workflow
m     - mark files in the tree
]g[g  - load next/prev marked files in buffer (will ask if there a multiple wins)
        this works with zen mode only if the tree gets reloaded with <leader>nf
B     - in tree will filter to only the list of marked/open files

## Marks
<leader>om - open Markbar
m[A-Z,a-z] - create global,local mark
'[A-z] - go to mark. \` jumps to cursor pos
M[A-z] - delete mark
in markbar:
<c-n>/<c-p> - next/prev mark
o - open mark at cursor
<c-x> - delete mark
DelLocalMarks, DelGlobalMarks
gz'M - Open a mark position in a floating-win. Use empty floating win with marks jumps: e.g. gz'M

Markbar config: ~/.config/nvim/plugin/setup-general.vim#/Marks.

## jumps & marks
[g   - prev insert start 
       NOTE: that "`[" doesn't work bc/ of autosave:
i'm now using [g to go to the insert start pos.  ~/.config/nvim/plugin/config/autosave.lua‖*InsertˍstartˍmarkˍFiX

## vim tools_db / psql / SQL
general db notes/faq: ~/Documents/Proj/g_edb_gql/m/h4s_simple/skunkdocs/a_skun.sql

now prefer using psql within sql.vim
1. set postgres db name using '<leader>ss'
let g:dbname = 'zio_skunk_tradeIO'
   or set g:dbconn if e.g. a docker image requires user&pw:
let g:dbconn = 'postgresql://jimmy:banana@0.0.0.0:5432/world'
let g:dbconn = 'postgres://user:password@localhost:5430/postgres'
let g:dbconn = 'jdbc:at://localhost:5432/realworld1'
   set g:dbconn to '' to use g:dbname
let g:dbconn = ''

2. use gej in .sql file paragraph

/Users/at/.config/nvim/plugin/tools_db.vim

for DBUI:
<leader><leader>du   - toggle open the DBUI panel
<leader><leader>df   - to link a .sql buffer to a database connection
A                    - in panel to create a new connection (using a connection string like:
                       postgresql://at:at@localhost:5432/zio_skunk_tradeIO
<leader><leader>d}   - eval a motion. <leader><leader>dib /ip should also work? 
:DBRun               - for file or visSel

:DBUI  needs to :DBUIFindBuffer of a .sql file
`gei` evaluates paragraphs

more maps and scripts: 
/.config/nvim/plugin/tools_db.vim#/nnoremap%20<silent>%20<leader>du
api/instrument/US0378331005
api/trade/ibm-123\?tradedate=2023-05-28

tests/testOnly tradex.domain.tests.integration.*
tests/testOnly tradex.domain.FrontOfficeOrderParsingServiceSpec.*

val tradingCycle: ZIO[Any, Throwable, Nothing]

connections / settings
/Users/at/.config/db_ui/connections.json|1

# List DB infos
~/Documents/Proj/g_edb_gql/m/h4s_simple/skunkdocs/a_skun.sql‖*ListˍDBˍinfos
~/Documents/Proj/g_edb_gql/m/h4s_simple/skunkdocs/a_skun.sql‖/psqlˍpostgresql://jimmy:banana@

# markdown
## markdown / ai-chat motions
<leader>n/p   - top level next/prev
~/.config/nvim/plugin/ftype/vim_lua_md.vim‖/NOTE:ˍjumpingˍtoˍmainˍdefi

TODO: markdown might deserve a separate list of patterns? vs vim/lua

NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Vim_MainStartPattern = '\v^(\#|---|☼\:|⌘\:|.*─|function|func\!|\i.*function\(|local\sfunction\s|.{-}\*\S{-}\*)'
" the *\S{-}\* patterns is searching vim help headlines
let g:Vim_TopLevelPattern = '\v^(\=\=|\#\s|.*─|☼\:|⌘\:)'

## markdown text objects
..o/iH   - around/inside heading content
buffer maps: ~/.config/nvim/plugin/ftype/vim_lua_md.vim‖/onoremapˍ<silent><buffer>ˍ

## markdown & writing preview and syntax highlight

### Peek
<leader>glm :PeekOpen<cr>
<leader>glM :PeekClose<cr>

:PeekOpen/Close  - to start stop
- separate tool window with cursor sync, fast
- need to stop with PeepClose!

use <leader>se
exec('PeekOpen')
exec('PeekClose')


## RenderMarkdown
https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file#commands
command:
RenderMarkdown toggle



### sqls / sqlls SQL language server
/Users/at/.config/sqls/config.yml|1
~/.config/nvim/plugin/setup-lsp.lua#/lspconfig.sqlls.setup{
/Users/at/.config/nvim/plugin/setup-lsp.lua|296
~/.config/nvim/plugin/tools_db.vim#/let%20g.dbs%20=


## info & sort in Dirvish / SortBy Modified and size
  <leader><leader>om :call DirvishSortByModified()<cr>
  ,,om :lua DirvishShowModified()<cr>
## DirvishSortBySize lines count
  <leader><leader>os :call DirvishSortBySize()<cr>
  ,,os :lua DirvishShowSize()<cr>


# Search

## online code search
https://grep.app/search

## File and folder / directory search
~/.config/nvim/plugin/config/telescope.vim‖*ˍˍˍFileˍsearchˍmapsˍ2025-03

gsf     - files in cwd sorted by most recently used (local)
gsF     - files most recently used (global)
<leader>gsf   - files in cwd not sorted (not sure that's needed?)

gsd     - directory / folder names
gsD     - file browser

## Folderˍsearchˍmapsˍ2025-03 - search text in folders
~/.config/nvim/plugin/config/telescope.vim‖*Folderˍsearchˍmapsˍ2025-03

<leader>sff   - find directory shows a dirvish folder
<leader>sfb   - browse to a Proj folder first, then search it's content

<leader>sfc   - AI Chats (Parrot) topics
<leader>sfC   - full text

<leader>sfn   - Notes topics
<leader>sfN   - full text

<leader>slh   - Local code headers
<leader>slH   - Local md headings
<leader>slc   - Local comment texts

## COLLECTION search 
could deprecate this, bc/ hardly used?
use case: i could add more predifined patterns?
,cp then <leader>p  - to set search folder
,scr <cmd>lua require('utils.general').Search_collection_full()<cr>
,sch <cmd>lua require('utils.general').Search_collection_md_headers()<cr>

### Hard link example
NOTE: I no longer use hard links - some apps break them!
use symlinks instead:
ln -s ~/.config/nvim/keymaps/vim-cheat-sheet.md ~/Documents/Notes/vim-cheat-sheet.md

hardlink infos
ln keymaps/vim-cheat-sheet.md ~/Documents/Notes
~/Documents/Notes
keymaps/vim-cheat-sheet.md

### hi there
eins

#### which file is a hardlink or original?
I ran the following:
ln keymaps/vim-cheat-sheet.md ~/Documents/Notes

now I see:
ls -l keymaps/vim-cheat-sheet.md
    .rw-r--r--@ 67k at 19 Jul 17:39 keymaps/vim-cheat-sheet.md
stat keymaps/vim-cheat-sheet.md
    16777233 262981080 -rw-r--r-- 2 at staff 0 67187 "Jul 19 17:39:27 2025" "Jul 19 17:39:35 2025" "Jul 19 17:39:35 2025" "Jul 19 17:07:23 2025" 4096 256 0 keymaps/vim-cheat-sheet.md

ls -l ~/Documents/Notes/vim-cheat-sheet.md
    .rw-r--r--@ 67k at 19 Jul 17:39 /Users/at/Documents/Notes/vim-cheat-sheet.md
stat ~/Documents/Notes/vim-cheat-sheet.md
    16777233 262981080 -rw-r--r-- 2 at staff 0 67455 "Jul 19 17:40:01 2025" "Jul 19 17:40:00 2025" "Jul 19 17:40:00 2025" "Jul 19 17:07:23 2025" 4096 256 0 /Users/at/Documents/Notes/vim-cheat-sheet.md

##### conclusion
The link count of 2 in the stat output confirms these are hard links to each other. When you
  create a hard link, there's no concept of "original" vs "link" - they're both equally valid paths
  to the same file.

### Collection search: Link files to Bookmark folder & search

I can hardlink any file to a folder in Bookmarks:
,ca  - In a dirvish folder on the file. Then a dialog will show up
<leader>i  - to select the subfolder in Bookmarks.
~/Documents/Notes/

I can activate a search collection:
,cp  - open a dialog
<leader>i  - to point to set the new active search collection

,sch - to search only the headers in the active collection.

new: all notes go to Documents/Notes folder, only *hard* links go to Documents/Bookmark folders
also see: ~/Documents/Notes/Local_fst_app.md‖/#ˍExampleLo

"Collections of file links"

  "add to collection" - "collection add" => ,ca
  "point to collection" - "collection point" => ,cp or ,ce
  "collection search header" => ,csh
  "collection search all" => ,csj
  "collection search signatures" => ,css (todo)

  "show notes folder sorted by last modified" => ,cm

set a default/start collection here: 
~/.config/nvim/plugin/general-helpers.vim#/let%20g.FolderSearch_Path%20=
.. currently its "notes_stack"

## new collection regex search 30.05.2023
    simple full live regex:
,scr <cmd>Telescope live_grep search_dirs=/Users/at/Documents/Notes<cr>

    searches in current collection folder! with a regex (for header) default text
,sch <cmd>lua require('utils_general').Search_collection_md_headers()<cr>

~/.config/nvim/lua/utils_general.lua#/function%20M.Search_collection_md_headers..

CONCLUSION:
use ,scr over ,csj
use ,sch over ,csh


## surround / wrap text objects and visual selections
In insert mode, wrapping with pairs is mostly handled by autopairs
~/.config/nvim/plugin/config/nvim-autopairs.lua

VSi    - insert sourround! supports asymetic warps like ```python def a()```
VS)}}  - all work nicely
VST    - warp with tripple backticks
VSD    - warp with tripple double quotes
VSS    - warp with tripple single quotes


# 2023-11 Quick cursor vis-sel & identifier search
gsr       - <cword> -> Search_mainPatterns( 'global', expand('<cword>'), "normal" )
gst       - <cword> -> ast-grep! 

ge;       - main symbols in file
ge:       - main symbols in repo and headers in Notes
gel       - lsp symbols

~/.config/nvim/plugin/tools_vimscript_lua.vim‖:28:4

## ast grep search
~/Documents/Notes/vim_works.md‖/#ˍast-grepˍ
example: (use gei) 
Search_ast( 'if $$$ then $$$ return {$$$} end' )

## search function name in nvim repo using gsr in error message!
on any vim error (show with <leader>sm) like:
    Error detected while processing function TermOneShot:
    _ 
    E116: Invalid arguments for function getcwd
    E116: Invalid arguments for function termopen
1. <leader>sm then <c-w>i   - to go into the error float window.
2. gsp  then <c-w>i   - <c-w>i on "nvim" project will make the error window cwd "nvim"
3. <c-o>               - to go back to the errow message
4. gsr               - on the function name in the message

<leader>sm    - lua PrintMessages( 3 )
<leader>sMm   - lua PrintMessages( 30 )
<leader>sMM   - call ShowMessages_new()

## Telescope Rgx regex search 

,svs      - search vim symbols
,svm      - search vim maps
,svv      - search vim all code
,svh      - search vim & lua headers

ge;       - main symbols/bindings in this repo
ge:       - main symbols/bindings in selected (parent-based) repos
,st       - tags (NOTE:) in current project
,sT       - tags (NOTE:) in selected projects
,sc       - comments in current project
,sC       - comments in selected projects
,sh       - headings in current project
,sH       - headings in selected projects

maps, regexes and glob definitions:
/Users/at/.config/nvim/plugin/utils_general_maps.lua


new telescope select maps
<c-s>b  - select below
<c-s>u  - select up

~/.config/nvim/plugin/utils-fileselect-telescope.vim#/nnoremap%20,sa%20<cmd>Telescope


# Vim-Works
/Users/at/Documents/Bookmarks/notes_1_2023/vim_works.md

find any git-repo in Documents/!  - <leader>tr
search help tags - <leader>th

# auto completion menue
<c-d>/<c-f>   - to scroll the docs buffer!
<c-e>         - to close the menue!
~/.config/nvim/plugin/setup-lsp.lua#/mapping%20=%20{

# vim diff
the left window are the proposed changes
the right wind  are is the original file
use:
]c[c  - navigate hunks in left win
dp    - in left win on a hunk you want to 'put' into the buffer! (right win)
do    - should 'optain' / 'get' the changes back .. but doesn't work (with magenta) .. instead use: ..
<leader>hr  - hunk reset! this fetches the lines/hunk from the last commit, overwriting the change! (.. that came
              from dp / the diff view)
,do   - in the diff buffer. does :diffoff! and :q to stop the diff view
[h]h    - can still navigate the gitsigns changes so far in the buffer (before the diff puts come in)

# diffview plugin
~/.config/nvim/plugin/config/diffview.lua‖/functionˍCo

,dp      - Compare current buffer with clipboard

<leader>ogl', ':DiffviewFileHistory %<CR>', 
<leader>ogL', ':DiffviewFileHistory<CR>',   

try:
https://github.com/sindrets/diffview.nvim?tab=readme-ov-file#usage

DiffviewFileHistory


# git maps

<leader><leader>gF   - git fetch && echo "=== Local vs Remote ===" && git status -sb && echo "" && echo "=== Incoming Changes ===" && git log HEAD..@{u} --oneline 2>/dev/null \|\| echo "No incoming changes"' )<cr>
<leader><leader>gR   - git pull --rebase
<leader><leader>gP   - git push

## git merge conflict diff markers resolving 
Your Neovim is using git-conflict.nvim to render those merge conflict markers. Here are the keymaps for resolving
  conflicts:

  Conflict Resolution Keymaps:
  - co - Accept ours (current/HEAD changes)
  - ct - Accept theirs (incoming changes)
  - cb - Accept both changes
  - c0 - Delete both (accept neither)

  Navigation:
  - ]x - Jump to next conflict
  - [x - Jump to previous conflict

## git commits
<leader><leader>gc  - commit via /Users/at/.config/utils_global/git-snap-cloud

## git diff views
2025-04:
<leader>gd           - Git commits viewer (5 commits, shows file list with M/A/D/R100 status)
<leader>gD           - Git file history viewer (current file, 5 commits)
<leader>ogl          - Git commits picker (telescope)
<leader>ogL          - Git commits viewer (40 commits)
<leader><leader>gd   - Compare two files from consecutive lines (git diff --no-index)
<localleader>gd      - Compare two git refs from consecutive lines (branches/commits/HEAD~1)
                       Falls back to last valid refs if empty/invalid lines

### Git Diff Viewer Keybindings (inside viewer)
p                    - Show diff for file/commit under cursor (stay in file list)
P                    - Show diff for file/commit under cursor (jump to diff view)
q                    - Close git diff viewer
<c-n>/<c-p>          - Navigate to next/previous commit or file change

### User Commands
:GitDiffFiles file1 file2           - Compare two files
:GitDiffBranches ref1 ref2          - Compare two git refs (branches/commits/HEAD~1/tags)
:GitDiffBufferMaps                  - Set up buffer keymaps for git diff navigation

2024-11:
ggs      - 'status' by showing diffs of all hunks
<leader>ogs    - 'status' by showing diffs of all hunks
<leader>ogS    - just the lines count changed per file! via git diff HEAD --stat
                 ~/.config/nvim/lua/utils/general.lua‖/functionˍM.Git_status_picker(op

ggl/<leader> - git log of the current file/all files
<leader>ogl/<leader> - git log of the current file/all files
<leader><leader>ogl/<leader> - file history (filtered by actual changes to files!) vim diff view
, gl/<leader>   - (same) / git log of the current file/all files
                  ~/.config/nvim/lua/utils/general.lua‖/functionˍM.Git_c
           maps and layout conf:
                  ~/.config/nvim/plugin/config/maps.lua‖/opts_gitstatˍ=ˍ{
<leader>ogg    - commit with fugitive
<leader>gi     - (in dirvish) add file (folder?) to .gitignore


# new git workflow
older:
<leader>ogs    - 'status' by showing diffs of all hunks
<leader>ogS    - just the lines count changed per file! via git diff HEAD --stat
<leader>ogc    - git commit message via fugitive (use ,,w to save and close/ confirm commit)
<leader>oga    - stage all & commit message via fugitive
<leader>ogl/<leader>  - list of git commits (with date ago/telescope)
                        maps: ~/.config/nvim/plugin/utils_general_maps.lua#/--%20Git%20picker

## gitsigns
workflow 2025-01: ~/.config/nvim/plugin/config/maps.lua‖*Gitsigns
, gd   - to show diff view in buffer (mini.diff)
<leader>gd   - git_commits_viewer
]c[c   - next/prev hunk
<leader>hr   - reset the hunk! (taken from prev commit!)
               can combine with simple undo/redo

<leader>gg   - gitsigns gutter, only for unstaged changes
]c[c         - navigate hunks
<leader>hp   - preview a diff of the hunk inline. 
<leader>hs/r - stage / reset a hunk. use S / R for the entire buffer
<leader>hu   - undo stage hunk

~/.config/nvim/plugin/utils-gitsigns.lua‖*Stagingˍgitˍhunks

### other gitsigns maps
<leader>gg    - toggle
]c[c          - next/prev hunk
<leader>hp    - show diff!!
<leader>gh    - Gitsigns change_base ~1
<leader>gH    - Gitsigns change_base
<leader>g1    - Gitsigns change_base ~1
<leader>g2    - Gitsigns change_base ~2
<leader>g3    - Gitsigns change_base ~3
<leader>g4    - Gitsigns change_base ~4



<leader>ogg    - fugitive main. use 's' to stage and 'u' to unstage. 'cc' to commit
<leader>G/I    - ? neo-tree: show ignored/git status files

can stage/unstage files in dirvish
<leader><leader>ga :<c-u>call Dirvish_git_add( getline('.') )<cr>
<leader><leader>gA :<c-u>call Dirvish_git_unstage( getline('.') )<cr>

- checkout older version of file out under a different name
- put windows of different file versions side by side and use
:set scrollbind
:set noscrollbind

## git removing files
git rm -r --cached docs/_archive
git commit -m "chore: untrack docs/_archive"

git rm -r --cached .bloop/
git rm -r --cached .metals/

## git commit changes to branch
Create and switch to backup branch
git checkout -b advanced-test-logger
git checkout -b tutorial-todo-workspace
Add and commit everything (including untracked files)
git add -A
git commit -m "advanced-test-logger"
git commit -m "tutorial-todo-workspace"
git checkout main 


## git reset hard roll back
First, create a new branch to save your current work (including uncommitted changes)
git stash --include-untracked
git checkout -b opencode-fix-attempt
git stash pop

Commit all your changes to this backup branch
git add -A
git commit -m "WIP: opencode fix attempt"

Now go back to your original branch (likely main or master)
git checkout main  # or git checkout master

Reset to the latest commit, discarding all changes
git reset --hard HEAD
git clean -fd
git clean -nfd


### Telescope git_bcommits
This is a convienient alternative approach to see a diff via VimDiff in 
two vim buffers side by side:
Telescope git_bcommits    - Run this in the file/buffer you want to compare
                          - find the commit/version you want to compare compare compare to
                          - use <c-t> to open a new tab with two VimDiff buffers!
                          - use :q on the 'Original' buffer to close the tab!


*  - previous line start
<c-o> - any non-reversible jump should use "normal! m'" to add to the jump list


# align
not ideal. I keep defining patterns (per column) here: ~/.config/nvim/plugin/utils-align.vim‖/g:alignTemplˍ=ˍ[
,aJ/j   - allows to activate a simple regex based preset (per column)

,>      - Push shift text to the right. ~/.config/nvim/plugin/utils-align.vim‖/InsertStringAtLoc(ˍst

# stubs & headings

<leader>ehs - heading start
<leader>ehe - heading start
<leader>ehd - heading delete

<leader>eai  - add <name>0 to var name

## Folds, Folding
<leader>ft   - toggle `set foldermethod?` expr vs marker 
                ~/.config/nvim/plugin/config/setup-general.vim‖*Foldingˍcode

i now have autofolding. but a foldlevelstart=5
so most folds should be expaneded when i open a file.
i can use
zm   - to generally (over the whole file) close one fold level to get a better overview.

`zm` `zr` progressively close/open the fold levels (of nested folds)
`zf` `zd` create/delete fold markers via motions/vis select
`zk` `zj` to navigate
`]z` `[z` go to end/beginning of current fold
`zo` `zc` `z<space>` to open/close/toggle individual folds
`zM` `zR` to close/open all folds
`zx` / `zX` update /re apply
zd<motion>  to delete the fold markers under the motion

~/.config/nvim/plugin/setup-general.vim‖*Foldingˍcode

# TS & JSX, TSX
## references with Trouble (lsp based) diagnostics
ged   - show diagnostics (buffer trouble)
geD   - show diagnostics (worspace trouble)
<leader>ged - show diagnostics (worspace telescope)

ge]/[ - next/prev error
ger   - show references of symbol under cursor
]q [q - next/prev reference in workspace

2025-01:
ger   - Glance references. use <c-w>, <c-w> to go to code preview, use <c->, to expand window, <c-p> to jump back
geR   - vim.lsp.buf.reference in quickfix show the host function in breadcrump. Glance does not.

these actually work:
# lsp 
<leader>lca  - code action
<leader>lr   - buf.rename

<leader>lgr :Glance references<cr>
<leader>lgd :Glance definitions<cr>
<leader>lgt :Glance type_definitions<cr>
<leader>lgi :Glance implementations<cr>
https://github.com/DNLHC/glance.nvim/blob/master/README.md

ToggleDiag
<leader>lts   - toggle lsp diagnostic sign column
:e!     - clear diagnostics cache (after changing 'rules' in eslint)

## Motions
J/K    - same column index motion
t/T    - bracket (in hs-motions) ~/.config/nvim/plugin/HsMotions.vim‖*Startˍofˍnext/prevˍbracket
I/Y    - semantic column (e.g. equal sign)
<leader>)/( - end/start of block!
~/.config/nvim/plugin/ftype/typescript.vim‖*Motions
<c-m>/<c-i>  - dots    ~/.config/nvim/plugin/ftype/scala.vim‖*Hotspotˍmotions

ged    - diagnostics float! (Trouble)
]d/[d  - diagn. warning
<leader>ged  - repo diagnostics search! (Telescope)
~/.config/nvim/plugin/ftype/typescript.vim‖/TSˍdiagnost

## end of block motion
J  - when at the beginning of the block, can just use the indent level motions
<leader>)  - this jumps to the end of the block from any place inside the block. (reversible via <c-o>)

### treesitter textobj motions
]M   - got_next_end
~/.config/nvim/plugin/config/treesitter.lua

## go return statement motions
]r    - (from TS function name) go to 'return' statement
[r    - previous return statement
]b    - End of JS block
~/.config/nvim/plugin/ftype/typescript.vim‖/GOˍRETURNˍmotions

## heading motions
q/Q    - next / prev
,q     - current end marker
<op>ih - inside heading content
<op>ah - around heading area
         * yank, delete, cut, visual-sel, change, subsitute

### word motions
#### forward
w/W    - beginning of word/Word
e/E    - end word/Word
#### backward
b/B    - beginning of word/Word
\e     - end of word
(,ge   - end of word) .. shadowed


[op]ii  - inside indent block (linewise delete, change, yank)
[op]ai  - outer indent block (linewise delete, change, yank)

outdated?
<leader>od  - open dirvish in float!

## indenting lines
,,al/j/}    - indent lines to the current cursor horz pos

## pasting from (past) registers
<leader>"   - show registers in Telescope (basically :reg)
              then 0/1/2 and <cr> to output a past yank/copy
"0p         - directly 'puts' the prev, prev yank

## textobject and treesitter motions
not yet tested, working: 2024-01
~/.config/nvim/plugin/config/treesitter.lua‖/lsp_interop

## hop / sneak motion commands
,j/k    - jump to line forward/back (works in visual mode!)
y/d q/Q - yank/delete/substitute until line forward/back
f       - one char line motion
,f/F    - type a char to jump forward/back
          NOTE: cursor has to be in the paragraph for "F" to work!?

~/.config/nvim/plugin/config/hop.lua

## Telescope useful maps

<c-w><cr>  - triggers the *default action*! needed when used as a general options picker.

<c-d>   - actions.delete_buffer, or in normal mode: <leader>dd. buffer delete

          (new 2024-08)
<c-t>    - to open the currently filtered lines in trouble.
           trouble then allows to preview the file loc in the main window!
           also keep the overview list in a presistent float in the top right while looking around in a previewed file location.

in the prompt:
m      - mark/add entry to selection
<c-q>    - add selected entries to quickfix list

<leader>ga   - is similar to ga - search for cursor word with telescope
               just the current file, vs gsr in the cwd
gsH    - search help (vim) like <leader>K
gsv    - fuzzy buffer search
gsg    - live grep
gS     - spell suggest. use yos to toggle error underlines

gsd    - find/search directories / folders in cwd. 
               use <c-i>/<c-n>/<c-p> to reveal the folder in a currently open tree! 
               NewBuf maps show dirvish view

gsb    - 'vim_bookmarks')<cr>
gsc    - 'bookmarks')<cr>
gsp    - 'project')<cr>
gsP    - 'repo')<cr>

gssi   - 'scaladex')<cr>   ?!
     ~/.config/nvim/plugin/config/telescope.lua‖/TOBEˍcontin


[insert]

    ["<c-l>"] = function() vim.fn.feedkeys( ".*" ) end,
    ["<c-space>"] = function() vim.fn.feedkeys( "<space>" ) end,

    ["<c-j>"] = move_selection_next_with_space(),
    ["<c-k>"] = move_selection_previous_with_space(),

    ["<c-n>"] = preview "next" "insert",
    ["<c-p>"] = preview "previous" "insert",
    ["<c-i>"] = preview 'current' 'normal',

    ["<c-o>"] = actions.cycle_history_prev,
    ["<c-m>"] = actions.cycle_history_next,

[normal]

    ["n"] = preview 'next' 'normal',
    ["p"] = preview 'previous' 'normal',
    ["<c-i>"] = preview 'current' 'normal',

    ["<c-o>"] = actions.cycle_history_prev,
    ["<c-m>"] = actions.cycle_history_next,

    ["j"] = move_selection_next_with_space(),
    ["k"] = move_selection_previous_with_space(),

    ["zz"] = selection_center(),


<c-l>    - in insert mode adds ".*" to the line to allow easy "key-snipped" search

<leader>tt <cmd>lua require('telescope.builtin').resume()<cr>
> finding a git repo on disk!
<leader>>tr Telescope repo list layout_strategy=vertical<cr>
<leader>>tp Telescope project<cr>
<leader>>ff Telescope find_files<cr>
go        Telescope find_files<cr> 
<leader>>fo Telescope oldfiles<cr>
<leader>>fg Telescope live_grep<cr>
<leader>>fb Telescope buffers<cr>
<leader>>fh Telescope help_tags<cr>

treesitter syntax
nnoremap <leader><leader>ts <cmd>Telescope highlights<cr>
nnoremap <leader><leader>tS <cmd>TSHighlightCapturesUnderCursor<cr>

init_selection = 'yst',
node_incremental = 'ysn',
scope_incremental = 'grc',
node_decremental = 'ysd',

### Telescope project maps
<c-w><cr>   - find files in that project! then open in split.
R	find a recently opened file within your project

d	delete currently selected project
r	rename currently selected project
c	create a project*
s	search inside files within your project
b	browse inside files within your project
w	change to the selected project's directory without opening it
R	find a recently opened file within your project
f	find a file within your project (same as <CR>)
Default mappings (insert mode):
Key	Description
<c-d>	delete currently selected project
<c-v>	rename currently selected project
<c-a>	create a project*
<c-s>	search inside files within your project
<c-b>	browse inside files within your project
<c-l>	change to the selected project's directory without opening it
<c-r>	find a recently opened file within your project
<c-f>	find a file within your project (same as <CR>)

#### Telescope projects persist list file
~/.local/share/nvim/telescope-projects.txt
run this to clean up the file:
:g/=0=/d

For your example: d_magenta=/Users/at/Documents/Proj/k_mindgraph/h_mcp/d_magenta=w0=1

  The columns mean:
  1. title: d_magenta - Project display name
  2. path: /Users/at/Documents/Proj/k_mindgraph/h_mcp/d_magenta - Full path to project directory
  3. workspace: w0 - Workspace identifier (defaults to "w0")
  4. activated: 1 - Whether project is active (1) or deleted/hidden (0)
  5. last_accessed_time: (missing in your example) - Unix timestamp of last access

### Gist
Telescopt gh gist

# Scratch
git add *
degit https://github.com/hayes/pothos

type Tags
are just arrays on Posts .. not connections

use the Comment implement (not the node) version
the add a custom Node type to the interface [Node]

i might make manually unique string ids in data.ts.

## filter buffer, spaces, semicolon
<leader><leader>c<leader> - ClearSpaces

### Quick floats
sp os - scratch
sp ol - links
sp ob - vim bookmarks

gdo - go to definition in float

space os - open scratch file in float
space ob - search for bookmarks

new js/ts 'yank around {} block' map: y<leader>ab

gsw - sets a test-printer expression in /scratch/.testPrinter.ts
gsp - prints/call this (exported) identifier (cursor can be in a different place)

sp qa - add cursor pos to quickfix list
<leader>qq - toggle quickfix list

## vim bookmarks

<leader>bb BookmarkToggle
<leader>ba BookmarkAnnotate
<leader>bs BookmarkShowAll
<leader>bn BookmarkNext
<leader>bp BookmarkPrev
<leader>bc BookmarkClear
<leader><leader>bd BookmarkClear
<leader>bk BookmarkMoveUp
<leader>bj BookmarkMoveDown

'i', '<c-x>', delete_selected_or_at_cursor
'n', 'dd', delete_selected_or_at_cursor

## Chrome browser Bookmark search

<leader>gsc    - search chrome bookmarks
            <c-w>i or <cr> will open in chrome
            <c-w>u will open in chromium
            <c-w>p to put url at cursor pos!! (can issue multiple times while staying in the prompt)

~/.config/nvim/plugin/config/telescope.vim
Telescope bookmarks initial_mode=normal default_text=Scala/Ref-Projs/
Telescope bookmarks default_text=caliban

could also search (and edit!?) the (json) file:
/Users/at/Library/Application Support/Google/Chrome/Default/Bookmarks
~/Library/Application Support/Google/Chrome/Default/Bookmarks

# open files in chrome browser
file:///Users/at/Documents/Proj/k_mindgraph/b_yf_n4/yfiles_eval/demos-ts/resources/icons/ylogo.svg
this currently works with .html .md files but not with .svg files
a workaroud: gwj on
open ~/Documents/Proj/k_mindgraph/b_yf_n4/yfiles_eval/demos-ts/resources/icons

## git Checkout and test a previous commit
Commit all current changes
Use FzfCommits / 2<leader>gl to copy a commit hash with <c-y>
run git checkout <commit-hash>
git checkout 5f9228a
git checkout 7b782df
test things then get back using "git checkout main"
git stash
git checkout main
git checkout cca8be8

## git checkout a file from prev commit
git checkout 4b643a6 -- exercises/JsPrinter.js

## topic: Git branch management recovery
~/.local/share/nvim/parrot/chats/2025-05-04.09-24-13.061.md
git checkout -b temp-branch

git branch main-backup-$(date +%Y%m%d)
git status
git branch main-backup main
git checkout -b temp-new-main
git add .
git commit -m "Incorporate work from detached HEAD 7b782df"
git branch -f main temp-new-main
git checkout main


## rolling back npm node_modules
del -rf node_modules
del package-lock.json  # If using npm
del pnpm-lock.yaml     # If using pnpm
pnpm install



## git checkout a single file
git show main:m/_printer/Examples.md > m/_printer/Examples_old.md
git show main:db/index.ts > db/index1.ts
git show origin/main:db/index.ts > db/index2.ts

consider set scrollbind, set noscrollbind

## git fetch an update from the remote repo
<leader><leader>gF  - shows incoming commits
<leader><leader>gP  - pulls from remote repo using --rebase
~/.config/nvim/plugin/utils/utils-git.vim‖/gitˍfetchˍ&ˍpull:

git fetch
git pull
or
git fetch origin
git pull origin main
git stash

~/.local/share/nvim/parrot/chats/2025-05-06.17-37-50.841.md

alternative / longer appraoch:
https://github.com/git-guides/git-pull
git remote update
git status -uno
git pull
git config pull.rebase false
git pull

# Java JDK JVM version management
(update 2024-03)

1. search for available java versions:
cs java --available | grep adopt
cs java --available | grep graal

copy the ID, e.g.:
graalvm:20.0.1
graalvm-java21:21.0.2

2. download the JDK
cs java --jvm graalvm-java21:21.0.2
cs java --jvm graalvm:20.0.1

3. update the zsh activation command
~/.zshrc‖/evalˍ"$(csˍ
currently:
eval "$(cs java --jvm graalvm-java21:21.0.2 --env)"


recent update, from:
java --version
openjdk 20.0.1 2023-04-18
OpenJDK Runtime Environment GraalVM CE 20.0.1+9.1 (build 20.0.1+9-jvmci-23.0-b12)
OpenJDK 64-Bit Server VM GraalVM CE 20.0.1+9.1 (build 20.0.1+9-jvmci-23.0-b12, mixed mode, sharing)

since 11.03.2024
cs java --jvm graalvm-java21:21.0.2 --env
openjdk 21.0.2 2024-01-16
OpenJDK Runtime Environment GraalVM CE 21.0.2+13.1 (build 21.0.2+13-jvmci-23.1-b30)
OpenJDK 64-Bit Server VM GraalVM CE 21.0.2+13.1 (build 21.0.2+13-jvmci-23.1-b30, mixed mode, sharing)

see
~/Documents/Notes//vim_works.md‖*ManagingˍtheˍJavaˍJVMˍ/ˍJDKˍversionˍwithˍCoursier

## monitor / watch / tail a file
<leader>fw / W
  Keeps reloading the current window/buffer with the current filepath!
function M.WatchFile_start()


# httpx  (simpler syntax than httpie)
httpx --help

note this map implements a short form syntax
relies on these vars:
let g:httpx_request_port = 9001
old(?)
let g:httpport = 3000
let g:httpdomain = '127.0.0.1'
let g:httpdomain = 'localhost'
also i can ommit GET
else the -j and -p params are simply appended to the command

nnoremap <silent> geh :call Scala_ServerClientRequest_x()<cr>

actors
httpx http://127.0.0.1:5000/actors

actors PUT -p filter_name "Robert Downey Jr." -j '{"age": 57, "height": 173}'

httpx -m PUT http://127.0.0.1:5000/actors -p filter_name "Robert Downey Jr." -j '{"age": 59, "height": 173}'
httpx http://127.0.0.1:5000/actors -m PUT -p filter_name "Robert Downey Jr." -j '{"age": 57, "height": 173}'

actors POST -p name 'Natalie 2 Portman'
httpx http://127.0.0.1:5000/actors -m POST -p name 'Natalie 2 Portman'

### request normal domains with httpx short syntax
Example: (gwj)
httpx https://swapi.dev/api/planets/1/

(<leader>s})
let g:httpx_request_port = ''
let g:httpdomain = 'swapi.dev'
let g:httpprotocol = 'https'

(geh)
api/planets/1/
api/planets/2/
api/planets/3/

## Http requests curl
gsf :call Scala_ServerClientRequest('', 'float')<cr>
,gsf :call Scala_ServerClientRequest( 'POST', 'float' )<cr>
gsF :call Scala_ServerClientRequest('', 'term')<cr>
,gsF :call Scala_ServerClientRequest( 'POST', 'term' )<cr>

## Http requests httpie
use 'gej' for simple GET requests
use ',gej' for POST requests
http -v get localhost:8080/cities/127/weather
http -v post localhost:8080/cities city=London country=UK
http post localhost:8080/cities city=London country=UK

### httpie shortform requests!
  use 'gsf' for get requests
cities/127/weather
  use ',gsf' for post requests!
cities city=London country=UK
cities city=London country=UK -v
  note how the --verbose option can still be passed!
  also ',gsF' or 'gsF' runs in an term for e.g. streaming responses

let g:httpport = 8080
let g:httpdomain = '127.0.0.1'
    Note: for some reason this domain sometimes differs from localhost
func! Scala_ServerClientRequest( args, mode )
- json formats, uses TSSyntaxadditions

## exec & term calls 2024-04
gep   - Scala_SetPrinterIdentif( "plain" )
gew   - Scala_SetPrinterIdentif( "webbrowser" )
geW   - Scala_SetPrinterIdentif( "server" )

gei   - Scala_RunPrinter( "float" ) 
geI   - Scala_RunPrinter( "server" )
gei   - Scala_RunPrinter( "term"  ) 
gej   - SbtJs_compile()


## exec & term calls 2023-11

considering consistency now:
gek   - vim.lsp.buf.hover         
gej   - vim.lsp.buf.signature_help

gew   - set (and fetch identif and line?)
gei   - refech set identif

gei  - is for lines only
      gei PrintVimOrLuaLine()<cr>
      gej PrintVimOrLuaParag()<cr>

      use 'gei' on the following line to run a vim expression or command (note the ":" as 3rd char!)
" :hi Directory

gwj  - RunTerm_showFloat()<cr>
gwJ  - RunTerm_parag_showFloat()<cr>
       note the concatenates the paragraph lines with ' ', not '\n'. which works with psql -c "..." but not with bash?
,gwj  - TermOneShotFloat( getline('.') )<cr>
<leader>gwj  - TermOneShot( getline('.') )<cr>
,gwt | gwT - GetLineFromCursor terms

## test an httpApp / routes in http4s ember server
<leader>gss :call Scala_SetServerApp_ScalaCLI()<cr>
<leader>gsr :call Scala_ServerRestart()<cr>
,,gsr :call Scala_ServerRestartTerm()<cr>
<leader>gsS :call Scala_ServerStop()<cr>

# gel edgedb maps
gej     - eval parag
,gej    - show object uuid in query result
get     - describe object
gsk     - show object fields
gsF     - show all inner object fields
gec     - object count
<leader>K     - describe schema

## thin fonts 
~/Documents/Notes/vim_works.md#/#%20alacritty%20fork

ok, i have now decided to use
=> thin & pale fonts in alacritty 0.12.0 rc2
    using this terminal command: 
    defaults write org.alacritty AppleFontSmoothing -int 0
instead of
- thicker, blurred and bright/fresh colored fonts in alacritty 0.10.0

# search websites (Google, Github, Scaladex?)
<leader>gso/O    - on visSel or cword or input() works well for Gitub repos, code, Google, etc?
~/.config/nvim/plugin/HsAPI-searchSites.vim#/Search%20Params

## github search
i made some scripts
general pattern:
https://github.com/search?q=user%3Araquo+duplicate+ids&type=issues

## vim substitute replace text
\r<motion>   - replaces last pattern (set with visual select //)   ~/.config/nvim/plugin/search-replace.vim#/func.%20ReplaceLastPattern.%20motionType,
.+1,127substitute/\.scala//g


# syntax treesitter semantic hightlights inspect
" use :Inspect 
nnoremap <leader><leader>ti :Inspect<CR>
nnoremap <leader><leader>tI :Inspect!<CR>
" NOTE there's also <leader><leader>ts/S for treesitter syntax inspect

do the same:
-- vim.show_pos()
-- vim.inspect_pos()

<leader><leader>bn :echo GetSyntaxIDAtCursor()<cr>

## vim completion options / nvim-cmp
nvim cmp in the vim command menu:
NOTE: to accept the currently selected menu entry *without* running it right away:
<c-h>  - to accept the currently selected menu entry

are here: ~/.config/nvim/plugin/setup-lsp.lua#/option%20=%20{
there are a lot of completion sources: https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources#buffer--vim-builtin-functionality

### isKeyword option
is now used by nvim-cmp
@,48-57,/,.,-,_,+,,,#,$,%,~,=
@,48-57,_,192-255
a-z,A-Z,48-57,_,.,-,>

## copilot
<c-o>   - suggest
<c-j>   - accept
<c-u>   - next
<c-c>   - cancel

/Users/at/.config/nvim/plugin/setup-lsp.vim


## free maps
go, gp  - were discontinoued in favour of gsf gsF
]/]g  - is free!
g]/[  - using this for return statements now
gn    - is free!

",t" is too ergonomic to be used new tab

<leader>od  - is dirvish! currently
<leader>f   - quite free

  -- ',svh', function()
  -- '<leader>fh', function()
  'gsh', function()

search for '" nnoremap' (using vi' & gsr) - commented / deprecated maps, e.g. the haskell/purescript align maps
,c    - 

## Window, Buffer Navigation
~/.config/nvim/plugin/utils-navigation.vim‖*Windows
<c-w>L/H/K/J    - jump to right/left/top .. most window
<leader><c-w>L/H/K/J  - push to right/left/top .. most position
<c-w>S l/h/k/j  - Shift (copy) to adjacent win
<c-w>x l/h/k/j  - swap with adjacent win
<c-w>d lhkj - close adjacent win
<c-w>d t/T - close next/prev tab
<c-w>dd    - close other windows in current tab
<c-w><c-r>   - rotate windows
_
<leader>wp[ap/af] - pin a function/paragraph (or imports) to the top
_
<c-w>p - jump win back
<c-w>i - jump into float-win
<c-w>I - resize/fit floatwin height width
_
\t] - TabmoveRight /Left (this works with . repeat command!)

## copy file path and links [2025-08]
<leader>cp/P           - copy filepath local/global
<leader>cl/L           - copy linkPath local/global
<leader><leader>cl/L   - copy linkPath linepos local/global
<leader>cs             - (deprecate)

## copy, move, delete files / buffers
<leader>db   - delete the current buffer (:bd<cr>)
<leader>dd   - in neo-tree  / divish

## set local-, tab- and global cwd

in [a file], [neo-tree], [dirvish]:

<leader>cd             - is the "prefix" for all maps!
     p/n/s       - is the source for the new cwd: 
                       p - parent folder (file and dirvish) / 
                       n - node (in tree) / 
                       s - search next project (in file)
           l/t/g - is the scope of the new cwd: local, tab, global

NOTES:
  - setting a tab or global (tcd, cd) cwd in a window will set all windows in the current tab to the same cwd and scope!
  - use echo getcwd( winnr() ) to get the valid cwd for the current win!
  - the u/update scope map in treeview is not yet clear
  - this is really the global cwd, disregarding the window and tab one: echo getcwd(-1,-1)
  - TODO: how to reset a local cwd to the global one? e.g. i have used <leader>cdsl in a win. but how to go back to the project global cwd?

<leader>cd l/t/g   - 

### set cwd from a file / window
<leader>cdG    - set the global cwd to the cwd of the current window :cd getcwd()
<leader>cdsl   - search a repo to set the win local cwd
<leader>cdst   - search a repo to set the tab(!!) local cwd

(TODO/issue: only '<leader>cdsl' allows to use '<leader>gs' for neo-tree show-file. '<leader>cdpt' in dirvish does not?)

In neo-tree:
<leader>cdpl - TreeRoot', 'local'
<leader>cdpt - TreeRoot', 'tab'
<leader>cdpg - TreeRoot', 'global'
<leader>cdpu - TreeRoot', 'update'
<leader>cdnl - Node', 'local'
<leader>cdnt - Node', 'tab'
<leader>cdng - Node', 'global'
<leader>cdnu - Node', 'update'

### Set local cwd of .md file (with commands)
there's no direct/shorter way I think(?)
<leader>cp   to copy the file location, also
,,sn   in the file
-      to go up to the Proj folder
<leader>cdpl to set the local cwd to the root path of the tree
<c-w>,v  to have the file with the new cwd in a new window.

## use del / trash

trash --help
trash -l

ls
touch zwei
del zwei
trash eins

# Printer & Examples.md
Examples.md was at m/_printer/Examples.md now at the root.

<leader>ces   - at a code heading to add a reference to a runnable example
<leader>cea   - add name and link to identifier
                NOTE: for "unmatched" errors look here: ~/.config/nvim/plugin/utils/NewBuf-LinkPaths.vim‖/NOTE:ˍthisˍ
to rerun the example:
<c-w>l s/v/o  - on an identif, then:

gew/W, gei/I - to activate & run it as either a printer or printerServer identif

TODO: could add/relate "frontend printer" identifiers 

IDEA: could add a vis-sel as selective context for aider.

# ExamplesLog.md
<leader>oex   - show ExamplesLog.md 
<leader>ces   - Example_SetStart
<leader>cea   - Example_AddIdentif
<leader>cea   - Example_AddVisSel

# Frequent files quick maps
<leader>oex   - show ExamplesLog.md 
<leader>oel   - ExampleLinks.md
<leader>op    - package.json
<leader>or    - README.md
<leader>oc    - claude.md
<leader>oC    - ~/.claude/claude.md
<leader>oev   - .env
<leader>oi    - .gitignore
<leader><leader>oc    - parrot ai chats

TODO should this be more consitent with harpoon?

# Harpoon file list manager
~/.config/nvim/plugin/config/harpoon.lua
~/.config/nvim/plugged/harpoon/README.md

<leader>oh     - show harpoon win
<leader>oH     - show ExampleLinks.md file (note both are linked and can be edited)
<leader>oE     - same as above just to relate to the next map ->
<leader>oex    - show ExamplesLog.md 

<leader>ah/a   - add current file
]a/[a          - next/prev file
<leader>oh/af  - view list. use dd, <c-w>l o/v/p
gsh            - telescope picker with file preview. use <c-w>o/v/p to open. and m, <c-q> for quickfix export.
,1/2/3         - jump to index file (and recent pos)
<c-w>l p       - in harpoon win to jump to the link. (note the above jumps to recent pos)
<leader>ad     - remove current file
,d1/2/3        - remove index

## save a diagram screenshot
mv '/Users/at/Documents/Screenshot 2024-02-15 at 18.07.31.png' m/h4s_simple/d_myimdb.png
in tree use <leader>Os to view the screenshot
open m/h4s_simple/d_myimdb.png

# Open Urls and filepaths in chromium, chrome and media viewers
glc   - is now smart to use either a url or a (relative) path in the line
        ~/.config/nvim/plugin/tools-external.vim‖/LaunchChromium_UrlOrPath()
glv   - show videos or images using vmp
        ~/.config/nvim/plugin/tools-external.vim‖/ViewInMpv(ˍfileP

## chrome / chromium maps

there are now "next window" maps defined here:
~/.config/karabiner/karabiner.json

<c-w>

# nvim version update
~/Documents/Notes/vim_works.md‖/#ˍnvimˍneov

-- codeLens issue 2024-05: method textDocument/codeLens is not supported by any of the servers registered
-- similar to https://github.com/elixir-tools/elixir-tools.nvim/issues/211
-- ~/.config/nvim/plugged/nvim-metals/lua/metals/handlers.lua‖/lsp.codelen
