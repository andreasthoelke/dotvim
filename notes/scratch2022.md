
syntaxIdAtCursor with treesitter

# Scratch

type Comment {
  author: User
  comment: String!
  id: ID!
  post: Post!
}

type Post {
  author: User
  comments: [Comment!]!
  content: String!
  id: ID!
  title: String!
}

type Query {
  post(id: ID!): Post
  posts(skip: Int, take: Int): [Post!]
  user(id: ID!): User
}

type User {
  comments: [Comment!]!
  firstName: String!
  fullName: String!
  id: ID!
  lastName: String!
  posts: [Post!]!
}


## Vim to learn

### Lsp
sp ca - code action
gti   - import identifier under cursor
~/.config/nvim/plugin/setup-lsp.lua#/buf_map.bufnr,%20"n",%20"gts",
https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils

### Quick floats
sp os - scratch
sp os - links
sp ob - vim bookmarks

gdo - go to definition in float

npx edgedb-js
save in other folder
connect to dracula and instance?







