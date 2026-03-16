import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/record.dart';
import '../../data/repositories/record_repository.dart';
import 'database_provider.dart';
import 'current_book_provider.dart';

/// 统计数据模型
class StatisticsData {
  final double totalExpense;
  final double totalIncome;
  final double balance;
  final List<CategoryStatistics> categoryStats;
  final List<DailyStatistics> dailyStats;

  const StatisticsData({
    this.totalExpense = 0,
    this.totalIncome = 0,
    this.balance = 0,
    this.categoryStats = const [],
    this.dailyStats = const [],
  });

  StatisticsData copyWith({
    double? totalExpense,
    double? totalIncome,
    double? balance,
    List<CategoryStatistics>? categoryStats,
    List<DailyStatistics>? dailyStats,
  }) {
    return StatisticsData(
      totalExpense: totalExpense ?? this.totalExpense,
      totalIncome: totalIncome ?? this.totalIncome,
      balance: balance ?? this.balance,
      categoryStats: categoryStats ?? this.categoryStats,
      dailyStats: dailyStats ?? this.dailyStats,
    );
  }
}

/// 分类统计
class CategoryStatistics {
  final String categoryId;
  final String name;
  final String icon;
  final int color;
  final double amount;
  final double percentage;

  const CategoryStatistics({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
    required this.amount,
    required this.percentage,
  });
}

/// 日统计
class DailyStatistics {
  final DateTime date;
  final double expense;
  final double income;

  const DailyStatistics({
    required this.date,
    required this.expense,
    required this.income,
  });
}

/// 统计 Provider
final statisticsProvider = FutureProvider.family<StatisticsData,
    ({String bookId, DateTime? startDate, DateTime? endDate})>((ref, params) async {
  final repository = ref.watch(recordRepositoryProvider);

  // 获取总收入和总支出
  final totalExpense = await repository.sumByBookId(
    params.bookId,
    RecordType.expense,
    startDate: params.startDate,
    endDate: params.endDate,
  );

  final totalIncome = await repository.sumByBookId(
    params.bookId,
    RecordType.income,
    startDate: params.startDate,
    endDate: params.endDate,
  );

  // 获取分类统计
  final categoryData = await repository.sumByCategory(
    params.bookId,
    RecordType.expense,
    startDate: params.startDate,
    endDate: params.endDate,
  );

  final categoryStats = categoryData.map((data) {
    final amount = (data['total'] as double?) ?? 0;
    return CategoryStatistics(
      categoryId: data['category_id'] as String? ?? '',
      name: data['name'] as String? ?? '其他',
      icon: data['icon'] as String? ?? 'more_horiz',
      color: (data['color'] as int?) ?? 0xFF607D8B,
      amount: amount,
      percentage: totalExpense > 0 ? (amount / totalExpense * 100) : 0,
    );
  }).toList();

  // 获取日统计
  final expenseDaily = await repository.sumByDate(
    params.bookId,
    RecordType.expense,
    startDate: params.startDate,
    endDate: params.endDate,
  );

  final incomeDaily = await repository.sumByDate(
    params.bookId,
    RecordType.income,
    startDate: params.startDate,
    endDate: params.endDate,
  );

  // 合并日统计
  final dailyMap = <String, DailyStatistics>{};
  for (final data in expenseDaily) {
    final dateStr = data['day'] as String;
    final amount = (data['total'] as double?) ?? 0;
    dailyMap[dateStr] = DailyStatistics(
      date: DateTime.parse(dateStr),
      expense: amount,
      income: 0,
    );
  }
  for (final data in incomeDaily) {
    final dateStr = data['day'] as String;
    final amount = (data['total'] as double?) ?? 0;
    final existing = dailyMap[dateStr];
    if (existing != null) {
      dailyMap[dateStr] = DailyStatistics(
        date: existing.date,
        expense: existing.expense,
        income: amount,
      );
    } else {
      dailyMap[dateStr] = DailyStatistics(
        date: DateTime.parse(dateStr),
        expense: 0,
        income: amount,
      );
    }
  }

  final dailyStats = dailyMap.values.toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return StatisticsData(
    totalExpense: totalExpense,
    totalIncome: totalIncome,
    balance: totalIncome - totalExpense,
    categoryStats: categoryStats,
    dailyStats: dailyStats,
  );
});

/// 本月统计 Provider
final monthlyStatisticsProvider = FutureProvider<StatisticsData>((ref) async {
  final currentBook = ref.watch(currentBookProvider);
  if (currentBook == null) return const StatisticsData();

  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month, 1);
  final endDate = DateTime(now.year, now.month + 1, 0);

  return ref.watch(statisticsProvider((
    bookId: currentBook.id,
    startDate: startDate,
    endDate: endDate,
  )).future);
});

/// 今日统计 Provider
final todayStatisticsProvider = FutureProvider<StatisticsData>((ref) async {
  final currentBook = ref.watch(currentBookProvider);
  if (currentBook == null) return const StatisticsData();

  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month, now.day);
  final endDate = startDate.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

  return ref.watch(statisticsProvider((
    bookId: currentBook.id,
    startDate: startDate,
    endDate: endDate,
  )).future);
});
