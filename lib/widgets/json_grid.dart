import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class JsonGrid extends StatelessWidget {
  Map? jsonObject;
  JsonGrid({required Map this.jsonObject});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 1,

      // Generate 100 widgets that display their index in the List.
      children: List.generate(jsonObject!.length, (index) {
        return Container(
          height: 20,
          constraints: BoxConstraints(maxWidth: 300, maxHeight: 20),
          child: Text(
            'key: ${jsonObject!.entries.elementAt(index).key.toString()} value: ${jsonObject!.entries.elementAt(index).value.toString()}',
            style: TextStyle(fontSize: 20),
            
          ),
        );
      }),
    );
  }
}
