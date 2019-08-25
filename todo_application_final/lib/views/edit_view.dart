import 'package:flutter/material.dart';
import 'package:todo_application/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_application/models/todo_list.dart';
import 'package:todo_application/view_models/todo_view_model.dart';

class EditView extends StatefulWidget {
  final ITodoViewModel iTodoViewModel;
  final TodoItem todoItem;

  EditView({@required this.iTodoViewModel, @required this.todoItem});

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
          style: iStyle.appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: iStyle.themeColor,
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
                    iStyle.themeColor,
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
              iMessage.updateTask,
              style: iStyle.headerTextStyle,
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
    //set initial value
    taskController.text = widget.todoItem.task;
    taskController.selection = TextSelection.collapsed(
      offset: taskController.text.length,
    );
    return Container(
      margin: EdgeInsets.all(20),
      child: TextField(
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
          labelText: iMessage.labelTask,
          hintStyle: iStyle.textFieldTextStyle,
          errorText: !validateTask ? errorMessageTask : null,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    //set initial value
    descriptionController.text = widget.todoItem.description;
    descriptionController.selection = TextSelection.collapsed(
      offset: descriptionController.text.length,
    );
    return Container(
      margin: EdgeInsets.all(20),
      child: TextFormField(
        maxLines: 2,
        controller: descriptionController,
        focusNode: descriptionFocusNode,
        onFieldSubmitted: (value) {
          descriptionController.text = value;
          taskFocusNode.unfocus();
        },
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: iMessage.labelDescription,
          hintStyle: iStyle.textFieldTextStyle,
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
        color: iStyle.themeColor,
        child: Text(
          iMessage.updateTask.toUpperCase(),
          style: iStyle.buttonTextStyle,
        ),
        onPressed: () {
          if (taskController.text.isEmpty) {
            setState(() {
              validateTask = false;
              errorMessageTask = iMessage.errorMessageTask;
            });
          } else {
            widget.iTodoViewModel.updateTask(
              id: widget.todoItem.id,
              task: taskController.text,
              description: descriptionController.text,
              isCompleted: widget.todoItem.isCompleted,
              onComplete: () {
                Navigator.pop(context);
              },
              onError: () {
                Navigator.pop(context);
              },
            );
          }
        },
      ),
    );
  }
}
