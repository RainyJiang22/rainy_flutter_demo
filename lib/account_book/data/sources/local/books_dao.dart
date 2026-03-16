import 'package:sqflite/sqflite.dart';

import 'database.dart';
import '../../models/book.dart';

/// 账本数据访问对象
class BooksDao {
  final DatabaseHelper _dbHelper;

  BooksDao(this._dbHelper);

  /// 插入账本
  Future<void> insert(Book book) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableBooks,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 更新账本
  Future<void> update(Book book) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableBooks,
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  /// 删除账本
  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    // 先删除关联数据
    await db.delete(
      DatabaseHelper.tableSplits,
      where: 'record_id IN (SELECT id FROM ${DatabaseHelper.tableRecords} WHERE book_id = ?)',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseHelper.tableRecords,
      where: 'book_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseHelper.tableCategories,
      where: 'book_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseHelper.tableMembers,
      where: 'book_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      DatabaseHelper.tableBooks,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 根据 ID 获取账本
  Future<Book?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableBooks,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Book.fromMap(maps.first);
  }

  /// 获取所有账本
  Future<List<Book>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableBooks,
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  /// 获取未归档的账本
  Future<List<Book>> getActive() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableBooks,
      where: 'is_archived = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  /// 归档账本
  Future<void> archive(String id) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableBooks,
      {'is_archived': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 取消归档
  Future<void> unarchive(String id) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableBooks,
      {'is_archived': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 获取主账本
  Future<Book?> getMainBook() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableBooks,
      where: 'type = ? AND is_archived = ?',
      whereArgs: [BookType.main.value, 0],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Book.fromMap(maps.first);
  }
}
