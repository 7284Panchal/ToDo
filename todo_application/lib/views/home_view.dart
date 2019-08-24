import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:todo_application/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_application/view_models/todo_view_model.dart';
import 'package:todo_application/views/add_view.dart';
import 'package:todo_application/views/edit_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //get view model
  ITodoViewModel iTodoViewModel = Injector.getInjector().get<ITodoViewModel>();

  @override
  void initState() {
    super.initState();
    iTodoViewModel.loadTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "To do",
          style: iStyle.appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: iStyle.themeColor,
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(iTodoViewModel: iTodoViewModel),
            ),
          ).then((value) {
            showSnackBar(iTodoViewModel.getMessage());
          });
        },
        backgroundColor: iStyle.themeColor,
        child: Icon(
          Icons.add,
        ),
        tooltip: iMessage.createNewTask,
      ),
      body: ScopedModel<TodoViewModel>(
        model: iTodoViewModel,
        child: ScopedModelDescendant<TodoViewModel>(
          builder: (context, child, model) {
            if (model.isLoading()) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(iStyle.themeColor),
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

  Widget _buildBodyContent(ITodoViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            child: Text(
              iMessage.totalTask(
                model.getTodoListCount(),
              ),
              style: iStyle.headerTextStyle,
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

  Widget _buildToDoList(ITodoViewModel model) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.getTodoListCount(),
      itemBuilder: (context, index) {
        return _buildToDoListItem(model: model, index: index);
      },
    );
  }

  Widget _buildToDoListItem({ITodoViewModel model, int index}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            model.getTodoList().todoItems.elementAt(index).task,
            style: model.getTodoList().todoItems.elementAt(index).isCompleted
                ? iStyle.titleDoneTextStyle
                : iStyle.titleTextStyle,
          ),
          subtitle: Text(
            model.getTodoList().todoItems.elementAt(index).description,
            style: iStyle.subTitleTextStyle,
          ),
          leading: Checkbox(
            activeColor: iStyle.themeColor,
            value: model.getTodoList().todoItems.elementAt(index).isCompleted,
            onChanged: (value) {
              model.updateTaskStatus(
                id: model.getTodoList().todoItems.elementAt(index).id,
                isCompleted: value,
              );
              setState(() {
                model.getTodoList().todoItems.elementAt(index).isCompleted =
                    value;
              });
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_forever,
            ),
            onPressed: () {
              model.deleteTask(
                id: model.getTodoList().todoItems.elementAt(index).id,
                onComplete: () {
                  setState(() {
                    showSnackBar(iTodoViewModel.getMessage());
                  });
                },
                onError: () {
                  setState(() {
                    showSnackBar(iTodoViewModel.getMessage());
                  });
                },
              );
            },
          ),
          isThreeLine: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditView(
                      iTodoViewModel: iTodoViewModel,
                      todoItem: model.getTodoList().todoItems.elementAt(index),
                    ),
              ),
            ).then((value) {
              showSnackBar(iTodoViewModel.getMessage());
            });
          },
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }

  showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: iStyle.themeColor,
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }
}
