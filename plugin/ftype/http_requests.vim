

nnoremap <silent> geh :call Scala_ServerClientRequest_x()<cr>


let g:httpport = 8080
" let g:httpport = 5000
" let g:httpdomain = '127.0.0.1'
let g:httpdomain = 'localhost'

func! Httpx_parse( source, result )
  if     a:source[0][0] == "-"
    let val = join( a:source, " " )
    let rest = []

  " elseif a:source[0] == "-j"
  elseif a:source[0] =~ '\v(POST|PUT|DELETE|UPDATE)'
    let val = "-m " . a:source[0]
    let rest = a:source[1:]
  else
    let val = "-m GET"
    let rest = a:source
  endif

  return [rest, a:result . " " . val]
endfunc


" ISSUE: can't fetch this simple route:
" ~/Documents/Proj/h_frontend/b_lamin_fullstack/server/src/main/scala/com/raquo/server/Server.scala‖/GETˍ->ˍRoot

func! Scala_ServerClientRequest_x()
  let sourceLineItems = split( matchstr( getline("."), '\v(//\s)?\zs.*' ), " " )

  let url = sourceLineItems[0]
  let sourceLineItems = sourceLineItems[1:]

  " call append(line('.'), sourceLineItems)
  
  let extension = ""

  while len( sourceLineItems )
    let [sourceLineItems, extension] = Httpx_parse( sourceLineItems, extension )
  endwhile

  " echo extension
  " return

  let url = "http://" . g:httpdomain . ":" . g:httpport . "/" . url

  let g:scala_serverRequestCmd = "httpx " . url . extension
  " call append(line('.'), g:scala_serverRequestCmd)
  " return

  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )

  let jsonStartLine = functional#findP( resultLines, {x-> x =~ '\v^(\{|\[)'} )
  if jsonStartLine != -1
    let resultLines = resultLines[jsonStartLine:]
  endif

  " call Scala_showInFloat( resultLines )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines, 'otherWinColumn' )
  if len( resultLines ) && !(resultLines[0] =~ 'error') && !(resultLines[0] =~ 'html')
    if jsonStartLine != -1
      silent exec "%!jq"
      call Edb_addObjCountToBuffer()
    endif
  endif

  set ft=json
  call TsSyntaxAdditions()
  silent call FloatWin_FitWidthHeight()
  silent wincmd p

endfunc


func! Scala_ServerClientRequest( args, mode )
  let urlEx = matchstr( getline("."), '\v(//\s)?\zs.*' )

  " let g:scala_serverRequestCmd = "http " . a:args . " :" . g:httpport . "/" . urlEx . " --ignore-stdin --stream"
  let g:scala_serverRequestCmd = "http " . a:args . " " . g:httpdomain . ":" . g:httpport . "/" . urlEx . " --ignore-stdin --stream"
  " call append(line('.'), g:scala_serverRequestCmd)
  " return
  if a:mode == 'term'
    call TermOneShot( g:scala_serverRequestCmd )
  else
    let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
    " call Scala_showInFloat( resultLines )
    silent let g:floatWin_win = FloatingSmallNew ( resultLines )
    if len( resultLines ) && !(resultLines[0] =~ 'error') && !(resultLines[0] =~ 'html')
      silent exec "%!jq"
    endif

    set ft=json
    call TsSyntaxAdditions()
    silent call FloatWin_FitWidthHeight()
    silent wincmd p
    " silent let g:floatWin_win = FloatingSmallNew ( resultLines )
    " silent call FloatWin_FitWidthHeight()
  endif
  " silent wincmd p
endfunc
" http --help
" echo system( "http localhost:8002/fruits/a eins=zwei --ignore-stdin" )
" echo system( "http localhost:8002/users name=zwei age=44 --ignore-stdin" )
" echo system( "curl -X POST localhost:8002/fruits/a --raw eins=zwei" )


func! Scala_ServerClientRequest_rerun()
  let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
  silent let g:floatWin_win = FloatingSmallNew ( resultLines )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc


" ─   Old                                               ──


" func! Scala_ServerClientRequest( args )
"   let urlExtension = GetLineFromCursor()
"   let g:scala_serverRequestCmd = "curl " . a:args . "http://localhost:8003/" . urlExtension
"   let resultLines = split( system( g:scala_serverRequestCmd ), '\n' )
"   silent let g:floatWin_win = FloatingSmallNew ( resultLines[3:] )
"   silent call FloatWin_FitWidthHeight()
"   silent wincmd p
" endfunc

" httpx -m PUT http://127.0.0.1:5000/actors -p filter_name "Robert Downey Jr." -j '{"age": 57, "height": 173}'
" httpx --help

" actors PUT -p filter_name "Robert Downey Jr." -j '{"age": 57, "height": 173}'
" conversion for my short version: don't use the -m key. all options after URL are optional. but the sequnce is fixed to how they appear in the --help



" nnoremap <silent>         gsf :call Scala_ServerClientRequest('', 'float')<cr>
" nnoremap <silent>        ,gsf :call Scala_ServerClientRequest( 'POST', 'float' )<cr>
" nnoremap <silent>         gsF :call Scala_ServerClientRequest('', 'term')<cr>
" nnoremap <silent>        ,gsF :call Scala_ServerClientRequest( 'POST', 'term' )<cr>


" https://httpie.io/docs/cli/examples

" NOTE: there's now ~/.config/nvim/plugin/tools_scala.vim#/func.%20Scala_ServerClientRequest.%20args,

nnoremap <silent> gwr         :call WebserverRequestResponse( '' )<cr>
nnoremap <silent> <leader>ger :call WebserverRequestResponseTerm( '' )<cr>
" nnoremap ge,r :call WebserverRequestResponse( '-v' )<cr>
" nnoremap ge,R :call WebserverRequestResponse( '--raw' )<cr>
" nnoremap geR :call WebserverRequestResponse( '-v --raw' )<cr>
func! WebserverRequestResponse( flags )

  let urlEx = matchstr( getline("."), '\v//\s\zs.*' )

  let l:cmd = "curl " . a:flags . " http://localhost:8002/" . urlEx

  let l:resultLines = split( system( l:cmd ), '\n' )
  silent let g:floatWin_win = FloatingSmallNew ( l:resultLines[3:] )
  silent call FloatWin_FitWidthHeight()
  silent wincmd p
endfunc
" !curl http://localhost:8080/up
" req "abc"
" http://localhost:8002/random
" curl -X POST http://localhost:8002/owls
" echo system( "http GET localhost:8002/zwei/aabb" )
" NOTE: http --help  is nice

" echo matchstr( getline("."), '\v//\s\zs.*' )

func! WebserverRequestResponseTerm( flags )
  let urlExtension = GetLineFromCursor()
  let cmd = "curl " . a:flags . urlExtension
  call TermOneShot( cmd )
endfunc
" http://localhost:8080/download/stream
" /Users/at/Documents/Server-Dev/effect-ts_zio/zio-examples/zio-quickstart-restful-webservice/src/main/scala/dev/zio/quickstart/download/





