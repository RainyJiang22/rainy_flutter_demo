import 'package:flutter/material.dart';

class ProgressRouteDemo extends StatefulWidget {
  const ProgressRouteDemo({super.key});

  @override
  State<ProgressRouteDemo> createState() => _ProgressRouteDemoState();
}

class _ProgressRouteDemoState extends State<ProgressRouteDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    //执行3秒
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animationController.forward();
    _animationController.addListener(() => setState(() => {}));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Progress Route Demo")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: ColorTween(
                  begin: Colors.grey,
                  end: Colors.blue,
                ).animate(_animationController),
                value: _animationController.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
