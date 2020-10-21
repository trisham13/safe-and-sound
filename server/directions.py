import googlemaps
import requests
import config
import polyline
import ast

# Google Maps API client -- everything goes through here
# email and password for associated account in Discord
gmaps = googlemaps.Client(key=config.maps_api_key)


# returns the best route as a polyline
def get_best_route(location_from, location_to):
    data_params = {
        'origin': location_from,
        'mode': 'walking',
        'key': config.maps_api_key,
        'destination': location_to,
        'alternatives': 'true'
    }
    directions_data = requests.get(
        'https://maps.googleapis.com/maps/api/directions/json', params=data_params).text

    # return directions_data

    # converts JSON string to python dict
    directions_data = ast.literal_eval(directions_data)

    # decodes polyline into list of tuples
    # this is an example: locations = polyline.decode('u{~vFvyys@fS]')
    # the polyline we need is in directions_data["routes"][n][overview_polyline][points]
    # if start location is (a,b) and end location is (x,y)
    # decoded_polylines is in the form of [[(a,b),(c,d),...(x,y)],[(a,b),(g,h),...(x,y)]]
    # this example is for 2 routes, hence 2 inner lists
    decoded_polylines = [polyline.decode(directions_data["routes"][n]["overview_polyline"]["points"])
                         for n in range(len(directions_data["routes"]))]

    # safety_ratings is in the form [s,t,..], where s and t are numbers representing
    # each route's safety weighting. A higher safety rating is better.
    safety_ratings = [safety_rating(route) for route in decoded_polylines]

    return str(decoded_polylines)


# calculates the safety rating of a route
def safety_rating(route):
    return 1 / (number_of_crimes(route) + 1)  # 1 / (... + 1) to avoid division by 0
    # ^ this line should change based on our best solution


# calculates the number of crimes near or on a particular route
def number_of_crimes(route):
    # TODO: write this method
    return 0
