
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
  " call matchadd('CommentMinusMinus', '\v\zs\(', 11, -1)
  " call matchadd('CommentMinusMinus', '\v\zs\)', 11, -1)

  " ─   Comment markup                                     ■
  " Define comment syntax first with higher priority
  syntax region Comment start="#" end="$" contains=BoldComment,ItalicComment,BlackBG keepend
  " This is effective in preventing the conceal unicode in normal comments
  " syntax match Comment '\v#\s\zs.*' contains=BoldComment,ItalicComment
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

  syntax match String '\v\"[^"]+\"'
  syntax match Conceal '\"' contained containedin=String conceal

  " New type get a default highlight of Indentifier. This will be overridded in the coming lines in case we know the base type entity, relation or attribute.
  syntax match Identifier '[a-zA-Z0-9_-]\+\ze\ssub\s'

  syntax match TdbEntity '^entity\s\zs[a-zA-Z0-9_-]\+'
  syntax match TdbEntity 'isa\s\zs[a-zA-Z0-9_-]\+'
  syntax match TdbEntity '[a-zA-Z0-9_-]\+\ze\ssub\sentity'
  syntax match TdbEntity '[a-zA-Z0-9_-]\+\ze\splays\s'

  " syntax match TdbRelation '^relation\s\zs[a-zA-Z0-9_-]\+'
  syntax match TdbRelation '[a-zA-Z0-9_-]\+\ze\ssub\srelation'
  syntax match TdbRelation '[a-zA-Z0-9_-]\+\ze\:\w'
  syntax match TdbRelation '[a-zA-Z0-9_-]\+\ze\s*('
  syntax match TdbRelationRole '\:\zs[a-zA-Z0-9_-]\+'
  syntax match TdbRelationRole '(\s*\zs[a-zA-Z0-9_-]\+\ze\s*:'
  syntax match TdbRelationRole ',\s*\zs[a-zA-Z0-9_-]\+\ze\s*:'

  " Variables starting with $
  syntax match TdbVar '\$[a-zA-Z0-9_-]\+' contains=TdbVariableDollar
  syntax match TdbVariableDollar '\$' contained conceal

  " Numbers
  syntax match Number '\<\d\+\>'
  syntax match Number '\<\d\+\.\d\+\>'

  " syntax match ItalicComment 'datetime'

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
  syntax match TdbOwns '\<\(owns\|has\)\>' nextgroup=TdbAttribute skipwhite conceal cchar=⬥
  syntax match TdbAttribute '[a-zA-Z0-9_-]\+' contained

  syntax match TdbEntityWord '\<\(entity\|isa\)\>' nextgroup=TdbEntity skipwhite conceal cchar=▢
  syntax match TdbRelationWord '\<relation\>' nextgroup=TdbRelation skipwhite conceal cchar=⊃
  syntax match TdbRelation '[a-zA-Z0-9_-]\+' contained

  syntax match TdbAttributeWord '\<attribute\>' nextgroup=TdbAttribute skipwhite conceal cchar=⬥


  " syn keyword typeqlKeyword    match get fetch define undefine insert delete
  " syn keyword typeqlKeyword    rule offset limit sort asc desc
  " syn keyword typeqlDate    datetime


  " ─   Keyword conceals                                   ■

  " syntax match Normal 'match' conceal cchar=❙
  syntax match Normal 'match' conceal cchar=❙
  syntax match Normal 'select' conceal cchar=▣
  syntax match Normal 'insert' conceal cchar=◢
  syntax match Normal 'update' conceal cchar=◪
  syntax match Normal 'put' conceal cchar=▼
  syntax match Normal 'delete' conceal cchar=◙
  syntax match Normal 'fetch' conceal cchar=↑
  syntax match Normal 'reduce' conceal cchar=▬
  syntax match Normal 'groupby' conceal cchar=⊔
  syntax match Normal "label\ze\s" conceal cchar=◆

  syntax match Normal "\s\zslet\ze\s" conceal cchar=𝇊
  syntax match Normal "\s\zswith\ze\s" conceal cchar=𝇊
  syntax match Normal "fun\ze\s" conceal cchar=→
  syntax match Normal "return" conceal cchar=▂

  syntax match Normal 'like\ze\s' conceal cchar=≈
  syntax match Normal 'and' conceal cchar=&
  syntax match Normal '\s\zsor\ze\s' conceal cchar=‖

  " syntax match Normal 'sub' conceal cchar=⟀
  syntax match Normal 'sub\ze\s' conceal cchar=󰁂
  syntax match Normal 'plays\ze\s' conceal cchar=
  " syntax match Normal 'entity' conceal cchar=▢
  " syntax match Normal 'relation' conceal cchar=⊃ 

  syntax match Normal '@card' conceal cchar=⁝ 
  syntax match Normal '@key' conceal cchar=✱
  syntax match Normal '@unique' conceal cchar=Ⲵ
  syntax match Normal '@regex' conceal cchar=⋳
  syntax match Normal '@abstract' conceal cchar=◈
  syntax match Normal '@independent' conceal cchar=∪

  syntax match Normal 'datetime' conceal cchar=⏲

  " syntax match Normal 'relates' conceal cchar=🡲 
  " syntax match Normal 'attribute' conceal cchar=⬥ 
  " see above
  " syntax match Normal 'owns' conceal cchar=◦ 

  syntax match Normal '\s\zsas\ze\s' conceal cchar=« 
  syntax match Normal 'value' conceal cchar=⫐ 
  syntax match Normal 'abstract' conceal cchar=◈ 
  syntax match Normal 'boolean' conceal cchar=B 
  syntax match Normal 'string' conceal cchar=S 
  syntax match Normal 'integer' conceal cchar=I 
  syntax match Normal 'double' conceal cchar=I 


  " ─^  Keyword conceals                                   ▲



  set conceallevel=2 " ■
  set concealcursor=ni " ▲


  set foldmethod=marker

  set commentstring=\#%s

  " Auto-continue comments on new lines
  setlocal formatoptions+=ro           
  setlocal comments=:#
  
  " Set up custom indentation for TypeQL
  setlocal autoindent
  setlocal smartindent
  setlocal indentexpr=TypeQLIndentExpr()
  setlocal indentkeys=o,O,*<Return>,<>>,{,},0#,!^F
  
  function! TypeQLIndentExpr()
    let prev_line = getline(v:lnum - 1)
    let curr_line = getline(v:lnum)
    let prev_indent = indent(v:lnum - 1)
    
    " Skip empty lines - find the last non-empty line
    if prev_line =~ '^\s*$'
      let lnum = v:lnum - 2
      while lnum > 0 && getline(lnum) =~ '^\s*$'
        let lnum = lnum - 1
      endwhile
      if lnum > 0
        let prev_line = getline(lnum)
        let prev_indent = indent(lnum)
      endif
    endif
    
    " If previous line is a comment, maintain same indentation
    if prev_line =~ '^\s*#'
      return prev_indent
    endif
    
    " If previous line is a TypeQL keyword alone, indent the following lines
    if prev_line =~ '^\s*\(match\|insert\|define\|update\|delete\|fetch\|get\|rule\|when\|then\)\s*$'
      return prev_indent + &shiftwidth
    endif
    
    " If previous line ends with comma OR semicolon, maintain current indentation
    " This ensures continuation lines stay aligned
    if prev_line =~ '[,;]\s*$' && prev_indent > 0
      return prev_indent
    endif
    
    " If current line starts with a closing bracket, decrease indent
    if curr_line =~ '^\s*[}\])]'
      return prev_indent - &shiftwidth
    endif
    
    " If previous line opens a bracket, increase indent
    if prev_line =~ '[{\[(]\s*$'
      return prev_indent + &shiftwidth
    endif
    
    " If we're in an indented block, maintain indentation
    " unless current line starts a new top-level statement
    if prev_indent > 0
      " Check if current line starts a new top-level statement
      if curr_line =~ '^\s*\(match\|insert\|define\|update\|delete\|fetch\|get\|rule\)\s*$'
        return 0
      endif
      " Otherwise maintain the indentation
      return prev_indent
    endif
    
    " Default: start at beginning of line
    return 0
  endfunction                 

  " CodeMarkup Header
  syntax match BlackBG '\v─\s.*' contained
  syntax match BlackBG '\v─\^.*' contained

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
    HiLink typeqlDate          ItalicComment
    HiLink typeqlString        String
    HiLink typeqlVariable      Identifier
    
    " Define bold style for comments with asterisks
    hi BoldComment gui=bold guifg=#48666b
    hi ItalicComment gui=italic guifg=#54757D

    delcommand HiLink
  endif


endfunc " ▲

