import 'package:flutter/material.dart';
import 'package:smart_gains/NavBar_Base.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final username = TextEditingController();

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
                          "Sign in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, bottom: 32, top: 64),
                    child: TextField(
                      controller: username,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Username',
                      ),
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
                        hintText: 'password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, bottom: 32, top: 32),
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
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        child: const Text("Log In")),
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
