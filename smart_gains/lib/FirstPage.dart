// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:smart_gains/LogInPage.dart';

import 'package:smart_gains/training_session.dart';

import 'CreateAccountPage.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/womanImage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              bottomOpacity: 0,
              shadowColor: const Color.fromARGB(0, 0, 0, 0),
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  Expanded(
                    child: Center(
                        child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                      height: 60,
                    )),
                  ),
                  const Icon(Icons.more_vert)
                ],
              )),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(child: Container()),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    )),
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10),
                      child: Title(
                          color: const Color.fromARGB(255, 6, 6, 32),
                          child: const Center(
                            child: Text(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              "Get healthier and fit with our smart fitness coach",
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: Title(
                          color: const Color.fromARGB(255, 6, 6, 32),
                          child: const Center(
                            child: Text(
                              "Train from home, like you were in a gym, with our Interactive Fitness Coach",
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(320, 40),
                              shape: const StadiumBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 37, 171, 117)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAccountPage(title: "here")),
                            );
                          },
                          child: const Text("Get Started")),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            child: const Text("Log in"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LogInPage(title: "here")),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
