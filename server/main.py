from flask import Flask
import json

app = Flask(__name__)

@app.route('/')
def home():
    return "Hey there!"

@app.route('/json-example')
def json_example():
    d = {}
    d['example'] = 'value'
    return json.dumps(d) # will return the dict as JSON

if __name__ == '__main__':
    app.run(debug=True) # saving file will reload the server
