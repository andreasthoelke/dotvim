
let g:edgedb_db = 'edgedb'
" let g:edgedb_db = 'dracula'
" let g:edgedb_db = 'dracula1'
" let g:edgedb_db = 'dracula4'
" let g:edgedb_db = 'ch20_1'

let g:edgedb_instance = '_1playground_2'
" let g:edgedb_instance = '_1playground_2'


func! Edb_bufferMaps()
  call Scala_bufferMaps_shared()

  nnoremap <silent><buffer> <leader>es :call EdgeQLSyntaxAdditions()<cr>

  nnoremap <silent><buffer> gej :let g:withId=0<cr>:call Edb_eval_parag()<cr>
  nnoremap <silent><buffer> gei :let g:withId=0<cr>:call Edb_eval_parag()<cr>
  nnoremap <silent><buffer> ,gej :let g:withId=1<cr>:call Edb_eval_parag()<cr>
  nnoremap <silent><buffer> ,gei :let g:withId=1<cr>:call Edb_eval_parag()<cr>

  nnoremap gq    m':let g:opContFn='Edb_query_textObj'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
  vnoremap gq :<c-u>let g:opContFn='Edb_query_textObj'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>

  " nnoremap <silent><buffer> <leader>ge :let g:opContFn='Edb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:set opfunc=Gen_opfuncAc<cr>g@
  " vnoremap <silent><buffer> <leader>gei :<c-u>let g:opContFn='Edb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:call Gen_opfuncAc('', 1)<cr>
  nnoremap <silent><buffer> <leader>geo :call Edb_eval_buffer( v:true )<cr>

  nnoremap <silent><buffer> get :call Edb_describe_object( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> <leader>K :call Edb_describe_schema()<cr>

  nnoremap <silent><buffer> gec :call Edb_query_objCount( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> gea :call Edb_query_withProp( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> ges :call Edb_query_inParans( v:false )<cr>

  nnoremap <silent><buffer> gSk :call Edb_showObjectFields( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> gsk :call Edb_showObjectFieldsWT( expand('<cWORD>') )<cr>
  " nnoremap <silent><buffer> gsf :call Edb_queryAllObjectFieldsTablePermMulti( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> gsF :let g:withId=0<cr>:call Edb_queryAllObjectFields_withInnerObjs( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> <leader>gsf :let g:withId=0<cr>:call Edb_queryAllObjectFields( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> ,gsF :let g:withId=1<cr>:call Edb_queryAllObjectFields_withInnerObjs( expand('<cWORD>') )<cr>
  nnoremap <silent><buffer> ,gsf :let g:withId=1<cr>:call Edb_queryAllObjectFields( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> ,,gsd :call Edb_queryDeleteObject( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> <leader>gsF :call Edb_queryAllObjectFields_InnerFields( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> gsK :silent call EdbReplPost( '\d object ' . expand('<cWORD>') )<cr>

  " ─     Copied from Tools_Scala                         ──
  nnoremap <silent><buffer> <leader><c-p> :call Edb_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <c-p>         :call Edb_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  " nnoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>
  " onoremap <silent><buffer> <leader>)     :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>(     :call Edb_MvStartOfBlock()<cr>
  " onoremap <silent><buffer> <leader>(     :call Edb_MvStartOfBlock()<cr>
  onoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>
  vnoremap <silent><buffer> <leader>(     :<c-u>call BlockStart_VisSel()<cr>

  nnoremap <silent><buffer> <leader>)     :call Edb_MvEndOfBlock()<cr>
  onoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>
  vnoremap <silent><buffer> <leader>)     :<c-u>call BlockEnd_VisSel()<cr>

  nnoremap <silent><buffer> * :call MvPrevLineStart()<cr>
  nnoremap <silent><buffer> ( :call MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call MvNextLineStart()<cr>

  nnoremap <silent><buffer> I :call Edb_ColonForw()<cr>
  nnoremap <silent><buffer> Y :call Edb_ColonBackw()<cr>

  nnoremap <silent><buffer> [b            :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Edb_TopLevBindingForw()<cr>:call ScrollOff(16)<cr>
  nnoremap <silent><buffer> <c-n>         :call Edb_MainStartBindingForw()<cr>:call ScrollOff(16)<cr>
  " " find a new map if I actually use this:
  " nnoremap <silent><buffer> <leader><c-p> :call JS_MvEndOfPrevBlock()<cr>
  nnoremap <silent><buffer> ]b            :call JS_MvEndOfBlock()<cr>

  nnoremap <silent><buffer> <leader>yab :call JS_YankCodeBlock()<cr>



endfunc

func! Edb_query_textObj( sel_str )
  " echoe a:sel_str
  " return
  call Edb_runQueryShow( a:sel_str )
endfunc


func! Edb_queryAllObjectFields_InnerFields( select_clause )
  let sc_words = split( a:select_clause )
  if len( sc_words ) > 1
    let obj_name = sc_words[1]
    let select_clause = a:select_clause
  else
    let obj_name = sc_words[0]
    let select_clause = 'select ' . obj_name
  endif
  let objFields = Edb_getObjectFieldsWTL( obj_name )
  let objFields = Edb_addStrFieldsToObjFields( objFields )
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
  call Edb_runQueryShow( [query] )
  " Can't parse/turn this string into a dictionary
  " let resLines = Edb_runQuery( [query] )
  " let resLines = join( resLines )
  " let resLines = substitute( resLines, ' null,', ' "null",', 'g' )
  " let resLines = eval( resLines )
  " echo resLines

endfunc
" call Edb_queryAllObjectFieldsTable( 'select Region' )

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


func! Edb_queryAllObjectFieldsTablePermMulti( obj_name )
  " This query uses a tuple of sub-queries(?) and therefore *permutes* all mutiple linked objects resulting in additional lines in the table. Which is ok, but see the other approach ..
  " with
  "   obj := (select Region filter .name = 'Prussia'),
  "   fieldVals := (obj.name, obj.cities, obj.other_places, <json>obj.castles ?? <json>'-'),
  " select fieldVals

  let fieldNames = Edb_getObjectFields( a:obj_name )
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
  " call EdbReplPlain( query )
  let resLines = Edb_runQuery( [query] )
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
  call Edb_bufferMaps()
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
" call Edb_queryAllObjectFieldsTable( 'Vampire' )

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

func! Edb_prependModule( obj_name )
  let line = split( getline( 1 ), " " )
  if !len(line) || line[0] != "module"
    return a:obj_name
  endif
  return line[1] . "::" . a:obj_name
endfunc

func! Edb_queryAllObjectFields( obj_name )
  let obj_name = split( a:obj_name, '\.' )[0]
  let query = 'select count( ' . Edb_prependModule(obj_name) . ' );'
  let query = query . 'select ' . Edb_prependModule(obj_name) . ' {*};'
  call Edb_runQueryShow( [query] )
endfunc

func! Edb_queryAllObjectFields_withInnerObjs( obj_name )
  let obj_name = split( a:obj_name, '\.' )[0]
  let query = 'select count( ' . Edb_prependModule(obj_name) . ' );'
  let query = query . 'select ' . Edb_prependModule(obj_name) . ' {**};'
  call Edb_runQueryShow( [query] )
endfunc

func! Edb_queryDeleteObject( obj_name )
  let obj_name = split( a:obj_name, '\.' )[0]
  let query = 'delete ' . Edb_prependModule(obj_name) . ";"
  call Edb_runQueryShow( [query] )
endfunc



func! Edb_showObjectFields( obj_name )
  let fieldNames = Edb_getObjectFields( a:obj_name )
  let g:floatWin_win = FloatingSmallNew ( fieldNames )
  call Edb_bufferMaps()
  " set syntax=edgeql
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc

func! Edb_getObjectFields( obj_name )
  let q1 = "with infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::"
  let q2 = "'), links_cl := (select infos.links filter .name != '__type__'), properties_cl := (select infos.properties filter .name != 'id'), select (properties_cl union links_cl).name"
  let query = q1 . a:obj_name . q2
  let resLines = Edb_runQuery( [query] )
  let cleanedLines = SubstituteInLines( resLines, '"', '' )
  return cleanedLines
endfunc

" with
"   infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::Vampire'),
"   links_cl := (select infos.links filter .name != '__type__'),
"   properties_cl := (select infos.properties filter .name != 'id'),
" select (properties_cl union links_cl).name


func! Edb_showObjectFieldsWT( obj_name )
  let fieldNames = Edb_getObjectFieldsWT( a:obj_name )
  let g:floatWin_win = FloatingSmallNew ( fieldNames )
  call Edb_bufferMaps()
  " set syntax=edgeql
  call easy_align#easyAlign( 1, line('$'), ',')
  exec "%s/,//ge"
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc

func! Edb_getObjectFieldsWT( obj_name )
  let q1 = "with infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::"
  let q2 = "'), links_cl := (select infos.links filter .name != '__type__'), properties_cl := (select infos.properties filter .name != 'id'), fields := (properties_cl union links_cl), select fields.name ++ ',' ++ fields.target.name"
  let query = q1 . a:obj_name . q2
  let resLines = Edb_runQuery( [query] )
  let cleanedLines = SubstituteInLines( resLines, '"', '' )
  let cleanedLines = SubstituteInLines( cleanedLines, ',.*\:', ',' )
  let cleanedLines = SubstituteInLines( cleanedLines, '>', 'A' )
  return cleanedLines
endfunc

func! Edb_getObjectFieldsWTP( obj_name )
  let q1 = "with infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::"
  let q2 = "'), links_cl := (select infos.links filter .name != '__type__'), properties_cl := (select infos.properties filter .name != 'id'), fields := (properties_cl union links_cl), select fields.name ++ ',' ++ fields.target.name"
  let query = q1 . a:obj_name . q2
  return Edb_runQuery( [query] )
endfunc

" with
"   infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::Vampire'),
"   links_cl := (select infos.links filter .name != '__type__'),
"   properties_cl := (select infos.properties filter .name != 'id'),
"   fields := (properties_cl union links_cl)
" select fields.name ++ ',' ++ fields.target.name

func! Edb_getObjectFieldsWTL( obj_name )
  let list_names_types = Edb_getObjectFieldsWT( a:obj_name )
  let list_names_types = functional#map( {l -> split( l, ',' ) }, list_names_types )
  let res = []
  for [name, type] in list_names_types
    let isLinkType = type[0] =~ '\u'
    let isArray = type[-1:] == 'A'
    call add( res, {'name': name, 'type': type, 'isArray': isArray, 'isLinkType': isLinkType} )
  endfor
  return res
endfunc
" echoe Edb_getObjectFieldsWTL( 'Region' )
" [{'name': 'other_places', 'isLinkType': 1, 'type': 'OtherPlace'},
" {'name': 'castles', 'isLinkType': 1, 'type': 'Castle'},
" {'name': 'cities', 'isLinkType': 1, 'type': 'City'},
" {'name': 'important_places', 'isLinkType': 0, 'type': 'str'},
" {'name': 'name', 'isLinkType': 0, 'type': 'str'},
" {'name': 'modern_name', 'isLinkType': 0, 'type': 'str'},
" {'name': 'coffins', 'isLinkType': 0, 'type': 'int16'}]

" obj_fields: [{'name': 'other_places', 'isLinkType': 1, 'type': 'OtherPlace', 'isArray': 0}, {'name': 'castles', 'isLinkType': 1, 'type': 'Castle', 'isArray': 0}, {'name': 'cities', 'isLinkType': 1, 'type': 'City', 'isArray': 0}, {'name': 'important_places', 'isLinkType': 0, 'type': 'strA', 'isArray': 1}, {'name': 'name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'modern_name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'coffins', 'isLinkType': 0, 'type': 'int16', 'isArray': 0}]
func! Edb_addStrFieldsToObjFields( obj_fields )
  let res = []
  for field in a:obj_fields
    if field.isLinkType
      let list_names_types = Edb_getObjectFieldsWTL( field.type )
      let strFields = functional#filter( {f -> f.type == 'str'}, list_names_types )
      let fieldNames = functional#map( {f -> f.name }, strFields )
      let field.strFields = ['id'] + fieldNames
    endif
    call add( res, field )
  endfor
  return res
endfunc
" echo Edb_addStrFieldsToObjFields([{'name': 'other_places', 'isLinkType': 1, 'type': 'OtherPlace', 'isArray': 0}, {'name': 'castles', 'isLinkType': 1, 'type': 'Castle', 'isArray': 0}, {'name': 'cities', 'isLinkType': 1, 'type': 'City', 'isArray': 0}, {'name': 'important_places', 'isLinkType': 0, 'type': 'strA', 'isArray': 1}, {'name': 'name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'modern_name', 'isLinkType': 0, 'type': 'str', 'isArray': 0}, {'name': 'coffins', 'isLinkType': 0, 'type': 'int16', 'isArray': 0}])


func! Edb_query_withProp( text )
  let objectProp = substitute( a:text, ')\|]', '', '')
  " echoe objectProp
  " return
  let query = 'select ' . objectProp . ';'
  call Edb_runQueryShow( [query] )
endfunc
" echo substitute( 'aber]', ']', '', '')
" echo substitute( 'aber]', ']\|)', '', '')
" echo substitute( 'aber)', ']\|)', '', '')


func! Edb_query_inParans( details )
  let [sLine, sCol] = searchpos( '(', 'cbnW' )
  let [eLine, eCol] = searchpos( ')', 'znW' )
  let sCol += 1
  let eCol -= 1
  let lines = GetTextWithinLineColumns_asLines( sLine, sCol, eLine, eCol )
  " echoe lines
  " return
  call Edb_runQueryShow( lines )
endfunc
" call Edb_query_inParans( 'ein' )
" see search flags like bnWn /opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/doc/eval.txt#/search.{pattern}%20[,%20{flags}

func! Edb_query_objCount( obj )
  let line = 'select count( ' . Edb_prependModule(a:obj) . ' );'

  call Edb_runQueryShow( [line] )
endfunc

func! Edb_eval_parag()
  let [startLine, endLine] = ParagraphStartEndLines()
  call Edb_eval_range( startLine, endLine )
endfunc



func! Edb_eval_buffer( format )
  let [startLine, endLine] = [1, line('$')]
  call Edb_eval_range( startLine, endLine )
endfunc


func! Edb_filterProp( lines, propStr )
  let lineNum = functional#find( a:lines, a:propStr )
  if lineNum == -1
    return a:lines
  endif
  return a:lines[ 0 : lineNum - 1 ] + a:lines[ lineNum + 3 : -1 ]
endfunc

" Edb_filterProp( resLines, "link __type__" )
" functional#find(['eins', 'zwei', 'aber'], 'be') != -1 ? 'yes' : 'no'
" find start line
" delete range of lines
" example to be filtered: 
" type mov::Season {
"     required single link __type__: schema::ObjectType {
"         readonly := true;
"     };
"     required single link show: mov::Show;
"     required single property id: std::uuid {
"         readonly := true;
"     };
"     required single property number: std::int32;
" };




func! Edb_describe_object( obj_name )
  let obj_name = a:obj_name
  let obj_name = split( obj_name, "(" )[0] " for function names
  let cmd = "edgedb describe object " . Edb_prependModule(obj_name) 
  let resLines = systemlist( cmd )
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
  endif

  let resLines = Edb_filterProp( resLines, "link __type__" )
  let resLines = Edb_filterProp( resLines, " id: std::uuid" )

  let g:floatWin_win = FloatingSmallNew ( resLines )

  set syntax=edgeql
  set ft=edgeql
  call EdgeQLSyntaxAdditions()

  call FloatWin_FitWidthHeight()
  wincmd p

endfunc

func! Edb_describe_schema( )
  let cmd = "edgedb describe schema" 
  let resLines = systemlist( cmd )
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
  endif

  let resLines = Edb_filterProp( resLines, "link __type__" )
  let resLines = Edb_filterProp( resLines, " id: std::uuid" )

  let g:floatWin_win = FloatingSmallNew ( resLines )

  set syntax=edgeql
  set ft=edgeql
  call EdgeQLSyntaxAdditions()

  call FloatWin_FitWidthHeight()
  wincmd p

endfunc


command! EdgeDBStartInstance call Edb_startInstance()

func! Edb_startInstance ()
  let cmd = 'edgedb instance start ' . g:edgedb_instance
  let resLines = systemlist( cmd )
  echo 'EdgeDB instance started: ' . g:edgedb_instance . ' DB: ' . g:edgedb_db
endfunc


command! EdgeDBShowTypes call Edb_showTypes()

func! Edb_showTypes ()
  let cmd = 'edgedb -d ' . g:edgedb_db . ' list types'
  let resLines = systemlist( cmd )
  let g:floatWin_win = FloatingSmallNew ( resLines )
  " call FloatWin_FocusFirst()
  call FloatWin_FitWidthHeight()
  wincmd p
endfunc

command! EdgeDBShowSchema call Edb_describe_schema()

command! EdgeDBShowAllObjects call Edb_showAllObjects()

func! Edb_showAllObjects()
  call Edb_runQueryShow( ['select count( Object ); select Object { __type__: {name} }'] )
endfunc

" 'select Object { __type__: {name} }'

command! -range=% EdgeDBEval call Edb_eval_range( <line1>, <line2> )

func! Edb_eval_range ( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')

  let lines = getline(startLine, endLine)
  " " TODO: wrap in with and the get count of result items?
  " if split(lines[0])[0] == "select"
  " endif

  call Edb_runQueryShow( lines )
endfunc


func! Edb_runQueryShow ( query_lines )

  let resLines = Edb_runQuery( a:query_lines )
  " echoe resLines

  let resLines = RemoveTermCodes( resLines )
  let resLines = SubstituteInLines( resLines, ';', '' )
  let resLines = SubstituteInLines( resLines, 'property ', '' )

  if len( resLines ) == 0
    echo "query completed!"
    return
  endif

  if len( resLines ) == 1
    if len( resLines[0] ) > 10
      " let resLines = split( resLines[0][1:-2], '\\n' )
      let resLines = split( resLines[0], '\\n' )
      " echoe resLines
      " Note this is a hack to deal with "describe type Movie" return: ['"create type default::MinorVampire extending default::Person {\n    create required link master -> default::Vampire;\n};"']
    endif
    let synt = 'edgeql'
    " let synt = 'json'
  else
    let synt = 'json'
  endif

  " if !g:withId
  "   let newResLines = resLines
  "   " let newResLines = functional#filter( {l -> !(l =~ '\s\"id\"\:')}, resLines )
  "   " let newResLines = SubstituteInLines( newResLines, '\v\"id":.*,', '' )
  "   " substitute in lines till ,
  "   " {"id": "1b0d2bb2-17e3-11ee-9fc1-5b64e2c5681c",
  "   " only filter lines with '"id" if there are other lines.
  "   " some small objects props are return as a single line
  "   if len(newResLines) > 1
  "     let resLines = newResLines
  "   endif
  " endif


  if resLines[0] =~ '\v(function|t_off_ype)'
    let resLines[0] = resLines[0][1:]
    let resLines[-1] = resLines[-1][:-2]

    let resLines = Edb_filterProp( resLines, "link __type__" )
    let resLines = Edb_filterProp( resLines, " id: std::uuid" )
  endif

  let g:floatWin_win = FloatingSmallNew ( resLines )
  if resLines[0] =~ '\v(function|t_off_ype)'
    let synt = 'edgeql'
  elseif !(resLines[0] =~ "error") && len(resLines) > 1
    silent! exec "%!jq"
    if !g:withId
      silent! exec "silent! g/\"id\"\:/d _"
    endif
  elseif resLines[0][0] == "{" || resLines[0][0] == "["
    silent! exec "%!jq"
    let synt = 'json'
  endif

  call Edb_addObjCountToBuffer()

  normal gg

  call Edb_bufferMaps()
  if synt == 'json'
    set syntax=json
    set ft=json
  else
    set syntax=edgeql
    set ft=edgeql

    call EdgeQLSyntaxAdditions()
  endif

  call FloatWin_FitWidthHeight()
  wincmd p

  " call tools_db#alignInFloatWin()
endfunc

" relies of jq json formatting
func! Edb_addObjCountToBuffer()
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
    call append( 0, len(bufferLines) - 0 . " lines" )
  endif
endfunc

let g:edgedb_query_cmd = "edgedb query --output-format json-pretty --file temp/lastQuery.edgeql --database " . g:edgedb_db

func! Edb_runQuery( query_lines )
  " echo a:query_lines
  " return
  " let filenameSource = expand('%:p:h') . '/.rs_' . expand('%:t:r') . '.edgeql'
  let filenameSource = 'temp/lastQuery.edgeql'
  call writefile( a:query_lines, filenameSource )

  " let resLines = systemlist( 'cat ' . filenameSource . ' | edgedb -d ' . g:edgedb_db )

  let cmd = "edgedb query --output-format json-pretty --file " . filenameSource . " --database " . g:edgedb_db
  let resLines = systemlist( cmd )

  return resLines
endfunc


func! Edb_showAligned (resLines, plain)
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



" NOTE: jumping to main definitions relies on empty lines (no hidden white spaces). this is bc/ of the '}' motion. could write a custom motion to improve this.
let g:Edb_MainStartPattern = '\v(select|insert|SELECT|INSERT|type|TYPE)'
let g:Edb_TopLevPattern = '\v^(select|insert|SELECT|INSERT|type|TYPE)'

func! Edb_TopLevBindingForw()
  call search( g:Edb_TopLevPattern, 'W' )
endfunc

func! Edb_MainStartBindingForw()
  " normal! }
  normal! jj
  call search( g:Edb_MainStartPattern, 'W' )
endfunc

func! Edb_TopLevBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Edb_TopLevPattern, 'bW' )
  " normal! {
  " normal! kk
  " call search( g:Edb_TopLevPattern, 'W' )
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc


func! Edb_MainStartBindingBackw()
  " NOTE: this works nicely here: ~/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/G_DomainModeling.scala#///%20Variance
  call search( g:Edb_MainStartPattern, 'bW' )
  " normal! {
  normal! kk
  call search( g:Edb_MainStartPattern, 'W' )
  " call search( '\v^(export|function|const|let)\s', 'W' )
endfunc

" call search('\v^(\s*)?call', 'W')

func! Edb_MvStartOfBlock()
  normal! k
  exec "silent keepjumps normal! {"
  normal! j^
endfunc


func! Edb_MvEndOfBlock()
  normal! j
  exec "silent keepjumps normal! }"
  normal! k^
endfunc

func! MakeOrPttn( listOfPatterns )
  return '\(' . join( a:listOfPatterns, '\|' ) . '\)'
endfunc

let g:Edb_colonPttn = MakeOrPttn( ['\:\:', '\/\/', '*>', '-', '=', 'extends', 'yield', 'if', 'then', 'else', '\$'] )

func! Edb_ColonForw()
  call SearchSkipSC( g:Edb_colonPttn, 'W' )
  normal w
endfunc

func! Edb_ColonBackw()
  normal bh
  call SearchSkipSC( g:Edb_colonPttn, 'bW' )
  normal w
endfunc









