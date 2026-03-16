import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';
import 'database_provider.dart';
import 'books_provider.dart';

/// 当前选中账本 StateNotifier
class CurrentBookNotifier extends StateNotifier<Book?> {
  final BookRepository _repository;
  final Ref _ref;

  CurrentBookNotifier(this._repository, this._ref) : super(null) {
    _init();
  }

  Future<void> _init() async {
    // 确保有主账本
    final mainBook = await _repository.ensureMainBook();
    state = mainBook;
  }

  /// 切换账本
  Future<void> switchBook(Book book) async {
    state = book;
    // 刷新相关数据
    _ref.invalidate(booksProvider);
  }

  /// 刷新当前账本
  Future<void> refresh() async {
    if (state == null) return;
    final book = await _repository.getById(state!.id);
    state = book;
  }
}

/// 当前选中账本 Provider
final currentBookProvider =
    StateNotifierProvider<CurrentBookNotifier, Book?>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return CurrentBookNotifier(repository, ref);
});

/// 当前账本 ID Provider
final currentBookIdProvider = Provider<String?>((ref) {
  return ref.watch(currentBookProvider)?.id;
});
