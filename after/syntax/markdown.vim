" Custom syntax additions for markdown
" Conceal Google Docs link - show only the emoji and text

" Match the full HTML structure and conceal everything except the link text
syntax region gdocLink matchgroup=Conceal start='<small><a href="https:\/\/docs\.google\.com\/document\/d\/[^"]\+">' end='<\/a><\/small>' concealends contains=gdocLinkText
syntax match gdocLinkText /📄 Google Doc/ contained

" Set conceallevel if not already set
if &conceallevel == 0
  setlocal conceallevel=2
endif
