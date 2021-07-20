import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class JsonGrid extends StatelessWidget {
  Map? jsonObject;
  JsonGrid({required jsonObject});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(jsonObject!.length, (index) {
        return Center(
          child: Text(
            'Item ${jsonObject![index].toString()}',
            style: Theme.of(context).textTheme.headline5,
          ),
        );
      }),
    );
  }
}
