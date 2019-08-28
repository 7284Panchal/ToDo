import 'package:flutter/material.dart';
import 'package:todo_application/enum.dart';
import 'package:todo_application/main.dart';
import 'package:todo_application/models/todo_list.dart';
import 'package:todo_application/views/add_edit_view.dart';
import 'package:todo_application/views/widget/appbar.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        startAddEditScreen(
          taskType: TaskType.ADD_TASK,
        );
      },
      backgroundColor: style.themeColor,
      child: Icon(
        Icons.add,
      ),
      tooltip: message.createNewTask,
    );
  }

  void startAddEditScreen({
    TodoItem todoItem,
    @required TaskType taskType,
  }) async {
    bool success = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditView(
          todoItem: todoItem,
          taskType: taskType,
        ),
      ),
    );
  }

  showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: style.themeColor,
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }
}
