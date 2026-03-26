import 'package:flutter/material.dart';

class WillPopScopeTest extends StatefulWidget {
  const WillPopScopeTest({super.key});

  @override
  State<WillPopScopeTest> createState() => _WillPopScopeTestState();
}

class _WillPopScopeTestState extends State<WillPopScopeTest> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    // Flutter 3.24+已经被废弃了
    // return WillPopScope(
    //   onWillPop: () async {
    //     if(_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > Duration(milliseconds: 1)) {
    //        _lastPressedAt = DateTime.now();
    //        return false;
    //     }
    //     return true;
    //   },
    //   child: Container(
    //     alignment: Alignment.center,
    //     child: Text("1秒内连续按2次返回键退出"),
    //   ),
    // );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt!) >
                  Duration(milliseconds: 1)) {
            _lastPressedAt = DateTime.now();
            Navigator.of(context).pop();
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Text("1秒内连续2次返回键退出"),
      ),
    );
  }
}

class PopScopeApp extends StatelessWidget {
  const PopScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PopScopeTestRoute extends StatefulWidget {
  const PopScopeTestRoute({super.key});

  @override
  State<PopScopeTestRoute> createState() => _PopScopeTestRouteState();
}

class _PopScopeTestRouteState extends State<PopScopeTestRoute>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  DateTime? _lastPressedAt;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, redult) {
        if (didPop) {
          return;
        }
        if(_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 1)) {
          _lastPressedAt = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('再按一次退出应用'),
              duration: Duration(seconds: 1),
            )
          );
        } else {
          setState(() {
            //允许退出
            _canPop = true;
          });
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(appBar: AppBar(title: const Text('PopScope示例')),
       body: const Center(
         child: Text('请在1秒内连续按两次返回键退出'),
       ),),
    );
  }
}
