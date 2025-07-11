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
  let prevlnum = prevnonblank(lnum - 1)
  let keywordpattern = '\v^\s*(match|insert|reduce|delete|fetch)>'
  
  " First line, no previous line, or keyword line = no indent
  if lnum == 1 || prevlnum == 0 || getline(lnum) =~# keywordpattern
    return 0
  endif
  
  let prev_line = getline(prevlnum)
  
  " Previous line is comment or after blank = new paragraph
  if prev_line =~# '^\s*#' || lnum - 1 != prevlnum
    return 0
  endif
  
  " Previous line ends with semicolon = keep same indent
  if prev_line =~# ';\s*$'
    return indent(prevlnum)
  endif
  
  " Check if previous line starts a paragraph
  if prevlnum == 1 || prev_line =~# keywordpattern
    return 2
  endif
  
  " Check if line before previous was blank/comment (paragraph start)
  let prevprevlnum = prevnonblank(prevlnum - 1)
  if prevprevlnum == 0 || prevlnum - 1 != prevprevlnum || getline(prevprevlnum) =~# '^\s*#'
    return 2
  endif
  
  " Keep current indent
  return indent(prevlnum)
endfunc



