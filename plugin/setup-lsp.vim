
" https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim/blob/main/README.md

lua <<EOF
-- require'toggle_lsp_diagnostics'.init()
-- require'toggle_lsp_diagnostics'.init({ start_on = true, signs = false, underline = false, virtual_text = { prefix = "|" }})
EOF


" nmap <silent>            ,gd <Plug>(coc-definition)
" nmap <silent> \gd :vsplit<CR><Plug>(coc-definition)
" nmap <silent> gd :call FloatingBuffer(expand('%'))<CR><Plug>(coc-definition)
" nmap <silent> gD :split<CR><Plug>(coc-definition)

nnoremap <silent> gdd :LspDef<cr>
nnoremap <silent> gdo :call FloatingBuffer(expand('%'))<CR>:LspDef<cr>
nnoremap <silent> gdv :vsplit<CR>:LspDef<cr>
nnoremap <silent> gds :split<CR>:LspDef<cr>


nmap <leader>ltu <Plug>(toggle-lsp-diag-underline)
nmap <leader>lts <Plug>(toggle-lsp-diag-signs)
nmap <leader>ltv <Plug>(toggle-lsp-diag-vtext)
nmap <leader>ltp <Plug>(toggle-lsp-diag-update_in_insert)
nmap <leader>ltd  <Plug>(toggle-lsp-diag)

" Issue: ToggleDiagDefault only works via the Command!?
nmap <leader>ltD  :ToggleDiagDefault<cr>
" nmap <leader>ltdd <Plug>(toggle-lsp-diag-default)
nmap <leader>ltdo <Plug>(toggle-lsp-diag-off)
nmap <leader>ltdf <Plug>(toggle-lsp-diag-on)

" ─   coc-nvim                                          ──
" https://github.com/neoclide/coc.nvim/blob/master/README.md
let g:coc_config_home = '~/.config/nvim'
" ~/.coc-settings.json
" old settings: ~/.config/nvim/plugin/tools-langClientHIE-completion.vim.bak#/let%20g.coc_config_home%20=

" Coc's completion menu can itegrate many sources (like webbrowser, buffer, lsp).
" inoremap <silent><expr> <c-i> coc#refresh()
inoremap <silent><expr> <Tab> coc#refresh()
" nnoremap <Tab> :echo "hi4"<cr>

" nnoremap <leader>lds :call DiagnosticsShow()<cr>
nnoremap <leader>lds :TroubleToggle<cr>


" Using buffer maps here: ~/.config/nvim/plugin/tools_rescript.vim#/nnoremap%20<silent><buffer>%20ged
" nnoremap <silent><buffer>         ger :lua vim.lsp.buf.references()<cr>:call T_DelayedCmd( "wincmd p", 50 )<cr>
" Todo: make these maps general per languge and put them here or
" ~/.config/nvim/plugin/general-setup.lua#/--%20Todo.%20make


" This might be an interesting tool function. (otherwise i might use :Trouble)
func! DiagnosticsShow ()
  let resLines = v:lua.vim.lsp.diagnostic.get(0)
  let resLines = functional#map( 'string', resLines )
  " let resLines = SubstituteInLines( resLines, '\n', '' )
  " call FloatWin_ShowLines( resLines )
  silent let g:floatWin_win = FloatingSmallNew ( resLines )

  " silent call FloatWin_FitWidthHeight()
  " silent wincmd p
endfunc
" this works (in a .res buffer)
" echo v:lua.vim.lsp.diagnostic.get(0)

" For further pretty printing the return JSON I'd need to convert JSON back to a js-object ..
" call System_Float( "node -e '" . "console.log( 44 )" . "'" )
" call System_Float( "node -e 'console.log(" . "42" . ")'" )
" call System_Float( "node -e 'console.log(" . string( [4, 4, 3] ) . ")'" )
" echo tools_js#json_stringify( expressionCodeStr )
" echo tools_js#eval_expression( '{aa: 44, bb: "eins"}.aa' )
" " {'tags': [1], 'source': 'ReScript', 'code': 27, 'message': 'unused variable reject. ', 'severity': 2, 'range': {'end': {'character': 50, 'line': 27}, 'start': {'character': 43, 'line': 27}}}

" all Coc config options
" https://github.com/neoclide/coc.nvim/blob/72095ac4b96f4bef3809cafcaeddcaad074f7bcf/data/schema.json

" enable/disable diagnostics (how to set this up on a pre-language level?)
" ~/.config/nvim/coc-settings.json#/"diagnostic.enable".%20false,

" autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})
" autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)

" inoremap <expr> <c-i> pumvisible() ? "\<C-o>coc#_hide()" : "<c-i>"

" doesn't work
" call CocAction('runCommand', 'editor.action.organizeImport')


" ─   ReScript Vim                                      ──

" autocmd FileType rescript setlocal omnifunc=rescript#Complete

" Todo: feature type hint for visual selection
function! RescriptTypeHint()

  if expand('<cword>') == 'let'
    normal w
  endif

  let c_line = line(".")
  let c_col = col(".")

  let l:command = g:rescript_analysis_exe . " hover " . @% . " " . (c_line - 1) . " " . (c_col - 1)

  silent let out = system(l:command)

  if v:shell_error != 0
    echohl Error | echomsg "Type Info failed with exit code '" . v:shell_error . "'" | echohl None
    return
  endif

  let l:json = []
  try
    let l:json = json_decode(out)
  catch /.*/
    echo "No type info (couldn't decode analysis result)"
    return
  endtry

  let l:match = l:json

  if type( l:match ) != 4
    echo 'No type info'
    echo l:match
    return
  endif

  if get(l:match, "contents", "") != ""
    let md_content = l:match.contents

    let lines = split(md_content, "\n")
    " let lines = extend(["Pos (l:c): " . c_line . ":" . c_col], text)

    " call s:ShowInPreview("type-preview", "markdown", lines)

    let lines = functional#filter( {line -> !(line =~ '```')}, lines )


    call writefile( lines, '/Users/at/.vim/scratch/typeinfo.res' )

    silent let g:floatWin_win = FloatingSmallNew ( [] )

    exec 'edit' '/Users/at/.vim/scratch/typeinfo.res'

    " set filetype=rescript
    silent call FloatWin_FitWidthHeight()
    silent wincmd p

    return
  endif
  echo "No type info"
endfunction


" echo !( '```res' =~ '```' )


" Todo: feature range and motion/textobject maps
function! RescriptFormat()

  let l:ext = expand("%:e")

  if matchstr(l:ext, 'resi\?') == ""
    echo "Current buffer is not a .res / .resi file... Do nothing."
    return
  endif

  let l:view = winsaveview()

  " Used for stderr tracking
  let l:stderr_tmpname = tempname()
  call writefile([], l:stderr_tmpname)

  " Used for the actual buffer content
  " this is needed to because bsc -format can't
  " consume code from stdin, so we need to dump
  " the content into a temporary file first
  let l:tmpname = tempname() . "." . l:ext

  call writefile(getline(1, '$'), l:tmpname)

  " bsc -format myFile.res > tempfile
  let l:command = g:rescript_bsc_exe . " -color never -format " . l:tmpname . " 2> " . l:stderr_tmpname

  exe "lcd " . g:rescript_project_root
  silent let l:out = systemlist(l:command)
  exe "lcd -"

  let l:stderr = readfile(l:stderr_tmpname)

  if v:shell_error ==? 0
    call DeleteLines(len(l:out), line('$'))
    call setline(1, l:out)

    " Make sure syntax highlighting doesn't break
    syntax sync fromstart

    " Clear out location list in case a previous syntax error was fixed
    let s:got_format_err = 0
    call setqflist([])
    cclose
  else
    let l:stderr = readfile(l:stderr_tmpname)

    let l:errors = rescript#parsing#ParseCompilerErrorOutput(l:stderr)

    if !empty(l:errors)
      for l:err in l:errors
        let l:err.filename = @%
      endfor
      call setqflist(l:errors, 'r')
      botright cwindow
      cfirst
    endif

    let s:got_format_err = 1
    echohl Error | echomsg "rescript format returned an error" | echohl None
  endif

  call delete(l:stderr_tmpname)
  call delete(l:tmpname)

  call winrestview(l:view)

  if s:got_format_err ==? 1
    return { 'has_error': 1, 'errors': l:errors }
  else
    return { 'has_error': 0, 'errors': [] }
  endif
endfunction


function! DeleteLines(start, end) abort
    silent! execute a:start . ',' . a:end . 'delete _'
endfunction










