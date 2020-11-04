import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/pages/savedLocations_1.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      color: Color(0xff74a1c3), fontSize: 20, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      '// Index 0: DIRECTIONS',
      style: optionStyle,
    ),
    Text(
      '// Index 1: REPORT',
      style: optionStyle,
    ),
    Text(
      '// Index 2: MY PLACES',
      style: optionStyle,
    ),
    Text(
      '// Index 3: UPDATES',
      style: optionStyle,
    ),
    Text(
      '// Index 4: SETTINGS',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SavedLocations()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'S a f e  &  S o u n d',
          textAlign: TextAlign.center,
          style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 30)),
        ),
        backgroundColor: Color(0xff74a1c3),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'DIRECTIONS',
              backgroundColor: Color(0xff74a1c3)),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'REPORT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key),
            label: 'MY PLACES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'UPDATES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'SETTINGS',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}