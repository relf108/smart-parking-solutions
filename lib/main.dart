import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions/views/search_spaces.dart';
import 'package:smart_parking_solutions/views/view.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';

import 'package:url_launcher/url_launcher.dart';
// ignore: implementation_imports
import 'package:smart_parking_solutions_common/src/credentials.dart';

//main method commenting
void main() {
  runApp(SmartParkingSolutions());
}

Map<int, Color> color = {
  50: Color.fromRGBO(242, 129, 129, .1),
  100: Color.fromRGBO(242, 129, 129, .2),
  200: Color.fromRGBO(242, 129, 129, .3),
  300: Color.fromRGBO(242, 129, 129, .4),
  400: Color.fromRGBO(242, 129, 129, .5),
  500: Color.fromRGBO(242, 129, 129, .6),
  600: Color.fromRGBO(242, 129, 129, .7),
  700: Color.fromRGBO(242, 129, 129, .8),
  800: Color.fromRGBO(242, 129, 129, .9),
  900: Color.fromRGBO(242, 129, 129, 1),
};

MaterialColor spsred = MaterialColor(0xfff28181, color);

class SmartParkingSolutions extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking Demo',
      theme: ThemeData(
          primarySwatch: Colors.red,
          backgroundColor: Color(0xfff28181),
          scaffoldBackgroundColor: Color(0xfff28181),
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

class _HomePageState extends State<HomePage> {
  Future<void> _launchURL() async {
    //const localhost = 'localhost';
    const localhost = '10.0.2.2';
    final url =
        'https://accounts.google.com/o/oauth2/v2/auth?scope=https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email&response_type=code&redirect_uri=http://$localhost:8888/authUser&client_id=${Credentials.clientID}';
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
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/smart_parking_logo.png"),
                  ),
                ),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: (MediaQuery.of(context).size.height) / 25,
              )
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('---Sign in with---')]),
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
                            return SignInView();
                          }))
                        },
                    child: Image.asset('assets/email.png',
                        height: (MediaQuery.of(context).size.height) / 25)),
                ElevatedButton(
                  onPressed: () async => {await _launchURL()},
                  child: Image.asset('assets/whitegoogle-512.png',
                      height: (MediaQuery.of(context).size.height) / 25),
                ),
              ],
            ),
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
                    child: Text('Home Screen')),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push<MaterialPageRoute>(context,
                              MaterialPageRoute(builder: (context) {
                            return SearchSpacesView();
                          }))
                        },
                    child: Text('Search Spaces')),
                ElevatedButton(
                  onPressed: () {
                    print("Button clicked");
                  },
                  child: Text('Reserve Spaces'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
