
" Note plugin/ftype/typedb.lua

" ─   Maps                                              ──

func! TypeDB_bufferMaps()
  call Scala_bufferMaps_shared()

  nnoremap <silent><buffer> <leader>es :call EdgeQLSyntaxAdditions()<cr>

  nnoremap <silent><buffer> gej :let g:cmdAltMode=0<cr>:call Tdb_eval_parag()<cr>
  nnoremap <silent><buffer> gei :let g:cmdAltMode=0<cr>:call Tdb_eval_parag()<cr>
  nnoremap <silent><buffer> ,gej :let g:cmdAltMode=1<cr>:call Tdb_eval_parag()<cr>
  nnoremap <silent><buffer> ,gei :let g:cmdAltMode=1<cr>:call Tdb_eval_parag()<cr>

  nnoremap gq    m':let g:opContFn='Tdb_query_textObj'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
  vnoremap gq :<c-u>let g:opContFn='Tdb_query_textObj'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>

  " nnoremap <silent><buffer> <leader>ge :let g:opContFn='Tdb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:set opfunc=Gen_opfuncAc<cr>g@
  " vnoremap <silent><buffer> <leader>gei :<c-u>let g:opContFn='Tdb_eval_range'<cr>:let g:opContArgs=[v:true]<cr>:call Gen_opfuncAc('', 1)<cr>
  nnoremap <silent><buffer> <leader>geo :call Tdb_eval_buffer( v:true )<cr>

  nnoremap <silent><buffer> get :call Tdb_describe_object( expand('<cWORD>') )<cr>

  nnoremap <silent><buffer> <leader>K :call Tdb_describe_schema()<cr>

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


" EXAMPLE transaction:
" transaction schema my_test_db
" define
"   entity user, owns username;
"   attribute username, value string;

" commit

func! Tdb_withTransactionLines( query_lines )
  let firstLn = ["transaction schema " . g:typedb_active_schema]
  let commitLns = ["", "commit"]
  return firstLn + a:query_lines + commitLns
endfunc

let g:typedb_cmd_base = "typedb console --tls-disabled --address http://0.0.0.0:1729 --username admin --password password "

func! Tdb_runQuery( query_lines )
  let transaction_lines = Tdb_withTransactionLines( a:query_lines )
  " return transaction_lines

  let filenameSource = 'temp/lastQuery.tqls'
  call writefile( transaction_lines, filenameSource )


  let cmd = g:typedb_cmd_base . "--script " . filenameSource
  let resLines = systemlist( cmd )

  return resLines
endfunc


func! Tdb_showAligned (resLines, plain)
  if a:plain
    let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )

    " We have reveived a printed nd_array if the first line starts with [[ and has no commas!
  elseif a:resLines[0][0:1] == "[[" && !(a:resLines[0] =~ ",")
    " if 0
    " echo "ndarray"
    let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )

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
      let g:floatWin_win = FloatingSmallNew ( linesResult, 'cursor' )

      " call FloatWin_ShowLines ( repl_py#splitToLines( expResult ) )
      if len(linesResult) > 2
        call repl_py#alignInFloatWin()
      endif
    else
      call v:lua.VirtualTxShow( expResult )
    endif

  else
    " Printed object:
    let g:floatWin_win = FloatingSmallNew ( a:resLines, 'cursor' )

    if len(a:resLines) > 2
      call repl_py#alignInFloatWin()
    endif
  endif
endfunc


" ─^  Run queries                                        ▲


" ─   Show results                                       ■

func! Tdb_runQueryShow ( query_lines )

  let resLines = Tdb_runQuery( a:query_lines )
  " echo resLines
  " return

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



  if resLines[0] =~ '\v(function|t_off_ype)'
    let resLines[0] = resLines[0][1:]
    let resLines[-1] = resLines[-1][:-2]

    let resLines = Tdb_filterProp( resLines, "link __type__" )
    let resLines = Tdb_filterProp( resLines, " id: std::uuid" )
  endif

  let g:floatWin_win = FloatingSmallNew ( resLines, 'cursor' )
  if resLines[0] =~ '\v(function|t_off_ype)'
    let synt = 'edgeql'
  elseif !(resLines[0] =~ "error") && len(resLines) > 1
    " silent! exec "%!jq"
    if !g:cmdAltMode
      silent! exec "silent! g/\"id\"\:/d _"
    endif
  elseif resLines[0][0] == "{" || resLines[0][0] == "["
    " silent! exec "%!jq"
    let synt = 'json'
  endif

  call Tdb_addObjCountToBuffer()

  normal gg

  " call Tdb_bufferMaps()
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
    call append( 0, len(bufferLines) - 0 . " lines" )
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









