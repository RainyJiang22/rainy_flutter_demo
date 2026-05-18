

import 'package:flutter/material.dart';

class PointerDemoApp extends StatelessWidget {
  const PointerDemoApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pointer Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal
      ),
      home: const PointerDemoPage(),
    );
  }
}


class PointerDemoPage extends StatefulWidget {
  const PointerDemoPage({super.key});

  @override
  State<PointerDemoPage> createState() => _PointerDemoPageState();
}

class _PointerDemoPageState extends State<PointerDemoPage> {
  String _eventText = '请在蓝色区域按下并移动手指';
  bool _useAbsorbPointer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原始指针事件')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _eventText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Listener(
              onPointerDown: (event) {
                setState(() {
                  _eventText = '按下:local=${event.localPosition}, global=${event.position}';
                });
              },
              onPointerMove: (event) {
                setState(() {
                  _eventText = '移动: local=${event.localPosition}';
                });
              },
              onPointerUp: (event) {
                setState(() {
                  _eventText = '抬起: local=${event.localPosition}';
                });
              },
              child: Container(
                height: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Text('监听区域'),
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: _useAbsorbPointer,
              title: Text(
                _useAbsorbPointer ? '父层还能收到事件，子层收不到' : '父层和子层都收不到',
              ), onChanged: (bool value) {
                setState(() {
                  _useAbsorbPointer = value;
                });
            },
            ),
            const SizedBox(height: 8),
            Listener(
              onPointerDown: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('父层Listener 收到点击')),
                );
              },
              child: Center(
                child: _useAbsorbPointer ? AbsorbPointer(
                  child: Listener(
                    onPointerDown: (_) {
                      debugPrint('子层收到点击');
                    },
                    child: _buildInnerBox(),
                  ),
                ) : IgnorePointer(
                  child: Listener(
                    onPointerDown: (_) {
                      debugPrint('子层收到点击');
                    },
                    child: _buildInnerBox(),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerBox() {
    return Container(
      width: 220,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        '点击这里测试指针拦截',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
