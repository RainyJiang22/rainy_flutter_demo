

import 'package:flutter/material.dart';

class GestureDemoApp extends StatelessWidget {
  const GestureDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gesture Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: const GestureDemoPage(),
    );
  }
}

class GestureDemoPage extends StatefulWidget {
  const GestureDemoPage({super.key});

  @override
  State<GestureDemoPage> createState() => _GestureDemoPageState();
}

class _GestureDemoPageState extends State<GestureDemoPage> {
  String _message = '尝试点击、双击、长按卡片';
  Offset _offset = const Offset(40, 40);
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('手势识别')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('当前事件'),
                subtitle: Text(_message),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _updateMessage('Tap'),
              onDoubleTap: () => _updateMessage('DoubleTap'),
              onLongPress: () => _updateMessage('LongPress'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '点击 / 双击 / 长按这里',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: _offset.dx,
                      top: _offset.dy,
                      child: GestureDetector(
                        onScaleStart: (details) {
                          _baseScale = _scale;
                        },
                        onScaleUpdate: (details) {
                          setState(() {
                            _offset += details.focalPointDelta;
                            _scale =
                                (_baseScale * details.scale).clamp(0.8, 2.5);
                            _message = details.scale == 1.0
                                ? '拖拽中: $_offset'
                                : '缩放中: ${_scale.toStringAsFixed(2)}x';
                          });
                        },
                        child: Transform.scale(
                          scale: _scale,
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.deepOrange,
                            child: Text(
                              'A',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMessage(String value) {
    setState(() {
      _message = value;
    });
  }
}

