import googlemaps
import requests
import config

# Google Maps API client -- everything goes through here
# email and password for associated account in Discord
gmaps = googlemaps.Client(key=config.maps_api_key)

def get_route_by_min_crimes(location_from, location_to):
    data_params = {
        'origin': location_from,
        'mode': 'walking',
        'key': config.maps_api_key,
        'destination': location_to,
        'alternatives': 'true'
    }
    directions_data = requests.get(
        'https://maps.googleapis.com/maps/api/directions/json', params=data_params).text
    return directions_data
