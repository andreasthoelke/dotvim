
" http://learnvimscriptthehardway.stevelosh.com/chapters/39.html


function! functional#sorted(l)
  let new_list = deepcopy(a:l)
  call sort(new_list)
  return new_list
endfunction

function! functional#reversed(l)
  let new_list = deepcopy(a:l)
  call reverse(new_list)
  return new_list
endfunction

function! functional#append(l, val)
  let new_list = deepcopy(a:l)
  call add(new_list, a:val)
  return new_list
endfunction

function! functional#assoc(l, i, val)
  let new_list = deepcopy(a:l)
  let new_list[a:i] = a:val
  return new_list
endfunction

function! functional#pop(l, i)
  let new_list = deepcopy(a:l)
  call remove(new_list, a:i)
  return new_list
endfunction

func! functional#map(fn, list)
  let new_list = deepcopy( a:list )
  " return map(new_list, {_, x -> a:fn( x ) })
  return map(new_list, {_, x -> call( a:fn, [x]) })
endfunc
" echo functional#map( 'toupper', ['eins', 'zwei'] )
" echo functional#map( 'UppercaseFirstChar', ['eins', 'zwei'] )
" echo functional#map( {a -> a . 'aa'}, ['bb', 'aa', 'cc'])
" Could also use a separate function reference ■
" let Fn2 = {_, x -> a:fn( x ) }
" call map(new_list, Fn2) ▲

func! functional#filter(fn, l)
  let new_list = deepcopy(a:l)
  return filter(new_list, {_, x -> call( a:fn, [x] )} )
endfunc
" functional#filter( {x->x==3}, [2, 3, 4] )
" echo functional#filter( {x-> x isnot# 3}, [2, 3, 4] )
" echo functional#filter( {x-> x =~ 'e'}, ['eins', 'acht', 'zwei'] )
" functional#filter( {x-> x !~ 'e'}, ['eins', 'acht', 'zwei'] )
" functional#filter( {x-> x =~ '^e'}, ['eins', 'acht', 'zwei'] )

" foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
func! functional#foldr(fabb, initB, listA)
  let accum = copy( a:initB )
  for nextA in a:listA
    let accum = call( a:fabb, [nextA, accum] )
  endfor
  return accum
endfun
" functional#foldr( {a, b -> a + b}, 0, [2, 4, 6] )
" echo Foldr( {a, b -> ( a < 8) && b}, v:true, [2, 4, 6] )
" echo Foldr( {a, b -> ( a < 8) && b}, v:true, [2, 10, 6] )

func! functional#concat( listOfLists )
  return functional#foldr( {a, b -> a + b}, [], functional#reversed( a:listOfLists ) )
endfunc
" echo functional#concat( [[2, 3], [5, 6, 7], [11, 12]] )

func! functional#sum(list)
  return functional#foldr( {a,b->a+b}, 0, a:list )
endfunc
" functional#sum( [3, 4, 5] )

func! functional#find(list, str)
  for idx in range(0, len(a:list)-1)
    if a:list[idx] == a:str 
      return idx
    endif
  endfor
  return -1
endfunc
" functional#find(['eins', 'zwei', 'aber'], 'be')
" functional#find(['eins', 'zwei', 'aber'], 'eins')
" functional#find(['eins', 'zwei', 'aber'], 'ns')
" functional#find(['eins', 'zwei', 'aber'], 'bei')
" functional#find(['eins', 'zwei', 'aber'], 'be') != -1 ? 'yes' : 'no'
" functional#find(['eins', 'zwei', 'aber'], 'ns') != -1 ? 'yes' : 'no'
" functional#find(['eins', 'zwei', 'aber'], 'nsx') != -1 ? 'yes' : 'no'

" Accessing global vars:
" g:['x'] and g:x are equivalent
" get(g:, 'x', default)

" Get the first list elem and optional second elem
" let [folderPathTarget;_] = Filter( {path-> path isnot# folderPathSource}, TabWinFilenames() )


func! Id( a )
  return a:a
endfunc

" echo Id( 'hi there' )
" echo call( Comp( function('Id'), function('Id') ), ['ab'] )

func! Comp( f, g )
  return {x-> a:g( a:f(x) )}
endfunc

func! Plus2( num )
  return (num + 2)
endfunc

" Search each element of searchList in list. Log the index of list if an elem of searchList matches.
" Return a list of list indices that (whose values) where matched by an item in searchList.
func! FindList( list, searchList )
  let matchedIndices = []
  return functional#foldr( {searchStr, accumIndices -> add( accumIndices, functional#find( a:list, searchStr ) ) }, matchedIndices, a:searchList )
endfunc

" FindList( ['aa', 'bb', 'cc', 'dd'], ['dd', 'bb', 'aa'] )
" FindList( getline(0, "$"), ["endfunc", "func! FindList( list, searchList )"] )
















