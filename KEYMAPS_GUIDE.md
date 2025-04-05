
# Improving Vim Processes and Related Keymaps

This document aims to develop techniques to improve my Vim processes and related keymaps.
This document should be edited by me and AI (e.g. Claude Code) to allow me to collaborate with AI in evolving/improving my vim processes.
AI should cautiously improve this doc. Improve the structure, clarity, grammar, etc.

## Table of Contents

- [Introduction](#introduction)
- [Keymap Philosophy](#keymap-philosophy)
  - [Ergonomic Models](#ergonomic-models)
  - [Classic Vim Maps](#classic-vim-maps)
  - [Mental Models](#mental-models)
  - [Evolution](#evolution)
- [Keymap Categories](#keymap-categories)
  - [Search Operations (`gs`)](#search-operations-gs)
  - [File Operations](#file-operations)
  - [View/Open Operations (`l o`)](#viewopen-operations-l-o)
  - [Development Operations](#development-operations)
- [Implementation Plan](#implementation-plan)
  - [Migration Tasks](#migration-tasks)
  - [Exercises and Tests](#exercises-and-tests)
  - [Cheat Sheets](#cheat-sheets)
  - [Hint Strategies and Tools](#hint-strategies-and-tools)
- [Current Process](#current-process)
- [Next Steps](#next-steps)

## Introduction

This guide documents my Vim keymap system, its underlying principles, and my process for evolving it. The goal is to create an efficient, ergonomic, and memorable mapping system that enhances my workflows.

## Keymap Philosophy

### Ergonomic Models

There are some patterns in my keymaps that are easy for me to type. E.g. 'gei' (for "run Printer") or 'l gd' for "show git diff".

For AI to understand my ergonomic preferences I should write up some rules here.
One obvious general rule might be that:
- Longer key sequences are harder to type.
- I use a classic (typewriter) 10 fingers touch typing technique, so fingers correspond with specific keys.
- The keys for 'g' and 'b' are covered by the index finger of the left hand.
- The keys 'asdfg' (left hand) and 'hjkl;' (right hand) are on the 'base row/position' and are generally very easy to type/reach since fingers don't have to move much.
- Keys like '`', '1', '-', '\', '=' are far from the fingers' base position and are harder to type.

### Classic Vim Maps

I try to adhere to the vim default patterns to some degree. E.g. 'y' is for 'yank'/'copy'.
But my personal ergonomic needs and mental models often take precedence over the classic vim maps.

### Mental Models

#### Mnemonics

Example: In
- 'gsf' - local file search
- 'gsF' - global file search (across projects)

I use the capital letter for the 'bigger' domain. Capital letters are also harder to type.
I also tend to use capital letters to 'negate' a map or turn something off (though I can't think of an example).

Sometimes there are different *versions* of commands. To reflect this, I sometimes prepend a leader or ',' to the map.
Example: 'gei' means 'run printer and show result in floating window' whereas 'l gei' (leader gei) means 'run printer and show result in terminal window'.

- 'l o..' / leader 'o' maps tend to 'open' something. Like 'l ot' opens the symbols outline, 'l os' opens the 'scratch2023' file, or 'l oa' opens the neo-tree.
- 'gs' keymaps are 'go search' maps.

### Evolution

I'm constantly evolving my maps based on new tasks. 

As an example, given 'gs' keymaps are 'go search' maps, when I come up with new needs to search e.g. inside comments a logical extension of my maps would be to use 'gsc'. But I already use 'gsc' to search only in the current buffer (full) text. I do this very often in practice, and 'gsc' is very ergonomic for me to type.

Whereas I have rarely had the need to limit my search to only text in comments. So this infrequent use-case would not justify occupying a very ergonomic map.

Since I use the 'search in comments' map so infrequently I tend to forget it. In this case it might even be better to 'deprecate' the map so I don't have to maintain the code/implementation of the map (note that each map has a "cost" of learning and maintaining the implementation).

There might be a more 'low level' approach to do the same task when it comes up, e.g. I could simply use the telescope reg-ex search to enter the comment string of the current language, e.g. "# " for python, plus "*" to search single line comment. However, note that in this case this would perhaps *not* be a good solution because typing a reg-ex for python multi-line comments would be prohibitive in a workflow.

## Keymap Categories

### Search Operations (`gs`)
- `gsf` - Local file search
- `gsF` - Global file search (across projects)
- `gsc` - Search in current buffer full text
- `gs;` - Search inside headings

### File Operations
<!-- To be filled in -->

### View/Open Operations (`l o`)
- `l ot` - Open symbols outline
- `l os` - Open scratch2023 file
- `l oa` - Open neo-tree

### Development Operations
- `gei` - Run printer and show result in floating window
- `l gei` - Run printer and show result in terminal window
- `l gd` - Show git diff

## Implementation Plan

### Migration Tasks

Given we have identified a strategy to improve the status quo of the maps we might want to keep track of related smaller / incremental tasks.

### Exercises and Tests

AI could set up "KEYMAPS_exercise_<label>.md" buffers. This would be focused training runs I would walk through. This might also double down as *Tests* for these maps.

Btw, I'm not sure and have made no efforts to have integration tests for all my vim processes. I'm not sure this would add a lot of value in my case, since the costs of me discovering a 'bug' in my usual 'work flow' are not too high.

### Cheat Sheets

This is what I currently have in ~/Documents/Notes/scratch2023.md.
I usually search in this file using 'gs;' (inside headings) and 'gsc' (full text).

### Hint Strategies and Tools

There are popular vim hint tools. E.g. when I pause typing they would show me potential continuations for the key sequence. I think 'spacemacs' (?) made this popular? However, I'm not sure I should adopt this.

## Current Process

1. Thinking about a task/workflow
2. Searching for related keymaps/commands/code using 'l vm' or 'gsg' telescope search 
3. Potentially changing or implementing a map
4. Practicing the map in the given task/workflow

## Next Steps

- Create a comprehensive inventory of all existing keymaps
- Evaluate ergonomics of most frequently used operations
- Identify candidates for optimization or remapping
- Develop a consistent naming convention for new maps
- Consider organizing keymaps into a separate directory structure:
  - `keymaps/ergonomics.md`
  - `keymaps/categories.md`
  - `keymaps/exercises/`

---

**Additional Resources**

Maps vs tools: There are different file browsers and workflows for how I achieve specific objectives.

Future analysis could include:
- ~/Documents/Notes/scratch2023.md
- Other .md files
- A list of keymap related vim files

