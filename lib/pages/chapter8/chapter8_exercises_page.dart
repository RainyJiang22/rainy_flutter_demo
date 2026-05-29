import 'package:first_flutter_demo/pages/chapter7/cart_exercise_page.dart';
import 'package:first_flutter_demo/pages/chapter7/login_exercise_page.dart';
import 'package:first_flutter_demo/pages/chapter7/settings_exercise_page.dart';
import 'package:first_flutter_demo/pages/chapter7/todo_exercise_page.dart';
import 'package:first_flutter_demo/pages/chapter8/event_bus_demo_app.dart';
import 'package:first_flutter_demo/pages/chapter8/gesture_demo_app.dart';
import 'package:first_flutter_demo/pages/chapter8/notification_demo_app.dart';
import 'package:first_flutter_demo/pages/chapter8/pointer_demo_app.dart';
import 'package:flutter/material.dart';

import 'gesture_lab_app.dart';

class Chapter8ExercisesPage extends StatelessWidget {
  const Chapter8ExercisesPage({super.key});

  static final List<_ExerciseEntry> _entries = [
    _ExerciseEntry(
      title: '`Listener`监听',
      description: 'Listener 监听原始指针事件',
      icon: Icons.shopping_cart_checkout,
      highlights: 'Provider / Dialog / Consumer',
      builder: () => const PointerDemoApp(),
    ),
    _ExerciseEntry(
      title: '拖拽',
      description: '处理点击、拖拽、缩放',
      icon: Icons.tune,
      highlights: 'Theme / ThemeMode / Switch',
      builder: () => const GestureDemoApp(),
    ),
    _ExerciseEntry(
      title: '监听滚动和自定义通知',
      description: '`NotificationListener` 监听滚动和自定义通知',
      icon: Icons.checklist,
      highlights: 'Provider / CRUD / Dialog',
      builder: () => const NotificationDemoApp(),
    ),
    _ExerciseEntry(
      title: '事件总线',
      description: '用单例 + 回调列表实现事件总线，思路没问题，但现代 Flutter 项目里更建议至少基于 StreamController.broadcast() 封装，生命周期更清楚',
      icon: Icons.lock_person,
      highlights: 'Form / Future / Dialog',
      builder: () => const EventBusDemoApp(),
    ),
    _ExerciseEntry(
      title: 'Gesture Lab',
      description: '事件实验室',
      icon: Icons.eighteen_mp,
      highlights: 'Form / Future / Dialog',
      builder: () => const GestureLabApp(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('第8章实战练习')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '根据 flutter-book-chapter8-summary 补齐的练习入口',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '覆盖 Flutter 如何接收、识别、分发和上传事件',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._entries.map((entry) => _ExerciseCard(entry: entry)),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.entry});

  final _ExerciseEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => entry.builder()));
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(entry.icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(entry.description),
                    const SizedBox(height: 10),
                    Text(
                      entry.highlights,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseEntry {
  const _ExerciseEntry({
    required this.title,
    required this.description,
    required this.icon,
    required this.highlights,
    required this.builder,
  });

  final String title;
  final String description;
  final IconData icon;
  final String highlights;
  final Widget Function() builder;
}
