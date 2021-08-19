import 'dart:convert';
import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/views/booking_conf.dart';
import '../main.dart';
import 'package:intl/intl.dart';

String testuser = 'tristan.sutton@gmail.com';

class ReserveSpaceView extends StatefulWidget {
  ReserveSpaceView(
      {Key? key,
      required this.jsonresponse,
      required this.bookingdate,
      required this.duration})
      : super(key: key);
  final String jsonresponse;
  final DateTime bookingdate;
  final String duration;
  @override
  State<ReserveSpaceView> createState() => _ReserveSpaceView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ReserveSpaceView extends State<ReserveSpaceView> {
  late TextEditingController _controller;
  late AnimationController controller;
  List _bays = [];

  Future<void> getReserveSpace(int bayID, DateTime bookingtime, String duration,
      String user, String streetmarkerid, String lat, String long) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return loading;
      },
    );
    String formattedDate =
        DateFormat('yyyy-MM-dd kk:mm:ss').format(bookingtime);
    print(formattedDate);
    String urlstring = 'http://' +
        localhost +
        ':8888/reserveSpace?bayID=' +
        bayID.toString() +
        '&email=' +
        user +
        '&startTime=' +
        formattedDate.toString() +
        'Z&duration=' +
        duration;
    print(urlstring);
    final url = Uri.parse(urlstring);
    Response response = await get(url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Navigator.pop(context);
      Navigator.push<MaterialPageRoute>(context,
          MaterialPageRoute(builder: (context) {
        return BookingConfView(
          streetMarkerID: streetmarkerid,
          bookingdate: formattedDate,
          lat: lat,
          long: long,
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
                  Text('Unable to reserve BayID: ' + bayID.toString()),
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

  Future<void> readJson(String jsonresponse) async {
    final String response = jsonresponse;
    final responsedecoded = await json.decode(response);
    setState(() {
      _bays = responsedecoded["bays"];
    });
    for (int i = 0; i < _bays.length; i++) {
      _bays[i]["distance"] = int.parse(_bays[i]["distance"]);
    }
  }

  @override
  void initState() {
    readJson(widget.jsonresponse);
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
    final DateTime bookingdate = widget.bookingdate;
    final String duration = widget.duration;
    var listView = ListView.builder(
        itemCount: _bays.length,
        itemBuilder: (context, index) {
          // INSERT YOUR CODE HERE
          // VARIABLES/FUNCTIONS TO BE USED:
          // _bays : list of all bays ( e.g. _bays[i]['streetMarkerID'])
          // bookingdate : the booking date and time (e.g. 2021-08-31 03:39:05.92) that will need to be passed into getReserveSpace()
          // duration : the length of booking time (e.g. 1.5 hours) that will need to be passed into getReserveSpace()
          // getReserveSpace() : does the http request and validation, just set the booking button onpress/onclick/ontap to action this function
          // loading : this variable returns the loading animation alert dialog, wrap this in a 'showDialog' to use it.

          // In this section you will have to program your version on displaying the list items,
          // you do not need to touch any other code in the file
          // Only work on lines 133 and on
          throw 'test';
        });
    return listView;
  }
}
