import 'package:first_flutter_demo/navigation/pages/airplay_screen.dart';
import 'package:first_flutter_demo/navigation/pages/email_screen.dart';
import 'package:first_flutter_demo/navigation/pages/home_screen.dart';
import 'package:first_flutter_demo/navigation/pages/pages_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _selectedItemColor = Colors.blue;
  final _unselectedItemColor = Colors.grey;

  int _currentIndex = 0;
  List<Widget> list = [];

  @override
  void initState() {
    list
      ..add(HomeScreen())
      ..add(EmailScreen())
      ..add(PagesScreen())
      ..add(AirplayScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        unselectedItemColor: _unselectedItemColor,
        selectedItemColor: _selectedItemColor,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: _selectedItemColor,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: _unselectedItemColor,
        ),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Email'),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: 'Pages'),
          BottomNavigationBarItem(icon: Icon(Icons.airplay), label: 'AirPlay'),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
