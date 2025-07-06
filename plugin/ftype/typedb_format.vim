function! TypeQLFormat()

  echo 'yes'
  setlocal iskeyword+=-

  " Get the range of lines to format
  let lnum = v:lnum
  let count = v:count
  let end_lnum = lnum + count - 1

  " Process each line in the range
  for line_num in range(lnum, end_lnum)
    let line = getline(line_num)

    " Skip empty lines
    if line =~ '^\s*$'
      continue
    endif

    " Check if this is a main declaration line (contains 'sub entity/relation/attribute')
    if line =~ '\v\s+sub\s+(entity|relation|attribute)'
      " Remove leading whitespace for main declarations
      call setline(line_num, substitute(line, '^\s*', '', ''))
      " Check if this is a property line (owns, plays, relates, etc.)
    elseif line =~ '\v^\s*(owns|plays|relates|value|abstract)'
      " Indent property lines by 2 spaces
      call setline(line_num, substitute(line, '^\s*', '  ', ''))
    endif

    " Ensure proper comma and semicolon placement
    let line = getline(line_num)
    " Remove trailing whitespace before punctuation
    let line = substitute(line, '\s*\([,;]\)\s*$', '\1', '')
    call setline(line_num, line)
  endfor

  " Return 0 to indicate we've handled the formatting
  return 0
endfunction

