
import 'package:flutter/material.dart';

class SignedInView extends StatefulWidget {

  @override
  State<SignedInView> createState() => _SignedInView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SignedInView extends State<SignedInView> {
   TextEditingController _controller;
   String _results = '';
  @override
  void initState() {

    super.initState();
    _controller =  new TextEditingController();

  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar
      (
        title: const Text('Search for spot'),

      ),
      body:

      Column(
        children: <Widget>[
        TextField(
          controller: _controller,
          onSubmitted: (String value) {
            setState(() {

              _results = value;
            });

          }



        ),
        Text(_results),
      ]

      ),
    );
  }
}