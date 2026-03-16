/// 分摊类型枚举
enum SplitType {
  equal(0, '平均分摊'),
  ratio(1, '按比例分摊'),
  fixed(2, '指定金额');

  final int value;
  final String label;

  const SplitType(this.value, this.label);

  static SplitType fromValue(int value) {
    return SplitType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SplitType.equal,
    );
  }
}

/// 分摊明细模型
class Split {
  final String id;
  final String recordId;
  final String memberId;
  final double amount;
  final SplitType splitType;
  final double? ratio;

  const Split({
    required this.id,
    required this.recordId,
    required this.memberId,
    required this.amount,
    required this.splitType,
    this.ratio,
  });

  /// 从数据库 Map 创建
  factory Split.fromMap(Map<String, dynamic> map) {
    return Split(
      id: map['id'] as String,
      recordId: map['record_id'] as String,
      memberId: map['member_id'] as String,
      amount: map['amount'] as double,
      splitType: SplitType.fromValue(map['split_type'] as int),
      ratio: map['ratio'] as double?,
    );
  }

  /// 转换为数据库 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'record_id': recordId,
      'member_id': memberId,
      'amount': amount,
      'split_type': splitType.value,
      'ratio': ratio,
    };
  }

  /// 复制并修改
  Split copyWith({
    String? id,
    String? recordId,
    String? memberId,
    double? amount,
    SplitType? splitType,
    double? ratio,
  }) {
    return Split(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      splitType: splitType ?? this.splitType,
      ratio: ratio ?? this.ratio,
    );
  }

  @override
  String toString() {
    return 'Split(id: $id, memberId: $memberId, amount: $amount, type: $splitType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Split && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
