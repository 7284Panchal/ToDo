import 'package:flutter/material.dart';
import 'package:todo_application/models/todo_list.dart';
import 'package:todo_application/main.dart';

class TodoListItem extends StatelessWidget {
  final TodoItem todoItem;
  final Function(bool value) onStatusChange;
  final Function onDelete;
  final Function onItemClick;

  TodoListItem({
    @required this.todoItem,
    @required this.onStatusChange,
    @required this.onDelete,
    @required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            todoItem.task,
            style: todoItem.isCompleted
                ? style.titleDoneTextStyle
                : style.titleTextStyle,
          ),
          subtitle: Text(
            todoItem.description,
            style: style.subTitleTextStyle,
          ),
          leading: Checkbox(
            activeColor: style.themeColor,
            value: todoItem.isCompleted,
            onChanged: (value) {
              onStatusChange(value);
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_forever,
            ),
            onPressed: () {
              onDelete();
            },
          ),
          isThreeLine: true,
          onTap: () async {
            onItemClick();
          },
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
