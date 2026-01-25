import 'package:flutter/material.dart';

class AppWidgetLifecycle extends StatefulWidget {
  const AppWidgetLifecycle({super.key});

  @override
  State<AppWidgetLifecycle> createState() => _AppWidgetLifecycleState();
}

class _AppWidgetLifecycleState extends State<AppWidgetLifecycle>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        print('应用处于后台');
      case AppLifecycleState.resumed:
        print('应用处于前台');
      case AppLifecycleState.inactive:
        print('应用不在活跃状态');
      default:
        print('');
    };
  }
}
