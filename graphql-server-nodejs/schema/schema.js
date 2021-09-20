const { gql } = require('apollo-server-express');

const typeDefs = gql`
    type Book {
        id:ID!
        title: String
        author: Author
    }
    type Author {
        id: ID!
        name : String
        age : Int
        books : [Book]
    }
    type Query {
        books: [Book],
        book(id : ID!): Book,
        authors : [Author]
        author (id : ID!) : Author
    }
    type Mutation {
        createAuthor( name: String, age : Int) :Author
        createBook( title: String, authorId : ID! ) :Book
        deleteBook(id: ID!) : Book
        deleteAuthor(id: ID!) : Author
        updateBook(id : ID!, title : String, authorId: ID) : Book
        updateAuthor(id : ID!, name : String, age: Int) : Author
    }
`;

module.exports = typeDefs;