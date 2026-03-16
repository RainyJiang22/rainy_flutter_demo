import '../sources/local/database.dart';
import '../sources/local/members_dao.dart';
import '../models/member.dart';

/// 成员仓库
class MemberRepository {
  final MembersDao _dao;

  MemberRepository(DatabaseHelper dbHelper) : _dao = MembersDao(dbHelper);

  /// 创建成员
  Future<Member> create(Member member) async {
    await _dao.insert(member);
    return member;
  }

  /// 批量创建成员
  Future<void> createAll(List<Member> members) async {
    await _dao.insertAll(members);
  }

  /// 更新成员
  Future<void> update(Member member) async {
    await _dao.update(member);
  }

  /// 删除成员
  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  /// 根据 ID 获取成员
  Future<Member?> getById(String id) async {
    return _dao.getById(id);
  }

  /// 获取账本的所有成员
  Future<List<Member>> getByBookId(String bookId) async {
    return _dao.getByBookId(bookId);
  }

  /// 检查成员名称是否存在
  Future<bool> nameExists(String bookId, String name) async {
    return _dao.nameExists(bookId, name);
  }

  /// 统计账本成员数量
  Future<int> countByBookId(String bookId) async {
    return _dao.countByBookId(bookId);
  }
}
