import { tydef4 as typeDefs } from '../scratch/gql3'
import { resol4 as resolvers } from '../scratch/gql3'

import { createServer } from '@graphql-yoga/node'

import { makeExecutableSchema } from '@graphql-tools/schema';


const execSchema = makeExecutableSchema({
  typeDefs: [typeDefs],
  resolvers: [resolvers],
})

createServer({ schema: execSchema, port: 4040 }).start()
// http://



