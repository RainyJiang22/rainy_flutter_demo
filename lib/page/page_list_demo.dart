// Tab 页面
import 'package:first_flutter_demo/page/keep_alive_wrapper.dart';
import 'package:flutter/material.dart';

class Page extends StatefulWidget {
  const Page({super.key, required this.text});

  final String text;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    print("build ${widget.text}");
    return Center(
      child: Text("${widget.text}", textScaler: TextScaler.linear(5.0)),
    );
  }
}

class PageViewDemo extends StatelessWidget {
  const PageViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (int i = 0; i < 6; ++i) {
      children.add(KeepAliveWrapper(keepAlive: true, child: Page(text: '$i')));
    }
    return Scaffold(
      appBar: AppBar(title: Text('PageView Demo')),
      body: PageView(children: children),
    );
  }
}
