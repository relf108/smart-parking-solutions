import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dimension_ratios/screen_ratio_generator.dart';
import 'package:smart_parking_solutions/views/view.dart';
import 'package:smart_parking_solutions/views/reserve_space.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';
import 'package:loading_animations/loading_animations.dart';

import 'package:url_launcher/url_launcher.dart';

import 'views/booking_conf.dart';
// ignore: implementation_imports
//import 'package:smart_parking_solutions_common/src/credentials.dart';

const localhost = '192.168.87.86';
String testuser = 'tristan.sutton@gmail.com';
var bookingdate = new DateTime.now();
String duration = '1:30:00';

//main method commenting
Future<void> main() async {
  runApp(SmartParkingSolutions());
}

AlertDialog loading = AlertDialog(
  backgroundColor: spsblue,
  content: LoadingBouncingGrid.square(
    backgroundColor: spsblue,
    borderColor: Color(0xff4169E1),
  ),
);

Map<int, Color> color = {
  50: Color.fromRGBO(25, 25, 112, .1),
  100: Color.fromRGBO(25, 25, 112, .2),
  200: Color.fromRGBO(25, 25, 112, .3),
  300: Color.fromRGBO(25, 25, 112, .4),
  400: Color.fromRGBO(25, 25, 112, .5),
  500: Color.fromRGBO(25, 25, 112, .6),
  600: Color.fromRGBO(25, 25, 112, .7),
  700: Color.fromRGBO(25, 25, 112, .8),
  800: Color.fromRGBO(25, 25, 112, .9),
  900: Color.fromRGBO(25, 25, 112, 1),
};

MaterialColor spsblue = MaterialColor(0xff191970, color);

class SmartParkingSolutions extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking Demo',
      theme: ThemeData(
          primarySwatch: spsblue,
          backgroundColor: Color(0xff4169E1),
          scaffoldBackgroundColor: Color(0xff4169E1),
          textTheme:
              TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle()).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          )),
      home: HomePage(title: 'Smart Parking Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

String response = '';
Future<void> readJson() async {
  response = await rootBundle.loadString('assets/testresponsedata.json');
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  Future<void> _launchURL() async {
    // const localhost = 'localhost';
    final url =
        'https://accounts.google.com/o/oauth2/v2/auth?scope=https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email&response_type=code&redirect_uri=http://$localhost:8888/authUser&client_id=${Credentials.clientID}';
    if (Platform.isAndroid || Platform.isIOS) {
      await launch(url);
    } else {
      // ignore: todo
      //TODO pop browser tab on desktop/web
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/smart_parking_logo_b2.png"),
                  ),
                ),
              )
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('---Sign in with---')]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: (MediaQuery.of(context).size.height) / 50,
              )
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('---Page Testing---')]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: (MediaQuery.of(context).size.height) / 50,
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push<MaterialPageRoute>(context,
                              MaterialPageRoute(builder: (context) {
                            return View();
                          }))
                        },
                    child: Text('Home')),
                ElevatedButton(
                  onPressed: () => [
                    Navigator.push<MaterialPageRoute>(context,
                        MaterialPageRoute(builder: (context) {
                      return ReserveSpaceView(
                        jsonresponse:
                            '{"numberOfSpaces":8,"bays":[{"distance":"1082","lat":"-37.80927403563136","long":"144.9740444973502","bayID":"5584","streetMarkerID":"12202N","description":{"description1":"2P MTR M-F 7:30-16:00","description2":"2P MTR SAT 7:30-12:30"}},{"distance":"529","lat":"-37.80793927082333","long":"144.96599596432765","bayID":"2749","streetMarkerID":"4580E","description":{"description1":"2P MTR M-SAT 7:30-20:30"}},{"distance":"589","lat":"-37.807708853788455","long":"144.96630832170874","bayID":"3408","streetMarkerID":"6257S","description":{"description1":"4P MTR M-SAT 7.30-8.30"}},{"distance":"578","lat":"-37.80774341058874","long":"144.9661907526817","bayID":"3414","streetMarkerID":"6263S","description":{"description1":"4P MTR M-SAT 7.30-8.30"}},{"distance":"593","lat":"-37.80740153209552","long":"144.96591541546846","bayID":"2753","streetMarkerID":"4592E","description":{"description1":"2P MTR M-SAT 7:30-20:30"}},{"distance":"587","lat":"-37.80745530729499","long":"144.9659084655904","bayID":"2752","streetMarkerID":"4590E","description":{"description1":"2P MTR M-SAT 7:30-20:30"}},{"distance":"592","lat":"-37.80760467000953","long":"144.9663048493107","bayID":"3405","streetMarkerID":"6254N","description":{"description1":"4P MTR M-SAT 7.30-8.30"}},{"distance":"599","lat":"-37.80758513511026","long":"144.96637132175528","bayID":"3403","streetMarkerID":"6252N","description":{"description1":"4P MTR M-SAT 7.30-8.30"}}]}',
                        bookingdate: bookingdate,
                        duration: duration,
                      );
                    }))
                  ],
                  child: Text('Reserve'),
                ),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push<MaterialPageRoute>(context,
                              MaterialPageRoute(builder: (context) {
                            return BookingConfView(
                              streetMarkerID: '1773S',
                              lat: '-37.816713050808474',
                              long: '144.9662354050186',
                              bookingdate: '2021-08-22 08:03:07Z',
                            );
                          }))
                        },
                    child: Text('Confirmation')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
