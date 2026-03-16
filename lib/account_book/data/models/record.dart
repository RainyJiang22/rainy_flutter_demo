import 'category.dart';
import 'member.dart';
import 'split.dart';

/// 记录类型枚举
enum RecordType {
  expense(0, '支出'),
  income(1, '收入');

  final int value;
  final String label;

  const RecordType(this.value, this.label);

  static RecordType fromValue(int value) {
    return RecordType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RecordType.expense,
    );
  }
}

/// 记账记录模型
class Record {
  final String id;
  final String bookId;
  final double amount;
  final RecordType type;
  final String categoryId;
  final DateTime date;
  final String? note;
  final String? payerId;
  final DateTime createdAt;
  final List<Split>? splits;

  const Record({
    required this.id,
    required this.bookId,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
    this.payerId,
    required this.createdAt,
    this.splits,
  });

  /// 从数据库 Map 创建
  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'] as String,
      bookId: map['book_id'] as String,
      amount: map['amount'] as double,
      type: RecordType.fromValue(map['type'] as int),
      categoryId: map['category_id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      note: map['note'] as String?,
      payerId: map['payer_id'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  /// 转换为数据库 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'amount': amount,
      'type': type.value,
      'category_id': categoryId,
      'date': date.millisecondsSinceEpoch,
      'note': note,
      'payer_id': payerId,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// 复制并修改
  Record copyWith({
    String? id,
    String? bookId,
    double? amount,
    RecordType? type,
    String? categoryId,
    DateTime? date,
    String? note,
    String? payerId,
    DateTime? createdAt,
    List<Split>? splits,
  }) {
    return Record(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      payerId: payerId ?? this.payerId,
      createdAt: createdAt ?? this.createdAt,
      splits: splits ?? this.splits,
    );
  }

  /// 是否有分摊
  bool get hasSplit => splits != null && splits!.isNotEmpty;

  @override
  String toString() {
    return 'Record(id: $id, amount: $amount, type: $type, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Record && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 记录详情（包含关联信息）
class RecordDetail {
  final Record record;
  final Category category;
  final Member? payer;
  final List<SplitDetail> splitDetails;

  const RecordDetail({
    required this.record,
    required this.category,
    this.payer,
    this.splitDetails = const [],
  });

  /// 是否有分摊
  bool get hasSplit => splitDetails.isNotEmpty;
}

/// 分摊详情（包含成员信息）
class SplitDetail {
  final Split split;
  final Member member;

  const SplitDetail({
    required this.split,
    required this.member,
  });
}
