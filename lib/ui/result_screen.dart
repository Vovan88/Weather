import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather/data/data.dart';

class ResultPage extends StatelessWidget {
  final DataWheather? dataWheather;
  final String title;
  const ResultPage({Key? key, required this.title, required this.dataWheather})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String plus = "";
    int temperature = 0;
    if (dataWheather != null) {
      temperature = (dataWheather!.temp - 273.15).round();
      if (temperature > 0) {
        plus = "+";
      }
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: [
            Container(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dataWheather!.name,
                  style: const TextStyle(color: Colors.green, fontSize: 30),
                ),
                Text(
                  plus + temperature.toString(),
                  style: TextStyle(
                      color: temperature > 0 ? Colors.red : Colors.blue,
                      fontSize: 60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
