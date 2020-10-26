import googlemaps
import requests
import config
import polyline
import ast
from geopy import distance
from parse_crimes import parse_crimes

# Google Maps API client -- everything goes through here
# email and password for associated account in Discord
gmaps = googlemaps.Client(key=config.maps_api_key)


# returns the best route as a polyline
def get_best_route(location_from, location_to):
    data_params = {
        'origin': '40.101099, -88.231979',#location_from,
        'mode': 'walking',
        'key': config.maps_api_key,
        'destination': '40.111086, -88.239049',#location_to,
        'alternatives':'true'
    }

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
    idx_of_best_route = find_max_rating_index(safety_ratings)
    # at the moment I'm returning all the relevent data from the API regarding the route we picked as optimal
    return str(directions_data["routes"][idx_of_best_route])


# calculates the safety rating of a route
def safety_rating(route):
    return 1 / (number_of_crimes(route) + 1)  # 1 / (... + 1) to avoid division by 0
    # ^ this line should change based on our best solution


# calculates the number of crimes near or on a particular route
def number_of_crimes(route):
    num_crimes = 0
    crime_data = parse_crimes()
    # list of lat-lng tuples from the crime data
    crime_locs = [(crime['location']['latitude'],crime['location']['longitude']) for crime in crime_data]
    for point in route:
        if is_near_crime(point, crime_locs):
            num_crimes += 1
    return num_crimes

def is_near_crime(point, crime_locs):
    # the closest acceptable distance a point can be from a crime in miles (rn the number is arbritrary)
    min_acceptable_dist = .75
    for crime_loc in crime_locs:
        # rn this computes the geodesic dist, I might change it to great-circle distance if that's optimal
        dist_to_crime = distance.distance(crime_loc, point).miles
        if dist_to_crime < min_acceptable_dist:
            return True
    return False

# finds the index of the highest rating in safetey ratings. We need this because that will be the same 
# index where the best route will be since both safety_ratings and directions_data are indexed the same way
def find_max_rating_index(safety_ratings):
    max_rating = safety_ratings[0]
    max_idx = 0
    for i in range (1,len(safety_ratings)):
        if safety_ratings[i] > max_rating:
            max_rating = safety_ratings[i]
            max_idx = i
    return max_idx

