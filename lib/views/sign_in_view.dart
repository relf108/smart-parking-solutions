import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final List<String> _searchHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        
        child: Column(
          children: <Widget>[
            Text('Test' ),
            Text('TODO'),
          ],
        ),
      ),
    );
  }
}
