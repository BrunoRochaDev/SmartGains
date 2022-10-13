import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'InputUserDataPage.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key, required this.title}) : super(key: key);
  final String title;

  void sendMessage(String email, String username, String password) async {
    var map = new Map<String, dynamic>();
    map['password'] = password;
    map['email'] = email;

    final response = await http.post(
        Uri.parse('http://192.168.10.151:8393/user?username=$username'),
        body: map);
  }

  @override
  Widget build(BuildContext context) {
    final myEmail = TextEditingController();
    final myUsername = TextEditingController();
    final myPassword = TextEditingController();

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
                          "Create your Smart Gains Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, bottom: 32, top: 32),
                    child: TextField(
                      controller: myEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: TextField(
                      controller: myUsername,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Usarname',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: TextField(
                      controller: myPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: const Icon(Icons.key),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: const Icon(Icons.key),
                        hintText: 'Repeat Password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
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
                          sendMessage(
                              myEmail.text, myUsername.text, myPassword.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InputUserData(title: "here")),
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
