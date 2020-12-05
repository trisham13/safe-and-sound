import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(SavedLocations());

class SavedLocations extends StatefulWidget {
  @override
  _SavedLocationsState createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {
  List<Widget> dynamicList;
  List<String> litem;

  @override
  initState() {
    super.initState();
    dynamicList = [new LocationWidget()];
    litem = ["Test1", "Test2", "Test4", "Test5", "Test6", "Test7", "Test8"];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe and Sound',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Saved Locations',
            style: GoogleFonts.teko(
                textStyle: TextStyle(color: Color(0xff74a1c3), fontSize: 30)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                onPressed: addLocation,
                alignment: Alignment.topRight,
                icon: Icon(Icons.add),
                tooltip: 'Add a new Location',
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: dynamicList.length,
                itemBuilder: (context, index) {
                  return dynamicList[index];
                },
              ))
            ]),
      ),
    );
  }

  addLocation() {
    dynamicList.add(new LocationWidget());
    setState(() {});
  }
}

class LocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      TextFormField(
        decoration: const InputDecoration(
          labelText: '    Name',
          hintText: '     Work',
        ),
        style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
      ),
      Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Starting Point',
                  hintText: '196 Tech Way',
                  prefixIcon: Icon(Icons.location_pin)),
              style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
            ),
          ),
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Destination',
                  hintText: '100 Grade Lane',
                  prefixIcon: Icon(Icons.location_pin)),
              style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
            ),
          )
        ],
      )
    ]));
  }
}
