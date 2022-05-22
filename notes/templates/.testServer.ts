const context = undefined

import { getGraphQLSchema } from './.testGqlExec'
import { graphqlHTTP } from 'express-graphql'
// import * as expr from 'express'
const expr = require('express')
import * as dotenv from 'dotenv'
import { createServer } from '@graphql-yoga/node'
import { createTestServer } from '@pothos/test-utils';
import { ApolloServer } from 'apollo-server'


dotenv.config()
const port = process.env.TESTPORT || 4040
const serverName = process.env.TESTSERVERNAME || 'Express'


export function StartServerExpress () {
  const app: expr.Express = expr()

  // app.get('/', (req: expr.Request, res: expr.Response) => {
  //   res.send('Express + TypeScript Server');
  // });

  // Logging example:
  // app.use( (req: expr.Request, res, next) => {
  //   console.log( req.headers['user-agent'] )
  //   console.log( req.ip )
  //   next()
  // })

  app.use('/graphql', graphqlHTTP({
    ...getGraphQLSchema(),
    context: context,
    graphiql: true
  }))

  app.listen(port, () => {
    console.log(`Express server is running at https://localhost:${port}/graphql`);
  })
}

export function StartServerYoga () {
  createServer({
    ...getGraphQLSchema(),
    hostname: 'localhost',
    context: context,
    port,
  })
    .start()
    .catch( e => console.log( e ) )
}

export function StartServerApollo () {
  const server = new ApolloServer({
    ...getGraphQLSchema(),
    context: context,
  })
  server.listen({port}).then(({ url }) => {
    console.log(`Apollo Server ready at ${url}`);
  })
}

export function StartServerHelix() {
  const server = createTestServer({
    ...getGraphQLSchema(),
    contextFactory: context,
  })
  server.listen(port, () => {
    console.log(`Helix server is running at https://localhost:${port}/graphql`);
  })
}




export function StartServer() {
  if (serverName === 'Yoga') {
    StartServerYoga()
  } else if (serverName === 'Express') {
    StartServerExpress()
  } else if (serverName === 'Apollo') {
    StartServerApollo()
  } else if (serverName === 'Helix') {
    StartServerHelix()
  }
}

// StartServerApollo()




