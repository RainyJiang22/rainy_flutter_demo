import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/record.dart';
import '../../data/models/category.dart';
import '../providers/categories_provider.dart';
import '../providers/records_provider.dart';
import '../providers/current_book_provider.dart';
import '../providers/statistics_provider.dart';
import 'amount_input.dart';
import 'category_picker.dart';

/// 快速记账面板
class QuickRecordSheet extends ConsumerStatefulWidget {
  const QuickRecordSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickRecordSheet(),
    );
  }

  @override
  ConsumerState<QuickRecordSheet> createState() => _QuickRecordSheetState();
}

class _QuickRecordSheetState extends ConsumerState<QuickRecordSheet> {
  RecordType _type = RecordType.expense;
  double _amount = 0;
  Category? _selectedCategory;
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入金额')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择分类')),
      );
      return;
    }

    final currentBook = ref.read(currentBookProvider);
    if (currentBook == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(recordsProvider.notifier).create(
            bookId: currentBook.id,
            amount: _amount,
            type: _type,
            categoryId: _selectedCategory!.id,
            date: DateTime.now(),
            note: _noteController.text.isNotEmpty ? _noteController.text : null,
          );

      // 强制刷新统计数据和记录列表
      ref.invalidate(todayStatisticsProvider);
      ref.invalidate(monthlyStatisticsProvider);
      ref.invalidate(recordsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToFullRecord() {
    Navigator.pop(context);
    // 导航到完整记账页面
    Navigator.pushNamed(context, '/account_book/add_record');
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == RecordType.expense
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖拽指示器
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 收支切换
            Padding(
              padding: const EdgeInsets.all(16),
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
            // 金额输入
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
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
            const SizedBox(height: 16),
            // 分类选择
            CategoryPicker(
              categories: categories,
              selectedCategory: _selectedCategory,
              onSelected: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            const SizedBox(height: 16),
            // 备注输入
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: '添加备注...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 操作按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goToFullRecord,
                      child: const Text('更多选项'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('保存'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
