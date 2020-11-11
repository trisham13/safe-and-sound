import json
import config
import pyrebase

# Set up Firebase
firebase_config = {
    "apiKey": config.firebase_api_key,
    "authDomain": "fa20team3project.firebaseapp.com",
    "databaseURL": "https://fa20team3project.firebaseio.com/",
    "storageBucket": "fa20team3project.appspot.com"
}
firebase = pyrebase.initialize_app(firebase_config)
db = firebase.database()

def insert_into_firebase(post_data):
    # post_data = json.loads(post_data) # if given data is a string, include this line
    db.child("userCrimes").push(post_data)