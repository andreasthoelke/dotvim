import { tydef5 as typeDefs } from '../scratch/gql4'
import { resol4 as resolvers } from '../scratch/gql4'
import { myquery3 as query } from '../scratch/gql4'
import { myvaria3 as variables } from '../scratch/gql4'

import { buildSchema, graphql } from 'graphql'


const process = graphql({
  schema: buildSchema( typeDefs ),
  source: query,
  rootValue: resolvers,
  // contextValue?: ?any,
  // variableValues?: ?{[key: string]: any},
  // operationName?: ?string
})

// process.then( res => console.log( res ) )

process.then( res => console.log( JSON.parse(JSON.stringify( res.data )) ) )












