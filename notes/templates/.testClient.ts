import { myquery1 as typeDefs } from '../scratch/gql1'
import { myvaria1 as variables } from '../scratch/gql1'

import { request } from "graphql-request";


const fetch = async () => {
  const res = await request({
    url: 'http://localhost:4040/graphql',
    document: query,
    variables: JSON.stringify( variables ),
    // requestHeaders: { Authorization: `bearer ${GH_TOKEN}` },
  })
  return res
}

fetch().then( res => console.log( res ) )
  // do one simple retry
  .catch(err => fetch().then( res => console.log( res ) ))













