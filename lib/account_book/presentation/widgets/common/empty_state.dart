import 'package:flutter/material.dart';

/// 空状态组件
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// 记录空状态
class EmptyRecords extends StatelessWidget {
  final VoidCallback? onAdd;

  const EmptyRecords({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: '暂无记录',
      subtitle: '点击下方按钮开始记账',
      action: onAdd != null
          ? FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('记一笔'),
            )
          : null,
    );
  }
}

/// 分类空状态
class EmptyCategories extends StatelessWidget {
  final VoidCallback? onAdd;

  const EmptyCategories({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.category_outlined,
      title: '暂无分类',
      subtitle: '点击下方按钮添加分类',
      action: onAdd != null
          ? FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('添加分类'),
            )
          : null,
    );
  }
}

/// 成员空状态
class EmptyMembers extends StatelessWidget {
  final VoidCallback? onAdd;

  const EmptyMembers({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.people_outline,
      title: '暂无成员',
      subtitle: '点击下方按钮添加成员',
      action: onAdd != null
          ? FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('添加成员'),
            )
          : null,
    );
  }
}
