
" example file
" ~/.local/share/nvim/parrot/chats/2025-07-29.12-13-51.md
" call MagentaBufferMaps()

func! MagentaBufferMaps()
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


endfunc


" NOTE these are common "columns" in gpt-5 output.
let g:Mgn_columnPttn = MakeOrPttn( ['\:', '\,', '\.','\;'] )


func! Mgn_ColumnForw()
  call SearchSkipSC( g:Mgn_columnPttn, 'W' )
  normal w
endfunc

func! Mgn_ColumnBackw()
  normal bh
  call SearchSkipSC( g:Mgn_columnPttn, 'bW' )
  normal w
endfunc


" let g:Mgn_MainStartPattern = '\v(# \zs|✏️.{-}in\s\`\zs)'
" Require blank line before two-space section starts so mid-paragraph indents don't match
let g:Mgn_MainStartPattern = '\v(^#{1,3} \zs|• \zs|\n\n\zs  \zs\i|✅ \zs|⏺ \zs)'
" the *\S{-}\* patterns is searching vim help headlines

let g:Mgn_TopLevelPattern = '\v(^# \zs|› \zs|─ \zs)'
" let g:Mgn_TopLevelPattern = '^# \zs'

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
  normal! kk
  call search( g:Mgn_TopLevelPattern, 'W' )
endfunc
