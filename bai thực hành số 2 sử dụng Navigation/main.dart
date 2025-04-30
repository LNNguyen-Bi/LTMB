import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('màn hình 1'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Điều hướng đến SecondScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            );
          },
          child: Text('đi đến màn hình 2'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('màn hình 2'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Quay lại FirstScreen
            Navigator.pop(context);
          },
          child: Text('trở về màn hình 1'),
        ),
      ),
    );
  }
}