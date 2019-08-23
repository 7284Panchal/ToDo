import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
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
      appBar: AppBar(
        title: Text(
          "To do",
          style: TextStyle(fontSize: 22, color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF17914A),
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(iTodoViewModel: iTodoViewModel),
            ),
          );
        },
        backgroundColor: Color(0xFF17914A),
        child: Icon(
          Icons.add,
        ),
        tooltip: "Create new task",
      ),
      body: ScopedModel<TodoViewModel>(
        model: iTodoViewModel,
        child: ScopedModelDescendant<TodoViewModel>(
          builder: (context, child, model) {
            if (model.isLoading()) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF17914A)),
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
              "You have ${model.getTodoListCount()} task",
              style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
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
            style: TextStyle(fontSize: 16, color: Color(0xFF4C4C4C)),
          ),
          subtitle: Text(
            model.getTodoList().todoItems.elementAt(index).description,
            style: TextStyle(fontSize: 14, color: Color(0xFF6E7687)),
          ),
          leading: Checkbox(
            activeColor: Color(
              0xFF17914A,
            ),
            value: model.getTodoList().todoItems.elementAt(index).isCompleted,
            onChanged: (value) {
              model.updateTask(
                id: model.getTodoList().todoItems.elementAt(index).id,
                task: model.getTodoList().todoItems.elementAt(index).task,
                description:
                    model.getTodoList().todoItems.elementAt(index).description,
                isCompleted: value,
                onComplete: () {},
                onError: () {},
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
              model.deleteTask(id: model.getTodoList().todoItems.elementAt(index).id,
              onComplete: (){},onError: (){},);
            },
          ),
          isThreeLine: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditView(iTodoViewModel: iTodoViewModel,todoItem: model.getTodoList().todoItems.elementAt(index),),
              ),
            );
          },
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
