import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/main.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

///EXAMPLE STATELESS WIDGET
class BookingConfView extends StatefulWidget {
  BookingConfView({Key? key, required this.booking}) : super(key: key);
  final Booking booking;
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
    final streetMarkerID = widget.booking.bookedSpace.stMarkerID;
    final address = widget.booking.bookedSpace.location!.humanAddress;
    String bookingdate = 'From ${widget.booking.startDate} until ${widget.booking.endDate}';
    final ratioGen = new ScreenRatioGenerator(context: context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ratioGen.screenHeightPercent(percent: 6),
        title: const Text('Booking Confirmation'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 12.0, bottom: 80.0, top: 25.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    "Home",
                    style: TextStyle(color: Colors.teal.shade900),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SmartParkingSolutions()),
                    );
                  }),
            ),
            Column(
              children: <Widget>[
                //this creates a circular placeholder to display an image
                //in this case the confirmation image
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.red,
                  backgroundImage: AssetImage(
                    'assets/confirm.png',
                  ),
                ),

                //all SizedBox create space between items, ex. n image and text
                SizedBox(
                  height: 20.0,
                  width: 150.0,
                ),

                Text(
                  "Booking successful!",
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 20.0,
                  width: 150.0,
                  child: Divider(
                    color: Colors.teal.shade100,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        //icons are from the internet. just type Icon(Icon.) to view options
                        leading: Icon(
                          Icons.streetview,
                          color: Colors.teal.shade600,
                        ),
                        title: Text(
                          "Street ID: " + streetMarkerID!,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      )),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_city,
                          color: Colors.teal.shade600,
                        ),
                        title: Text(
                          "Location: " + address!,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      )),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.timer,
                          color: Colors.teal.shade600,
                        ),
                        title: Text(
                          'Booking Date/Time = ' + bookingdate,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
