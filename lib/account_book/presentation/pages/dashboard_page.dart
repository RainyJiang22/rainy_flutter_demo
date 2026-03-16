import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/record.dart';
import '../providers/current_book_provider.dart';
import '../providers/records_provider.dart';
import '../providers/statistics_provider.dart';
import '../providers/books_provider.dart';
import '../widgets/record_card.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/quick_record_sheet.dart';
import 'book_manage_page.dart';

/// 首页仪表盘
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBook = ref.watch(currentBookProvider);
    final todayStats = ref.watch(todayStatisticsProvider);
    final monthlyStats = ref.watch(monthlyStatisticsProvider);
    final recordsState = ref.watch(recordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: _buildBookSelector(context, ref, currentBook),
        actions: [
          IconButton(
            onPressed: () => _showBookManage(context),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: currentBook == null
          ? const LoadingIndicator()
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(recordsProvider);
                ref.invalidate(todayStatisticsProvider);
                ref.invalidate(monthlyStatisticsProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 本月概览卡片
                    _buildMonthlyOverview(context, monthlyStats),
                    const SizedBox(height: 16),

                    // 今日概览
                    _buildTodayOverview(context, todayStats),
                    const SizedBox(height: 16),

                    // 最近记录
                    _buildRecentRecords(context, recordsState),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBookSelector(
    BuildContext context,
    WidgetRef ref,
    dynamic currentBook,
  ) {
    final booksState = ref.watch(booksProvider);

    if (booksState.books.isEmpty) {
      return const Text('记账本');
    }

    return InkWell(
      onTap: () => _showBookSelector(context, ref, booksState.books),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentBook?.name ?? '选择账本',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void _showBookSelector(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> books,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '选择账本',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            ...books.map((book) => ListTile(
                  leading: Icon(
                    Icons.book_outlined,
                    color: Color(book.color),
                  ),
                  title: Text(book.name),
                  subtitle: Text(
                    book.type.label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    ref.read(currentBookProvider.notifier).switchBook(book);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyOverview(BuildContext context, AsyncValue<dynamic> stats) {
    return stats.when(
      data: (data) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '本月概览',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    '支出',
                    data?.totalExpense ?? 0,
                    true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    '收入',
                    data?.totalIncome ?? 0,
                    false,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    '结余',
                    data?.balance ?? 0,
                    (data?.balance ?? 0) < 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 120, child: LoadingIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    double amount,
    bool isExpense,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '¥${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayOverview(BuildContext context, AsyncValue<dynamic> stats) {
    return stats.when(
      data: (data) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildTodayCard(
                context,
                '今日支出',
                data?.totalExpense ?? 0,
                Icons.arrow_upward,
                true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTodayCard(
                context,
                '今日收入',
                data?.totalIncome ?? 0,
                Icons.arrow_downward,
                false,
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTodayCard(
    BuildContext context,
    String title,
    double amount,
    IconData icon,
    bool isExpense,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isExpense
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '¥${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isExpense
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecords(BuildContext context, dynamic recordsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最近记录',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // TODO: 查看全部记录
                },
                child: const Text('查看全部'),
              ),
            ],
          ),
        ),
        if (recordsState.isLoading)
          const SizedBox(height: 100, child: LoadingIndicator())
        else if (recordsState.records.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: EmptyRecords(
              onAdd: () => QuickRecordSheet.show(context),
            ),
          )
        else
          ..._groupByDate(recordsState.records.take(10).toList())
              .entries
              .map((entry) => RecordListGroup(
                    date: entry.key,
                    records: entry.value,
                  )),
      ],
    );
  }

  Map<DateTime, List<RecordDetail>> _groupByDate(List<RecordDetail> records) {
    final map = <DateTime, List<RecordDetail>>{};
    for (final record in records) {
      final date = record.record.date;
      final dateKey = DateTime(date.year, date.month, date.day);
      map.putIfAbsent(dateKey, () => []).add(record);
    }
    return map;
  }

  void _showBookManage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookManagePage()),
    );
  }
}
