import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(SavedLocations());

class SavedLocations extends StatefulWidget {
  @override
  _SavedLocationsState createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {

  static List<Widget> dynamicList;

  @override
  // ignore: override_on_non_overriding_member
  initState() {
    super.initState();
    dynamicList = [new LocationWidget()];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe and Sound',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'S a v e d  L o c a t i o n s',
            textAlign: TextAlign.center,
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 30)),
          ),
          backgroundColor: Color(0xff74a1c3),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
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
              )
            )
          ]
        ),
      ),
    );
  }
  addLocation(){
    dynamicList.add(new LocationWidget());
    setState(() { });
  }
}

class LocationWidget extends StatelessWidget {
  
  final nameController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column (
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Work',
            ),
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
          ),
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: startController,
                  decoration: const InputDecoration(
                    labelText: 'Starting Point',
                    hintText: '196 Tech Way',
                    prefixIcon: Icon(Icons.location_pin)
                  ),
                  style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
                ),
              ),
              Flexible(
                child: TextField(
                  controller: endController,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    hintText: '100 Grade Lane',
                    prefixIcon: Icon(Icons.location_pin)
                  ),
                  style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
          OutlinedButton(
            child: Text("Submit"),
            onPressed: () async {
              saveLocation(nameController.text ?? "", startController.text ?? "", endController.text ?? "");
              SharedPreferences prefs = await SharedPreferences.getInstance();
              print(prefs.getStringList(nameController.text) ?? "");
            }
          )
        ]
      )
    );
  }
  saveLocation(String name, String start, String end) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> route = <String>[start, end];
    prefs.setStringList(name, route);
  }
}
