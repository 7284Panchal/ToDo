import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_application/view_models/todo_view_model.dart';

class AddView extends StatefulWidget {
  final ITodoViewModel iTodoViewModel;

  AddView({@required this.iTodoViewModel});

  @override
  State<StatefulWidget> createState() {
    return AddViewState();
  }
}

class AddViewState extends State<AddView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode taskFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  String errorMessageTask;
  bool validateTask = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "To do",
          style: TextStyle(
            fontSize: 22,
            color: Color(
              0xFFFFFFFF,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(
          0xFF17914A,
        ),
        elevation: 10,
      ),
      body: ScopedModel<TodoViewModel>(
        model: widget.iTodoViewModel,
        child: ScopedModelDescendant<TodoViewModel>(
          builder: (context, child, model) {
            if (model.isLoading()) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(
                      0xFF17914A,
                    ),
                  ),
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
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            child: Text(
              "Create task",
              style: TextStyle(
                fontSize: 16,
                color: Color(
                  0xFF333333,
                ),
              ),
            ),
          ),
          _buildTaskField(),
          _buildDescriptionField(),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildTaskField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: TextField(
        autofocus: true,
        controller: taskController,
        focusNode: taskFocusNode,
        onEditingComplete: () {
          taskFocusNode.unfocus();
          FocusScope.of(context).requestFocus(descriptionFocusNode);
        },
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: "Task",
          hintStyle: TextStyle(
            color: Color(
              0xFF6E7687,
            ),
          ),
          errorText: !validateTask ? errorMessageTask : null,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: TextFormField(
        maxLines: 2,
        controller: descriptionController,
        focusNode: descriptionFocusNode,
        onFieldSubmitted: (value) {
          taskFocusNode.unfocus();
        },
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: "Description",
          hintStyle: TextStyle(
            color: Color(
              0xFF6E7687,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: 150,
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        color: Color(
          0xFF17914A,
        ),
        child: Text(
          "Add Task",
          style: TextStyle(
            fontSize: 16,
            color: Color(
              0xFFFFFFFF,
            ),
          ),
        ),
        onPressed: () {
          if (taskController.text.isEmpty) {
            setState(() {
              validateTask = false;
              errorMessageTask = "Task should not empty";
            });
          }

          widget.iTodoViewModel.addTask(
            task: taskController.text,
            description: descriptionController.text,
            onComplete: () {
              showSnackBar(widget.iTodoViewModel.getMessage());
              Future.delayed(Duration(seconds: 2,),(){
                Navigator.pop(context);
              });
            },
            onError: () {
              showSnackBar(widget.iTodoViewModel.getMessage());
            },
          );
        },
      ),
    );
  }

  showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Color(
        0xFF17914A,
      ),
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}
