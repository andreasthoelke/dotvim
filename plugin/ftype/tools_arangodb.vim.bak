
let g:arangodb_db = '_system'

" nnoremap <silent> <leader>adw :call LaunchChromium("http://localhost:8529")<cr>
" nnoremap <silent> <leader>ads :call AdbStart()<cr>
" nnoremap <silent> <leader>adS :call AdbStop()<cr>
" nnoremap <silent> <leader>adr :call AdbReplStart()<cr>
" nnoremap <silent> <leader>adR :call AdbReplStop()<cr>
" nnoremap <silent> <leader>adm :call Adb_bufferMaps()<cr>

func! Adb_bufferMaps()
  " nnoremap <silent><buffer> gei :call Adb_eval_parag( v:true )<cr>
  " nnoremap <silent><buffer> geI :call Adb_eval_parag( v:false )<cr>

  nnoremap <silent><buffer> gei :call Adb_parag_repl()<cr>
  nnoremap <silent><buffer> gel :call Adb_line_repl()<cr>

  " nnoremap gq    m':let g:opContFn='Adb_query_textObj'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
  " vnoremap gq :<c-u>let g:opContFn='Adb_query_textObj'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>

  " nnoremap <silent><buffer> <leader>ge :let g:opContFn='Adb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:set opfunc=Gen_opfuncAc<cr>g@
  " vnoremap <silent><buffer> <leader>gei :<c-u>let g:opContFn='Adb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:call Gen_opfuncAc('', 1)<cr>
  " nnoremap <silent><buffer> <leader>geo :call Adb_eval_buffer( v:true )<cr>

  " nnoremap <silent><buffer> get :call Adb_describe_object( expand('<cword>'), v:false )<cr>
  " nnoremap <silent><buffer> geT :call Adb_describe_object( expand('<cword>'), v:true )<cr>
  " nnoremap <silent><buffer> ,K :call Adb_describe_object( expand('<cword>'), v:false )<cr>
  " nnoremap <silent><buffer> ,,K :call Adb_describe_object( expand('<cword>'), v:true )<cr>

  " nnoremap <silent><buffer> <leader>K :call Adb_describe_schema()<cr>

  " nnoremap <silent><buffer> gec :call Adb_query_objCount( expand('<cword>'), v:false )<cr>
  " nnoremap <silent><buffer> gea :call Adb_query_withProp( expand('<cWORD>'), v:false )<cr>
  " nnoremap <silent><buffer> ges :call Adb_query_inParans( v:false )<cr>

  " nnoremap <silent><buffer> gSk :call Adb_showObjectFields( expand('<cword>') )<cr>
  " nnoremap <silent><buffer> gsk :call Adb_showObjectFieldsWT( expand('<cword>') )<cr>
  " nnoremap <silent><buffer> gsf :call Adb_queryAllObjectFieldsTablePermMulti( expand('<cword>') )<cr>
  " nnoremap <silent><buffer> gsF :call Adb_queryAllObjectFields( expand('<cword>') )<cr>
  " nnoremap <silent><buffer> <leader>gsF :call Adb_queryAllObjectFields_InnerFields( expand('<cword>') )<cr>

  " nnoremap <silent><buffer> gsK :silent call AdbReplPost( '\d object ' . expand('<cword>') )<cr>

  echo "Arango maps active!"
endfunc

func! Adb_query_textObj( sel_str )
  " echoe a:sel_str
  " return
  call Adb_runQueryShow( v:true, a:sel_str )
endfunc


func! Adb_queryAllObjectFields_InnerFields( select_clause )
  let sc_words = split( a:select_clause )
  if len( sc_words ) > 1
    let obj_name = sc_words[1]
    let select_clause = a:select_clause
  else
    let obj_name = sc_words[0]
    let select_clause = 'select ' . obj_name
  endif
  let objFields = Adb_getObjectFieldsWTL( obj_name )
  let objFields = Adb_addStrFieldsToObjFields( objFields )
  let linkFields = functional#filter( {f -> f.isLinkType }, objFields )
  let propFields = functional#map({f->f.name}, functional#filter( {f -> !f.isLinkType }, objFields ))
  let q_propFields = join( propFields, ', ' )

  let q_linkFieldsList = []
  for field in linkFields
    let qstr = field.name . ': {'
    let qstr = qstr . join( field.strFields, ', ' ) . '}'
    call add( q_linkFieldsList, qstr )
  endfor
  let q_linkFields = join( q_linkFieldsList, ', ' )
  let query = select_clause . ' {' . q_propFields . ', ' . q_linkFields . '}'
  call Adb_runQueryShow( v:true, [query] )
  " Can't parse/turn this string into a dictionary
  " let resLines = Adb_runQuery( [query] )
  " let resLines = join( resLines )
  " let resLines = substitute( resLines, ' null,', ' "null",', 'g' )
  " let resLines = eval( resLines )
  " echo resLines

endfunc
" call Adb_queryAllObjectFieldsTable( 'select Region' )

" find field names that contain name, title
" only use 3 chars
" use str fields that are mostly not nil
" concat 3 chars of multifields, abbrev after 10 chars
" can just use the js driver!
"
" call append(line('.'), string( linkFields ))
" [{'name': 'other_places', 'isLinkType': 1, 'type': 'OtherPlace', 'isArray': 0}, {'name': 'castles', 'isLinkType': 1, 'type': 'Castle', 'isArray': 0}, {'name': 'cities', 'isLinkType': 1, 'type': 'City', 'isArray': 0}, {'name': 'important_places', 'isLinkType': 0, 'type': 'strA', 'isArray': 1}, {'name': 'name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'modern_name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'coffins', 'isLinkType': 0, 'type': 'int16', 'isArray': 0}]

" all link fields
" take the first str typed property of that object e.g. modern_name
" put the name of the field in a second info column
" combine it with id
" the field val will then be a concat of modern_name + ..id
" if modern_name is nil then only id excerpt will be shown
" select Region {name, cities: {id, name, modern_name}}


func! Adb_queryAllObjectFieldsTablePermMulti( obj_name )
  " This query uses a tuple of sub-queries(?) and therefore *permutes* all mutiple linked objects resulting in additional lines in the table. Which is ok, but see the other approach ..
  " with
  "   obj := (select Region filter .name = 'Prussia'),
  "   fieldVals := (obj.name, obj.cities, obj.other_places, <json>obj.castles ?? <json>'-'),
  " select fieldVals

  let fieldNames = Adb_getObjectFields( a:obj_name )
  let q_preFName = '<json>obj.'
  let q_postFName = ' ?? <json>"-"'
  let q_start = '(' . q_preFName
  let q_inBetween = q_postFName . ', ' . q_preFName
  let q_end = ')'
  let q_fieldValsExpr = q_start . join( fieldNames, q_inBetween ) . q_postFName . q_end
  let queryL1 = 'with obj := (select ' . a:obj_name . '), '
  let queryL2 = 'fieldVals := ' . q_fieldValsExpr . ', '
  let queryL3 = 'select fieldVals;'
  let query = queryL1 . queryL2 . queryL3
  " call AdbReplPlain( query )
  let resLines = Adb_runQuery( [query] )
  " echo UnexpandLines( resLines )
  let resLines = UnexpandLines( resLines )
  " return
  " Note: The EdgeQL returned tuples can be evaluated to vimscript lists! ->
  let resLines = functional#map( {lineStr -> FilterLists( eval( lineStr ) )}, resLines )
  " echoe resLines
  " return
  let resLines = functional#map( {line -> string( line )}, resLines )
  let tableLines = [string( fieldNames )] + resLines
  " echo tableLines
  let tableLines = functional#map( {lineStr -> lineStr[1:-2] }, tableLines )
  let g:floatWin_win = FloatingSmallNew ( tableLines )
  call Adb_bufferMaps()
  " call easy_align#easyAlign( 1, line('$'), ',')
  silent exec "%s/\'//g"
  silent exec "%s/\"//g"
  silent exec "Tabularize /,"
  silent exec "%s/,//g"
  call append( 1, '' )
  let infoLine = len( resLines ) . ' ' . a:obj_name . "'s"
  call append( 0, infoLine )
  call FloatWin_FitWidthHeight()
  wincmd p
  " call append( line('.'), fieldNames )
  " call append( line('.'), query )
endfunc
  " list := (npc.name, <str>npc.age ?? '-', <json>npc.places_visited  ?? <json>'-')
  " ~/Documents/Server-Dev/edgedb/1playground/src/drac/dpl2.edgeql#/list%20.=%20.npc.name,
" call Adb_queryAllObjectFieldsTable( 'Vampire' )

func! FilterLists ( line )
  if type(a:line) == 3
    let line = a:line
  else
    let line = [a:line]
  endif

  let res = []
  for el in line
    if type(el) == 3
      " limit the size of the list and replace the commas with ;
      let item = string( el[:2] )[1:-2]   . '‥'
      let item = substitute( item, ',', ';', 'g')
      call add( res, item )
    elseif type(el) == 4
      let item = '‥' . string( el )[-5:-2]
      call add( res, item )
    else
      call add( res, el )
    endif
  endfor
  return res
endfunc
" echo FilterLists( ['eins', [4,3], v:true] )

func! UnexpandLines ( list )
  let ret = []
  let buf = ''
  for e in a:list
    if e == '['
      " echo 'start'
      " start: of collapse tracking. Start filling the buffer
      let buf = '['
    elseif e == ']'
      " echo 'end'
      " end: of collapse tracking. add the accumulated buffer as an unexpanded list item
      let buf = buf . e
      call add( ret, buf )
      let buf = ''
    elseif buf == ''
      " echo 'normal'
      " normal: no collapse tracking is active. add list items as normal
      call add( ret, e )
    else
      " echo 'during'
      " during: collapse tracking. append the list item to the buffer, not the list.
      let buf = buf . e
    endif
  endfor
  return ret
endfunc
" echo UnexpandLines( ['[','eins','zwei',']','[drei','vier'] )

func! Adb_queryAllObjectFields( obj_name )
  let fieldNames = Adb_getObjectFields( a:obj_name )
  let fieldsStr = join( fieldNames, ', ' )
  let query = 'select ' . a:obj_name . ' {' . fieldsStr . '};'
  " let resLines = Adb_runQuery( query )
  call Adb_runQueryShow( v:true, [query] )
endfunc

func! Adb_showObjectFields( obj_name )
  let fieldNames = Adb_getObjectFields( a:obj_name )
  let g:floatWin_win = FloatingSmallNew ( fieldNames )
  call Adb_bufferMaps()
  " set syntax=edgeql
  call FloatWin_FitWidthHeight()
endfunc

func! Adb_getObjectFields( obj_name )
  let q1 = "with infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::"
  let q2 = "'), links_cl := (select infos.links filter .name != '__type__'), properties_cl := (select infos.properties filter .name != 'id'), select (properties_cl union links_cl).name"
  let query = q1 . a:obj_name . q2
  let resLines = Adb_runQuery( [query] )
  let cleanedLines = SubstituteInLines( resLines, '"', '' )
  return cleanedLines
endfunc

" with
"   infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::Vampire'),
"   links_cl := (select infos.links filter .name != '__type__'),
"   properties_cl := (select infos.properties filter .name != 'id'),
" select (properties_cl union links_cl).name


func! Adb_showObjectFieldsWT( obj_name )
  let fieldNames = Adb_getObjectFieldsWT( a:obj_name )
  let g:floatWin_win = FloatingSmallNew ( fieldNames )
  call Adb_bufferMaps()
  " set syntax=edgeql
  call easy_align#easyAlign( 1, line('$'), ',')
  exec "%s/,//ge"
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc

func! Adb_getObjectFieldsWT( obj_name )
  let q1 = "with infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::"
  let q2 = "'), links_cl := (select infos.links filter .name != '__type__'), properties_cl := (select infos.properties filter .name != 'id'), fields := (properties_cl union links_cl), select fields.name ++ ',' ++ fields.target.name"
  let query = q1 . a:obj_name . q2
  let resLines = Adb_runQuery( [query] )
  let cleanedLines = SubstituteInLines( resLines, '"', '' )
  let cleanedLines = SubstituteInLines( cleanedLines, ',.*\:', ',' )
  let cleanedLines = SubstituteInLines( cleanedLines, '>', 'A' )
  return cleanedLines
endfunc

func! Adb_getObjectFieldsWTP( obj_name )
  let q1 = "with infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::"
  let q2 = "'), links_cl := (select infos.links filter .name != '__type__'), properties_cl := (select infos.properties filter .name != 'id'), fields := (properties_cl union links_cl), select fields.name ++ ',' ++ fields.target.name"
  let query = q1 . a:obj_name . q2
  return Adb_runQuery( [query] )
endfunc

" with
"   infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::Vampire'),
"   links_cl := (select infos.links filter .name != '__type__'),
"   properties_cl := (select infos.properties filter .name != 'id'),
"   fields := (properties_cl union links_cl)
" select fields.name ++ ',' ++ fields.target.name

func! Adb_getObjectFieldsWTL( obj_name )
  let list_names_types = Adb_getObjectFieldsWT( a:obj_name )
  let list_names_types = functional#map( {l -> split( l, ',' ) }, list_names_types )
  let res = []
  for [name, type] in list_names_types
    let isLinkType = type[0] =~ '\u'
    let isArray = type[-1:] == 'A'
    call add( res, {'name': name, 'type': type, 'isArray': isArray, 'isLinkType': isLinkType} )
  endfor
  return res
endfunc
" echoe Adb_getObjectFieldsWTL( 'Region' )
" [{'name': 'other_places', 'isLinkType': 1, 'type': 'OtherPlace'},
" {'name': 'castles', 'isLinkType': 1, 'type': 'Castle'},
" {'name': 'cities', 'isLinkType': 1, 'type': 'City'},
" {'name': 'important_places', 'isLinkType': 0, 'type': 'str'},
" {'name': 'name', 'isLinkType': 0, 'type': 'str'},
" {'name': 'modern_name', 'isLinkType': 0, 'type': 'str'},
" {'name': 'coffins', 'isLinkType': 0, 'type': 'int16'}]

" obj_fields: [{'name': 'other_places', 'isLinkType': 1, 'type': 'OtherPlace', 'isArray': 0}, {'name': 'castles', 'isLinkType': 1, 'type': 'Castle', 'isArray': 0}, {'name': 'cities', 'isLinkType': 1, 'type': 'City', 'isArray': 0}, {'name': 'important_places', 'isLinkType': 0, 'type': 'strA', 'isArray': 1}, {'name': 'name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'modern_name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'coffins', 'isLinkType': 0, 'type': 'int16', 'isArray': 0}]
func! Adb_addStrFieldsToObjFields( obj_fields )
  let res = []
  for field in a:obj_fields
    if field.isLinkType
      let list_names_types = Adb_getObjectFieldsWTL( field.type )
      let strFields = functional#filter( {f -> f.type == 'str'}, list_names_types )
      let fieldNames = functional#map( {f -> f.name }, strFields )
      let field.strFields = ['id'] + fieldNames
    endif
    call add( res, field )
  endfor
  return res
endfunc
" echo Adb_addStrFieldsToObjFields([{'name': 'other_places', 'isLinkType': 1, 'type': 'OtherPlace', 'isArray': 0}, {'name': 'castles', 'isLinkType': 1, 'type': 'Castle', 'isArray': 0}, {'name': 'cities', 'isLinkType': 1, 'type': 'City', 'isArray': 0}, {'name': 'important_places', 'isLinkType': 0, 'type': 'strA', 'isArray': 1}, {'name': 'name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'modern_name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'coffins', 'isLinkType': 0, 'type': 'int16', 'isArray': 0}])


func! Adb_query_withProp( text, details )
  let objectProp = substitute( a:text, ')\|]', '', '')
  " echoe objectProp
  " return
  let query = 'select ' . objectProp . ';'
  call Adb_runQueryShow( v:true, [query] )
endfunc
" echo substitute( 'aber]', ']', '', '')
" echo substitute( 'aber]', ']\|)', '', '')
" echo substitute( 'aber)', ']\|)', '', '')


func! Adb_query_inParans( details )
  let [sLine, sCol] = searchpos( '(', 'cbnW' )
  let [eLine, eCol] = searchpos( ')', 'znW' )
  let sCol += 1
  let eCol -= 1
  let lines = GetTextWithinLineColumns_asLines( sLine, sCol, eLine, eCol )
  " echoe lines
  " return
  call Adb_runQueryShow( v:true, lines )
endfunc
" call Adb_query_inParans( 'ein' )
" see search flags like bnWn /opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/doc/eval.txt#/search.{pattern}%20[,%20{flags}

func! Adb_query_objCount( word, details)
  if a:details
    let line = 'select count( ' . a:word . ' );'
  else
    let line = 'select count( ' . a:word . ' );'
  endif

  call Adb_runQueryShow( v:true, [line] )
endfunc

let g:Adb_queryLinesCount = 1

func! Adb_parag_repl()
  let [startLine, endLine] = ParagraphStartEndLines()
  let lines = getline(startLine, endLine)

  let lines = functional#filter( { l -> !(l =~ "\/\/") }, lines )

  if lines[0] =~ "_query"
    let cmdStr = join(lines, "\n")
    let g:Adb_queryLinesCount = len( lines ) - 1
  else
    let cmdStr = join(lines, "; ")
    let g:Adb_queryLinesCount = 1
  endif
  " echo cmdStr
  " return
  
  " let lines = SubstituteInLines( lines, "'", " " )
  " let cmdStr = substitute( cmdStr, "`;", "`", '')
  let cmdStr = substitute( cmdStr, "gql`", "`", '')

  call AdbReplPost( cmdStr )
endfunc

func! Adb_line_repl()
  call AdbReplPost( getline(".") )
endfunc


func! Adb_eval_parag( format )
  let [startLine, endLine] = ParagraphStartEndLines()
  call Adb_eval_range( a:format, startLine, endLine )
endfunc

func! Adb_eval_buffer( format )
  let [startLine, endLine] = [1, line('$')]
  call Adb_eval_range( a:format, startLine, endLine )
endfunc

func! Adb_describe_object( word, verbose )
  if a:verbose
    let line = ['describe object ' . a:word . ' as text;']
  else
    let line = ['describe object ' . a:word . ' as sdl;']
  endif

  call Adb_runQueryShow( v:true, line )
endfunc

command! ArangoDBStartInstance call Adb_startInstance()

func! Adb_startInstance ()
  let cmd = 'edgedb instance start ' . g:edgedb_instance
  let resLines = systemlist( cmd )
  echo 'EdgeDB instance started: ' . g:edgedb_instance . ' DB: ' . g:edgedb_db
endfunc


command! ArangoDBShowTypes call Adb_showTypes()

func! Adb_showTypes ()
  let cmd = 'edgedb -d ' . g:edgedb_db . ' list types'
  let resLines = systemlist( cmd )
  let g:floatWin_win = FloatingSmallNew ( resLines )
  " call FloatWin_FocusFirst()
  call FloatWin_FitWidthHeight()
endfunc

command! ArangoDBShowSchema call Adb_describe_schema()

func! Adb_describe_schema()
  let line = ['describe schema as sdl;']
  call Adb_runQueryShow( v:true, line )
endfunc

command! ArangoDBShowAllObjects call Adb_showAllObjects()

func! Adb_showAllObjects()
  call Adb_runQueryShow( v:true, ['select count( Object ); select Object { __type__: {name} }'] )
endfunc

" 'select Object { __type__: {name} }'

command! -range=% ArangoDBEval call Adb_eval_range( v:true, <line1>, <line2> )

func! Adb_eval_range ( format, ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')

  let lines = getline(startLine, endLine)
  " echoe lines

  call Adb_runQueryShow( a:format, lines )
endfunc


func! Adb_runQueryShow ( format, query_lines )

  let resLines = Adb_runQuery( a:query_lines )
  " echoe resLines

  let resLines = RemoveTermCodes( resLines )

  if len( resLines ) == 0
    echo "query completed!"
    return
  endif

  if len( resLines ) == 1
    if len( resLines[0] ) > 10
      let resLines = split( resLines[0][1:-2], '\\n' )
      " echoe resLines
      " Note this is a hack to deal with "describe type Movie" return: ['"create type default::MinorVampire extending default::Person {\n    create required link master -> default::Vampire;\n};"']
    endif
    let synt = 'edgeql'
    " let synt = 'json'
  else
    let synt = 'json'
  endif

  " let str_resLines = functional#map( 'string', resLines )

  let g:floatWin_win = FloatingSmallNew ( resLines )
  call Adb_bufferMaps()
  if synt == 'json'
    set syntax=json
  else
    set syntax=edgeql
  endif
  syntax match Normal "->" conceal cchar=→
  syntax match Normal "::" conceal cchar=|
  syntax match Normal ":=" conceal cchar=⫶
  call FloatWin_FitWidthHeight()

  " call tools_db#alignInFloatWin()

endfunc


func! Adb_runQuery( query_lines )
  call jobsend(g:AdbReplID, a:query_lines[0] . "\n" )
endfunc


" func! Adb_runQuery( query_lines )
"   " echoe a:query_lines
"   let filenameSource = expand('%:p:h') . '/.rs_' . expand('%:t:r') . '.edgeql'
"   call writefile( a:query_lines, filenameSource )
"   let resLines = systemlist( 'cat ' . filenameSource . ' | edgedb -d ' . g:edgedb_db )
"   return resLines
" endfunc


func! Adb_showAligned (resLines, plain)
  if a:plain
    let g:floatWin_win = FloatingSmallNew ( resLines )

    " We have reveived a printed nd_array if the first line starts with [[ and has no commas!
  elseif a:resLines[0][0:1] == "[[" && !(a:resLines[0] =~ ",")
    " if 0
    " echo "ndarray"
    let g:floatWin_win = FloatingSmallNew ( a:resLines )

    call FloatWin_FocusFirst()
    exec "%s/\\[//ge"
    exec "%s/]//ge"
    " exec "%s/'//ge"
    call easy_align#easyAlign( 1, line('$'), ',')
    call FloatWin_FitWidthHeight()
    wincmd p

    " Collection returned:
  elseif a:resLines[-1] =~ "[\[|\{|\(]"
  " elseif 0
    let expResult = a:resLines[-1]
    " echoe expResult

    if len( expResult ) > 3
      call v:lua.VirtualTxShow( expResult[:20] . ' ..' )
      let linesResult = repl_py#splitToLines( expResult )
      " echoe linesResult
      " call FloatWin_ShowLines_old ( linesResult )
      let g:floatWin_win = FloatingSmallNew ( linesResult )
      " call FloatWin_ShowLines ( repl_py#splitToLines( expResult ) )
      if len(linesResult) > 2
        call repl_py#alignInFloatWin()
      endif
    else
      call v:lua.VirtualTxShow( expResult )
    endif

  else
    " Printed object:
    let g:floatWin_win = FloatingSmallNew ( a:resLines )
    if len(a:resLines) > 2
      call repl_py#alignInFloatWin()
    endif
  endif
endfunc














