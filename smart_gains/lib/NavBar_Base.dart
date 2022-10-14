import 'package:flutter/material.dart';

import 'StatisticsTab.dart';
import 'TrainTab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  List pages = [
    StatisticsTab(
      title: 'statistics',
    ),
    const TrainTab(
      title: 'train',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Statistics',
            icon: Icon(Icons.insights),
          ),
          BottomNavigationBarItem(
            label: 'Train',
            icon: Icon(Icons.timer),
          ),
        ],
      ),
    );
  }
}
