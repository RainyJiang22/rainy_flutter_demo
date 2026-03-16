import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/category.dart';
import '../providers/categories_provider.dart';
import '../providers/current_book_provider.dart';
import '../widgets/common/empty_state.dart';

/// 分类管理页面
class CategoryManagePage extends ConsumerStatefulWidget {
  const CategoryManagePage({super.key});

  @override
  ConsumerState<CategoryManagePage> createState() => _CategoryManagePageState();
}

class _CategoryManagePageState extends ConsumerState<CategoryManagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);
    final currentBook = ref.watch(currentBookProvider);

    final expenseCategories =
        categoriesState.categories.where((c) => c.type == CategoryType.expense).toList();
    final incomeCategories =
        categoriesState.categories.where((c) => c.type == CategoryType.income).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('分类管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '支出'),
            Tab(text: '收入'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddCategoryDialog(context, CategoryType.expense),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: categoriesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryList(
                  context,
                  expenseCategories,
                  CategoryType.expense,
                ),
                _buildCategoryList(
                  context,
                  incomeCategories,
                  CategoryType.income,
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    List<Category> categories,
    CategoryType type,
  ) {
    if (categories.isEmpty) {
      return EmptyCategories(
        onAdd: () => _showAddCategoryDialog(context, type),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          onEdit: () => _showEditCategoryDialog(context, category),
          onDelete: category.isDefault
              ? null
              : () => _deleteCategory(category),
        );
      },
    );
  }

  void _deleteCategory(Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除分类'),
        content: Text('确定要删除 ${category.name} 吗？'),
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
      await ref
          .read(categoriesProvider.notifier)
          .delete(category.id, currentBook?.id);
    }
  }

  void _showAddCategoryDialog(BuildContext context, CategoryType type) {
    _showCategoryDialog(context, null, type);
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    _showCategoryDialog(context, category, category.type);
  }

  void _showCategoryDialog(
    BuildContext context,
    Category? category,
    CategoryType type,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CategoryForm(
        category: category,
        type: type,
        onSave: (newCategory) async {
          if (category == null) {
            await ref.read(categoriesProvider.notifier).create(newCategory);
          } else {
            await ref.read(categoriesProvider.notifier).update(newCategory);
          }
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(category == null ? '分类已创建' : '分类已更新')),
            );
          }
        },
      ),
    );
  }
}

/// 分类列表项
class _CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CategoryTile({
    required this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(category.color).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getIconData(category.icon),
            color: Color(category.color),
          ),
        ),
        title: Text(category.name),
        subtitle: category.isDefault ? const Text('默认分类') : null,
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
            if (onDelete != null)
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

  IconData _getIconData(String iconName) {
    final iconMap = {
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'shopping_cart': Icons.shopping_cart,
      'sports_esports': Icons.sports_esports,
      'home': Icons.home,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'more_horiz': Icons.more_horiz,
      'account_balance_wallet': Icons.account_balance_wallet,
      'card_giftcard': Icons.card_giftcard,
      'trending_up': Icons.trending_up,
    };
    return iconMap[iconName] ?? Icons.category;
  }
}

/// 分类表单
class _CategoryForm extends StatefulWidget {
  final Category? category;
  final CategoryType type;
  final Function(Category) onSave;

  const _CategoryForm({
    this.category,
    required this.type,
    required this.onSave,
  });

  @override
  State<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<_CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String _selectedIcon = 'more_horiz';
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
    Colors.amber,
    Colors.cyan,
  ];

  final List<Map<String, dynamic>> _icons = [
    {'name': 'restaurant', 'icon': Icons.restaurant},
    {'name': 'directions_car', 'icon': Icons.directions_car},
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart},
    {'name': 'sports_esports', 'icon': Icons.sports_esports},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'local_hospital', 'icon': Icons.local_hospital},
    {'name': 'school', 'icon': Icons.school},
    {'name': 'account_balance_wallet', 'icon': Icons.account_balance_wallet},
    {'name': 'card_giftcard', 'icon': Icons.card_giftcard},
    {'name': 'trending_up', 'icon': Icons.trending_up},
    {'name': 'more_horiz', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.icon ?? 'more_horiz';
    _selectedColor = widget.category?.color ?? Colors.teal.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final category = Category(
      id: widget.category?.id ?? const Uuid().v4(),
      bookId: widget.category?.bookId,
      name: _nameController.text.trim(),
      type: widget.type,
      icon: _selectedIcon,
      color: _selectedColor,
      isDefault: widget.category?.isDefault ?? false,
    );

    await widget.onSave(category);
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
                widget.category == null ? '创建分类' : '编辑分类',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '分类名称',
                  hintText: '输入分类名称',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入分类名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('图标', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _icons.map((item) {
                  final isSelected = item['name'] == _selectedIcon;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = item['name']),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(
                        item['icon'],
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('颜色', style: Theme.of(context).textTheme.titleSmall),
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
                      width: 36,
                      height: 36,
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
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
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
