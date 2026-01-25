import 'package:flutter/material.dart';

class FlutterWidgetLifecycle extends StatefulWidget {
  const FlutterWidgetLifecycle({super.key});

  @override
  State<FlutterWidgetLifecycle> createState() => _FlutterWidgetLifecycleState();
}

class _FlutterWidgetLifecycleState extends State<FlutterWidgetLifecycle> {
  int _count = 0;

  @override
  void initState() {
    print('------initState------');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('------didChangeDependencies---------');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant FlutterWidgetLifecycle oldWidget) {
    print('------didUpdateWidget-------');
    super.didUpdateWidget(oldWidget);
  }

  //设置setstate之后也会调用
  @override
  Widget build(BuildContext context) {
    print('------build---------');
    return Scaffold(
      appBar: AppBar(title: Text('Flutter生命周期')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              child: Text('点我', style: TextStyle(fontSize: 26)),
            ),
            Text(_count.toString())
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('-------deactivate-------');
    super.deactivate();
  }

  @override
  void dispose() {
    print('-------dispose-------');
    super.dispose();
  }

}
