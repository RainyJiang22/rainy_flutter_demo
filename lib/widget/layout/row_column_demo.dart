import 'package:flutter/material.dart';

class RowColumnDemo extends StatelessWidget {
  const RowColumnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("hello world"),
            Text("I am Jack")
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("hello world"),
            Text("I am Jack")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: TextDirection.rtl,
          children: [
            Text("hello world"),
            Text("I am Jack")
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Text(" hello world ", style: TextStyle(fontSize: 30.0)),
            Text(" I am Jack "),
          ],
        ),
      ],
    );
  }
}
