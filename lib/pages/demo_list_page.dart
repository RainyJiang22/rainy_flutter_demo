import 'package:first_flutter_demo/widget/container/CustomContainer.dart';
import 'package:first_flutter_demo/widget/image/AlignmentImage.dart';
import 'package:first_flutter_demo/widget/image/BlendModeImage.dart';
import 'package:first_flutter_demo/widget/image/LoadImageDemo.dart';
import 'package:first_flutter_demo/widget/text/TextDemo.dart';
import 'package:first_flutter_demo/widget/text/TextDemo1.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_demo/model/demo_item.dart';
import 'package:first_flutter_demo/widget/animation/FadeAnimation.dart';

class DemoListPage extends StatelessWidget {
  const DemoListPage({super.key});

  static final List<DemoItem> demos = [
    DemoItem(
      title: '淡入淡出动画',
      description: '演示Flutter的FadeTransition动画效果',
      icon: Icons.animation,
      builder: () => const FadeAnimation(),
      routeName: '/fade-animation',
    ),
    DemoItem(
      title: '文字',
      description: 'Flutter绘制text',
      icon: Icons.text_decrease,
      builder: () => const Textdemo1(),
    ),
    DemoItem(
      title: '图片加载',
      description: 'Flutter加载图片相关',
      icon: Icons.image,
      builder: () => const LoadImageDemo(),
    ),
    DemoItem(
      title: '图片混合模式',
      description: 'Flutter混合模式相关',
      icon: Icons.image,
      builder: () => const BlendModeImage(),
    ),
    DemoItem(
      title: '图片位置',
      description: 'Flutter aligment相关',
      icon: Icons.image,
      builder: () => const Alignmentimage(),
    ),
    DemoItem(
      title: 'Container模块',
      description: 'Flutter container相关',
      icon: Icons.layers_outlined,
      builder: () => const Customcontainer(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo 列表'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: demos.isEmpty
          ? const Center(
              child: Text(
                '暂无Demo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: demos.length,
              itemBuilder: (context, index) {
                final demo = demos[index];
                return _DemoListItem(
                  demo: demo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => demo.builder()),
                    );
                  },
                );
              },
            ),
    );
  }
}

/// Demo列表项组件
class _DemoListItem extends StatelessWidget {
  final DemoItem demo;
  final VoidCallback onTap;

  const _DemoListItem({required this.demo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  demo.icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      demo.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
