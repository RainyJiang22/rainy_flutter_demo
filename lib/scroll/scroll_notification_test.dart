import 'package:flutter/material.dart';

class ScrollNotificationTest extends StatefulWidget {
  const ScrollNotificationTest({super.key});

  @override
  State<ScrollNotificationTest> createState() => _ScrollNotificationTestState();
}

class _ScrollNotificationTestState extends State<ScrollNotificationTest> {
  String _progress = "0%";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('scroll notification demo')),
      body: Scrollbar(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            double progress =
                notification.metrics.pixels /
                notification.metrics.maxScrollExtent;
            setState(() {
              _progress = "${(progress * 100).toInt()}%";
            });
            print("BottomEdge: ${notification.metrics.extentAfter == 0}");
            return false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListView.builder(
                itemCount: 100,
                itemExtent: 50.0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text("$index"));
                },
              ),
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.black54,
                child: Text(_progress),
              )
            ],
          ),
        ),
      ),
    );
  }
}
