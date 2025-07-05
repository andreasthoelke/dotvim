
" db-ui connections can be defined here:
" ~/.config/db_ui/connections.json#/[{"url".%20"mysql.//root.PW@127.0.0.1.3306/pets",%20"name".

func! Sql_bufferMaps()

  call Scala_bufferMaps_shared()

  nnoremap <silent><buffer> gej :call DB_eval_parag_psql()<cr>
  nnoremap <silent><buffer> gel :call DB_eval_parag_sqlite()<cr>
  nnoremap <silent><buffer> gei :call DB_eval_parag()<cr>
  nnoremap <silent><buffer> ,ge <Plug>(sqls-execute-query)


  nnoremap <silent><buffer>         gek :lua vim.lsp.buf.hover()<cr>

  " Todo: make these maps general per language and put them here or ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make
  nnoremap <silent><buffer>         ged :TroubleToggle<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
  nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 200 )<cr>

  " Stubs and inline tests
  nnoremap <silent><buffer> <leader>et :call CreateInlineTestDec_rescript()<cr>

  nnoremap <silent><buffer>       geh :silent call RescriptTypeHint()<cr>
  nnoremap <silent><buffer>            gdd :call RS_OpenDefinition(':e')<cr>

  " nnoremap <silent><buffer> <c-n> :call Scala_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  " nnoremap <silent><buffer> <c-p> :call RS_TopLevBindingBackw()<cr>:call ScrollOff(10)<cr>

endfunc


nnoremap <silent> <leader><leader>du :DBUIToggle<CR>
nnoremap <silent> <leader><leader>df :DBUIFindBuffer<CR>
nnoremap <silent> <leader><leader>dr :DBUIRenameBuffer<CR>
nnoremap <silent> <leader><leader>dL :DBUILastQueryInfo<CR>

nnoremap <silent> <leader><leader>DD :DBUIFindBuffer<CR>
nmap <silent> <leader><leader>dd <Plug>(DBUI_ExecuteQuery)

let g:db_ui_save_location = '~/.config/db_ui'
let g:db_ui_tmp_query_location = '~/.local/share/db_ui'

let g:db_ui_execute_on_save = 0
let g:db_ui_show_database_icon = 1
let g:db_ui_use_nerd_fonts = 1

  " \ 'learn_dev': 'postgres:///learn_dev',
  " \ 'funcprog': 'postgres:///funcprog',
let g:dbs = {
  \ 'muse': 'postgresql://postgres:password@0.0.0.0:5432/muse',
  \ }

" these are additional permanent connections. activate this as needed
" let g:dbs = {
"   \ 'air_routes': 'mysql://root:PW@127.0.0.1:3306/air_routes',
"   \ 'pets': 'mysql://root:PW@127.0.0.1:3306/pets',
"   \ 'learn_dev': 'postgres:///learn_dev',
"   \ 'funcprog': 'postgres:///funcprog',
"   \ 'todos_koa': 'mongodb://localhost:27017/todos_koa',
"   \ 'pothos_prisma': 'sqlite:/Users/at/Documents/Architecture/examples/pothos/examples/prisma/prisma/dev.db',
"   \ }

" mysql://root:PW@127.0.0.1:3306/pets
"  \ 'finito_sqlite': 'sqlite:/Users/at/Documents/.config/libro-finito/db.sqlite',
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


func! DB_eval_parag()
  let [startLine, endLine] = ParagraphStartEndLines()
  call DBRun( startLine, endLine )
endfunc


" psql -d zio_skunk_tradeIO -c "select * from accounts"
" let g:dbname = 'zio_skunk_tradeIO'
let g:dbname = 'world'
" let g:dbname = 'learn_dev'
" let g:dbname = 'realworld-prod.sqlite'
" let g:dbconn = 'postgresql://postgres:password@0.0.0.0:5432/muse'
" let g:dbconn = 'postgresql://jimmy:banana@0.0.0.0:5432/world'
" let g:dbconn = 'postgresql://at:at@0.0.0.0:5432/d_myimdb'
" let g:dbconn = 'jdbc:at://localhost:5432/realworld1'
let g:dbconn = ''

func! DB_eval_parag_psql()
  let [startLine, endLine] = ParagraphStartEndLines()
  let lines = getline(startLine, endLine)
  let sqlStr = join(lines, "\n")

  " psql -d zio_skunk_tradeIO -c "select * from accounts"
  " let cmd = 'psql -d ' . g:dbname . ' -c "' . sqlStr . '"'
  " let cmd = 'psql ' . g:dbconn . ' -c "' . sqlStr . '"'
  " echo cmd
  " return

  if g:dbname =~ 'sqlite'
    " let cmd = 'sqlite3 ' . g:dbname . ' "' . sqlStr . '"' . ' .mode -column'
    let cmd = 'sqlite3 ' . g:dbname . ' "' . sqlStr . '"' . ' -column'
  else
    if len( g:dbconn )
      let cmd = 'psql ' . g:dbconn . ' -c "' . sqlStr . '"'
    else
      let cmd = 'psql -d ' . g:dbname . ' -c "' . sqlStr . '"'
    endif
  endif

  call System_Float( cmd )
endfunc


" sqlite3 --help
let g:dbname_sqlite = '/Users/at/Documents/Proj/_dbs/world/world.db'

func! DB_eval_parag_sqlite()
  let [startLine, endLine] = ParagraphStartEndLines()
  let lines = getline(startLine, endLine)
  " let sqlStr = join(lines, "\n")
  let sqlStr = join(lines, " ") . ";"
  " echo sqlStr
  " return
  
  " psql -d zio_skunk_tradeIO -c "select * from accounts"
  " sqlite3 realworld-prod.sqlite "select * from users"
  let cmd = 'sqlite3 ' . g:dbname_sqlite . ' "' . sqlStr . '"' . ' .mode -column'
  " echo cmd
  " return

  let resLines = systemlist( cmd )
  let resLines = RemoveTermCodes( resLines )

  if !len(resLines)
    let resLines += ['query completed with nothing returned']
  endif

  if len(resLines) && resLines[-1] =~ 'current output mode' 
    let resLines = resLines[:-2]
  endif

  if len(resLines)
    let resLines += ['', 'cnt ' . len(resLines)]
  endif

  let g:floatWin_win = FloatingSmallNew ( resLines, "otherWinColumn" )
  call ScalaSyntaxAdditions() 
  call FloatWin_FitWidthHeight()
  wincmd p

  " call System_Float( cmd )
endfunc



command! -range=% DBRun call DBRun( <line1>, <line2> )
" Note: this applies to the whole buffer when no visual-sel

map ,dr <Plug>(DBUI_ExecuteQuery)

nnoremap <leader><leader>dl :call DBRun( line('.'), line('.') )<cr>
nnoremap <leader><leader>d :let g:opContFn='DBRun'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
vnoremap <leader><leader>d :<c-u>let g:opContFn='DBRun'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

" db_ui#query( "select * from collections" )

func! DBRun( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  " let rangeStr = startLine . ',' . endLine
  let lines = getline(startLine, endLine)
  let sqlStr = join(lines, "\n")

  " NOTE_TODO: this doesn't work with sqlite!!
  " help db_ui
  let resLines = db_ui#query( sqlStr )
  if len( resLines ) == 0
    echo "query completed!"
    return
  endif

  let resLines = RemoveTermCodes( resLines )

  let g:query_res = resLines

  let str_resLines = functional#map( 'string', resLines )

  " let linesResult = repl_py#splitToLines( string( resLines ) )

  let g:floatWin_win = FloatingSmallNew ( str_resLines )

  call Sql_alignInFloatWin()

endfunc
" Check: ~/.config/nvim/plugin/tools_edgedb.vim#/func.%20tools_edgedb#runQueryShow%20.

func! Sql_alignInFloatWin()
  call FloatWin_FocusFirst()
  " setlocal modifiable
  " call easy_align#easyAlign( 1, line('$'), ',')
  silent exec "%s/\\[//g"
  silent exec "%s/\]//g"
  silent exec "%s/\'//g"
  silent exec "Tabularize /,"
  silent exec "%s/,/|/eg"
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
" Now (also?) using lsp

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






