import { query1 as query } from '../examples/relay-windowed-pagination/src/schema'
import { varia1 as variables } from '../scratch/tests'

import { request } from "graphql-request";
import * as util from 'util'
import * as dotenv from 'dotenv'


dotenv.config()
const port = process.env.TESTPORT || 4040
export const e1_port = port


const fetch = async () => {
  const res = await request({
    url: `http://localhost:${port}/graphql`,
    document: query,
    variables: JSON.stringify( variables ),
    // requestHeaders: { Authorization: `bearer ${GH_TOKEN}` },
  })
  return res
}


const run = () => fetch().then( res => {
  const inspVal = util.inspect( res, {showHidden: false, depth: null, colors: false} )
  console.log( inspVal )
})

export function RunQuery() {
  setTimeout( run, 200 )
}









