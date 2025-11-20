# Google Docs Sync for Neovim

Integration for syncing markdown files with Google Docs, with clean UI and concealment features.

## Features

- ✅ Push/pull markdown files to/from Google Docs
- ✅ Styled, concealed Google Doc links in markdown files
- ✅ Interactive list of recent Google Docs with clickable URLs
- ✅ Remove integration with smart file search
- ✅ Clean ANSI-stripped output

## Commands

| Command | Description |
|---------|-------------|
| `:GDocPush` | Push current markdown file to Google Docs |
| `:GDocPull` | Pull Google Doc to current file |
| `:GDocList` | List recent Google Docs (press `dd` to manage) |
| `:GDocUpdateLink` | Add/update styled Google Doc link |
| `:GDocRemove` | Remove integration from current file |
| `:GDocRemove!` | Open Google Doc in browser |

## File Format

Markdown files with Google Docs integration contain:

```markdown
---
gdoc_id: 1ABC...XYZ
---

<small><a href="https://docs.google.com/document/d/1ABC...XYZ/edit">📄 Google Doc</a></small>

# Your Content
```

**In the editor:** The HTML link is concealed and appears as just `📄 Google Doc`

**In preview:** The link is clickable and styled small

## GDocList Features

When you run `:GDocList`, you get a split window with:
- Clickable markdown links to all recent Google Docs
- Press `dd` on any line to:
  - **Remove from local files** - Searches current directory for markdown files with that gdoc_id and removes integration
  - **Open in browser** - Opens the Google Doc
  - **Cancel**

## Default Keymaps

In markdown files (configured in setup):
- `<leader><leader>dp` - Push to Google Docs
- `<leader><leader>df` - Pull from Google Docs
- `<leader><leader>dl` - List Google Docs

## Files Modified

### Core Functionality
- `lua/gdoc_sync.lua` - Main sync logic and all commands

### UI Enhancements
- `after/ftplugin/markdown.vim` - Conceals HTML Google Doc links
- `after/syntax/markdown.vim` - Placeholder for syntax customization

## How It Works

1. **Frontmatter**: YAML frontmatter stores the `gdoc_id` for sync operations
2. **Styled Link**: HTML link provides clickable access in preview, concealed in editor
3. **Smart Search**: When removing integration, searches directory tree for files with matching gdoc_id
4. **Clean Output**: ANSI color codes stripped from `gdoc` script output

## Setup

The module is initialized in your nvim config with:

```lua
require('gdoc_sync').setup({
  push_key = '<leader><leader>dp',  -- optional, customize keymaps
  pull_key = '<leader><leader>df',
  list_key = '<leader><leader>dl'
})
```

## Requirements

- `gdoc` script in PATH (~/.config/utils_global/gdoc)
- `rclone` configured with 'gdrive' remote
- See: ~/.config/utils_global/gdoc_README.md for setup

## Concealment Settings

The concealment requires:
- `conceallevel=2` (set automatically)
- `concealcursor=nc` (conceals except in current line in normal/visual mode)

To see the full HTML when editing, just move your cursor to that line.

## Troubleshooting

**Link not concealed?**
- Check `:set conceallevel?` (should be 2)
- Reload buffer: `:e`

**Matches not added?**
- Check `:echo getmatches()` (should show Conceal patterns)
- Manually run: `:call s:SetupGDocConceal()`

**Can't find local files with dd?**
- The search starts from current working directory (`:pwd`)
- Use `:cd` to change to your notes directory if needed
