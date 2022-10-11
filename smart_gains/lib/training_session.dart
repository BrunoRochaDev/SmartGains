import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_page.dart';

class TrainingSession extends StatefulWidget {
  const TrainingSession({Key? key}) : super(key: key);

  @override
  State<TrainingSession> createState() => _TrainingSessionState();
}

class _TrainingSessionState extends State<TrainingSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: SafeArea(
        child: Center(
            child: ElevatedButton(
          onPressed: () async {
            await availableCameras().then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
          },
          child: const Text("Take a Picture"),
        )),
      ),
    );
  }
}
