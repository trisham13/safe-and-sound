import 'package:flutter/material.dart';

void main() => runApp(Updates());

class Updates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe and Sound',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Updates'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text('     Near Me:')),
          Expanded(child: Text('     Near Home:')),
          Expanded(child: Text('     Near Work:')),
          Flexible(
              child: TextFormField(
            decoration: const InputDecoration(labelText: '     Near:'),
          )),
        ]),
      ),
    );
  }
}
