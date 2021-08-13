import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

///EXAMPLE STATELESS WIDGET
// class ReserveSpaceView extends StatefulWidget {
//   @override
//   State<ReserveSpaceView> createState() => _ReserveSpaceView();
// }

// /// This is the private State class that goes with MyStatefulWidget.
// class _ReserveSpaceView extends State<ReserveSpaceView> {
//   late TextEditingController _controller;
//   String _results = '';
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ratioGen = new ScreenRatioGenerator(context: context);
//     return Scaffold(
//         appBar: AppBar(
//       toolbarHeight: ratioGen.screenHeightPercent(percent: 6),
//       title: const Text('Reserve Spaces'),
//     ));
//   }
// }

import 'package:flutter/material.dart';
//import 'package:flutter_signin_button/button_builder.dart';

/// Entrypoint example for registering via Email/Password.
class ReserveSpaces extends StatefulWidget {
  /// The page title.
  final String title = 'Registration';

  @override
  State<StatefulWidget> createState() => ReserveSpacesState();
}

class ReserveSpacesState extends State<ReserveSpaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView"),
      ),
      body: getListView(),
    );

    // throw UnimplementedError();
  }

  //Data source yup
  List<String> getListElement() {
    var items =
        List<String>.generate(1000, (index) => "LOCATION --- MELBOURNE $index");
    return items;
  }

  Widget getListView() {
    var listItems = getListElement();

    var listView = ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        title: Text(listItems[index]),
      );
    });
    return listView;
  }
}
