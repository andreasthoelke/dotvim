" Conceal Google Docs links
" Use autocmd to persist matches across window changes

" Set conceallevel
setlocal conceallevel=2
setlocal concealcursor=nc

" Keep Markdown shifts aligned with the rest of this config so >j, >>, >}
" and the matching < motions use two spaces.
setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

function! s:EnsureTwoSpaceCodeBlockHighlight() abort
  if hlexists('@markup.raw.block.markdown')
    highlight! link MarkdownTwoSpaceCodeBlock @markup.raw.block.markdown
  elseif hlexists('@markup.raw.block')
    highlight! link MarkdownTwoSpaceCodeBlock @markup.raw.block
  elseif hlexists('Special')
    highlight! link MarkdownTwoSpaceCodeBlock Special
  elseif hlexists('mdNormHiBG')
    highlight! link MarkdownTwoSpaceCodeBlock mdNormHiBG
  elseif hlexists('markdownItalic')
    highlight! link MarkdownTwoSpaceCodeBlock markdownItalic
  else
    highlight! link MarkdownTwoSpaceCodeBlock Comment
  endif
endfunction

function! s:RefreshTwoSpaceCodeBlockHighlights() abort
  if !exists('b:md_two_space_code_ns')
    let b:md_two_space_code_ns = nvim_create_namespace('markdown_two_space_code')
  endif

  call s:EnsureTwoSpaceCodeBlockHighlight()
  call nvim_buf_clear_namespace(bufnr('%'), b:md_two_space_code_ns, 0, -1)

  let l:line_count = line('$')
  let l:in_block = 0

  for l:lnum in range(1, l:line_count)
    let l:line = getline(l:lnum)

    if l:in_block
      if l:line =~# '^  \S'
        call nvim_buf_add_highlight(bufnr('%'), b:md_two_space_code_ns, 'MarkdownTwoSpaceCodeBlock', l:lnum - 1, 0, -1)
        continue
      endif

      if l:line =~# '^\s*$'
        continue
      endif

      let l:in_block = 0
    endif

    if l:line =~# '^  \S' && getline(l:lnum - 1) =~# '^\s*$'
      let l:in_block = 1
      call nvim_buf_add_highlight(bufnr('%'), b:md_two_space_code_ns, 'MarkdownTwoSpaceCodeBlock', l:lnum - 1, 0, -1)
    endif
  endfor
endfunction

" Function to set up concealment
function! s:SetupGDocConceal()
  " Clear existing gdoc matches to avoid duplicates
  for m in getmatches()
    if m.group == 'Conceal' && (m.pattern =~ 'small' || m.pattern =~ 'docs')
      silent! call matchdelete(m.id)
    endif
  endfor

  " Add new matches
  call matchadd('Conceal', '\v\<small\>\<a href\="https://docs\.google\.com/[^"]*"\>')
  call matchadd('Conceal', '\v\</a\>\</small\>')
endfunction

" Set up autocmd to maintain concealment
augroup GDocConceal
  autocmd! * <buffer>
  autocmd BufWinEnter,WinEnter <buffer> call s:SetupGDocConceal()
augroup END

augroup MarkdownTwoSpaceCodeBlocks
  autocmd! * <buffer>
  autocmd BufWinEnter,WinEnter,InsertLeave,TextChanged,TextChangedI <buffer> call s:RefreshTwoSpaceCodeBlockHighlights()
augroup END

" Initial setup
call s:SetupGDocConceal()
call s:RefreshTwoSpaceCodeBlockHighlights()
