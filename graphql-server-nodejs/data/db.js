
const Book = require('../models/Book')
const Author = require('../models/Author')


const mongoDataMethods = {
    getAllBooks: async (condition = null) => await condition === null ?  Book.find() : Book.find(condition),
    getBookById: async id => await Book.findById(id),
    getAuthorById: async id => await Author.findById(id),
    getAllAuthors : async () => await Author.find(),
    deleteBookById: async id => await Book.findByIdAndRemove(id),
    deleteAuthorById: async id => await Author.findByIdAndRemove(id),
    updateBookById : async (type, set) => await Book.findByIdAndUpdate(type,set),
    updateAuthorById : async (type, set) => await Author.findByIdAndUpdate(type,set),

}
module.exports = mongoDataMethods;