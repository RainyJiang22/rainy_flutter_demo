import 'package:first_flutter_demo/pages/stopwatch/stop_watch_page.dart';
import 'package:flutter/material.dart';

class StopWatchApp extends StatelessWidget {
  const StopWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StopWatchPage(),
    );
  }
}
