import 'package:flutter/material.dart';

class CenterColumnDemo extends StatelessWidget {
  const CenterColumnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text("hi"), Text("world")],
    );
  }
}
