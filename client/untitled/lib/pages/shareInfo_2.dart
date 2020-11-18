import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Report';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: Column(
              children: <Widget>[
                Text(
                    'Type of crime:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 3, fontSize: 20),
                ),
                ReportBar(),
                CrimeInfo()
              ],
          ),
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class ReportBar extends StatefulWidget {
  ReportBar({Key key}) : super(key: key);

  @override
  _ReportBarState createState() => _ReportBarState();
}
String crimeType = 'theft';
/// This is the private State class that goes with MyStatefulWidget.
class _ReportBarState extends State<ReportBar> {
  String dropdownValue = 'Theft';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      //style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          crimeType = newValue;
        });
      },
      items: <String>['Theft', 'Assault', 'Burglary', 'Arrest', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
class CrimeInfo extends StatefulWidget {
  CrimeInfo({Key key}) : super(key: key);

  @override
  _CrimeInfoState createState() => _CrimeInfoState();
}

class _CrimeInfoState extends State<CrimeInfo> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              hintText: 'Location',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: timeController,
            decoration: const InputDecoration(
              hintText: 'Time',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
                  createRecord();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void createRecord(){
    databaseReference.child("userCrimes from shareInfo").set({
      'crime' + timeController.text :{
        'Location': locationController.text,
        'Time': timeController.text,
        'Type': crimeType
      }
    });
  }
}


