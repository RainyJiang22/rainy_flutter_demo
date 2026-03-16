import 'package:flutter/material.dart' hide Split;
import '../../data/models/member.dart';
import '../../data/models/split.dart';

/// 分摊设置面板
class SplitPanel extends StatefulWidget {
  final double totalAmount;
  final List<Member> members;
  final List<Split>? initialSplits;
  final String? initialPayerId;
  final ValueChanged<SplitResult>? onChanged;

  const SplitPanel({
    super.key,
    required this.totalAmount,
    required this.members,
    this.initialSplits,
    this.initialPayerId,
    this.onChanged,
  });

  @override
  State<SplitPanel> createState() => _SplitPanelState();
}

class _SplitPanelState extends State<SplitPanel> {
  SplitType _splitType = SplitType.equal;
  Set<String> _selectedMemberIds = {};
  String? _payerId;
  Map<String, double> _customAmounts = {};
  Map<String, double> _ratios = {};

  @override
  void initState() {
    super.initState();
    _initFromInitial();
  }

  void _initFromInitial() {
    if (widget.initialSplits != null && widget.initialSplits!.isNotEmpty) {
      final firstSplit = widget.initialSplits!.first;
      _splitType = firstSplit.splitType;
      _selectedMemberIds = widget.initialSplits!.map((s) => s.memberId).toSet();

      for (final split in widget.initialSplits!) {
        _customAmounts[split.memberId] = split.amount;
        if (split.ratio != null) {
          _ratios[split.memberId] = split.ratio!;
        }
      }
    }

    _payerId = widget.initialPayerId;

    // 默认选择所有成员
    if (_selectedMemberIds.isEmpty) {
      _selectedMemberIds = widget.members.map((m) => m.id).toSet();
    }
  }

  void _notifyChanged() {
    if (widget.onChanged == null) return;

    final splits = _calculateSplits();
    widget.onChanged!(SplitResult(
      splits: splits,
      payerId: _payerId,
    ));
  }

  List<Split> _calculateSplits() {
    if (_selectedMemberIds.isEmpty) return [];

    final selectedMembers =
        widget.members.where((m) => _selectedMemberIds.contains(m.id)).toList();

    switch (_splitType) {
      case SplitType.equal:
        final amountPerPerson = widget.totalAmount / selectedMembers.length;
        return selectedMembers.map((m) => Split(
              id: '',
              recordId: '',
              memberId: m.id,
              amount: amountPerPerson,
              splitType: SplitType.equal,
            )).toList();

      case SplitType.ratio:
        final totalRatio = _ratios.values.fold<double>(0, (sum, r) => sum + r);
        if (totalRatio == 0) return [];

        return selectedMembers.map((m) {
          final ratio = _ratios[m.id] ?? 1;
          final amount = widget.totalAmount * (ratio / totalRatio);
          return Split(
            id: '',
            recordId: '',
            memberId: m.id,
            amount: amount,
            splitType: SplitType.ratio,
            ratio: ratio,
          );
        }).toList();

      case SplitType.fixed:
        return selectedMembers.map((m) {
          final amount = _customAmounts[m.id] ?? 0;
          return Split(
            id: '',
            recordId: '',
            memberId: m.id,
            amount: amount,
            splitType: SplitType.fixed,
          );
        }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分摊类型选择
        Text('分摊方式', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<SplitType>(
          segments: const [
            ButtonSegment(value: SplitType.equal, label: Text('平均')),
            ButtonSegment(value: SplitType.ratio, label: Text('比例')),
            ButtonSegment(value: SplitType.fixed, label: Text('指定')),
          ],
          selected: {_splitType},
          onSelectionChanged: (types) {
            setState(() => _splitType = types.first);
            _notifyChanged();
          },
        ),
        const SizedBox(height: 16),

        // 成员选择
        Text('参与成员', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.members.map((member) {
            final isSelected = _selectedMemberIds.contains(member.id);
            return FilterChip(
              selected: isSelected,
              label: Text(member.name),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedMemberIds.add(member.id);
                  } else {
                    _selectedMemberIds.remove(member.id);
                  }
                });
                _notifyChanged();
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // 根据分摊类型显示不同的输入
        if (_splitType == SplitType.ratio) ...[
          Text('分摊比例', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...widget.members
              .where((m) => _selectedMemberIds.contains(m.id))
              .map((member) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(member.name)),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '比例',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onChanged: (value) {
                              _ratios[member.id] = double.tryParse(value) ?? 0;
                              _notifyChanged();
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
        ],

        if (_splitType == SplitType.fixed) ...[
          Text('分摊金额', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...widget.members
              .where((m) => _selectedMemberIds.contains(m.id))
              .map((member) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(member.name)),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '¥',
                              hintText: '金额',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onChanged: (value) {
                              _customAmounts[member.id] =
                                  double.tryParse(value) ?? 0;
                              _notifyChanged();
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
          // 显示总金额提示
          Builder(builder: (context) {
            final total = _customAmounts.values.fold<double>(0, (sum, a) => sum + a);
            final diff = widget.totalAmount - total;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                diff.abs() < 0.01
                    ? '已分配完毕'
                    : '还需分配 ¥${diff.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: diff.abs() < 0.01
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                    ),
              ),
            );
          }),
        ],
        const SizedBox(height: 16),

        // 垫付人选择
        Text('垫付人', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _payerId,
          hint: const Text('选择垫付人'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: widget.members
              .where((m) => _selectedMemberIds.contains(m.id))
              .map((member) => DropdownMenuItem(
                    value: member.id,
                    child: Text(member.name),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() => _payerId = value);
            _notifyChanged();
          },
        ),
      ],
    );
  }
}

/// 分摊结果
class SplitResult {
  final List<Split> splits;
  final String? payerId;

  const SplitResult({
    required this.splits,
    this.payerId,
  });
}
