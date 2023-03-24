// ignore_for_file: prefer_const_constructors, list_remove_unrelated_type

import 'package:flutter/material.dart';
import 'package:todo_list/model/to_do.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To Do List",
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple),
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final list = <Todo>[];
  var textFieldText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("To Do List"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: (() {
              showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Add new item"),
                      content: TextField(
                        decoration: InputDecoration(
                            hintText: "Enter text",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Colors.purple, width: 2))),
                        onChanged: ((value) => textFieldText = value),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (textFieldText.isNotEmpty) {
                                setState(() {
                                  list.add(Todo.of(textFieldText, false));
                                });
                                showSnackbar(context, "Item added!");
                                textFieldText = "";
                              } else {
                                showSnackbar(context, "Empty item not added!");
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(fontSize: 17),
                            ))
                      ],
                    );
                  }));
            }),
            child: Icon(Icons.add)),
        body: list.isNotEmpty
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: ((context, index) => TodoItem(
                    title: list[index].title,
                    checked: list[index].completed,
                    onCheck: (checked) => list[index].completed = checked,
                    onDeletePressed: () => {
                          setState(() {
                            list.remove(index);
                          })
                        })),
              )
            : Center(child: Text("No item!")));
  }
}

void showSnackbar(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}

// ignore: must_be_immutable
class TodoItem extends StatefulWidget {
  var checked = false;
  var title = "";
  Function(bool) onCheck;
  Function()? onDeletePressed;

  TodoItem(
      {Key? key,
      required this.title,
      this.checked = false,
      required this.onCheck,
      this.onDeletePressed})
      : super(key: key);

  bool isChecked() => checked;
  void setChecked(isChecked) {
    checked = isChecked;
    onCheck.call(isChecked);
  }

  void delete() {
    onDeletePressed!.call();
  }

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem>
    with AutomaticKeepAliveClientMixin<TodoItem> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => setState(() {
          widget.setChecked(!widget.checked);
        }),
        borderRadius: BorderRadius.circular(10),
        highlightColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.checked,
                      fillColor: MaterialStateProperty.all(Colors.grey),
                      onChanged: (newValue) {
                        setState(() {
                          widget.setChecked(newValue);
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          color: widget.checked ? Colors.grey : Colors.black,
                          fontSize: 19,
                          decoration: widget.checked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () => widget.delete(),
                icon: Icon(Icons.delete_outline),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
