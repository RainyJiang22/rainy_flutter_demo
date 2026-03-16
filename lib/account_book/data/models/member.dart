/// 成员模型
class Member {
  final String id;
  final String bookId;
  final String name;
  final String? avatar;
  final String? phone;
  final String? email;

  const Member({
    required this.id,
    required this.bookId,
    required this.name,
    this.avatar,
    this.phone,
    this.email,
  });

  /// 从数据库 Map 创建
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] as String,
      bookId: map['book_id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
    );
  }

  /// 转换为数据库 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'email': email,
    };
  }

  /// 复制并修改
  Member copyWith({
    String? id,
    String? bookId,
    String? name,
    String? avatar,
    String? phone,
    String? email,
  }) {
    return Member(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'Member(id: $id, name: $name, bookId: $bookId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Member && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
