# Search Operations Exercise

This exercise helps practice the advanced search operations in your Neovim setup.

## Prerequisites
- Familiarity with basic Vim search (/, ?)
- Understanding of your custom keymaps for searching

## Exercise 1: File Search Operations

**Goal**: Practice searching for files using different methods

1. Use `gsf` to search for files in the current project
   - Find "categories.md" in the keymaps directory
   - Find "vim-cheat-sheet_2025-05.md"

2. Use `gsd` to search specifically for directories
   - Find the "keymaps" directory
   - Find the "plugin/config" directory

3. Use `gsp` to access recently used files
   - Navigate to a file you've recently edited

**Success Metrics**:
- Find each target file in under 5 seconds
- Learn to refine your search when there are many results

## Exercise 2: Buffer Content Search

**Goal**: Practice searching within the current buffer efficiently

1. Open "vim-cheat-sheet_2025-05.md"

2. Use `gsc` to search within the current buffer
   - Search for "git diff"
   - Search for "telescope"
   - Try using regex in your search (e.g., "^# ")

3. Use `gs;` to search only within headings
   - Search for "git"
   - Search for "search"

**Success Metrics**:
- Notice the difference in results between `gsc` and `gs;`
- Navigate to at least 5 different locations using these searches

## Exercise 3: Symbol Search

**Goal**: Practice searching for code symbols

1. Open a code file (e.g., a Lua file in plugin/config/ or lua/utils/)

2. Use `gsl` to search LSP symbols in the file
   - Find function definitions
   - Find variable declarations

3. Use `ge;` to find main symbols in the current file
   - Notice how the results differ from `gsl`

4. Use `ge:` to find symbols across your repo
   - Search for a common function name

**Success Metrics**:
- Understand the differences between these symbol search methods
- Successfully navigate to at least 3 different symbols

## Exercise 4: Advanced Search Workflows

**Goal**: Practice realistic search workflows combining multiple techniques

1. Word-under-cursor search:
   - Place cursor on a common word like "search" or "telescope"
   - Use `gsr` to find all occurrences in the project
   - Navigate between results using the appropriate keys

2. AST pattern search:
   - In a Lua file, place cursor on a function call
   - Use `gst` to find similar patterns
   - Try entering a pattern like "require('$$$')" to find all require statements

3. Special collections search:
   - Use `l sfc` to search AI chat history topics
   - Use `l sfn` to search notes topics

**Success Metrics**:
- Complete each search workflow in under 30 seconds
- Navigate between multiple results efficiently

## Exercise 5: Search and Action Integration

**Goal**: Practice combining search with follow-up actions

1. Find and open:
   - Use `gsf` to find a file
   - Open it in a split with `<c-v>`
   - Open another file in a new tab with `<c-t>`

2. Symbol workflow:
   - Find a symbol with `ge;`
   - Use `ger` to find references to that symbol
   - Use `]q [q` to navigate between references

**Success Metrics**:
- Smoothly transition between search and navigation actions
- Maintain context awareness throughout the workflow

## Notes
- Record which search operations you use most frequently
- Note any search capabilities you wish you had but don't currently
- Watch for patterns where you use search inefficiently

## Next Steps
- Consider remapping any awkward search keymaps
- Create custom searches for your most common patterns
- Explore telescope's advanced options by pressing `?` in a search window