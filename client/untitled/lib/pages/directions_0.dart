import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(DirectionView());

class DirectionView extends StatefulWidget {
  @override
  _DirectionViewState createState() => _DirectionViewState();
}

class _DirectionViewState extends State<DirectionView> {
  GoogleMapController _controller;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> markers = {};

  final TextEditingController startPointController = TextEditingController();
  final TextEditingController endPointController = TextEditingController();

  final FocusNode startFocusNode = FocusNode();
  final FocusNode endFocusNode = FocusNode();

  String _startPoint = '';
  String _endPoint = '';

  Future<bool> getMarkers() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPointer = await locationFromAddress(_startPoint);
      List<Location> endPointer = await locationFromAddress(_endPoint);

      if (startPointer != null && endPointer != null) {
        Position startCoordinates = Position(
            latitude: startPointer[0].latitude,
            longitude: startPointer[0].longitude);
        Position endCoordinates = Position(
            latitude: endPointer[0].latitude,
            longitude: endPointer[0].longitude);

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startPoint,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$endCoordinates'),
          position: LatLng(
            endCoordinates.latitude,
            endCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _endPoint,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny = (startCoordinates.latitude <= endCoordinates.latitude)
            ? startCoordinates.latitude
            : endCoordinates.latitude;
        double minx = (startCoordinates.longitude <= endCoordinates.longitude)
            ? startCoordinates.longitude
            : endCoordinates.longitude;
        double maxy = (startCoordinates.latitude <= endCoordinates.latitude)
            ? endCoordinates.latitude
            : startCoordinates.latitude;
        double maxx = (startCoordinates.longitude <= endCoordinates.longitude)
            ? endCoordinates.longitude
            : startCoordinates.longitude;

        _southwestCoordinates = Position(latitude: miny, longitude: minx);
        _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

        // Accommodate the two locations within the
        // camera view of the map
        _controller.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );
        setState(() {});
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Directions',
          style: GoogleFonts.teko(
              textStyle: TextStyle(color: Color(0xff74a1c3), fontSize: 30)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey[400],
            child: SafeArea(
              top: true,
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Starting Point',
                        style: GoogleFonts.teko(
                            textStyle: TextStyle(color: Colors.white),
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          focusNode: startFocusNode,
                          controller: startPointController,
                          onChanged: (value) {
                            setState(() {
                              _startPoint = value;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.location_on)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Ending Point',
                          style: GoogleFonts.teko(
                              textStyle: TextStyle(color: Colors.white),
                              fontSize: 20)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          focusNode: endFocusNode,
                          controller: endPointController,
                          onChanged: (value) {
                            setState(() {
                              _endPoint = value;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.location_on)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    //Four mid buttons
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Chip(
                          label: Text(
                        'Walk',
                        style: GoogleFonts.teko(
                            textStyle: TextStyle(color: Colors.black)),
                      )),
                      Chip(
                          label: Text('Bike',
                              style: GoogleFonts.teko(
                                  textStyle: TextStyle(color: Colors.black)))),
                      Chip(
                          label: Text('Bus',
                              style: GoogleFonts.teko(
                                  textStyle: TextStyle(color: Colors.black)))),
                      Chip(
                          label: Text('Car',
                              style: GoogleFonts.teko(
                                  textStyle: TextStyle(color: Colors.black)))),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    //Map button. Use after cords inputted.
                    color: Colors.teal,
                    onPressed: (_startPoint != '' && _endPoint != '')
                        ? () async {
                            startFocusNode.unfocus();
                            endFocusNode.unfocus();
                            setState(() {
                              if (markers.isNotEmpty) markers.clear();
                            });

                            getMarkers();
                          }
                        : () {},
                    child: Text(
                      'Map',
                      style: GoogleFonts.teko(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
