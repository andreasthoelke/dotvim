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
  let keywordpattern = '\v^\s*(match|insert|reduce|delete|fetch)>'
  
  " Current line is keyword or first line = no indent
  if v:lnum == 1 || getline(v:lnum) =~# keywordpattern
    return 0
  endif
  
  " Find previous non-blank line
  let prevlnum = prevnonblank(v:lnum - 1)
  if prevlnum == 0 || v:lnum - 1 != prevlnum  " No prev line or after blank
    return 0
  endif
  
  " Find previous non-comment content line
  let contentlnum = prevlnum
  while contentlnum > 0 && getline(contentlnum) =~# '^\s*#'
    let contentlnum = prevnonblank(contentlnum - 1)
  endwhile
  
  if contentlnum == 0  " Only comments above
    return 0
  endif
  
  let content = getline(contentlnum)
  
  " Semicolon = maintain indent
  if content =~# ';\s*$'
    return indent(contentlnum)
  endif
  
  " Paragraph start = indent next line
  if contentlnum == 1 || content =~# keywordpattern || contentlnum - 1 != prevnonblank(contentlnum - 1)
    return 2
  endif
  
  " Keep previous indent
  return indent(prevlnum)
endfunc



