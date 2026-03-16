import '../sources/local/database.dart';
import '../sources/local/records_dao.dart';
import '../sources/local/splits_dao.dart';
import '../models/record.dart';

/// 记录仓库
class RecordRepository {
  final RecordsDao _recordsDao;
  final SplitsDao _splitsDao;

  RecordRepository(DatabaseHelper dbHelper)
      : _recordsDao = RecordsDao(dbHelper),
        _splitsDao = SplitsDao(dbHelper);

  /// 创建记录
  Future<Record> create(Record record, {List<dynamic>? splits}) async {
    await _recordsDao.insert(record);
    if (splits != null && splits.isNotEmpty) {
      for (final split in splits) {
        await _splitsDao.insert(split as dynamic);
      }
    }
    return record;
  }

  /// 更新记录
  Future<void> update(Record record, {List<dynamic>? splits}) async {
    await _recordsDao.update(record);
    // 先删除旧的分摊数据
    await _splitsDao.deleteByRecordId(record.id);
    // 插入新的分摊数据
    if (splits != null && splits.isNotEmpty) {
      for (final split in splits) {
        await _splitsDao.insert(split as dynamic);
      }
    }
  }

  /// 删除记录
  Future<void> delete(String id) async {
    await _recordsDao.delete(id);
  }

  /// 根据 ID 获取记录
  Future<Record?> getById(String id) async {
    return _recordsDao.getById(id);
  }

  /// 获取记录详情
  Future<RecordDetail?> getDetailById(String id) async {
    return _recordsDao.getDetailById(id);
  }

  /// 获取账本的记录列表
  Future<List<Record>> getByBookId(
    String bookId, {
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _recordsDao.getByBookId(
      bookId,
      limit: limit,
      offset: offset,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 获取账本记录详情列表
  Future<List<RecordDetail>> getDetailsByBookId(
    String bookId, {
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _recordsDao.getDetailsByBookId(
      bookId,
      limit: limit,
      offset: offset,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 获取指定日期的记录
  Future<List<Record>> getByDate(String bookId, DateTime date) async {
    return _recordsDao.getByDate(bookId, date);
  }

  /// 统计金额
  Future<double> sumByBookId(
    String bookId,
    RecordType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _recordsDao.sumByBookId(
      bookId,
      type,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 按分类统计
  Future<List<Map<String, dynamic>>> sumByCategory(
    String bookId,
    RecordType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _recordsDao.sumByCategory(
      bookId,
      type,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 按日期统计
  Future<List<Map<String, dynamic>>> sumByDate(
    String bookId,
    RecordType type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _recordsDao.sumByDate(
      bookId,
      type,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
