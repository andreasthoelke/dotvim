" Set consistent indentation for TypeQL
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab

echo "hi there"
" Custom formatoptions for TypeQL
setlocal formatoptions=tcqln

" Custom indent expression for TypeQL-style continuation
setlocal indentexpr=TypeQLIndent()

function! TypeQLIndent()
    let prev_line = getline(v:lnum - 1)
    let curr_line = getline(v:lnum)
    
    " If previous line ends with comma, indent continuation
    if prev_line =~ ',$'
        return 2
    endif
    
    " If current line starts with closing delimiter, don't indent
    if curr_line =~ '^\s*[});]'
        return 0
    endif
    
    " Default: no indent for new statements
    return 0
endfunction

