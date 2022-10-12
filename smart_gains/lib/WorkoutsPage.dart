import 'package:flutter/material.dart';

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
        title: const Icon(Icons.menu),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 424,
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
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
