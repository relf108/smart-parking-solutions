import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/widgets/json_grid.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

import 'package:url_launcher/url_launcher.dart';
// ignore: implementation_imports
import 'package:smart_parking_solutions_common/src/credentials.dart';

//main method commenting
void main() {
  runApp(SmartParkingSolutions());
}

class SmartParkingSolutions extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking Demo',
      theme: ThemeData(
          primarySwatch: Colors.red,
          backgroundColor: Colors.red,
          scaffoldBackgroundColor: Colors.red,
          textTheme:
              TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle()).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          )),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _launchURL() async {
    const localhost = 'localhost';
    //const localhost = '10.0.2.2';
    final url =
        'https://accounts.google.com/o/oauth2/v2/auth?scope=https://www.googleapis.com/auth/userinfo.profile&response_type=code&redirect_uri=http://$localhost:8888/authUser&client_id=${Credentials.clientID}';
    if (Platform.isAndroid || Platform.isIOS) {
      await launch(url);
    } else {
      //TODO pop browser tab on desktop/web
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          //play with this
          children: <Widget>[
            Image.asset(
              'assets/smart_parking_logo.png',
              fit: BoxFit.fill,
            ),
            ElevatedButton(
                onPressed: () => {
                      Navigator.push<MaterialPageRoute>(context,
                          MaterialPageRoute(builder: (context) {
                        return SignInView();
                      }))
                    },
                child: Text('Sign in')),
            ElevatedButton(
                onPressed: () => {
                      Navigator.push<MaterialPageRoute>(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchSpacesView();
                      }))
                    },
                child: Text('Developer Sign in Bypass')),
            ElevatedButton(
                onPressed: () async => {await _launchURL()},
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/google_logo.jpg',
                      scale: 20,
                    ),
                    Text('  Sign up with google'),
                  ],
                )),
            // Spacer(
            //   flex: 1,
            // ),
            ///TODO move following container to parking space view and change test vals to pull from REST API
            Container(
                constraints: BoxConstraints(maxHeight: 100, maxWidth: 400),
                child: JsonGrid(
                    jsonObject: ParkingSpace(
                            bayId: '8346',
                            lat: '-37.81243621759688',
                            lon: '144.9678039100279',
                            location: Location(
                                latitude: '-37.81243621759688',
                                longitude: '144.9678039100279',
                                humanAddress:
                                    '{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}'),
                            stMarkerId: '767Wa',
                            status: 'Unoccupied')
                        .toJson()))
          ],
        ),
      ),
    );
    //  ),
    //     ),
    //   ),
    // );
  }
}
