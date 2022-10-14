import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:smart_gains/Report.dart';

import 'CameraPage.dart';
import 'models/exercise_model.dart';

class TrainTab extends StatelessWidget {
  const TrainTab({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 260.0,
                child: Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      iconTheme: const IconThemeData(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      elevation: 0,
                      bottomOpacity: 0,
                    ),
                    body: Container(
                      height: 300.0,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/deadLift.jpg"),
                        fit: BoxFit.cover,
                      )),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Free Style",
                                  style: TextStyle(
                                      fontSize: 33,
                                      color: Colors.white,
                                      fontFamily: 'KronaOne-Regular',
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Choose your training",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'KronaOne-Regular'),
                                ),
                                SizedBox(height: 8)
                              ]),
                        ],
                      ),
                    ))),
            Container(
              height: 424,
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        showModal(context, index);
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 0.0, bottom: 5.0, right: 10, left: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset(exercises[index]
                                          .icon), //add image location here
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          exercises[index].name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black38),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          exercises[index].description,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ])));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showModal(BuildContext context, int index) {
  Widget closeButton = TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text('Close',
        style: TextStyle(color: Color.fromARGB(255, 37, 171, 117))),
  );

  Widget trainButton = ElevatedButton(
    onPressed: () {
      Navigator.pop(context);
      //showModal2(context, index);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ReportTab(
                    title: '',
                  )));
    },
    // style: ButtonStyle(backgroundColor: Color.fromARGB(255, 37, 171, 117)),
    child: Text('Train!'),
  );

  var weights = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Row(children: [
              Text(exercises[index].name,
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38)),
            ]),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(exercises[index].instruction_image),
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(height: 20),
            Text(exercises[index].instructions),
            Row(children: [
              Text("Any weights?"),
              SizedBox(width: 10),
              Container(
                width: 70,
                height: 30,
                child: TextField(
                  controller: weights,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                  width: 42,
                  child: ElevatedButton(
                      onPressed: () {}, child: Text("+", style: TextStyle())))
            ]),
          ],
        ),
      ),
      actions: [trainButton, closeButton],
    ),
  );
}

void sendMessage(String username, String weights, String exercise) async {
  var map = new Map<String, dynamic>();
  map['weight'] = weights;
  map['exercise'] = exercise;

  final response = await http.put(
      Uri.parse('http://192.168.10.103/user?username=$username'),
      body: map);
}

void showModal2(BuildContext context, int exercise_idx) {
  Widget okButton = ElevatedButton(
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraPage(
                    title: exercise_idx,
                  )));
    },
    child: Text('OK'),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: const [
              Text("Instructions",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38)),
            ]),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(exercises[exercise_idx].starter_pose),
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(height: 20),
            Text(exercises[exercise_idx].camera_positioning),
          ],
        ),
      ),
      actions: [okButton],
    ),
  );
}
