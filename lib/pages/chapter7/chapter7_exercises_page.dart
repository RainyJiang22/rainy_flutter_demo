import 'package:first_flutter_demo/pages/chapter7/cart_exercise_page.dart';
import 'package:first_flutter_demo/pages/chapter7/login_exercise_page.dart';
import 'package:first_flutter_demo/pages/chapter7/settings_exercise_page.dart';
import 'package:first_flutter_demo/pages/chapter7/todo_exercise_page.dart';
import 'package:flutter/material.dart';

class Chapter7ExercisesPage extends StatelessWidget {
  const Chapter7ExercisesPage({super.key});

  static final List<_ExerciseEntry> _entries = [
    _ExerciseEntry(
      title: '购物车练习',
      description: 'Provider 状态共享、数量管理、结算对话框',
      icon: Icons.shopping_cart_checkout,
      highlights: 'Provider / Dialog / Consumer',
      builder: () => const CartExercisePage(),
    ),
    _ExerciseEntry(
      title: '设置页面练习',
      description: '主题模式、字体缩放、设置项联动预览',
      icon: Icons.tune,
      highlights: 'Theme / ThemeMode / Switch',
      builder: () => const SettingsExercisePage(),
    ),
    _ExerciseEntry(
      title: '待办事项练习',
      description: '增删改查、筛选、滑动删除、弹窗编辑',
      icon: Icons.checklist,
      highlights: 'Provider / CRUD / Dialog',
      builder: () => const TodoExercisePage(),
    ),
    _ExerciseEntry(
      title: '登录系统练习',
      description: '表单校验、异步登录、会话展示、退出确认',
      icon: Icons.lock_person,
      highlights: 'Form / Future / Dialog',
      builder: () => const LoginExercisePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('第7章实战练习')),
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
                  '根据 flutter-book-chapter7-summary 补齐的练习入口',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '覆盖 Provider、Theme、异步 UI、对话框与表单等第 7 章核心能力。',
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
