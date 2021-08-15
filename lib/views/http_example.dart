import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';
import 'package:http/http.dart';
import 'dart:convert';

const urlPrefix = 'http://10.0.2.2:5000';
String responsestring = '';

Future<String> makeGetRequest(String user) async {
  final url = Uri.parse('http://10.0.2.2:5000/currentBookings?user=' + user);
  Response response = await get(url);
  print('Status code: ${response.statusCode}');
  print('Headers: ${response.headers}');
  print('Body: ${response.body}');
  responsestring = await response.body;
  return responsestring;
}

///EXAMPLE STATELESS WIDGET
class HttpExample extends StatefulWidget {
  @override
  State<HttpExample> createState() => _HttpExample();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HttpExample extends State<HttpExample> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  String _results = '';
  @override
  void initState() {
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
    final username = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ratioGen.screenHeightPercent(percent: 6),
        title: const Text('HTTP GET EXAMPLE'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ratioGen.screenWidthPercent(percent: 50),
                      child: TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person), labelText: 'Username:'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () => [
                          makeGetRequest(username.text),
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                        'User ' + username.text + ' response:'),
                                    content: Text(responsestring),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ))
                        ],
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
