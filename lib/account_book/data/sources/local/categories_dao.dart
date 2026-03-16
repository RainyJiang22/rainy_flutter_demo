import 'package:sqflite/sqflite.dart';

import 'database.dart';
import '../../models/category.dart';

/// 分类数据访问对象
class CategoriesDao {
  final DatabaseHelper _dbHelper;

  CategoriesDao(this._dbHelper);

  /// 插入分类
  Future<void> insert(Category category) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableCategories,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 批量插入分类
  Future<void> insertAll(List<Category> categories) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final category in categories) {
      batch.insert(
        DatabaseHelper.tableCategories,
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// 更新分类
  Future<void> update(Category category) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableCategories,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  /// 删除分类
  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 根据 ID 获取分类
  Future<Category?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Category.fromMap(maps.first);
  }

  /// 获取账本的所有分类（包括默认分类）
  Future<List<Category>> getByBookId(String? bookId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCategories,
      where: 'book_id = ? OR book_id IS NULL',
      whereArgs: [bookId],
      orderBy: 'sort_order ASC',
    );
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  /// 获取指定类型的分类
  Future<List<Category>> getByType(String? bookId, CategoryType type) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCategories,
      where: '(book_id = ? OR book_id IS NULL) AND type = ?',
      whereArgs: [bookId, type.value],
      orderBy: 'sort_order ASC',
    );
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  /// 获取默认分类
  Future<List<Category>> getDefaultCategories() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCategories,
      where: 'is_default = ?',
      whereArgs: [1],
      orderBy: 'type ASC, sort_order ASC',
    );
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  /// 更新排序
  Future<void> updateSortOrder(String id, int sortOrder) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableCategories,
      {'sort_order': sortOrder},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 检查分类名称是否存在
  Future<bool> nameExists(String? bookId, String name, CategoryType type) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCategories,
      where: '(book_id = ? OR book_id IS NULL) AND name = ? AND type = ?',
      whereArgs: [bookId, name, type.value],
    );
    return maps.isNotEmpty;
  }
}
