//通过RenderObject生成自定义组件widget

import 'package:flutter/material.dart';

class CustomWidget extends LeafRenderObjectWidget {
  const CustomWidget({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomObject();
  }
}

class RenderCustomObject extends RenderBox {
  @override
  void performLayout() {
    //布局逻辑
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    //实现绘制
  }
}
