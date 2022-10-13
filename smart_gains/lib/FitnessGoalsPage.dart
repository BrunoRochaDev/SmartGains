import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_gains/PreviousExerciseActivityPage.dart';
import 'package:http/http.dart' as http;

class FitnessGoalsPage extends StatelessWidget {
  const FitnessGoalsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  void sendMessage() async {
    final response = await http.post(
        Uri.parse('http://192.168.10.151:8393/user?username=filipe%27'),
        body: jsonEncode(<String, String>{
          'email': "filie",
        }));
  }

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
              centerTitle: true,
              elevation: 0,
              bottomOpacity: 0,
              shadowColor: const Color.fromARGB(0, 0, 0, 0),
              backgroundColor: Colors.transparent,
              title: Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
                height: 60,
              )),
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            alignment: FractionalOffset.center,
            child: SingleChildScrollView(
              reverse: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Title(
                        color: const Color.fromARGB(255, 6, 6, 32),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "Your Fitness Goals",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(
                        title: "Get healthier in body and mind"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(title: "Lose weight/fat"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(title: "Gain weight/muscle"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(
                        title: "Lose fat and gain muscle (aka “tone” up)"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(
                        title: "Specific Doctor-given weight or exercise goal"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(
                        title:
                            "Strengthen the heart and decrease resting heart rate"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(
                        title:
                            "Build muscle and increase your resting metabolism"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(title: "Gain Flexibility"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(title: "Perfect your form"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: MyStatefulWidget(
                        title: "Be more explosive for a specific sport"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(320, 40),
                            shape: const StadiumBorder(),
                            backgroundColor:
                                const Color.fromARGB(255, 37, 171, 117)),
                        onPressed: () {
                          sendMessage();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PreviousAttivity(title: "here")),
                          );
                        },
                        child: const Text("Continue")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Container(
          height: 50,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 6, 6, 32),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Checkbox(
                  fillColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 37, 171, 117)),
                  activeColor: const Color.fromARGB(255, 37, 171, 117),
                  shape: const CircleBorder(),
                  value: value,
                  onChanged: (bool? newValue) {
                    onChanged(newValue!);
                  },
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  style: const TextStyle(color: Colors.white),
                  label,
                  textAlign: TextAlign.center,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(title);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _isSelected = false;
  String titulo = "";

  _MyStatefulWidgetState(String title) {
    titulo = title;
  }
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: titulo,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: _isSelected,
      onChanged: (bool newValue) {
        setState(() {
          _isSelected = newValue;
        });
      },
    );
  }
}
