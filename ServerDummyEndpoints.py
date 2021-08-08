from flask import Flask, request, jsonify, make_response, Response

app = Flask(__name__)


# dummy /currentBookings endpoint
@app.route('/currentBookings')
def currentBookings(): #example get req made by front end = http://geekayk.ddns.net:5000/currentBookings?user=test2

    user = request.args.get('user')

    if user == 'test1':
        response = [{"bookings":1},{"streetid":"91A","date":"21112021","time":"1300","length":2}]
        return make_response(jsonify(response))
    elif user == 'test2':
        response =[{"bookings":2},{"streetid":"77C", "date":"09092021", "time":"0930", "length":2},{"streetid":"04B", "date":"14122021", "time":"1600", "length":3}]
        return make_response(jsonify(response))
    elif user == 'test3':
        response =[{"bookings":3},{"streetid":"104B", "date":"01102021", "time":"0700", "length":0.5},{"streetid":"22A", "date":"30082021", "time":"1400", "length":2},{"streetid":"04B", "date":"14122021", "time":"1600", "length":3}]
        return make_response(jsonify(response))
    else:
        return Response({user + ' user not found'}, status=201, mimetype='application/json')

# add more dummy endpoints here

@app.route('/parking')
def parking():

    response = [{"spaces":3},{"streedid":"10103W", "distance":100, "lat":-37.803471559047566, "long":144.9479280887954, "near":"57, State Route 60, North Melbourne VIC 3051, Australia"},{"streedid":"10105W", "distance":105, "lat":-37.80341705438269, "long":144.94793731799047, "near":"57, State Route 60, North Melbourne VIC 3051, Australia"},{"streedid":"10107W", "distance":110, "lat":-37.80368282112505, "long":144.94789332681202, "near":"57, State Route 60, North Melbourne VIC 3051, Australia"}]
    return make_response(jsonify(response))

@app.route('/checkSpace')
def checkSpace():
    
    response = [{"status":"available"}]
    return make_response(jsonify(response))

# run app
if __name__ == '__main__':
    # run app in debug mode on port 5000
    app.run(debug=True, port=5000)