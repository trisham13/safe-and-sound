import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:untitled/pages/shareInfo_2.dart';
import 'package:untitled/pages/directions_0.dart';
import 'package:untitled/pages/updatedInfo_3.dart';
import 'package:untitled/pages/savedLocations_1.dart';

void main() => runApp(MainPage());

/// This is the main application widget.
class MainPage extends StatelessWidget {
  static const String _title = 'Safe&Sound';

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

  final List<Widget> _widgetOptions = [
    DirectionsPage(),
    ShareInfoPage(),
    SavedLocations(),
    Updates(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'S a f e & S o u n d',
          textAlign: TextAlign.center,
          style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 30)),
        ),
        backgroundColor: Color(0xff74a1c3),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff74a1c3),
        type: BottomNavigationBarType.fixed,
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
