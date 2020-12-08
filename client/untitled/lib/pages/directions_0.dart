import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:untitled/pages/secrets.dart';
import 'package:http/http.dart' as http;

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

  String _startPoint = '';
  String _endPoint = '';

  Set<Marker> markers = {};

  final TextEditingController startPointController = TextEditingController();
  final TextEditingController endPointController = TextEditingController();

  final FocusNode startFocusNode = FocusNode();
  final FocusNode endFocusNode = FocusNode();

  List<String> distance = [];
  List<String> time = [];

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  List<String> travelModes = ['Walk', 'Bike', 'Bus', 'Car'];

  Future<bool> getMarkers() async {
    try {
      // Retrieving placemarks from addresses
      markers.clear();
      polylines.clear();
      distance.clear();
      time.clear();
      polylineCoordinates.clear();

      List<String> latLongStart = _startPoint.split(",");
      List<String> latLongEnd = _endPoint.split(",");

      //List<Location> startPointer = await locationFromAddress(_startPoint);
      //List<Location> endPointer = await locationFromAddress(_endPoint);

      if (_startPoint != null && _endPoint != null) {
        Position startCoordinates = Position(
            latitude: double.parse(latLongStart[0]),
            longitude: double.parse(latLongStart[1]),
        );
        Position endCoordinates = Position(
            latitude: double.parse(latLongEnd[0]),
            longitude: double.parse(latLongEnd[1]),
        );

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
        await _createPolylines(startCoordinates, endCoordinates);
        await _getDistance(startCoordinates, endCoordinates);
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

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  _getDistance(Position start, Position destination) async {
    List<String> travel = ['walking', 'bicycling', 'transit', 'driving'];
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${start.latitude},${start.longitude}&destinations=${destination.latitude},${destination.longitude}&key=${Secrets.API_KEY}";
    print(url);
    for (var i = 0; i < travel.length; i++) {
      final response = await http.get(url + '&mode=${travel[i]}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var value = data['rows'][0]['elements'][0];
        if (value["status"] == 'OK') {
          distance.add(value['distance']['text'] ?? '');
          time.add(value['duration']['text'] ?? '');
        } else {
          distance.add('');
          time.add('');
        }
      }
    }
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
            color: Color(0xff74a1c3),
            child: SafeArea(
              top: true,
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
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
                              contentPadding: EdgeInsets.all(4),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.location_on)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
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
                              contentPadding: EdgeInsets.all(4),
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
                    //Four mid buttons
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      travelModes.length,
                          (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              Chip(label: Text(travelModes[index])),
                              distance.isNotEmpty
                                  ? Text(
                                distance[index],
                                textAlign: TextAlign.center,
                              )
                                  : SizedBox(),
                              time.isNotEmpty
                                  ? Text(
                                time[index],
                                textAlign: TextAlign.center,
                              )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    //Map button. Use after cords inputted.
                    color: Colors.grey,
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
              polylines: Set<Polyline>.of(polylines.values),
              markers: markers != null ? Set<Marker>.from(markers) : null,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              myLocationButtonEnabled: false,
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
