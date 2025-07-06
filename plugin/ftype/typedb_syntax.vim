
" Note I deactivated the default typedb syntax highlight plugin:
" ~/.config/nvim/plugged/typeql.vim/syntax/typeql.vim

func! TypeQLSyntaxAdditions() " ■
  setlocal iskeyword+=-

  call clearmatches()
  set syntax=typeql

  " Dim end of line / end of statement separators.
  call matchadd('CommentMinusMinus', '\v\zs,', 11, -1)
  call matchadd('CommentMinusMinus', '\v\zs;', 11, -1)
  call matchadd('CommentMinusMinus', '\v\zs:', 11, -1)

  " This is effective in preventing the conceal unicode in normal comments
  syntax match CommentMinus '\v#\s\zs.*'
  " IMPORTANT: this line would prevent the above effect!
  " syntax match Normal "\#\s" conceal

  " IMPORTANT: Only matchadd can coneal the comment chars when those are already match by the above syntax match!
  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})

  " syntax match FunctionDec '\:\zs\w*'
  " This was the only way to match Identifiers that include "-" / dashes.
  syntax match ModeMsg '\:\zs[a-zA-Z0-9_-]\+'

  syntax match Identifier '[a-zA-Z0-9_-]\+\ze\:'
  syntax match Identifier '[a-zA-Z0-9_-]\+\ze\ssub\s'
  syntax match Identifier '[a-zA-Z0-9_-]\+\ze\splays\s'

  syntax match TdbEntity '[a-zA-Z0-9_-]\+\ze\ssub\sentity'
  syntax match TdbRelation '[a-zA-Z0-9_-]\+\ze\ssub\srelation'
  " syntax match ParamDec '[a-zA-Z0-9_-]\+\ze\ssub\sattribute'
  syntax match TdbAttribute '[a-zA-Z0-9_-]\+\ze\ssub\sattribute'

  syn keyword typeqlKeyword    match get fetch define undefine insert delete
  syn keyword typeqlKeyword    rule offset limit sort asc desc


  " ─   Keywords                                           ■

  " syntax match Normal 'sub' conceal cchar=⟀
  syntax match Normal 'sub\ze\s' conceal cchar=󰁂
  syntax match Normal 'plays\ze\s' conceal cchar=
  syntax match Normal 'entity' conceal cchar=
  syntax match Normal 'relation' conceal cchar=⪾ 
  syntax match Normal 'relates' conceal cchar=🡲 
  syntax match Normal 'attribute' conceal cchar=● 
  syntax match Normal 'owns' conceal cchar=☼ 

  syntax match Normal 'as\ze\s' conceal cchar=« 
  syntax match Normal 'value' conceal cchar=⫐ 
  syntax match Normal 'abstract' conceal cchar=◈ 
  syntax match Normal 'boolean' conceal cchar=B 
  syntax match Normal 'string' conceal cchar=S 

  " ─^  Keywords                                           ▲




  set conceallevel=2 " ■
  set concealcursor=ni " ▲


  set foldmethod=marker

  set commentstring=\#%s

  " CodeMarkup Header
  syntax match BlackBG '\v─\s.*'
  syntax match BlackBG '\v─\^.*'

  if version >= 508 || !exists("did_typeql_syn_inits")
    if version < 508
      let did_typeql_syn_inits = 1
      command -nargs=+ HiLink hi link <args>
    else
      command -nargs=+ HiLink hi def link <args>
    endif

    HiLink typeqlKeyword       Keyword
    HiLink typeqlComment       Comment
    HiLink typeqlOperator      Operator
    HiLink typeqlType          Type
    HiLink typeqlNumber        Number
    HiLink typeqlBoolean       Number
    HiLink typeqlDate          Number
    HiLink typeqlString        String
    HiLink typeqlVariable      Identifier

    delcommand HiLink
  endif


endfunc " ▲

