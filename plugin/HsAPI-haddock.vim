
"  hoogle⁩ ▸ ⁨wai-router⁩ ▸ ⁨1.0.0.1⁩ ▸ ⁨doc⁩ ▸ ⁨html⁩wai-router.txt
" ⁨index⁩ ▸ ⁨wai-router⁩ ▸ ⁨1.0.0.1⁩wai-router.cabal

" echo readfile('.hackage/hoogle/wai-router/1.0.0.1/doc/html/wai-router.txt')
" put =readfile('.hackage/index/wai-router/1.0.0.0/wai-router.cabal')
" put =readfile('.hackage/index/wai-router/**/wai-router.cabal')
" put =globpath('.hackage/index/wai-router/**', 'wai-router.cabal')
" .hackage/index/wai-router/1.0.0.0/wai-router.cabal
" .hackage/index/wai-router/1.0.0.1/wai-router.cabal


" Get hoogle-doc or cabal file of package from the local .hackage folder
" Returns a list of lines
" uses the most recent local version
func! PackageDoc( type, packName )
  if a:type == 'hoogle'
    let extension = '.txt'
    let rootFolder = 'hoogle'
  elseif a:type == 'cabal'
    let extension = '.cabal'
    let rootFolder = 'index'
  endif

  let path  = '.hackage/' . rootFolder . '/' . a:packName . '/**'
  let files = split( globpath( path, a:packName . extension ), '\n' )
  return readfile( files[-1] )
endfunc
" put =PackageDoc( 'hoogle', 'wai-router' )
" put =PackageDoc( 'hoogle', 'wai-router' )
" put =PackageDoc( 'cabal', 'align' )
" put =PackageDoc( 'cabal', 'these' )

" Note: the .cabal file also has a 'exposed modules' field 

" Cabal can also query docs:
command! -nargs=1 CabalInfo call SystemCmdToScratchBuffer('cabal info ' . <args>)
" CabalInfo 'these-0.7.6'
" CabalInfo 'these'

" call SystemCmdToScratchBuffer('cabal info these-0.7.6')
" call StdoutToBuffer('cabal info these')
  " Data.Functor.These
  " Data.These
  " Data.These.Combinators
" call StdoutToBuffer('cabal info these-0.7.6')
  " Control.Monad.Chronicle
  " Control.Monad.Chronicle.Class
  " Control.Monad.Trans.Chronicle
  " Data.Align
  " Data.Align.Indexed
  " Data.Align.Key
  " Data.Functor.These
  " Data.These


" Get hoogle doc of specific version from hackage.org
" again as a list of lines like PackageDoc does
" python << EOF
" import requests
" def packageHoogleWebText( package, version ):
"     # Format query url e.g.: 'http://hackage.haskell.org/package/these-0.7.6/docs/these.txt'
"     baseUrl = 'http://hackage.haskell.org/package/'
"     packageAndVersion = package + '-' + version
"     docsPath = '/docs/' + package + '.txt'
"     response = requests.get( baseUrl + packageAndVersion + docsPath )
"     return( response.text )
" EOF
" call append('.', split( pyeval("packageHoogleWebText( 'these', '0.7.6' )"), '\n' ) )
" call ScratchWin_Show('these 7.6', split( pyeval("packageHoogleWebText( 'these', '0.7.6' )"), '\n' ) )

" Note: the hoogle file also provides the modules, just in different lines

" Search for any keywords in package description of hackage
" returns a list of package names
" python << EOF
" import requests
" import json
" def packageHoogleSearch( termsStr ):
"     response = requests.get('http://hackage.haskell.org/packages/search'
"       , params={'terms': termsStr}
"       , headers={'Accept': 'application/json'}
"       )
"     lobj = response.json()
"     resList  = [ dic[ 'name' ] for dic in lobj ]
"     return( resList )
" EOF
" call append('.', pyeval("packageHoogleSearch( 'wai' )")  )

" # data from github - author, description
" # align ? activate the bottom help
" # two sources package.yaml/installed packages and a search on github
" # both allow open github/hackage docs
" # allow install/uninstall from package.yaml
" # get the Modules and option to hoogle those?

" Feature idea:  quickly install /uninstall packages
" packageHoogleSearch to install
" - show on quickmenu?
" Notes this reads the package names (dependencies) of the current project
" ~/.vim/plugin/tools-external.vim#/def%20getHSPackageDependencies...

" Freature idea: mapping between Module and package
" might allow (parent-) module based browsing
" https://www.stackage.org/lts-14.4/docs

" ~/.hackage/modules.txt#/Data.These%20.these-1.0.1.

func! ModuleToPackage( module )

endfunc























" -

