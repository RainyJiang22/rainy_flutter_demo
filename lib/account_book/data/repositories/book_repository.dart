import '../sources/local/database.dart';
import '../sources/local/books_dao.dart';
import '../models/book.dart';

/// 账本仓库
class BookRepository {
  final BooksDao _dao;

  BookRepository(DatabaseHelper dbHelper) : _dao = BooksDao(dbHelper);

  /// 创建账本
  Future<Book> create(Book book) async {
    await _dao.insert(book);
    return book;
  }

  /// 更新账本
  Future<void> update(Book book) async {
    await _dao.update(book);
  }

  /// 删除账本
  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  /// 根据 ID 获取账本
  Future<Book?> getById(String id) async {
    return _dao.getById(id);
  }

  /// 获取所有账本
  Future<List<Book>> getAll() async {
    return _dao.getAll();
  }

  /// 获取未归档的账本
  Future<List<Book>> getActive() async {
    return _dao.getActive();
  }

  /// 归档账本
  Future<void> archive(String id) async {
    await _dao.archive(id);
  }

  /// 取消归档
  Future<void> unarchive(String id) async {
    await _dao.unarchive(id);
  }

  /// 获取主账本
  Future<Book?> getMainBook() async {
    return _dao.getMainBook();
  }

  /// 确保有主账本
  Future<Book> ensureMainBook() async {
    var mainBook = await _dao.getMainBook();
    if (mainBook != null) return mainBook;

    // 创建默认主账本
    mainBook = Book(
      id: 'main_book',
      name: '默认账本',
      type: BookType.main,
      icon: 'account_balance_wallet',
      color: 0xFF009688,
      createdAt: DateTime.now(),
    );
    await _dao.insert(mainBook);
    return mainBook;
  }
}
