import 'package:flutter/material.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Statistics"),
    ));
  }
}
