
# Inline Values Repl (IVR)
- evaluate code in source file context
  - using the main compiler and inject a print(ed) expression
  - selected compiler command based on filetype
- using inline test declarations (nicely concealed)
  to keep text exressions in the source file (documenting the function)
- use only single line expressions (v 1) wrapped into 'print()' (last print)
- with list linewise printing (and alignment) in floating win

### 'Eval/update all' (2.0 feature)
we could get a list of test expressions from all ITDs
- related to a function
- in the whole file
dict: linenum -> expression
the print statement could the line num
we'd then have a dict: line-num -> evaluated value
we'd render this dict to virtual text

### we can use a synchronous return
let g:Test1 = system( "ls -a" )
call append('.', g:Test1)
echo systemlist( "ls -a | grep 'vim'" )
echo systemlist( "grep 'vim'", g:Test1 )

### 'Piping' through shell commands is powerful in general
echo systemlist( 'sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"', g:Test1 )

### Async
mostly complicates things a bit
jobs can have a simple callback lambda:
let g:cm = 'python "/Users/at/Documents/ML/spacy1/t1.py"'
call jobstart( g:cm, {'on_stdout' : {j,d,e->append(line('.'),d)}} )

### GetStrOfBufAndCmd
func! GetStrOfBufAndCmd ( cmd_str )
  let lines = add( getline(1, "$"), a:cmd_str )
  return join( lines, "\n" )
endfunc

call GetStrOfBufAndCmd
then prepend "python " . string of all lines
or "node " or "psci "

### Select compiler command based on filetype
python
node
purescript
typescript?
lua

also filetype dependent:
- ITD conceal
- float syntax
- list/dict linewise + alignment


--

## Example code
def add10(num):
    return num + 10

# Create inline test stub
at any point under a 'def ..'
  leader et will call CreateInlineTestDec
  it will extract fn names and mandatory params count
    look at existing declarations
  then add a testDec below the fn-def (with one blanc line)
  default params will be 0. the cursor on the first param
    could also use keyword arguments

e1_add10 = add10(0)
e2_add10 = add10(22)

## Conceal inline test declaration (ITD)
it will be concealed like this
‥ add10(0)

‥ range(0, 200)  | [2, 3, 4, 5, 6, 7]
‥ range(0, 200)  | [2, 3, 4, 5, 6, 7]
‥ add10(‥1, ‥2)  | 300

~/.config/nvim/syntax/purescript.vim#/Inline%20Tests%20conceals
## Test bindings and helper vals
the test binding can be used/referred to.
  if the var-name shows up not at the beginning of the line it will be concealed with an index
you can create helper values by editing the main fn name (here: add10 -> range)

# Evaluate the test binding and get it's value
on 'ge' the "expression of the binding" will be evaluated against the re-compiled file (see above)
so the value of the test expression will be the last printed line of the evaluated file.


## Virtual text output
the return value will always be show in virtual text

list and dict values that exceed a char-count threshold of say 20 ..
- will be truncated in the virtual text
- will additionally be shown in the float win.
-- list items and dict key-vals will be rended linewise/ with line breaks

## Float display
- for lists
- for dictionaries
just insert line breaks

This float-win has a dynamic curos pos. which is nice and not nice. ~/.config/nvim/plugin/ui-floatWin.vim#/func.%20FloatWin_ShowLines%20.
let g:floatWin_win = v:lua.vim.lsp.util.open_floating_preview( a:lines )

### syntax
but we can just pass it the language syntax!

### Interactive term
a 2.0 feature
only for interactive output (special map?)
call FloatingTerm()
call termopen( g:cm )
~/.config/nvim/plugin/utils-repl-py.vim#/func.%20PyReplStart%20..


I can use Typeinfo from lsp
lua vim.lsp.buf.hover()

plenary.lsp.override

lua print(vim.inspect(vim.tbl_keys(vim.lsp.handlers)))





