import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_parking_solutions/credentials.dart';

void main() {
  runApp(SmartParkingSolutions());
}

class SmartParkingSolutions extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _launchURL() async {
    const localhost = 'localhost';
    //const localhost = '10.0.2.2';
    const url =
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
            ElevatedButton(
                onPressed: () async => {await _launchURL()},
                child: Text('Sign in with google'))
          ],
        ),
      ),
    );
  }
}
