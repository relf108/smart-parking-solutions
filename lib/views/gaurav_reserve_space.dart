import 'dart:convert';
import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking_solutions/views/booking_conf.dart';
import '../main.dart';

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

  Future<void> getReserveSpace(
      int bayID, DateTime bookingtime, String duration, String user) async {
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
          jsonresponse: response.body,
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
          return Card(
            margin: EdgeInsets.all(10),
            child: ExpansionTile(
              leading: Text(
                _bays[index]["streetMarkerID"].toString(),
                style: TextStyle(color: Colors.black),
              ),
              title: Text('Location: ' +
                  _bays[index]["lat"] +
                  ', ' +
                  _bays[index]["long"]),
              children: <Widget>[
                ListTile(
                  title: Text((() {
                    if (_bays[index]["description"].length == 1) {
                      return _bays[index]["description"]["description1"];
                    } else if (_bays[index]["description"].length == 2) {
                      return _bays[index]["description"]["description1"] +
                          ', ' +
                          _bays[index]["description"]["description2"];
                    } else if (_bays[index]["description"].length == 3) {
                      return _bays[index]["description"]["description1"] +
                          ', ' +
                          _bays[index]["description"]["description2"] +
                          ', ' +
                          _bays[index]["description"]["description3"];
                    } else if (_bays[index]["description"].length == 4) {
                      return _bays[index]["description"]["description1"] +
                          ', ' +
                          _bays[index]["description"]["description2"] +
                          ', ' +
                          _bays[index]["description"]["description3"] +
                          ', ' +
                          _bays[index]["description"]["description4"];
                    } else if (_bays[index]["description"].length == 5) {
                      return _bays[index]["description"]["description1"] +
                          ', ' +
                          _bays[index]["description"]["description2"] +
                          ', ' +
                          _bays[index]["description"]["description3"] +
                          ', ' +
                          _bays[index]["description"]["description4"] +
                          ', ' +
                          _bays[index]["description"]["description5"];
                    } else {
                      return 'Error reading restrictions';
                    }
                  })()),
                  trailing: InkWell(
                    onTap: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirm Booking'),
                          content: Text(
                              'Are you sure you would like to book Parking Bay ' +
                                  _bays[index]["streetMarkerID"].toString() +
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
                                getReserveSpace(
                                    int.parse(_bays[index]["bayID"]),
                                    bookingdate,
                                    duration,
                                    testuser);
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
