import 'package:flutter/material.dart';

class AlignDemo extends StatelessWidget {
  const AlignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Center(
        child: Container(
          width: 120.0,
          height: 120.0,
          color: Colors.blue,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FlutterLogo(size: 60),
          ),
        ),
      ),
    );
  }

}