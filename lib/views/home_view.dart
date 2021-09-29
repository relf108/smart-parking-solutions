import 'dart:convert';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/main.dart';
import 'package:smart_parking_solutions/tmp/session_data.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

///EXAMPLE STATELESS WIDGET
class HomeView extends StatefulWidget {
  HomeView(this.response);
  Response response;
  @override
  State<HomeView> createState() => _HomeView(response);
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeView extends State<HomeView> {
  _HomeView(this.response);
  Response response;
  late TextEditingController _controller;
  List<Booking> _bookings = [];

  void getCurrentBookings() {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(response.body);
      final responsedecoded = json.decode(response.body);
      setState(() {
        for (var booking in responsedecoded['bookings']) {
          Booking newBooking = Booking.fromJson(json: booking);
          _bookings.add(newBooking);
        }
      });
      for (int i = 0; i < _bookings.length; i++) {
        var starttimeutc = _bookings[i].startDate;
        var endtimeutc = _bookings[i].endDate;
        var booktimeutc = _bookings[i].createdDate;
        _bookings[i].startDate = starttimeutc.toLocal();
        _bookings[i].endDate = endtimeutc.toLocal();
        _bookings[i].createdDate = booktimeutc.toLocal();
      }
    }
  }

  Future<void> deleteBooking(Booking booking) async {
    final Response response = await post(
        Uri.parse('http://geekayk.ddns.net:8888/deleteBooking'),
        body: booking.toJson());
    if (response.statusCode == 200) {
      // return bookings.fromJson(jsonDecode(response.body));
      print(response.body);
      getCurrentBookings();
    } else {
      throw Exception('Failed to delete the booking.');
    }
  }

  Future<void> cancelBooking(Booking booking) async {
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
                Text('Street Marker ID: ' + booking.bookedSpace.stMarkerID!),
                Text('Internal Bay ID: ' + booking.bookedSpace.bayID!),
                Text('Booking Start: ' + booking.startDate.toString()),
                Text('Booking End: ' + booking.endDate.toString()),
                Text('Booking Made: ' + booking.createdDate.toString()),
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
                Navigator.of(context)
                    .pop(); //here http request to delete the booking
                setState(() {
                  _bookings.remove(booking); //deleting local data
                });
                deleteBooking(
                    booking); //calling deleteBooking function to delete the booking
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
    getCurrentBookings();
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
                              _bookings[index]
                                  .bookedSpace
                                  .stMarkerID
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(_bookings[index].startDate.toString(),
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                //'Location: ${getStreetAddress(_bookings[index]['lat'], _bookings[index]['long'])}'
                                'Location: ${_bookings[index].bookedSpace.location!.humanAddress}',
                                style: TextStyle(color: Colors.white)),
                            trailing: InkWell(
                              onTap: () async {
                                cancelBooking(_bookings[index]);
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
