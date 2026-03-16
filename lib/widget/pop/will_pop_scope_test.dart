

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
    return WillPopScope(
      onWillPop: () async {
        if(_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > Duration(milliseconds: 1)) {
           _lastPressedAt = DateTime.now();
           return false;
        }
        return true;
      },
      child: Container(
        alignment: Alignment.center,
        child: Text("1秒内连续按2次返回键退出"),
      ),
    );
  }
}
