import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

class SearchSpacesView extends StatefulWidget {
  @override
  State<SearchSpacesView> createState() => _SignedInView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SignedInView extends State<SearchSpacesView> {
  late TextEditingController _controller;
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
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: ratioGen.screenHeightPercent(percent: 6),
          title: const Text('Search for spot'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    constraints: BoxConstraints(
                        maxHeight: ratioGen.screenHeightPercent(percent: 5),
                        maxWidth: ratioGen.screenWidthPercent(percent: 5)),
                    child: Icon(
                      Icons.search,
                    )),
                Spacer(
                  flex: 1,
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: ratioGen.screenWidthPercent(percent: 90),
                      maxHeight: ratioGen.screenHeightPercent(percent: 5)),
                  child: TextField(
                      controller: _controller,
                      onSubmitted: (String value) {
                        setState(() {
                          _results = value;
                        });
                      }),
                )
              ],
            ),
            Text(_results),
            SingleChildScrollView(
                child: Container(
                    constraints: BoxConstraints(
                        maxHeight: ratioGen.screenHeightPercent(percent: 82),
                        maxWidth: ratioGen.screenWidthPercent(percent: 100)),
                    child: JsonGrid(
                        jsonObject: ParkingSpace(
                                bayID: '8346',
                                lat: '-37.81243621759688',
                                lon: '144.9678039100279',
                                location: Location(
                                    latitude: '-37.81243621759688',
                                    longitude: '144.9678039100279',
                                    humanAddress:
                                        '{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}'),
                                stMarkerID: '767Wa',
                                status: 'Unoccupied')
                            .toJson())))
          ],
        ));
  }
}
