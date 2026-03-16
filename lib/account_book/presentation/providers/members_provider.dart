import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/member.dart';
import '../../data/repositories/member_repository.dart';
import 'database_provider.dart';
import 'current_book_provider.dart';

/// 成员列表状态
class MembersState {
  final List<Member> members;
  final bool isLoading;
  final String? error;

  const MembersState({
    this.members = const [],
    this.isLoading = false,
    this.error,
  });

  MembersState copyWith({
    List<Member>? members,
    bool? isLoading,
    String? error,
  }) {
    return MembersState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 成员列表 Notifier
class MembersNotifier extends StateNotifier<MembersState> {
  final MemberRepository _repository;
  final String? _bookId;

  MembersNotifier(this._repository, this._bookId) : super(const MembersState()) {
    if (_bookId != null) {
      load(_bookId);
    }
  }

  /// 加载成员列表
  Future<void> load(String bookId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final members = await _repository.getByBookId(bookId);
      state = state.copyWith(members: members, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 创建成员
  Future<Member?> create(Member member) async {
    try {
      final newMember = await _repository.create(member);
      await load(member.bookId);
      return newMember;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 更新成员
  Future<bool> update(Member member) async {
    try {
      await _repository.update(member);
      await load(member.bookId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 删除成员
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

/// 当前账本成员 Provider
final membersProvider =
    StateNotifierProvider<MembersNotifier, MembersState>((ref) {
  final repository = ref.watch(memberRepositoryProvider);
  final currentBook = ref.watch(currentBookProvider);
  return MembersNotifier(repository, currentBook?.id);
});

/// 指定账本成员 Provider
final bookMembersProvider =
    FutureProvider.family<List<Member>, String>((ref, bookId) async {
  final repository = ref.watch(memberRepositoryProvider);
  return repository.getByBookId(bookId);
});
