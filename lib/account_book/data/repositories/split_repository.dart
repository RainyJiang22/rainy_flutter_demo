import '../sources/local/database.dart';
import '../sources/local/splits_dao.dart';
import '../models/split.dart';

/// 分摊仓库
class SplitRepository {
  final SplitsDao _dao;

  SplitRepository(DatabaseHelper dbHelper) : _dao = SplitsDao(dbHelper);

  /// 创建分摊
  Future<Split> create(Split split) async {
    await _dao.insert(split);
    return split;
  }

  /// 批量创建分摊
  Future<void> createAll(List<Split> splits) async {
    await _dao.insertAll(splits);
  }

  /// 删除分摊
  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  /// 删除记录的所有分摊
  Future<void> deleteByRecordId(String recordId) async {
    await _dao.deleteByRecordId(recordId);
  }

  /// 获取记录的所有分摊
  Future<List<Split>> getByRecordId(String recordId) async {
    return _dao.getByRecordId(recordId);
  }

  /// 获取成员的所有分摊
  Future<List<Split>> getByMemberId(String memberId) async {
    return _dao.getByMemberId(memberId);
  }

  /// 统计成员的分摊总额
  Future<double> sumByMemberId(String memberId) async {
    return _dao.sumByMemberId(memberId);
  }
}
