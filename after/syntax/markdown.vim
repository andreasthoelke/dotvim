" Custom syntax additions for markdown
" NOTE: Google Docs link concealment moved to after/ftplugin/markdown.vim
" for better compatibility with vim-markdown plugin

" Treat blank-line-prefixed two-space indentation like a Markdown code block.
" This mirrors the built-in four-space rule so the custom two-space shifts
" still pick up the same block styling and syntax group.
syntax region markdownCodeBlock start="^\n\( \{2,}\|\t\)" end="^\ze \{,1}\S.*$" keepend
