import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/record.dart';
import '../../data/models/split.dart';
import '../../data/repositories/record_repository.dart';
import 'database_provider.dart';
import 'current_book_provider.dart';

/// 记录列表状态
class RecordsState {
  final List<RecordDetail> records;
  final bool isLoading;
  final String? error;

  const RecordsState({
    this.records = const [],
    this.isLoading = false,
    this.error,
  });

  RecordsState copyWith({
    List<RecordDetail>? records,
    bool? isLoading,
    String? error,
  }) {
    return RecordsState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 记录列表 Notifier
class RecordsNotifier extends StateNotifier<RecordsState> {
  final RecordRepository _repository;
  final String? _bookId;
  final Uuid _uuid;

  RecordsNotifier(this._repository, this._bookId)
      : _uuid = const Uuid(),
        super(const RecordsState()) {
    if (_bookId != null) {
      load(_bookId);
    }
  }

  /// 加载记录列表
  Future<void> load(String bookId, {int? limit}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final records = await _repository.getDetailsByBookId(
        bookId,
        limit: limit ?? 50,
      );
      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 创建记录
  Future<Record?> create({
    required String bookId,
    required double amount,
    required RecordType type,
    required String categoryId,
    required DateTime date,
    String? note,
    String? payerId,
    List<Split>? splits,
  }) async {
    try {
      final record = Record(
        id: _uuid.v4(),
        bookId: bookId,
        amount: amount,
        type: type,
        categoryId: categoryId,
        date: date,
        note: note,
        payerId: payerId,
        createdAt: DateTime.now(),
      );
      await _repository.create(record, splits: splits);
      await load(bookId);
      return record;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 更新记录
  Future<bool> update(Record record, {List<Split>? splits}) async {
    try {
      await _repository.update(record, splits: splits);
      await load(record.bookId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 删除记录
  Future<bool> delete(String id, String bookId) async {
    try {
      await _repository.delete(id);
      await load(bookId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// 当前账本记录 Provider
final recordsProvider =
    StateNotifierProvider<RecordsNotifier, RecordsState>((ref) {
  final repository = ref.watch(recordRepositoryProvider);
  final currentBook = ref.watch(currentBookProvider);
  return RecordsNotifier(repository, currentBook?.id);
});

/// 记录详情 Provider
final recordDetailProvider =
    FutureProvider.family<RecordDetail?, String>((ref, id) async {
  final repository = ref.watch(recordRepositoryProvider);
  return repository.getDetailById(id);
});

/// 指定日期范围的记录 Provider
final recordsByDateRangeProvider = FutureProvider.family<
    List<RecordDetail>, ({String bookId, DateTime start, DateTime end})>(
    (ref, params) async {
  final repository = ref.watch(recordRepositoryProvider);
  return repository.getDetailsByBookId(
    params.bookId,
    startDate: params.start,
    endDate: params.end,
  );
});
