import 'package:flutter/material.dart';

class AlignDemo extends StatelessWidget {
  const AlignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Align Demo")),
      // body: Container(
      //   width: 120.0,
      //   height: 120.0,
      //   color: Colors.blue.shade50,
      //   child: Align(
      //     alignment: Alignment.topRight,
      //     child: FlutterLogo(size: 60)
      //   ),
      // ),
      body: Align(
        widthFactor: 2,
        heightFactor: 2,
        //alignment: Alignment.topRight,
        alignment: Alignment(2,0.0),
        child: FlutterLogo(
          size: 60,
        ),
      ),
    );
  }
}
