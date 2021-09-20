class QueryMethods {
  final listBooks = '''
    query books {
      books{
          id
          title
          author {
            name
            id
        }
      }
    }
  ''';
  final authors = '''
  query authors {
    authors{ 
      name
      id
      age
     }
  }
  ''';
  final authorById = '''
    query authorById(\$id : ID!) {
      author(id:\$id){
        name
        age
        books{
          title
        }
      }
    }

  ''';
  final bookById = '''
    query bookById(\$id: ID!) {
      book(id:\$id){
        title
        author{
          name
        }
      }
    }

  ''';

  final createAuthor = '''
  mutation createAuthor(\$name: String!, \$age: Int!){
      createAuthor(
          name : \$name,
          age   : \$age
        ){
          id
          name
          age
        }
  }
  ''';

  final createBook = '''
  mutation createBook(\$title: String!, \$authorId: ID!){
      createBook(
          title : \$title,
          authorId:\$authorId
        ){
          id
          title
        }
  }
  ''';
  final deleteBook = '''
  mutation deleteBook(\$id : ID!){
    deleteBook(id : \$id){
      id
    }
  }  
  ''';
  final deleteAuthor = '''
  mutation deleteAuthor(\$id : ID!){
    deleteAuthor(id : \$id){
      id
    }
  }  
  ''';

  final updateBook = '''
   mutation updateBook(\$id : ID!, \$title: String, \$authorId: ID){
      updateBook(
          id : \$id,
          title : \$title,
          authorId:\$authorId
        ){
          id
          title
        }
  }
  ''';
  final updateAuthor = '''
   mutation updateAuthor(\$id : ID!, \$name: String, \$age: Int){
      updateAuthor(
          id : \$id,
          name : \$name,
          age:\$age
        ){
          id
          name
        }
  }
  ''';
}
