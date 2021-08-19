import 'dart:convert';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/main.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';

///EXAMPLE STATELESS WIDGET
class View extends StatefulWidget {
  @override
  State<View> createState() => _View();
}

/// This is the private State class that goes with MyStatefulWidget.
class _View extends State<View> {
  late TextEditingController _controller;
  List _bookings = [];

  Future<void> getCurrentBookings() async {
    String urlstring =
        'http://' + localhost + ':8888/currentBookings?email=' + testuser;
    print(urlstring);
    final url = Uri.parse(urlstring);
    Response response = await get(url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(response.body);
      final responsedecoded = await json.decode(response.body);
      setState(() {
        _bookings = responsedecoded['bookings'];
      });
      for (int i = 0; i < _bookings.length; i++) {
        var starttimeutc = DateTime.parse(_bookings[i]['startDate']);
        var endtimeutc = DateTime.parse(_bookings[i]['endDate']);
        var booktimeutc = DateTime.parse(_bookings[i]['createdDate']);
        _bookings[i]['startDate'] = starttimeutc.toLocal().toString();
        _bookings[i]['endDate'] = endtimeutc.toLocal().toString();
        _bookings[i]['createdDate'] = booktimeutc.toLocal().toString();
      }
    }
  }

  Future<void> cancelBooking(int booking) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Booking Details:'),
                /*Text('Street Marker ID: ' +
                    _bookings[booking]['streetMarkerID']),*/
                Text('Internal Bay ID: ' + _bookings[booking]['bayID']),
                Text('Booking Start: ' + _bookings[booking]['startDate']),
                Text('Booking End: ' + _bookings[booking]['endDate']),
                Text('Booking Made: ' + _bookings[booking]['createdDate']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getCurrentBookings();
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratioGen = new ScreenRatioGenerator(context: context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ratioGen.screenHeightPercent(percent: 6),
        title: const Text('Home'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: ratioGen.screenHeightPercent(percent: 75),
                  width: ratioGen.screenWidthPercent(percent: 100),
                  child: ListView.builder(
                      itemCount: _bookings.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.red,
                          child: ListTile(
                            leading: Text(
                              /*_bookings[index]['streetMarkerID']*/ _bookings[
                                  index]['bayID'],
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(_bookings[index]['startDate'],
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                'Location: ' /* +
                                _bookings[index]['lat'] +
                                ', ' +
                                _bookings[index]['long']*/
                                ,
                                style: TextStyle(color: Colors.white)),
                            trailing: InkWell(
                              onTap: () async {
                                cancelBooking(index);
                              },
                              child: Icon(Icons.arrow_forward),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    height: ratioGen.screenHeightPercent(percent: 6),
                    width: ratioGen.screenWidthPercent(percent: 100),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push<MaterialPageRoute>(context,
                            MaterialPageRoute(builder: (context) {
                          return SearchSpacesView();
                        }))
                      },
                      child: Card(
                        color: Colors.red,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/snr.png',
                        ),
                      ),
                    ))
              ],
            ),
            Row(
              children: [
                Container(
                    height: ratioGen.screenHeightPercent(percent: 6),
                    width: ratioGen.screenWidthPercent(percent: 100),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push<MaterialPageRoute>(context,
                            MaterialPageRoute(builder: (context) {
                          return CreatePasswordView("test@123.com");
                        }))
                      },
                      child: Card(
                        color: Colors.red,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/ap.png',
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
