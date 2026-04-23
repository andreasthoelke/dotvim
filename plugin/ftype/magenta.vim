
" example file
" ~/.local/share/nvim/parrot/chats/2025-07-29.12-13-51.md
" call MarkdownNavMaps()

func! MarkdownNavMaps()
  " set syntax=markdown
  " call MarkdownSyntaxAdditions()

  nnoremap <silent><buffer><leader>ot :Outline<cr>
  " nnoremap <silent><buffer>gdi :lua require("follow-md-links").follow_link()<cr>

" ─   Search                                             ■

  " Note these two are new 2025-08
  nnoremap <silent><buffer> gs;  :lua require('utils.general').Search_current_buffer_md_headers()<cr>
  nnoremap <silent><buffer> gs:  :lua require('utils.general').Search_cwd_md_headers()<cr>

  " nnoremap <silent><buffer> gsf  :Telescope current_buffer_fuzzy_find<cr>
  " nnoremap <silent><buffer> gsg  :Telescope live_grep<cr>
  " Moved to ~/.config/nvim/plugin/config/telescope.vim‖*ˍˍˍFileˍsearchˍmapsˍ2025-03
  " nnoremap <silent><buffer> gsf  :call v:lua.Telesc_launch('current_buffer_fuzzy_find')<cr>
  " nnoremap <silent><buffer> gsg  :call v:lua.Telesc_launch('live_grep')<cr>

  " nnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( 'global', expand('<cword>'), "normal" )<cr>
  " xnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( 'global', GetVisSel(), "normal" )<cr>

  nnoremap <silent><buffer> gsr  :call v:lua.Search_selection()<cr>
  xnoremap <silent><buffer> gsr  :call v:lua.Search_mainPatterns( 'global', GetVisSel(), "normal" )<cr>

  nnoremap <silent><buffer> gst  :call v:lua.Search_ast( expand('<cword>') )<cr>
  xnoremap <silent><buffer> gst  :call v:lua.Search_ast( GetVisSel() )<cr>


" ─^  Search                                             ▲

" ─     Motions                                         ──
  nnoremap <silent><buffer> I :call Mgn_ColumnForw()<cr>
  nnoremap <silent><buffer> Y :call Mgn_ColumnBackw()<cr>
  nnoremap <silent><buffer> ]t :call MD_ClauseStartForw()<cr>
  nnoremap <silent><buffer> [t :call MD_ClauseStartBackw()<cr>
  onoremap <silent><buffer> I <cmd>call Mgn_ColumnForw()<cr>
  onoremap <silent><buffer> Y <cmd>call Mgn_ColumnBackw()<cr>
  xnoremap <silent><buffer> I <esc><cmd>call ChangeVisSel(function('Mgn_ColumnForw'))<cr>
  xnoremap <silent><buffer> Y <esc><cmd>call ChangeVisSel(function('Mgn_ColumnBackw'))<cr>
  xnoremap <silent><buffer> ]t <esc><cmd>call ChangeVisSel(function('MD_ClauseStartForw'))<cr>
  xnoremap <silent><buffer> [t <esc><cmd>call ChangeVisSel(function('MD_ClauseStartBackw'))<cr>

  " Clause text object: select the current ]t/[t clause/sentence chunk.
  " ic = inner clause (exclusive of separator), ac = around clause (inclusive)
  onoremap <silent><buffer> ic <cmd>call MD_ClauseObj('i')<cr>
  xnoremap <silent><buffer> ic <cmd>call MD_ClauseObj('i')<cr>
  onoremap <silent><buffer> ac <cmd>call MD_ClauseObj('a')<cr>
  xnoremap <silent><buffer> ac <cmd>call MD_ClauseObj('a')<cr>

  nnoremap <silent><buffer> <c-p>         :call Mgn_MainStartBindingBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Mgn_MainStartBindingForw()<cr>:call ScrollOff(27)<cr>

  nnoremap <silent><buffer> <leader><c-p> :call Mgn_TopLevBindingBackw()<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Mgn_TopLevBindingForw()<cr>:call ScrollOff(22)<cr>

  nnoremap <silent><buffer> t :call BracketStartForw()<cr>
  vnoremap <silent><buffer> t <esc>:call ChangeVisSel(function('BracketStartForw'))<cr>
  nnoremap <silent><buffer> T b:call BracketStartBackw()<cr>w
  vnoremap <silent><buffer> T <esc>:call ChangeVisSel(function('BracketStartBackw'))<cr>
  nnoremap <silent><buffer> <leader>]t :call BracketEndForw()<cr>
  nnoremap <silent><buffer> ]T :call BracketEndForw()<cr>
  vnoremap <silent><buffer> ]T <esc>:call ChangeVisSel(function('BracketEndForw'))<cr>h

  nnoremap <silent><buffer>]b :call MD_BoldNext()<cr>
  nnoremap <silent><buffer>[b :call MD_BoldPrev()<cr>

  nnoremap <silent><buffer> ( :call Md_MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call Md_MvNextLineStart()<cr>


endfunc


func! Md_SkipLinePrefix()
  " Skip leading markers to land on first significant word:
  "   ## Heading  ->  Heading
  "   - item      ->  item
  "   > quote     ->  quote
  "   1. item     ->  item
  let c = GetCharAtCursor()
  if c == '#'
    call search('^#\+\s*\zs\S', 'c')
  elseif c =~ '[-*>]'
    normal! w
  elseif c =~ '\d'
    call search('^\d\+\.\s*\zs\S', 'c')
  endif
endfunc

func! Md_MvLineStart()
  normal! m'
  normal! ^
  call Md_SkipLinePrefix()
endfunc

func! Md_MvNextLineStart()
  normal! m'
  normal! j^
  call Md_SkipLinePrefix()
endfunc


" ─   Markdown agent nav patterns                        ■

let g:Mgn_columnPttn = MakeOrPttn( ['\:', '#','→', '\,', '\- ', '—', '–', '─', '\;'] )

" let g:Mgn_MainStartPattern = '\v(# \zs|✏️.{-}in\s\`\zs)'
" Require blank line before two-space section starts so mid-paragraph indents don't match
let g:Mgn_MainStartPattern = '\v(#{1,3} \zs|• \zs|\n\n\zs  \zs\i|✅ \zs|⏺ \zs|^# \zs|› \zs|^---|☼\:\zs|⌘\:\zs|─ \zs)'
" the *\S{-}\* patterns is searching vim help headlines

let g:Mgn_TopLevelPattern = '\v(^# \zs|› \zs|^---|☼\:\zs|⌘\:\zs|^─ \zs)'

" ─^  Markdown agent nav patterns                        ▲



func! Mgn_ColumnForw()
  call SearchSkipSC( g:Mgn_columnPttn, 'W' )
  normal w
endfunc

func! Mgn_ColumnBackw()
  normal bh
  call SearchSkipSC( g:Mgn_columnPttn, 'bW' )
  normal w
endfunc



func! Mgn_MainStartBindingForw()
  normal! jj
  call search( g:Mgn_MainStartPattern, 'W' )
  " call ScrollUp(5)
  call ScrollUpFromMiddle( 7 )
  " normal! <c-e><c-e><c-e>
endfunc

func! Mgn_MainStartBindingBackw()
  normal! ^kk
  call search( g:Mgn_MainStartPattern, 'bW' )
  normal! kk
  call search( g:Mgn_MainStartPattern, 'W' )
  call ScrollUpFromMiddle( 7 )
  " call ScrollUp(5)
endfunc

func! Mgn_TopLevBindingForw()
  normal! jj
  call search( g:Mgn_TopLevelPattern, 'W' )
endfunc

func! Mgn_TopLevBindingBackw()
  normal! ^
  call search( g:Mgn_TopLevelPattern, 'bW' )
  if line('.') > 3
    normal! kk
    call search( g:Mgn_TopLevelPattern, 'W' )
  endif
endfunc

" Clause text object and ]t/[t motions share these separators:
" Includes comma, semicolon, colon, sentence punctuation, spaced hyphen,
" and spaced long dash separators.
" mode: 'i' = inner (stop before separator), 'a' = around (include separator + space)
let g:MD_clausePttn = '\(,\s\|;\s\|:\s\|[.!?]["'')\]]*\s\|\s-\s\|\s—\s\)'

func! MD_PosBefore(posA, posB)
  return a:posA[0] < a:posB[0] || (a:posA[0] == a:posB[0] && a:posA[1] < a:posB[1])
endfunc

func! MD_PosAfter(posA, posB)
  return a:posA[0] > a:posB[0] || (a:posA[0] == a:posB[0] && a:posA[1] > a:posB[1])
endfunc

func! MD_AddClauseStart(starts, pos)
  if a:pos[0] == 0
    return
  endif
  if empty(a:starts) || a:starts[-1] != a:pos
    call add(a:starts, a:pos)
  endif
endfunc

func! MD_TrimEndBefore(line, col, pStart)
  let l:savePos = getpos('.')
  call setpos('.', [0, a:line, a:col, 0])
  let l:pos = searchpos('\S', 'bW', a:pStart)
  call setpos('.', l:savePos)
  return l:pos
endfunc

func! MD_LastTextPos(pStart, pEnd)
  let l:savePos = getpos('.')
  call setpos('.', [0, a:pEnd, strlen(getline(a:pEnd)) + 1, 0])
  let l:pos = searchpos('\S', 'bW', a:pStart)
  call setpos('.', l:savePos)
  return l:pos
endfunc

func! MD_TrimMarkdownClose(pos)
  let [l:line, l:col] = a:pos
  while l:col > 1 && strpart(getline(l:line), l:col - 1, 1) =~ '[*_`]'
    let l:col -= 1
  endwhile
  return [l:line, l:col]
endfunc

func! MD_ClauseSegments()
  let l:savePos = getpos('.')
  let l:view = winsaveview()
  let [l:pStart, l:pEnd] = ParagraphStartEndLines()
  let l:segments = []

  call setpos('.', [0, l:pStart, 1, 0])
  let l:start = searchpos('\k', 'cW', l:pEnd)

  call setpos('.', [0, l:pStart, 1, 0])
  while 1
    let [l:sepLine, l:sepCol] = searchpos(g:MD_clausePttn, 'W', l:pEnd)
    if l:sepLine == 0
      break
    endif

    let l:matchStr = matchstr(getline(l:sepLine)[l:sepCol-1:], g:MD_clausePttn)
    let l:sepEnd = [l:sepLine, l:sepCol + strlen(l:matchStr) - 1]
    let l:innerEnd = MD_TrimMarkdownClose(MD_TrimEndBefore(l:sepLine, l:sepCol, l:pStart))
    if l:start[0] != 0 && MD_PosBefore(l:start, [l:sepLine, l:sepCol])
      call add(l:segments, {
            \ 'start': l:start,
            \ 'innerEnd': l:innerEnd,
            \ 'aroundEnd': l:sepEnd,
            \ })
    endif

    call setpos('.', [0, l:sepEnd[0], l:sepEnd[1] + 1, 0])
    let l:start = searchpos('\k', 'cW', l:pEnd)
  endwhile

  if l:start[0] != 0
    let l:innerEnd = MD_TrimMarkdownClose(MD_LastTextPos(l:pStart, l:pEnd))
    if l:innerEnd[0] != 0 && !MD_PosBefore(l:innerEnd, l:start)
      call add(l:segments, {
            \ 'start': l:start,
            \ 'innerEnd': l:innerEnd,
            \ 'aroundEnd': l:innerEnd,
            \ })
    endif
  endif

  call setpos('.', l:savePos)
  call winrestview(l:view)
  return l:segments
endfunc

func! MD_ClauseStartPositions()
  let l:starts = []
  for l:segment in MD_ClauseSegments()
    call MD_AddClauseStart(l:starts, l:segment.start)
  endfor
  return l:starts
endfunc

func! MD_ClauseStartForw()
  let l:cursor = [line('.'), col('.')]
  for l:pos in MD_ClauseStartPositions()
    if MD_PosAfter(l:pos, l:cursor)
      call setpos('.', [0, l:pos[0], l:pos[1], 0])
      return
    endif
  endfor
endfunc

func! MD_ClauseStartBackw()
  let l:cursor = [line('.'), col('.')]
  let l:target = []
  for l:pos in MD_ClauseStartPositions()
    if MD_PosBefore(l:pos, l:cursor)
      let l:target = l:pos
    endif
  endfor

  if !empty(l:target)
    call setpos('.', [0, l:target[0], l:target[1], 0])
  endif
endfunc

func! MD_ClauseObj(mode)
  let l:cursor = [line('.'), col('.')]
  let l:target = {}

  for l:segment in MD_ClauseSegments()
    if !MD_PosAfter(l:segment.start, l:cursor)
      let l:target = l:segment
    endif
  endfor

  if empty(l:target)
    let l:segments = MD_ClauseSegments()
    if empty(l:segments)
      return
    endif
    let l:target = l:segments[0]
  endif

  let l:end = a:mode ==# 'a' ? l:target.aroundEnd : l:target.innerEnd
  call setpos('.', [0, l:target.start[0], l:target.start[1], 0])
  normal! v
  call setpos('.', [0, l:end[0], l:end[1], 0])
endfunc
