import { tydef5 as typeDefs } from '../scratch/gql4'
import { resol4 as resolvers } from '../scratch/gql4'

import { createServer } from '@graphql-yoga/node'

import { makeExecutableSchema } from '@graphql-tools/schema';
import { graphqlHTTP } from 'express-graphql';
import { buildSchema } from 'graphql';
import * as expr from 'express';


// const execSchema = makeExecutableSchema({
//   typeDefs: [buildSchema( typeDefs )],
//   resolvers: [{ Query: resolvers }],
// })
// createServer({ schema: execSchema, port: 4040 }).start()

// Problem: Fields with arguments are null.
createServer({ schema: { typeDefs: typeDefs, resolvers: { Query: resolvers }, }, port: 4040 }).start()

// expr().use('/graphql', graphqlHTTP({ schema: buildSchema( typeDefs ), rootValue: resolvers, graphiql: true })).listen(4040)

// http://localhost:4040/graphql




