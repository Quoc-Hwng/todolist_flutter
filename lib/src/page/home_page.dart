import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:todolist/src/page/add_todo_page.dart';
import 'package:todolist/src/page/edit_to_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _updateTodo(index) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(index);
      bool _currentCompleted = snapshot['completed'];
      await transaction.update(index, {
        'completed': !_currentCompleted,
      });
    });
  }

  Future<void> _deleteTodo(index) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(index);
    });
  }

  Future<void> _showDialogDelete(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Color'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are U Del ??'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('DELETE'),
              onPressed: () async {
                await _deleteTodo(index);
                Navigator.of(context).pop(context);
              },
            ),
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showBottomAddToDo() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddTodoPage();
        });
  }

  showBottomEditToDo(title, desc, color, index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return EditTodoPage(
            title: title,
            desc: desc,
            color: color,
            index: index,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.0, left: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            showBottomAddToDo();
          },
          child: Icon(
            Icons.add,
            size: size.width / 18.0,
            color: Colors.white,
          ),
          backgroundColor: Colors.blueAccent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('todo')
                  //   .where('completed', isEqualTo: false)
                  // .limit(7)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                List<DocumentSnapshot> docs = snapshot.data.documents;

                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          //xóa color ngoài bỏ vào đây
                          color:
                              Color(snapshot.data.documents[index]['colors'])),
                      margin: EdgeInsets.only(
                        bottom: 2.0,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(snapshot.data.documents[index]['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    )),
                                Text(snapshot.data.documents[index]['desc'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ))
                              ],
                            ),
                            Row(children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: size.width / 20.0,
                                ),
                                onPressed: () {
                                  showBottomEditToDo(
                                    snapshot.data.documents[index]['title'],
                                    snapshot.data.documents[index]['desc'],
                                    snapshot.data.documents[index]['colors'],
                                    snapshot.data.documents[index].reference,
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: snapshot.data.documents[index]
                                          ['completed']
                                      ? Colors.black
                                      : Colors.white,
                                  size: size.width / 20.0,
                                ),
                                onPressed: () async {
                                  await _updateTodo(
                                      snapshot.data.documents[index].reference);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: size.width / 20.0,
                                ),
                                onPressed: () async {
                                  _showDialogDelete(
                                      snapshot.data.documents[index].reference);
                                },
                              ),
                            ])
                          ]),
                    );
                  },
                );
              })),
    );
  }
}
