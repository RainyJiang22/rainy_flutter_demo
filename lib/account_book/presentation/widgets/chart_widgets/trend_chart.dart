import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/statistics_provider.dart';

/// 趋势折线图
class TrendChart extends StatelessWidget {
  final List<DailyStatistics> data;
  final bool showIncome;
  final bool showExpense;
  final int? days;

  const TrendChart({
    super.key,
    required this.data,
    this.showIncome = true,
    this.showExpense = true,
    this.days,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }

    final displayData = days != null && data.length > days!
        ? data.sublist(data.length - days!)
        : data;

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(displayData),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: _calculateBottomInterval(displayData),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= displayData.length) {
                    return const Text('');
                  }
                  final date = displayData[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${date.month}/${date.day}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: _calculateInterval(displayData),
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatAmount(value),
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (displayData.length - 1).toDouble(),
          minY: 0,
          maxY: _calculateMaxY(displayData),
          lineBarsData: [
            if (showExpense)
              LineChartBarData(
                isCurved: true,
                color: Theme.of(context).colorScheme.error,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                ),
                spots: displayData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.expense))
                    .toList(),
              ),
            if (showIncome)
              LineChartBarData(
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ),
                spots: displayData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.income))
                    .toList(),
              ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  if (index < 0 || index >= displayData.length) {
                    return null;
                  }
                  final date = displayData[index].date;
                  final isExpense = spot.barIndex == 0;
                  return LineTooltipItem(
                    '${date.month}/${date.day}\n${isExpense ? "支出" : "收入"}: ¥${spot.y.toStringAsFixed(2)}',
                    TextStyle(
                      color: isExpense
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMaxY(List<DailyStatistics> data) {
    double maxY = 0;
    for (final d in data) {
      if (showExpense && d.expense > maxY) maxY = d.expense;
      if (showIncome && d.income > maxY) maxY = d.income;
    }
    return maxY * 1.2;
  }

  double _calculateInterval(List<DailyStatistics> data) {
    final maxY = _calculateMaxY(data);
    if (maxY <= 100) return 20;
    if (maxY <= 500) return 100;
    if (maxY <= 1000) return 200;
    if (maxY <= 5000) return 1000;
    if (maxY <= 10000) return 2000;
    return 5000;
  }

  double _calculateBottomInterval(List<DailyStatistics> data) {
    if (data.length <= 7) return 1;
    if (data.length <= 14) return 2;
    if (data.length <= 30) return 5;
    return 7;
  }

  String _formatAmount(double value) {
    if (value >= 10000) {
      return '${(value / 10000).toStringAsFixed(1)}万';
    }
    return value.toInt().toString();
  }
}
