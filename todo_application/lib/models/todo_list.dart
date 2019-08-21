// To parse this JSON data, do
//
//     final todoList = todoListFromJson(jsonString);

import 'dart:convert';

TodoList todoListFromJson(String str) => TodoList.fromJson(json.decode(str));

String todoListToJson(TodoList data) => json.encode(data.toJson());

class TodoList {
  List<TodoItem> todoItems;

  TodoList({
    this.todoItems,
  });

  factory TodoList.fromJson(Map<String, dynamic> json) => new TodoList(
    todoItems: json["todoItems"] == null ? null : new List<TodoItem>.from(json["todoItems"].map((x) => TodoItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "todoItems": todoItems == null ? null : new List<dynamic>.from(todoItems.map((x) => x.toJson())),
  };
}

class TodoItem {
  int id;
  bool isCompleted;
  String task;
  String description;

  TodoItem({
    this.id,
    this.isCompleted,
    this.task,
    this.description,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) => new TodoItem(
    id: json["id"] == null ? null : json["id"],
    isCompleted: json["isCompleted"] == null ? null : json["isCompleted"],
    task: json["task"] == null ? null : json["task"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "isCompleted": isCompleted == null ? null : isCompleted,
    "task": task == null ? null : task,
    "description": description == null ? null : description,
  };
}
