
# Improving Vim processes and related keymaps
This document aims to develop techniques to improve my Vim processes and related keymaps.
This document should be edited by me and AI (e.g. Claude Code) to allow me to collaborate with AI in evoling / improving my vim processes.
AI should cautiously improve this doc. Improve the structure, clarity, grammar, etc.

## Analysis

### Ergomomic models
There are some patterns in my keymaps that are easy for me to type. E.g. 'gei' (for "run Printer") or 'l gd' for "show
git diff".

For AI to understand my ergonomic preferences I should write up some rules here.
One obvious general rule might be that:
- longer key sequences are harder to type.
I use a classic (typewriter) 10 fingers tough typing technique. so fingers correspond with letters/keys on the keyboard.
based on this the keys for 'g' and 'b' are covered by the index finger of the left hand. and the keys 'asdfg' (left
hand) and 'hjkl;' (right hand) are on 'base row/position' of the fingers and a generally very easy to type/reach since
the fingers don't have to move a lot. Whereas '`' '1' '-' '\' '=' are far way from the fingers base position. those are
hard to type.

### classic vim maps
i try to adhere to the vim default patterns to some degree. e.g. 'y' is for 'yank'/'copy'.
but my personal ergonomic needs and mental models often take precedence over the classic vim maps.

### Mental models
Mnemonics
Example: In
'gsf'  - local file search
'gsF'  - global file search (across projects)
i use the capital letter for the 'bigger' domain. capital letters are also harder to type.
but i also tend to use capital letters to 'negate' a map, to turn something off. (though i can't think of an example).

sometimes there are different *versions* of a commands. to reflect this i sometimes prepend a leader or ',' to the map.
example 'gei' means 'run printer and show result in floating window' whereas 'l gei' (leader gei) means 'run printer and
show result in terminal window'.

'l o..' / leader 'o' maps tend to 'open' something. like 'l ot' opens the symbols outline. or 'l os' opens the
'scratch2023' file. or 'l oa' opens the neo-tree.

'gs' keymaps are 'go search' maps.


### Evolution
I'm constantly evolving my maps based on new tasks. 

As an example, given 'gs' keymaps are 'go search' maps, when i come up with new needs to search e.g. inside comments a logical extension of my maps would be to use 'gsc'. but I already use 'gsc' to search only in the current buffer (full) text. i do this very often in practice. and 'gsc' is very erogonompic for me to type.
Whereas i have rarely had the need to limit my search to only text in comments. so this infrequent use-case would not
justify occupying a very ergonomic map.
Since i use the 'search in comments' map so infrequently i tend to forget it. In this case it might even be better to
'deprecate' the map so i don't have to maintain the code/implementation of the map (note that each map has a "cost"
learning and maintaining the implementation)
There might be a more 'low level' approach to do the same task when it comes up, e.g. i could simply use the telescope
reg-ex search to enter the comment string of the current language, e.g. "# " for python, plus "*" to search single line
comment. however note that in this case this would perhaps *not* be a good solution because typing a reg-ex for python
multi-line comments would be prohibitive in a workflow.

### Migration tasks
Given we have identified a strategy to improve the status quo of the maps we might want to keep track of related smaller
/ incremental tasks.

### Exercises and Tests
AI could set up "KEYMAPS_exercise_<label>.md" buffers. This would be focused training runs I would walk though. This
might also double down as *Tests* for these maps.
Btw, I'm not sure and have made no efforts to have integration tests for all my vim processes. I'm not sure this would
add a lot of value in my case, since the costs of me discovering a 'bug' in my usual 'work flow' are not too high.

### Cheet sheets
This is what i currently have in ~/Documents/Notes/scratch2023.md.
i usuall search in this file using 'gs;' (inside headings) and 'gsc' (full text).

### Hint strategies and tools
There are popular vim hint tools. e.g. when i pause typing they would show me potential continuations for the key
squence. I think 'spacemacs' (?) made this popular? However i'm not sure i should adopt this.


--
Maps vs tools
e.g. there are different file browsers and workflows of how a achieve specific objectives.

could analyze:
~/Documents/Notes/scratch2023.md
other .md files.
a list of keymap related vim files.

## current process
thinking about a task/workflow
searching for related keymaps/commands/code using 'l vm' or 'gsg' telescope search 
potentially changing or implementing a map
practicing the map in the given task/workflow



