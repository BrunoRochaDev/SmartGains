import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(255, 78, 75, 75)),
          elevation: 0,
          bottomOpacity: 0,
          shadowColor: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: const Center(child: Text("Smart Gains"))),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Second page"),
          ElevatedButton(onPressed: () {}, child: const Text("get fucked"))
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'home2',
          icon: Icon(Icons.settings),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Shop',
        ),
      ]),
    );
  }
}
