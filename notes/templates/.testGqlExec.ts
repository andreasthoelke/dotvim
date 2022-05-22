const schemaSource = undefined
const resolvers = undefined
const query = undefined
const variables = undefined

import { buildSchema, graphql, GraphQLSchema, lexicographicSortSchema, printSchema } from 'graphql'
import SchemaBuilder from '@pothos/core'
import * as util from 'util'


export const getGraphQLSchema: () => {schema: GraphQLSchema, rootValue?: any} = () => {
  if        (schemaSource.constructor.name === 'SchemaBuilder') {
    // This is from: new require(`@pothos/core`).SchemaBuilder({})
    return { schema: schemaSource.toSchema({}) }

  } else if (schemaSource.constructor.name === 'GraphQLObjectType') {
    // This is from: new require(`graphql`).GraphQLObjectType({})
    return { schema: new GraphQLSchema( { query: schemaSource } ) }

  } else if (Object.getOwnPropertyNames( schemaSource ).includes( 'query' )) {
    // This is from: {query: <GraphQLObjectType>, mutation: <GraphQLObjectType>}
    return { schema: new GraphQLSchema( schemaSource  ) }

  } else if ( typeof( schemaSource ) === 'string' ) {
    // This is a SDL gql`` GQL Type Def.
    return {
      schema: buildSchema( schemaSource ),
      rootValue: resolvers,
    }

  } else {
    throw (schemaSource.constructor.name + ' is not supported')
  }
}


const gqlExec = graphql({
  ...getGraphQLSchema(),
  // schema: buildSchema( schemaSource ),
  // rootValue: resolvers,
  source: query,
  variableValues: variables,
  // contextValue?: ?any,
  // operationName?: ?string
})


export function ExecSchema() {
  gqlExec.then( res => {
    const inspVal = util.inspect( res.data, {showHidden: false, depth: null, colors: false} )
    // const inspValF = JSON.parse( JSON.stringify( inspVal, null, 2 ) )
    const inspValF = inspVal.replaceAll('[Object: null prototype] ', '')
    console.log( inspValF )
  })
}

export function ExecSchemaWithError() {
  gqlExec.then( res => console.log( res ) )
}


export function ShowSchema() {
  console.log( printSchema( lexicographicSortSchema( getGraphQLSchema().schema ) ) )
}











