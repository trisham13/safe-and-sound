import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/rendering.dart';

//void main() => runApp(MyApp());


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Report';

  /*
  @override
  public void onCreate() {
    super.onCreate();
    FirebaseApp.initializeApp(this);
  }

   */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report',
            style: GoogleFonts.teko(
                textStyle: TextStyle(color: Color(0xff74a1c3), fontSize: 30)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Type of crime:',
                textAlign: TextAlign.left,
                style: GoogleFonts.teko(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 3,
                  fontSize: 20,
                )),
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
        children: <Widget>[
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              hintText: '     Location',
            ),
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
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
              hintText: '     Time',
            ),
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                  child: Text('Submit', style: GoogleFonts.teko()),
                ),
              ),
            ],
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


