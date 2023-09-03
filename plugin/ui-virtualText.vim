
" Specific Neovim features: nvim_buf_add_highlight nvim_buf_set_virtual_text

" Conceal: TODO

" Get syntax group id
" echo synIDattr( synID( line('.'), col('.'), 0), 'name' )

func! VirtualHighlightMatchedStrings( searchList )
  let bufferLines = getline( 0, "$" )
  let lineNumsMatched = FindList( bufferLines, a:searchList )

  let ns = nvim_create_namespace( "MatchedStrings" )
  let bn = bufnr('')

  call nvim_buf_clear_namespace( bn, ns, 0, line('$') )

  for lineNum in lineNumsMatched
    " call nvim_buf_set_extmark( bn, ns, lineNum -1, -1, [['<<', 'CommentMinusCursive']])
    call nvim_buf_set_virtual_text( bn, ns, lineNum, [["« ", 'CommentMinusCursive']], {})
  endfor
endfunc

" VirtualHighlightMatchedStrings( ['" abcd', 'endfunc'] )
" VirtualHighlightMatchedStrings( ['" axcd', 'endfunc'] )
" abcd
" axcd


func! VirtualRadioLabel( label )
  let ns = nvim_create_namespace( a:label )
  let bn = bufnr('')

  " Clear all virtual text of this label
  call nvim_buf_clear_highlight( bn, ns, 0, -1)
  call v:lua.vim.api.nvim_buf_del_extmark( bn, ns, 1 )

  call nvim_buf_set_virtual_text( bn, ns, line('.') -1, [[a:label, 'CommentSection']], {})
endfunc

func! VirtualRadioLabel_lineNum( label, lineNum )
  " let ns = nvim_create_namespace( a:label )
  let ns = nvim_create_namespace( "PrinterLabels" )
  let bn = bufnr('')

  " Clear all virtual text of this label
  call nvim_buf_clear_highlight( bn, ns, 0, -1)
  call v:lua.vim.api.nvim_buf_del_extmark( bn, ns, 1 )

  " call nvim_buf_set_virtual_text( bn, ns, a:lineNum -1, [[a:label, 'CommentSection']], {})
  call nvim_buf_set_virtual_text( bn, ns, line('.') -1, [[a:label, 'CommentMinusCursive']], {})
endfunc

" NVim Virtual Text: ------------------
if has('nvim-0.3.2')
  let g:nsid_def = nvim_create_namespace('default')
endif

function! VirtualtextClear()
  let l:buffer = bufnr('')
  call nvim_buf_clear_highlight(l:buffer, g:nsid_def, 0, -1)
  call v:lua.vim.api.nvim_buf_del_extmark( l:buffer, g:nsid_def, 1 )
endfunction

func! VirtualtextShowMessage(message, hlgroup)
  let l:cursor_position = getcurpos()
  let l:line = line('.')
  let l:buffer = bufnr('')
  call nvim_buf_set_virtual_text(l:buffer, g:nsid_def, l:line-1, [[a:message, a:hlgroup]], {})
endfunc
" VirtualtextShowMessage( 'a test', 'CommentSection' )

func! VirtualTextShow( lineNum, msg )
  call nvim_buf_set_extmark( bufnr(), g:nsid_def, a:lineNum -1, [[a:msg, 'CommentSection']], {})
endfunc
" VirtualTextShow( line('.'), "hi" )
" v:lua.VirtualTxShow( 55, 'eins2', 'right_align' )

func! VirtualtextShowMessage_off(message, hlgroup) " ■
  let l:cursor_position = getcurpos()
  let l:line = line('.')
  let l:buffer = bufnr('')
  " let opts = {'end_line':
  call nvim_buf_set_virtual_text(l:buffer, g:nsid_def, l:line-1, 4, {})
  " call nvim_buf_set_extmark(l:buffer, g:nsid_def, l:line-1, [[a:message, a:hlgroup]], {})
endfunc " ▲

" call VirtualtextShowMessage( 'hi there', 'Comment' )
" call VirtualtextClear()

" call VirtualtextShowMessage('← some ∷ sig ⇒ nd (s)', 'SpecialKey')
" call VirtualtextShowMessage('← some ∷ sig ⇒ nd (s)', 'Folded')
" call VirtualtextShowMessage('← some ∷ sig ⇒ nd (s)', 'WildMenu')

" Multiple text chunks would allow to recreate syntax highlighting
" call nvim_buf_set_virtual_text( bufnr(''), g:nsid_def, line('.'), [[ '⇒ first ∷ ', 'Folded'], [ 'sec ← (nd)', 'WildMenu']],)
" Shows Demo Here: →

" Example for nvim_buf_add_highlight: Highlight/mark the char under the cursor
nnoremap <leader>mc :call nvim_buf_add_highlight( bufnr(''), g:nsid_def, 'WildMenu', line('.')-1, getcurpos()[2]-1, getcurpos()[2])<cr>
" vnoremap <leader>mv :call HighlightVisualSelection(0)<cr>
" Clear nvim virtual highlights and text
nnoremap <leader>cv :call VirtualtextClear()<cr>
nnoremap ,cc :lua VirtualTxClear()<cr>

function! HighlightVisualSelection( idx )
  let l:highlights = [ 'Normal', 'BlackBG', 'Visual', 'WildMenu' ]
  " Todo: This check is not working
  " let l:idx = (a:idx == 0) ? inputlist( l:highlights ) : a:idx
  " let l:idx = a:idx ? a:idx : inputlist( l:highlights )
  if a:idx == 0
    let l:idx = inputlist( l:highlights )
  else
    let l:idx = a:idx
  endif
  " Destructuring the 4 item position array
  let [l:lineNumStart, l:columnStart] = getpos("'<")[1:2]
  let [l:lineNumEnd,   l:columnEnd]   = getpos("'>")[1:2]
  call nvim_buf_add_highlight( bufnr(''), g:nsid_def, l:highlights[ l:idx ], l:lineNumStart-1, l:columnStart-1, l:columnEnd)
endfunction
" call nvim_buf_add_highlight( bufnr(''), g:nsid_def, 'Search', line('.')-3, 1, 100)

" Flash Highlight A Region: Note the nvim highlight does not easily work across lines
" call highlightedyank#highlight#add( 'HighlightedyankRegion', getpos("'<"), getpos("'>"), 'char', 1000)

" vnoremap <leader>ab :<c-u>echo getpos("'<")<cr>
" vnoremap <leader>ab :<c-u>echo getpos("'>")<cr>

