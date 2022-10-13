from flask import request, jsonify
from app import app
from flask_cors import cross_origin
import pymongo
from bson.json_util import dumps


# mock database created with pymongo
myclient = pymongo.MongoClient("mongodb://mongo:27017/", username='admin', password='admin', authSource='admin', authMechanism='SCRAM-SHA-256')
# create or get db
mydb = myclient["SmartGainsTest"]
# create or get collection
mycol = mydb["CollectionTest"]

mydict = {"init": "yes"}
x = mycol.insert_one(mydict)


# debug material
@app.route("/")
@cross_origin()
def index():
    return {}


@app.route('/user/inf', methods=['PUT'])
@cross_origin()
def UserInf():

    username = request.args.get("username")

    # curl http://localhost:8393/user/inf?username=<username>
    # -d "weight=<weight>" -d "height=<height>" -d "gender=<gender>" -d "birth=<dateOfBirth>"
    # -X PUT

    if request.method == 'PUT':

        weight = request.form['weight']
        height = request.form['height']
        gender = request.form['gender']
        birth = request.form['birth']
        objective = request.form["objective"]

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        if result != []:

            mydict = {"username": username}
            update_to = {"$set" : {'weight' : weight}}
            x = mycol.update_one(mydict, update_to)
            update_to = {"$set" : {'height' : height}}
            x = mycol.update_one(mydict, update_to)
            update_to = {"$set" : {'gender' : gender}}
            x = mycol.update_one(mydict, update_to)
            update_to = {"$set" : {'dateOfBirth' : birth}}
            x = mycol.update_one(mydict, update_to)
            update_to = {"$set" : {'dailyGoal' : objective}}
            x = mycol.update_one(mydict, update_to)

            return dumps(mycol.find({"username": username}))

        return jsonify({"command": "Failed", "error": "Could not update the user"})

    return jsonify({"command": "Failed", "error": "Request method incorrect"})


@app.route('/user/activity', methods=['PUT'])
@cross_origin()
def UserActivity():

    username = request.args.get("username")

    # curl http://localhost:8393/user/activity?username=<username>
    # -d "activity=<activity>"
    # -X PUT

    if request.method == 'PUT':

        activity = request.form['activity']

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        if result != []:

            mydict = {"username": username}
            update_to = {"$set" : {'activity' : activity}}
            x = mycol.update_one(mydict, update_to)

            return dumps(mycol.find({"username": username}))

        return jsonify({"command": "Failed", "error": "Could not update the user"})

    return jsonify({"command": "Failed", "error": "Request method incorrect"})


@app.route('/user/goals', methods=['PUT'])
@cross_origin()
def UserGoals():

    username = request.args.get("username")

    # curl http://localhost:8393/user/activity?username=<username>
    # -d "goals=<goals>" -d "dailyGoal=<dailyGoal>"
    # -X PUT

    if request.method == 'PUT':

        goals = request.form['goals']
        dailyGoal = request.form['dailyGoal']

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        if result != []:

            mydict = {"username": username}
            update_to = {"$set" : {'goals' : goals}}
            x = mycol.update_one(mydict, update_to)
            update_to = {"$set" : {'dailyGoal' : dailyGoal}}
            x = mycol.update_one(mydict, update_to)

            return dumps(mycol.find({"username": username}))

        return jsonify({"command": "Failed", "error": "Could not update the user"})

    return jsonify({"command": "Failed", "error": "Request method incorrect"})


@app.route('/user', methods=['GET', 'POST', 'PUT'])
@cross_origin()
def User():

    username = request.args.get("username")

    # curl http://localhost:8393/user?username=<username>
    # -d "password=<password>" -d "email=<email>""
    # -X POST
    if request.method == 'POST':

        password = request.form['password']
        email = request.form['email']

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        if result == []:
            mydict = { "username": username, "password": password, "email": email}
            x = mycol.insert_one(mydict)

            # return identification and photo
            return dumps(mycol.find({"username": username}))
        
        return jsonify({"command": "Failed", "error": "Username already exists"})


    # curl http://localhost:8393/user?username=<username>
    # -X GET
    elif request.method == 'GET':

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        return dumps(result)

    # curl http://localhost:8393/user?username=<username>
    # -d "weight=<weight>"
    # -X GET
    elif request.method == 'PUT':

        weight = request.form['weight']

        update_to = {"$set" : {'weight' : weight}}
        x = mycol.update_one(mydict, update_to)

        return dumps(mycol.find({"username": username}))


    return jsonify({"command": "Failed", "error": "Request method incorrect"})


@app.route('/databackend', methods=['PUT'])
@cross_origin()
def DataBackend():
    # curl http://localhost:8393/databackend
    # -d "repCount=<repCount>" -d "goodRepCount=<goodRepCount>" -d "username=<username>"
    # -X PUT

    if request.method == 'PUT':

        repCount = request.form['repCount']
        goodRepCount = request.form['goodRepCount']
        username = request.form["username"]

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        if result != []:
            mydict = {"username": username}
            update_to = {"$set" : {'repCount' : repCount}}
            x = mycol.update_one(mydict, update_to)
            update_to = {"$set" : {'goodRepCount' : goodRepCount}}
            x = mycol.update_one(mydict, update_to)

            return dumps(mycol.find({"username": username}))

        return jsonify({"command": "Failed", "error": "Could not update the user"})

    return jsonify({"command": "Failed", "error": "Request method incorrect"})


@app.route('/datafrontend', methods=['PUT'])
@cross_origin()
def DataFrontend():
    # curl http://localhost:8393/datafrontend
    # -d "hours:<hours>" -d "day:<day>" -d "username=<username>"
    # -X PUT

    if request.method == 'PUT':

        hours = request.form['hours']
        days = request.form['day']
        username = request.form["username"]

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        if result != []:
            mydict = {"username": username}
            update_to = {"$set" : {'hoursDay' : {days: hours}}}
            x = mycol.update_one(mydict, update_to)

            return dumps(mycol.find({"username": username}))

        return jsonify({"command": "Failed", "error": "Could not update the user"})

    return jsonify({"command": "Failed", "error": "Request method incorrect"})


@app.route('/gifs', methods=['PUT'])
@cross_origin()
def Gifs():
    # curl http://localhost:8393/gifs
    # -d "gifs:<gifs>" "username=<username>"
    # -X PUT

    username = request.args.get("username")

    if request.method == 'PUT':

        gifs = request.form['gifs']

        result = []
        for x in mycol.find({"username": username}):
            result.append(x)

        if result != []:
            mydict = {"username": username}
            update_to = {"$set" : {'gifs' : gifs}}
            x = mycol.update_one(mydict, update_to)

            return dumps(mycol.find({"username": username}))

        return jsonify({"command": "Failed", "error": "Could not update the user"})

    return jsonify({"command": "Failed", "error": "Request method incorrect"})

@app.errorhandler(404)
def page_not_found(e):
    return jsonify({"command": "Failed", "error": "Error handling the request"})