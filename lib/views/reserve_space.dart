import 'dart:convert';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/views/booking_conf.dart';

String testuser = '102145123@student.swin.edu.au';

///EXAMPLE STATELESS WIDGET
// ignore: must_be_immutable
class ReserveSpaceView extends StatefulWidget {
  ReserveSpaceView(
      {Key? key,
      required this.jsonresponse,
      required this.bookingdate,
      required this.duration})
      : super(key: key);
  final String jsonresponse;
  final DateTime bookingdate;
  final double duration;
  @override
  State<ReserveSpaceView> createState() => _ReserveSpaceView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ReserveSpaceView extends State<ReserveSpaceView> {
  late TextEditingController _controller;
  List _bays = [];

  Future<void> getReserveSpace(
      int bayID, DateTime bookingtime, double duration, String user) async {
    String urlstring = 'http://geekayk.ddns.net:8888/reserveSpace?bayid=' +
        bayID.toString() +
        '&email=' +
        user +
        '&startTime=' +
        bookingtime.toString() +
        '&duration=' +
        duration.toString();
    print(urlstring);
    final url = Uri.parse(urlstring);
    Response response = await get(url);
    if (response.statusCode == 200) {
      Navigator.push<MaterialPageRoute>(context,
          MaterialPageRoute(builder: (context) {
        return BookingConfView(
          jsonresponse: response.body,
        );
      }));
    } else {
      print('fail');
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('/checkSpace Endpoint Failure'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Unable to check BayID: ' + bayID.toString()),
                  Text(''),
                  Text('Please go back and try booking another spot.'),
                  Text(''),
                  Text(
                    'Error: ' + response.body,
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

  Future<void> getCheckSpace(
      int bayID, DateTime bookingtime, double duration, String user) async {
    String urlstring = 'http://geekayk.ddns.net:8888/checkSpace?bayid=' +
        bayID.toString() +
        '&datetime=' +
        bookingtime.toString() +
        '&duration=' +
        duration.toString();
    print(urlstring);
    final url = Uri.parse(urlstring);
    Response response = await get(url);
    if (response.statusCode == 200) {
      getReserveSpace(bayID, bookingtime, duration, user);
    } else {
      print('fail');
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('/checkSpace Endpoint Failure'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Unable to check BayID: ' + bayID.toString()),
                  Text(''),
                  Text('Please go back and try booking another spot.'),
                  Text(''),
                  Text(
                    'Error: ' + response.body,
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

  // //Data source yup
  // List<String> getListElement() {
  //   var items =
  //       List<String>.generate(1000, (index) => "LOCATION --- MELBOURNE $index");
  //   return items;
  // }

  Widget getListView() {
    final DateTime bookingdate = widget.bookingdate;
    final double duration = widget.duration;
    var listView = ListView.builder(
        itemCount: _bays.length,
        itemBuilder: (context, index) {
          if (_bays[index]["description"].length == 1) {
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
                    title: Text('Restrictions: ' +
                        _bays[index]["description"]["description1"]),
                    trailing: InkWell(
                      onTap: () async {
                        getCheckSpace(int.parse(_bays[index]["bayID"]),
                            bookingdate, duration, testuser);
                      },
                      child: Icon(Icons.book_online),
                    ),
                  )
                ],
                // onTap: () async {
                //   getCheckSpace(
                //       _bays[index]['bayID'], bookingdate, duration, testuser);
                // },
              ),
            );
          } else if (_bays[index]["description"].length == 2) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ExpansionTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                children: <Widget>[
                  ListTile(
                    title: Text('Restrictions: ' +
                        _bays[index]["description"]["description1"] +
                        ', ' +
                        _bays[index]["description"]["description2"]),
                    trailing: InkWell(
                      onTap: () async {
                        getCheckSpace(int.parse(_bays[index]["bayID"]),
                            bookingdate, duration, testuser);
                      },
                      child: Icon(Icons.book_online),
                    ),
                  )
                ],
              ),
            );
          } else if (_bays[index]["description"].length == 3) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ExpansionTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                children: <Widget>[
                  ListTile(
                    title: Text('Restrictions: ' +
                        _bays[index]["description"]["description1"] +
                        ', ' +
                        _bays[index]["description"]["description2"] +
                        ', ' +
                        _bays[index]["description"]["description3"]),
                    trailing: InkWell(
                      onTap: () async {
                        getCheckSpace(int.parse(_bays[index]["bayID"]),
                            bookingdate, duration, testuser);
                      },
                      child: Icon(Icons.book_online),
                    ),
                  )
                ],
              ),
            );
          } else if (_bays[index]["description"].length == 4) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ExpansionTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                children: <Widget>[
                  ListTile(
                    title: Text('Restrictions: ' +
                        _bays[index]["description"]["description1"] +
                        ', ' +
                        _bays[index]["description"]["description2"] +
                        ', ' +
                        _bays[index]["description"]["description3"] +
                        ', ' +
                        _bays[index]["description"]["description4"]),
                    trailing: InkWell(
                      onTap: () async {
                        getCheckSpace(int.parse(_bays[index]["bayID"]),
                            bookingdate, duration, testuser);
                      },
                      child: Icon(Icons.book_online),
                    ),
                  )
                ],
              ),
            );
          } else if (_bays[index]["description"].length == 5) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ExpansionTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                children: <Widget>[
                  ListTile(
                    title: Text('Restrictions: ' +
                        _bays[index]["description"]["description1"] +
                        ', ' +
                        _bays[index]["description"]["description2"] +
                        ', ' +
                        _bays[index]["description"]["description3"] +
                        ', ' +
                        _bays[index]["description"]["description4"] +
                        ', ' +
                        _bays[index]["description"]["description5"]),
                    trailing: InkWell(
                      onTap: () async {
                        getCheckSpace(int.parse(_bays[index]["bayID"]),
                            bookingdate, duration, testuser);
                      },
                      child: Icon(Icons.book_online),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text('failed to load data'),
              ),
            );
          }
        });
    return listView;
  }
}
