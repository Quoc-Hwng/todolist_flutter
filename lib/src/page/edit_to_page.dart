import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTodoPage extends StatefulWidget {
  final String title;
  final String desc;
  final int color;
  final index;

  EditTodoPage(
      {this.title,
      this.desc,
      this.color,
      this.index}); //ngoặc nhọn để trỏ chỉ đinh truyền tham số, không có phải theo thứ tự
  @override
  State<StatefulWidget> createState() => _EditTodoPage();
}

class _EditTodoPage extends State<EditTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

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
    title = widget.title;
    desc = widget.desc;
    color = widget.color;
    _titleController.text = widget.title;
    _descController.text = widget.desc;
  }

  Future<void> _updateTodo(index, title, desc, color) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.update(index, {
        'title': title,
        'desc': desc,
        'colors': color,
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
            controller: _titleController,
            //obscureText: true,
            decoration: InputDecoration(
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 20.0),
            ),
            onChanged: (val) => title = val.trim(),
          ),
          TextFormField(
            controller: _descController,
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
              await _updateTodo(widget.index, title, desc, color);
            },
            child: Container(
                height: 55.0,
                child: Text('Edit',
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
