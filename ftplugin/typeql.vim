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
  let keywordpattern = '\v^\s*(match|insert|reduce|put|update|delete|fetch|fun)>'
  let schemapattern = '\v^\s*(entity|relation|attribute|rule)>'
  let commentpattern = '\v^\s*#'
  
  let currline = getline(v:lnum)
  
  " Current line is keyword, schema keyword, comment, or first line = no indent
  if v:lnum == 1 || currline =~# keywordpattern || currline =~# schemapattern || currline =~# commentpattern
    return 0
  endif
  
  " Find previous non-blank line
  let prevlnum = prevnonblank(v:lnum - 1)
  if prevlnum == 0
    return 0
  endif
  
  let prevline = getline(prevlnum)
  
  " If current line contains "}", set indent to 2
  if currline =~# '}'
    return 2
  endif
  
  " If previous line ends with "{", set indent to 4
  if prevline =~# '{\s*$'
    return 4
  endif
  
  " Look for any previous line that ends with "{" to maintain indent 4
  let checknum = prevlnum
  while checknum > 0
    let checkline = getline(checknum)
    if checkline =~# '{\s*$'
      " Found opening brace, check if there's a closing brace after it
      let closenum = checknum + 1
      while closenum < v:lnum
        if getline(closenum) =~# '}'
          " Found closing brace, use normal indent
          return 2
        endif
        let closenum = closenum + 1
      endwhile
      " No closing brace found, maintain indent 4
      return 4
    endif
    let checknum = checknum - 1
  endwhile
  
  " Default paragraph indent
  return 2
endfunc



