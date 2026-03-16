import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/category.dart';
import '../../data/repositories/category_repository.dart';
import 'database_provider.dart';
import 'current_book_provider.dart';

/// 分类列表状态
class CategoriesState {
  final List<Category> categories;
  final bool isLoading;
  final String? error;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 分类列表 Notifier
class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final CategoryRepository _repository;
  final String? _bookId;

  CategoriesNotifier(this._repository, this._bookId) : super(const CategoriesState()) {
    _init();
  }

  Future<void> _init() async {
    // 初始化默认分类
    await _repository.initDefaultCategories();
    if (_bookId != null) {
      await load(_bookId);
    }
  }

  /// 加载分类列表
  Future<void> load(String bookId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final categories = await _repository.getByBookId(bookId);
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 创建分类
  Future<Category?> create(Category category) async {
    try {
      final newCategory = await _repository.create(category);
      await load(category.bookId ?? '');
      return newCategory;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 更新分类
  Future<bool> update(Category category) async {
    try {
      await _repository.update(category);
      await load(category.bookId ?? '');
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 删除分类
  Future<bool> delete(String id, String? bookId) async {
    try {
      await _repository.delete(id);
      await load(bookId ?? '');
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// 当前账本分类 Provider
final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  final currentBook = ref.watch(currentBookProvider);
  return CategoriesNotifier(repository, currentBook?.id);
});

/// 支出分类 Provider
final expenseCategoriesProvider = Provider<List<Category>>((ref) {
  final state = ref.watch(categoriesProvider);
  return state.categories.where((c) => c.type == CategoryType.expense).toList();
});

/// 收入分类 Provider
final incomeCategoriesProvider = Provider<List<Category>>((ref) {
  final state = ref.watch(categoriesProvider);
  return state.categories.where((c) => c.type == CategoryType.income).toList();
});

/// 指定账本分类 Provider
final bookCategoriesProvider =
    FutureProvider.family<List<Category>, String>((ref, bookId) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getByBookId(bookId);
});
