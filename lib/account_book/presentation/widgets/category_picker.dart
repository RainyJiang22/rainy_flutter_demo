import 'package:flutter/material.dart';
import '../../data/models/category.dart';

/// 分类选择器
class CategoryPicker extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category>? onSelected;
  final bool showAll;

  const CategoryPicker({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onSelected,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('暂无分类'),
      );
    }

    final displayCategories =
        showAll ? categories : categories.take(8).toList();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: displayCategories.length,
        itemBuilder: (context, index) {
          final category = displayCategories[index];
          final isSelected = category.id == selectedCategory?.id;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _CategoryItem(
              category: category,
              isSelected: isSelected,
              onTap: () => onSelected?.call(category),
            ),
          );
        },
      ),
    );
  }
}

/// 分类项
class _CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(category.color)
                    : Color(category.color).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: Icon(
                _getIconData(category.icon),
                color: isSelected ? Colors.white : Color(category.color),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      'work': Icons.work,
      'flight': Icons.flight,
      'movie': Icons.movie,
      'music_note': Icons.music_note,
      'pets': Icons.pets,
      'fitness_center': Icons.fitness_center,
      'phone': Icons.phone,
      'wifi': Icons.wifi,
      'water_drop': Icons.water_drop,
      'electric_bolt': Icons.electric_bolt,
      'gas_meter': Icons.gas_meter,
      'baby_changing_station': Icons.baby_changing_station,
      'celebration': Icons.celebration,
      'card_travel': Icons.card_travel,
    };
    return iconMap[iconName] ?? Icons.category;
  }
}

/// 分类选择对话框
class CategoryPickerDialog extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;

  const CategoryPickerDialog({
    super.key,
    required this.categories,
    this.selectedCategory,
  });

  static Future<Category?> show(
    BuildContext context, {
    required List<Category> categories,
    Category? selectedCategory,
  }) async {
    return showModalBottomSheet<Category>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CategoryPickerDialog(
        categories: categories,
        selectedCategory: selectedCategory,
      ),
    );
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
                    '选择分类',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category.id == selectedCategory?.id;

                  return InkWell(
                    onTap: () => Navigator.pop(context, category),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(category.color)
                                : Color(category.color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getIconData(category.icon),
                            color: isSelected
                                ? Colors.white
                                : Color(category.color),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
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
