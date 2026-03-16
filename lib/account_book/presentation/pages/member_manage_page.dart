import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/member.dart';
import '../providers/members_provider.dart';
import '../providers/current_book_provider.dart';
import '../widgets/common/empty_state.dart';

/// 成员管理页面
class MemberManagePage extends ConsumerStatefulWidget {
  const MemberManagePage({super.key});

  @override
  ConsumerState<MemberManagePage> createState() => _MemberManagePageState();
}

class _MemberManagePageState extends ConsumerState<MemberManagePage> {
  @override
  Widget build(BuildContext context) {
    final membersState = ref.watch(membersProvider);
    final currentBook = ref.watch(currentBookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('成员管理'),
        actions: [
          IconButton(
            onPressed: currentBook != null
                ? () => _showAddMemberDialog(context, currentBook.id)
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: currentBook == null
          ? const Center(child: Text('请先选择账本'))
          : membersState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : membersState.members.isEmpty
                  ? EmptyMembers(
                      onAdd: () => _showAddMemberDialog(context, currentBook.id),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: membersState.members.length,
                      itemBuilder: (context, index) {
                        final member = membersState.members[index];
                        return _MemberTile(
                          member: member,
                          onEdit: () => _showEditMemberDialog(context, member),
                          onDelete: () => _deleteMember(member),
                        );
                      },
                    ),
    );
  }

  void _deleteMember(Member member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除成员'),
        content: Text('确定要删除 ${member.name} 吗？'),
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

    if (confirmed == true) {
      final currentBook = ref.read(currentBookProvider);
      if (currentBook != null) {
        await ref
            .read(membersProvider.notifier)
            .delete(member.id, currentBook.id);
      }
    }
  }

  void _showAddMemberDialog(BuildContext context, String bookId) {
    _showMemberDialog(context, null, bookId);
  }

  void _showEditMemberDialog(BuildContext context, Member member) {
    _showMemberDialog(context, member, member.bookId);
  }

  void _showMemberDialog(BuildContext context, Member? member, String bookId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MemberForm(
        member: member,
        bookId: bookId,
        onSave: (newMember) async {
          if (member == null) {
            await ref.read(membersProvider.notifier).create(newMember);
          } else {
            await ref.read(membersProvider.notifier).update(newMember);
          }
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(member == null ? '成员已添加' : '成员已更新')),
            );
          }
        },
      ),
    );
  }
}

/// 成员列表项
class _MemberTile extends StatelessWidget {
  final Member member;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MemberTile({
    required this.member,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
          child: member.avatar != null && member.avatar!.isNotEmpty
              ? Text(member.avatar!, style: const TextStyle(fontSize: 18))
              : Text(
                  member.name.isNotEmpty
                      ? member.name[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
        ),
        title: Text(member.name),
        subtitle: member.phone != null || member.email != null
            ? Text(
                [member.phone, member.email].whereType<String>().join(' | '),
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit?.call();
            if (value == 'delete') onDelete?.call();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('编辑'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 成员表单
class _MemberForm extends StatefulWidget {
  final Member? member;
  final String bookId;
  final Function(Member) onSave;

  const _MemberForm({
    this.member,
    required this.bookId,
    required this.onSave,
  });

  @override
  State<_MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<_MemberForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  String? _avatar;
  bool _isLoading = false;

  final List<String> _avatarOptions = [
    '👤', '😊', '😎', '🤓', '👨', '👩', '🧑', '👦', '👧', '👶',
    '🦸', '🧙', '🧛', '🧜', '🧚', '🦹', '🧝', '👼', '🤖', '👽',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _phoneController = TextEditingController(text: widget.member?.phone ?? '');
    _emailController = TextEditingController(text: widget.member?.email ?? '');
    _avatar = widget.member?.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final member = Member(
      id: widget.member?.id ?? const Uuid().v4(),
      bookId: widget.bookId,
      name: _nameController.text.trim(),
      avatar: _avatar,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
    );

    await widget.onSave(member);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.member == null ? '添加成员' : '编辑成员',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // 头像选择
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showAvatarPicker(),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: _avatar != null && _avatar!.isNotEmpty
                            ? Text(_avatar!, style: const TextStyle(fontSize: 32))
                            : Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _showAvatarPicker,
                      child: const Text('选择头像'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '成员名称',
                  hintText: '输入成员名称',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入成员名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '手机号（可选）',
                  hintText: '输入手机号',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '邮箱（可选）',
                  hintText: '输入邮箱',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
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
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _avatarOptions.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() => _avatar = _avatarOptions[index]);
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _avatarOptions[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
