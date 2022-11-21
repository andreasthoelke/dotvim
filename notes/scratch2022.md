
# Scala references with Trouble
ged  - show workspace errors
ge]/[ - next/prev error
ger   - show references of symbol under cursor
]q [q - next/prev reference in workspace

# Scala Printer

## SBT support
1. needs this printer file as Main
    fpcourse/
    src/main/scala/Main.scala

`gew` `gee` this then namspace imports the indentif into Main/Printer

2. start the sbt terminal with `space ro`

`gei` does `runMain Printer`

interactive programms can be seen in the running terminal

## Scala-cli support

1. needs this printer file as Printer.scala
     /Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/scala-cli-zio1/Printer.scala
   in the same folder as the source file
     /Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/scala-cli-zio1/a_effects.scala

`gew` `gee` again just imports the identif into the Printer.scala

`gei` does `scala-cli .`
`space gei` does `scala-cli .` in a new/temp terminal




npx vite
http://localhost:3000
http://localhost:4040/graphql
npx rescript build -w

Todos:
~/.config/nvim/help.md#/###%20TODO.%20nvim-treesitter-rescript

# Scratch
git add *
degit https://github.com/hayes/pothos

type Tags
are just arrays on Posts .. not connections

use the Comment implement (not the node) version
the add a custom Node type to the interface [Node]

i might make manually unique string ids in data.ts.


## Vim to learn

space ]t  - bracket end forward
leader leader ]t   - BufferInnerBracket()
space os - open scratch file in float
space ob - search for bookmarks

new js/ts 'yank around {} block' map: y<leader>ab

space s; - strip semicolon .. and the af/ap/,j

gsw - sets a test-printer expression in /scratch/.testPrinter.ts
gsp - prints/call this (exported) identifier (cursor can be in a different place)


sp qa - add cursor pos to quickfix list
leader qq - toggle quickfix list

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







