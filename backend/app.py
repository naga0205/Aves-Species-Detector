from flask import Flask,request,jsonify
import subprocess
import pyrebase
#configration files of firebase storage

config = {
  "apiKey": "AIzaSyC53IW7-0ckK1jnkZ6Z4yIWERkihp0iHhU",
  "authDomain": "avesspecies-b354b.firebaseapp.com",
  "projectId": "avesspecies-b354b",
  "storageBucket": "avesspecies-b354b.appspot.com",
  "messagingSenderId": "957116794895",
  "appId": "1:957116794895:web:ec1a969b85935095e9bb7a",
  "serviceAccount": "serviceAccountKey.json",
  "databaseURL":"https://avesspecies-b354b-default-rtdb.firebaseio.com/"
};
firebase_storage = pyrebase.initialize_app(config)
storage = firebase_storage.storage()
app = Flask(__name__)
@app.route("/", methods=['GET'])
def home():
    filename=str(request.args['query'])
    # # print(filename)
    storage.download("images/{}".format(filename),"img.jpg")
    subprocess.run(["python","model.py"])
    dic={}
    return jsonify(dict) 
if __name__ == "__main__":
    app.run()