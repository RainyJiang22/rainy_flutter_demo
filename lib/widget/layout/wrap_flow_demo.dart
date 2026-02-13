import 'package:flutter/material.dart';

class WrapFlowDemo extends StatefulWidget {
  const WrapFlowDemo({super.key});

  @override
  State<WrapFlowDemo> createState() => _WrapFlowDemoState();
}

class _WrapFlowDemoState extends State<WrapFlowDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wrap Flow Demo")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("wrap用法"),
          SizedBox(height: 10.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            children: [
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('A'),
                ),
                label: Text('Hamilton'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('M'),
                ),
                label: Text('Lafayette'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('H'),
                ),
                label: Text('Mulligan'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('J'),
                ),
                label: Text('Laurens'),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text("Flow的用法"),
          Flow(
            delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
            children: <Widget>[
              Container(width: 80.0, height:80.0, color: Colors.red,),
              Container(width: 80.0, height:80.0, color: Colors.green,),
              Container(width: 80.0, height:80.0, color: Colors.blue,),
              Container(width: 80.0, height:80.0,  color: Colors.yellow,),
              Container(width: 80.0, height:80.0, color: Colors.brown,),
              Container(width: 80.0, height:80.0,  color: Colors.purple,),
            ],
          )
        ],
      ),
    );
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin;

  TestFlowDelegate({this.margin = EdgeInsets.zero});

  double width = 0;
  double height = 0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;

    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i)!.width + x + margin.right;
      if(w < context.size.width) {
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i)!.height + margin.top + margin.bottom;
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + margin.left + margin.right;
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(double.infinity,200.0);
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
