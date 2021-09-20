import 'package:flutter/material.dart';
import 'package:client_graphql/src/services/queryMethods.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BookDetail extends StatelessWidget {
  final String bookId;
  const BookDetail({required this.bookId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageDetail'),
      ),
      body: Query(
        options: QueryOptions(
            document: gql(QueryMethods().bookById), variables: {'id': bookId}),
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
          final book = result.data!['book'];
          return Card(
            child: ListTile(
              title: Text("Title : ${book['title']}"),
              subtitle: Text("Author: ${book['author']['name']}"),
            ),
          );
        },
      ),
    );
  }
}
