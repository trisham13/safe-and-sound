import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(Updates());

class Updates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe and Sound',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Updates',
            style: GoogleFonts.teko(
                textStyle: TextStyle(color: Color(0xff74a1c3), fontSize: 30)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Text(
            '     Near Me:',
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
          )),
          Expanded(
              child: Text(
            '     Near Home:',
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
          )),
          Expanded(
              child: Text(
            '     Near Work:',
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
          )),
          Flexible(
              child: TextFormField(
            decoration: const InputDecoration(
              labelText: '     Near:',
            ),
            style: GoogleFonts.teko(textStyle: TextStyle(fontSize: 20)),
          )),
        ]),
      ),
    );
  }
}
