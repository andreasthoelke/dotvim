
" Issue: prevent intero+neomake to clear the LC warnings/loclist. temp neomake patch  ~/.vim/plugged/neomake/autoload/neomake/cmd.vim#/call%20setloclist.0,%20[],

" call jobsend(g:intero_job_id, "\<C-u>")


" ─   Settings                                          ──
" Intero starts automatically. Set this if you'd like to prevent that.
let g:intero_start_immediately = 0
let g:intero_use_neomake = 0
" This show ghi warnings as opposed to hlint warnings:
" TODO: toggle warnings without restart vim!
" Todo: I may sometimes want -fwarn-unused-imports / disable -fno-warn-unused-imports

" See warnings here: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/flags.html#warnings
" let g:intero_ghci_options = '-Wall -fdefer-typed-holes -frefinement-level-hole-fits=1 -fno-warn-name-shadowing -Wno-unused-matches -Wno-missing-signatures -Wno-type-defaults -Wno-unused-top-binds -XPartialTypeSignatures -Wno-partial-type-signatures'
" let g:intero_ghci_options = '-fno-warn-unused-imports -fdefer-typed-holes -frefinement-level-hole-fits=1 -XPartialTypeSignatures'
let g:intero_ghci_options = '-XOverloadedLabels -XBlockArguments -XTypeOperators -XDataKinds -XFlexibleContexts -fno-warn-unused-imports -fdefer-typed-holes -frefinement-level-hole-fits=1 -XPartialTypeSignatures'
" let g:intero_ghci_options = '-Wall -Wno-unrecognised-pragmas -fno-warn-name-shadowing -Wno-unused-matches -Wno-missing-signatures -Wno-type-defaults -Wno-unused-top-binds -XPartialTypeSignatures -Wno-partial-type-signatures'
" let g:intero_ghci_options = '-Wall -Wno-unused-matches -Wno-missing-signatures -Wno-type-defaults -Wno-unused-top-binds'
" let g:intero_ghci_options = '-Wall -Wno-missing-signatures -Wno-type-defaults -Wno-unused-top-binds'

" Note GHC warnings: are set here for HIE!
" ~/Documents/Haskell/6/HsTrainingTypeClasses1/HsTrainingTypeClasses1.cabal#/ghc-options.%20-fdefer-typed-holes%20-fwarn-incomplete-patterns
" ghc-options: -fdefer-typed-holes -fwarn-incomplete-patterns -frefinement-level-hole-fits=1 -XPartialTypeSignatures

" Also note ~/Documents/Haskell/6/HsTrainingTypeClasses1/.hlint.yaml#/#%20Ignore%20some

" TODO: when do I need this? ■
let g:haskellmode_completion_ghc = 1
" autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" causes tag error?



" GHCI:
" use :m -<module name> to unload modules
" use :m to go to only Prelude
" edit ghci.conf to set
" DEFAULT IMPORTS:
" e ~/.ghc/ghci.conf ▲


" ─   Maps                                               ■
" nnoremap <silent> <leader>is :InteroStart<CR>
" nnoremap <silent> <leader>isc :SignsClear<CR>
" Todo: unify this with purs?
" nnoremap <silent> <leader>ik :InteroKill<CR>
" nnoremap <silent> <leader>io :InteroOpen<CR>
" nnoremap <silent> <leader>ih :InteroHide<CR>
" nnoremap <silent> <leader>im :InteroLoadCurrentModule<CR>
" nnoremap <silent> <leader>il :InteroLoadCurrentFile<CR>

" nnoremap <silent>         gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> ,gd :sp<CR>:call LanguageClient_textDocument_definition()<CR>

" fee mapping
" nnoremap <silent>         ]d :call GotoDefinition()<CR>
" nnoremap dr :InteroReload<cr>
" ─^  Maps                                               ▲

" ─   Legacy Intero Types: TODO                          ■
" only for identifier, no unicode conversion
" nnoremap <silent> gw :InteroTypeInsert<cr>
" nnoremap <silent> <localleader>tw :InteroTypeInsert<cr>
" nnoremap <silent> <localleader>gw :InteroTypeInsert<cr>
" does not echo any more (changed this in Intero) outputs gentype only in Repl
map <localleader>tt <Plug>InteroType

map <localleader>tg <Plug>InteroGenTypeInsert
vnoremap <localleader>tg :InteroGenTypeInsert<cr>
" map <localleader>tg <Plug>InteroGenericType
nnoremap <localleader>ti :InteroInfoInsert<cr>
vnoremap <localleader>ti :InteroInfoInsert<cr>
" ─^  Legacy Intero Types: TODO                          ▲


" ─   Show Type-At symbol or selection                   ■

" TODO adapt this approach to use the spago/ghci/stack repl?
" map gw :call SetReplCallbackFloatWin()<cr><Plug>InteroType
" vmap gw :<c-u>call SetReplCallbackFloatWin()<cr>gv<Plug>InteroType
" map gW :call SetReplCallbackFloatWin()<cr><Plug>InteroGenericType
" map gW :<c-u>call SetReplCallbackFloatWin()<cr>gv<Plug>InteroGenericType

func! SetReplCallbackFloatWin()
  call intero#process#add_handler( function( "FloatWin_stripToType" ) )
endfunc

func! FloatWin_stripToType( lines )
  let str = join( a:lines, ' ' )
  let type = HsGetTypeFromSignatureStr( str )
  call FloatWin_ShowLines( [type] )
endfunc

" Use Intero to insert type
nnoremap <silent> ,gw :InteroTypeInsert<cr>

" Or use a custom intero :type repl evel
" Get repl :type/:kind info for cword / vis-sel:
nnoremap ,get :call InteroEval( ':type ' . expand('<cword>'), "FloatWin_ShowLines", '' )<cr>
" nnoremap gwt :call InteroEval( ':type ' . expand('<cword>'), "PasteTypeSig", '' )<cr>
vnoremap ,get :call InteroEval( ':type ' . Get_visual_selection(), "FloatWin_ShowLines", '' )<cr>
nnoremap ,gek :call InteroEval( ':kind ' . expand('<cword>'), "FloatWin_ShowLines", '' )<cr>
vnoremap ,gek :<c-u>call InteroEval( ':kind ' . Get_visual_selection(), "FloatWin_ShowLines", '' )<cr>

" nnoremap geT :call InteroRunType( expand('<cword>'), 'HsShowLinesInFloatWin' )<cr>

" ─^  Show Type-At symbol or selection                   ▲



" Default:
" nnoremap gei :call InteroEval_SmartShow()<cr>

" Plain Repl Lines:
" nnoremap ges :call InteroEval( GetReplExpr(), "FloatWin_ShowLines", '' )<cr>
" nnoremap gei :call InteroEval( GetReplExpr(), "FloatWinAndVirtText", '' )<cr>
" nnoremap gei :call ReplEval( GetReplExpr() )<cr>

" vnoremap gei :call InteroEval( Get_visual_selection(), "FloatWinAndVirtText", '' )<cr>

" ─   legacy to be reviewed                              ■
" Run cword in repl - paste returned lines verbally:
" nnoremap <silent> gew :call InteroEval( GetReplExpr(), "ShowList_AsLines_Aligned", '' )<cr>
" nnoremap geW :call InteroEval( GetReplExpr(), "PasteLines", '' )<cr>
" -                   - Haskell list as lines:
" nnoremap gel :call InteroEval( GetReplExpr(), "ShowList_AsLines_Aligned", '' )<cr>
" -                   - Haskell list as table:
" nnoremap gec :call InteroEval( GetReplExpr(), "ShowList_AsLines_Aligned", 'AlignColumns('')' )<cr>
" nnoremap geC :call InteroEval( GetReplExpr(), "ShowList_AsLines_Aligned", 'AlignTable' )<cr>
" ─^  legacy to be reviewed                              ▲



" Align function needs to be a script var .. (?)
let s:async_alignFnExpr = ''
let s:async_curType = ''

func! FloatWinAndVirtText( lines )
  call FloatWin_ShowLines( a:lines )
  call VirtualtextShowMessage( a:lines[0], 'CommentSection' )
endfunc


func! InteroEval_SmartShow()
  let typeSigLineNum = TopLevBackwLine()
  let funcName       = GetTopLevSymbolName( typeSigLineNum )
  let funcReturnType = HsExtractReturnTypeFromLine( typeSigLineNum )

endfunc

" TODO consideration: could use the ":set +t" ghci feature to always get the type alongside the returned value and
" treat/format it accordingly

" Repl mutiple lines:
nnoremap gel      :let g:opContFn='ReplEvalLines'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
vnoremap gel :<c-u>let g:opContFn='ReplEvalLines'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

func! ReplEvalLines( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  " let l:lines = getline( startLine, endLine)
  " call PsShowLinesInBuffer( l:lines )
  " for lineStr in l:lines
  for lineNum in range(startLine, endLine)
    call ReplEval( GetReplExprLN( lineNum ) )
  endfor
endfunc



" ─   New Purescript REPL                                ■

nnoremap <silent> <leader>ro :call ReplStart()<cr>
nnoremap <silent> <leader>rq :call ReplStop()<cr>
nnoremap <silent> <leader>rl :call ReplEval('import ' . GetModuleName())<cr>
" nnoremap <silent> dr         :call ReplEval(':reload')<cr>:call ReplReload_Refreshed( expand('%') )<cr>
nnoremap <silent> dr         :call ReplReload()<cr>
nnoremap          <leader>ri :exec "Pimport " . expand('<cword>')<cr>

" Obsolete: use ~/.vim/plugin/HsAPI.vim#/Browse%20modules%20uses
" nnoremap <silent> <leader>rb      :call ReplEval(':browse ' . input( 'Browse module: ', expand('<cWORD>')))<cr>
" vnoremap <silent> <leader>rb :<c-u>call ReplEval(':browse ' . input( 'Browse module: ', GetVisSel()))<cr>

nnoremap <silent> gei      :silent call ReplEval( GetReplExpr() )<cr>
vnoremap <silent> gei :<c-u>call ReplEval( Get_visual_selection() )<cr>

" now moved to ~/.vim/plugin/HsAPI.vim#/Get%20.type%20from
" nnoremap get      :call ReplEval( ':type ' . expand('<cword>') )<cr>
" vnoremap get :<c-u>call ReplEval( ':type ' . GetVisSel() )<cr>


" Note that the following functions are linked by referring to the same Psci session (PursReplID)
command! ReplStart :let g:PursReplID = jobstart("spago repl", g:ReplCallbacks)

func! ReplStart ()
  if exists('g:PursReplID')
    echo 'Repl is already running'
    return
  endif
  let g:PursReplID = jobstart("spago repl", g:ReplCallbacks)
endfunc

func! ReplStop ()
  if !exists('g:PursReplID')
    echo 'Repl is not running'
    return
  endif
  call jobstop( g:PursReplID )
  unlet g:PursReplID
endfunc

func! ReplReload ()
  call jobsend(g:PursReplID, ':reload' . "\n")
  " IMPORTANT: this uses `"` / double quotes for the newline ("\n") - single quotes don't work
  call ReplReload_Refreshed( expand('%') )
endfunc

func! ReplLoadCurrentModule ()
  call ReplEval ( 'import ' . GetModuleName() )
endfunc

func! ReplMainCallback(job_id, data, event)
  call ReplSimpleResponseHandler (a:data)
endfunc

func! ReplErrorCallback(job_id, data, event)
  echom a:data
endfunc

func! ReplExitCallback(job_id, data, event)
  echom a:data
endfunc


let g:ReplCallbacks = {
      \ 'on_stdout': function('ReplMainCallback'),
      \ 'on_stderr': function('ReplErrorCallback'),
      \ 'on_exit': function('ReplExitCallback')
      \ }

func! ReplEval( expr )
  if a:expr =~ '^.*--.*$' || a:expr =~ '^$' | return | endif
  if ReplReload_FileNeedsReplReload(expand('%'))
    call ReplReload()
  endif
  call jobsend(g:PursReplID, a:expr . "\n")
endfunc

" ANSI colors are incoded into the error messages and need to be removed (TODO there is also a setting for psci). e.g.  [32m'Done!'[39m
let g:ReplaceBashEscapeStrings = [['[33m',''], ['[32m',''], ['[39m',''], ['[0m','']]

" Separates 3 output types:
" - Forwards multi-line repl-outputs
" - Splits a list of strings into lines
" - Forwards other values
func! ReplSimpleResponseHandler( lines )
  " Not sure why there is sometimes an additional one line return value.
  if len( a:lines ) == 1 | return | endif
  " echom len(a:lines)
  " if (type(a:lines) != type(v:t_list))
  "   echom a:lines
  "   " call HsShowLinesInFloatWin( [a:lines] )
  "   return
  " endif
  let l:lines = ReplaceStringsInLines( a:lines, g:ReplaceBashEscapeStrings )
  " echoe l:lines
  " let l:lines = functional#filter( {x->x == ''}, l:lines )

  if len( l:lines ) == 3
    " Repl returned the typlical one value
    call VirtualtextShowMessage( l:lines[0], 'CommentSection' )
    let hsReturnVal = l:lines[0]
    if hsReturnVal[0:1] == '["'
      " Detected list of strings: To split the list into lines, convert to vim list of line-strings!
      call HsShowLinesInFloatWin( eval ( hsReturnVal ) )
    else
      call HsShowLinesInFloatWin( [hsReturnVal] )
    endif
  elseif len( l:lines ) == 0
    echo "Repl returned 0 lines"
  " elseif len( l:lines ) > 15
  "   call PsShowLinesInBuffer( l:lines )
  else
    call HsShowLinesInFloatWin( l:lines )
    call VirtualtextShowMessage( join(l:lines[:1]), 'CommentSection' )
  endif
endfunc
" call PursReplReturnCB (["eins", "zwei"])


" "spago install <packagename> && spago build"
command! -nargs=1 -complete=custom,PSCIDEcompleteIdentifier
      \ PursInstall
      \ echom jobstart("spago install " . <q-args> . " && spago build", g:ReplCallbacks)

" add :CocRestart and Prebuild to this

" ─^  New Purescript REPL                                ▲



" call InteroRun( ':type ' . GetReplExpr(), 'InteroEval_SmartShow_step2', '' ) ▲
func! InteroRun( replExpr, alignFnExpr )
  let s:async_alignFnExpr = a:alignFnExpr
  call intero#process#add_handler( function( 'PursReplReturnCB' ) )
  call intero#repl#eval( a:replExpr )
endfunc

func! InteroRunType( testExpr, continueFnName )
  let g:async_runTypeContinue = a:continueFnName
  call intero#process#add_handler( function( 'InteroReplTypeReturnCB' ) )
  call intero#repl#eval( ':type ' . a:testExpr )
  " call intero#repl#eval( ':type +d ' . a:testExpr )-- TODO how to integrate the polymorphic flag?
endfunc
" call InteroRunType('maybe', 'HsShowLinesInFloatWin' )
" call InteroRunType('database', 'HsShowLinesInFloatWin' )

func! InteroReplTypeReturnCB( lines )
  if len( a:lines ) == 1
    call call( g:async_runTypeContinue, [[HsGetTypeFromSignatureStr( a:lines[0] )]] )
  else
    call HsShowLinesInFloatWin( lines )
  endif
endfunc

func! HsShowLinesInFloatWin( hsLines )
  normal! m'
  call FloatWin_ShowLines( a:hsLines )
  call FloatWin_do( 'call HaskellSyntaxAdditions()' )
  call FloatWin_FitWidthHeight()
  if len( s:async_alignFnExpr )
    call FloatWin_do( 'call ' . s:async_alignFnExpr )
  endif
endfunc
" call HsShowLinesInFloatWin( ["eins", "zwei"] )


" Get a (repl-) evaluable expression-string from a (line-) string
func! GetReplExpr()
  let lineList                = split( getline('.') )
  let secondWordOnwards       = join( l:lineList[1:], ' ')
  let expressionOfBind        = join( l:lineList[2:], ' ')
  let topLevelSymbol          = lineList[0]
  let concealedBindingLine    = lineList[0][0:1] == 'cb'
  let testBindingLine         = lineList[0][0:1] =~ 'e\d'
  let isDeclarationWithNoArgs = lineList[1] == '='
  let isToplevelLine          = IndentLevel( line('.') ) == 1
  let cursorIsAtStartOfLine   = col('.') == 1 " not sure where?

  if IsImportLine( line('.') )
    return getline('.')
  elseif IsDoStartLine( line('.') )
    return topLevelSymbol
  elseif concealedBindingLine || testBindingLine
    return expressionOfBind
  elseif CursorIsInsideStringOrComment()
    return secondWordOnwards
  elseif IsTypeSignLine( line('.') )
    return topLevelSymbol
  elseif IsTypeSignLineWithArgs( line('.') )
    return topLevelSymbol
  elseif CursorIsAtStartOfWord()
    return expand('<cword>')
  elseif isToplevelLine && isDeclarationWithNoArgs
    " echoe 'declaration with no args'
    return topLevelSymbol
  else
    echoe 'Could not extract an expression!'
  endif
endfunc
" TODO: document test cases. optimise for non reload. autoreload in case it's needed?


func! GetReplExprLN( lineNum )
  if IsEmptyLine( a:lineNum )
    return ""
  endif

  let lineList                = split( getline( a:lineNum ) )
  let secondWordOnwards       = join( l:lineList[1:], ' ')
  let expressionOfBind        = join( l:lineList[2:], ' ')
  let topLevelSymbol          = lineList[0]
  let concealedBindingLine    = lineList[0][0:1] == 'cb'
  let testBindingLine         = lineList[0][0:1] =~ 'e\d'
  let isDeclarationWithNoArgs = lineList[1] == '='
  let isToplevelLine          = IndentLevel( a:lineNum ) == 1
  let cursorIsAtStartOfLine   = col('.') == 1 " not sure where?

  if IsImportLine( a:lineNum )
    return getline( a:lineNum )
  elseif IsDoStartLine( a:lineNum )
    return topLevelSymbol
  elseif concealedBindingLine || testBindingLine
    return expressionOfBind
  elseif CursorIsInsideStringOrComment()
    return secondWordOnwards
  elseif IsTypeSignLine( a:lineNum )
    return topLevelSymbol
  elseif IsTypeSignLineWithArgs( a:lineNum )
    return topLevelSymbol
  elseif CursorIsAtStartOfWord()
    return expand('<cword>')
  elseif isToplevelLine && isDeclarationWithNoArgs
    " echoe 'declaration with no args'
    return topLevelSymbol
  else
    echoe 'Could not extract an expression!'
  endif
endfunc

" ─   Apply args                                         ■
" Todo: ? was this to automatically apply/run the tests?
" nnoremap <silent> ]g :call TestArgForw()<cr>:call ScrollOff(16)<cr>
func! TestArgForw()
  call search( '\v^e\d_', 'W' )
endfunc

func! TestArgForwLineNum()
  return searchpos( '\v^e\d_', 'cnb' )[0]
endfunc

" nnoremap <silent> [g :call TestArgBackw()<cr>:call ScrollOff(10)<cr>
func! TestArgBackw()
  call search( '\v^e\d_', 'bW' )
endfunc

func! InteroEval_TestArgs( lineNum_TestArgs, lineNum_TypeSig )
  let testArgs = HsGetTestArgsFromLineNum( a:lineNum_TestArgs )
  let typeSig = getline( a:lineNum_TypeSig )
  let symbolName = split( typeSig )[0]
  let returnType = HsExtractReturnTypeFromTypeSig( typeSig )
endfunc


" ─^  Apply args                                         ▲


" Select a haskell print/show function and optionally a vim-script align function
" based on the Hs expression/return type
func! HsTypeStr_To_PrintAlignFn( typeStr )
  if a:typeStr[0:1] == '[(' || a:typeStr[0:1] == '[['
    " 1) List of Tuples/Lists: `show` the Tuple/List and align to all commas
    return ['show <$> ', "AlignBufferAsTable(',')"]
  elseif a:typeStr == '\v(Int |Integer |String |Text |\[Char)'
    " 3) Simple types are shown as they are:
    return ['', '']
  elseif a:typeStr =~ '\v^(Map |Vector |\[\u)'
    " 2) Map, Vector or Haskelltype (uppercase in list): use ppTable
    return ['T.printTable ', '']
  else
    " 4) Non list type: use Pretty.Simple
    return ['pPrint ', '']
  endif
endfunc
" echo HsTypeStr_To_PrintAlignFn('[(Integer, Char)]')
" echo HsTypeStr_To_PrintAlignFn('[Sometype Int Char]')
" echo HsTypeStr_To_PrintAlignFn('Map Int Char')


" ─   Tools                                              ■

" Simply paste the lines below as they are ■
func! PasteLines( lines )
  call append( line('.'), a:lines )
endfunc

func! PasteTypeSig( lines ) abort
  " let unicodeLines = ReplaceStringsInLines( a:lines, g:HsReplacemMap_CharsToUnicodePtts )
  call append(line('.') -1, a:lines)
endfunc " ▲

command! HsStackRun    :call HaskellStackRun()

" Opens a visible terminal and builds and runs the stack project (using stack build && stack exec ..)
" TODO: two alternative ways to launch long running processes:
" ➜  pragmaticServant git:(master) ✗ stack runghc src/Lib.hs
" 2. Launch a terminal with "glt" + "ghcid -T :main"
fun! HaskellStackRun()
  " let Cbs2 = {
  " \ 'on_stdout': function('OnEv1'),
  " \ 'on_stderr': function('OnEv1'),
  " \ 'on_exit': function('OnEv1')
  " \ }

  " let commandBaseString = "!stack build && stack exec "
  let projectName = HaskellProjectName1()
  " let commString = commandBaseString . projectName . "-exe"
  " let commString = "stack build"
  let commString = "20Term stack build && stack exec " . projectName . "-exe"
  " let StackRunIO = jobstart(commString, Cbs2)
  " exec "20Term stack build"

  exec commString
endfun
" example command:
" "stack build && stack exec pragmaticServant-exe"
" glt :20Term<cr>

" command! PursRepl :let PursReplID = jobstart("pulp repl", Cbs1)
" :call jobstart(split(&shell) + split(&shellcmdflag) + ['{cmd}'])


" ─   HPack                                             ──
autocmd BufWritePost package.yaml call Hpack()

func! Hpack()
  let err = system('hpack ' . expand('%'))
  if v:shell_error
    echo err
  endif
endfunc

" ─^  Tools                                              ▲

" ─   Other tools Langserver                             ■
"From  https://github.com/sriharshachilakapati/dotfiles/blob/abdef669aad394ff290c7360995e8c05386bcb80/.vimrc
" Callback function used for imports. Calls FZF if there are ambigous imports and resolves with selected one
function! s:PaddImportCallback(ident, result)
  " If the result is empty, then early exit
  if (type(a:result["result"]) == type(v:null))
    return
  endif

  " There are ambigous imports, call FZF with default FZF options
  call fzf#run(fzf#wrap({ 'source': a:result["result"],
        \ 'sink': { module -> PaddImport(a:ident, module) }
        \ }))
endfunction


func! ServerCmd( command, ... )
  let l:args = get(a:, 1, [])
  call LanguageClient_workspace_executeCommand( a:command, l:args, function('PasteLines'))
endfunc

func! LanguageClient_workspace_executeCmd(...)
  return call('LanguageClient#workspace_executeCommand', a:000)
endfunc

" just for testing - not sure when this might be useful
nnoremap <leader>dhi :echo intero#util#get_haskell_identifier()<cr>
" alternative to PSCIDEgetKeyword()
" ─^  Other tools Langserver                             ▲

" ─   Repl legacy                                        ■


" Evaluate "expr" in ghci. "renderFnName" will receive what ghci returns as a vim list of lines.
" Renamed from "InsertEvalExpr"
func! InteroEval( expr, renderFnName, alignFnName ) abort
  " exec "InteroReload" " TODO perhaps reload on InsertLeave? otherwise all cmds would take longer..?
  " Set the align function as a script var as it can not be passed to callback(?)
  let s:async_alignFnExpr = a:alignFnName
  " TODO refactor to support smart command events?
  if a:expr =~ 'server'
    call jobsend(g:intero_job_id, "\<C-c>")
    exec 'InteroOpen'
  endif
  call intero#process#add_handler( function( a:renderFnName ) )
  call intero#repl#eval( a:expr )
endfunc

nnoremap <leader>ic :InteroCancelRunningProcessInGhci<cr>:InteroHide<cr>:call FloatWin_close()<cr>

command! InteroCancelRunningProcessInGhci call jobsend(g:intero_job_id, "\<C-c>")

" Resume here to finish pretty printing big values ~/.vim/notes/notes-todos.md#/##%20Pretty%20printing
func! InteroEval_SmartShow_step2( replReturnedLines ) " ■
  " 2. Store the type of the expression
  let firstLine = split( a:replReturnedLines[0], ' ' )
  " let typeSepIndex = index( firstLine, '"::' )
  " let s:curType = join( firstLine[typeSepIndex:], ' ' )
  let s:curType = join( firstLine[2:], ' ' )
  " 3. Now eval the expression in the repl
  " echoe s:curType
  if s:curType[0:1] == '[(' || s:curType[0:1] == '[['
    " 1) List of Tuples/Lists: `show` the Tuple/List and align to all commas
    let replExpr = 'show <$> ' . GetReplExpr()
    " let s:async_alignFnExpr = "AlignColumns( ['\,', '2\,'] )"
    call InteroRun( replExpr, 'ShowList_AsLines_Aligned', "AlignBufferAsTable( ',' )" )
  elseif s:curType =~ '\v(Map |Vector |\[\u)'
    " 2) Map, Vector or Haskelltype (uppercase in list): use ppTable
    " -- echo "Map.Map Stock" =~ '\v(Map |Vector |\[\u)' ■
    " -- echo "Vector Stock" =~ '\v(Map "|Vector |\[\u)'
    " -- echo "[Ein" =~ '\v(Map "|Vector |\[\u)' ▲
    let replExpr = 'T.printTable ' . GetReplExpr()
    call InteroRun( replExpr, 'HsShowLinesInFloatWin', '' )
  elseif s:curType =~ '\v(Int |Integer |String |Text |\[Char)'
    " 3) Simple type are shown as they are:
    call InteroRun( GetReplExpr(), 'HsShowLinesInFloatWin', '' )
  else
    " 4) Non list type: use Pretty.Simple
    let replExpr = 'pPrint ' . GetReplExpr()
    call InteroRun( replExpr, 'HsShowLinesInFloatWin', '' )
  endif
endfunc
" Tests: see ~/Documents/Haskell/6/HsTrainingTypeClasses1/src/Prettyprint.hs
" call InteroRun( ':type ' . GetReplExpr(), 'InteroEval_SmartShow_step2', '' ) ▲

" TODO test and finish the various cases
" Interpretes the first repl-returned line as a Haskell-List of Strings - and appends these items as lines.
" It then aligns the first 2 columns (column separator is <space>)
func! ShowList_AsLines_Aligned( replReturnedLines ) " ■
  let firstLine = a:replReturnedLines[0]
  " echo a:replReturnedLines
  " return
  normal! m'

  if firstLine[0:1] == '["'
    " Received a Haskell list of stings - can simply convert-eval it to vimscript of strings!
    call FloatWin_ShowLines( eval( firstLine ) )
    " if len( s:async_alignFnExpr )
    "   call FloatWin_do( 'call ' . s:async_alignFnExpr )
    " endif
  elseif
    " Maybe an error?
    call FloatWin_ShowLines( replReturnedLines )
  endif


  " call FloatWin_do( 'call HaskellSyntaxAdditions()' )
  " call FloatWin_FitWidthHeight()
endfunc " ▲

" exec l:startWindowNr . 'wincmd w' ■
" call nvim_set_current_win(2)
" Interpretes the first repl-returned line as a Haskell-List of Strings - and appends these items as lines.
" It then aligns the first 2 columns (column separator is <space>)
" func! ShowList_AsColumns( hsList, alignment_FuncName )
"   normal! m'
"   call ShowList_AsLines_Aligned( a:hsList )
"   call FloatWin_do( 'call ' . a:alignment_FuncName . '()' )
"   " call append( line('.'), eval( a:hsList[0] ) )
"   " call AlignBufferAsColumns()
" endfunc ▲

" ─^  Repl legacy                                        ▲

nnoremap ger :call WebserverRequestResponse( '' )<cr>
nnoremap ge,r :call WebserverRequestResponse( '-v' )<cr>
nnoremap ge,R :call WebserverRequestResponse( '--raw' )<cr>
nnoremap geR :call WebserverRequestResponse( '-v --raw' )<cr>
func! WebserverRequestResponse( flags )
  let urlExtension = GetStringInQuotesFromLine( line('.') )
  let l:cmd = "curl " . a:flags . " http://localhost:8000/" . urlExtension
  let l:resultLines = split( system( l:cmd ), '\n' )
  call FloatWinAndVirtText( l:resultLines[3:] )
  " call append( line('.'), l:resultLines )
endfunc
" !curl http://localhost:8000
" req "abc"


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





