import 'package:flutter/material.dart';

class Textdemo1 extends StatelessWidget {
  const Textdemo1({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      color: Colors.blue,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      letterSpacing: 10,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          color: Colors.cyanAccent.withAlpha(33),
          height: 76,
          child: const Text("RainyJiang26-2000", style: style),
        ),
      ],
    );
  }
}
