


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




