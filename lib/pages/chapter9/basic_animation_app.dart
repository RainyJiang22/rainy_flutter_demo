import 'package:flutter/material.dart';

class BasicAnimationApp extends StatelessWidget {
  const BasicAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '显示动画基础',
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal
      ),
      home: const ScaleDemoPage(),
    );
  }
}


class ScaleDemoPage extends StatefulWidget {
  const ScaleDemoPage({super.key});


  @override
  State<ScaleDemoPage> createState() => _ScaleDemoPageState();
}

class _ScaleDemoPageState extends State<ScaleDemoPage>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700)
    );

    _sizeAnimation = Tween<double>(begin: 88, end: 180).chain(
        CurveTween(curve: Curves.easeInOut)
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if(_expanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('显示动画基础')),
      body: Center(
        child: AnimatedBuilder(
          animation: _sizeAnimation,
          child: const FlutterLogo(),
          builder: (BuildContext context, Widget? child) {
            return Container(
              width: _sizeAnimation.value,
              height: _sizeAnimation.value,
              decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24)
              ),
              alignment: Alignment.center,
              child: child,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggle,
        icon: const Icon(Icons.animation),
        label: Text(_expanded ? '缩小' : '放大'),
      ),
    );
  }
}



