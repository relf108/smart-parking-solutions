import 'dart:convert';
import 'dart:io';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/views/booking_conf.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';
import '../main.dart';

//String testuser = 'tristan.sutton@gmail.com';
User testUser = User(
    email: 'tristan.sutton@gmail.com',
    familyName: 'Sutton',
    givenName: 'Tristan',
    googleUserID: '116902257632708248933',
    handicapped: false,
    userID: 1);

class ReserveSpaceView extends StatefulWidget {
  ///These should be available from the searchSpaces view and will be easy to pass through
  ReserveSpaceView(
      {Key? key,
      required jsonresponse,
      required this.startDate,
      required this.duration})
      : super(key: key) {
    for (var bay in jsonDecode(jsonresponse)['bays']) {
      this.searchResp.add(SearchSpacesResponse.fromJson(json: bay));
    }
  }
  final DateTime startDate;
  final Duration duration;
  final List<SearchSpacesResponse> searchResp = [];
  @override
  State<ReserveSpaceView> createState() => _ReserveSpaceView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ReserveSpaceView extends State<ReserveSpaceView> {
  late TextEditingController _controller;
  late AnimationController controller;

  Future<void> getReserveSpace(Booking booking) async {
    String localFormattedDate = booking.startDate.toLocal().toString();
    booking.createdDate = booking.createdDate.toUtc();
    booking.startDate = booking.startDate.toUtc();
    booking.endDate = booking.endDate.toUtc();
    //  print(formattedDate);
    String urlstring = 'http://' + localhost + ':8888/reserveSpace';
    print(urlstring);
    final url = Uri.parse(urlstring);
    Response response = await post(url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(booking.toJson()));
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
    // for (var resp in widget.searchResp) {
    //   widget.searchResp.add(resp);
    // }
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
    var listView = ListView.builder(
        itemCount: widget.searchResp.length,
        itemBuilder: (context, index) {
          return Card(
            color: spsblue,
            margin: EdgeInsets.all(10),
            child: ExpansionTile(
              leading: Text(
                widget.searchResp[index].space.stMarkerID!,
                style: TextStyle(color: Colors.white),
              ),
              title: Text(
                'Location: ' + widget.searchResp[index].humanAddress.toString(),
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                ListTile(
                  title: Text((() {
                    return widget.searchResp.first.description.toString();
                  })()),
                  trailing: InkWell(
                    onTap: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirm Booking'),
                          content: Text(
                              'Are you sure you would like to book Parking Bay ' +
                                  widget.searchResp[index].space.stMarkerID
                                      .toString() +
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
                                getReserveSpace(Booking(
                                    createdDate: DateTime.now(),
                                    startDate: widget.startDate,
                                    endDate:
                                        widget.startDate.add(widget.duration),
                                    bookedSpace: widget.searchResp[index].space,
                                    owner: testUser));
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
