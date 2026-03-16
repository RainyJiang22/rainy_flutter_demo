import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/current_book_provider.dart';
import '../providers/statistics_provider.dart';
import '../widgets/chart_widgets/trend_chart.dart';
import '../widgets/chart_widgets/pie_chart.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/empty_state.dart';

/// 统计报表页面
class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initDates();
  }

  void _initDates() {
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
  }

  void _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBook = ref.watch(currentBookProvider);
    final stats = currentBook != null
        ? ref.watch(statisticsProvider((
            bookId: currentBook.id,
            startDate: _startDate,
            endDate: _endDate,
          )))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        actions: [
          TextButton.icon(
            onPressed: _selectDateRange,
            icon: const Icon(Icons.date_range),
            label: Text(
              '${DateFormat('MM/dd').format(_startDate)} - ${DateFormat('MM/dd').format(_endDate)}',
            ),
          ),
        ],
      ),
      body: stats == null
          ? const LoadingIndicator()
          : stats.when(
              data: (data) {
                if (data.categoryStats.isEmpty && data.dailyStats.isEmpty) {
                  return const EmptyState(
                    icon: Icons.bar_chart,
                    title: '暂无数据',
                    subtitle: '开始记账后即可查看统计',
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 概览卡片
                      _buildOverviewCard(context, data),
                      const SizedBox(height: 24),

                      // 趋势图
                      Text('收支趋势', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TrendChart(
                            data: data.dailyStats,
                            days: _endDate.difference(_startDate).inDays + 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 分类统计
                      Text('支出分类', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: data.categoryStats.isNotEmpty
                              ? Column(
                                  children: [
                                    CategoryPieChart(
                                      data: data.categoryStats,
                                      totalAmount: data.totalExpense,
                                    ),
                                    const SizedBox(height: 16),
                                    const Divider(),
                                    const SizedBox(height: 16),
                                    CategoryBarChart(data: data.categoryStats),
                                  ],
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text('暂无支出数据'),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const LoadingIndicator(),
              error: (error, _) => Center(
                child: Text('加载失败: $error'),
              ),
            ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, dynamic data) {
    return Container(
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
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  context,
                  '总支出',
                  data.totalExpense,
                  true,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatColumn(
                  context,
                  '总收入',
                  data.totalIncome,
                  false,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatColumn(
                  context,
                  '结余',
                  data.balance,
                  data.balance < 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    double amount,
    bool isNegative,
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
            '¥${amount.abs().toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ),
      ],
    );
  }
}
