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
          Row()
        ],
      ),
    ));
  }
}
