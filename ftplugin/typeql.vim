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

func! s:PrevNonBlankNonComment(lnum)
  let i = a:lnum - 1
  while i > 0
    if getline(i) !~# '^\s*$' && getline(i) !~# '^\s*#'
      return i
    endif
    let i -= 1
  endwhile
  return 0
endfunc

func! TypeQLIndent()
  let lnum = v:lnum
  let prevlnum = prevnonblank(lnum - 1)
  let keywordpattern = '\v^\s*(match|insert|reduce|delete|fetch)>'
  
  " First line or line starts with keywords = no indent
  if lnum == 1 || prevlnum == 0 || getline(lnum) =~# keywordpattern
    return 0
  endif
  
  " Get previous non-blank, non-comment line
  let prev_content_lnum = s:PrevNonBlankNonComment(lnum)
  
  " No previous content line = first line of file
  if prev_content_lnum == 0
    return 0
  endif
  
  " Check if there's a gap (blank or comment lines) before current line
  let last_non_blank = prevnonblank(lnum - 1)
  if last_non_blank != prev_content_lnum && getline(last_non_blank) =~# '^\s*#'
    " Previous non-blank is comment, new paragraph
    return 0
  endif
  
  " After blank line = new paragraph, no indent
  if lnum - 1 != prevlnum
    return 0
  endif
  
  " Previous line ends with semicolon = keep same indent
  let prev_line = getline(prevlnum)
  if prev_line =~# ';\s*$'
    return indent(prevlnum)
  endif
  
  " Previous line is comment = skip it
  if prev_line =~# '^\s*#'
    return 0
  endif
  
  " Previous line is paragraph start = indent
  if prevlnum == 1 || prev_line =~# keywordpattern || prevlnum - 1 != prevnonblank(prevlnum - 1)
    return 2
  endif
  
  " Keep current indent
  return indent(prevlnum)
endfunc



