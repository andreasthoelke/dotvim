# Keymap Categories

This document organizes all keymaps into functional categories for easier reference and management.

## Navigation

### File Navigation
- `gsf` - Local file search (within project)
- `gsF` - Global file search (across projects)
- `gsd` - Directory/folder names search
- `gsD` - File browser
- `l sff` - Find directory (shows a dirvish folder)
- `l sfb` - Browse to a Proj folder first, then search its content
- `gsp` - Open recently used files
- `gP` - Open files with frecency algorithm
- `go` - Find files (hidden included)
- `l go` - Toggle neo-tree
- `gb` - List buffers

### File Management
- `l oa` - Open neo-tree
- `l oo` - Open neo-tree in float
- `l cp` - Copy file path
- `l ct` - Copy local path
- `l Os` - System open in MacOS default app
- `l Oc` - Open path in VS Code
- `c-w l v/s/t` - Open filepath in split window (right/below/tab)
- `c-w l o` - Open filepath in float

### Buffer Navigation
- `gsc` - Search in current buffer (full text)
- `gs;` - Search inside headings
- `gsl` - Search LSP symbols
- `gel` - List LSP symbols
- `ge;` - Main symbols in file
- `ge:` - Main symbols in repo and headers in Notes
- `l db` - Delete current buffer

### Code Navigation
- `gsr` - Search for word under cursor
- `gst` - AST grep for pattern matching
- `ggzr(zr)` - Expand all subfolders
- `l fs` - Find workspace symbols
- `l on` - Open LangServer browser explorer
- `l ot` - Open symbols outline

### Window Management
- `c-w L/H/K/J` - Jump to rightmost/leftmost/topmost/bottommost window
- `l c-w L/H/K/J` - Push window to rightmost/leftmost/topmost/bottommost position
- `c-w S l/h/k/j` - Shift (copy) window in direction
- `c-w x l/h/k/j` - Swap with adjacent window
- `c-w d lhkj` - Close adjacent window
- `c-w i` - Jump into float-win
- `c-w I` - Resize/fit float window

### Tabs
- `\t]` - Tab move right
- `\t[` - Tab move left
- `l ts` - Set tab name
- `l tS` - Reset tab name
- `l tu` - Toggle tab hide

## Code Operations

### Code Execution
- `gei` - Run printer and show result in floating window
- `l gei` - Run printer and show result in terminal window
- `gep` - Paste code paragraph into repl
- `gew` - Set identifier (and fetch)
- `geW` - Set server identifier
- `geI` - Restart long-runner process
- `ll sp/P` - SBT printer terminal start/stop
- `ll sl/L` - SBT long-running terminal start/stop
- `ll sr/R` - SBT reloader terminal & process start/stop
- `ll sj/J` - SBT JS client/server terminals

### LSP Operations
- `l lca` - Code action
- `l lr` - Rename symbol
- `l lgr` - Glance references
- `l lgd` - Glance definitions
- `l lgt` - Glance type definitions
- `l lgi` - Glance implementations
- `ged` - Show diagnostics (buffer trouble)
- `geD` - Show diagnostics (workspace trouble)
- `l ged` - Show diagnostics (workspace telescope)
- `ge]/[` - Next/prev error
- `ger` - Show references of symbol under cursor
- `]q [q` - Next/prev reference in workspace
- `gdo` - Go to definition in float

### Text Editing
- `zM/zR` - Close/open all folds
- `zm/zr` - Progressively close/open fold levels
- `l ehs/ehe/ehd` - Heading start/end/delete
- `l ed` - Create Scala doc comment
- `l eb` - Create Scala fewer brackets
- `l eai` - Add <n>0 to var name
- `,aJ/j` - Align text based on regex preset
- `,>` - Push shift text to the right
- `VSi/VS)/VST` - Insert surround/surround with paren/wrap with triple backticks
- `,j/k` - Jump to line forward/back

### Git Operations
- `l gd` - Show git diff
- `,gd` - Show git commits viewer
- `l ogl` - Show git history with telescope
- `l ogL` - Show git commits viewer (40 commits)
- `ggs` - Show status with diffs of all hunks
- `l ogs` - Show status with diffs of all hunks
- `l ogS` - Show lines changed per file
- `ggl/L` - Git log of current file/all files
- `l ogl/L` - Git log of current file/all files
- `ll ogl/L` - File history with vim diff view
- `l ogg` - Commit with fugitive
- `l gi` - Add file to gitignore
- `]c[c` - Next/prev git hunk
- `l hr` - Reset git hunk
- `l hs/r` - Stage/reset a hunk
- `l hp` - Preview git hunk diff

## Specialized Tools 

### Search Tools
- `l sfc` - AI Chats (Parrot) topics
- `l sfC` - AI Chats full text
- `l sfn` - Notes topics
- `l sfN` - Notes full text
- `l slh` - Local code headers
- `l slc` - Local comment texts
- `gs;` - Search inside headings
- `gsg` - Live grep
- `gsv` - Fuzzy buffer search
- `gsc` - Search bookmarks
- `gsp` - Search projects
- `gsP` - Search repo

### Terminal & HTTP
- `gwj` - Run term in float window
- `,gwj` - Run one-shot command in float
- `l gwj` - Run one-shot command in terminal
- `geh` - HTTP request
- `gej` - HTTP POST request
- `ll du` - Toggle DBUI panel
- `ll df` - Link SQL buffer to database connection

### Project Tools
- `l ls` - Load session for CWD
- `l lS` - Save session for CWD
- `ll ls` - Select session dialog
- `l oh` - Show harpoon window
- `l ah/a` - Add current file to harpoon
- `]a/[a` - Next/prev harpoon file
- `,1/2/3` - Jump to indexed harpoon file

### Document Tools
- `l zz` - Zen mode
- `l zn` - TZ Narrow (visual selection only)
- `l ces` - Set example start
- `l cea` - Add example identifier
- `l oe` - Show ExamplesLog.md
- `l n/p` - Navigate to next/prev top level heading
- `q/Q` - Next/prev heading
- `,q` - Current end marker

### Media & External Tools
- `glc` - Open URL or path in Chromium
- `glv` - Show videos or images using mpv
- `l gso/O` - Search web (GitHub, Google) with selection/word

## Map Inventory Status

- [x] Extract major categories from cheat sheet
- [ ] Complete inventory of all existing keymaps
- [ ] Categorize all keymaps according to this structure
- [ ] Identify gaps in coverage
- [ ] Identify inconsistencies or conflicts
- [ ] Prioritize maps for ergonomic optimization