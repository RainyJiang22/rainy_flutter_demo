import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/record.dart';

/// 记录卡片
class RecordCard extends StatelessWidget {
  final RecordDetail recordDetail;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const RecordCard({
    super.key,
    required this.recordDetail,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final record = recordDetail.record;
    final category = recordDetail.category;
    final isExpense = record.type == RecordType.expense;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 分类图标
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(category.color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(category.icon),
                  color: Color(category.color),
                ),
              ),
              const SizedBox(width: 12),
              // 分类名称和备注
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (record.note != null && record.note!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        record.note!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // 金额
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isExpense ? "-" : "+"}¥${record.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isExpense
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  if (recordDetail.hasSplit) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '分摊',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
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
}

/// 记录列表项（带日期分组）
class RecordListGroup extends StatelessWidget {
  final DateTime date;
  final List<RecordDetail> records;
  final void Function(RecordDetail)? onTap;
  final void Function(RecordDetail)? onLongPress;

  const RecordListGroup({
    super.key,
    required this.date,
    required this.records,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM月dd日 EEEE', 'zh_CN');
    final expenseTotal = records
        .where((r) => r.record.type == RecordType.expense)
        .fold<double>(0, (sum, r) => sum + r.record.amount);
    final incomeTotal = records
        .where((r) => r.record.type == RecordType.income)
        .fold<double>(0, (sum, r) => sum + r.record.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日期标题
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text(
                dateFormat.format(date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const Spacer(),
              if (expenseTotal > 0)
                Text(
                  '支出 ¥${expenseTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              if (expenseTotal > 0 && incomeTotal > 0)
                const SizedBox(width: 8),
              if (incomeTotal > 0)
                Text(
                  '收入 ¥${incomeTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
            ],
          ),
        ),
        // 记录列表
        ...records.map((record) => RecordCard(
              recordDetail: record,
              onTap: () => onTap?.call(record),
              onLongPress: () => onLongPress?.call(record),
            )),
      ],
    );
  }
}
