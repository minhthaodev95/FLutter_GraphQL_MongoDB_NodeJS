import 'package:flutter/material.dart';
import 'package:client_graphql/src/services/queryMethods.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthorDetail extends StatelessWidget {
  final String authorId;
  const AuthorDetail({required this.authorId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageAuthorDetail'),
      ),
      body: Query(
        options: QueryOptions(
            document: gql(QueryMethods().authorById),
            variables: {'id': authorId}),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 3.0,
              ),
            );
          }
          final author = result.data!['author'];
          List books = result.data!['author']['books'];
          return Column(
            children: [
              Card(
                child: ListTile(
                  title: Text("Name : ${author['name']}"),
                  subtitle: Text("age: ${author['age']}"),
                ),
              ),
              Text('Các tác phẩm :'),
              Container(
                height: 500,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text("Title : ${books[index]['title']}"),
                      ),
                    );
                  },
                  itemCount: books.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
