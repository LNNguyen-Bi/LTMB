import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Display App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('load image demo'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Image.asset('assets/images/1.png'),
              ),
              Expanded(
                child: Image.asset('assets/images/2.png'),
              ),
              Expanded(
                child: Image.asset('assets/images/3.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}