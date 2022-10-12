import 'package:flutter/material.dart';
import 'package:smart_gains/CameraPage.dart';

import 'models/exercise_model.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        elevation: 0,
        bottomOpacity: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 424,
              decoration: const BoxDecoration(color: Colors.white),
              child: Title(
                color: Colors.black,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraPage()),
                          (Route<dynamic> route) => false);
                    },
                    child: Text("hsdkshd")),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          label: 'Statistics',
          icon: Icon(Icons.insights),
        ),
        BottomNavigationBarItem(
          label: 'Train',
          icon: Icon(Icons.timer),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ]),
    );
  }
}
