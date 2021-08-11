import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

///EXAMPLE STATELESS WIDGET
class HttpExample extends StatefulWidget {
  @override
  State<HttpExample> createState() => _HttpExample();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HttpExample extends State<HttpExample> {
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
        title: const Text('HTTP GET EXAMPLE'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Username',
              labelText: 'Test#',
            ))
          ],
        ),
      ),
    );
  }
}
