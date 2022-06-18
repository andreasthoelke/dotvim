
func! JsonConfKey( confFile, key )
  let fileStr = join( readfile( a:confFile ) )
  let confDict = json_decode( fileStr )
  if !has_key( confDict, a:key )
    return ''
  endif
  return confDict[ a:key ]
endfunc
" echo JsonConfKey( 'package.json', 'scripts' )
" echo JsonConfKey( 'bsconfig.json', 'suffix' )


func! JsonAddToKey( confFile, key )
  let fileStr = join( readfile( a:confFile ) )
  let confDict = json_decode( fileStr )
  if !has_key( confDict, a:key )
    return ''
  endif
  let confDict.test = "hi there"
  " return confDict
  " return string( json_encode( confDict ) )
  " return json_encode( confDict )
  let confJson = json_encode( confDict )
  call writefile( [confJson], a:confFile )
endfunc

" echo JsonAddToKey( '/Users/at/Documents/UI-Dev/rescript/setup-tests/b_vite_react/bsconfig_test.json', 'suffix' )


command! -nargs=* ConfAdd call JsonAppendToKey(<f-args>)
" When executed as: > :Mycmd arg1 arg2
" This will invoke: > :call Myfunc("arg1","arg2")
" Example:
" ConfAdd bsconfig.json bs-dependencies @rescriptbr/ancestor
" call JsonAppendToKey( "Test4.json", "bs-dependencies", "hi there" )
" ~/Documents/UI-Dev/rescript/setup-tests/b_vite_react/bsconfig.json#/"@rescriptbr/ancestor",

func! JsonAppendToKey( filePath, key, value )
  let ls = []
  let ls = add(ls, 'const editJsonFile = require("edit-json-file");')
  let ls = add(ls, 'const filePath = "' . a:filePath . '";')
  let ls = add(ls, 'let file = editJsonFile(filePath);')
  " let ls = add(ls, 'file.append("bs-dependencies", "abcd1");')
  let ls = add(ls, 'file.append("' . a:key . '", "' . a:value . '");')

  " TODO: optionally set a value
  " let ls = add(ls, 'file.set("suffix", "aabbc2");')
  " let ls = add(ls, 'file.set("' . a:key . '", "' . a:value . '");')

  let ls = add(ls, 'file.save();')
  let ls = add(ls, 'console.log( file.get() )')

  " Create scratch folder if needed
  let targetFolder = getcwd() . '/scratch'
  if !isdirectory( targetFolder ) | call mkdir( targetFolder, 'p' ) | endif
  let scriptPath = targetFolder . '/.modJson.js'

  call writefile( ls, scriptPath )
  let cmd = 'node ' . scriptPath
 call System_Float( cmd )

endfunc
" call Abc()

func! NpmInstallPackage( packageName )
  let cmd = T_GetPackageInstallCmdOfCurrentProject() . ' ' . a:packageName
  call T_RunJob( cmd, 'visible' )
endfunc
" call NpmInstallPackage( 'edit-json-file' )













