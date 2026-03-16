import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/split.dart';
import '../../data/repositories/split_repository.dart';
import 'database_provider.dart';

/// 分摊列表状态
class SplitsState {
  final List<Split> splits;
  final bool isLoading;
  final String? error;

  const SplitsState({
    this.splits = const [],
    this.isLoading = false,
    this.error,
  });

  SplitsState copyWith({
    List<Split>? splits,
    bool? isLoading,
    String? error,
  }) {
    return SplitsState(
      splits: splits ?? this.splits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 分摊列表 Notifier
class SplitsNotifier extends StateNotifier<SplitsState> {
  final SplitRepository _repository;

  SplitsNotifier(this._repository) : super(const SplitsState());

  /// 加载记录的分摊列表
  Future<void> loadByRecordId(String recordId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final splits = await _repository.getByRecordId(recordId);
      state = state.copyWith(splits: splits, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 加载成员的分摊列表
  Future<void> loadByMemberId(String memberId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final splits = await _repository.getByMemberId(memberId);
      state = state.copyWith(splits: splits, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 创建分摊
  Future<Split?> create(Split split) async {
    try {
      final newSplit = await _repository.create(split);
      state = state.copyWith(splits: [...state.splits, newSplit]);
      return newSplit;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 批量创建分摊
  Future<bool> createAll(List<Split> splits) async {
    try {
      await _repository.createAll(splits);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 删除分摊
  Future<bool> delete(String id) async {
    try {
      await _repository.delete(id);
      state = state.copyWith(
        splits: state.splits.where((s) => s.id != id).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// 分摊 Provider
final splitsProvider =
    StateNotifierProvider<SplitsNotifier, SplitsState>((ref) {
  final repository = ref.watch(splitRepositoryProvider);
  return SplitsNotifier(repository);
});

/// 记录分摊 Provider
final recordSplitsProvider =
    FutureProvider.family<List<Split>, String>((ref, recordId) async {
  final repository = ref.watch(splitRepositoryProvider);
  return repository.getByRecordId(recordId);
});

/// 成员分摊 Provider
final memberSplitsProvider =
    FutureProvider.family<List<Split>, String>((ref, memberId) async {
  final repository = ref.watch(splitRepositoryProvider);
  return repository.getByMemberId(memberId);
});

/// 成员分摊总额 Provider
final memberSplitSumProvider =
    FutureProvider.family<double, String>((ref, memberId) async {
  final repository = ref.watch(splitRepositoryProvider);
  return repository.sumByMemberId(memberId);
});
