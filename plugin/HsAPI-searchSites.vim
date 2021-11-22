
" Search for documentation, help, code excepts/usages
" in the context you are in/ not break the flow

" All search params are optional - could send an empty object {} to show the search sites main page (without actually running a query)
let g:exampleSearchParams =
      \{'mainTerm':   'fmap'
      \,'identifier': '<*>'
      \,'type':       'Maybe a'
      \,'module':     'Control.Applicative'
      \,'package':    'async-2.2.1'
      \,'language':   'Haskell'
      \}
" include also ranges of packages, repos, folders on disk?

" Stages:
" 1. Gather context info
" 2. Let user edit search params
" 3. Select (a list of) search services
" 4. Map search params to services and run query
" 5. Display/ open results

" Ideas:
" Collections of pages: BrowserSearch could look for a 'pages'/'collection' key and run/open multiple results
" Search only in current package sets using: echo pyeval('getHSPackageDependencies()')


func! GetSearchParams( mode, ...)
  let userStr = SearchPropsUserStr( a:mode )
  return ParseSearchParams( a:0 ? input(a:1, userStr) : userStr )
endfunc
" echom string( GetSearchParams('visual', 'Search props: ') )
" Control.Applicative fmap ::
" cursor on 'fmap' will return:
" {'module': 'Control.Applicative', 'language': 'vim', 'identifier': 'fmap', 'package': 'async-'}

func! GetInputStr( userPrompt, ...)
  let initStr = a:0 == 1 ? GetVisSel() : HsCursorKeyword()
  return input( a:userPrompt, initStr )
endfunc
nnoremap <leader>tti :echoe GetInputStr('Search keyword: ')<cr>
vnoremap <leader>tti :<c-u>echoe GetInputStr('Search term: ', 'v')<cr>

" Issue: This labels the last sub-module as 'identifier'
func! ParseModuleIdentifier( inStr ) " ■
  let items = split( a:inStr, '\a\zs\.' )
  if items[-1][0] =~ '\u' && len( items ) < 3
    " if len( items ) == 2 " Just two items and the last one uppercase. -> is pased as just a module
      return {'module': join( items, '.' )}
    " else
      " Assume the last item is a dataconstructor for now. If an explicit is available, then revert to interpret the entire string as a module
      " return {'module': join(items[:-2], '.')
      "       \, 'identifier': items[-1]}
    " endif
  else
    " If the last item is lowercase or an infix/symbol char then parse it is identifier
    return {'module': join(items[:-2], '.')
        \, 'identifier': items[-1]}
  endif
endfunc
" echo ParseModuleIdentifier( 'Control.Applicative.Monoid' )
" echo ParseModuleIdentifier( 'Data.ByteString.Lazy.Char8' )
" echo ParseModuleIdentifier( 'Control.Applicative.Just' )
" echo ParseModuleIdentifier( 'Data.Monoid.Sum' )
" echo ParseModuleIdentifier( 'Control.Applicative.fmap' )
" echo ParseModuleIdentifier( 'Control.Applicative.(<*>)' )
" echo ParseModuleIdentifier( 'Control.Applicative.<*>' )
" echo ParseModuleIdentifier( 'Data.Eq.==' )
" echo ParseModuleIdentifier( 'Data.Eq.(.)' )
" echo ParseModuleIdentifier( 'Applicative.fmap' ) ▲

" The user can enter short version of params, this will be turned into a more complete 'search-props-dictionary'
func! ParseSearchParams( inStr )
  " Comma as a seperator is required when type-sigs are passed
  let inStrs = a:inStr =~ '\(\;\|->\)' ? split(a:inStr, '\;') : split(a:inStr)

  let searchParams = {}
  for item in inStrs
    if     item =~ '\s' "    Type (only types can contains spaces!)
      call extend( searchParams, {'type': item} )

    elseif item[0] =~ '\A' " Identifier (starts with a non-alphabetic char)
      call extend( searchParams, {'identifier': item} )

    elseif item =~ '\i\.'  " Module or qualified identifier
      call extend( searchParams, ParseModuleIdentifier( item ) ) " Adds 'module' and maybe 'identifier'
      " let itemQualifiedBackup = copy( item )

    elseif item =~ '-' "     Package (user needs to add '-' to package name with no version)
      if LastChar(item) == '-'
        let item = CropLastChar(item)
      endif
      call extend( searchParams, {'package': item} )

    elseif item =~ 'haskell\|vim\|purescript\|markdown\|javascript' " Language
      call extend( searchParams, {'language': item} )

    elseif item[0] =~ '\u' " Identifier (a dataconstructor e.g. Just)
      call extend( searchParams, {'identifier': item} )

    elseif item[0] =~ '\U' " a normal identifier
      call extend( searchParams, {'identifier': item} )

    else
      echoe "Unsupported item in ParseSearchParams: " . item
    endif
  endfor
  return searchParams
endfunc
" echo ParseSearchParams( 'Control.Applicative fmap async- Haskell' )
" echo ParseSearchParams( 'Data.ByteString.Lazy.Char8 Haskell' )
" echo ParseSearchParams( 'Maybe (a -> b) -> Maybe b -> Maybe a;Haskell' )
" echo ParseSearchParams( 'Maybe b -> Maybe a' )

" Gather cursor keyword/module and language in a space separated string
func! SearchPropsUserStr( mode )
  if a:mode == 'visual'
    let inStr = GetVisSel()
    if inStr =~ '\s' " Type (only types can contains spaces!)
      let str1 = inStr .';' " use semicollon instead of space in case types are used
    else
      let str1 = ParseModuleIdentifier( inStr ) " this may be a selected part of a Data.Module.identifier
    endif
  else
    let modIdentif = ParseModuleIdentifier( HsCursorKeyword_findModule() )
    let str1 = get(modIdentif,'module','') .' '. get(modIdentif,'identifier','')
  endif

  let lang = GetLanguageByCurrentFileExtension()
  return str1 . ' ' . lang
endfunc
" Tests:
vnoremap <leader><leader>cc :<c-u>echo SearchPropsUserStr('visual')<cr>
nnoremap <leader><leader>cc :echo SearchPropsUserStr('n')<cr>
nnoremap <leader><leader>cb :echo GetSearchParams('n')<cr>



let g:choicesTest2 = [{'label':'_Google', 'url':'http://www.google.de/search?q='}, {'section':'Local search:'}, {'label':'_In Hask dir', 'comm':'Fhask'}]

              "                      ( userPromptText,      optUserPromtValue_andFirstArg,    choices,       continuationFn,          contOtherArgs,          [winPos] ... )
nnoremap gso :call UserChoiceAction( 'Run query on site', GetSearchParams('n'),                  g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>
nnoremap gsO :call UserChoiceAction( 'Run query on site', GetSearchParams('n', 'Search params: '), g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>

vnoremap gso :<c-u>call UserChoiceAction( 'Run query on site', GetSearchParams('visual'),        g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>
vnoremap gsO :<c-u>call UserChoiceAction( 'Run query on site', GetSearchParams('visual', 'Search params: '), g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>

nnoremap <leader>tta :call UserChoiceAction( 'Please select one: ', {}, g:choicesTest1, function('TestUserChoice1'), [] )<cr>
nnoremap <leader>ttb :call UserChoiceAction( 'Search ..', {'eins':expand("<cword>")}, g:choicesTest2, function('TestUserChoiceSearch'), [v:true] )<cr>


" TODO temp purescript version
nnoremap gso :call UserChoiceAction( 'Run query on site', {'identifier': HsCursorKeyword()},                  g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>
nnoremap gsO :call UserChoiceAction( 'Run query on site', {'identifier': GetInputStr('Search term: ')},                  g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>
vnoremap gso :<c-u>call UserChoiceAction( 'Run query on site', {'identifier': GetVisSel()},        g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>
vnoremap gsO :<c-u>call UserChoiceAction( 'Run query on site', {'identifier': GetInputStr('Search term: ')},        g:searchSites, 'RunSearch', [{'browser':'default'}] )<cr>


" ─   Search Params                                     ──
" 'mainTerm':   'fmap'
" 'identifier': '<*>'
" 'type':       'Maybe a'
" 'module':     'Control.Applicative'
" 'package':    'async-2.2.1'
" 'language':   'Haskell'
" ─   Site Props                                        ──
" baseUrl
" module_mainTerm
" language
" package
" module
" options

" siteProps are selected via UserChoiceAction
" searchParams are the first (user shown) arg of this/the contiuation function (second arg of UserChoiceAction)
func! RunSearch ( searchParams, browser, siteProps )
  let mainTermQuery = ''
  let packageQuery = ''
  let languageQuery = ''
  let moduleQuery = ''
  let optionsQuery = ''

  " echo a:searchParams

  if has_key(a:siteProps, 'mainTerm')
    let mainTermQuery .= a:siteProps.mainTerm
  elseif has_key(a:siteProps, 'module_mainTerm')
    let mainTermQuery .= a:siteProps.module_mainTerm
  endif

  " Module: Use module searchParams in moduleQueryField if site provides.
  " Else if there's a module_mainTerm options (the site allows to search for module-qualified identifiers) then prepend with a "."
  " Else prepend to mainTerm with a space
  if has_key(a:searchParams,'module')
    " We got Module info in the searchProps, now what to do with it?
    if has_key(a:siteProps,'module')
      " The selected site has a dedicated module -feature/filter, so write the module in the separate module query
      let moduleQuery = a:siteProps.module . a:searchParams.module
    elseif has_key(a:siteProps,'module_mainTerm')
      " The site is known to support module-qualified-identifiers e.g. "Data.Eq.(==)"
      let mainTermQuery .= a:searchParams.module
      if has_key(a:searchParams,'identifier') || has_key(a:searchParams,'type')
        let mainTermQuery .= '.'
      endif
    else
      let mainTermQuery .= a:searchParams.module
      if has_key(a:searchParams,'identifier') || has_key(a:searchParams,'type')
        let mainTermQuery .= ' '
      endif
    endif
  endif

  " Main Term:
  if has_key(a:searchParams,'mainTerm')
    let mainTermQuery .= a:searchParams.mainTerm " set initial mainTerm
    " Addition type/identifier: (rare?)
    if has_key(a:searchParams,'identifier')
      let mainTermQuery .= a:searchParams.identifier " add an additional identifier
    endif
    if has_key(a:searchParams,'type')
      let mainTermQuery .= a:searchParams.type " add an additional type
    endif
  else
    " Use identifier and/or type as mainQuery: (a combination of both should be rare?)
    if has_key(a:searchParams,'identifier')
      let mainTermQuery .= a:searchParams.identifier .'' " add identifier
    endif
    if has_key(a:searchParams,'type')
      let mainTermQuery .= a:searchParams.type " add type
    endif
  endif

  " echo mainTermQuery

  " Site Options: Any simple search options (not params) are currently simply set in the site.option definition (e.g.  github filters)
  if has_key(a:siteProps,'options')
    let optionsQuery .= a:siteProps.options
  endif

  " Package: Use packageSearchStr with dedicated packageQueryField if the site provides. Else, Package info is prepanded to the main query with a space.
  if has_key(a:searchParams,'package')
    if     has_key(a:siteProps,'package')
      let packageQuery = a:siteProps.package . a:searchParams.package " set/ overwrite packageQuery
    elseif has_key(a:siteProps,'mainTerm')
      let mainTermQuery = a:searchParams.package .' '. mainTermQuery " prepend to mainTermQuery
    else
      echo 'Note: PackageStr ' . a:searchParams.package . ' can not be used with ' . a:siteProps.label
    endif
  endif

  " Language: Language info is only used if the site has a specific language query field, it's ignored otherwise (e.g. redit/r/haskell will ignore the language string)
  if has_key(a:searchParams,'language')
    if has_key(a:siteProps,'language')
      let languageQuery = a:siteProps.language . a:searchParams.language
    endif
  endif


  let queryStr = packageQuery . moduleQuery . mainTermQuery . languageQuery . optionsQuery

  if has_key( a:siteProps, 'baseUrl' )
    exec '!open ' . shellescape( a:siteProps.baseUrl . queryStr )
  elseif has_key( a:choosenObjCmd, 'command' )
    exec a:siteProps.command . ' ' . queryStr
  endif
endfunc


" ─   Config Search Sites                               ──

let g:searchSites =  [ {'section':'Docs'} ]

" https://www.stackage.org/lts-14.1/hoogle?q=Data.Either.fromLeft
" module_mainTerm should join namespace and mainTerm via a '.' if both are provided
let g:searchSites += [ {'label':'_Stackage',   'baseUrl':'https://www.stackage.org/lts-14.1/'
      \, 'module_mainTerm':'hoogle?q='
      \}]

" https://hoogle.haskell.org/?hoogle=Data.Either.fromLeft&scope=package%3Aeither
let g:searchSites += [ {'label':'_Hoogle',     'baseUrl':'https://hoogle.haskell.org/'
      \, 'module_mainTerm':'?hoogle='
      \}]

" https://pursuit.purescript.org/search?q=fromLeft
" Pursuit can only search for a module namespace (Data.Either) *or* an identifier (e.g. fromLeft), not a combination of both
" So searching for a module has to use the 'mainTerm' field
let g:searchSites += [ {'label':'_Pursuit',    'baseUrl':'https://pursuit.purescript.org/'
      \, 'mainTerm':'search?q='
      \}]

" https://spacchetti.github.io/starsuit/#search:traverse
" Starsuit can only search for a module namespace (Data.Either) *or* an identifier (e.g. fromLeft), not a combination of both
let g:searchSites += [ {'label':'_T Starsuit Pursuit',    'baseUrl':'https://spacchetti.github.io/starsuit/'
      \, 'mainTerm':'\#search:'
      \}]

let g:searchSites += [ {'section':'Web help/ posts'} ]

" https://book.purescript.org/index.html?search=
let g:searchSites += [ {'label':'_Book Purscript',     'baseUrl':'https://book.purescript.org/index.html'
      \, 'mainTerm':'?search='
      \, 'language':'+'
      \}]

" https://jordanmartinez.github.io/purescript-jordans-reference-site/?search=
let g:searchSites += [ {'label':'_M Jordan Reference',     'baseUrl':'https://jordanmartinez.github.io/purescript-jordans-reference-site/'
      \, 'mainTerm':'?search='
      \, 'language':'+'
      \}]

" https://www.google.de/search?q=traverse+Haskell
" This usually features Stackoverflow
let g:searchSites += [ {'label':'_Google',     'baseUrl':'https://google.de/'
      \, 'mainTerm':'search?q='
      \, 'language':'+'
      \}]

" https://www.reddit.com/r/haskell/search/?q=Data.Either.fromLeft&restrict_sr=1
let g:searchSites += [ {'label':'_Redit Haskell', 'baseUrl':'https://www.reddit.com/r/haskell/'
      \, 'mainTerm':'search/?q='
      \, 'options':'&restrict_sr=1'
      \}]

" https://github.com/search?l=&q=traverse+language%3AHaskell&type=Code
" Can then switch to 'Repos', 'Issues', 'Wikis', ..
let g:searchSites += [ {'label':'Github code',     'baseUrl':'https://github.com/search?'
      \, 'mainTerm':'&q='
      \, 'language':'&l='
      \, 'options':'&type=Code'
      \}]

" Search in description of repo
" https://github.com/search?l=&q=traverse+language%3AHaskell&type=Repositories
let g:searchSites += [ {'label':'Github package (repo)',     'baseUrl':'https://github.com/search?'
      \, 'mainTerm':'&q='
      \, 'language':'&l='
      \, 'options':'&type=Repositories'
      \}]

" Search in Github issues
" https://github.com/search?l=&q=traverse+language%3AHaskell&type=Repositories
let g:searchSites += [ {'label':'Github issues',     'baseUrl':'https://github.com/search?'
      \, 'mainTerm':'&q='
      \, 'language':'&l='
      \, 'options':'&type=Issues'
      \}]

" https://haskell-code-explorer.mfix.io/search/withAsync
" https://haskell-code-explorer.mfix.io/package/async-2.2.1/search/withAsync
let g:searchSites += [ {'label':'Hs Code Explorer (Hackage search + browse)'
      \, 'baseUrl':'https://haskell-code-explorer.mfix.io/'
      \, 'package':'package/'
      \, 'mainTerm':'search/'
      \}]

" https://codesearch.aelve.com/haskell/search?query=fromLeft&filter=Data.Either
let g:searchSites += [ {'label':'Aelve (Hackage code search)'
      \, 'baseUrl':'https://codesearch.aelve.com/haskell/'
      \, 'mainTerm':'search?query='
      \, 'module':'&filter='
      \}]



