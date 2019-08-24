import 'package:flutter/material.dart';
import 'package:todo_application/main.dart';
import 'package:todo_application/views/add_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "To do",
          style: iStyle.appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: iStyle.themeColor,
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          ).then((value) {});
        },
        backgroundColor: iStyle.themeColor,
        child: Icon(
          Icons.add,
        ),
        tooltip: iMessage.createNewTask,
      ),
    );
  }

  showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: iStyle.themeColor,
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }
}
