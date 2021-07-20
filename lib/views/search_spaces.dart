
import 'package:flutter/material.dart';

class SearchSpacesView extends StatefulWidget {

  @override
  State<SearchSpacesView> createState() => _SignedInView();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SignedInView extends State<SearchSpacesView> {
   late TextEditingController _controller;
   String _results = '';
  @override
  void initState() {

    super.initState();
    _controller =  TextEditingController();

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