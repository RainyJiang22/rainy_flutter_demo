import 'package:sqflite/sqflite.dart';

import 'database.dart';
import '../../models/record.dart';
import '../../models/category.dart';
import '../../models/member.dart';
import '../../models/split.dart';

/// 记录数据访问对象
class RecordsDao {
  final DatabaseHelper _dbHelper;

  RecordsDao(this._dbHelper);

  /// 插入记录
  Future<void> insert(Record record) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableRecords,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 更新记录
  Future<void> update(Record record) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableRecords,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  /// 删除记录
  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    // 先删除关联的分摊数据
    await db.delete(
      DatabaseHelper.tableSplits,
      where: 'record_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseHelper.tableRecords,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 根据 ID 获取记录
  Future<Record?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableRecords,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Record.fromMap(maps.first);
  }

  /// 获取记录详情
  Future<RecordDetail?> getDetailById(String id) async {
    final record = await getById(id);
    if (record == null) return null;

    final db = await _dbHelper.database;

    // 获取分类
    final categoryMaps = await db.query(
      DatabaseHelper.tableCategories,
      where: 'id = ?',
      whereArgs: [record.categoryId],
    );
    if (categoryMaps.isEmpty) return null;
    final category = Category.fromMap(categoryMaps.first);

    // 获取垫付人
    Member? payer;
    if (record.payerId != null) {
      final payerMaps = await db.query(
        DatabaseHelper.tableMembers,
        where: 'id = ?',
        whereArgs: [record.payerId],
      );
      if (payerMaps.isNotEmpty) {
        payer = Member.fromMap(payerMaps.first);
      }
    }

    // 获取分摊详情
    final splitMaps = await db.rawQuery('''
      SELECT s.*, m.id as member_id, m.name as member_name, m.avatar, m.phone, m.email
      FROM ${DatabaseHelper.tableSplits} s
      LEFT JOIN ${DatabaseHelper.tableMembers} m ON s.member_id = m.id
      WHERE s.record_id = ?
    ''', [id]);

    final splitDetails = splitMaps.map((map) {
      final split = Split.fromMap(map);
      final member = Member(
        id: map['member_id'] as String,
        bookId: '',
        name: map['member_name'] as String,
        avatar: map['avatar'] as String?,
        phone: map['phone'] as String?,
        email: map['email'] as String?,
      );
      return SplitDetail(split: split, member: member);
    }).toList();

    return RecordDetail(
      record: record,
      category: category,
      payer: payer,
      splitDetails: splitDetails,
    );
  }

  /// 获取账本的记录列表
  Future<List<Record>> getByBookId(
    String bookId, {
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String where = 'book_id = ?';
    List<dynamic> whereArgs = [bookId];

    if (startDate != null) {
      where += ' AND date >= ?';
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }
    if (endDate != null) {
      where += ' AND date <= ?';
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    final maps = await db.query(
      DatabaseHelper.tableRecords,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date DESC, created_at DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Record.fromMap(map)).toList();
  }

  /// 获取账本记录详情列表
  Future<List<RecordDetail>> getDetailsByBookId(
    String bookId, {
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await getByBookId(
      bookId,
      limit: limit,
      offset: offset,
      startDate: startDate,
      endDate: endDate,
    );

    final details = <RecordDetail>[];
    for (final record in records) {
      final detail = await getDetailById(record.id);
      if (detail != null) {
        details.add(detail);
      }
    }
    return details;
  }

  /// 获取指定日期的记录
  Future<List<Record>> getByDate(String bookId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getByBookId(
      bookId,
      startDate: startOfDay,
      endDate: endOfDay.subtract(const Duration(milliseconds: 1)),
    );
  }

  /// 统计金额
  Future<double> sumByBookId(
    String bookId,
    RecordType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String where = 'book_id = ? AND type = ?';
    List<dynamic> whereArgs = [bookId, type.value];

    if (startDate != null) {
      where += ' AND date >= ?';
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }
    if (endDate != null) {
      where += ' AND date <= ?';
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${DatabaseHelper.tableRecords} WHERE $where',
      whereArgs,
    );

    return (result.first['total'] as double?) ?? 0;
  }

  /// 按分类统计
  Future<List<Map<String, dynamic>>> sumByCategory(
    String bookId,
    RecordType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String where = 'r.book_id = ? AND r.type = ?';
    List<dynamic> whereArgs = [bookId, type.value];

    if (startDate != null) {
      where += ' AND r.date >= ?';
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }
    if (endDate != null) {
      where += ' AND r.date <= ?';
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    final result = await db.rawQuery('''
      SELECT r.category_id, c.name, c.icon, c.color, SUM(r.amount) as total
      FROM ${DatabaseHelper.tableRecords} r
      LEFT JOIN ${DatabaseHelper.tableCategories} c ON r.category_id = c.id
      WHERE $where
      GROUP BY r.category_id
      ORDER BY total DESC
    ''', whereArgs);

    return result;
  }

  /// 按日期统计
  Future<List<Map<String, dynamic>>> sumByDate(
    String bookId,
    RecordType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String where = 'book_id = ? AND type = ?';
    List<dynamic> whereArgs = [bookId, type.value];

    if (startDate != null) {
      where += ' AND date >= ?';
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }
    if (endDate != null) {
      where += ' AND date <= ?';
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    final result = await db.rawQuery('''
      SELECT date(date / 1000, 'unixepoch', 'localtime') as day, SUM(amount) as total
      FROM ${DatabaseHelper.tableRecords}
      WHERE $where
      GROUP BY day
      ORDER BY day ASC
    ''', whereArgs);

    return result;
  }
}
