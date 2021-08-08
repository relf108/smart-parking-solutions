from flask import Flask, request, jsonify, make_response, Response

app = Flask(__name__)


# dummy /currentBookings endpoint
@app.route('/currentBookings')
def currentBookings(): #example get req made by front end = http://geekayk.ddns.net:5000/currentBookings?user=test2

    user = request.args.get('user')

    if user == 'test1':
        response = [{"streetid":"91A","date":"21/11/2021","time":"13:00","length":2}]
        return make_response(jsonify(response))
    elif user == 'test2':
        response =[{"streetid":"77C", "date":"09/09/2021", "time":"09:30", "length":2},{"streetid":"04B", "date":"14/12/2021", "time":"16:00", "length":3}]
        return make_response(jsonify(response))
    elif user == 'test3':
        response =[{"streetid":"104B", "date":"01/10/2021", "time":"07:00", "length":0.5},{"streetid":"22A", "date":"30/08/2021", "time":"14:00", "length":2},{"streetid":"04B", "date":"14/12/2021", "time":"16:00", "length":3}]
        return make_response(jsonify(response))
    else:
        return Response({user + ' user not found'}, status=201, mimetype='application/json')

# add more dummy endpoints here



# run app
if __name__ == '__main__':
    # run app in debug mode on port 5000
    app.run(debug=True, port=5000)