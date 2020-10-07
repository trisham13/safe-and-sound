from flask import Flask
from flask_cors import CORS
from flask import request
from flask import render_template
import json
import googlemaps
import requests

# Google Maps API client -- everything goes through here
# email and password for associated account in Discord
gmaps = googlemaps.Client(key="***REMOVED***")

app = Flask(__name__)

# Allows '/crime-map' to access data from '/crime'
CORS(app, resources={r"/*": {"origins": "*"}})


@app.route('/')  # https://localhost:5000/
def home():
    return "Hey there!"


@app.route('/json-example')  # https://localhost:5000/json-example
def json_example():
    d = {}
    d['example'] = 'value'
    return json.dumps(d)  # Will return the dict as JSON


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


@ app.route('/crime-map')
# Access to html file with '/crime-map'
def crime_map():
    return render_template('test-maps.html')


if __name__ == '__main__':
    app.run(debug=True)  # saving file will reload the server
