import 'package:flutter/material.dart';

class ImplicitAnimationApp extends StatelessWidget {
  const ImplicitAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: '隐式动画示例',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      home: ImplicitAnimationPage(),
    );
  }
}

class ImplicitAnimationPage extends StatefulWidget {
  const ImplicitAnimationPage({super.key});

  @override
  State<ImplicitAnimationPage> createState() => _ImplicitAnimationPageState();
}

class _ImplicitAnimationPageState extends State<ImplicitAnimationPage> {
  int _count = 0;
  bool _selected = false;

  void _increment() {
    setState(() {
      _count++;
      _selected = !_selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _selected ? Colors.deepOrange : Colors.blue;
    final radius = _selected ? 36.0 : 12.0;

    return Scaffold(
      appBar: AppBar(title: const Text("隐式动画")),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: _selected ? 260 : 200,
          height: _selected ? 260 : 200,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              '$_count',
               key: ValueKey(_count), //没有key切换可能不明显
                style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _increment,
        icon: const Icon(Icons.add),
        label: const Text('增加'),
      ),
    );
  }
}
