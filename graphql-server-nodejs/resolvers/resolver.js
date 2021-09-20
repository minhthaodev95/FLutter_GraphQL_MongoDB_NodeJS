const {books, authors} = require('../data/db');
const Author = require('../models/Author')
const Book = require('../models/Book')

const resolvers = {
    Query: {
        books: async (parent, args, {mongoDataMethods}) => await mongoDataMethods.getAllBooks(),
        book: async (parent, {id}, {mongoDataMethods}) => await mongoDataMethods.getBookById(id),
        authors : async (parent, args, {mongoDataMethods}) => await mongoDataMethods.getAllAuthors(),
        author : async (parent, {id}, {mongoDataMethods}) => await mongoDataMethods.getAuthorById(id)
    },
    Book : {
        author:async ({authorId}, args, {mongoDataMethods}) => await mongoDataMethods.getAuthorById(authorId)
    },
    Author: {
        books:async({id}, args, {mongoDataMethods}) => await mongoDataMethods.getAllBooks({authorId: id})
    },
    Mutation : {
        createAuthor : async (parent, args) =>  await new Author(args).save(),
        createBook  : async (parent, args) =>  await new Book(args).save(),
        deleteBook : async (parent, {id}, {mongoDataMethods} ) => await mongoDataMethods.deleteBookById(id),
        deleteAuthor : async (parent, {id}, {mongoDataMethods} ) => await mongoDataMethods.deleteAuthorById(id),
        updateBook :  async (parent, {id, title, authorId}, {mongoDataMethods}) =>  await mongoDataMethods.updateBookById(id, {title, authorId }),
        updateAuthor :  async (parent, {id, name, age}, {mongoDataMethods}) =>  await mongoDataMethods.updateAuthorById(id,  {name, age}),
    },      
    
}

module.exports = resolvers;