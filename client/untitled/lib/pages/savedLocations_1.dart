import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(SavedLocations());

class SavedLocations extends StatefulWidget {
  @override
  _SavedLocationsState createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {

  List<LocationWidget> dynamicList = [];

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
              Column (
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Work',
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
                            ),
                            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Destination',
                              hintText: '100 Grade Lane',
                            ),
                            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
                          ),
                        )
                      ],
                    )
                  ]
              ),
              ListView.builder(
                itemCount: dynamicList.length,
                itemBuilder: (_, index) => dynamicList[index],
              )
            ]
        ),
      ),
    );
  }
  addLocation(){
    setState(() {});
    dynamicList.add(new LocationWidget());
  }
}

class LocationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column (
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Work',
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
                      ),
                      style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Destination',
                        hintText: '100 Grade Lane',
                      ),
                      style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
                    ),
                  )
                ],
              )
            ]
        )
    );
  }
}
