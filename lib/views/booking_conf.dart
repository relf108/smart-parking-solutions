import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';

///EXAMPLE STATELESS WIDGET
class BookingConfView extends StatefulWidget {
  BookingConfView({
    Key? key,
    required this.streetMarkerID,
    required this.bookingdate,
    required this.lat,
    required this.long,
  }) : super(key: key);
  final String streetMarkerID;
  final String bookingdate;
  final String lat;
  final String long;
  @override
  State<BookingConfView> createState() => _BookingConfView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BookingConfView extends State<BookingConfView> {
  late TextEditingController _controller;
  List confirmation = [];

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
    final streetMarkerID = widget.streetMarkerID;
    final lat = widget.lat;
    final long = widget.long;
    String bookingdate = widget.bookingdate;
    final ratioGen = new ScreenRatioGenerator(context: context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ratioGen.screenHeightPercent(percent: 6),
        title: const Text('Booking Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('streetMarkerID = ' + streetMarkerID),
            Text('Location = ' + lat + ', ' + long),
            Text('Booking Date/Time = ' + bookingdate)
          ],
        ),
      ),
    );
  }
}
