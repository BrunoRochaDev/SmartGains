
import asyncio
from flask import Flask, jsonify, request
from flask_restful import Api, Resource
import logging
from flask_cors import CORS, cross_origin
import websockets
# logger
logging.basicConfig(filename="api.log", level=logging.DEBUG)

websockets


# Flask app and Flask Restful api
app = Flask(__name__)
app.logger.debug("\n\n\n\t\tFlask app start")
api = Api(app)
cors = CORS(app, resources={r"/*": {"origins": "*"}})

# get all users with all the information
# debug material
@app.route("/")
@cross_origin()
def index():
    print("connected")

    return {"command": "connected"}

# Class generalization for the CRUD methods related to the User -> database connection
# Mock class for testing
class Rep(Resource):
    
    # GET method
    # input arguments: identification (id or something similar) -> NMEC if possible
    # get the photo in the database for the user with id inputed
    def get(self):
        # curl http://localhost:5000/image/<id> -X GET

        # return identification and photo
        return jsonify({"command": "get_user"})

    # PUT method
    # input arguments: identification (id or something similar) -> NMEC if possible
    # updates / inserts a user to the database
    def put(self):
        # curl http://localhost:8393/user/<id> -d "repCount=<repCount>" -X PUT

        repCount = request.form['repCount']

        return jsonify({"command": "repCount", "repCount": repCount})


api.add_resource(Rep, '/rep')


# main
if __name__ == "__main__":
    # run Flask app
    app.run(debug=True,host="0.0.0.0", port=8393)


    app.logger.info( flask.request.remote_addr)