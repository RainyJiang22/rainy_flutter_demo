import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoExercisePage extends StatelessWidget {
  const TodoExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoExerciseModel.seeded(),
      child: const _TodoExerciseView(),
    );
  }
}

class _TodoExerciseView extends StatelessWidget {
  const _TodoExerciseView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('待办事项练习'),
        actions: [
          Consumer<TodoExerciseModel>(
            builder: (context, model, _) {
              return IconButton(
                tooltip: '清理已完成',
                onPressed: model.completedCount == 0
                    ? null
                    : model.clearCompleted,
                icon: const Icon(Icons.cleaning_services_outlined),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: const [
          _TodoSummaryCard(),
          SizedBox(height: 18),
          _TodoFilterBar(),
          SizedBox(height: 18),
          _TodoListSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTodoEditorDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('新增待办'),
      ),
    );
  }
}

class _TodoSummaryCard extends StatelessWidget {
  const _TodoSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoExerciseModel>(
      builder: (context, model, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TodoMetric(label: '总数', value: '${model.items.length}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TodoMetric(label: '进行中', value: '${model.activeCount}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TodoMetric(
                  label: '已完成',
                  value: '${model.completedCount}',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TodoMetric extends StatelessWidget {
  const _TodoMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class _TodoFilterBar extends StatelessWidget {
  const _TodoFilterBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoExerciseModel>(
      builder: (context, model, _) {
        return Wrap(
          spacing: 10,
          children: TodoFilter.values
              .map(
                (filter) => ChoiceChip(
                  label: Text(filter.label),
                  selected: model.filter == filter,
                  onSelected: (_) => model.setFilter(filter),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _TodoListSection extends StatelessWidget {
  const _TodoListSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoExerciseModel>(
      builder: (context, model, _) {
        if (model.visibleItems.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              children: [
                const Icon(Icons.inbox_outlined, size: 44),
                const SizedBox(height: 12),
                Text(
                  '当前筛选下没有待办',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '试试切换筛选条件，或者新增一条任务。',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return Column(
          children: model.visibleItems
              .map((item) => _TodoTile(item: item))
              .toList(growable: false),
        );
      },
    );
  }
}

class _TodoTile extends StatelessWidget {
  const _TodoTile({required this.item});

  final TodoItem item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) => context.read<TodoExerciseModel>().removeTodo(item.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Checkbox(
            value: item.isDone,
            onChanged: (_) =>
                context.read<TodoExerciseModel>().toggleTodo(item.id),
          ),
          title: Text(
            item.title,
            style: TextStyle(
              decoration: item.isDone ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.note.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(item.note),
              ],
              const SizedBox(height: 4),
              Text(
                '创建于 ${item.createdAt.month.toString().padLeft(2, '0')}-${item.createdAt.day.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => showTodoEditorDialog(context, todo: item),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
      ),
    );
  }
}

Future<void> showTodoEditorDialog(
  BuildContext context, {
  TodoItem? todo,
}) async {
  final titleController = TextEditingController(text: todo?.title ?? '');
  final noteController = TextEditingController(text: todo?.note ?? '');
  final formKey = GlobalKey<FormState>();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(todo == null ? '新增待办' : '编辑待办'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                  hintText: '例如：整理第7章练习代码',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '标题不能为空';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noteController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '备注',
                  hintText: '补充这条待办的上下文',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) {
                return;
              }

              final model = context.read<TodoExerciseModel>();
              if (todo == null) {
                model.addTodo(
                  title: titleController.text.trim(),
                  note: noteController.text.trim(),
                );
              } else {
                model.updateTodo(
                  todo.copyWith(
                    title: titleController.text.trim(),
                    note: noteController.text.trim(),
                  ),
                );
              }
              Navigator.of(dialogContext).pop();
            },
            child: Text(todo == null ? '创建' : '保存'),
          ),
        ],
      );
    },
  );

  titleController.dispose();
  noteController.dispose();
}

enum TodoFilter {
  all('全部'),
  active('进行中'),
  completed('已完成');

  const TodoFilter(this.label);

  final String label;
}

class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    required this.note,
    required this.createdAt,
    this.isDone = false,
  });

  final String id;
  final String title;
  final String note;
  final DateTime createdAt;
  final bool isDone;

  TodoItem copyWith({
    String? title,
    String? note,
    DateTime? createdAt,
    bool? isDone,
  }) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}

class TodoExerciseModel extends ChangeNotifier {
  TodoExerciseModel({List<TodoItem>? initialItems})
    : _items = initialItems ?? [];

  factory TodoExerciseModel.seeded() {
    return TodoExerciseModel(
      initialItems: [
        TodoItem(
          id: 'todo-1',
          title: '整理第7章摘要',
          note: '梳理 Provider、Theme、Dialog 的核心知识点。',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TodoItem(
          id: 'todo-2',
          title: '补齐练习页面',
          note: '把文档里的练习真正落到项目里。',
          createdAt: DateTime.now(),
          isDone: true,
        ),
      ],
    );
  }

  final List<TodoItem> _items;
  TodoFilter _filter = TodoFilter.all;

  UnmodifiableListView<TodoItem> get items => UnmodifiableListView(_items);
  TodoFilter get filter => _filter;

  List<TodoItem> get visibleItems {
    switch (_filter) {
      case TodoFilter.all:
        return List<TodoItem>.unmodifiable(_items);
      case TodoFilter.active:
        return List<TodoItem>.unmodifiable(
          _items.where((item) => !item.isDone),
        );
      case TodoFilter.completed:
        return List<TodoItem>.unmodifiable(_items.where((item) => item.isDone));
    }
  }

  int get activeCount => _items.where((item) => !item.isDone).length;
  int get completedCount => _items.where((item) => item.isDone).length;

  void setFilter(TodoFilter value) {
    _filter = value;
    notifyListeners();
  }

  void addTodo({required String title, required String note}) {
    _items.insert(
      0,
      TodoItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        note: note,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateTodo(TodoItem updated) {
    final index = _items.indexWhere((item) => item.id == updated.id);
    if (index == -1) {
      return;
    }
    _items[index] = updated;
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }
    _items[index] = _items[index].copyWith(isDone: !_items[index].isDone);
    notifyListeners();
  }

  void removeTodo(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _items.removeWhere((item) => item.isDone);
    notifyListeners();
  }
}
