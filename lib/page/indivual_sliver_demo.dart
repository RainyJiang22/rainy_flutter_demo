import 'dart:math';

import 'package:first_flutter_demo/page/sliver_flexible_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IndivualSliverDemo extends StatelessWidget {
  const IndivualSliverDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      //为了能使CustomScrollView拉到顶部时还能继续往下拉，必须让 physics 支持弹性效果
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        //我们需要实现的 SliverFlexibleHeader 组件
        SliverFlexibleHeader(
          visibleExtent: 200, // 初始状态在列表中占用的布局高度
          // 为了能根据下拉状态变化来定制显示的布局，我们通过一个 builder 来动态构建布局。
          builder: (context, availableHeight,visibleExtent) {
            return GestureDetector(
              onTap: () => print('tap'), //测试是否可以响应事件
              child: Image(
                image: AssetImage("imgs/avatar.png"),
                width: 50.0,
                height: availableHeight,
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        // 构建一个list
       // buildSliverList(30),
      ],
    );
  }
}