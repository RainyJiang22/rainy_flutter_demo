import 'package:flutter/material.dart';
import '../../data/models/member.dart';

/// 成员选择器
class MemberPicker extends StatelessWidget {
  final List<Member> members;
  final Set<String> selectedMemberIds;
  final ValueChanged<Set<String>>? onSelectionChanged;
  final bool multiSelect;

  const MemberPicker({
    super.key,
    required this.members,
    this.selectedMemberIds = const {},
    this.onSelectionChanged,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('暂无成员'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: members.map((member) {
        final isSelected = selectedMemberIds.contains(member.id);
        return _MemberChip(
          member: member,
          isSelected: isSelected,
          onTap: () {
            if (multiSelect) {
              final newSelection = Set<String>.from(selectedMemberIds);
              if (isSelected) {
                newSelection.remove(member.id);
              } else {
                newSelection.add(member.id);
              }
              onSelectionChanged?.call(newSelection);
            } else {
              onSelectionChanged?.call({member.id});
            }
          },
        );
      }).toList(),
    );
  }
}

/// 成员芯片
class _MemberChip extends StatelessWidget {
  final Member member;
  final bool isSelected;
  final VoidCallback onTap;

  const _MemberChip({
    required this.member,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatar(context),
          const SizedBox(width: 8),
          Text(member.name),
        ],
      ),
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (member.avatar != null && member.avatar!.isNotEmpty) {
      // 如果 avatar 是 emoji
      if (member.avatar!.runes.length == 1 ||
          member.avatar!.runes.length == 2) {
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              member.avatar!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      }
    }

    // 默认头像
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

/// 成员选择对话框
class MemberPickerDialog extends StatefulWidget {
  final List<Member> members;
  final Set<String> selectedMemberIds;
  final bool multiSelect;
  final String? title;

  const MemberPickerDialog({
    super.key,
    required this.members,
    this.selectedMemberIds = const {},
    this.multiSelect = true,
    this.title,
  });

  static Future<Set<String>?> show(
    BuildContext context, {
    required List<Member> members,
    Set<String> selectedMemberIds = const {},
    bool multiSelect = true,
    String? title,
  }) async {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => MemberPickerDialog(
        members: members,
        selectedMemberIds: selectedMemberIds,
        multiSelect: multiSelect,
        title: title,
      ),
    );
  }

  @override
  State<MemberPickerDialog> createState() => _MemberPickerDialogState();
}

class _MemberPickerDialogState extends State<MemberPickerDialog> {
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.selectedMemberIds);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title ?? '选择成员',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, _selectedIds),
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: MemberPicker(
                  members: widget.members,
                  selectedMemberIds: _selectedIds,
                  multiSelect: widget.multiSelect,
                  onSelectionChanged: (ids) {
                    setState(() => _selectedIds = ids);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
