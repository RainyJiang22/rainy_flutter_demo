import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/current_book_provider.dart';
import 'book_manage_page.dart';
import 'category_manage_page.dart';
import 'member_manage_page.dart';

/// 我的页面
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBook = ref.watch(currentBookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: ListView(
        children: [
          // 当前账本信息
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: currentBook != null
                          ? Color(currentBook.color).withValues(alpha: 0.15)
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.book,
                      color: currentBook != null
                          ? Color(currentBook.color)
                          : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentBook?.name ?? '未选择账本',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentBook?.type.label ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 管理菜单
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '管理',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuTile(
            context,
            icon: Icons.book_outlined,
            title: '账本管理',
            subtitle: '创建、切换、归档账本',
            onTap: () => _navigateTo(context, const BookManagePage()),
          ),
          _buildMenuTile(
            context,
            icon: Icons.category_outlined,
            title: '分类管理',
            subtitle: '自定义收支分类',
            onTap: () => _navigateTo(context, const CategoryManagePage()),
          ),
          _buildMenuTile(
            context,
            icon: Icons.people_outline,
            title: '成员管理',
            subtitle: '管理账本成员',
            onTap: () => _navigateTo(context, const MemberManagePage()),
          ),

          const Divider(height: 32),

          // 数据菜单
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '数据',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuTile(
            context,
            icon: Icons.backup_outlined,
            title: '数据备份',
            subtitle: '备份到本地',
            onTap: () => _showComingSoon(context),
          ),
          _buildMenuTile(
            context,
            icon: Icons.cloud_upload_outlined,
            title: '数据导出',
            subtitle: '导出为 CSV 文件',
            onTap: () => _showComingSoon(context),
          ),
          _buildMenuTile(
            context,
            icon: Icons.cloud_sync_outlined,
            title: '云端同步',
            subtitle: '多设备数据同步',
            onTap: () => _showComingSoon(context),
          ),

          const Divider(height: 32),

          // 关于菜单
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '关于',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuTile(
            context,
            icon: Icons.info_outline,
            title: '关于记账本',
            subtitle: '版本 1.0.0',
            onTap: () => _showAbout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.outline,
      ),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('功能开发中，敬请期待')),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: '记账本',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 RainyJiang',
      children: [
        const SizedBox(height: 16),
        const Text('一个简单实用的个人记账应用，支持日常记账和分摊功能。'),
      ],
    );
  }
}
