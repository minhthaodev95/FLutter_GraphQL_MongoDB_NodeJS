import 'package:client_graphql/src/author_detail.dart';
import 'package:client_graphql/src/services/queryMethods.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthorsList extends StatefulWidget {
  AuthorsList({Key? key}) : super(key: key);

  @override
  _AuthorsListState createState() => _AuthorsListState();
}

class _AuthorsListState extends State<AuthorsList> {
  int _selectedIndex = 1;
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
    final _nameAuthor = TextEditingController();
    final _ageAuthor = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              child: Mutation(
                  options: MutationOptions(
                    document: gql(QueryMethods().createAuthor),
                    onCompleted: (dynamic resultData) {
                      print(resultData);
                    },
                  ),
                  builder: (RunMutation runMutation, result) {
                    return SingleChildScrollView(
                      child: Dialog(
                          insetAnimationDuration: Duration(milliseconds: 100),
                          insetAnimationCurve: Curves.easeIn,
                          insetPadding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text('Insert Author '),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: _nameAuthor,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.people),
                                    hintText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: _ageAuthor,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.auto_graph_rounded),
                                    hintText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      runMutation({
                                        'name': _nameAuthor.text,
                                        'age': int.parse(_ageAuthor.text),
                                      });
                                      Navigator.pop(context, result);
                                    },
                                    child: Text('Insert Author')),
                              ],
                            ),
                          )),
                    );
                  }),
            ),
          );
        });
  }

//show dialog Update Author
  void _showDialogUpdateAuthor(
      final idAuthor, final initNameAuthor, final initAgeAuthor) {
    String _nameAuthor = '';
    String _ageAuthor = '';
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              child: Mutation(
                  options: MutationOptions(
                    document: gql(QueryMethods().updateAuthor),
                    onCompleted: (dynamic resultData) {
                      print(resultData);
                    },
                  ),
                  builder: (RunMutation runMutation, result) {
                    return SingleChildScrollView(
                      child: Dialog(
                          insetAnimationDuration: Duration(milliseconds: 100),
                          insetAnimationCurve: Curves.easeIn,
                          insetPadding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text('Update Author '),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  initialValue: initNameAuthor,
                                  onChanged: (text) {
                                    _nameAuthor = text;
                                  },
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.people),
                                    hintText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  initialValue: initAgeAuthor.toString(),
                                  onChanged: (text) {
                                    _ageAuthor = text;
                                  },
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.auto_graph_rounded),
                                    hintText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      runMutation({
                                        "id": idAuthor,
                                        'name': _nameAuthor == ''
                                            ? initNameAuthor
                                            : _nameAuthor,
                                        'age': _ageAuthor == ''
                                            ? initAgeAuthor
                                            : int.parse(_ageAuthor),
                                      });
                                      Navigator.pop(context, result);
                                    },
                                    child: Text('Update Author')),
                              ],
                            ),
                          )),
                    );
                  }),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authors'),
        automaticallyImplyLeading: false,
      ),
      body: Query(
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
            List authors = result.data!['authors'];
            return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthorDetail(
                          authorId: authors[index]['id'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text("Name : ${authors[index]['name']}"),
                        ),
                        Mutation(
                            options: MutationOptions(
                              document: gql(QueryMethods().deleteAuthor),
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
                                    runDeleteMutation(
                                        {'id': authors[index]['id']});
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
                              _showDialogUpdateAuthor(
                                  authors[index]['id'],
                                  authors[index]['name'],
                                  authors[index]['age']);
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: authors.length,
            );
          }),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.red,
        notchMargin: 4,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
