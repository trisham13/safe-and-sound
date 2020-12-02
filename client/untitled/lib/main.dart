import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// import 'package:intent/intent.dart' as android_intent;
// import 'package:intent/action.dart' as android_action;

import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Default Font',
        theme: ThemeData(fontFamily: 'teko'),
        home: Home());
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(250, 250),
                child: ClipOval(
                  child: Material(
                    color: Color(0xff4eb14e), //0xff58a758
                    child: InkWell(
                      splashColor: Colors.red,
                      onLongPress: () async {
                        FlutterPhoneDirectCaller.callNumber("911");
                      }, //_launchURL, // () => launch('tel://911')
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.call, size: 100.0),
                          Text(
                            "911",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.teko(
                                textStyle: TextStyle(fontSize: 50)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        label: Text(
          '     S T A R T     ',
          style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
        ),
        backgroundColor: Color(0xff74a1c3),
        onPressed: () {}, // to page_0
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu, color: Color(0x00000000)),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search, color: Color(0x00000000)),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

/*
_callNumber() async {
  const number = '911'; //set the number here
  bool res = await FlutterPhoneDirectCaller.callNumber(number);
} */

/*
_launchURL() async {
  // Replace 12345678 with your tel. no.

  android_intent.Intent()
    ..setAction(android_action.Action.ACTION_CALL)
    ..setData(Uri(scheme: "tel", path: "9375459038"))
    ..startActivity().catchError((e) => print(e));
}*/
