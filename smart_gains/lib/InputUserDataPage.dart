import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FitnessGoalsPage.dart';

const List<String> list = <String>[
  '1 time per week',
  '2 times per week',
  '3 times per week',
  '4 times per week',
  '5 times per week'
];

class InputUserData extends StatelessWidget {
  const InputUserData({Key? key, required this.title, required this.username})
      : super(key: key);
  final String title;
  final TextEditingController username;

  @override
  Widget build(BuildContext context) {
    final height = TextEditingController();
    final weight = TextEditingController();
    final gender = TextEditingController();
    final dateOfBirth = TextEditingController();
    final dailyGoal = TextEditingController();

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
              reverse: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Title(
                        color: const Color.fromARGB(255, 6, 6, 32),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "Information about yourself",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, bottom: 32, top: 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: weight,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon(Icons.scale),
                              hintText: 'Weigth',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: height,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon(Icons.square_foot),
                              hintText: 'Height',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: gender,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon(Icons.transgender),
                              hintText: 'Gender',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: dateOfBirth,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon(Icons.date_range),
                              hintText: 'dd/mm/yyyy',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: dailyGoal,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon(Icons.transgender),
                              hintText: 'Daily Goal',
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonExample(),
                        ),
                      ],
                    ),
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
                          sendToDB(username.text, height.text, weight.text,
                              gender.text, dateOfBirth.text, dailyGoal.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FitnessGoalsPage(title: "here")),
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

void sendToDB(String username, String height, String weight, String gender,
    String dateOfBirth, String dailyGoal) async {
  var map = new Map<String, dynamic>();
  map['height'] = height;
  map['weight'] = weight;
  map['gender'] = gender;
  map['dateOfBirth'] = dateOfBirth;
  map['dailyGoal'] = dailyGoal;

  final response = await http.post(
      Uri.parse('http://192.168.10.151:8393/user?username=$username'),
      body: map);
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
