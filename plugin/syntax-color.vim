
func! GetLangCommentStr()
  return trim( split(&commentstring, '%s')[0] )
  " This trims leadging and trailing whitespace
endfunc
" put =GetLangCommentStr()


command! SyntaxIDShow echo GetSyntaxIDAtCursor()
func! GetSyntaxIDAtCursor()
  return synIDattr( synID( line('.'), col('.'), 0), 'name' )
endfunc
nnoremap <leader><leader>bn :echo GetSyntaxIDAtCursor()<cr>


" STEP1: FIND THE SYNATX GROUP YOU WANT TO CHANGE:
" Show the syntax group(s) of the word under the cursor
" The first pasted line is the outermost syntax group eg. vimLineComment, the last line is actual syntax group/id for the work
" under the cursor, e.g. vimCommentTitle
nnoremap <leader><leader>hhsg :call SyntaxStack()<CR>
function! SyntaxStack()
  let l:synList = map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")')
  call append(line('.'),  l:synList )
endfunc

function! SynStack()
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" STEP2A: If you want a color that is already present in the in the colorscheme
" you can just find the name of the highlight group/id (see below)
" Show the syntax group and the related active highlightgroup
nnoremap <leader><leader>hhg :call SyntaxGroup()<CR>
function! SyntaxGroup()
  let l:s = synID(line('.'), col('.'), 1)
  " echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
  call append(line('.'), synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name'))
endfun
" .. and then "hi! def link syntaxGroup Highlightgroup"
" example: "highlight! def link vimCommentTitle Error"

" When modifiable is off
nnoremap <leader><leader>hhh :call SyntaxGroupEcho()<CR>
function! SyntaxGroupEcho()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" Overview of existing highlight groups:
" Show a nice output of how all the vim-highlight groups are colored
command! HighlightTest exec "source $VIMRUNTIME/syntax/hitest.vim"

" STEP2B: FIND A NICE COLOR YOU WANT TO CHANGE TO
" If you want to take a color from another coloscheme and/or modify that color
" you will need the hex-color value of that color and set up a new/custom highlight group
" Put cursor over a nice color, below pastes the highlight group/color values
nnoremap <leader><leader>hsc :call SyntaxColor()<CR>
function! SyntaxColor()
  let l:s = synID(line('.'), col('.'), 1)
  let l:hlname = synIDattr(synIDtrans(l:s), 'name')
  exec 'RedirMessagesBuf' 'highlight' l:hlname
  " exec ',ColorHighlight'
endfun

" Highligh color values in the current line
nnoremap <leader><leader>hhcc :,ColorHighlight<CR>
" TODO range mapping

" Example:
" highlight! MyTest1 guifg=#E0306F
" highlight! def link vimCommentTitle MyTest1
" highlight! def link vimCommentTitle Function

" Remove the highlighting (and related vim slowdown) of color values
nnoremap <leader><leader>hcd :ColorClear<CR>

func! GetHighlightColorVals( group )
  let output = execute('hi ' . a:group)
  let list = split(output, '\s\+')
  let dict = {}
  for item in list
    if match(item, '=') > 0
      let splited = split(item, '=')
      let dict[splited[0]] = splited[1]
    endif
  endfor
  return dict
endfunc
" From: https://vi.stackexchange.com/questions/12293/read-values-from-a-highlight-group

func! GetHiGuiColorList ( hlgroup )
  let cols = GetHighlightColorVals( a:hlgroup )
  return [ get( cols, 'guifg', '' ), get( cols, 'guibg', '' ) ]
endfunc


