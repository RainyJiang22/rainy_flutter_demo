import 'package:first_flutter_demo/lifecycle/LifecycleWatcher.dart';
import 'package:first_flutter_demo/network/SampleNetwork.dart';
import 'package:first_flutter_demo/pages/juejin/juejin_page_demo.dart';
import 'package:first_flutter_demo/pages/launch_page.dart';
import 'package:first_flutter_demo/pages/stopwatch/stop_watch_app.dart';
import 'package:first_flutter_demo/pages/stopwatch/stop_watch_page.dart';
import 'package:first_flutter_demo/paint/Paper.dart';
import 'package:first_flutter_demo/paint/SignDemo.dart';
import 'package:first_flutter_demo/state/box_state_demo.dart';
import 'package:first_flutter_demo/state/state_test_demo.dart';
import 'package:first_flutter_demo/widget/align/AlignDemo.dart';
import 'package:first_flutter_demo/widget/animation/GestureDemo.dart';
import 'package:first_flutter_demo/widget/container/CustomContainer.dart';
import 'package:first_flutter_demo/widget/flex/FlexDemo.dart';
import 'package:first_flutter_demo/widget/flow/flow_demo.dart';
import 'package:first_flutter_demo/widget/image/AlignmentImage.dart';
import 'package:first_flutter_demo/widget/image/BlendModeImage.dart';
import 'package:first_flutter_demo/widget/image/LoadImageDemo.dart';
import 'package:first_flutter_demo/widget/list/ListDemo.dart';
import 'package:first_flutter_demo/widget/stack/StackDemo.dart';
import 'package:first_flutter_demo/widget/stateful/stateful_page_demo.dart';
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
      title: '双击旋转动画',
      description: '演示Flutter的TransTransition动画效果',
      icon: Icons.animation,
      builder: () => const GestureDemo(),
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
      title: '画笔属性',
      description: 'Flutter认识画笔的属性',
      icon: Icons.layers_outlined,
      builder: () => const Paper(),
    ),
    DemoItem(
      title: '签名demo',
      description: 'Flutter 绘制painter相关',
      icon: Icons.signal_cellular_0_bar,
      builder: () => const SignatureDemo(),
    ),
    DemoItem(
      title: '异步Ui demo',
      description: 'Flutter 异步ui相关',
      icon: Icons.network_cell,
      builder: () => const SampleNetwork(),
    ),
    DemoItem(
      title: 'Lifecycle demo',
      description: 'Flutter Lifecycle相关',
      icon: Icons.motorcycle,
      builder: () => const LifecycleWatcher(),
    ),

    DemoItem(
      title: 'ListView demo',
      description: 'Flutter ListView列表相关',
      icon: Icons.list,
      builder: () => const ListDemo(),
    ),
    DemoItem(
      title: 'Container模块',
      description: 'Flutter container相关',
      icon: Icons.layers_outlined,
      builder: () => const CustomContainer(),
    ),

    DemoItem(
      title: 'Align布局',
      description: 'Flutter align相关',
      icon: Icons.layers_outlined,
      builder: () => const AlignDemo(),
    ),
    DemoItem(
      title: 'Flex弹性布局',
      description: 'Flutter flex相关',
      icon: Icons.layers_outlined,
      builder: () => const FlexDemo(),
    ),
    DemoItem(
      title: '堆叠布局',
      description: 'Flutter stack相关',
      icon: Icons.layers_outlined,
      builder: () => const StackDemo(),
    ),
    DemoItem(
      title: '流式布局',
      description: 'Flutter flow相关',
      icon: Icons.layers_outlined,
      builder: () => const FlowDemo(),
    ),
    DemoItem(
      title: '掘金首页练习',
      description: 'Flutter布局练习实战',
      icon: Icons.layers_outlined,
      builder: () => const JuejinPageDemo(),
    ),
    DemoItem(
      title: 'State',
      description: 'State状态练习相关',
      icon: Icons.layers_sharp,
      builder: () => const CounterWidget(),
    ),
    DemoItem(
      title: '状态管理',
      description: '学习flutter状态管理',
      icon: Icons.layers_sharp,
      builder: () => const BoxStateDemo(),
    ),
    DemoItem(
      title: '秒表应用',
      description: 'flutter简单秒表功能',
      icon: Icons.layers_sharp,
      builder: () => const StopWatchApp(),
    ),
    DemoItem(
      title: 'Flutter基础布局',
      description: 'flutter StatefulWidget及其简单widget',
      icon: Icons.layers_sharp,
      builder: () => const StatefulPageDemo(),
    ),
    DemoItem(
      title: 'Flutter打开第三方应用',
      description: 'flutter使用url_launch打开第三方应用',
      icon: Icons.start,
      builder: () => const LaunchPageDemo(title: 'hello'),
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
