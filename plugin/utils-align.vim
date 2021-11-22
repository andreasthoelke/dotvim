

" Note: This has to contain the (easy-align propriaty?) "/" syntax, so we can e.g. refer to the second column via "2\"
" let g:pttnsTypeSigs4 = [                          '/∷/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '2/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '/\(([^)]*\)\@<!.*\zs→\([^(]*)\)\@!/']
" let g:pttnsTypeSigs4 = ['/ / {"left_margin": 0, "right_margin": 0}', '/∷/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '2/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '/\(([^)]*\)\@<!.*\zs→\([^(]*)\)\@!/']

let g:pttnsTypeSigs4 = ['/ / {"left_margin": 0, "right_margin": 0}', '/'. PatternToMatchOutsideOfParentheses('∷','(',')') .'/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '2/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '/\(([^)]*\)\@<!.*\zs→\([^(]*)\)\@!/']
" let g:pttnsTypeSigs4 = ['/ / ',                   '/∷/', '/.*\(∷\zs\s\|\zs⇒\)/', '/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '2/\(([^)]*\)\@<!→\([^(]*)\)\@!/', '/\(([^)]*\)\@<!.*\zs→\([^(]*)\)\@!/']


" TODO in HsAPI output I want ranges of separate alignment. test this e.g. with \j motion and 'ip'
" - then there should be a script the aligns all paragraps?
" - to updata alignment, all aligning (multiple?) spaces need to be removed first -  like get back to normal form
" - perhaps the entire process should therefore be maintained as structured source-data-obj + persistable user
"   formatting?

" Set the contFn to be called with start/end line
" contArgs defines other/preceding (optional) args to be applied to the contFn
" nnoremap ,at      :let g:opContFn='HsTabu'<cr>:let g:opContArgs=[g:pttnsTypeSigs4]<cr>:set opfunc=Gen_opfunc<cr>g@
" vnoremap ,at :<c-u>let g:opContFn='HsTabu'<cr>:let g:opContArgs=[g:pttnsTypeSigs4]<cr>:call Gen_opfunc('', 1)<cr>
nnoremap <leader>t      :let g:opContFn='HsTabu'<cr>:let g:opContArgs=[g:pttnsTypeSigs4]<cr>:set opfunc=Gen_opfuncAc<cr>g@
vnoremap <leader>t :<c-u>let g:opContFn='HsTabu'<cr>:let g:opContArgs=[g:pttnsTypeSigs4]<cr>:call Gen_opfuncAc('', 1)<cr>

func! Gen_opfuncAc( _, ...)
  " First arg is sent via op-fn. presence of second arg indicates visual-sel
  let [l1, l2] = a:0 ? [line("'<"), line("'>")] : [line("'["), line("']")]
  call call( g:opContFn, g:opContArgs + [l1, l2] )
endfunc
" Also note: " Vim Pattern For applying a function via an operator map, visual selection and command ~/.vim/plugin/code-line-props.vim#/Vim%20Pattern.%20For

command! -range=% HsTabu call HsTabu( [], <line1>, <line2> ) | normal! gg0
" Align/Tabularize a list of column-patters over an (optional) range of lines
func! HsTabu( columnPttns, ...)
  let columnPttns = len(a:columnPttns) ? a:columnPttns : g:pttnsTypeSigs4
  let   startLine = a:0 ? a:1 : 1
  let   endLine = a:0 ? a:2 : line('$')
  " remove any previous alignment
  " call StripAligningSpaces( startLine, endLine )
  " unicode to simplify the process
  call HsUnicode( startLine, endLine )
  for pttn in columnPttns
    call easy_align#easyAlign( startLine, endLine, pttn)
  endfor
  call HsUnUnicode( startLine, endLine )
endfunc
" call HsTabu( g:pttnsTypeSigs4 )
" call HsTabu( [] )


" ─   Align Templates                                    ■
" ,a(motion)(sel) - run a multi-col align template on motion or vis sel
" Tests: - ",aii=" will align to "=" inside indent block

nnoremap ,a      :let g:opContFn='HsAlignUC'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
vnoremap ,a :<c-u>let g:opContFn='HsAlignUC'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

func! HsAlignUC( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  call UserChoiceAction('Align to:', {}, g:alignTempl, function('HsAlignAp'), [startLine, endLine])
endfunc

func! HsAlignAp( startLine, endLine, ucProps )
  call HsAlign( a:ucProps.pttns, a:startLine, a:endLine )
endfunc

let g:alignTempl = [
      \  {'label':'_space',     'pttns': ['/ / {"left_margin": 0, "right_margin": 0}']}
      \, {'label':'_= equal',   'pttns': ['=']}
      \, {'label':'_, comma',   'pttns': ['/\,/']}
      \, {'label':'_<- bind',   'pttns': ['/<-/']}
      \, {'label':'_> case',   'pttns': ['/->/']}
      \, {'label':'_type sigs', 'pttns': g:pttnsTypeSigs4}
      \]


" A simple (non UChoiceAction) way to map multi-column alignments
" nnoremap <leader>a=      :let g:opContFn='HsAlign'<cr>:let g:opContArgs=[['=']]<cr>:set opfunc=Gen_opfuncAc<cr>g@
" vnoremap <leader>a= :<c-u>let g:opContFn='HsAlign'<cr>:let g:opContArgs=[['=']]<cr>:call Gen_opfuncAc('', 1)<cr>

command! -nargs=1 -range=% HsAlign call HsAlign ( <args>, <line1>, <line2> )
" Test: - ":HsAlign []" would align the entire buffer by the first and second space-column

func! HsAlign( columnPttns, ... )
  let columnPttns = len(a:columnPttns) ? a:columnPttns : ['/ / {"left_margin": 0, "right_margin": 0}', '2/ / {"left_margin": 0, "right_margin": 0}']
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  for pttn in columnPttns
    call easy_align#easyAlign( startLine, endLine, pttn)
  endfor
endfunc



" ─^  Align Templates                                    ▲

command! -range=% StripAligningSpaces call StripAligningSpaces( <line1>, <line2> )
" Note: this applies to the whole buffer when no visual-sel

nnoremap <leader>as      :let g:opContFn='StripAligningSpaces'<cr>:let g:opContArgs=[]<cr>:set opfunc=Gen_opfuncAc<cr>g@
vnoremap <leader>as :<c-u>let g:opContFn='StripAligningSpaces'<cr>:let g:opContArgs=[]<cr>:call Gen_opfuncAc('', 1)<cr>

func! StripAligningSpaces( ... )
  let startLine = a:0 ? a:1 : 1
  let endLine = a:0 ? a:2 : line('$')
  let rangeStr = startLine . ',' . endLine
  exec rangeStr . 's/\S\zs\s\+/ /g'
endfunc
" call StripAligningSpaces()


" Push shift text to the right:
" nnoremap <localleader>> i <esc>
nnoremap <localleader>> :call InsertStringAtLoc( ' ', line('.'), col('.')-2 )<cr>
" nnoremap <localleader>> i <Esc>
" Make it repeatable so the cursor follows the text to the right
" Followup: it just does this. not sure what the problem was before
" nmap <Plug>PushTextRight i <esc>l:call repeat#set("\<Plug>PushTextRight")<cr>
" nmap <localleader>> <Plug>PushTextRight

func! InsertStringAtLoc( str, line, col )
  let lineText = getline( a:line )
  let textBefore = lineText[:a:col]
  let textAfter = lineText[a:col+1:]
  if a:col == -1
    " quick fix for cursor positon 1
    let textBefore = ""
  endif
  " echo textBefore
  " echo textAfter
  normal! "_dd
  call append( a:line-1, textBefore . a:str . textAfter )
  normal! k
endfunc
" echo InsertStringAtLoc( 'XX', line('.'), col('.')-2 )


nnoremap <leader>sb i<CR><C-R>=repeat(' ',col([line('.')-1,'$'])-col('.'))<CR><Esc>l
" nnoremap <leader>sn :echo col([line('.'),'$'])<CR>
nnoremap <leader>sn i<CR><C-R>=repeat(' ',col([line('.')-1,'$'])-col('.'))<CR><Esc>l
" Vim will insert a newline (<CR>) followed by a number of spaces (<C-R>=repeat(' ',...)) equal to the difference between the column number of the end of the previous line (col([line('.')-1,'$'])) and the current column number (col('.'))



" Old: ■
" nnoremap <leader>>> :call IndentToCursorH()<CR>
" nnoremap <leader><< :call IndentToCursorH()<CR>
" TODO: maybe make a mapping "dwkwj<leader>>>" to indent haskell binds:
" jsonValue ∷ Value
"           ← decode (T.encodeUtf8 jsonTxt) ?? "Not a valid json!"
"
" function! IndentToCursorH()
"   exec ("left " . (virtcol('.') - 1))
" endfun ▲

" ─   Indent to cursor H                                 ■

" `leader >>` + motion or vis-sel with "v" indents the lines to the current cursor-horz position
" nnoremap <silent> <leader>>> :set opfunc=Indent_op<cr>g@
nnoremap <silent> <localleader>, :set opfunc=Indent_op<cr>g@
" vnoremap <silent> <leader>>> :<c-u>call Indent_op( visualmode(), 1)<cr>
vnoremap <silent> <localleader>, :<c-u>call Indent_op( visualmode(), 1)<cr>
" Note: This does not work with "V"/ Visual-Block mode

" TODO: use visual-sel to intent from a specific point of the line string. example
" - MyActions will be a Sum type
" - MyState will be a Product type
" how to: take the length of the visual sel (vitual-cols?) and insert n-spaces at the left-most point of the visual-sel

" Note for extending this:
" Below is an example of how to perform multiple easy-alignments on a (motion-) range of lines.
" So instead of running: "<leader>al,j "& "<leader>al,j2 ". you can just do "<leader>at,j"

" Perform an align operation on a range of lines. An operator function can/needs to access the range as shown below
func! Indent_op( motionType, ...)
  normal! m'
  " motionType could e.g. be 'char' here - but aligning will only use linewise here
  let motionType = 'lines'
  " Get the range of lines from either visual mode ( "'<") or an (operator pending) motion or text object
  if a:0
    let [l1, l2] = ["'<", "'>"]
  else
    let [l1, l2] = [line("'["), line("']")]
  endif
  " Format the range string
  let range = l1.','.l2
  execute range .  ("left " . (col('.') - 1))
  " call JumpBackSkipCurrentLoc()
endfunc

" ─^  Indent to cursor H                                 ▲



