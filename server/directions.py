import requests
import config
import polyline
import ast
from geopy import distance
from parse_crimes import parse_crimes
import json

# the closest acceptable distance a point can be from a crime in miles (rn the number is arbritrary)
MIN_ACCEPTABLE_CRIME_DISTANCE = .75
ALLOWED_EXTRA_LEEWAY = .15

# the dict of crime proximity
is_point_close_to_crime = dict()

global crime_data

# returns the best route as a polyline
def get_best_route(location_from, location_to):
    data_params = {
        'origin': location_from,  # location_from,
        'mode': 'walking',
        'key': config.maps_api_key,
        'destination': location_to,  # location_to,
        'alternatives': 'true'
    }

    global crime_data
    crime_data = parse_crimes()
    
    # makes google maps api request
    directions_data = requests.get(
        'https://maps.googleapis.com/maps/api/directions/json', params=data_params).text

    # converts JSON string to python dict
    directions_data = ast.literal_eval(directions_data)

    # the polyline we need is in directions_data["routes"][n][overview_polyline][points]
    polylines = [directions_data["routes"][n]["overview_polyline"]["points"]
                 for n in range(len(directions_data["routes"]))]

    # decodes polyline into list of tuples
    # this is an example: locations = polyline.decode('u{~vFvyys@fS]')
    # if start location is (a,b) and end location is (x,y)
    # decoded_polylines is in the form of [[(a,b),(c,d),...(x,y)],[(a,b),(g,h),...(x,y)]]
    # this example is for 2 routes, hence 2 inner lists
    decoded_polylines = [polyline.decode(i) for i in polylines]

    # safety_ratings is in the form [s,t,..], where s and t are numbers representing
    # each route's safety weighting. A higher safety rating is better.
    safety_ratings = [safety_rating(route) for route in decoded_polylines]

    # create readable json out of data
    polylines_json = create_json(polylines, safety_ratings)
    return polylines_json

    # # at the moment I'm returning all the relevant data from the API regarding the route we picked as optimal
    # return str(directions_data["routes"][idx_of_best_route])


def calculate_crime_weight_in_radius(point, crimes, radius):
    crime_weight = 0
    # for every crime
    for crime in crimes:
        crime_loc = crime['location']['latitude'], crime['location']['longitude']
        # rn this computes the geodesic dist, I might change it to great-circle distance if that's optimal
        dist_to_crime = distance.distance(crime_loc, point).miles
        if dist_to_crime < radius:
            crime_weight += crime['danger_level']
    return crime_weight


def crime_weightage(route):
    total_crime_weight = 0
    # list of lat-lng tuples from the crime data
    for point in route:
        total_crime_weight += calculate_crime_weight_in_radius(point, crime_data, MIN_ACCEPTABLE_CRIME_DISTANCE)
    return total_crime_weight


# calculates the safety rating of a route
def safety_rating(route):
    return 1 / (crime_weightage(route) + 1)
    # return 1 / (number_of_crimes(route) + 1)  # 1 / (... + 1) to avoid division by 0
    # this method should change based on our best solution


# calculates the number of crimes near or on a particular route
def number_of_crimes(route):
    num_crimes = 0
    # list of lat-lng tuples from the crime data
    crime_locs = [(crime['location']['latitude'], crime['location']['longitude']) for crime in crime_data]
    for point in route:
        if is_near_crime(point, crime_locs):
            num_crimes += 1
    return num_crimes


def is_near_crime(point, crime_locs):
    # if we have calculated this point alerady, don't do it again
    if point in is_point_close_to_crime.keys():
        return is_point_close_to_crime[point]

    # if the point were looking at is less than some miles from a point we calculated before,
    # just return the result of the point we calculated
    for seen_point in is_point_close_to_crime.keys():
        dist_to_seen_point = distance.distance(seen_point, point)
        if dist_to_seen_point < ALLOWED_EXTRA_LEEWAY:
            return is_point_close_to_crime[seen_point]

    # for every crime
    for crime_loc in crime_locs:
        # rn this computes the geodesic dist, I might change it to great-circle distance if that's optimal
        dist_to_crime = distance.distance(crime_loc, point).miles
        if dist_to_crime < MIN_ACCEPTABLE_CRIME_DISTANCE:
            is_point_close_to_crime[point] = True
            return True
    is_point_close_to_crime[point] = False
    return False


# finds the index of the highest rating in safetey ratings. We need this because that will be the same
# index where the best route will be since both safety_ratings and directions_data are indexed the same way
def find_max_rating_index(safety_ratings):
    max_rating = safety_ratings[0]
    max_idx = 0
    for i in range(1, len(safety_ratings)):
        if safety_ratings[i] > max_rating:
            max_rating = safety_ratings[i]
            max_idx = i
    return max_idx


# creates a json in the following format
# { "polylines" = [
#   { "polyline": "lrqcjgk", "safety_rating": 5 },
#   { "polyline": "qrcgqkw", "safety_rating": 10 },
#   { "polyline": "jaeqjkr", "safety_rating": 2 } ] }
def create_json(decoded_polylines, safety_ratings):
    # initialize python style dict to later convert into json format
    polylines_json = {}
    polylines_json["polylines"] = []

    # construct python style dict to later convert into json format
    for i in range(len(decoded_polylines)):
        route_details = {}
        route_details["polyline"] = decoded_polylines[i]
        route_details["safety_rating"] = safety_ratings[i]
        polylines_json["polylines"].append(route_details)

    # convert to json
    json.dumps(polylines_json)
    return polylines_json
