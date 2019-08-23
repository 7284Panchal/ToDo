import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:todo_application/dependency_injection.dart';
import 'package:todo_application/style.dart';
import 'package:todo_application/views/message.dart';
import 'package:todo_application/views/home_view.dart';

IStyle iStyle;
IMessage iMessage;

void main(){
  //Configure dependencies here
  DependencyInjection().configureDependency();

  iStyle = Injector.getInjector().get<IStyle>();
  iMessage = Injector.getInjector().get<IMessage>();
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF17914A),
        cursorColor: Color(0xFF17914A),
      ),
      title: 'Todo',
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
