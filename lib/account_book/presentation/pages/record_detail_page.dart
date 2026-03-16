import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/record.dart';
import '../providers/records_provider.dart';
import '../providers/current_book_provider.dart';
import '../widgets/common/app_card.dart';
import '../widgets/amount_input.dart';

/// 记录详情页面
class RecordDetailPage extends ConsumerWidget {
  final String recordId;

  const RecordDetailPage({
    super.key,
    required this.recordId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordDetail = ref.watch(recordDetailProvider(recordId));
    final currentBook = ref.watch(currentBookProvider);

    return recordDetail.when(
      data: (detail) {
        if (detail == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('记录不存在')),
          );
        }

        final record = detail.record;
        final category = detail.category;
        final isExpense = record.type == RecordType.expense;

        return Scaffold(
          appBar: AppBar(
            title: const Text('记录详情'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'delete') {
                    final confirmed = await _showDeleteConfirm(context);
                    if (confirmed == true && currentBook != null) {
                      await ref
                          .read(recordsProvider.notifier)
                          .delete(recordId, currentBook.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已删除')),
                        );
                      }
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('删除'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 金额卡片
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Color(category.color).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getIconData(category.icon),
                          color: Color(category.color),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${isExpense ? "-" : "+"}¥${record.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isExpense
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 详情信息
                AppCard(
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context,
                        Icons.calendar_today,
                        '日期',
                        DateFormat('yyyy年MM月dd日').format(record.date),
                      ),
                      const Divider(),
                      _buildDetailRow(
                        context,
                        Icons.access_time,
                        '时间',
                        DateFormat('HH:mm').format(record.date),
                      ),
                      if (record.note != null && record.note!.isNotEmpty) ...[
                        const Divider(),
                        _buildDetailRow(
                          context,
                          Icons.note,
                          '备注',
                          record.note!,
                        ),
                      ],
                      const Divider(),
                      _buildDetailRow(
                        context,
                        Icons.book,
                        '账本',
                        currentBook?.name ?? '默认账本',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 分摊信息
                if (detail.hasSplit) ...[
                  Text('分摊详情', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  AppCard(
                    child: Column(
                      children: [
                        if (detail.payer != null)
                          _buildDetailRow(
                            context,
                            Icons.person,
                            '垫付人',
                            detail.payer!.name,
                          ),
                        const Divider(),
                        ...detail.splitDetails.map((splitDetail) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    child: Text(
                                      splitDetail.member.name[0],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(splitDetail.member.name)),
                                  Text(
                                    '¥${splitDetail.split.amount.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],

                // 创建时间
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    '创建于 ${DateFormat('yyyy-MM-dd HH:mm').format(record.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('加载失败: $error')),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'shopping_cart': Icons.shopping_cart,
      'sports_esports': Icons.sports_esports,
      'home': Icons.home,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'more_horiz': Icons.more_horiz,
      'account_balance_wallet': Icons.account_balance_wallet,
      'card_giftcard': Icons.card_giftcard,
      'trending_up': Icons.trending_up,
    };
    return iconMap[iconName] ?? Icons.category;
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条记录吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
