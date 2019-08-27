import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:todo_application/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_application/models/todo_list.dart';
import 'package:todo_application/view_models/todo_view_model.dart';
import 'package:todo_application/views/add_edit_view.dart';
import 'package:todo_application/views/widget/todo_list_item.dart';
import 'package:todo_application/enum.dart';

import 'widget/appbar.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //get view model
  TodoViewModel todoViewModel = Injector.getInjector().get<TodoViewModel>();

  @override
  void initState() {
    super.initState();
    todoViewModel.loadTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      body: ScopedModel<TodoViewModelImplementation>(
        model: todoViewModel,
        child: ScopedModelDescendant<TodoViewModelImplementation>(
          builder: (context, child, model) {
            if (model.isLoading()) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(style.themeColor),
                ),
              );
            } else {
              return _buildBodyContent(model);
            }
          },
        ),
      ),
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

  Widget _buildBodyContent(TodoViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            child: Text(
              message.totalTask(
                model.getTodoListCount(),
              ),
              style: style.headerTextStyle,
            ),
          ),
          Divider(
            height: 1,
          ),
          model.getTodoListCount() != 0 ? _buildToDoList(model) : Container()
        ],
      ),
    );
  }

  Widget _buildToDoList(TodoViewModel model) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.getTodoListCount(),
      itemBuilder: (context, index) {
        return _buildToDoListItem(model: model, index: index);
      },
    );
  }

  Widget _buildToDoListItem({TodoViewModel model, int index}) {
    return TodoListItem(
      todoItem: model.getTodoList().todoItems.elementAt(index),
      onStatusChange: (value) {
        onTaskStatusChange(
          model: model,
          index: index,
          value: value,
        );
      },
      onDelete: () {
        onTaskDelete(
          model: model,
          index: index,
        );
      },
      onItemClick: () {
        startAddEditScreen(
          todoItem: model.getTodoList().todoItems.elementAt(index),
          taskType: TaskType.EDIT_TASK,
        );
      },
    );
  }

  void onTaskStatusChange({
    @required TodoViewModel model,
    @required int index,
    @required bool value,
  }) {
    model.updateTaskStatus(
      id: model.getTodoList().todoItems.elementAt(index).id,
      isCompleted: value,
    );
    setState(() {
      model.getTodoList().todoItems.elementAt(index).isCompleted = value;
    });
  }

  void onTaskDelete({
    @required TodoViewModel model,
    @required int index,
  }) {
    model.deleteTask(
      id: model.getTodoList().todoItems.elementAt(index).id,
      onComplete: () {
        setState(() {
          showSnackBar(todoViewModel.getMessage());
        });
      },
      onError: () {
        setState(() {
          showSnackBar(todoViewModel.getMessage());
        });
      },
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
          todoViewModel: todoViewModel,
          todoItem: todoItem,
          taskType: taskType,
        ),
      ),
    );

    if (success) {
      showSnackBar(todoViewModel.getMessage());
    }
  }

  showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: style.themeColor,
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }
}
