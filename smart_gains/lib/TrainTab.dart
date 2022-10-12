import 'package:flutter/material.dart';

import 'CameraPage.dart';
import 'models/exercise_model.dart';

class TrainTab extends StatelessWidget {
  const TrainTab({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
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
    );
  }
}

void showModal(BuildContext context, int index) {
  Widget closeButton = TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text('Close'),
  );

  Widget trainButton = ElevatedButton(
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraPage(
                    title: index,
                  )));
    },
    child: Text('Train!'),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Column(
        children: [
          Row(children: [
            Text(exercises[index].name,
                style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38)),
          ]),
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(exercises[index].instruction_image),
              fit: BoxFit.cover,
            )),
          ),
          Text(exercises[index].instructions)
        ],
      ),
      actions: [trainButton, closeButton],
    ),
  );
}
