# File Operations Exercise

This exercise helps practice file operations in your Neovim setup, including navigation, management, and window/buffer interactions.

## Prerequisites
- Familiarity with basic Vim buffer/window commands
- Understanding of your custom keymaps for file operations

## Exercise 1: File Tree Navigation

**Goal**: Practice navigating with Neo-tree and file pickers

1. Open Neo-tree:
   - Use `l oa` to toggle open Neo-tree
   - Navigate to the "keymaps" directory
   - Expand and collapse folders with `zo`/`zc`
   - Use `zC` to collapse all tree nodes

2. Neo-tree operations:
   - Use `o` to float view a file
   - Use `I` to toggle a folder's expansion state
   - Try `ll om` to change sort order (e.g., by modified time)

3. Close and reopen Neo-tree in float mode:
   - Close Neo-tree
   - Use `l oo` to open Neo-tree in float mode
   - Practice using `c-w i` to jump into the float window

**Success Metrics**:
- Navigate through the file tree efficiently
- Successfully use different Neo-tree operations

## Exercise 2: File Path Operations

**Goal**: Practice working with file paths

1. Path copying:
   - Open a file
   - Use `l cp` to copy the full file path
   - Use `l ct` to copy the local path
   - Paste each path to verify the difference

2. Path operations:
   - With cursor on a file path in text (e.g., in vim-cheat-sheet_2025-05.md)
   - Use `c-w l v` to open that path in a vertical split
   - Use `c-w l s` to open a path in a horizontal split
   - Use `c-w l o` to open a path in a float window

3. System operations:
   - Navigate to an image file in Neo-tree
   - Use `l Os` to open it in the macOS default app
   - Try `l Oc` on a directory to open it in VS Code

**Success Metrics**:
- Successfully manipulate file paths in different contexts
- Open files from paths embedded in text

## Exercise 3: Buffer Management

**Goal**: Practice efficient buffer management

1. Buffer navigation:
   - Open several files using `gsf`
   - Use `gb` to list all open buffers
   - Navigate between buffers using the list

2. Buffer deletion:
   - Delete a buffer with `l db`
   - In telescope buffer list, mark multiple buffers with `m` and delete with `<c-d>`

3. Buffer search:
   - Use `gsc` to search within the current buffer
   - Use `gsv` for fuzzy buffer search
   - Notice the difference in search behavior

**Success Metrics**:
- Efficiently navigate between multiple buffers
- Clean up unnecessary buffers without losing work

## Exercise 4: Window Management

**Goal**: Practice window manipulation

1. Window navigation:
   - Split the window with `<c-w>v` and `<c-w>s`
   - Navigate between splits with `<c-w>h/j/k/l`
   - Jump to edge windows with `<c-w>L/H/K/J`

2. Window manipulation:
   - Move the current window to edges with `l <c-w>L/H/K/J`
   - Resize windows with `<c-w>.` and `<c-w>,`
   - Swap windows with `<c-w>x l/h/k/j`

3. Float windows:
   - Open a file in a float window using Neo-tree's `o` command
   - Jump into the float with `<c-w>i`
   - Resize/fit the float window with `<c-w>I`
   - Jump back with `<c-w>p`

**Success Metrics**:
- Create and manage multiple window layouts
- Navigate efficiently between different window types

## Exercise 5: Working Directory Operations

**Goal**: Practice managing current working directory

1. CWD visualization:
   - Check current CWD with `:pwd`
   - Use Neo-tree to visualize the directory structure

2. Setting CWD:
   - From a file, use `l cdpl` to set local CWD to parent directory
   - In Neo-tree, use `l cdnl` to set local CWD to node
   - Check the effect on file operations like `gsf`

3. Advanced CWD:
   - Use `l cdsl` to search and set a project repo as local CWD
   - Try using different scopes (local/tab/global) to understand the differences

**Success Metrics**:
- Successfully manage working directories for different windows/tabs
- Understand how CWD affects various file operations

## Notes
- Record which file operations you use most frequently
- Note any operations that feel awkward or inefficient
- Consider how your workflow might be improved

## Next Steps
- Review file operation keymaps that feel awkward
- Consider creating custom mappings for common file workflows
- Experiment with different tree/file navigator layouts