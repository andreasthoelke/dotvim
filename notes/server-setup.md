
a simple reproduceable setup

# typescript
# graphql
# edgedb

set syntax=zsh
set syntax=vim

pwd # use gwt on this line (from the start)
ls # make sure you are in the parent folder
mkdir c_gql_edb # create your project folder
_ # set global project root to the new folder \v then leader cdg
pwd # should now be /Users/at/Documents/Server-Dev/c_gql_edb
mkdir src
touch src/eins src/zwei drei vier

yarn init --yes # create a package.json
pnpm init

node --version # 16 is fine.

pnpm add -D typescript @types/node ts-node
pnpm add -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
pnpm add -D tslib@latest # just for import helpers?

# .gitignore
wget https://raw.githubusercontent.com/metachris/typescript-boilerplate/master/.gitignore

# tsconfig
wget https://gist.githubusercontent.com/mtimbs/0eaf27df08cff8f4ca4303de60bf617b/raw/b0e40b4d4445329768e8697b64ebb4e426284322/tsconfig.json
wget https://raw.githubusercontent.com/metachris/typescript-boilerplate/master/tsconfig.json

# eslintrc # https://www.metachris.com/2021/04/starting-a-typescript-project-in-2021/
wget https://raw.githubusercontent.com/metachris/typescript-boilerplate/master/.eslintrc.js

collecting custom settings here: ~/Documents/Server-Dev/c_gql_edb/.eslintrc.js#/rules.%20{
TODO: make this file (in a repo?) the template for new projects.

# git
git init
git add .
git commit -am "initial commit"

# esbuild (?)
pnpm add -D esbuild

# a demo main.ts file
wget -c https://raw.githubusercontent.com/metachris/typescript-boilerplate/master/src/main.ts -O src/main.ts

# basic test call
call append('.', T_NodeFunctionCall_TermCmd( './src/main.ts', 'delayed' ))
npx ts-node -T -e 'require("./src/main.ts").delayed()'

# test a rambda list call with arg
pnpm add -D rambda
pnpm add -D lodash @types/lodash
use leader s} to run these lines to insert the test lines into main.ts
call T_InsertLineAt( './src/main.ts', '', 0 )
call T_InsertLineAt( './src/main.ts', 'export const list = (n: number) => console.log( range(1, n + 1) )', 1 )
call T_InsertLineAt( './src/main.ts', '', 0 )
call T_InsertLineAt( './src/main.ts', "import { range } from 'rambda'", 1 )

Run the test (should show 1..12)
npx ts-node -T -e 'require("./src/main.ts").list(12)'

# Initialize the testServer files
vim: gs .. then initialize and install packages

This uses the following template snapshot:
echo g:testServerDefaultFiles
Can be set like this:
let g:testServerDefaultFiles = '/Users/at/Documents/Server-Dev/pothos/pothos/scratch/snapshot_sdl1/'
The following files will be copied into ./scratch/
echo g:TesterFileNamesAll

also .env is initialized: ~/.config/nvim/plugin/tools_testServer.vim#/func.%20T_InitEnvFile..
Installing packages: ~/.config/nvim/plugin/tools_testServer.vim#/func.%20T_InitInstallPackages..

## Tests
gss - show shema
gsa - server start
gse - client fetch
gsd - gql-exec

## Summarize multiple commands in an .sh script
/Users/at/Documents/UI-Dev/rescript/setup-tests/relay/graphql-client-example-server/prepareForPublish.sh

# Lsp diagnostics
This should show no error, just some type warnings
Trouble workspace_diagnostics

# GQL examples ./scratch/.testsDefault.ts
leader P or <c-w>f on this path: ./scratch/.testsDefault.ts

Go through these examples and test DB with gsi and mark schema, query, variables with gsi. the run gsr/ gse.
~/Documents/Server-Dev/c_gql_edb/scratch/.testsDefault.ts#///%20Code%20first
~/Documents/Server-Dev/c_gql_edb/scratch/.testsDefault.ts#///%20Pothos%20Simple
use leader glC to explore in GraphiQl
## change the server and port
in ./.env

# Copy a sub-folder from another project
cp -r /Users/at/Documents/Server-Dev/pothos/pothos/examples/relay-windowed-pagination/src/ ./src/pagination-data-example
note that adding a "/" to the source folder copies only the contents (not the folder itself) so you can create a new (renamed) folder at the target

## Install missing package
pnpm add -D @pothos/plugin-relay
This seems needed for type errors to update:
LspRestart

# fp-ts
pnpm add fp-ts
src/fp-ts-examples/











