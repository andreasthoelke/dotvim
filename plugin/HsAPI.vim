
" ~/.vim/notes/notes-todos.md#/###%20HsAPI


" nnoremap ,gsd :call HsAPIQueryShowBuf( HsCursorKeyword_findModule(), 15, 0 )<cr>
" vnoremap ,gsd :call HsAPIQueryShowBuf( GetVisSel(),       15, 0 )<cr>
" nnoremap ,gSd :call HsAPIQueryShowBuf( HsCursorKeyword(), 60, 0 )<cr>
" vnoremap ,gSd :call HsAPIQueryShowBuf( GetVisSel(),       60, 0 )<cr>

" nnoremap gsd :call PsAPIQuery( HsCursorKeyword(), 15, 0 )<cr>
" vnoremap gsd :<c-u>call PsAPIQuery( GetVisSel(),       15, 0 )<cr>
" nnoremap gSd :call PsAPIQuery( HsCursorKeyword(), 60, 0 )<cr>
" vnoremap gSd :call PsAPIQuery( GetVisSel(),       60, 0 )<cr>

" nnoremap ,gsD :call HsAPIQueryShowBuf( input( 'HsAPI query: ', HsCursorKeyword_findModule()), 15, 0 )<cr>
" vnoremap ,gsD :call HsAPIQueryShowBuf( input( 'HsAPI query: ', GetVisSel()),       15, 0 )<cr>
" nnoremap ,gSD :call HsAPIQueryShowBuf( input( 'HsAPI query: ', HsCursorKeyword()), 60, 0 )<cr>
" vnoremap ,gSD :call HsAPIQueryShowBuf( input( 'HsAPI query: ', GetVisSel()),       60, 0 )<cr>

" nnoremap gsD :call PsAPIQuery( input( 'PsAPI query: ', HsCursorKeyword()), 15, 0 )<cr>
" vnoremap gsD :call PsAPIQuery( input( 'PsAPI query: ', GetVisSel()),       15, 0 )<cr>
" nnoremap gSD :call PsAPIQuery( input( 'PsAPI query: ', HsCursorKeyword()), 60, 0 )<cr>
" vnoremap gSD :call PsAPIQuery( input( 'PsAPI query: ', GetVisSel()),       60, 0 )<cr>


" TODO: use ~/.vim/plugin/HsAPI-searchSites.vim#/func.%20GetSearchParams.%20mode,
  " qualified shortcuts are currently not supported, e.g. "LBSASCII.pack" ~/Documents/Haskell/6/HsTrainingTypeClasses1/src/Webservers.hs#/asciiMessageBody%20=%20MessageBody
  " integrate with UserChoiceAction ~/.vim/plugin/HsAPI-searchSites.vim#/nnoremap%20gsO%20.call


" gsk to insert info into float win - using the module name
" nnoremap gsk :call HsAPIShowInfoContext( HsCursorKeyword_findModule() )<cr>
" vnoremap gsk :call HsAPIShowInfoContext( GetVisSel() )<cr>
" nnoremap gsK :call HsAPIShowInfoContext( input( 'Doc string query: ', HsCursorKeyword_findModule()) )<cr>
" vnoremap gsK :call HsAPIShowInfoContext( input( 'Doc string query: ', GetVisSel()) )<cr>

" " Browse modules uses Hoogle for Haskell
" nnoremap ,gsb :call HsAPIBrowseShowBuf( HsCursorKeyword() )<cr>
" vnoremap ,gsb :call HsAPIBrowseShowBuf( GetVisSel() )<cr>
" nnoremap ,gsB :call HsAPIBrowseShowBuf( input( 'Module: ', HsCursorKeyword()) )<cr>
" vnoremap ,gsB :call HsAPIBrowseShowBuf( input( 'Module: ', GetVisSel()) )<cr>

" " Browse modules uses Psci for Purescript
" nnoremap gsb      :call ReplEval(':browse ' . expand('<cWORD>'))<cr>
" vnoremap gsb :<c-u>call ReplEval(':browse ' . GetVisSel())<cr>
" nnoremap gsB      :call ReplEval(':browse ' . input( 'Browse module: ', expand('<cWORD>')))<cr>
" vnoremap gsB :<c-u>call ReplEval(':browse ' . input( 'Browse module: ', GetVisSel()))<cr>



" a "complete" command with a "flex" matcher seems to be a main feature of PursIDE
func! PsAPIQuery( searchStr, _, __ )
  call purescript#ide#call(
        \ {'command': 'complete'
        \ , 'params':
        \   { 'matcher': { "matcher": "flex", "params": { "search": a:searchStr } }
        \   , 'options': { 'groupReexports': v:true }
        \   }
        \ },
        \ 'PsAPI Query - No results for '. a:searchStr,
        \ 0,
        \ { response -> PsAPIQueryHandleResponse( response ) }
        \ )
endfunc

" Formats and shows the response
" Code adapted from https://github.com/FrigoEU/psc-ide-vim
func! PsAPIQueryHandleResponse( response )
  if get(a:response, "resultType", "error") !=# "success"
    return purescript#ide#utils#error(get(a:resp, "result", "error"))
  endif

  let displayLines = []
  let querryResult = get(a:response, "result", [])

  for resultItem in querryResult
    if (has_key(resultItem, "definedAt") && type(resultItem.definedAt) == v:t_dict)
      let lineNumber = resultItem.definedAt.start[0]
      let colonNumber = resultItem.definedAt.start[1]
      let filePath    = resultItem.definedAt.name
      let displayLine3 = filePath . '#:' . lineNumber . ':' . colonNumber
    else
      let displayLine3 = '-- -'
    endif
    let module = get(resultItem, "module", "")
    let displayLine1 = module
    " using h rel.txt format e.g. ~/.vimrc#:10:4
    let displayLine2 = resultItem.identifier . ' :: ' . resultItem.type

    call add( displayLines, displayLine1 )
    call add( displayLines, displayLine2 )
    call add( displayLines, displayLine3 )
  endfor
  call PsShowLinesInBuffer( displayLines )
  " call FloatWin_ShowLines( displayLines )
endfunc



let g:ScratchBufferCounter = 0

func! PsShowLinesInBuffer ( lines )
  let g:ScratchBufferCounter += 1
  call ActivateScratchWindow('HsAPI' . g:ScratchBufferCounter . '.hs')
  exec '%delete'
  call append( 0, a:lines )
  " Delete blank lines
  exec 'g/^$/d'
  "Delete last line
  " exec 'normal! Gdd'
  exec 'normal! gg0'
  call HaskellSyntaxAdditions()
  " adjust buffer height to max 20 lines
  let l:height = min( [ 20, line('$') ] )
  exec ('resize ' . l:height )
endfunc " ▲


func! HsAPIQueryShowBuf( searchStr, count, infoFlag ) " ■
  let hoogleCmd = GetAPICmdStr( a:searchStr, a:count, a:infoFlag )
  let hoogleLines = split( system( hoogleCmd ), '\n' )
  call ActivateScratchWindow('HsAPIdata/APIquery.hs')
  exec '%delete'
  call append( 0, hoogleLines )
  " return
  if !a:infoFlag
    " exec 'SplitModulesInLines'
    call HsTabu( [] )
  else
    exec 'normal jjgc}'
  endif

  call HaskellSyntaxAdditions()
  exec 'normal! gg0'
endfunc " ▲

func! HsAPIQueryShowFloat( searchStr, count, infoFlag ) " ■
  let hoogleCmd = GetAPICmdStr( a:searchStr, a:count, a:infoFlag )
  let hoogleLines = split( system( hoogleCmd ), '\n' )
  call FloatWin_ShowLines( hoogleLines )

  if !a:infoFlag
    " Delete commented lines
    call FloatWin_do( 'g/--/d' )
    " Put namespace in separate line. For all lines, line break after big-word (no trailing whitespace), comment the module line
    call FloatWin_do( 'g/./normal! Whiki-- ' )
    " Issue: commenting/uncommenting this line inserts '\' after the 'Whi'
    " call FloatWin_do( 'g/./normal! Whi\ki-- ' )
    " call FloatWin_do( 'call HsAlignTypeSigs()' )
    call FloatWin_do( 'call HsTabu( [] )' )
  else
    call FloatWin_do( 'normal jjgc}' )
  endif

  call FloatWin_do( 'call HaskellSyntaxAdditions()' )

  call FloatWin_do( 'normal! gg0' )
  call FloatWin_FitWidthHeight()
endfunc " ▲

func! HsAPIShowInfoContext( searchStr )
  if @% == 'HsAPIdata/APIquery.hs'
    call HsAPIQueryShowInline( a:searchStr, 0, 1 )
  else
    call HsAPIQueryShowFloat( a:searchStr, 0, 1 )
  endif
endfunc
" TODO: refactor - showInline/showFloatingwin should be later in the call stack

func! HsAPIQueryShowInline( searchStr, count, infoFlag ) " ■
  let hoogleCmd = GetAPICmdStr( a:searchStr, a:count, a:infoFlag )
  let hoogleLines = split( system( hoogleCmd ), '\n' )
  call append( line('.'), hoogleLines )
  if len( hoogleLines ) > 3
    normal 0jjjgc}kkk
  endif
endfunc " ▲

let g:lastSearchStr = ''
func! HsAPIBrowseShowBuf( searchStr )
  " echoe a:searchStr
  let browseCmd = ':browse ' . a:searchStr
  let g:lastSearchStr = a:searchStr
  call InteroEval( browseCmd, "HsAPIBrowseShowBuf_CB", '' )
endfunc

func! HsAPIBrowseShowBuf_CB( replReturnedLines )
  let moduleLine = '-- browse ' . g:lastSearchStr
  call ScratchWin_Show( 'HsAPIdata/APIquery.hs', [moduleLine] + a:replReturnedLines )

  call CleanupBrowseOutput()

  call HsTabu( [] )

  call HaskellSyntaxAdditions()
  exec 'normal! gg0'
endfunc

func! CropLeadingModuleNames()
  if getline('.') =~ '-- browse'
    return
  endif
  normal! f.Eb"tyEB
  if GetCharAtCursor() =~ '(\|['
    normal! l
  endif
  normal! vE"tp
endfunc
" map' :: (Data.Profunctor.Mapping.Mapping p, Functor f) => p a b -> p (f a) (f b)
" call CropLeadingModuleNames()


func! CleanupBrowseOutput()
  let cmds = []
  " Crop namespaces e.g. (Data.Vector.Generic.Base.Vector v a,
  " find first '.', yank the last word, select all, paste
  " call add( cmds, 'g/\i\.\i/normal! f.Eb"tyEBvE"tp' )

  " call add( cmds, '%s/{-.*-}//g' )

  call add( cmds, 'g/\i\.\i/call CropLeadingModuleNames()' )
  " as this crops only the first long namespace, make a second pass
  call add( cmds, 'g/\i\.\i/call CropLeadingModuleNames()' )

  " join lines that end with => or :: or ,  - needs several passes
  call add( cmds, 'g/\(,\|=>\|::\)$/normal! J' )
  call add( cmds, 'g/\(,\|=>\|::\)$/normal! J' )
  call add( cmds, 'g/\(,\|=>\|::\)$/normal! J' )
  " or begin with '->'
  call add( cmds, 'g/^\s*->/normal! kJ' )

  " Move classes to the end of buffer
  " call add( cmds, 'g/class/m$' )
  " call add( cmds, 'g/class/d' )
  call add( cmds, 'g/\.\.\./d' )

  call RunCmdsSilent( cmds )
endfunc

func! RunCmdsSilent( cmds )
  for cmd in a:cmds
    exec 'silent ' . cmd
  endfor
endfunc




" func! HsExtractTypeFromLine( lineNr )
" func! HsCursorKeyword()

func! s:formatBuffer()
  "Syntax
  set syntax=purescript1
  " Delete commented lines
  exec "g/--/d"
  " Put namespace in separate line. For all lines, line break after big-word (no trailing whitespace), comment the module line
  exec "g/./normal! Whi0i-- "
  " Unicode
  call ExecRange( "HsReplaceCharsToUnicode", 1, line('$') )
  " Align
  call HsTabularizeTypeSigns( 1, line('$') )
  normal! gg
endfunc
" Note: need to source this with line select - because of the special chars?


func! HoogleFormatInfoOutput()
  let l:sig = getline( '.' )
  normal! ddi-- 
  call append( 1, l:sig)
  normal! jo{-
  set syntax=purescript1
  normal gg
endfunc

func! GetAPICmdStr( query, limit, infoFlag )
  let infoArg = a:infoFlag ? ' --info' : ''
  return 'hoogle "' . a:query . '" -n=' . a:limit . infoArg
endfunc

nnoremap <leader>hii :call PsImportIdentifier( expand('<cword>') )<cr>
nnoremap <leader>hiI :call PsImportIdentifier( input( 'Import identifier: ', expand('<cword>')) )<cr>
vnoremap <leader>hii :<c-u>call PsImportIdentifier( GetVisSel() )<cr>
vnoremap <leader>hiI :<c-u>call PsImportIdentifier( input( 'Import identifier: ', GetVisSel()) )<cr>

func! PsImportIdentifier( identifier )
  " echoe a:identifier
  call vimmerps#PaddImport( a:identifier )
endfunc

nnoremap <leader>Hii :call HsImportIdentifier( GetSearchParams('n') )<cr>
nnoremap <leader>HiI :call HsImportIdentifier( GetSearchParams('n', 'Import identifier: ') )<cr>
vnoremap <leader>Hii :call HsImportIdentifier( GetSearchParams('visual') )<cr>
vnoremap <leader>HiI :call HsImportIdentifier( GetSearchParams('visual', 'Import identifier: ') )<cr>

map      <Leader>lhi :call LanguageClient#textDocument_codeAction()<CR>

func! HsImportIdentifier( userContextProps )
  " echo a:userContextProps.module .' - '. a:userContextProps.identifier
  wincmd c
  call HsImport( a:userContextProps.module, RemoveBrackets( a:userContextProps.identifier ) )
endfunc

" Import Haskell Identifiers Using Hoogle And Hsimport:{{{
" 1. Use "gsd" ("go search docs") on a missing identifier
" 2. In the hoogle list of available identifiers, go to the line/version you
" want to import and run <leader>ii to import the identifier (confirm the import
" section of your source file has added the identifier)
" See HoogleImportIdentifier in vimrc and
" /Users/at/.vim/plugged/vim-hoogle/plugin/hoogle.vim
" also note the "HOOGLE INCLUDE NEW LIBS:" comment in vimrc
" Sparse Hoogle Infos: https://github.com/ndmitchell/hoogle/blob/master/docs/Install.md}}}

" EXAMPLES:{{{
" Can import this (which is split in two lines in the Hoggle result window)
" Prelude putStrLn                                                   :: String                                    -> IO ()
" Hoogle TODO support these:
" Data.Aeson data Value
" Data.Aeson type Array = Vector Value
" Data.Aeson class ToJSON a
" Data.Aeson (.=)                                                    :: (KeyValue kv, ToJSON v) => Text -> v        -> kv}}}
func! HoogleImportIdentifier() "{{{
  let l:split_line_prev = split( getline(line('.') -1) )
  let l:split_line      = split( getline('.') )
  call HoogleCloseSearch()
  let l:module     = l:split_line_prev[ 1 ]
  let l:identifier = l:split_line[ 0 ]
  call HsImport( l:module, l:identifier )
  " normal! <c-w>k{{{
  " if &mod
  "   echo "Please save before importing!"
  "   return
  " endif
  " let l:imp1 = l:split_line[0]
  " let l:imp2 = l:split_line[1]
  " if l:imp2 == "data" || l:imp2 == "type" || l:imp2 == "class"
  "   let l:imp2 = l:split_line[2]
  " endif
  " if l:imp2[0] == "("
  "   let l:imp2 = StripString( l:imp2, "(" )
  "   let l:imp2 = StripString( l:imp2, ")" )
  " endif
  " call Hsimp( l:imp1, l:imp2)
  "update format of the import list}}}
  call StylishHaskell()
endfunction "}}}

func! HoogleInsert( symbolOrModulePath, args )
  let l:cmd = 'hoogle ' . a:symbolOrModulePath . a:args
  let l:resultLines = split( system( l:cmd ), '\n' )
  " Don't need to repeat the function signature
  " call remove( l:resultLines, 0 )
  " echo split( system( 'hoogle Data.Conduit.List.replicateM --info' ), '\n' )
  " echo split( system( 'hoogle zipwith --info' ), '\n' )
  " Remove empty lines at the end --------------
  let l:idx_lastLine = len( l:resultLines ) - 1
  let l:lastLineText = l:resultLines[ l:idx_lastLine ]
  if l:lastLineText == ''
    call remove( l:resultLines, l:idx_lastLine )
  endif
  let l:idx_lastLine = len( l:resultLines ) - 1
  let l:lastLineText = l:resultLines[ l:idx_lastLine ]
  if l:lastLineText == ''
    call remove( l:resultLines, l:idx_lastLine )
  endif
  " Remove empty lines at the end --------------
  " Open comment at the end of the last line
  let l:resultLines[ 1 ] = '{- ' . l:resultLines[ 1 ]
  " Close comment at the end of the last line
  let l:idx_lastLine = len( l:resultLines ) - 1
  let l:text_lastLine = l:resultLines[ l:idx_lastLine ]
  let l:resultLines[ l:idx_lastLine ] = l:text_lastLine . ' -}'
  call append( line('.'), l:resultLines )
  " call append( line('.'), split( system( 'hoogle Data.Conduit.List.replicateM --info' ), '\n' ) )
endfunc


func! HoogleLineJump() "{{{
  let l:prev_line = getline(line('.') -1)
  let l:cur_line  = getline('.')
  let l:split_line_prev = split(l:prev_line)
  let l:split_line      = split(l:cur_line)
  let l:module     = l:split_line_prev[ 1 ]
  let l:identifier = l:split_line[ 0 ]
  let l:module_symbol_str = l:module . '.' . l:identifier
  " since results are given in the format `Data.IntMap.Strict lookup :: Key                            -> IntMap a -> Maybe a`
  " this results in a search of `Data.IntMap.Strict.lookup`
  " call HoogleLookup( l:module_symbol_str, ' --info' )
  call HoogleInsert( l:module_symbol_str, ' --info' )
endfunction "}}}
" To go back to the search results overview, just run the previous search again
" nnoremap <silent> <buffer> <localleader><c-o> <esc>:call HoogleLookup( g:hoogle_prev_search, '' )<cr>
" nnoremap <silent> <buffer> <localleader><c-o> :call HoogleGoBack()<cr>



fun! HsImport(module, symbol)
  call hsimport#imp_symbol(a:module, a:symbol, expand('%'))
endfun
" call HsImport("Control.Monad", "replicateM")



" HOOGLE INCLUDE NEW LIBS:
" "hoogle generate base lense" will download and install only the base and
" lense libs.
" open ":e hoogle-defaults" from the root of the project folder, add/delete
" libs, then <backspace> in first line to have everything in one row, and
" copy-paste into terminal
" https://github.com/ndmitchell/hoogle/blob/master/docs/Install.md
" Todo: get hoogle libs from cabal file


