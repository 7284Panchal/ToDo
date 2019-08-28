import 'package:flutter/material.dart';
import 'package:todo_application/enum.dart';
import 'package:todo_application/main.dart';
import 'package:todo_application/models/todo_list.dart';

class AddEditView extends StatefulWidget {
  final TodoItem todoItem;
  final TaskType taskType;

  AddEditView({
    this.todoItem,
    @required this.taskType,
  });

  @override
  State<StatefulWidget> createState() {
    return AddEditViewState();
  }
}

class AddEditViewState extends State<AddEditView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          message.appBarTitle,
          style: style.appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: style.themeColor,
        elevation: 10,
      ),
    );
  }
}
