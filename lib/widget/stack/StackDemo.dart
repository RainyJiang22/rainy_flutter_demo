import 'package:flutter/material.dart';

class StackDemo extends StatelessWidget {
  const StackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Stack Demo')),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: _createContainerList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _createContainerList() {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.black,
      Colors.grey,
      Colors.green,
    ];
    List<Widget> containerList = [];

    for (int i = 5; i > 0; i--) {
      containerList.add(
        Container(height: 100.0 * i, width: 100.0 * i, color: colors[i - 1]),
      );
    }
    return containerList;
  }
}
