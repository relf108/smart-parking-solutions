import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_parking_solutions/views/sign_in_view.dart';
import 'package:smart_parking_solutions_common/smart_parking_solutions_common.dart';
import 'package:loading_animations/loading_animations.dart';

import 'package:url_launcher/url_launcher.dart';

const localhost = 'geekayk.ddns.net';
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: (MediaQuery.of(context).size.height) / 50,
              )
            ]),
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
                    child: Text('Sign in')),
                ElevatedButton(
                    onPressed: () => {_launchURL()}, child: Text('Register')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
