import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class SavedLocations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe and Sound',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Saved Locations'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              IconButton(
                onPressed: () { },
                alignment: Alignment.topRight,
                icon: Icon(Icons.add),
                tooltip: 'Add a new Location',
              ),
              Container(
                  child: Column (
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Work',
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Starting Point',
                                  hintText: '196 Tech Way',
                                ),
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Destination',
                                  hintText: '100 Grade Lane',
                                ),
                              ),
                            )
                          ],
                        )
                      ]
                  )
              )
            ]
        ),
      ),
    );
  }
}

/*
class SavedLocations extends StatefulWidget {
  @override
  _SavedLocationsState createState() =>
      new _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> _locations = new List.generate(_count, (int i) => new Location());
    return MaterialApp(
      title: 'Safe and Sound',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Saved Locations'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              IconButton(
                onPressed: _addNewLocation(),
                alignment: Alignment.topRight,
                icon: Icon(Icons.add),
                tooltip: 'Add a new Location',
              ),
              ListView(
                children: _locations,
              )
            ]
        ),
      ),
    );
  }
  _addNewLocation() {
    setState(() {
      _count = _count + 1;
    });
  }
}

class Location extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Location();
}

class _Location extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        child:
        new Column(
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Name',
                ),
              ),
              new Row(
                children: [
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Starting Point',
                    ),
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Destination',
                    ),
                  )
                ],
              )
            ]
        )
    );
  }
}*/
