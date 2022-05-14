import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class JsonGrid extends StatelessWidget {
  Map? jsonObject;
  JsonGrid({required Map this.jsonObject});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(jsonObject!.length, (index) {
        return Container(
          child: Text(
            '${jsonObject!.entries.elementAt(index).key.toString()}: ${jsonObject!.entries.elementAt(index).value.toString()}',
            style: TextStyle(fontSize: 20),
          ),
        );
      }),
    );
  }
}
