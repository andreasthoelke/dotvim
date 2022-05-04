
nnoremap <silent> <leader>du :DBUIToggle<CR>
nnoremap <silent> <leader>df :DBUIFindBuffer<CR>
nnoremap <silent> <leader>dr :DBUIRenameBuffer<CR>
nnoremap <silent> <leader>dL :DBUILastQueryInfo<CR>

nnoremap <silent> <leader>DD :DBUIFindBuffer<CR>
nmap <silent> <leader>dd <Plug>(DBUI_ExecuteQuery)

let g:db_ui_save_location = '~/.config/db_ui'
let g:db_ui_tmp_query_location = '~/.local/share/db_ui'

let g:db_ui_execute_on_save = 0
let g:db_ui_show_database_icon = 1
let g:db_ui_use_nerd_fonts = 1

let g:dbs = {
  \ 'air_routes': 'mysql://root:PW@127.0.0.1:3306/air_routes',
  \ 'pets': 'mysql://root:PW@127.0.0.1:3306/pets',
  \ 'todos_koa': 'mongodb://localhost:27017/todos_koa',
  \ 'pothos_prisma': 'sqlite:/Users/at/Documents/Architecture/examples/pothos/examples/prisma/prisma/dev.db',
  \ }
" mysql://root:PW@127.0.0.1:3306/pets
" mysql://root:PW@127.0.0.1:3306/air_routes

" use DBUIFindBuffer (leader DD) to set the g:db variable for a buffer (needed to issue queries)

function! DB_putInsertQuery() abort
  let rows = db_ui#query(printf(
        \ "select column_name, data_type from information_schema.columns where table_name='%s' and table_schema='%s'",
        \ b:dbui_table_name,
        \ b:dbui_schema_name
        \ ))
  let lines = ['INSERT INTO '.b:dbui_table_name.' (']
  for [column, datatype] in rows
    call add(lines, column)
  endfor
  call add(lines, ') VALUES (')
  for [column, datatype] in rows
    call add(lines, printf('%s <%s>', column, datatype))
  endfor
  call add(lines, ')')
  call setline(1, lines)
endfunction

nnoremap <silent> <leader>Dip :call DB_putInsertQuery()<cr>

" autocmd FileType sql nnoremap <buffer><leader>i :call <sid>populate_query()


command! -range=% DBRun call DBRun( <line1>, <line2> )
" Note: this applies to the whole buffer when no visual-sel

nnoremap <leader>dl :call DBRun( line('.'), line('.') )<cr>
nnoremap <leader>d :let g:opContFn='DBRun'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
vnoremap <leader>d :<c-u>let g:opContFn='DBRun'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

func! DBRun( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  " let rangeStr = startLine . ',' . endLine
  let lines = getline(startLine, endLine)
  let sqlStr = join(lines, "\n")

  let rows = db_ui#query( sqlStr )
  if len( rows ) == 0
    echo "query completed!"
    return
  endif

  let g:query_res = rows

  let str_rows = functional#map( 'string', rows )

  " let linesResult = repl_py#splitToLines( string( rows ) )

  let g:floatWin_win = FloatingSmallNew ( str_rows )

  call tools_db#alignInFloatWin()

endfunc

func! tools_db#alignInFloatWin()
  call FloatWin_FocusFirst()
  " setlocal modifiable
  " call easy_align#easyAlign( 1, line('$'), ',')
  silent exec "%s/\\[//g"
  silent exec "%s/\]//g"
  silent exec "%s/\'//g"
  silent exec "Tabularize /,"
  silent exec "%s/,/|/g"
  call append( 1, '' )
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc

" ─   Completion                                        ──
" If vim-dadbod-ui is not used, vim-dadbod g:db or b:db is used.
" If you want, you can also add b:db_table to limit autocompletions to that table only.
" https://github.com/kristijanhusak/vim-dadbod-completion

" For built in omnifunc
autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni

" hrsh7th/nvim-compe
" let g:compe.source.vim_dadbod_completion = v:true

" hrsh7th/nvim-cmp
" autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

" For completion-nvim
" augroup completion
"   autocmd!
"   autocmd BufEnter * lua require'completion'.on_attach()
"   autocmd FileType sql let g:completion_trigger_character = ['.', '"', '`', '[']
" augroup END

" Shougo/ddc.vim
" call ddc#custom#patch_filetype(['sql', 'mysql', 'plsql'], 'sources', 'dadbod-completion')
" call ddc#custom#patch_filetype(['sql', 'mysql', 'plsql'], 'sourceOptions', {
" \ 'dadbod-completion': {
" \   'mark': 'DB',
" \   'isVolatile': v:true,
" \ },
" \ })

" Source is automatically added, you just need to include it in the chain complete list
let g:completion_chain_complete_list = {
    \   'sql': [
    \    {'complete_items': ['vim-dadbod-completion']},
    \   ],
    \ }
" Make sure `substring` is part of this list. Other items are optional for this completion source
let g:completion_matching_strategy_list = ['exact', 'substring']
" Useful if there's a lot of camel case items
let g:completion_matching_ignore_case = 1






