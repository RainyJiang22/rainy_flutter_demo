

import 'package:flutter/material.dart';

class ThemeAppDemo extends StatelessWidget {
  const ThemeAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ThemeTestRoute extends StatefulWidget {
  const ThemeTestRoute({super.key});

  @override
  State<ThemeTestRoute> createState() => _ThemeTestRouteState();
}

class _ThemeTestRouteState extends State<ThemeTestRoute> {

  //当前主题色
  MaterialColor _themeColor = Colors.teal;
  @override
  Widget build(BuildContext context) {

    final themeData = Theme.of(context);


    return Theme(
      data: ThemeData(
        primarySwatch: _themeColor,
        iconTheme: IconThemeData(color: _themeColor),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('主题切换试示例'),
          backgroundColor: _themeColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.favorite),
                Icon(Icons.airport_shuttle),
                Text('  颜色跟随主题'),
              ],
            ),
            const SizedBox(height: 20),
            // 第二行：颜色固定
            Theme(
              // 使用copyWith覆盖部分主题属性
              data: themeData.copyWith(
                iconTheme: themeData.iconTheme.copyWith(color: Colors.black),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.favorite),
                  Icon(Icons.airport_shuttle),
                  Text('  颜色固定黑色'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _themeColor,
          onPressed: () {
            setState(() {
              _themeColor = _themeColor == Colors.teal ? Colors.blue : Colors.teal;
            });
          },
          child: const Icon(Icons.palette),
        ),
      ),
    );

  }
}

///自定义导航栏的组件
class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.color, required this.title});

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


