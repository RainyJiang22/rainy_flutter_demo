import 'dart:math';

import 'package:flutter/material.dart';

class TransformDemo extends StatelessWidget {
  const TransformDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transform Demo')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Transform.translate(
              offset: Offset(-20.0, -5.0),
              child: Text("Hello World"),
            ),
          ),
          SizedBox(height: 130.0),
          Container(
            color: Colors.black,
            child: Transform(
              alignment: Alignment.topRight,
              transform: Matrix4.skewY(0.3),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.deepOrange,
                child: const Text('Apartment for rent!'),
              ),
            ),
          ),
          SizedBox(height: 130.0),
          //旋转
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Transform.rotate(angle: pi / 2, child: Text("Hello World")),
          ),
          SizedBox(height: 130.0),
          //缩放
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.red),
            child: Transform.scale(
              scale: 1.5, //放大到1.5倍
              child: Text("Hello world"),
            ),
          ),
          SizedBox(height: 130.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                //将Transform.rotate换成RotatedBox
                child: RotatedBox(
                  quarterTurns: 1, //旋转90度(1/4圈)
                  child: Text("Hello world"),
                ),
              ),
              Text("你好", style: TextStyle(color: Colors.green, fontSize: 18.0),)
            ],
          ),
        ],
      ),
    );
  }
}
