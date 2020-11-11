import json

from flask import Flask, jsonify, request, render_template
from flask_cors import CORS
import googlemaps
import pyrebase

import config
import directions
from parse_crimes import parse_crimes


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


@app.route('/')  # http://localhost:5000/
def home():
    return db.child("userCrimes").get().val()


@app.route('/json-example')  # http://localhost:5000/json-example
def json_example():
    d = {}
    d['example'] = 'value'
    return json.dumps(d)  # Will return the dict as JSON


# Gets data from urbana crime data API and displays it as a JSON
@app.route('/crime')
def crime():
    return jsonify(parse_crimes())

# Access to html file with '/crime-map'
@app.route('/crime-map')
def crime_map():
    return render_template('test-maps.html')


# Returns the most optimal route from location A to B 
# 'location_from' and 'location_to' query params need to be in the format 'x,y'
#   aka, params need to be strings
@app.route('/get-directions')
def get_directions():
    query_args = request.args # query params

    # Calls method in directions.py with 'from' and 'to' locations
    return directions.get_best_route(query_args.get('location_from'), query_args.get('location_to'))

@app.route('/get-map-data')
def get_map_data():
    query_args = request.args # query params
    return directions.get_map_data(query_args.get('location_from'), query_args.get('location_to'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)  # Saving file will reload the server
