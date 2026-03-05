

import 'package:flutter/material.dart';

import 'arc_progress_painter.dart';

class ArcProgressDemo extends StatefulWidget {
  const ArcProgressDemo({super.key});

  @override
  State<ArcProgressDemo> createState() => _ArcProgressDemoState();
}

class _ArcProgressDemoState extends State<ArcProgressDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.addListener(() {
      setState(() {});
    });

    // 自动播放
    Future.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('圆弧进度条')),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: ArcProgressPainter(progress: _animation.value),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}