
" Note plugin/ftype/typedb.lua

nnoremap <silent><c-t>l :call StartTypeDBServer()<cr>
nnoremap <silent><c-t>L :call StopTypeDBServer()<cr>
nnoremap <silent><c-t>s :lua Tdb_selectSchema()<cr>
nnoremap <silent><c-t>c :call Tdb_createDB()<cr>
nnoremap <silent><c-t>C :call Tdb_clearDB()<cr>
nnoremap <silent><c-t>D :call Tdb_deleteDB()<cr>


" ─   Maps                                              ──

func! TypeDB_bufferMaps()
  call Scala_bufferMaps_shared()

  " nnoremap <silent><buffer> gej :call Tdb_eval_parag()<cr>
  lua Tdb_create_lineswise_maps()

  nnoremap <silent><buffer> gep :let g:tdb_schema_mode="define"<cr>:call Tdb_eval_parag()<cr>
  nnoremap <silent><buffer> ,gep :let g:tdb_schema_mode="undefine"<cr>:call Tdb_eval_parag()<cr>


  " nnoremap <silent><buffer> ,gej :let g:cmdAltMode=1<cr>:call Tdb_eval_parag()<cr>
  " nnoremap <silent><buffer> ,gei :let g:cmdAltMode=1<cr>:call Tdb_eval_parag()<cr>

  nnoremap gq    m':let g:opContFn='Tdb_query_textObj'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
  vnoremap gq :<c-u>let g:opContFn='Tdb_query_textObj'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>

  " nnoremap <silent><buffer> <leader>ge :let g:opContFn='Tdb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:set opfunc=Gen_opfuncAc<cr>g@
  " vnoremap <silent><buffer> <leader>gei :<c-u>let g:opContFn='Tdb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:call Gen_opfuncAc('', 1)<cr>
  nnoremap <silent><buffer> <leader>geo :call Tdb_eval_buffer()<cr>

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



func! Tdb_eval_buffer()
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
  let query_lines = a:query_lines
  " If a line is not a comment and contains a keyword its a read-write query. else a schema query.
  let g:isRWTrans = functional#findP( a:query_lines, {x-> !(x =~ '^# ') && x =~ '\v\s(match|insert|update|put|delete|reduce)\s'} )
  " echo g:isRWTrans
  if g:isRWTrans < 0
    " echo 'schema'
    let leadUpLns = ["transaction schema " . g:typedb_active_schema]
    let leadUpLns = leadUpLns + [ g:tdb_schema_mode ]
    if g:tdb_schema_mode == 'undefine'
      let query_lines = Tdb_makeUndefineQuery( query_lines )
      " echo query_lines
    endif

  else
    " echo 'RW'
    let leadUpLns = ["transaction write " . g:typedb_active_schema]
  endif
  let commitLns = ["", "commit"]
  return leadUpLns + query_lines + commitLns
endfunc

func! Tdb_makeUndefineQuery( query_lines )
  let result = []

  for line in a:query_lines
    " Trim whitespace
    let trimmed = substitute(line, '^\s*\|\s*$', '', 'g')

    if trimmed == ''
      " Keep empty lines
      call add(result, '')
    elseif trimmed =~ '^\(attribute\|entity\|relation\)\s\+'
      " Extract the name after attribute/entity/relation keyword
      let parts = split(trimmed, '\s\+')
      if len(parts) >= 2
        " Get the second part and remove any trailing comma
        let name = substitute(parts[1], ',$', '', '')
        call add(result, name . ';')
      endif
      " the second word is 'plays' or 'owns'
    elseif trimmed =~ '^\S\+\s\+\(plays\|owns\)\s\+'
      " Remove any comments (text after #) and trailing semicolon
      let clean_line = substitute(trimmed, '\s*@.*$', '', '')
      let clean_line = substitute(clean_line, '\s*#.*$', '', '')
      let clean_line = substitute(clean_line, ';\s*$', '', '')
      " Extract parts of the line
      let parts = split(clean_line, '\s\+')
      " echo parts
      if len(parts) >= 3
        let subject = parts[0]
        let action = parts[1]  " 'plays' or 'owns'
        " Join remaining parts (everything after action) and remove trailing comma
        let object = substitute(join(parts[2:], ' '), ',\s*$', '', '')
        " Construct the rearranged line
        call add(result, action . ' ' . object . ' from ' . subject . ';')
      endif
    else
      " For other lines (like 'owns', 'relates', etc.), output empty line
      call add(result, '')
    endif
  endfor

  return result
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

  let cmd = g:typedb_cmd_base . "--script " . filePath
  let resLines = systemlist( cmd )
  return resLines
endfunc

func! Tdb_listSchemaNames()
  let cmd = g:typedb_cmd_base . "--command 'database list'"
  let resLines = systemlist( cmd )
  return resLines[1:]
endfunc
" echo Tdb_listSchemaNames()


func! Tdb_clearDB()
  let msg = 'Clear database ' . g:typedb_active_schema . "?"
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

func! Tdb_deleteDB()
  let msg = 'Delete database ' . g:typedb_active_schema . "?"
  let confirmed = confirm( msg, "&Yes\n&Cancel", 2 )
  if !(confirmed == 1)
    echo 'canceled'
    return
  endif
  let cmd = g:typedb_cmd_base . "--command 'database delete " . g:typedb_active_schema . "'"
  let resLines = systemlist( cmd )
  let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc

func! Tdb_createDB()
  let g:typedb_active_schema = input( 'New database name: (currently active) ', g:typedb_active_schema )
  let cmd = g:typedb_cmd_base . "--command 'database create " . g:typedb_active_schema . "'"
  let resLines = systemlist( cmd )
  let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc



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

  " Update show schema on schema updates
  if g:isRWTrans < 0
    call Tdb_update_ShowCurrentSchemaFile()
  endif

  call Tdb_showLines( resLines )
endfunc

func! Tdb_update_ShowCurrentSchemaFile()
  let schemaLines = Tdb_getSchema()
  let schemaLines = Tdb_sort_schemaLines( schemaLines )
  let [_, schemaPath] = Tdb_localPath()
  call writefile( schemaLines, schemaPath )
endfunc

func! Tdb_sort_schemaLines( input_lines )
  let input_lines = a:input_lines

  call filter( input_lines, 'v:val !~ ''^\s*$'' && v:val !~ ''^\s*define\s*$''')

  " Initialize lists to hold the different types of blocks.
  let l:attribute_lines = []
  let l:entity_lines = []
  let l:relation_lines = []

  " This variable will track which type of block we are currently inside.
  let l:current_block_type = ''

  " Iterate over each line of the input.
  for l:line in a:input_lines
    " Check if the line is the start of a new top-level block (i.e., it
    " doesn't start with whitespace).
    if l:line =~ '^\S'
      " Determine the block type based on the content of the line.
      if l:line =~ '^attribute'
        let l:current_block_type = 'attribute'
      elseif l:line =~ 'entity'
        " It's a new 'entity' block.
        " If the entity_lines list is not empty, it means this is NOT the
        " first 'entity' block, so add a blank separator line.
        if !empty(l:entity_lines)
          call add(l:entity_lines, '')
        endif
        let l:current_block_type = 'entity'
      elseif l:line =~ 'relation'
        " It's a new 'relation' block.
        " If the relation_lines list is not empty, it means this is NOT the
        " first 'relation' block, so add a blank separator line.
        if !empty(l:relation_lines)
          call add(l:relation_lines, '')
        endif
        let l:current_block_type = 'relation'
      endif
    endif

    " Add the current line to the appropriate list based on the block type.
    if l:current_block_type == 'attribute'
      call add(l:attribute_lines, l:line)
    elseif l:current_block_type == 'entity'
      call add(l:entity_lines, l:line)
    elseif l:current_block_type == 'relation'
      call add(l:relation_lines, l:line)
    endif
  endfor

  " Combine the lists in the desired order: entities, relations, and then attributes,
  " with a separator comment block before the attributes.
  return [g:typedb_active_schema, '', '# Entities', ''] + l:entity_lines + ['', '', '# Relations', ''] + l:relation_lines + ['', '', '# Attributes', ''] + l:attribute_lines
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
let g:Tdb_MainStartPattern = '\v(sub|plays|entity|relation|attribute)'
let g:Tdb_TopLevPattern = '\v(define|Entities|Relations|Attributes)'

func! Tdb_TopLevBindingForw()
  call search( g:Tdb_TopLevPattern, 'W' )
endfunc

func! Tdb_TopLevBindingBackw()
  call search( g:Tdb_TopLevPattern, 'bW' )
endfunc


func! Tdb_skipcomment()
  let curCar = GetCharAtCursor()
  if curCar == '#' || curCar == ''
    normal! j
    call Tdb_skipcomment()
  endif
endfunc

func! Tdb_skipcommentUp()
  let curCar = GetCharAtCursor()
  if curCar == '#'
    call Tdb_MainStartBindingBackw()
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
  call Tdb_skipcommentUp()
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
  " call LaunchChrome( "https://studio.typedb.com/schema" )

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


