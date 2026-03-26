import 'package:flutter/material.dart';

///计数器共享
class InheritedWidgetApp extends StatelessWidget {
  const InheritedWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IneritedWidgetTestRoute(),
    );
  }
}

class ShareDataWidget extends InheritedWidget {
  const ShareDataWidget({super.key, required Widget child, required this.data})
    : super(child: child);

  final int data;

  /// 定义一个便捷方法，方便子树中的Widget获取共享数据
  /// [listen] 参数控制是否建立依赖关系
  static ShareDataWidget? of(BuildContext context, {bool listen = true}) {
    if (listen) {
      // 建立依赖关系，数据变化时会触发子Widget的didChangeDependencies和build
      return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
    } else {
      // 不建立依赖关系，只获取数据，不会触发重建
      return context
              .getElementForInheritedWidgetOfExactType<ShareDataWidget>()
              ?.widget
          as ShareDataWidget?;
    }
  }

  @override
  bool updateShouldNotify(ShareDataWidget old) {
    return old.data != data;
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    final data = ShareDataWidget.of(context)!.data;
    return Text('共享数据:$data', style: const TextStyle(fontSize: 24));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('数据已更新');
  }
}


class IneritedWidgetTestRoute extends StatefulWidget {
  const IneritedWidgetTestRoute({super.key});

  @override
  State<IneritedWidgetTestRoute> createState() => _IneritedWidgetTestRouteState();
}

class _IneritedWidgetTestRouteState extends State<IneritedWidgetTestRoute> {
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InheritedWidget数据共享'),
      ),
      body: Center(
        child: ShareDataWidget(
          data: count,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: TestWidget(),
              ),
              ElevatedButton(
                child: const Text('增加计数'),
                onPressed: () {
                  setState(() {
                    ++count;
                  });
                },
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (context) {
                  final data = ShareDataWidget.of(context,listen: false)?.data ?? 0;
                  return Text(
                    '不响应变化的数据:$data',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
