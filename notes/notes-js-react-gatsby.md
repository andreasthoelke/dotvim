
# Gatsby
gatsby new starter-blog https://github.com/gatsbyjs/gatsby-starter-blog

https://github.com/gatsbyjs/gatsby-starter-blog
http://localhost:8000/

## Tutorial
https://www.gatsbyjs.com/docs/tutorial/part-1/

# NextJS
https://nextjs.org/learn/basics/create-nextjs-app/setup
npx create-next-app nextjs-blog --use-npm --example "https://github.com/vercel/next-learn/tree/master/basics/learn-starter"

http://localhost:3000/posts/first-post
stopped here:
https://nextjs.org/learn/basics/navigate-between-pages/client-side

# Create React App
npx create-react-app fn-comps1 && cd $_

# Function components
https://www.robinwieruch.de/react-function-component/

http://localhost:3000


# Flow types
use 'npm run flow'

could try this setup:
npx create-react-app flowchecker
https://pusher.com/tutorials/type-check-react-flow/

auto-annotator?
npm run flow codemod annotate-exports --write --repeat src

https://medium.com/flow-type/improvements-to-flow-in-2019-c8378e7aa007

type MyComponentProps = {
  id: number,
  name: string
};

const MyComponent = ({ id, name}: MyComponentProps): React.Node =>
  <div>{`My name is ${name} and ${id} is my ID.`}</div>

## flow-typed
https://flow-typed.github.io/flow-typed/#/usage



# Eslint

https://gist.github.com/nkbt/9efd4facb391edbf8048



create-react-app my-app && cd my-app
yarn add --dev flow-bin
yarn run flow init





















