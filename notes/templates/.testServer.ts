import { schem3 as typeDef } from './theTestFile.ts'
import { resol1 as resolver } from './theTestFile.ts'

import { createServer } from '@graphql-yoga/node'

import { buildSchema, GraphQLSchema, lexicographicSortSchema, printSchema } from 'graphql'
import { makeExecutableSchema } from '@graphql-tools/schema';


const execSchema = makeExecutableSchema({
  typeDefs: [typeDefinitions],
  resolvers: [resolvers],
})

const createServer({ schema: execSchema }).start()



