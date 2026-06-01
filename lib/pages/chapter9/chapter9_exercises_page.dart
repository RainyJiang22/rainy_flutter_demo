
import 'package:first_flutter_demo/pages/chapter9/animation_showcase_app.dart';
import 'package:first_flutter_demo/pages/chapter9/basic_animation_app.dart';
import 'package:first_flutter_demo/pages/chapter9/implicit_animation_app.dart';
import 'package:first_flutter_demo/pages/chapter9/route_hero_app.dart';
import 'package:flutter/material.dart';

class Chapter9ExercisesPage extends StatelessWidget {
  const Chapter9ExercisesPage({super.key});

  static final List<_ExerciseEntry> _entries = [
    _ExerciseEntry(
      title: '显式动画基础',
      description: '理解 controller、curve、tween、AnimatedBuilder 的配合方式。',
      icon: Icons.shopping_cart_checkout,
      highlights: 'Provider / Dialog / Consumer',
      builder: () => const BasicAnimationApp(),
    ),
    _ExerciseEntry(
      title: '自定义路由过渡 + Hero',
      description: '把页面切换动画和共享元素动画组合起来',
      icon: Icons.animation_rounded,
      highlights: 'Provider / Dialog / Consumer',
      builder: () => const RouteHeroApp(),
    ),
    _ExerciseEntry(
      title: '隐式动画',
      description: '简单属性变化优先用隐式动画',
      icon: Icons.animation_rounded,
      highlights: 'Provider / Dialog / Consumer',
      builder: () => const ImplicitAnimationApp(),
    ),
    _ExerciseEntry(
      title: '综合练习',
      description: '综合练习动画',
      icon: Icons.animation_rounded,
      highlights: 'Provider / Dialog / Consumer',
      builder: () => const AnimationShowcaseApp(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('第9章实战练习')),
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
                  '根据 flutter-book-chapter9-summary 补齐的练习入口',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '覆盖Flutter拆成可理解、可组合、可维护的几类能力：显式动画、路由过渡、共享元素动画、交织动画、切换动画和隐式动画',
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
