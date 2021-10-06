import 'dart:convert';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/views/102063393.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import '../main.dart';

class SearchSpacesView extends StatefulWidget {
  @override
  State<SearchSpacesView> createState() => _SearchSpacesView();
}

Future<void> makeGetRequest(String address, String radius, DateTime date,
    DateTime time, Duration duration, BuildContext context) async {
  print('Address: $address Radius $radius');
  var bookingdatetime = DateTime.parse(
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00');
  print(bookingdatetime);
  String urlstring = 'http://' +
      localhost +
      ':8888/searchSpaces?address=' +
      address +
      '&distance=' +
      radius;
  final url = Uri.parse(urlstring);
  print(urlstring);
  Response response = await get(url);
  final body = json.decode(response.body);
  print(response.body);
  if (body['numberOfSpaces'] > 0) {
    Navigator.pop(context);
    Navigator.push<MaterialPageRoute>(context,
        MaterialPageRoute(builder: (context) {
      return ReserveSpaceView(
          jsonresponse: response.body,
          startDate: bookingdatetime,
          duration: duration);
    }));
  } else if (body['numberOfSpaces'] == 0) {
    print('fail - no spaces');
    Navigator.pop(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Bays Found'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Uh oh!'),
                Text(''),
                Text(
                    'Seems like there are no parking bays available, maybe try a different address or time?'),
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
  } else {
    print('fail');
    Navigator.pop(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('/searchSpace Endpoint Failure'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Unable to search parking bays.'),
                Text(''),
                Text('Please try again, or try different search parameters.'),
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
  Navigator.push<MaterialPageRoute>(context,
      MaterialPageRoute(builder: (context) {
    return ReserveSpaceView(
      jsonresponse: response.body,
      startDate: bookingdatetime,
      duration: duration,
    );
  }));
}

/// This is the private State class that goes with MyStatefulWidget.
class _SearchSpacesView extends State<SearchSpacesView> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final address = TextEditingController();
  late int _radius = 100;
  Duration _duration = Duration(minutes: 30);
  String _date = "Not set";
  String _time = "Not set";
  late DateTime seldate, seltime;
  late TextEditingController _controller;

  get late => null;
  @override
  void initState() {
    super.initState();
  }

  void reset() {
    //textformfield.clear();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));

    setState(() {});
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
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: ratioGen.screenHeightPercent(percent: 6),
          title: const Text('Search Parking Spaces'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: ratioGen.screenWidthPercent(percent: 90),
                                child: TextFormField(
                                  controller: address,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      labelText: 'Enter destination here:',
                                      labelStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(children: <Widget>[
                                Container(
                                  width:
                                      ratioGen.screenWidthPercent(percent: 90),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 1, 1),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        print('confirm $date');
                                        _date =
                                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                        seldate = DateTime.parse(_date);
                                        print('seldate $seldate');
                                        setState(() {});
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.date_range,
                                                      size: 18.0,
                                                    ),
                                                    Text(" $_date"),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Text("Select date"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(children: <Widget>[
                                Container(
                                    width: ratioGen.screenWidthPercent(
                                        percent: 90),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        DatePicker.showTimePicker(context,
                                            showTitleActions: true,
                                            onConfirm: (time) {
                                          print('confirm $time');
                                          _time =
                                              '${seldate.year}-${seldate.month.toString().padLeft(2, '0')}-${seldate.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
                                          seltime = DateTime.parse(_time);
                                          print('seltime $seltime');
                                          setState(() {});
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                        setState(() {});
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.access_time,
                                                        size: 18.0,
                                                      ),
                                                      Text(" $_time"),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text("  Select time"),
                                          ],
                                        ),
                                      ),
                                    )),
                              ]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(children: <Widget>[
                                Container(
                                    width: ratioGen.screenWidthPercent(
                                        percent: 90),
                                    child: Column(children: <Widget>[
                                      DropdownButtonFormField<String>(
                                          style: TextStyle(color: Colors.black),
                                          value: _duration.toString(),
                                          items: [
                                            Duration(minutes: 30).toString(),
                                            Duration(hours: 1).toString(),
                                            Duration(hours: 1, minutes: 30)
                                                .toString(),
                                            Duration(hours: 2).toString(),
                                            Duration(hours: 2, minutes: 30)
                                                .toString(),
                                            Duration(hours: 3).toString(),
                                            Duration(hours: 3, minutes: 30)
                                                .toString(),
                                            Duration(hours: 4).toString()
                                          ]
                                              .map((label) => DropdownMenuItem(
                                                    child:
                                                        Text(label.toString()),
                                                    value: label,
                                                  ))
                                              .toList(),
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Parking duration (hours)',
                                              labelStyle: TextStyle(
                                                  color: Colors.white)),
                                          onChanged: (value) {
                                            setState(() {
                                              _duration = value! as Duration;
                                            });
                                          })
                                    ])),
                              ]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(children: <Widget>[
                                Container(
                                    width: ratioGen.screenWidthPercent(
                                        percent: 90),
                                    child: Column(children: <Widget>[
                                      DropdownButtonFormField<int>(
                                          style: TextStyle(color: Colors.black),
                                          value: _radius,
                                          items: [100, 200, 500, 1000, 2000]
                                              .map((label) => DropdownMenuItem(
                                                    child:
                                                        Text(label.toString()),
                                                    value: label,
                                                  ))
                                              .toList(),
                                          hint: Text('Radius'),
                                          decoration: InputDecoration(
                                              labelText: 'Radius (m)',
                                              labelStyle: TextStyle(
                                                  color: Colors.white)),
                                          onChanged: (value) {
                                            setState(() {
                                              _radius = value!;
                                            });
                                          })
                                    ])),
                              ]),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height:
                                    ratioGen.screenHeightPercent(percent: 5),
                              )
                            ],
                          ),
                          Row(children: [
                            Container(
                              // height: 120.0,
                              width: ratioGen.screenWidthPercent(percent: 40),
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    onPressed: () => {reset()},
                                    child: Text('Reset')),
                              ),
                            ),
                            Container(
                              width: ratioGen.screenWidthPercent(percent: 40),
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return loading;
                                        },
                                      );
                                      makeGetRequest(
                                          address.text,
                                          _radius.toString(),
                                          seldate,
                                          seltime,
                                          _duration,
                                          context);
                                    },
                                    child: Text('Submit')),
                              ),
                            ),
                          ]),
                        ],
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
