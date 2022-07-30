
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

~/Documents/Server-Dev/d_gql_edb/.eslintrc.js#/rules.%20{

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

pnpm --help
pnpm remove rambda
pnpm add ramda @types/ramda

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
cat .env # you may want to change server and port!

## Tests
gss - show shema
gsa - server start
gse - client fetch
gsd - gql-exec

## Summarize multiple commands in an .sh script
example config shell script: ~/Documents/Server-Dev/pg/a_pg_learn/server-setup.md#/##%20Config%20shell
read shell variables: ~/.config/nvim/plugin/tools-tab-status-lines.vim#/func.%20PyVimVirtualEnvExt%20..
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
also use leader yy, leader pp in dirvish to copy folders

## Install missing package
pnpm add -D @pothos/plugin-relay
This seems needed for type errors to update:
LspRestart

# fp-ts
pnpm add fp-ts
src/fp-ts-examples/

# PostgreSQL
/Users/at/Documents/Server-Dev/pg/a_pg_learn/

yarn add db-migrate db-migrate-pg
you can use psql to connect to the db!


# PostgreSQL installation
now using Postgres.app. not using homebrew.
  psql --help
  brew uninstall libpq
  brew services restart postgresql
  sudo mkdir -p /etc/paths.d &&
  echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp

## PostgreSQL settings
/Users/at/Library/Application Support/Postgres
postgresql.conf

/Users/at/Library/Application%20Support/Postgres/var-14/
~/Library/Application%20Support/Postgres/var-14/postgresql.conf#/#port%20=%205432

# Migration files
npx db-migrate create create-schema --sql-file
./migrations/20220718102738-create-schema.js

### up sql file at
./migrations/sqls/20220718102738-create-schema-up.sql

### down sql file at
./migrations/sqls/20220718102738-create-schema-down.sql
npx db-migrate up
npx db-migrate down
touch .db-migraterc
npx db-migrate create create-table-person

### card, response tables
npx db-migrate create create-table-card
npx db-migrate create create-table-response
npx db-migrate create create-function-score-response
npx db-migrate create create-function-handle-score

npx db-migrate up
npx db-migrate down

# SQLS lsp for sql
go install github.com/lighttiger2505/sqls@latest

vim plugin: https://github.com/nanotee/sqls.nvim

help sqls-nvim

coc-nvim config
~/.config/nvim/coc-settings.json#/"sql".%20{

/Users/at/.config/sqls/config.yml


# Postgraphile
Beginner course: https://www.youtube.com/watch?v=eDZO8z1qw3k&t=980s

yarn add postgraphile

## Config shell script
touch server.sh
chmod +x server.sh

npx postgraphile \
  -c postgres:///learn_dev \
  --schema learn

npx postgraphile -c postgres:///learn_dev --schema learn

./server.sh


## Plugins
yarn add @graphile-contrib/pg-simplify-inflector

# GraphQL queries
scratch/learn_dev.ts

http://localhost:4040/graphql

# Prisma example

/Users/at/Documents/Server-Dev/pothos/pothos-repo2/examples/prisma/

pnpm add @prisma/client prisma @pothos/plugin-prisma
yarn add @pothos/plugin-prisma

pnpm add node-fetch

## Commands
            init   Set up Prisma for your app
        generate   Generate artifacts (e.g. Prisma Client)
              db   Manage your database schema and lifecycle
         migrate   Migrate your database
          studio   Browse your data with Prisma Studio
          format   Format your schema
## Examples
  Set up a new Prisma project
  $ prisma init
  Generate artifacts (e.g. Prisma Client)
  $ prisma generate
  Browse your data
  $ prisma studio
  Create migrations from your Prisma schema, apply them to the database, generate artifacts (e.g. Prisma Cl ient)
  $ prisma migrate dev
  Pull the schema from an existing database, updating the Prisma schema
  $ prisma db pull
  Push the Prisma schema state to the database
  $ prisma db push


npx prisma init
npx prisma studio
npx prisma generate
npx prisma migrate reset -f
ts-node ./prisma/seed.ts


https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch/relational-databases-typescript-postgres

postgresql://USER:PASSWORD@HOST:PORT/DATABASE?schema=SCHEMA

## Prisma migrate
npx prisma migrate dev --name init

npx prisma migrate dev --name pothos_example

npx prisma db push

## Prisma client
npx ts-node src/a_prisma.ts

https://github.com/prisma/prisma-examples/tree/latest/typescript/graphql-nextjs
https://github.com/prisma/prisma-examples/tree/latest/typescript/grpc

npx prisma generate


# Edgedb

query builder, composability
https://www.edgedb.com/blog/designing-the-ultimate-typescript-query-builder


# Rambdax
pnpm add rambdax




