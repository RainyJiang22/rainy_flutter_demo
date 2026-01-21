import 'package:flutter/material.dart';

//流动布局
class FlowDemo extends StatelessWidget {
  const FlowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    num size = 50.0;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flow Demo')),
        body: Flow(
          delegate: CrossFlowDelegate(),
          children: List<Widget>.generate(
            5,
            (int index) => Container(
              width: size.toDouble(),
              height: size.toDouble(),
              alignment: Alignment.center,
              color: index == 2 ? Colors.red : Colors.blue,
              child: Text(
                index.toString(),
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CrossFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    final double size = context.getChildSize(0)?.width ?? 0;

    context.paintChild(
      2,
      transform: Matrix4.translationValues(2 * size, size, 0.0),
    );
    context.paintChild(
      0,
      transform: Matrix4.translationValues(2 * size, 0, 0.0),
    );
    context.paintChild(
      1,
      transform: Matrix4.translationValues(size, size, 0.0),
    );
    context.paintChild(
      3,
      transform: Matrix4.translationValues(3 * size, size, 0.0),
    );
    context.paintChild(
      4,
      transform: Matrix4.translationValues(2 * size, 2 * size, 0.0),
    );
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}
