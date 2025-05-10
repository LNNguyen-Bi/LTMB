import 'package:flutter/material.dart';
import 'controllers/user_controller.dart';
import 'models/user.dart';
import 'views/login_view.dart';
import 'views/task_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserController _userController = UserController();
  User? _loggedUser ;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkLoggedUser ();
  }

  Future<void> _checkLoggedUser () async {
    final user = await _userController.getLoggedUser ();
    setState(() {
      _loggedUser  = user;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return MaterialApp(
      title: 'Flutter Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _loggedUser  == null
          ? LoginView()
          : TaskListView(key: ValueKey(_loggedUser !.id)),
    );
  }
}