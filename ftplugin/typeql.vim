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

function! TypeQLIndent()
    let prev_line = getline(v:lnum - 1)
    let curr_line = getline(v:lnum)
    let prev_indent = indent(v:lnum - 1)
    
    " Skip empty lines - find the last non-empty line
    if prev_line =~ '^\s*$'
        let lnum = v:lnum - 2
        while lnum > 0 && getline(lnum) =~ '^\s*$'
            let lnum = lnum - 1
        endwhile
        if lnum > 0
            let prev_line = getline(lnum)
            let prev_indent = indent(lnum)
        endif
    endif
    
    " If previous line is a comment, maintain same indentation
    if prev_line =~ '^\s*#'
        return prev_indent
    endif
    
    " If previous line is a TypeQL keyword alone, indent the following lines
    if prev_line =~ '^\s*\(match\|insert\|define\|update\|delete\|fetch\|get\|rule\|when\|then\)\s*$'
        return prev_indent + &shiftwidth
    endif
    
    " If previous line ends with comma OR semicolon, maintain current indentation
    " This ensures continuation lines stay aligned
    if prev_line =~ '[,;]\s*$' && prev_indent > 0
        return prev_indent
    endif
    
    " If current line starts with a closing bracket, decrease indent
    if curr_line =~ '^\s*[}\])]'
        return prev_indent - &shiftwidth
    endif
    
    " If previous line opens a bracket, increase indent
    if prev_line =~ '[{\[(]\s*$'
        return prev_indent + &shiftwidth
    endif
    
    " If we're in an indented block, maintain indentation
    " unless current line starts a new top-level statement
    if prev_indent > 0
        " Check if current line starts a new top-level statement
        if curr_line =~ '^\s*\(match\|insert\|define\|update\|delete\|fetch\|get\|rule\)\s*$'
            return 0
        endif
        " Otherwise maintain the indentation
        return prev_indent
    endif
    
    " Default: start at beginning of line
    return 0
endfunction

" Source additional TypeQL configurations if available
if exists('*TypeQLSyntaxAdditions')
    call TypeQLSyntaxAdditions()
endif

" Set up buffer mappings if available
if exists('*TypeDB_bufferMaps')
    call TypeDB_bufferMaps()
endif

