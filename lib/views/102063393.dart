import 'dart:io';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/views/booking_conf.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';
import '../main.dart';

String testuser = 'tristan.sutton@gmail.com';

class ReserveSpaceView extends StatefulWidget {
  ///These should be available from the searchSpaces view and will be easy to pass through
  final SearchSpacesResponse searchResp;
  final Booking booking;

  ReserveSpaceView({Key? key, required this.booking, required this.searchResp})
      : super(key: key);
  @override
  State<ReserveSpaceView> createState() => _ReserveSpaceView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ReserveSpaceView extends State<ReserveSpaceView> {
  late TextEditingController _controller;
  late AnimationController controller;
  List<ParkingSpace> _bays = [];

  Future<void> getReserveSpace(Booking booking) async {
    String localFormattedDate = booking.startDate.toLocal().toString();
    //  print(formattedDate);
    String urlstring = 'http://' + localhost + ':8888/reserveSpace';
    print(urlstring);
    final url = Uri.parse(urlstring);
    Response response = await post(url, body: booking.toJson());
    print(response.body + response.statusCode.toString());
    // if (response.statusCode >= 200 && response.statusCode < 300) { really avoid this when possible
    // Try the following in your own code
    if (response.statusCode == HttpStatus.accepted) {
      ///HttpStatus vars directly evaluate to ints
      ///Definition from dart libs:
      /// static const int accepted = 202; 
      Navigator.pop(context);
      Navigator.push<MaterialPageRoute>(context,
          MaterialPageRoute(builder: (context) {
        return BookingConfView(
          streetMarkerID: booking.bookedSpace.stMarkerID!,
          bookingdate: localFormattedDate,
          lat: booking.bookedSpace.lat!,
          long: booking.bookedSpace.lon!,
        );
      }));
    } else {
      print('fail');
      Navigator.pop(context);
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('/reserveSpace Endpoint Failure'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Unable to reserve BayID: ' + booking.bookedSpace.bayID!),
                  Text(''),
                  Text('Please go back and try booking another spot.'),
                  Text(''),
                  Text(
                    'Error: ' +
                        response.statusCode.toString() +
                        ' ' +
                        response.body,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    //Add the entire response as we're keeping all this data closeley coupled
    _bays.add(widget.booking.bookedSpace);
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
        title: Text("Reserve Space"),
      ),
      body: getListView(),
    );
  }

  Widget getListView() {
    final DateTime bookingdate = widget.booking.startDate;
    final String duration =
        bookingdate.difference(widget.booking.endDate).toString();
    var listView = ListView.builder(
        itemCount: _bays.length,
        itemBuilder: (context, index) {
          return Card(
            color: spsblue,
            margin: EdgeInsets.all(10),
            child: ExpansionTile(
              leading: Text(
                _bays[index].stMarkerID!,
                style: TextStyle(color: Colors.black),
              ),
              title: Text('Location: ' + _bays[index].location!.toString()),
              children: <Widget>[
                ListTile(
                  title: Text((() {
                    return widget.searchResp.description.toString();
                  })()),
                  trailing: InkWell(
                    onTap: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirm Booking'),
                          content: Text(
                              'Are you sure you would like to book Parking Bay ' +
                                  _bays[index].stMarkerID.toString() +
                                  ' at your chosen time?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return loading;
                                  },
                                );
                                getReserveSpace(widget.booking);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(Icons.book_online),
                  ),
                )
              ],
            ),
          );
        });
    return listView;
  }
}
