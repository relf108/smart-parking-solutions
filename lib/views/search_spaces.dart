import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

class SearchSpacesView extends StatefulWidget {
  @override
  State<SearchSpacesView> createState() => _SearchSpacesView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SearchSpacesView extends State<SearchSpacesView> {
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
          title: const Text('Search Parking Spaces'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ratioGen.screenWidthPercent(percent: 100),
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Where are you going?'),
                ),
              )
            ],
          ),
        ));
  }
}
