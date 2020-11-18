import 'package:http/http.dart' as http;

/**
 * adds a crime to the firebase database
 *
 * takes in a description of the crime, the location, and its category
 * the location should be a list of length 2, with the first item being
 *  latitude, and the second being longitude
 *
 */
Future<bool> addToFirebase(String crimeDescription, List location,
    String crimeCategory) async {
  var url = 'http://localhost:5000/insert-map-data';
  var response = await http.post(url,
      body: { 'crime_category': crimeCategory,
              'crime_description': crimeDescription,
              'location' : "(" + location[0] + ", " + location[1] + ")"});
  // print('Response status: ${response.statusCode}');

  return response.statusCode == 200; // 200 means everything went OK
}



