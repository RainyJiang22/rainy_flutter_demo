/// 账本类型枚举
enum BookType {
  main(0, '主账本'),
  sub(1, '子账本');

  final int value;
  final String label;

  const BookType(this.value, this.label);

  static BookType fromValue(int value) {
    return BookType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookType.main,
    );
  }
}

/// 账本模型
class Book {
  final String id;
  final String name;
  final BookType type;
  final String icon;
  final int color;
  final DateTime createdAt;
  final bool isArchived;

  const Book({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.createdAt,
    this.isArchived = false,
  });

  /// 从数据库 Map 创建
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      name: map['name'] as String,
      type: BookType.fromValue(map['type'] as int),
      icon: map['icon'] as String,
      color: map['color'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      isArchived: (map['is_archived'] as int) == 1,
    );
  }

  /// 转换为数据库 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.value,
      'icon': icon,
      'color': color,
      'created_at': createdAt.millisecondsSinceEpoch,
      'is_archived': isArchived ? 1 : 0,
    };
  }

  /// 复制并修改
  Book copyWith({
    String? id,
    String? name,
    BookType? type,
    String? icon,
    int? color,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, name: $name, type: $type, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
