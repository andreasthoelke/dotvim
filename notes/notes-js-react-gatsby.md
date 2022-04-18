
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
npx create-react-app tuts_2 && cd $_

# Function components
https://www.robinwieruch.de/react-function-component/

http://localhost:3000


# Flow types
use 'npm run flow'

Make flow aware of "import { ReactComponent as MyIcon } from 'icon.svg';
~/Documents/UI-Dev/React1/fn-comps1/.flowconfig#/module.name_mapper.extension='svg'%20->%20'<PROJECT_ROOT>/SVGModule.js.flow'

just an old tutorial?
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

https://flow-typed.github.io/flow-typed/\#/usage

Note: after installing a new lib I need to run this again:
flow-typed install

# Eslint

https://gist.github.com/nkbt/9efd4facb391edbf8048

/* eslint no-unused-vars: 0 */

create-react-app my-app && cd my-app
yarn add --dev flow-bin
yarn run flow init


# Babel

caution: this ejects CRA
https://github.com/timarney/react-app-rewired
https://dev.to/ansonh/simplest-way-to-install-babel-plugins-in-create-react-app-7i5


npm install --save-dev @babel/plugin-proposal-do-expressions
npm install --save-dev @babel/plugin-transform-react-jsx


# Nextjs

npx create-next-app nextjs-blog --use-npm --example "https://github.com/vercel/next-learn/tree/master/basics/learn-starter"

# new React vite typescript project
yarn create vite .. then follow propts!

# Styled components


# Typescript

npx src <filename> -o <outfile>

https://www.typescriptlang.org/docs/handbook/2/functions.html

"strictFunctionTypes": false,

# Json placeholder
https://jsonplaceholder.typicode.com/guide/


# Fetch clients



# Redux
// Actions Creators
const addTodo1 = (text: string) => ({ type: 'todos/todoAdded', payload: text })

## Reducers
(state, action) => newState
.. are like Event listeners. Actions = Events










