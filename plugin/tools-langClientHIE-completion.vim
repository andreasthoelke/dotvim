

" ─   Coc nvim settings                                 ──
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<C-i>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

nnoremap <silent> gsi :call CocActionAsync('diagnosticInfo')<cr>

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
" if exists('*complete_info')
"   inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" else
"   inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>hK :call Show_documentation()<CR>
" nnoremap <silent> get :call Show_documentation()<CR>

function! Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" GoTo code navigation. don't seem supported in purescript
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

nmap <silent>            ,gd <Plug>(coc-definition)
nmap <silent> \gd :vsplit<CR><Plug>(coc-definition)
nmap <silent> gd :call FloatingBuffer(expand('%'))<CR><Plug>(coc-definition)
nmap <silent> gD :split<CR><Plug>(coc-definition)

" this allows to open the menu and get suggestions without any characters typed already.
inoremap <silent><expr> <c-space> coc#refresh()



" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})
" autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)

" not clear how/if this works?
" command! -nargs=0 Format :call CocAction('format')

" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" TODO -- not seem to work? .. use this in HSMotion
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" echo CocAction('runCommand', 'purescript.getAvailableModules')
" echo LanguageClient_workspace_executeCommand('purescript.restartPscIde', [])

" ─^  Coc nvim settings                                  ▲



" issue: Purs ide throws an error, can't find the project root folder? - it's deactivated now
" purs ide server -p 12441 src/**/*.purs
" let g:psc_ide_server_port = 12441
" let g:psc_ide_server_port = 38218

let g:vimmerps_disable_mappings = v:true

let g:vimmerps_config =
    \ { 'autoStartPscIde': v:true
    \ , 'pscIdePort': v:null
    \ , 'autocompleteAddImport': v:true
    \ , 'pursExe': 'purs'
    \ , 'addSpagoSources': v:true
    \ , 'censorWarnings': ["ShadowedName", "UnusedImport", "MissingTypeDeclaration"]
    \ , 'addNpmPath': v:true
    \ }

" Test this: ~/Documents/Haskell/6/HsTrainingTypeClasses1/.vim/settings.json#/"languageServerHaskell".%20{
" Issue: prevent intero+neomake to clear the LC warnings/loclist. temp neomake patch  ~/.vim/plugged/neomake/autoload/neomake/cmd.vim#/call%20setloclist.0,%20[],

" HIE config: ~/Documents/Haskell/6/HsTrainingTypeClasses1/.vim/settings.json#/"diagnosticsDebounceDuration.%2050,
" Note GHC warnings: are set here for HIE!
" ~/Documents/Haskell/6/HsTrainingTypeClasses1/HsTrainingTypeClasses1.cabal#/ghc-options.%20-fdefer-typed-holes%20-fwarn-incomplete-patterns
" ghc-options: -fdefer-typed-holes -fwarn-incomplete-patterns -frefinement-level-hole-fits=1 -XPartialTypeSignatures
" Also note ~/Documents/Haskell/6/HsTrainingTypeClasses1/.hlint.yaml#/#%20Ignore%20some

autocmd BufReadPost *.kt setlocal filetype=kotlin

" ─   Language Client HIE                                ■

" let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }
" let g:LanguageClient_serverCommands = { 'purescript': ['purescript-language-server', '--stdio', '--config', '{}'] }
let g:LanguageClient_serverCommands = { 'kotlin': ["kotlin-language-server"] }

" let g:LanguageClient_rootMarkers.haskell = ['*.cabal', 'stack.yaml', 'spago.dhall']

let g:LanguageClient_autoStart = 1
" let g:lsp_async_completion = 1
" delay updates? not sure if this works
" let g:LanguageClient_changeThrottle = 0.5

let g:LanguageClient_diagnosticsEnable = 1
" let g:LanguageClient_diagnosticsList = 'Location'
" default is Quickfix - but Intero uses quickfix (nicely formatted) via neomake

let g:LanguageClient_windowLogMessageLevel = 'Info'
" let g:LanguageClient_settingsPath = '~/.vim/HIE/settings.json'
" default: $projectdir/.vim/settings.json

" let g:LanguageClient_loggingFile = expand('~/.vim/LanguageClient.log')
let g:LanguageClient_useFloatingHover = 1
" In HsFormat
" set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" Try: - "gqaf"


" `leader lm` to open LanguageClient menu - e.g. to trigger a HIE codeAction
nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
" Documentation
map <Leader>lk :call LanguageClient#textDocument_hover()<CR>

" Go to definition:
map <Leader>lG <c-w>v:call LanguageClient#textDocument_definition()<CR>
map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
" Bug in LC currently prevents this
" map <Leader>lg :call LanguageClient#textDocument_definition({'gotoCmd':'split'})<cr>

map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
map <Leader>lb :call LanguageClient#textDocument_references()<CR>
map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
" also a map here: ~/.vim/plugin/HsAPI.vim#/map%20<Leader>lhi%20.call
" map <Leader>lhi :call LanguageClient#textDocument_codeAction()<CR>

map <Leader>lc :echo LanguageClient#textDocument_completion()<CR>

map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
" This still shows an error - 'no handler for ..'
map <Leader>lS :call LanguageClient_workspace_symbol()<CR>

map <Leader>ga :call LanguageClient_textDocument_documentHighlight()<CR>

map <Leader>lR :LanguageClientStop<cr>:LanguageClientStart<cr>

" not available for Purescript - but maybe for Haskell?
map <leader>lt <Plug>(coc-type-definition)

nnoremap <leader>Ld :CocList diagnostics<cr>
nnoremap <leader>Ls :CocList symbols<cr>
nnoremap <leader>Lf :CocList folders<cr>
nnoremap <leader>La :CocList actions<cr>
nnoremap <leader>Lc :CocList commands<cr>



" less clutter while having many warnings - or faster glimpse into the issue?
let g:LanguageClient_useVirtualText = "No"
" let g:LanguageClient_fzfOptions = ?
" let $FZF_DEFAULT_OPTS="--preview=bat --reverse"
" let g:LanguageClient_fzfOptions = fzf#vim#with_preview().options
" let g:LanguageClient_fzfOptions = '$FZF_DEFAULT_OPTS'
let g:LanguageClient_fzfContextMenu = 1


" Diagnostics highlighing:
let g:LanguageClient_diagnosticsDisplay = {
      \ 1: {
      \ 'name': 'Error',
      \ 'texthl': 'WarningSign',
      \ 'signTexthl': 'WarningSign',
      \ 'virtualTexthl': 'purescriptLineComment',
      \ 'signText': g:sign_error,
      \ },
      \ 2: {
      \ 'name': 'Warning',
      \ 'texthl': 'WarningSign',
      \ 'signTexthl': 'WarningSign',
      \ 'virtualTexthl': 'purescriptLineComment',
      \ 'signText': g:sign_warning,
      \ },
      \ 3: {
      \ 'name': 'Information',
      \ 'texthl': 'WarningSign',
      \ 'signTexthl': 'WarningSign',
      \ 'virtualTexthl': 'purescriptLineComment',
      \ 'signText': g:sign_warning,
      \ },
      \ 4: {
      \ 'name': 'Hint',
      \ 'texthl': 'WarningSign',
      \ 'signTexthl': 'WarningSign',
      \ 'virtualTexthl': 'purescriptLineComment',
      \ 'signText': g:sign_warning,
      \ },
      \ }

" ─^  Language Client HIE                                ▲



nnoremap ged :call ShowLC_Diagnostics( line('.') )<cr>

" Note (important): To find the source of a LC diagnostic message (warning, error, severity, etc), uncomment the 'echoe' line below
func! s:showLC_Diagnostics( stateJSON )
  if !has_key(a:stateJSON, 'result')
    return
  endif
  let message = ''
  let state = json_decode( a:stateJSON.result )
  let diagnostics = get( state.diagnostics, expand('%:p'), [] )
  " echoe string( diagnostics )
  " echoe string( state )
  " todo: put into a buffer and get other useful things (like the type at the cursor) from it?
  for diag in diagnostics
    if diag.range.start.line +1 == g:_diagnosticsTargetLine
      let message = diag.message
    endif
  endfor
  let messageLines = LCFilterLines( split( message, '\%x00' ) )
  call FloatWin_ShowLines( messageLines )
endfunc

" func! s:showLC_Diagnostics( stateJSON ) ■
"   if has_key(a:stateJSON, 'result')
"     let res = json_decode( a:stateJSON.result )
"     call FloatWin_ShowLines( [ string( res.diagnostics ) ] )
"   endif
" endfunc ▲


func! ShowLC_Diagnostics ( targetLine )
  let g:_diagnosticsTargetLine = a:targetLine
  call LanguageClient#getState(function( 's:showLC_Diagnostics' ))
endfunc


func! LCFilterLines ( lines )
  if a:lines == [] | return a:lines | endif

  if split( a:lines[0] )[0] == 'Hole'
    " return [ ' :: ' . trim( a:lines[ 2 ] ) ]
    let firstTypeLine = a:lines[2]
    let restLines = a:lines[3:]
    return insert( restLines, ' :: ' . firstTypeLine[4:], 0 )
  else
    return a:lines
  endif
endfunc

" Hole '_' has the inferred type
"     HTMLElement
"   in the following context:
"     body :: HTMLElement



" ─   More diagnostics                                   ■


" obsolete?
" function! LCDiagnostics_Update ()
"     " Get diagnostics state by callback interface
"     let l:callback_name = 'LCDiagnostics_Update_CB'
"     call LanguageClient#getState(function(l:callback_name))
" endfunction
"
" " Code from https://github.com/takiyu/lightline-languageclient.vim/
" function! LCDiagnostics_Update_CB ( state )
"     try
"         " Restore result dictionary
"         let l:result_str = a:state.result
"         let l:result = LCDiagnostics_ParseJson(l:result_str)
"
"         let full_filename = expand('%:p')
"         let l:diagnostics = l:result.diagnostics
"         if has_key(l:diagnostics, full_filename)
"             " Return
"             let g:last_diag_exists = 1
"             let g:last_diag_list = l:diagnostics[full_filename]
"         else
"             let g:last_diag_exists = 0
"             let g:last_diag_list = []
"         endif
"     catch
"         echohl 'Something wrong in LanguageClient state parsing for lightline'
"         let g:last_diag_exists = 0
"         let g:last_diag_list = []
"     endtry
" endfunction
"
" function! LCDiagnostics_ParseJson( src_str )
"     " Replace invalid values for VimScript
"     let l:json_str = a:src_str
"     let l:json_str = substitute(l:json_str, "true", "1", "g")
"     let l:json_str = substitute(l:json_str, "false", "0", "g")
"     let l:json_str = substitute(l:json_str, "null", "\"\"", "g")
"     let l:json_str = substitute(l:json_str, "undefined", "\"\"", "g")
"     " Convert string to dictionary
"     let l:json_dict = eval(l:json_str)
"     return l:json_dict
" endfunction
"
"


" ─^  More diagnostics                                   ▲



" ─   Completion                                         ■


" Backup old: using HIE and deoplete
" let g:deoplete#enable_at_startup = 1
" inoremap <expr> <c-i> deoplete#manual_complete()
" call deoplete#custom#option({
"       \ 'auto_complete_delay': 200,
"       \ 'smart_case': v:true,
"       \ 'auto_complete': v:false,
"       \ })





" autocmd BufEnter * call ncm2#enable_for_buffer()
" let g:float_preview#docked = 0
" function! DisableExtras()
"   call nvim_win_set_option(g:float_preview#win, 'number', v:false)
"   call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
"   call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
" endfunction
" autocmd User FloatPreviewWinOpen call DisableExtras()


" set completeopt=menuone,preview
set completeopt=noinsert,menuone,noselect
" set completeopt+=noselect
" set completeopt+=noinsert

" TODO Not sure what effect this has
set completefunc=LanguageClient#complete

set omnifunc=LanguageClient#complete
" set omnifunc=syntaxcomplete#Complete
" set omnifunc=lsp#complete

" let g:haskellmode_completion_ghc = 0
" autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" omni complete
" inoremap <C-B> <C-X><C-O>
" Open omni menu and don't select the first entry
" inoremap <C-space><C-space> <C-x><C-o><C-p>
" navigate the list by using j and k
" Free mapping in insert mode
" inoremap <C-j> <C-n>
" inoremap <C-k> <C-p>

" open suggestions
" imap <Tab> <C-P>


" TODO: above line testen
" insert mode <S-space> schliesst omni preview und fuegt space ein
" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode


" Todo: needed for omnicomplete? - this throws error when hitting return in command history!
" augroup cursleave
"   autocmd!
"   autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"   autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" augroup END


" ─^  Completion                                         ▲


" ─   Get types and Type holes                           ■

" Get type via CocAction 'doHover':
nnoremap <silent> gw :call CocAction('doHover')<cr>
vnoremap <silent> gw :<c-u>call CocAction('doHover')<cr>


" Get :type from Psci for Purescript:
nnoremap \get      :call ReplEval(':type ' . expand('<cword>'))<cr>
vnoremap \get :<c-u>call ReplEval(':type ' . GetVisSel())<cr>
nnoremap \geT      :call ReplEval(':type ' . input( 'Get type: ', expand('<cword>')))<cr>
vnoremap \geT :<c-u>call ReplEval(':type ' . input( 'Get type: ', GetVisSel()))<cr>


nnoremap get      :call CreateTypeHole_LetInBind()<cr>
nnoremap geT      :call CreateTypeHole_DoLetBind( HsCursorKeyword() )<cr>

nnoremap gst      :call CreateTypeHole_DoLetBind( HsCursorKeyword() )<cr>
vnoremap gst :<c-u>call CreateTypeHole_DoLetBind( GetVisSel() )<cr>
nnoremap gsT      :call CreateTypeHole_DoLetBind( input( 'Identifier: ', HsCursorKeyword()) )<cr>
vnoremap gsT :<c-u>call CreateTypeHole_DoLetBind( input( 'Identifier: ', GetVisSel()) )<cr>

" nnoremap <leader>ht      :call CreateTypeHole_LetBind( HsCursorKeyword() )<cr>
" vnoremap <leader>ht :<c-u>call CreateTypeHole_LetBind( GetVisSel() )<cr>
" nnoremap <leader>hT      :call CreateTypeHole_LetBind( input( 'Identifier: ', HsCursorKeyword()) )<cr>
" vnoremap <leader>hT :<c-u>call CreateTypeHole_LetBind( input( 'Identifier: ', GetVisSel()) )<cr>

" nnoremap <leader>hh      :call ShowAndUndoTypeHole_LetBind()<cr>

" let (_:: ?_) = 1 in

func! CreateTypeHole_LetInBind ()
  let g:holeLine= getline('.')
  let holeString = "let (_:: ?_) = unit in "
  call setline('.', strpart(g:holeLine, 0, col('.') - 1) . holeString . strpart(g:holeLine, col('.') - 1))
  call SetLC_DiagnosticsChanged_HandlerLetIn()
endfunc

func! SetLC_DiagnosticsChanged_HandlerLetIn ()
  augroup LCDiagnosticsChanged
    autocmd!
    autocmd User LanguageClientDiagnosticsChanged call ShowAndUndoTypeHole_LetInBind()
  augroup END
endfunc

func! ShowAndUndoTypeHole_LetInBind ()
  call ShowLC_Diagnostics( line('.') )
  silent! autocmd! LCDiagnosticsChanged
  call setline('.', g:holeLine)
endfunc


func! CreateTypeHole_DoLetBind ( identifierInScope )
  let lineText = IndentionString(IndentLevel(line('.')+1)) . 'let (e1 :: ?_) = ' . a:identifierInScope
  call append( line('.'), lineText )
  let s:lineNumOfHole = line('.') +1
  call SetLC_DiagnosticsChanged_HandlerDoLet()
endfunc

func! SetLC_DiagnosticsChanged_HandlerDoLet ()
  augroup LCDiagnosticsChanged
    autocmd!
    autocmd User LanguageClientDiagnosticsChanged call ShowAndUndoTypeHole_DoLetBind()
  augroup END
endfunc

func! ShowAndUndoTypeHole_DoLetBind ()
  call ShowLC_Diagnostics( line('.') +1 )
  silent! autocmd! LCDiagnosticsChanged
  exec s:lineNumOfHole 'delete _'
  normal! k
endfunc


func! IndentionString ( indentionColumn )
  return repeat( ' ', a:indentionColumn -1)
endfunc


" ─^  Get types and Type holes                           ▲


" ─   Repl Relead Tracking                               ■
" augroup LS_StatusChange
"   autocmd!
"   autocmd FileWritePost *.purs echo 'hi'
" augroup END

" au! ag CursorMoved        *.vim :echo  line('.')

au! ag TextChanged *.purs call ReplReload_TrackFileChange()

let g:ReplReload_filesChanged = {}

func! ReplReload_TrackFileChange ()
  if MatchesInLine( line('.'), "^e._" ) || MatchesInLine( line('.'), "^cb." )
    " don't register a reload-need when the cursor is on an 'e2_' line like  e2_pow = pow 4 4
    " call NodeJSRunBinding()
    return
  endif
  let curFile = expand('%')
  let g:ReplReload_filesChanged[curFile] = v:true
  " echo g:ReplReload_filesChanged
endfunc

func! ReplReload_FileNeedsReplReload ( fileName )
  return has_key(g:ReplReload_filesChanged, a:fileName) && g:ReplReload_filesChanged[a:fileName]
endfunc

func! ReplReload_Refreshed ( fileName )
  let g:ReplReload_filesChanged[a:fileName] = v:false
  " let g:ReplReload_filesChanged = {}
endfunc
" echo ReplReload_FileNeedsReplReload(expand('%'))


" ─^  Repl Relead Tracking                               ▲


