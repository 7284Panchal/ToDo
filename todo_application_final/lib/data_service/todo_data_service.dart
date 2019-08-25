import 'package:flutter/material.dart';
import 'package:todo_application/data/preference_helper.dart';
import 'package:todo_application/models/todo_list.dart';

abstract class ITodoDataService {
  Future<TodoList> getTodoList();

  Future<bool> setTodoList({TodoList todoList});
}

class TodoDataService implements ITodoDataService {
  IPreferenceHelper iPreferenceHelper;

  TodoDataService({@required this.iPreferenceHelper});

  @override
  Future<TodoList> getTodoList() async {
    //get existing todoTaskList
    String todoListString = await iPreferenceHelper.getString(
        key: PreferenceKeys.preferenceKeyTodoList);

    TodoList todoList;
    //if todoTaskList is empty then initialize todoList
    //else load existing data into todoList
    if (todoListString == null) {
      todoList = TodoList(todoItems: List());
    } else {
      todoList = todoListFromJson(todoListString);
    }
    return todoList;
  }

    @override
  Future<bool> setTodoList({TodoList todoList}) async {
    //covert list in to string to store in preference
    String todoListString = todoListToJson(todoList);

    return await iPreferenceHelper.set(
        key: PreferenceKeys.preferenceKeyTodoList, value: todoListString);
  }
}
