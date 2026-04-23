
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
  onoremap <silent><buffer> I <cmd>call Mgn_ColumnForw()<cr>
  onoremap <silent><buffer> Y <cmd>call Mgn_ColumnBackw()<cr>
  xnoremap <silent><buffer> I <esc><cmd>call ChangeVisSel(function('Mgn_ColumnForw'))<cr>
  xnoremap <silent><buffer> Y <esc><cmd>call ChangeVisSel(function('Mgn_ColumnBackw'))<cr>

  " Clause text object: select up to next ", " "; " ": " "! " "? " or " - "
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

let g:Mgn_columnPttn = MakeOrPttn( ['\:', '#','→', '\,', '\- ','\;'] )

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

" Clause text object: span from current position to next ", " / "; " / " - "
" mode: 'i' = inner (stop before separator), 'a' = around (include separator + space)
let g:MD_clausePttn = '\(,\s\|;\s\|:\s\|!\s\|?\s\|\s-\s\)'
func! MD_ClauseObj(mode)
  let l:startLine = line('.')
  let l:startCol  = col('.')
  " Find end: search forward for separator on current line
  let [l:eLine, l:eCol] = searchpos(g:MD_clausePttn, 'nW')
  if l:eLine == 0 || l:eLine != l:startLine
    " No separator on this line: fall back to end of line
    let l:eLine = l:startLine
    let l:eCol  = col('$') - 1
    let l:endCol = l:eCol
  else
    if a:mode ==# 'a'
      " include the ", " / "; " — two chars; " - " is three
      let l:matchStr = matchstr(getline(l:eLine)[l:eCol-1:], g:MD_clausePttn)
      let l:endCol = l:eCol + strlen(l:matchStr) - 1
    else
      let l:endCol = l:eCol - 1
    endif
  endif
  call setpos("'<", [0, l:startLine, l:startCol, 0])
  call setpos("'>", [0, l:eLine,      l:endCol,  0])
  normal! `<v`>
endfunc
