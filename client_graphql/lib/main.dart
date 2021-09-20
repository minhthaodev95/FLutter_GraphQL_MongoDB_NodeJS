import 'package:client_graphql/src/homepage.dart';
import 'package:client_graphql/src/screens/authorsList.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink libraryBooks = HttpLink('http://localhost:4000/graphql');
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: libraryBooks,
        cache: GraphQLCache(
          store: InMemoryStore(),
        ),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => HomePage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/second': (context) => AuthorsList(),
        },
      ),
    );
  }
}
