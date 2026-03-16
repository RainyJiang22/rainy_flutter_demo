import 'package:sqflite/sqflite.dart';

import 'database.dart';
import '../../models/member.dart';

/// 成员数据访问对象
class MembersDao {
  final DatabaseHelper _dbHelper;

  MembersDao(this._dbHelper);

  /// 插入成员
  Future<void> insert(Member member) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableMembers,
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 批量插入成员
  Future<void> insertAll(List<Member> members) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final member in members) {
      batch.insert(
        DatabaseHelper.tableMembers,
        member.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// 更新成员
  Future<void> update(Member member) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableMembers,
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  /// 删除成员
  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableMembers,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 根据 ID 获取成员
  Future<Member?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableMembers,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Member.fromMap(maps.first);
  }

  /// 获取账本的所有成员
  Future<List<Member>> getByBookId(String bookId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableMembers,
      where: 'book_id = ?',
      whereArgs: [bookId],
      orderBy: 'name ASC',
    );
    return maps.map((map) => Member.fromMap(map)).toList();
  }

  /// 检查成员名称是否存在
  Future<bool> nameExists(String bookId, String name) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableMembers,
      where: 'book_id = ? AND name = ?',
      whereArgs: [bookId, name],
    );
    return maps.isNotEmpty;
  }

  /// 统计账本成员数量
  Future<int> countByBookId(String bookId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.tableMembers} WHERE book_id = ?',
      [bookId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
