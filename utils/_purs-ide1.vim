
function! T0()
  call PSCIDEtype('log', v:true)
  " call GetType(
	" \ a:ident,
	" \ a:filterModules,
	" \ { resp -> PSCIDEtypeCallback(a:ident, resp.result, a:filterModules) }
	" \ )
endfunction

function! T3()
  let l:id = 'log'
  let l:ft = v:true
  call GetType(
	\ l:id,
	\ l:ft,
	\ { resp -> PSCIDEtypeCallback(l:id, resp.result, l:ft) }
	\ )
endfunction


function! T5()
  return expand("%:p")
endfun

function! T4()
  return purescript#ide#import#listImports('Main', '', 'main')
endfun

function! T1()
  return items( purescript#ide#callSync( {'command': 'cwd'} , '', 0, ) )
endfunction

function! T11()
  return purescript#ide#callSync({'command': 'cwd'}, '', 0).result
endfunction

function! T2()
  return items( purescript#ide#callSync( {'command': 'type',
                                         \'params': {'search': 'hl0',
                                         \           'filters': [],
                                         \           'currentModule': 'Main'}, }, '', 0, ) )
endfunction


function! T6()
  return items( purescript#ide#callSync( {'command': 'type',
                                         \'params': {'search': 'true',
                                         \           'filters': [{"filter": "modules", "params": {"modules": ["Main", "Prim", "Prelude", "Control.Monad.Eff", "Control.Monad.Eff.Console"]}}],
                                         \           'currentModule': 'Main'}, }, '', 0, ) )
endfunction



function! Tes0()
  let l:resp = purescript#ide#callSync(
	\ {'command': 'list', 'params': {'type': 'availableModules'}} ,
	\ 'Failed to get loaded modules',
	\ 0
	\ )
  return items( l:resp )
endfunction


function! Tes1()
  let l:resp = purescript#ide#callSync(
	\ {'command': 'list', 'params': {'type': 'loadedModules'}},
	\ 'Failed to get loaded modules',
	\ 0
	\ )
  return l:resp
endfunction

let g:tf1 = '/Users/andreas.thoelke/Documents/purescript/hello1/src/Main.purs'

function! Tes2()
  let l:resp = purescript#ide#callSync(
	\ {'command': 'list', 
  \  'params': {'type': 'import',
  \             'file': g:tf1 }},
	\ 'Failed to get loaded modules',
	\ 0
	\ )
  return l:resp
endfunction
" ['result', {'moduleName': 'Main', 'imports': [{'module': 'Prelude', 'importType': 'implicit'}, {'module': 'Control.Monad.Eff', 'identifiers': ['Eff'], 'importType': 'explicit'}, {'module': 'Control.Monad.Eff.Console', 'identifiers': ['CONSOLE', 'log'], 'importType': 'explicit'}]}]
" ['resultType', 'success']
