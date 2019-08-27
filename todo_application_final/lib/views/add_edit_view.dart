import 'package:flutter/material.dart';
import 'package:todo_application/enum.dart';
import 'package:todo_application/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_application/models/todo_list.dart';
import 'package:todo_application/view_models/todo_view_model.dart';
import 'package:todo_application/views/widget/appbar.dart';

class AddEditView extends StatefulWidget {
  final TodoViewModel todoViewModel;
  final TodoItem todoItem;
  final TaskType taskType;

  AddEditView({
    @required this.todoViewModel,
    this.todoItem,
    @required this.taskType,
  });

  @override
  State<StatefulWidget> createState() {
    return AddEditViewState();
  }
}

class AddEditViewState extends State<AddEditView> {
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
      appBar: buildAppBar(),
      body: ScopedModel<TodoViewModelImplementation>(
        model: widget.todoViewModel,
        child: ScopedModelDescendant<TodoViewModelImplementation>(
          builder: (context, child, model) {
            if (model.isLoading()) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    style.themeColor,
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

  Widget _buildBodyContent(TodoViewModel model) {
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
              widget.taskType == TaskType.ADD_TASK
                  ? message.createNewTask
                  : message.updateTask,
              style: style.headerTextStyle,
            ),
          ),
          _buildTaskField(),
          _buildDescriptionField(),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildTaskField() {
    //set initial value
    if (widget.taskType == TaskType.EDIT_TASK) {
      taskController.text = widget.todoItem.task;
      taskController.selection = TextSelection.collapsed(
        offset: taskController.text.length,
      );
    }

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
          labelText: message.labelTask,
          hintStyle: style.textFieldTextStyle,
          errorText: !validateTask ? errorMessageTask : null,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    //set initial value
    if (widget.taskType == TaskType.EDIT_TASK) {
      descriptionController.text = widget.todoItem.description;
      descriptionController.selection = TextSelection.collapsed(
        offset: descriptionController.text.length,
      );
    }

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
          labelText: message.labelDescription,
          hintStyle: style.textFieldTextStyle,
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: 150,
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        color: style.themeColor,
        child: Text(
          widget.taskType == TaskType.ADD_TASK
              ? message.addTask.toUpperCase()
              : message.update.toUpperCase(),
          style: style.buttonTextStyle,
        ),
        onPressed: () {
          performOperation();
        },
      ),
    );
  }

  void performOperation() {
    if (taskController.text.isEmpty) {
      setState(() {
        validateTask = false;
        errorMessageTask = message.errorMessageTask;
      });
    } else {
      if (widget.taskType == TaskType.ADD_TASK) {
        widget.todoViewModel.addTask(
          task: taskController.text,
          description: descriptionController.text,
          onComplete: () {
            Navigator.pop(context, true);
          },
          onError: () {
            Navigator.pop(context, true);
          },
        );
      } else {
        widget.todoViewModel.updateTask(
          id: widget.todoItem.id,
          task: taskController.text,
          description: descriptionController.text,
          isCompleted: widget.todoItem.isCompleted,
          onComplete: () {
            Navigator.pop(context, true);
          },
          onError: () {
            Navigator.pop(context, true);
          },
        );
      }
    }
  }
}
