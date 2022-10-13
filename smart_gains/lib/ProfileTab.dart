import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 64),
            child: Row(children: [
              Expanded(
                  child: Title(
                color: Colors.black,
                child: Text(
                  "Persons Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
              Container(
                height: 130.0,
                width: 130.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/womanImage.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.rectangle,
                ),
              )
            ]),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 64),
              child: Row(
                children: [
                  Container(
                    height: 260.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber,
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(child: Text("TDEE, Calaries")),
                  ),
                  Expanded(child: Container()),
                  Column(
                    children: [
                      Container(
                        height: 120.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber,
                          shape: BoxShape.rectangle,
                        ),
                        child: Center(
                            child: Text(
                          "Current Weight: 200kg",
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Container(
                        height: 120.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber,
                          shape: BoxShape.rectangle,
                        ),
                        child: Center(
                            child: Text(
                          "Height: 1.80 m",
                          textAlign: TextAlign.center,
                        )),
                      )
                    ],
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "My objectives",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
              child: Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/weight-progress-chart.png'),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.rectangle,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
            child: Row(
              children: [
                Container(
                  height: 120.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                      child: Text(
                    "Hours Trained this week 3/5 60%",
                    textAlign: TextAlign.center,
                  )),
                ),
                Expanded(child: Container()),
                Container(
                  height: 120.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                      child: Text(
                    "Hours Trained this month 10/59 16%",
                    textAlign: TextAlign.center,
                  )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Daily Tasks",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(child: Container()),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.edit),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
