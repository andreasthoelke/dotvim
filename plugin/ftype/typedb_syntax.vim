
" Note I deactivated the default typedb syntax highlight plugin:
" ~/.config/nvim/plugged/typeql.vim/syntax/typeql.vim

func! TypeQLSyntaxAdditions() " ■
  setlocal iskeyword+=-

  call clearmatches()
  set syntax=typeql
  set filetype=typeql

  " Dim end of line / end of statement separators.
  call matchadd('CommentMinusMinus', '\v\zs,', 11, -1)
  call matchadd('CommentMinusMinus', '\v\zs;', 11, -1)
  call matchadd('CommentMinusMinus', '\v\zs:', 11, -1)

  " ─   Comment markup                                     ■
  " This is effective in preventing the conceal unicode in normal comments
  syntax match Comment '\v#\s\zs.*' contains=BoldComment,ItalicComment
  " IMPORTANT: this line would prevent the above effect!
  " syntax match Normal "\#\s" conceal

  " Bold text within comments (text wrapped with asterisks)
  syntax match BoldComment '\v\*[^*]+\*' contained
  syntax match Conceal '\*' contained containedin=BoldComment conceal
  " Italic text within quotes (text wrapped with ")
  syntax match ItalicComment '\v\"[^"]+\"' contained
  " syntax match Conceal '\"' contained containedin=ItalicComment conceal

  " IMPORTANT: Only matchadd can coneal the comment chars when those are already match by the above syntax match!
  call matchadd('Conceal', '\#\s', 12, -1, {'conceal': ''})

  " ─^  Comment markup                                     ▲

  " New type get a default highlight of Indentifier. This will be overridded in the coming lines in case we know the base type entity, relation or attribute.
  syntax match Identifier '[a-zA-Z0-9_-]\+\ze\ssub\s'

  " This was the only way to match Identifiers that include "-" / dashes.
  syntax match TdbEntity '[a-zA-Z0-9_-]\+\ze\ssub\sentity'
  syntax match TdbEntity '[a-zA-Z0-9_-]\+\ze\splays\s'

  syntax match TdbRelation '[a-zA-Z0-9_-]\+\ze\ssub\srelation'
  syntax match TdbRelation '[a-zA-Z0-9_-]\+\ze\:\w'
  syntax match TdbRelationRole '\:\zs[a-zA-Z0-9_-]\+'

  " EXAMPLE:
  " commit sub relation,
  "   relates repository,
  syntax match TdbEntity '\<relates\>' nextgroup=TdbEntity skipwhite conceal cchar=🡲
  syntax match TdbEntity '[a-zA-Z0-9_-]\+' contained

  " EXAMPLE: user owns username;
  syntax match TdbEntity '[a-zA-Z0-9_-]\+\ze\sowns'
  " Note that we don't know if the attribute is owned by an entity, it's perhaps more common. also rate to have a one
  " line statement like this: user owns username;
  " EXAMPLE:
  " user sub entity,
  "   owns username,
  syntax match TdbOwns '\<owns\>' nextgroup=TdbAttribute skipwhite conceal cchar=☼
  syntax match TdbAttribute '[a-zA-Z0-9_-]\+' contained



  " ─   Other keywords                                    ──
  syn keyword typeqlKeyword    match get fetch define undefine insert delete
  syn keyword typeqlKeyword    rule offset limit sort asc desc


  " ─   Keyword conceals                                   ■

  " syntax match Normal 'sub' conceal cchar=⟀
  syntax match Normal 'sub\ze\s' conceal cchar=󰁂
  syntax match Normal 'plays\ze\s' conceal cchar=
  syntax match Normal 'entity' conceal cchar=
  syntax match Normal 'relation' conceal cchar=⪾ 
  " syntax match Normal 'relates' conceal cchar=🡲 
  syntax match Normal 'attribute' conceal cchar=● 
  " see above
  " syntax match Normal 'owns' conceal cchar=☼ 

  syntax match Normal 'as\ze\s' conceal cchar=« 
  syntax match Normal 'value' conceal cchar=⫐ 
  syntax match Normal 'abstract' conceal cchar=◈ 
  syntax match Normal 'boolean' conceal cchar=B 
  syntax match Normal 'string' conceal cchar=S 


  " ─^  Keyword conceals                                   ▲



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
    
    " Define bold style for comments with asterisks
    hi BoldComment gui=bold guifg=#48666b
    hi ItalicComment gui=italic guifg=#54757D

    delcommand HiLink
  endif


endfunc " ▲

