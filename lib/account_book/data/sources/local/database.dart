import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 数据库帮助类
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// 数据库名称
  static const String _databaseName = 'account_book.db';

  /// 数据库版本
  static const int _databaseVersion = 1;

  /// 表名
  static const String tableBooks = 'books';
  static const String tableMembers = 'members';
  static const String tableCategories = 'categories';
  static const String tableRecords = 'records';
  static const String tableSplits = 'splits';

  /// 获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 创建表
  Future<void> _onCreate(Database db, int version) async {
    // 账本表
    await db.execute('''
      CREATE TABLE $tableBooks (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type INTEGER NOT NULL,
        icon TEXT NOT NULL,
        color INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        is_archived INTEGER DEFAULT 0
      )
    ''');

    // 成员表
    await db.execute('''
      CREATE TABLE $tableMembers (
        id TEXT PRIMARY KEY,
        book_id TEXT NOT NULL,
        name TEXT NOT NULL,
        avatar TEXT,
        phone TEXT,
        email TEXT,
        FOREIGN KEY (book_id) REFERENCES $tableBooks(id)
      )
    ''');

    // 分类表
    await db.execute('''
      CREATE TABLE $tableCategories (
        id TEXT PRIMARY KEY,
        book_id TEXT,
        name TEXT NOT NULL,
        type INTEGER NOT NULL,
        icon TEXT NOT NULL,
        color INTEGER NOT NULL,
        sort_order INTEGER DEFAULT 0,
        is_default INTEGER DEFAULT 0,
        FOREIGN KEY (book_id) REFERENCES $tableBooks(id)
      )
    ''');

    // 记录表
    await db.execute('''
      CREATE TABLE $tableRecords (
        id TEXT PRIMARY KEY,
        book_id TEXT NOT NULL,
        amount REAL NOT NULL,
        type INTEGER NOT NULL,
        category_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        note TEXT,
        payer_id TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (book_id) REFERENCES $tableBooks(id),
        FOREIGN KEY (category_id) REFERENCES $tableCategories(id),
        FOREIGN KEY (payer_id) REFERENCES $tableMembers(id)
      )
    ''');

    // 分摊表
    await db.execute('''
      CREATE TABLE $tableSplits (
        id TEXT PRIMARY KEY,
        record_id TEXT NOT NULL,
        member_id TEXT NOT NULL,
        amount REAL NOT NULL,
        split_type INTEGER NOT NULL,
        ratio REAL,
        FOREIGN KEY (record_id) REFERENCES $tableRecords(id),
        FOREIGN KEY (member_id) REFERENCES $tableMembers(id)
      )
    ''');

    // 创建索引
    await db.execute(
      'CREATE INDEX idx_records_book_date ON $tableRecords(book_id, date)',
    );
    await db.execute(
      'CREATE INDEX idx_records_category ON $tableRecords(category_id)',
    );
    await db.execute(
      'CREATE INDEX idx_splits_record ON $tableSplits(record_id)',
    );
    await db.execute(
      'CREATE INDEX idx_members_book ON $tableMembers(book_id)',
    );
    await db.execute(
      'CREATE INDEX idx_categories_book ON $tableCategories(book_id)',
    );
  }

  /// 数据库升级
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 未来版本升级逻辑
  }

  /// 关闭数据库
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// 清空所有数据（用于测试）
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableSplits);
    await db.delete(tableRecords);
    await db.delete(tableCategories);
    await db.delete(tableMembers);
    await db.delete(tableBooks);
  }
}
