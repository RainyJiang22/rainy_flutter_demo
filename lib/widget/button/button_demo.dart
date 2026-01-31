import 'dart:ui';

import 'package:flutter/material.dart';

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('按钮及其标题')),
      body: Column(
        children: [
          ElevatedButton(child: Text("normal"), onPressed: () {}),
          SizedBox(height: 10),
          TextButton(onPressed: () {}, child: Text('normal')),
          SizedBox(height: 10),
          OutlinedButton(child: Text("normal"), onPressed: () {}),
          IconButton(onPressed: () {}, icon: Icon(Icons.light)),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.send),
                label: Text("发送"),
                onPressed:() {},
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.add),
                label: Text("添加"),
                onPressed:() {},
              ),
              TextButton.icon(
                icon: Icon(Icons.info),
                label: Text("详情"),
                onPressed: () {},
              ),
            ],
          ),
        ],

      ),
    );
  }
}
