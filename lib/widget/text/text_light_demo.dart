import 'package:flutter/material.dart';

class TextLightDemo extends StatelessWidget {
  const TextLightDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('文本以及样式')),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
            child: Column(
              children: [
                Text('Hello World', textAlign: TextAlign.left),
                SizedBox(height: 10),
                Text(
                  'Hello World! I am jack' * 4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                //textScaleFactor已经过时了，需要替换成TextScaler.linear(double scaler)
                Text("Hello world", textScaler: TextScaler.linear(1.5)),
                SizedBox(height: 10),
                Text(
                  "Hello world",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18.0,
                    height: 1.2,
                    fontFamily: "Courier",
                    background: Paint()..color = Colors.yellow,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
                SizedBox(height: 10),
                Text('text富文本:'),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Home'),
                      TextSpan(
                        text: 'https://flutterchina.club',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                Text('text defaultText'),
                DefaultTextStyle(style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                ), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("hello world"),
                    Text("I am Jack"),
                    Text("I am Jack",
                      style: TextStyle(
                          inherit: false, //2.不继承默认样式
                          color: Colors.grey
                      ),
                    ),
                    Text("I am Jacky Tallow for animation ")
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
