import 'package:flutter/material.dart';
import 'package:todo_application/dependency_injection.dart';
import 'package:todo_application/views/home_view.dart';

void main(){
  //Configure dependencies here
  DependencyInjection().configureDependency();
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
