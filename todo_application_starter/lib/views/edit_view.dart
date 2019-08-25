import 'package:flutter/material.dart';
import 'package:todo_application/models/todo_list.dart';
import 'package:todo_application/main.dart';

class EditView extends StatefulWidget {
  final TodoItem todoItem;

  EditView({@required this.todoItem});

  @override
  State<StatefulWidget> createState() {
    return EditViewState();
  }
}

class EditViewState extends State<EditView> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode taskFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  String errorMessageTask;
  bool validateTask = false;

  @override
  void dispose() {
    taskController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          iMessage.appBarTitle,
          style: iStyle.appBarTextStyle
        ),
        centerTitle: true,
        backgroundColor: iStyle.themeColor,
        elevation: 10,
      ),
    );
  }
}
