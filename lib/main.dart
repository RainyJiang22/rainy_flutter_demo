import 'package:dio/dio.dart';
import 'package:first_flutter_demo/navigation/bottom_navigation_widget.dart';
import 'package:first_flutter_demo/network/DioHttp.dart';
import 'package:first_flutter_demo/paint/Paper.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_demo/pages/demo_list_page.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight
  // ]); //使设备横屏
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);//全屏
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
