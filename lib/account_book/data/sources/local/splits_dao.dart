import 'package:sqflite/sqflite.dart';

import 'database.dart';
import '../../models/split.dart';

/// 分摊数据访问对象
class SplitsDao {
  final DatabaseHelper _dbHelper;

  SplitsDao(this._dbHelper);

  /// 插入分摊
  Future<void> insert(Split split) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableSplits,
      split.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 批量插入分摊
  Future<void> insertAll(List<Split> splits) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final split in splits) {
      batch.insert(
        DatabaseHelper.tableSplits,
        split.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// 删除分摊
  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableSplits,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 删除记录的所有分摊
  Future<void> deleteByRecordId(String recordId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableSplits,
      where: 'record_id = ?',
      whereArgs: [recordId],
    );
  }

  /// 获取记录的所有分摊
  Future<List<Split>> getByRecordId(String recordId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSplits,
      where: 'record_id = ?',
      whereArgs: [recordId],
    );
    return maps.map((map) => Split.fromMap(map)).toList();
  }

  /// 获取成员的所有分摊
  Future<List<Split>> getByMemberId(String memberId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableSplits,
      where: 'member_id = ?',
      whereArgs: [memberId],
    );
    return maps.map((map) => Split.fromMap(map)).toList();
  }

  /// 统计成员的分摊总额
  Future<double> sumByMemberId(String memberId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM ${DatabaseHelper.tableSplits} WHERE member_id = ?',
      [memberId],
    );
    return (result.first['total'] as double?) ?? 0;
  }
}
