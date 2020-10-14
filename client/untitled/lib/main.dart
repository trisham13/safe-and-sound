import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.explore, 'DIRECTIONS'),
          //_buildButtonColumn(color, Icons.assistant_navigation, 'DIRECTIONS'),
          _buildButtonColumn(color, Icons.report, 'REPORT'),
          _buildButtonColumn(color, Icons.vpn_key, 'MY PLACES'),
          _buildButtonColumn(color, Icons.update, 'UPDATES'),
          _buildButtonColumn(color, Icons.settings, 'SETTINGS'),
        ],
      ),
    );
    return MaterialApp(
      title: 'HomePage',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Safe & Sound'),
        ),
        body: Column(
          children: [
            buttonSection,
          ],
        ),
      ),
    );
  } // Widget

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
