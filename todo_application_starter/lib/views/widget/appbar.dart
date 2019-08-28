import 'package:flutter/material.dart';
import 'package:todo_application/main.dart';

Widget buildAppBar() {
  return AppBar(
    title: Text(
      message.appBarTitle,
      style: style.appBarTextStyle,
    ),
    centerTitle: true,
    backgroundColor: style.themeColor,
    elevation: 10,
  );
}
