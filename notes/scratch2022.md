

let e1_dummyName = Belt.Array.range( 1, 4 )
  -> Js.Array2.map( i => i
    -> i => {i + 1}
    -> show
    -> Js.String2.concat( "name", _ )
    -> i => {i ++ "x"}
    -> React.string
  )
  -> React.array



# Scratch

type Tags
are just arrays on Posts .. not connections

use the Comment implement (not the node) version
the add a custom Node type to the interface [Node]

i might make manually unique string ids in data.ts.




## Vim to learn

### Lsp
sp ca - code action
gti   - import identifier under cursor
~/.config/nvim/plugin/setup-lsp.lua#/buf_map.bufnr,%20"n",%20"gts",
https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils

### Quick floats
sp os - scratch
sp ol - links
sp ob - vim bookmarks

gdo - go to definition in float

npx edgedb-js
save in other folder
connect to dracula and instance?







