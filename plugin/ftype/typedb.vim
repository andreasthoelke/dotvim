
" Note plugin/ftype/typedb.lua

" ─   Maps                                              ──

func! TypeDB_bufferMaps()
  call Scala_bufferMaps_shared()

  " nnoremap <silent><buffer> gej :call Tdb_eval_parag()<cr>
  lua Tdb_create_lineswise_map()


  nnoremap <silent><c-t>s :call StartTypeDBServer()<cr>
  nnoremap <silent><c-t>S :call StopTypeDBServer()<cr>
  nnoremap <silent><c-t>o :lua Tdb_selectSchema()<cr>
  nnoremap <silent><c-t>D :call Tdb_dropDB()<cr>

  nnoremap <silent><buffer> gep :call Tdb_eval_parag()<cr>


  " nnoremap <silent><buffer> ,gej :let g:cmdAltMode=1<cr>:call Tdb_eval_parag()<cr>
  " nnoremap <silent><buffer> ,gei :let g:cmdAltMode=1<cr>:call Tdb_eval_parag()<cr>

  nnoremap gq    m':let g:opContFn='Tdb_query_textObj'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
  vnoremap gq :<c-u>let g:opContFn='Tdb_query_textObj'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>

  " nnoremap <silent><buffer> <leader>ge :let g:opContFn='Tdb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:set opfunc=Gen_opfuncAc<cr>g@
  " vnoremap <silent><buffer> <leader>gei :<c-u>let g:opContFn='Tdb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:call Gen_opfuncAc('', 1)<cr>
  nnoremap <silent><buffer> <leader>geo :call Tdb_eval_buffer( v:true )<cr>

  nnoremap <silent><buffer> <leader>K :call Tdb_show_schema()<cr>

  nnoremap <silent><buffer> get :call Tdb_describe_object( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> gec :call Tdb_query_objCount( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> gea :call Tdb_query_withProp( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> ges :call Tdb_query_inParans( v:false )<cr>

  nnoremap <silent><buffer> gsK :call Tdb_showObjectFields( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> gsk :call Tdb_showObjectFieldsWT( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> ,,gsd :call Tdb_queryDeleteObject( expand('<cWORD>') )<cr>

  " nnoremap <silent><buffer> gsK :silent call TdbReplPost( '\d object ' . expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> <leader><c-p> :call Tdb_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Tdb_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>

  nnoremap <silent><buffer> <c-p>         :call Tdb_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Tdb_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>

  " nnoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>
  " onoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>(     :call Tdb_MvStartOfBlock()<cr>
  " onoremap <silent><buffer> <leader>(     :call Tdb_MvStartOfBlock()<cr>
  onoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>
  vnoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>

  nnoremap <silent><buffer> <leader>)     :call Tdb_MvEndOfBlock()<cr>
  onoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>
  vnoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>

  nnoremap <silent><buffer> * :call MvPrevLineStart()<cr>
  nnoremap <silent><buffer> ( :call MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call MvNextLineStart()<cr>

  nnoremap <silent><buffer> I :call Tdb_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Tdb_ColonBackw()<cr>

  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  " " find a new map if I actually use this:
  " nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>


endfunc







" ─   Run queries                                        ■

func! Tdb_eval_parag()
  let [startLine, endLine] = ParagraphStartEndLines()
  call Tdb_eval_range( startLine, endLine )
endfunc



func! Tdb_eval_buffer( format )
  let [startLine, endLine] = [1, line('$')]
  call Tdb_eval_range( startLine, endLine )
endfunc



command! -range=% TdbEval call Tdb_eval_range( <line1>, <line2> )

func! Tdb_eval_range ( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')

  let lines = getline(startLine, endLine)
  " " TODO: wrap in with and the get count of result items?
  " if split(lines[0])[0] == "select"
  " endif

  call Tdb_runQueryShow( lines )
endfunc


" EXAMPLE schema transaction:
" transaction schema my_test_db
" define
"   entity user, owns username;
"   attribute username, value string;

" commit

" EXAMPLE write transaction:
" transaction write my_test_db
" insert $x isa user, has username "user_0";

" commit


func! Tdb_withTransactionLines( query_lines )
  let g:isRWTrans = functional#findP( a:query_lines, {x-> x =~ '\v(match|insert|update|put|delete|reduce)'} )
  " echo g:isRWTrans
  if g:isRWTrans < 0
    " echo 'schema'
    let leadUpLns = ["transaction schema " . g:typedb_active_schema]
    if g:cmdAltMode
      let leadUpLns = leadUpLns + ['undefine']
    else
      let leadUpLns = leadUpLns + ['define']
    endif
  else
    " echo 'RW'
    let leadUpLns = ["transaction write " . g:typedb_active_schema]
  endif
  let commitLns = ["", "commit"]
  return leadUpLns + a:query_lines + commitLns
endfunc

let g:typedb_cmd_base = "typedb console --tls-disabled --address http://0.0.0.0:1729 --username admin --password password "

func! Tdb_localPath()
  let queryPath = 'temp/query.tql'
  let schemaPath = 'temp/schema_' . g:typedb_active_schema . '.tql'
  if !isdirectory('temp')
    call mkdir('temp', 'p')
  endif
  if !filereadable(queryPath)
    call writefile([], queryPath)
  endif
  if !filereadable(schemaPath)
    call writefile([], schemaPath)
  endif
  return [queryPath, schemaPath]
endfunc

func! Tdb_runQuery( query_lines )
  let transaction_lines = Tdb_withTransactionLines( a:query_lines )

  let [filePath, _] = Tdb_localPath()
  call writefile( transaction_lines, filePath )

  let cmd = g:typedb_cmd_base . "--script " . filenameSource
  let resLines = systemlist( cmd )
  return resLines
endfunc

func! Tdb_listSchemaNames()
  let cmd = g:typedb_cmd_base . "--command 'database list'"
  let resLines = systemlist( cmd )
  return resLines[1:]
endfunc
" echo Tdb_listSchemaNames()


func! Tdb_dropDB()
  let msg = 'Delete database ' . g:typedb_active_schema . "?"
  let confirmed = confirm( msg, "&Yes\n&Cancel", 2 )
  if !(confirmed == 1)
    echo 'canceled'
    return
  endif

  " Delete and recreate DB to clear it.
  let cmd = g:typedb_cmd_base . "--command 'database delete " . g:typedb_active_schema . "'"
  let resLines = systemlist( cmd )
  let cmd = g:typedb_cmd_base . "--command 'database create " . g:typedb_active_schema . "'"
  let resLines = resLines + systemlist( cmd )

  let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc
" echo Tdb_listSchemaNames()



func! Tdb_getSchema()
  let cmd = g:typedb_cmd_base . "--command 'database schema " . g:typedb_active_schema . "'"
  let resLines = systemlist( cmd )
  return resLines
endfunc
" echo Tdb_getSchema()

func! Tdb_show_schema()
  let schemaLines = Tdb_getSchema() 
  let [_, schemaPath] = Tdb_localPath()
  call writefile( schemaLines, schemaPath )
  call Path_Float( schemaPath )
endfunc
" call Tdb_show_schema()


" ─^  Run queries                                        ▲


" ─   Show results                                       ■

func! Tdb_runQueryShow ( query_lines )
  let resLines = Tdb_runQuery( a:query_lines )
  let resLines = RemoveTermCodes( resLines )

  " Show schema on schema updates
  if g:isRWTrans < 0
    let schemaLines = Tdb_getSchema()
    let resLines = resLines + [''] + schemaLines
  endif

  call Tdb_showLines( resLines )
endfunc

func! Tdb_showLines ( lines )
  let g:floatWin_win = FloatingSmallNew ( a:lines, 'cursor' )
  normal gg
  call TypeQLSyntaxAdditions()
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc


" relies of jq json formatting
func! Tdb_addObjCountToBuffer()
  let bufferLines = getline( 0, "$" )
  if bufferLines[0][0] =~ '\d'
    call setline( 1, bufferLines[0] . " (val|db-cnt)" )
  endif
  let objStartLinesOuter = functional#filter( { l -> l == '{' }, bufferLines )
  let objStartLinesOuterInArray = functional#filter( { l -> l == "  {" }, bufferLines )
  let objStartLinesInner = functional#filter( { l -> substitute( l, " ", "", "g" ) == '{' }, bufferLines )
  " substitute( " ein ss ", " ", "", "g" )
  let innerObjsCount = len(objStartLinesInner) - len(objStartLinesOuter)
  if innerObjsCount
    call append( 0, innerObjsCount . " inner obj"  )
  endif
  if len(objStartLinesOuter)
    call append( 0, len(objStartLinesOuter) . " outer obj"  )
  elseif len(objStartLinesOuterInArray)
    call append( 0, len(objStartLinesOuterInArray) . " outer obj in array"  )
  elseif len( bufferLines )
    " TOREVIEW: ommitting the lines count for now.
    " call append( 0, len(bufferLines) - 0 . " lines" )
  endif
endfunc


" ─^  Show results                                       ▲



" ─   Motions                                           ──

" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Tdb_MainStartPattern = '\v(sub|plays|entity|relation)'
let g:Tdb_TopLevPattern = '\v^(define)'

func! Tdb_TopLevBindingForw()
  call search( g:Tdb_TopLevPattern, 'W' )
endfunc

func! Tdb_TopLevBindingBackw()
  call search( g:Tdb_TopLevPattern, 'bW' )
endfunc


func! Tdb_skipcomment()
  let curCar = GetCharAtCursor()
  if curCar == '#'
    normal! j
    call Tdb_skipcomment()
  endif
endfunc

func! Tdb_MainStartBindingForw()
  normal! }
  call search( g:Tdb_MainStartPattern, 'W' )
  normal! {
  normal! j
  call Tdb_skipcomment()
endfunc

func! Tdb_MainStartBindingBackw()
  normal! {
  call search( g:Tdb_MainStartPattern, 'bW' )
  normal! {
  normal! j
  call Tdb_skipcomment()
endfunc


func! Tdb_MvStartOfBlock()
  normal! k
  exec "silent keepjumps normal! {"
  normal! j^
endfunc


func! Tdb_MvEndOfBlock()
  normal! j
  exec "silent keepjumps normal! }"
  normal! k^
endfunc

func! MakeOrPttn( listOfPatterns )
  return '\(' . join( a:listOfPatterns, '\|' ) . '\)'
endfunc

let g:Tdb_colonPttn = MakeOrPttn( ['\:\:', '\/\/', '*>', '-', '=', 'extends', 'yield', 'if', 'then', 'else', '\$'] )

func! Tdb_ColonForw()
  call SearchSkipSC( g:Tdb_colonPttn, 'W' )
  normal w
endfunc

func! Tdb_ColonBackw()
  normal bh
  call SearchSkipSC( g:Tdb_colonPttn, 'bW' )
  normal w
endfunc



" ─   TDB Services                                       ■

func! StartTypeDBServer()
  if exists('g:TypeDBTermID')
    echo 'TypeDB server is already running'
    return
  endif
  let cmdline = 'typedb server'
  exec "20new"
  let opts = { 'cwd': getcwd( winnr() ) }
  let g:TypeDBTermID = termopen( cmdline, opts )

  silent wincmd c
  call LaunchChrome( "https://studio.typedb.com/schema" )

  echo 'TypeDB server started'
endfunc

func! StopTypeDBServer ()
  if !exists('g:TypeDBTermID')
    echo 'TypeDB server is not running'
    return
  endif
  call jobstop( g:TypeDBTermID )
  unlet g:TypeDBTermID
  echo 'TypeDB server closed!'
endfunc


func! RestartTypeDBServer ()
  if exists('g:TypeDBTermID')
    call StopDevServer()
  endif
  call StartDevServer()
endfunc



" ─^  TDB Services                                       ▲






