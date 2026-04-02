import 'package:flutter/material.dart';

class ThemeAppDemo extends StatelessWidget {
  const ThemeAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ThemeTestRoute(),
    );
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
            NavBar(
              color: _themeColor,
              title: '自定义导航栏',
            ),
            const SizedBox(height: 20),
            NavBar(
               color: Colors.white,
               title: '浅色导航栏',
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _themeColor,
          onPressed: () {
            setState(() {
              _themeColor = _themeColor == Colors.teal
                  ? Colors.blue
                  : Colors.teal;
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
    return Container(
      constraints: const BoxConstraints(
        minHeight: 52,
        minWidth: double.infinity
      ),
      decoration:BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0,3),
            blurRadius: 3
          ),
        ]
      ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // 根据背景色亮度确定文字颜色
            // computeLuminance返回0-1的值，越大颜色越浅
            color: color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        )
    );
  }
}
