import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name:' hello')
class SingleChildScrollViewTestRoute extends StatelessWidget {
  const SingleChildScrollViewTestRoute({super.key});

  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scaffold(
      appBar: AppBar(title: Text('SingleChildScroll Demo')),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              //动态创建一个List<Widget>
              children: str.split("")
              //每一个字母都用一个Text显示,字体为原来的两倍
                  .map((c) => Text(c, textScaler: TextScaler.linear(2.0),))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
