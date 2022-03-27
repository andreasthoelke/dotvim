
" let g:edgedb_db = 'edgedb'
let g:edgedb_db = 'dracula'

func! tools_edgedb#bufferMaps()
  nnoremap <silent><buffer> gei :call tools_edgedb#eval_parag( v:true )<cr>
  nnoremap <silent><buffer> geI :call tools_edgedb#eval_parag( v:false )<cr>

  nnoremap gq    m':let g:opContFn='tools_edgedb#query_textObj'<cr>:let g:opContArgs=[]<cr>:set opfunc=OperateOnSelText<cr>g@
  vnoremap gq :<c-u>let g:opContFn='tools_edgedb#query_textObj'<cr>:let g:opContArgs=[]<cr>:call OperateOnSelText(visualmode(), 1)<cr>

  " nnoremap <silent><buffer> <leader>ge :let g:opContFn='tools_edgedb#eval_range'<cr>:let g:opContArgs=[v:true]<cr>:set opfunc=Gen_opfuncAc<cr>g@
  " vnoremap <silent><buffer> <leader>gei :<c-u>let g:opContFn='tools_edgedb#eval_range'<cr>:let g:opContArgs=[v:true]<cr>:call Gen_opfuncAc('', 1)<cr>
  nnoremap <silent><buffer> <leader>geo :call tools_edgedb#eval_buffer( v:true )<cr>

  nnoremap <silent><buffer> get :call tools_edgedb#describe_object( expand('<cword>'), v:false )<cr>
  nnoremap <silent><buffer> geT :call tools_edgedb#describe_object( expand('<cword>'), v:true )<cr>
  nnoremap <silent><buffer> ,K :call tools_edgedb#describe_object( expand('<cword>'), v:false )<cr>
  nnoremap <silent><buffer> ,,K :call tools_edgedb#describe_object( expand('<cword>'), v:true )<cr>

  nnoremap <silent><buffer> <leader>K :call tools_edgedb#describe_schema()<cr>

  nnoremap <silent><buffer> gec :call tools_edgedb#query_objCount( expand('<cword>'), v:false )<cr>
  nnoremap <silent><buffer> gea :call tools_edgedb#query_withProp( expand('<cWORD>'), v:false )<cr>

  nnoremap <silent><buffer> ges :call tools_edgedb#query_inParans( v:false )<cr>

  nnoremap <silent><buffer> gsk :call tools_edgedb#showObjectFields( expand('<cword>') )<cr>
  nnoremap <silent><buffer> gsf :call tools_edgedb#queryAllObjectFields( expand('<cword>') )<cr>

endfunc

func! tools_edgedb#query_textObj( sel_str )
  " echoe a:sel_str
  " return
  call tools_edgedb#runQueryShow( v:true, a:sel_str )
endfunc


func! tools_edgedb#queryAllObjectFields( obj_name )
  let fieldNames = tools_edgedb#getObjectFields( a:obj_name )
  let fieldsStr = join( fieldNames, ', ' )
  let query = 'select ' . a:obj_name . ' {' . fieldsStr . '};'
  " let resLines = tools_edgedb#runQuery( query )
  call tools_edgedb#runQueryShow( v:true, [query] )
endfunc

func! tools_edgedb#showObjectFields( obj_name )
  let fieldNames = tools_edgedb#getObjectFields( a:obj_name )
  let g:floatWin_win = FloatingSmallNew ( fieldNames )
  call tools_edgedb#bufferMaps()
  " set syntax=edgeql
  call FloatWin_FitWidthHeight()
endfunc

func! tools_edgedb#getObjectFields( obj_name )
  let q1 = "with infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::"
  let q2 = "'), links_cl := (select infos.links filter .name != '__type__'), properties_cl := (select infos.properties filter .name != 'id'), select (properties_cl union links_cl).name"

  let query = q1 . a:obj_name . q2
  let resLines = tools_edgedb#runQuery( [query] )

  let cleanedLines = SubstituteInLines( resLines, '"', '' )
  return cleanedLines
endfunc

" with
"   infos := (select schema::ObjectType { links: { name }, properties: { name } } filter .name = 'default::Vampire'),
"   links_cl := (select infos.links filter .name != '__type__'),
"   properties_cl := (select infos.properties filter .name != 'id'),
" select (properties_cl union links_cl).name


func! tools_edgedb#query_withProp( text, details )
  let objectProp = substitute( a:text, ')\|]', '', '')
  " echoe objectProp
  " return
  let query = 'select ' . objectProp . ';'
  call tools_edgedb#runQueryShow( v:true, [query] )
endfunc
" echo substitute( 'aber]', ']', '', '')
" echo substitute( 'aber]', ']\|)', '', '')
" echo substitute( 'aber)', ']\|)', '', '')


func! tools_edgedb#query_inParans( details )
  let [sLine, sCol] = searchpos( '(', 'cbnW' )
  let [eLine, eCol] = searchpos( ')', 'znW' )
  let sCol += 1
  let eCol -= 1
  let lines = GetTextWithinLineColumns_asLines( sLine, sCol, eLine, eCol )
  echoe lines
  return
  call tools_edgedb#runQueryShow( v:true, lines )
endfunc
" call tools_edgedb#query_inParans( 'ein' )
" see search flags like bnWn /opt/homebrew/Cellar/neovim/0.6.0/share/nvim/runtime/doc/eval.txt#/search.{pattern}%20[,%20{flags}

func! tools_edgedb#query_objCount( word, details)
  if a:details
    let line = 'select count( ' . a:word . ' );'
  else
    let line = 'select count( ' . a:word . ' );'
  endif

  call tools_edgedb#runQueryShow( v:true, [line] )
endfunc

func! tools_edgedb#eval_parag( format )
  let [startLine, endLine] = ParagraphStartEndLines()
  call tools_edgedb#eval_range( a:format, startLine, endLine )
endfunc

func! tools_edgedb#eval_buffer( format )
  let [startLine, endLine] = [1, line('$')]
  call tools_edgedb#eval_range( a:format, startLine, endLine )
endfunc

func! tools_edgedb#describe_object( word, verbose )
  if a:verbose
    let line = ['describe object ' . a:word . ' as text;']
  else
    let line = ['describe object ' . a:word . ' as sdl;']
  endif

  call tools_edgedb#runQueryShow( v:true, line )
endfunc

func! tools_edgedb#describe_schema()
  let line = ['describe schema as sdl;']
  call tools_edgedb#runQueryShow( v:true, line )
endfunc

" command! -range=% EdgeDBEval call tools_edgedb#eval( <line1>, <line2> )

func! tools_edgedb#eval_range ( format, ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')

  let lines = getline(startLine, endLine)

  call tools_edgedb#runQueryShow( a:format, lines )
endfunc


func! tools_edgedb#runQueryShow ( format, query_lines )

  let resLines = tools_edgedb#runQuery( a:query_lines )

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
  call tools_edgedb#bufferMaps()
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


func! tools_edgedb#runQuery( query_lines )
  let filenameSource = expand('%:p:h') . '/.rs_' . expand('%:t:r') . '.edgeql'
  call writefile( a:query_lines, filenameSource )

  let resLines = systemlist( 'cat ' . filenameSource . ' | edgedb -d ' . g:edgedb_db )
  return resLines
endfunc


func! tools_edgedb#showAligned (resLines, plain)
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














