# Neovim Keymap Documentation Improvement Process

## Overview
This document outlines the process for cleaning up and improving the Neovim keymap documentation.

## Goals
1. Create a consistent, well-organized keymap reference
2. Remove outdated/irrelevant content (especially Scala-related)
3. Ensure accuracy by cross-referencing with actual config files
4. Improve readability and navigation

## Current Issues Identified

### Structure & Organization
- Mixed content types (keymaps, configuration notes, TODOs)
- Inconsistent section ordering
- Some sections are too long and need splitting
- No clear hierarchy or navigation structure

### Formatting Inconsistencies
- Different notation styles for keymaps:
  - `l zm  - :ZenMode`
  - `c-g h     - mcp hub`
  - `<leader>om - open Markbar`
- Inconsistent spacing and alignment
- Mixed comment styles

### Content Issues
- Scala-related content needs removal
- Outdated/deprecated maps still documented
- Missing descriptions for some maps
- Duplicate information in multiple sections

## Proposed Standards

### Keymap Notation Format
```
<key>    - <description>    [optional: command/function]
```
Examples:
- `l zm    - Toggle zen mode    :ZenMode`
- `c-g h   - Open MCP hub`
- `]c       - Next git hunk`

### Section Headers
Use consistent markdown headers with decorative lines:
```markdown
# Major Section
## Subsection
### Sub-subsection
```

### Organization Structure
1. Core Vim Operations
2. File & Buffer Management
3. Window & Tab Navigation
4. Search & Replace
5. Git Integration
6. LSP & Code Intelligence
7. AI/Assistant Tools
8. Language-Specific Features
9. Plugin-Specific Maps
10. Utilities & Miscellaneous

## Action Items for Each Section

### Phase 1: Clean & Remove
- [ ] Remove all Scala-related content
- [ ] Remove deprecated/outdated maps
- [ ] Remove duplicate information

### Phase 2: Standardize
- [ ] Apply consistent keymap notation
- [ ] Standardize section headers
- [ ] Add missing descriptions
- [ ] Fix spacing and alignment

### Phase 3: Verify & Update
- [ ] Cross-reference with maps.lua
- [ ] Cross-reference with plugin configs
- [ ] Add any missing keymaps
- [ ] Update descriptions to match actual behavior

### Phase 4: Reorganize
- [ ] Group related keymaps together
- [ ] Create logical flow between sections
- [ ] Add navigation aids (TOC, cross-references)

## Notes for Future Improvements
- Consider creating separate files for:
  - Plugin-specific keymaps
  - Language-specific keymaps
  - Custom functions/commands
- Add examples where helpful
- Include troubleshooting notes for complex maps
- Consider version/date tracking for changes