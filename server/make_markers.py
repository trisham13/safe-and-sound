from parse_crimes import parse_crimes
import json

# Each marker needs a unique id, a lat-lng coordinate and an info window with a title and snippet
'''
JSON Format:
{
    "markers" : [
        {
            "id" : some integer,
            "info_window" : {
                "snippet" : "Description of crime",
                "title" : "What type of crime it is and on what date it occured",
            },
            "postion": {
                "latitude" : latitude coord,
                "longitude" : longitude coord
            }
        }
    ]
}
'''
def make_markers():
    crimes = parse_crimes()
    markers = {}
    markers['markers'] = []
    for crime in crimes:
        marker = {}
        marker['id'] = crime['id']
        position = {}
        position['latitude'] = crime['location']['latitude']
        position['longitude'] = crime['location']['longitude']
        marker['position'] = position
        info_window = {}
        info_window['title'] = crime['crime_category'] + " on " + crime['date_reported']
        info_window['snippet'] = crime['crime_description']
        marker['info_window'] = info_window
        markers['markers'].append(marker)
    json.dumps(markers)
    return markers
    