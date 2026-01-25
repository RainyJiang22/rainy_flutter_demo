import 'package:flutter/material.dart';

class GesturePage extends StatefulWidget {
  const GesturePage({super.key});

  @override
  State<GesturePage> createState() => _GesturePageState();
}

class _GesturePageState extends State<GesturePage> {
  String printString = '';
  double moveX = 0.0;
  double moveY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('如何监听用户手势')),
      body: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () => printMsg('点击'),
                  onDoubleTap: () => printMsg('双击'),
                  onLongPress: () => printMsg('长按'),
                  onTapCancel: () => printMsg('取消'),
                  onTapUp: (e) => printMsg('松开'),
                  onTapDown: (e) => printMsg('按下'),
                  child: Container(
                    padding: EdgeInsets.all(60),
                    decoration: BoxDecoration(color: Colors.blueAccent),
                    child: Text(
                      '点我',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                ),
                Text(printString),
              ],
            ),
            Positioned(
              left: moveX,
              top: moveY,
              child: GestureDetector(
                onPanUpdate: (e) => _doMove(e),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void printMsg(String s) {
    setState(() {
      printString += '.$s';
    });
  }

  void _doMove(DragUpdateDetails e) {
    setState(() {
      moveX = e.delta.dx;
      moveY = e.delta.dy;
    });
  }
}
