from flask import Flask
import json
import googlemaps

# Google Maps API client -- everything goes through here
# email and password for associated account in Discord
gmaps = googlemaps.Client(key="API_KEY_HERE")

app = Flask(__name__)

@app.route('/') # https://localhost:5000/
def home():
    return "Hey there!"

@app.route('/json-example') # https://localhost:5000/json-example
def json_example():
    d = {}
    d['example'] = 'value'
    return json.dumps(d) # will return the dict as JSON

if __name__ == '__main__':
    app.run(debug=True) # saving file will reload the server
