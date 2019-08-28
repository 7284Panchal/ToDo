import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:todo_application/dependency_injection.dart';
import 'package:todo_application/style.dart';
import 'package:todo_application/message.dart';
import 'package:todo_application/views/home_view.dart';

Style style;
Message message;

void main() {
  //Configure dependencies here
  DependencyInjection().configureDependency();

  //get style and message reference which will used in whole app
  style = Injector.getInjector().get<Style>();
  message = Injector.getInjector().get<Message>();
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: style.themeColor,
        cursorColor: style.themeColor,
      ),
      title: message.appBarTitle,
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
