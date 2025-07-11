" Set consistent indentation for TypeQL
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab

" Custom formatoptions for TypeQL
setlocal formatoptions=tcqln

" Enable auto and smart indent
setlocal autoindent
setlocal smartindent

" Custom indent expression for TypeQL-style continuation
setlocal indentexpr=TypeQLIndent()
setlocal indentkeys=o,O,*<Return>,<>>,{,},0#,!^F

func! TypeQLIndent()
  let lnum = v:lnum
  
  " First line of file has no indentation
  if lnum == 1
    return 0
  endif
  
  " Get previous non-blank line
  let prevlnum = prevnonblank(lnum - 1)
  
  " No previous line means no indentation
  if prevlnum == 0
    return 0
  endif
  
  " Check if previous line is blank (indicating new paragraph)
  if lnum - 1 != prevlnum
    " This is the first line of a new paragraph
    return 0
  endif
  
  " Check if line before previous was blank (prev line starts paragraph)
  let prevprevlnum = prevnonblank(prevlnum - 1)
  if prevprevlnum == 0 || prevlnum - 1 != prevprevlnum
    " Previous line was first in paragraph, so indent current line
    return 2
  endif
  
  " Otherwise, maintain the indentation of the previous line
  return indent(prevlnum)
endfunc



