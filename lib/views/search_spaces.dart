import 'dart:ffi';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/main.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';

class SearchSpacesView extends StatefulWidget {
  @override
  State<SearchSpacesView> createState() => _SearchSpacesView();
}

String resp = '';

Future<String> makeGetRequest(String address, String radius) async {
  final url = Uri.parse('http://192.168.87.86:5000/searchSpaces?address=' +
      address +
      '&distance=' +
      radius);
  Response response = await get(url);
  print('Status code: ${response.statusCode}');
  print('Headers: ${response.headers}');
  print('Body: ${response.body}');
  resp = response.statusCode.toString();
  return response.statusCode.toString();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SearchSpacesView extends State<SearchSpacesView> {
  late int _radius = 100;
  var _value;
  double _duration = 0.5;
  String _date = "Not set";
  String _time = "Not set";
  late TextEditingController _controller;
  String _results = '';

  get late => null;
  @override
  void initState() {
    super.initState();
  }

  void reset() {
    //textformfield.clear();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));

    setState(() {
      _value = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratioGen = new ScreenRatioGenerator(context: context);
    final address = TextEditingController();
    final username = TextEditingController();
    final arrivaltime = TextEditingController();
    final date = TextEditingController();
    final radius = TextEditingController();
    final duration = TextEditingController();
    return Scaffold(
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
                  Container(
                    width: ratioGen.screenWidthPercent(percent: 90),
                    child: TextFormField(
                      controller: address,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Enter destination here:',
                          labelStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: <Widget>[
                    Container(
                      width: ratioGen.screenWidthPercent(percent: 90),
                      child: ElevatedButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2000, 1, 1),
                              maxTime: DateTime(2022, 12, 31),
                              onConfirm: (date) {
                            print('confirm $date');
                            _date =
                                '${date.year} - ${date.month} - ${date.day}';
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        width: ratioGen.screenWidthPercent(percent: 90),
                        child: ElevatedButton(
                          onPressed: () {
                            DatePicker.showTimePicker(context,
                                showTitleActions: true, onConfirm: (time) {
                              print('confirm $time');
                              _time = '${time.hour} : ${time.minute}';
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                            setState(() {});
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        width: ratioGen.screenWidthPercent(percent: 90),
                        child: Column(children: <Widget>[
                          DropdownButtonFormField<double>(
                              style: TextStyle(color: Colors.white),
                              value: _duration,
                              items: [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label.toString()),
                                        value: label,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                  labelText: 'Parking duration (hours)',
                                  labelStyle: TextStyle(color: Colors.white)),
                              onChanged: (value) {
                                setState(() {
                                  _duration = value!;
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
                        width: ratioGen.screenWidthPercent(percent: 90),
                        child: Column(children: <Widget>[
                          DropdownButtonFormField<int>(
                              style: TextStyle(color: Colors.white),
                              value: _radius,
                              items: [100, 200, 500, 1000, 2000]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label.toString()),
                                        value: label,
                                      ))
                                  .toList(),
                              hint: Text('Radius'),
                              decoration: InputDecoration(
                                  labelText: 'Radius (m)',
                                  labelStyle: TextStyle(color: Colors.white)),
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
                    height: ratioGen.screenHeightPercent(percent: 5),
                  )
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  width: ratioGen.screenWidthPercent(percent: 30),
                  child: ElevatedButton(
                      onPressed: () => {reset()}, child: Text('Reset')),
                ),
                Container(
                  width: ratioGen.screenWidthPercent(percent: 30),
                  child: ElevatedButton(
                      onPressed: () => {
                            [
                              makeGetRequest(address.text, _radius.toString()),
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('Response Code:'),
                                        content: Text(resp),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ))
                            ]
                          },
                      child: Text('Submit')),
                ),
              ]),
            ],
          ),
        ));
  }
}
