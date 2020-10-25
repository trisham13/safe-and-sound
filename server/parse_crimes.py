import json
import dateutil.parser
import pyrebase
import config
import requests

# Set up Firebase
firebase_config = {
    "apiKey": config.firebase_api_key,
    "authDomain": "fa20team3project.firebaseapp.com",
    "databaseURL": "https://fa20team3project.firebaseio.com/",
    "storageBucket": "fa20team3project.appspot.com"
}
firebase = pyrebase.initialize_app(firebase_config)
db = firebase.database()

# Get crimes from Urbana crime API
def get_crime():
    year_to_search = 2020
    data_params = {'$where': 'year_occurred = {}'.format(year_to_search)}

    # Use Urbana data and search JSON file for crimes from specified year
    crime_data = requests.get('https://data.urbanaillinois.us/resource/uj4k-8xe8.json',
                              params=data_params).text

    return crime_data


"""
Get most important info from Urbana crime API
as well as user-submitted crimes from Firebase database.

Returns a list of dicts; each dict is of form:
{
    "crime_category": "Category",
    "crime_description": "DESCRIPTION",
    "date_reported": "mm/dd/yyyy",
    "location": {
        "latitude": "12.345678",
        "longitude": "12.345678"
    },
    "source": "####_crime_database"
}
(where #### is either "user" or "urbana")
"""
def parse_crimes():
    # Load Urbana crimes
    crime_data = json.loads(get_crime())

    # Create new list for all the crimes
    formatted_crimes = []

    # Urbana crimes:
    for crime in crime_data:
        # Skip to next crime if this one doesn't have an address or location
        if 'mapping_address' not in crime:
            continue
        if 'latitude' not in crime['mapping_address']:
            continue

        # Keep relevant information, add crime to formatted_crimes
        formatted_crimes.append({
            'crime_category': crime['crime_category_description'],
            'crime_description': crime['crime_description'],
            'date_reported': dateutil.parser.parse(crime['date_reported']).strftime("%m/%d/%Y"),
            'location': {
                'latitude': crime['mapping_address']['latitude'],
                'longitude': crime['mapping_address']['longitude']
            },
            'source': 'urbana_crime_database'
        })

    # User-submitted crimes:
    for crime in db.child("userCrimes").get().val():
        formatted_crimes.append(crime)

    # Sort all by date_reported
    formatted_crimes = sorted(
        formatted_crimes, key=lambda x: x['date_reported'])

    return formatted_crimes
