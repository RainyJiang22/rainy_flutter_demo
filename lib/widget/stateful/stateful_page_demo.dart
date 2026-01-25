import 'package:flutter/material.dart';

class StatefulPageDemo extends StatefulWidget {
  const StatefulPageDemo({super.key});

  @override
  State<StatefulPageDemo> createState() => _StatefulPageDemoState();
}

class _StatefulPageDemoState extends State<StatefulPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("如何使用Flutter进行布局")),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              height: 100,
              child: PhysicalModel(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                clipBehavior: Clip.antiAlias, //抗锯齿
                child: PageView(
                  children: [
                    _item('Page1', Colors.deepPurple),
                    _item('Page2', Colors.red),
                    _item('Page3', Colors.green),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.lightGreenAccent),
                    child: Text('宽度撑满'),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Image.network(
                  'https://picsum.photos/200/300',
                  width: 160,
                  height: 220,
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Image.network(
                      'https://picsum.photos/200/300',
                      width: 42,
                      height: 53
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _chip('Flutter'),
                _chip('进阶'),
                _chip('实战'),
                _chip('携程'),
                _chip('App')
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _item(String s, MaterialColor deepPurple) {
    return Container(
      color: deepPurple,
      child: Center(child: Text(s)),
    );
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label),
      avatar: CircleAvatar(
        backgroundColor: Colors.blue.shade900,
        child: Text(
          label.substring(0, 1), style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
