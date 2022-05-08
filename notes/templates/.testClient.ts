import { tydefConstr1 as typeDefs } from '../scratch/gql4'
import { resolCons1 as resolvers } from '../scratch/gql4'
import { queryCons1 as query } from '../scratch/gql4'
import { variaCons1 as variables } from '../scratch/gql4'

import { buildSchema, graphql, GraphQLSchema } from 'graphql'


const process = graphql({
  // schema: buildSchema( typeDefs ), // An SDL (fixed) schema(-first)
  // rootValue: resolvers, // needs a separate resolvers object
  schema: new GraphQLSchema({ query: typeDefs }), // Code-first query-root object includes resolvers
  source: query,
  // contextValue?: ?any,
  variableValues: variables,
  // operationName?: ?string
})

// process.then( res => console.log( res ) )

process.then( res => console.log( JSON.parse(JSON.stringify( res.data )) ) )

// https://graphql.org/graphql-js/graphql/










