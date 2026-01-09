import 'package:flutter/material.dart';

/// Demo项模型类
/// 用于存储每个demo的基本信息
class DemoItem {
  /// Demo标题
  final String title;
  
  /// Demo描述
  final String description;
  
  /// Demo图标
  final IconData icon;
  
  /// Demo页面构建器
  final Widget Function() builder;
  
  /// Demo路由名称（可选）
  final String? routeName;

  const DemoItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
    this.routeName,
  });
}
