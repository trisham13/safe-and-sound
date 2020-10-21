from flask import Flask
from flask_cors import CORS
from flask import request
from flask import render_template
import config
import json
import googlemaps
import requests
import pyrebase
import directions

# Google Maps API client -- everything goes through here
# email and password for associated account in Discord
gmaps = googlemaps.Client(key=config.maps_api_key)

app = Flask(__name__)

firebase_config = {
  "apiKey": config.firebase_api_key,
  "authDomain": "fa20team3project.firebaseapp.com",
  "databaseURL": "https://fa20team3project.firebaseio.com/",
  "storageBucket": "fa20team3project.appspot.com"
}

firebase = pyrebase.initialize_app(firebase_config)
db = firebase.database()

# Allows '/crime-map' to access data from '/crime'
CORS(app, resources={r"/*": {"origins": "*"}})


@app.route('/')  # https://localhost:5000/
def home():
    return db.child("userCrimes").get().val()


@app.route('/json-example')  # https://localhost:5000/json-example
def json_example():
    d = {}
    d['example'] = 'value'
    return json.dumps(d)  # Will return the dict as JSON


# Gets data from urbana crime data API and displays it as a JSON
@app.route('/crime')
def crime():
    # You can use a 'year' param (e.g., http://localhost:5000/crime?year=2015 etc.)
    year_to_search = request.args.get('year')

    # Search for data from 2020 if year is unspecified
    if year_to_search == None:
        year_to_search = 2020
    data_params = {'$where': 'year_occurred = {}'.format(year_to_search)}

    # Use Urbana data and search JSON file for crimes from specified year
    crime_data = requests.get('https://data.urbanaillinois.us/resource/uj4k-8xe8.json',
                              params=data_params).text
    return crime_data

# Access to html file with '/crime-map'
@app.route('/crime-map')
def crime_map():
    return render_template('test-maps.html')


# Returns the most optimal route from location A to B 
# 'location_from' and 'location_to' query params need to be in the format 'x, y'
#   aka, params need to be strings
@app.route('/get-directions')
def get_directions():
    query_args = request.args # query params

    # Calls method in directions.py with 'from' and 'to' locations
    return directions.get_route_by_min_crimes(query_args.get('location_from'), query_args.get('location_to'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)  # Saving file will reload the server
