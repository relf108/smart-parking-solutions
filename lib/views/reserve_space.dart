import 'dart:convert';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';

///EXAMPLE STATELESS WIDGET
// ignore: must_be_immutable
class ReserveSpaceView extends StatefulWidget {
  ReserveSpaceView({Key? key, required this.jsonresponse}) : super(key: key);
  final String jsonresponse;
  @override
  State<ReserveSpaceView> createState() => _ReserveSpaceView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ReserveSpaceView extends State<ReserveSpaceView> {
  @override
  late TextEditingController _controller;
  List _bays = [];
  String _results = '';

  static get key => null;

  Future<void> getReserveSpace(
      int bayID, DateTime bookingtime, double duration, String user) async {
    //code here
  }

  Future<void> getCheckSpace(
      int bayID, DateTime bookingtime, double duration, String user) async {
    String urlstring = 'http://geekayk.ddns.net:8888/checkSpace?bayid=' +
        bayID.toString() +
        '&datetime=' +
        bookingtime.toString() +
        '&duration=' +
        duration.toString();
    final url = Uri.parse(urlstring);
    Response response = await get(url);
    if (response.statusCode == 200) {
      getReserveSpace(bayID, bookingtime, duration, user);
    } else {
      //error code for /checkSpace
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
    var listView = ListView.builder(
        itemCount: _bays.length,
        itemBuilder: (context, index) {
          if (_bays[index]["description"].length == 1) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Text(
                  _bays[index]["streetMarkerID"].toString(),
                  style: TextStyle(color: Colors.black),
                ),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                subtitle: Text('Restrictions: ' +
                    _bays[index]["description"]["description1"]),
                isThreeLine: true,
                //onTap: () async {getCheckSpace(_bays[index]['bayID'], bookingtime, duration, user)},
              ),
            );
          } else if (_bays[index]["description"].length == 2) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                subtitle: Text('Restrictions: ' +
                    _bays[index]["description"]["description1"] +
                    ', ' +
                    _bays[index]["description"]["description2"]),
                isThreeLine: true,
              ),
            );
          } else if (_bays[index]["description"].length == 3) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                subtitle: Text('Restrictions: ' +
                    _bays[index]["description"]["description1"] +
                    ', ' +
                    _bays[index]["description"]["description2"] +
                    ', ' +
                    _bays[index]["description"]["description3"]),
                isThreeLine: true,
              ),
            );
          } else if (_bays[index]["description"].length == 4) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                subtitle: Text('Restrictions: ' +
                    _bays[index]["description"]["description1"] +
                    ', ' +
                    _bays[index]["description"]["description2"] +
                    ', ' +
                    _bays[index]["description"]["description3"] +
                    ', ' +
                    _bays[index]["description"]["description4"]),
                isThreeLine: true,
              ),
            );
          } else if (_bays[index]["description"].length == 5) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Text(_bays[index]["streetMarkerID"].toString(),
                    style: TextStyle(color: Colors.black)),
                title: Text('Location: ' +
                    _bays[index]["lat"] +
                    ', ' +
                    _bays[index]["long"]),
                subtitle: Text('Restrictions: ' +
                    _bays[index]["description"]["description1"] +
                    ', ' +
                    _bays[index]["description"]["description2"] +
                    ', ' +
                    _bays[index]["description"]["description3"] +
                    ', ' +
                    _bays[index]["description"]["description4"] +
                    ', ' +
                    _bays[index]["description"]["description5"]),
                isThreeLine: true,
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
