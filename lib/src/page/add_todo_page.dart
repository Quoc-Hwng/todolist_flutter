import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTodoPage();
}

class _AddTodoPage extends State<AddTodoPage> {
  String title;
  String desc;
  int color;

  List<int> colors = [
    Colors.lightGreenAccent.value,
    Colors.amberAccent.value,
    Colors.deepPurpleAccent.value,
  ];
  @override
  void initState() {
    super.initState();
    title = '';
    desc = '';
    color = colors[0];
  }

  Future<void> _addTodo(title, desc, color) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection("todo");
      await reference.add({
        'title': title,
        'desc': desc,
        'colors': color,
        'completed': false,
        'publishAt': DateTime.now(),
      });
    });
    Navigator.of(context).pop(context);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        children: [
          TextFormField(
            //obscureText: true,
            decoration: InputDecoration(
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 20.0),
            ),
            onChanged: (val) => title = val.trim(),
          ),
          TextFormField(
            //obscureText: true,
            decoration: InputDecoration(
              hintText: 'Description',
              hintStyle: TextStyle(fontSize: 20.0),
            ),
            onChanged: (val) => desc = val.trim(),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 40.0,
            width: 150.0,
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      print(colors[index]);
                      setState(() {
                        color = colors[index];
                      });
                    },
                    child: Container(
                        height: 25.0,
                        width: 25.0,
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                            color: Color(colors[index]),
                            border: Border.all(
                              color: color == colors[index]
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0)))));
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () async {
              await _addTodo(title, desc, color);
            },
            child: Container(
                height: 55.0,
                child: Text('Create',
                    style: TextStyle(
                        color: Colors.white, fontSize: size.width / 18.0)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)))),
          )
        ],
      ),
    );
  }
}
