import json
from datetime import datetime
import dateutil.parser
import pyrebase
import requests
import config
import danger_levels

# Set up Firebase
firebase_config = {
    "apiKey": config.firebase_api_key,
    "authDomain": "fa20team3project.firebaseapp.com",
    "databaseURL": "https://fa20team3project.firebaseio.com/",
    "storageBucket": "fa20team3project.appspot.com"
}
firebase = pyrebase.initialize_app(firebase_config)
db = firebase.database()


def get_crime():
    """Gets crimes from Urbana crime API: https://data.urbanaillinois.us/resource/uj4k-8xe8.json"""
    year_to_search = 2020
    data_params = {'$where': 'year_occurred = {}'.format(year_to_search)}

    # Use Urbana data and search JSON file for crimes from specified year
    crime_data = requests.get('https://data.urbanaillinois.us/resource/uj4k-8xe8.json',
                              params=data_params).text

    return crime_data


# Import danger_levels from danger_levels.py
DANGER_LEVELS = danger_levels.danger_levels


def get_danger_level(crime):
    """Assign danger level to crime based on `danger_levels`"""

    # Default danger level
    danger = None

    # Handle Urbana crimes
    if crime.get('crime_category_description', None) in DANGER_LEVELS:
        danger = DANGER_LEVELS[crime['crime_category_description']]

    # Handle user-submitted crimes
    if crime.get('crime_category', None) in DANGER_LEVELS:
        danger = DANGER_LEVELS[crime['crime_category']]

    return danger


def parse_crimes():
    """Gets most important info from Urbana crime API
    as well as user-submitted crimes from Firebase database.

    Returns
    ------
    A ist of dicts; each dict is of the form:
    ```
    {
        "crime_category": "Category",
        "crime_description": "DESCRIPTION",
        "danger_level": ~,
        "date_reported": "mm/dd/yyyy",
        "location": {
            "latitude": "12.345678",
            "longitude": "12.345678"
        },
        "source": "####_crime_database"
    }
    ```
    (where #### is either "user" or "urbana",
    and   ~   is a rating from 1-10)
    """
    # Load Urbana crimes
    crime_data = json.loads(get_crime())

    # Create new list for all the crimes
    formatted_crimes = []

    # Urbana crimes:
    for crime in crime_data:
        # Skip to next crime if this one doesn't have an
        # address, location, or description
        if 'mapping_address' not in crime:
            continue
        if 'latitude' not in crime['mapping_address']:
            continue
        if 'crime_category_description' not in crime:
            continue

        # Get danger level (skip crime if danger level doesn't exist)
        danger_level = get_danger_level(crime)
        if danger_level == None:
            continue

        # Keep relevant information, add crime to formatted_crimes
        formatted_crimes.append({
            'crime_category': crime['crime_category_description'],
            'crime_description': crime['crime_description'],
            'danger_level': danger_level,
            'date_reported': dateutil.parser.parse(crime['date_reported']).strftime("%m/%d/%Y"),
            'location': {
                'latitude': crime['mapping_address']['latitude'],
                'longitude': crime['mapping_address']['longitude']
            },
            'source': 'urbana_crime_database'
        })

    # User-submitted crimes:
    for crime in db.child("userCrimes").get().val():
        # Get danger level (skip crime if danger level doesn't exist)
        danger_level = get_danger_level(crime)
        if danger_level == None:
            continue

        crime['danger_level'] = danger_level

        formatted_crimes.append(crime)

    # Sort all by date_reported
    formatted_crimes = sorted(
        formatted_crimes, key=lambda x: datetime.strptime(x['date_reported'], '%m/%d/%Y'))

    return formatted_crimes
