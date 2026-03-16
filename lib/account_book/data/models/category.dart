/// 分类类型枚举
enum CategoryType {
  expense(0, '支出'),
  income(1, '收入');

  final int value;
  final String label;

  const CategoryType(this.value, this.label);

  static CategoryType fromValue(int value) {
    return CategoryType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CategoryType.expense,
    );
  }
}

/// 分类模型
class Category {
  final String id;
  final String? bookId;
  final String name;
  final CategoryType type;
  final String icon;
  final int color;
  final int sortOrder;
  final bool isDefault;

  const Category({
    required this.id,
    this.bookId,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.sortOrder = 0,
    this.isDefault = false,
  });

  /// 从数据库 Map 创建
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      bookId: map['book_id'] as String?,
      name: map['name'] as String,
      type: CategoryType.fromValue(map['type'] as int),
      icon: map['icon'] as String,
      color: map['color'] as int,
      sortOrder: map['sort_order'] as int? ?? 0,
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }

  /// 转换为数据库 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'name': name,
      'type': type.value,
      'icon': icon,
      'color': color,
      'sort_order': sortOrder,
      'is_default': isDefault ? 1 : 0,
    };
  }

  /// 复制并修改
  Category copyWith({
    String? id,
    String? bookId,
    String? name,
    CategoryType? type,
    String? icon,
    int? color,
    int? sortOrder,
    bool? isDefault,
  }) {
    return Category(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
