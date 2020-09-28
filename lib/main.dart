import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Homepage'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Image.asset('Image/IMG_0228.jpg'),
              Text('Hi! My name is Rachel Huang and I am a computer science major from Wheaton, Illinois. I am on campus this semester and I am living in ISR. I am excited to be a part of CS 196! '),
            ],
          )
        ),
      ),
    );
  }
}