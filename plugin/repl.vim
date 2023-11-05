

" nnoremap <silent> gsh :call Scala_ServerClientRequest_x()<cr>

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

"Note: when is a Node js call useful?
nnoremap geN :call NodeJSRunFunction( expand('<cword>'), '' )<cr>
" nnoremap geN :call WebserverRequestResponse( '-v --raw' )<cr>
func! NodeJSRunFunction( fnName, arg )
  let jsFilePath = './output/' . GetModuleName() . '/index'
  let nodeCmd = 'require("' . jsFilePath . '").' . a:fnName . '(' . a:arg . ')'
  let l:cmd = 'node -e ' . shellescape( nodeCmd )
  " nice test: measure the time the node app is running:
  " let l:cmd = 'time node -e ' . shellescape( nodeCmd )
  " echoe l:cmd
  let l:resultLines = split( system( l:cmd ), '\n' )
  call HsShowLinesInFloatWin( l:resultLines )
endfunc
" echo system( "node -e " . shellescape("require('./output/Main/index').main()") )
" "one could console.log the return value of functions:
" const { abc, main } = require('./output/Main');
" console.log( abc(22) );
" console.log( require('./output/Main').cbdk0 );

nnoremap gen :call NodeJSRunBinding()<cr>

func! NodeJSRunBinding()
  let jsFilePath = './output/' . GetModuleName() . '/index'
  let symName = GetTopLevSymbolName( line('.') )
  let nodeCmd = 'console.log( require("' . jsFilePath . '").' . symName . ');'
  let l:cmd = 'node -e ' . shellescape( nodeCmd )
  " echoe l:cmd
  let l:resultLines = split( system( l:cmd ), '\n' )
  call HsShowLinesInFloatWin( l:resultLines )
  call VirtualtextShowMessage( join(l:resultLines[:1]), 'CommentSection' )
endfunc

" This actually works. but one would need to delay the call a bit as only the prev change is picked up
" au! ag TextChanged *.purs call NodeJSRunBinding()


func! FloatWin_stripToType( lines )
  let str = join( a:lines, ' ' )
  let type = HsGetTypeFromSignatureStr( str )
  call FloatWin_ShowLines( [type] )
endfunc


" Align function needs to be a script var .. (?)
let s:async_alignFnExpr = ''
let s:async_curType = ''

func! FloatWinAndVirtText( lines )
  call FloatWin_ShowLines( a:lines )
  call VirtualtextShowMessage( a:lines[0], 'CommentSection' )
endfunc




