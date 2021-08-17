import 'dart:convert';
import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/create_password_view.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';

///EXAMPLE STATELESS WIDGET
class BookingConfView extends StatefulWidget {
  BookingConfView({
    Key? key,
    required this.jsonresponse,
  }) : super(key: key);
  final String jsonresponse;
  @override
  State<BookingConfView> createState() => _BookingConfView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BookingConfView extends State<BookingConfView> {
  late TextEditingController _controller;
  List confirmation = [];
  String _results = '';

  Future<void> readJson(String jsonresponse) async {
    final String response = jsonresponse;
    final responsedecoded = await json.decode(response);
    setState(() {
      confirmation = responsedecoded["bays"];
    });
  }

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
      title: const Text('Booking Confirmation'),
    ));
  }
}
