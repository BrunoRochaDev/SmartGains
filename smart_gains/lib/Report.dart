import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'CameraPage.dart';
import 'NavBar_Base.dart';
import 'models/exercise_model.dart';
import 'models/rep_model.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(height: 40),
        const Text("Set Report",
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 37, 171, 117))),
        Container(
          margin:
              const EdgeInsets.only(top: 0.0, bottom: 5.0, right: 10, left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text("Rep 1", style: TextStyle(fontSize: 30)),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/good.gif"),
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(height: 10),
                Text("Good rep!",
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                SizedBox(height: 40),
                Text("Rep 2", style: TextStyle(fontSize: 30)),
                SizedBox(height: 15),
                Container(
                  height: 300,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/bad_knee.gif"),
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(height: 10),
                Text("Don't bend your knees!",
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text("Don't bend your body forward!",
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
              ]),
        )
      ])),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Statistics',
            icon: Icon(Icons.insights),
          ),
          BottomNavigationBarItem(
            label: 'Train',
            icon: Icon(Icons.timer),
          ),
        ],
      ),
    );
  }
}
