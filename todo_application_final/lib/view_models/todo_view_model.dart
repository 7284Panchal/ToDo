import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_application/data_service/todo_data_service.dart';
import 'package:todo_application/models/todo_list.dart';
import 'package:todo_application/main.dart';

abstract class TodoViewModel {
  bool isLoading();

  String getMessage();

  int getTodoListCount();

  TodoList getTodoList();

  void loadTodoList();

  void addTask({
    String task,
    String description,
    VoidCallback onComplete,
    VoidCallback onError,
  });

  void updateTask({
    int id,
    String task,
    String description,
    bool isCompleted,
    VoidCallback onComplete,
    VoidCallback onError,
  });

  void updateTaskStatus({
    int id,
    bool isCompleted,
  });

  void deleteTask({
    int id,
    VoidCallback onComplete,
    VoidCallback onError,
  });
}

class TodoViewModelImplementation extends Model with TodoViewModel {
  TodoDataService todoDataService;

  TodoViewModelImplementation({@required this.todoDataService});

  bool _isLoading = true; //default false

  String _message = ""; //default empty to prevent null exception on Text widget

  TodoList _todoList;

  @override
  bool isLoading() {
    return _isLoading;
  }

  @override
  String getMessage() {
    return _message;
  }

  @override
  int getTodoListCount() {
    return _todoList.todoItems.length;
  }

  @override
  TodoList getTodoList() {
    return _todoList;
  }

  @override
  void loadTodoList() async {
    _isLoading = true;
    notifyListeners();

    _todoList = await todoDataService.getTodoList();
    _message = message.taskLoaded;

    _isLoading = false;
    notifyListeners();
  }

  @override
  void addTask({
    String task,
    String description,
    VoidCallback onComplete,
    VoidCallback onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    //get unique id for todoItem
    int id = DateTime.now().millisecondsSinceEpoch;

    //create todoItem for the data
    TodoItem todoItem = TodoItem(
        id: id, task: task, description: description, isCompleted: false);

    //add todoItem in to todoList
    _todoList.todoItems.add(todoItem);

    bool result = await todoDataService.setTodoList(todoList: _todoList);

    if (result) {
      _message = message.taskCreated;
      _isLoading = false;
      notifyListeners();
      onComplete();
    } else {
      _message = message.processingError;
      _isLoading = false;
      notifyListeners();
      onError();
    }
  }

  @override
  void updateTaskStatus({int id, bool isCompleted}) async {
    //get index of todoItem with matching id
    int index = _todoList.todoItems.indexWhere((todoItem) => todoItem.id == id);

    _todoList.todoItems.elementAt(index).isCompleted = isCompleted;

    await todoDataService.setTodoList(todoList: _todoList);

    _message = message.taskUpdated;
  }

  @override
  void updateTask({
    int id,
    String task,
    String description,
    bool isCompleted,
    VoidCallback onComplete,
    VoidCallback onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    //get index of todoItem with matching id
    int index = _todoList.todoItems.indexWhere((todoItem) => todoItem.id == id);

    //update todoItem with new data
    _todoList.todoItems.elementAt(index).task = task;
    _todoList.todoItems.elementAt(index).description = description;
    _todoList.todoItems.elementAt(index).isCompleted = isCompleted;

    bool result = await todoDataService.setTodoList(todoList: _todoList);

    if (result) {
      _message = message.taskUpdated;
      _isLoading = false;
      notifyListeners();
      onComplete();
    } else {
      _message = message.processingError;
      _isLoading = false;
      notifyListeners();
      onError();
    }
  }

  @override
  void deleteTask({
    int id,
    VoidCallback onComplete,
    VoidCallback onError,
  }) async {
    //remove todoItem with matching id
    _todoList.todoItems.removeWhere((todoItem) => todoItem.id == id);

    bool result = await todoDataService.setTodoList(todoList: _todoList);

    if (result) {
      _message = message.taskDeleted;
      onComplete();
    } else {
      _message = message.processingError;
      onError();
    }
  }
}
