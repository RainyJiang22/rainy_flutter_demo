import 'package:flutter/material.dart';

class FlexDemo extends StatelessWidget {
  const FlexDemo({super.key});

  @override
  Widget build(BuildContext context) {
    var count = 0;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flex demo')),
        body: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _createContainer(++count, Colors.red),
            _createContainer(++count, Colors.grey),
            _createContainer(++count, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _createContainer(int count, Color color) {
    return Expanded(
      flex: count,
      child: Container(height: 100, color: color),
    );
  }
}
