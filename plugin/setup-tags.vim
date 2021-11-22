

highlight default link TagbarHighlight  Cursor

let g:tagbar_sort = 0

" ─   Auto update tags                                  ──
" Auto update the tag files. This autocmd and shell script will increamentally
" update the local tags files ("fast-tags" approach). Note this is not needed for tagbar.
" augroup tags
"   au BufWritePost *.hs !init-tags %
" augroup END

" "init-tags" is at /Users/andreas.thoelke/.local/bin/init-tags
" Code:
" setopt extended_glob
" fns=$@
" if [[ ! -r tags ]]; then
"   echo Generating tags from scratch...
"   exec fast-tags **/*.hs $fns
" else
"   exec fast-tags $fns
" fi

" make two separate map - otherwise the deleting can't be explained

" ─   MakeSectionEndMarker Demo line                    ──

" hasktags -c -a -o d2 src/Main.hs

nnoremap <leader>ta :Dispatch! hasktags -c %<cr>

" Tags: ------------
" Look upwards from the current files directory until a "tags" file is found
set tags=./tags;
" set tags=tags;/,codex.tags;/
" set tags=/,codex.tags;/
" to tell it to use the ./tags
" set tags+=tags
" set tags=./tags;,tags
" TODO: run ctags manually? how would tags work for purescript
" ctags -f - --format=2 --excmd=pattern --extra= --fields=nksaSmt myfile


" let g:tagbar_type_haskell = {
"       \ 'ctagsbin'  : 'fast-tags',
"       \ 'ctagsargs' : '-o-',
"       \ 'kinds'     : [
"       \  'm:modules:0:0',
"       \  'c:classes:0:1',
"       \  't:types:0:1',
"       \  'C:constructors:0:1',
"       \  'p:patterns:0:1',
"       \  'o:operators:0:1',
"       \  'f:functions:0:1'
"       \ ],
"       \ 'sro'        : '.',
"       \ 'kind2scope' : {
"       \ 'm' : 'module',
"       \ 'c' : 'class',
"       \ 'd' : 'data',
"       \ 't' : 'type'
"       \ },
"       \ 'scope2kind' : {
"       \ 'module' : 'm',
"       \ 'class'  : 'c',
"       \ 'data'   : 'd',
"       \ 'type'   : 't'
"       \ }
"       \ }


" let g:tagbar_type_haskell = {
"     \ 'kinds' : [
"         \ 'm:module',
"         \ 'e:exports:1',
"         \ 'i:imports:1',
"         \ 't:declarations',
"         \ 'd:declarations:1',
"         \ 'n:declarations:1',
"         \ 'f:functions',
"         \ 'c:constructors',
"         \ '?:unknown',
"     \ ],
" \ }

" let g:tagbar_type_haskell = {
"       \ 'ctagsbin' : 'lushtags',
"       \ 'ctagsargs' : '--ignore-parse-error --',
"       \ 'kinds' : [
"       \ 'm:module:0',
"       \ 'e:exports:1',
"       \ 'i:imports:1',
"       \ 't:declarations:0',
"       \ 'd:declarations:1',
"       \ 'n:declarations:1',
"       \ 'f:functions:0',
"       \ 'c:constructors:0'
"       \ ],
"       \ 'sro' : '.',
"       \ 'kind2scope' : {
"       \ 'd' : 'data',
"       \ 'n' : 'newtype',
"       \ 'c' : 'constructor',
"       \ 't' : 'type'
"       \ },
"       \ 'scope2kind' : {
"       \ 'data' : 'd',
"       \ 'newtype' : 'n',
"       \ 'constructor' : 'c',
"       \ 'type' : 't'
"       \ }
"       \ }


let g:tagbar_type_purescript = {
      \ 'ctagsbin'    : 'hasktags',
      \ 'ctagsargs'   : '-x -c -o-',
      \ 'kinds'       : [
      \  'm:modules:0:1',
      \  'd:data:0:1',
      \  'd_gadt:data gadt:0:1',
      \  'nt:newtype:0:1',
      \  'c:classes:0:1',
      \  'i:instances:0:1',
      \  'cons:constructors:0:1',
      \  'c_gadt:constructor gadt:0:1',
      \  'c_a:constructor accessors:1:1',
      \  't:type names:0:1',
      \  'pt:pattern types:0:1',
      \  'pi:pattern implementations:0:1',
      \  'f:function:0:1',
      \  'ft:function types:0:1',
      \  'fi:function implementations:0:1',
      \  'o:others:0:1'
      \ ],
      \ 'sro'          : '.',
      \ 'kind2scope'   : {
      \ 'm'        : 'module',
      \ 'd'        : 'data',
      \ 'd_gadt'   : 'd_gadt',
      \ 'c_gadt'   : 'c_gadt',
      \ 'nt'       : 'newtype',
      \ 'cons'     : 'cons',
      \ 'c_a'      : 'accessor',
      \ 'c'        : 'class',
      \ 'i'        : 'instance'
      \ },
      \ 'scope2kind'   : {
      \ 'module'   : 'm',
      \ 'data'     : 'd',
      \ 'newtype'  : 'nt',
      \ 'cons'     : 'c_a',
      \ 'd_gadt'   : 'c_gadt',
      \ 'class'    : 'ft',
      \ 'instance' : 'ft'
      \ }
      \ }

" let g:tagbar_type_haskell = {
"       \ 'ctagsbin'  : 'hasktags',
"       \ 'ctagsargs' : '-x -c -o-',
"       \ 'kinds'     : [
"       \  'm:modules:0:1',
"       \  'd:data: 0:1',
"       \  'd_gadt: data gadt:0:1',
"       \  't:type names:0:1',
"       \  'nt:new types:0:1',
"       \  'c:classes:0:1',
"       \  'cons:constructors:1:1',
"       \  'c_gadt:constructor gadt:1:1',
"       \  'c_a:constructor accessors:1:1',
"       \  'ft:function types:1:1',
"       \  'fi:function implementations:0:1',
"       \  'o:others:0:1'
"       \ ],
"       \ 'sro'        : '.',
"       \ 'kind2scope' : {
"       \ 'm' : 'module',
"       \ 'c' : 'class',
"       \ 'd' : 'data',
"       \ 't' : 'type'
"       \ },
"       \ 'scope2kind' : {
"       \ 'module' : 'm',
"       \ 'class'  : 'c',
"       \ 'data'   : 'd',
"       \ 'type'   : 't'
"       \ }
"       \ }


let g:tagbar_type_markdown = {
      \ 'ctagstype': 'markdown',
      \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
      \ 'ctagsargs' : '-f - --sort=yes',
      \ 'kinds' : [
      \ 's:sections',
      \ 'i:images'
      \ ],
      \ 'sro' : '|',
      \ 'kind2scope' : {
      \ 's' : 'section',
      \ },
      \ 'sort': 0,
      \ }

" if executable('lushtags') ■
" if 0
  " let g:tagbar_type_haskell = {
  "       \ 'ctagsbin' : 'lushtags',
  "       \ 'ctagsargs' : '--ignore-parse-error --',
  "       \ 'kinds' : [
  "       \ 'm:module:0',
  "       \ 'e:exports:1',
  "       \ 'i:imports:1',
  "       \ 't:declarations:0',
  "       \ 'd:declarations:1',
  "       \ 'n:declarations:1',
  "       \ 'f:functions:0',
  "       \ 'c:constructors:0'
  "       \ ],
  "       \ 'sro' : '.',
  "       \ 'kind2scope' : {
  "       \ 'd' : 'data',
  "       \ 'n' : 'newtype',
  "       \ 'c' : 'constructor',
  "       \ 't' : 'type'
  "       \ },
  "       \ 'scope2kind' : {
  "       \ 'data' : 'd',
  "       \ 'newtype' : 'n',
  "       \ 'constructor' : 'c',
  "       \ 'type' : 't'
  "       \ }
  "       \ }

" Add support for purescript files in tagbar.
" let g:tagbar_type_purescript = {
"       \ 'ctagsbin' : 'purs',
"       \ 'ctagsargs' : 'docs --format ctags',
"       \ 'kinds' : [
"       \ 'm:module:0',
"       \ 'e:exports:1',
"       \ 'i:imports:1',
"       \ 't:declarations:0',
"       \ 'd:declarations:1',
"       \ 'n:declarations:1',
"       \ 'f:functions:0',
"       \ 'c:constructors:0'
"       \ ],
"       \ 'sro' : '.',
"       \ 'kind2scope' : {
"       \ 'd' : 'data',
"       \ 'n' : 'newtype',
"       \ 'c' : 'constructor',
"       \ 't' : 'type'
"       \ },
"       \ 'scope2kind' : {
"       \ 'data' : 'd',
"       \ 'newtype' : 'n',
"       \ 'constructor' : 'c',
"       \ 'type' : 't'
"       \ }
"       \ }

  " Add support for markdown files in tagbar.
  " let g:tagbar_type_markdown = {
  "   \ 'ctagstype' : 'markdown',
  "   \ 'kinds' : [
  "       \ 'h:Heading_L1',
  "       \ 'i:Heading_L2',
  "       \ 'k:Heading_L3'
  "   \ ]
  " \ }
"   let g:tagbar_type_markdown = {
"         \ 'ctagstype': 'markdown',
"         \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
"         \ 'ctagsargs' : '-f - --sort=yes',
"         \ 'kinds' : [
"         \ 's:sections',
"         \ 'i:images'
"         \ ],
"         \ 'sro' : '|',
"         \ 'kind2scope' : {
"         \ 's' : 'section',
"         \ },
"         \ 'sort': 0,
"         \ }
" endif " ▲


" ─   MakeSectionEndMarker Demo line                    ──

" foldlevel

" test




