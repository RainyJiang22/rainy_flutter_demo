import 'package:flutter/material.dart' hide Split;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/record.dart';
import '../../data/models/category.dart';
import '../../data/models/split.dart';
import '../providers/current_book_provider.dart';
import '../providers/categories_provider.dart';
import '../providers/records_provider.dart';
import '../providers/members_provider.dart';
import '../providers/statistics_provider.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_picker.dart';
import '../widgets/split_panel.dart';

/// 完整记账页面
class AddRecordPage extends ConsumerStatefulWidget {
  const AddRecordPage({super.key});

  @override
  ConsumerState<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends ConsumerState<AddRecordPage> {
  RecordType _type = RecordType.expense;
  double _amount = 0;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _noteController = TextEditingController();
  bool _enableSplit = false;
  List<Split> _splits = [];
  String? _payerId;
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      _showError('请输入金额');
      return;
    }

    if (_selectedCategory == null) {
      _showError('请选择分类');
      return;
    }

    final currentBook = ref.read(currentBookProvider);
    if (currentBook == null) return;

    setState(() => _isLoading = true);

    try {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await ref.read(recordsProvider.notifier).create(
            bookId: currentBook.id,
            amount: _amount,
            type: _type,
            categoryId: _selectedCategory!.id,
            date: dateTime,
            note: _noteController.text.isNotEmpty ? _noteController.text : null,
            payerId: _payerId,
            splits: _enableSplit ? _splits : null,
          );

      // 刷新统计数据
      ref.invalidate(todayStatisticsProvider);
      ref.invalidate(monthlyStatisticsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功')),
        );
      }
    } catch (e) {
      _showError('保存失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == RecordType.expense
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);
    final membersState = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('记一笔'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 收支切换
            Center(
              child: SegmentedButton<RecordType>(
                segments: const [
                  ButtonSegment(
                    value: RecordType.expense,
                    label: Text('支出'),
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  ButtonSegment(
                    value: RecordType.income,
                    label: Text('收入'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (types) {
                  setState(() {
                    _type = types.first;
                    _selectedCategory = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // 金额输入
            Center(
              child: AmountInput(
                initialValue: _amount,
                onChanged: (value) => _amount = value,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _type == RecordType.expense
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // 分类选择
            Text('分类', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            CategoryPicker(
              categories: categories,
              selectedCategory: _selectedCategory,
              onSelected: (category) {
                setState(() => _selectedCategory = category);
              },
              showAll: true,
            ),
            const SizedBox(height: 24),

            // 日期时间选择
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(DateFormat('yyyy年MM月dd日').format(_selectedDate)),
                    onTap: _selectDate,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(_selectedTime.format(context)),
                    onTap: _selectTime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 备注
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: '备注',
                hintText: '添加备注...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // 分摊设置
            if (membersState.members.isNotEmpty) ...[
              SwitchListTile(
                title: const Text('启用分摊'),
                subtitle: const Text('将这笔记录分摊给多人'),
                value: _enableSplit,
                onChanged: (value) {
                  setState(() => _enableSplit = value);
                },
              ),
              if (_enableSplit) ...[
                const SizedBox(height: 16),
                SplitPanel(
                  totalAmount: _amount,
                  members: membersState.members,
                  initialSplits: _splits,
                  initialPayerId: _payerId,
                  onChanged: (result) {
                    _splits = result.splits;
                    _payerId = result.payerId;
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
