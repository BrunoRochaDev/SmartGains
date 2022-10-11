import 'package:flutter/material.dart';
import 'package:smart_gains/FirstPage.dart';
import 'training_session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Camera Demo',
      debugShowCheckedModeBanner: false,
      home: FirstPage(title: "asdklasd"),
    );
  }
}
