augroup ftdetect_mdx
  autocmd!
  " Use setf so it won’t override a manually set filetype
  autocmd BufRead,BufNewFile *.mdx setf markdown.mdx
augroup END

