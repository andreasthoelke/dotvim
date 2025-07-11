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
  
  " After blank line = new paragraph
  if lnum - 1 != prevlnum
    return 0
  endif
  
  " Find previous non-comment line
  let contentlnum = prevlnum
  while contentlnum > 0 && getline(contentlnum) =~# '^\s*#'
    let contentlnum = prevnonblank(contentlnum - 1)
  endwhile
  
  " No non-comment line found = new paragraph
  if contentlnum == 0
    return 0
  endif
  
  let content_line = getline(contentlnum)
  
  " Previous non-comment line ends with semicolon = keep same indent
  if content_line =~# ';\s*$'
    return indent(contentlnum)
  endif
  
  " Check if content line starts a paragraph
  if contentlnum == 1 || content_line =~# keywordpattern
    return 2
  endif
  
  " Check if line before content was blank (paragraph start)
  let before_content = prevnonblank(contentlnum - 1)
  if before_content == 0 || contentlnum - 1 != before_content
    return 2
  endif
  
  " Keep current indent
  return indent(prevlnum)
endfunc



