import { tydefConstr1 as typeDefs } from '../scratch/gql4'
import { resolCons1 as resolvers } from '../scratch/gql4'

import { graphqlHTTP } from 'express-graphql'
import { buildSchema, GraphQLSchema } from 'graphql'
import * as expr from 'express'
import * as dotenv from 'dotenv'

dotenv.config()
const port = process.env.TESTPORT;

const app: expr.Express = expr();

app.get('/', (req: expr.Request, res: expr.Response) => {
  res.send('Express + TypeScript Server');
});


app.use( (req: expr.Request, res, next) => {
  console.log( req.headers['user-agent'] )
  console.log( req.ip )
  next()
})

app.use('/graphql', graphqlHTTP({
  // schema: buildSchema( typeDefs ), // An SDL (fixed) schema(-first)
  // rootValue: resolvers, // needs a separate resolvers object
  schema: new GraphQLSchema({ query: typeDefs }), // Code-first query-root object includes resolvers
  graphiql: true
}))


// app.listen(4040)
app.listen(port, () => {
  console.log(`[server]: Server is running at https://localhost:${port}`);
})


// http://localhost:4040/graphql




