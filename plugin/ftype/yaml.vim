
" ─   Syntax additions                                   ■

func! YamlSyntaxAdditions()
  " A reused split window can keep stale yaml state from a previous buffer.
  " Refresh only yaml-owned matches instead of relying on a one-time flag.
  if exists('w:yaml_conceal_match_ids')
    for id in w:yaml_conceal_match_ids
      silent! call matchdelete(id)
    endfor
  endif
  let w:yaml_conceal_match_ids = []

  call add(w:yaml_conceal_match_ids, matchadd('Conceal', '->', 10, -1, {'conceal': '→'}))
  call add(w:yaml_conceal_match_ids, matchadd('Conceal', '<-', 10, -1, {'conceal': '←'}))
  call add(w:yaml_conceal_match_ids, matchadd('Conceal', '=>', 10, -1, {'conceal': ''}))
  call add(w:yaml_conceal_match_ids, matchadd('Conceal', '<<', 10, -1, {'conceal': '«'}))
  call add(w:yaml_conceal_match_ids, matchadd('Conceal', '>>', 10, -1, {'conceal': '»'}))
  setlocal conceallevel=2
  setlocal concealcursor=ni
endfunc

" ─^  Syntax additions                                   ▲


" ─   Buffer Maps                                        ■

func! YamlBufferMaps()
  nnoremap <silent><buffer><leader>ot :Outline<cr>

  nnoremap <silent><buffer> I :call Yaml_ColumnForw()<cr>
  nnoremap <silent><buffer> Y :call Yaml_ColumnBackw()<cr>

  nnoremap <silent><buffer> <c-p>         :call Yaml_MainStartBackw()<cr>:call ScrollOff(10)<cr>
  nnoremap <silent><buffer> <c-n>         :call Yaml_MainStartForw()<cr>:call ScrollOff(27)<cr>

  nnoremap <silent><buffer> <leader><c-p> :call Yaml_TopLevBackw()<cr>
  nnoremap <silent><buffer> <leader><c-n> :call Yaml_TopLevForw()<cr>:call ScrollOff(22)<cr>

  nnoremap <silent><buffer> ( :call Yaml_MvLineStart()<cr>
  nnoremap <silent><buffer> ) :call Yaml_MvNextLineStart()<cr>
endfunc


func! Yaml_MvLineStart()
  normal! m'
  normal! ^
  " Reuse Md_SkipLinePrefix: skips '- ' list markers (same pattern in yaml)
  call Md_SkipLinePrefix()
endfunc

func! Yaml_MvNextLineStart()
  normal! m'
  normal! j^
  call Md_SkipLinePrefix()
endfunc

" ─^  Buffer Maps                                        ▲


" ─   Motions                                            ■

" <c-n>/<c-p>: top-level keys + section nodes + named list items
" - branch 1: top-level key at col 0 (canvas:, remnant:)
" - branch 2: indented key preceded by blank line (knot:, veils:) - skips properties like fragment:
" - branch 3: list items with 'id' key (- id: siren); \zs at 'id', not '-'
let g:Yaml_MainStartPattern = '\(^\S[^:# \t]*:\|\n\s*\n\s\+\zs\w[^:# \t]*:\|\s*-\s\+\zsid:\)'

" <leader><c-n>/<c-p>: top-level keys only (canvas:, ambient:, nodes:)
let g:Yaml_TopLevelPattern = '^\S[^:# \t]*:'


func! Yaml_MainStartForw()
  " $ moves to end of current line so search finds the very next line's match
  " (jj would skip lines directly following the current match, e.g. ambient: -> - id:)
  normal! $
  call search( g:Yaml_MainStartPattern, 'W' )
  call ScrollUpFromMiddle( 7 )
endfunc

func! Yaml_MainStartBackw()
  " 0 moves to col 1 so search skips the match on current line (without jj two-step)
  normal! 0
  call search( g:Yaml_MainStartPattern, 'bW' )
  call ScrollUpFromMiddle( 7 )
endfunc

func! Yaml_TopLevForw()
  normal! $
  call search( g:Yaml_TopLevelPattern, 'W' )
endfunc

func! Yaml_TopLevBackw()
  normal! 0
  call search( g:Yaml_TopLevelPattern, 'bW' )
endfunc

" ─^  Motions                                            ▲


" ─   Column navigation                                  ■

" I/Y: jump between key name | value start | comment text
"   (1) :\s*\zs\S              - value: first non-space after ':'
"   (2) #\s*\zs\S              - comment text: first non-space after '#'
"   (3) ^\s*\(-\s\+\)\?\zs\w  - key name: first word char, skipping '- ' list marker
"
" Forward sequence on '    start-delay: 0    # plays immediately':
"   I -> 'start-delay'  I -> '0'  I -> 'plays'  I -> key on next line
"
" Uses Yaml_SearchSkipStr (not SearchSkipSC) so:
"   - '#' inside "quoted strings" like "#00cc66" is skipped  (string context)
"   - '#' starting a yaml comment is NOT skipped             (comment context is allowed)
let g:Yaml_columnPttn = '\(:\s*\zs\S\|#\s*\zs\S\|^\s*\(-\s\+\)\?\zs\w\)'

func! Yaml_SearchSkipStr( pttn, flags )
  let mtch = search( a:pttn, a:flags )
  if mtch && synIDattr(synID(line('.'), col('.'), 1), 'name') =~? 'string'
    call Yaml_SearchSkipStr( a:pttn, a:flags )
  endif
endfunc

func! Yaml_ColumnForw()
  call Yaml_SearchSkipStr( g:Yaml_columnPttn, 'W' )
endfunc

func! Yaml_ColumnBackw()
  normal! h
  call Yaml_SearchSkipStr( g:Yaml_columnPttn, 'bW' )
endfunc

" ─^  Column navigation                                  ▲
