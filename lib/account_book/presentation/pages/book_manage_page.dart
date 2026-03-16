import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/book.dart';
import '../providers/books_provider.dart';
import '../providers/current_book_provider.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/app_card.dart';

/// 账本管理页面
class BookManagePage extends ConsumerStatefulWidget {
  const BookManagePage({super.key});

  @override
  ConsumerState<BookManagePage> createState() => _BookManagePageState();
}

class _BookManagePageState extends ConsumerState<BookManagePage> {
  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);
    final currentBook = ref.watch(currentBookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('账本管理'),
        actions: [
          IconButton(
            onPressed: () => _showAddBookDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: booksState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : booksState.books.isEmpty
              ? EmptyState(
                  icon: Icons.book,
                  title: '暂无账本',
                  subtitle: '点击右上角创建账本',
                  action: FilledButton.icon(
                    onPressed: () => _showAddBookDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('创建账本'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: booksState.books.length,
                  itemBuilder: (context, index) {
                    final book = booksState.books[index];
                    final isCurrentBook = book.id == currentBook?.id;

                    return _BookCard(
                      book: book,
                      isCurrentBook: isCurrentBook,
                      onTap: () => _switchBook(book),
                      onEdit: () => _showEditBookDialog(context, book),
                      onArchive: () => _archiveBook(book),
                    );
                  },
                ),
    );
  }

  void _switchBook(Book book) {
    ref.read(currentBookProvider.notifier).switchBook(book);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已切换到 ${book.name}')),
    );
  }

  void _archiveBook(Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('归档账本'),
        content: Text('确定要归档 ${book.name} 吗？归档后可在设置中恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('归档'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(booksProvider.notifier).archive(book.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('账本已归档')),
        );
      }
    }
  }

  void _showAddBookDialog(BuildContext context) {
    _showBookDialog(context, null);
  }

  void _showEditBookDialog(BuildContext context, Book book) {
    _showBookDialog(context, book);
  }

  void _showBookDialog(BuildContext context, Book? book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _BookForm(
        book: book,
        onSave: (newBook) async {
          if (book == null) {
            await ref.read(booksProvider.notifier).create(newBook);
          } else {
            await ref.read(booksProvider.notifier).update(newBook);
          }
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(book == null ? '账本已创建' : '账本已更新')),
            );
          }
        },
      ),
    );
  }
}

/// 账本卡片
class _BookCard extends StatelessWidget {
  final Book book;
  final bool isCurrentBook;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  const _BookCard({
    required this.book,
    required this.isCurrentBook,
    required this.onTap,
    required this.onEdit,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(book.color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.book,
              color: Color(book.color),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      book.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (isCurrentBook) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '当前',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  book.type.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'archive') onArchive();
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
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined),
                    SizedBox(width: 8),
                    Text('归档'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 账本表单
class _BookForm extends StatefulWidget {
  final Book? book;
  final Function(Book) onSave;

  const _BookForm({
    this.book,
    required this.onSave,
  });

  @override
  State<_BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<_BookForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  BookType _type = BookType.sub;
  int _selectedColor = Colors.teal.value;
  bool _isLoading = false;

  final List<Color> _colors = [
    Colors.teal,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
    Colors.green,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.book?.name ?? '');
    _type = widget.book?.type ?? BookType.sub;
    _selectedColor = widget.book?.color ?? Colors.teal.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final book = Book(
      id: widget.book?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _type,
      icon: 'book',
      color: _selectedColor,
      createdAt: widget.book?.createdAt ?? DateTime.now(),
    );

    await widget.onSave(book);
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
                widget.book == null ? '创建账本' : '编辑账本',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '账本名称',
                  hintText: '输入账本名称',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入账本名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('账本类型', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<BookType>(
                segments: const [
                  ButtonSegment(value: BookType.main, label: Text('主账本')),
                  ButtonSegment(value: BookType.sub, label: Text('子账本')),
                ],
                selected: {_type},
                onSelectionChanged: (types) {
                  setState(() => _type = types.first);
                },
              ),
              const SizedBox(height: 16),
              Text('主题颜色', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _colors.map((color) {
                  final isSelected = color.value == _selectedColor;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = color.value),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
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
}
