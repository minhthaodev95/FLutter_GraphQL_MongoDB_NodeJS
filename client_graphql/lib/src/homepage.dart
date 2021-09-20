import 'package:client_graphql/src/book_detail.dart';
import 'package:client_graphql/src/models/authorModel.dart';
import 'package:client_graphql/src/services/queryMethods.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/");
        break;
      case 1:
        Navigator.pushNamed(context, "/second");
        break;
    }
    ;
  }

  void _showDialog() {
    final currentAuthor = Rxn<String>();
    final _title = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Query(
              options: QueryOptions(
                document: gql(QueryMethods().authors),
                pollInterval: Duration(seconds: 10),
              ),
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
                final datas = result.data!['authors'] as List;
                final List<Author> authors =
                    datas.map((author) => Author.fromJson(author)).toList();

                return Center(
                  child: Container(
                    child: Mutation(
                        options: MutationOptions(
                          document: gql(QueryMethods().createBook),
                          onCompleted: (dynamic resultData) {
                            print(resultData);
                          },
                        ),
                        builder: (runMutation, result) {
                          return SingleChildScrollView(
                            child: Dialog(
                                insetAnimationDuration:
                                    Duration(milliseconds: 100),
                                insetAnimationCurve: Curves.easeIn,
                                insetPadding: EdgeInsets.all(5),
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Text('Insert Book '),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: _title,
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.people),
                                          hintText: 'Title',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Obx(
                                        () => Row(
                                          children: [
                                            Text('Author : '),
                                            DropdownButton<String>(
                                              items:
                                                  authors.map((Author author) {
                                                return DropdownMenuItem<String>(
                                                  value: author.id,
                                                  child: Text(author.name),
                                                );
                                              }).toList(),
                                              onChanged: (selectedAuthor) {
                                                currentAuthor.value =
                                                    selectedAuthor;
                                              },
                                              value: currentAuthor.value,
                                              hint: Text('Author'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          runMutation({
                                            'title': _title.text,
                                            'authorId': currentAuthor.value
                                          });
                                          Navigator.pop(context, result);
                                        },
                                        child: Text('Insert Book'),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ),
                );
              });
        });
  }

  void _showDialogUpdate(final idBookUpdate, final titleBookUpdate,
      final authorBook, final rootAuthorId) {
    final currentAuthor = Rxn<String>();
    String titleEditUpdate = '';
    showDialog(
        context: context,
        builder: (context) {
          return Query(
              options: QueryOptions(
                document: gql(QueryMethods().authors),
                pollInterval: Duration(seconds: 10),
              ),
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
                final datas = result.data!['authors'] as List;
                final List<Author> authors =
                    datas.map((author) => Author.fromJson(author)).toList();

                return Center(
                  child: Container(
                    child: Mutation(
                        options: MutationOptions(
                          document: gql(QueryMethods().updateBook),
                          onCompleted: (dynamic resultData) {
                            print(resultData);
                          },
                        ),
                        builder: (runMutation, result) {
                          return SingleChildScrollView(
                            child: Dialog(
                                insetAnimationDuration:
                                    Duration(milliseconds: 100),
                                insetAnimationCurve: Curves.easeIn,
                                insetPadding: EdgeInsets.all(5),
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Text('Insert Book '),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        initialValue: titleBookUpdate,
                                        onChanged: (text) {
                                          titleEditUpdate = text;
                                        },
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.people),
                                          hintText: 'Title',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Obx(
                                        () => Row(
                                          children: [
                                            Text('Author : '),
                                            DropdownButton<String>(
                                              items:
                                                  authors.map((Author author) {
                                                return DropdownMenuItem<String>(
                                                  value: author.id,
                                                  child: Text(author.name),
                                                );
                                              }).toList(),
                                              onChanged: (selectedAuthor) {
                                                currentAuthor.value =
                                                    selectedAuthor;
                                              },
                                              value: currentAuthor.value,
                                              hint: Text(authorBook),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          runMutation({
                                            "id": idBookUpdate,
                                            "title": titleEditUpdate == ''
                                                ? titleBookUpdate
                                                : titleEditUpdate,
                                            'authorId':
                                                currentAuthor.value == null
                                                    ? rootAuthorId
                                                    : currentAuthor.value
                                          });
                                          Navigator.pop(context, result);
                                        },
                                        child: Text('Update Book'),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Book'),
        automaticallyImplyLeading: false,
      ),
      body: Query(
          options: QueryOptions(
            document: gql(QueryMethods().listBooks),
            pollInterval: Duration(seconds: 10),
          ),
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
            List books = result.data!['books'];
            return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetail(
                          bookId: books[index]['id'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    child: Stack(children: <Widget>[
                      ListTile(
                        title: Text("Title : ${books[index]['title']}"),
                      ),
                      Mutation(
                          options: MutationOptions(
                            document: gql(QueryMethods().deleteBook),
                            onCompleted: (dynamic resultData) {
                              print(resultData);
                            },
                          ),
                          builder: (runDeleteMutation, result) {
                            return Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                color: Colors.red[400],
                                onPressed: () {
                                  runDeleteMutation({'id': books[index]['id']});
                                },
                                icon: Icon(Icons.delete),
                              ),
                            );
                          }),
                      Positioned(
                        top: 5,
                        right: 40,
                        child: IconButton(
                          color: Colors.grey,
                          onPressed: () {
                            _showDialogUpdate(
                                books[index]['id'],
                                books[index]['title'],
                                books[index]['author']['name'],
                                books[index]['author']['id']);
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ]),
                  ),
                );
              },
              itemCount: books.length,
            );
          }),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Colors.amber,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Author',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showDialog();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
