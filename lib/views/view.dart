import 'dart:convert';

import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_parking_solutions/main.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';

///EXAMPLE STATELESS WIDGET
class View extends StatefulWidget {
  @override
  State<View> createState() => _View();
}

/// This is the private State class that goes with MyStatefulWidget.
class _View extends State<View> {
  late TextEditingController _controller;
  List _bookings = [];

  Future<void> getCurrentBookings() async {
    String urlstring =
        'http://' + localhost + ':8888/currentBookings?email=' + testuser;
    print(urlstring);
    final url = Uri.parse(urlstring);
    Response response = await get(url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(response.body);
      final responsedecoded = await json.decode(response.body);
      setState(() {
        _bookings = responsedecoded['bookings'];
      });
    }
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
                  height: ratioGen.screenHeightPercent(percent: 50),
                  width: ratioGen.screenWidthPercent(percent: 100),
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAlias,
                    child: ListView.builder(
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                                /*_bookings[index]['streetMarkerID']*/ _bookings[
                                    index]['bayID']),
                            title: Text(_bookings[index]['startDate']),
                            subtitle: Text(
                                'Location: ' /* +
                                _bookings[index]['lat'] +
                                ', ' +
                                _bookings[index]['long']*/
                                ),
                            trailing: InkWell(
                              onTap: () => null,
                              child: Icon(Icons.arrow_forward),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                    height: ratioGen.screenHeightPercent(percent: 19),
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
                    height: ratioGen.screenHeightPercent(percent: 19),
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
