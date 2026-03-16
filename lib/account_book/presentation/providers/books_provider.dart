import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';
import 'database_provider.dart';

/// 账本列表状态
class BooksState {
  final List<Book> books;
  final bool isLoading;
  final String? error;

  const BooksState({
    this.books = const [],
    this.isLoading = false,
    this.error,
  });

  BooksState copyWith({
    List<Book>? books,
    bool? isLoading,
    String? error,
  }) {
    return BooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 账本列表 Notifier
class BooksNotifier extends StateNotifier<BooksState> {
  final BookRepository _repository;

  BooksNotifier(this._repository) : super(const BooksState()) {
    load();
  }

  /// 加载账本列表
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final books = await _repository.getActive();
      state = state.copyWith(books: books, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 创建账本
  Future<Book?> create(Book book) async {
    try {
      final newBook = await _repository.create(book);
      await load();
      return newBook;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 更新账本
  Future<bool> update(Book book) async {
    try {
      await _repository.update(book);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 删除账本
  Future<bool> delete(String id) async {
    try {
      await _repository.delete(id);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 归档账本
  Future<bool> archive(String id) async {
    try {
      await _repository.archive(id);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// 账本列表 Provider
final booksProvider =
    StateNotifierProvider<BooksNotifier, BooksState>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return BooksNotifier(repository);
});

/// 获取所有账本（包括归档）
final allBooksProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getAll();
});
