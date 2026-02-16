

import 'package:flutter/material.dart';

class ResponsiveColumnDemo extends StatelessWidget {
  const ResponsiveColumnDemo({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //最大宽度小于200，显示单列
        if(constraints.maxWidth < 200) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: children
          );
        } else {
          // 大于200，显示双列
          var children = <Widget>[];
          for (var i = 0; i < children.length; i += 2) {
            if (i + 1 < children.length) {
              children.add(Row(
                mainAxisSize: MainAxisSize.min,
                children: [children[i], children[i + 1]],
              ));
            } else {
              children.add(children[i]);
            }
          }
          return Column(mainAxisSize: MainAxisSize.min, children: children);
        }
      },
    );
  }
}

class LayoutBuilderRoute extends StatelessWidget {
  const LayoutBuilderRoute({super.key});


  @override
  Widget build(BuildContext context) {
    var _children = List.filled(6, Text("A"));
    return Scaffold(
      appBar: AppBar(title: Text("Responsive Demo")),
      body: Column(
        children: [
          SizedBox(width: 190,child: ResponsiveColumnDemo(children: _children)),
          ResponsiveColumnDemo(children: _children),
          LayoutLogPrint(child:Text("xx")) // 下面介绍
        ],
      ),
    );
  }
}

class LayoutLogPrint<T> extends StatelessWidget {
  const LayoutLogPrint({
    super.key,
    this.tag,
    required this.child,
  });

  final Widget child;
  final T? tag; //指定日志tag

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      // assert在编译release版本时会被去除
      assert(() {
        print('${tag ?? key ?? child}: $constraints');
        return true;
      }());
      return child;
    });
  }
}

