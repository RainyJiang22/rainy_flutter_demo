import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sources/local/database.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/member_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/record_repository.dart';
import '../../data/repositories/split_repository.dart';

/// 数据库实例 Provider
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

/// 账本仓库 Provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return BookRepository(dbHelper);
});

/// 成员仓库 Provider
final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return MemberRepository(dbHelper);
});

/// 分类仓库 Provider
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return CategoryRepository(dbHelper);
});

/// 记录仓库 Provider
final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return RecordRepository(dbHelper);
});

/// 分摊仓库 Provider
final splitRepositoryProvider = Provider<SplitRepository>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return SplitRepository(dbHelper);
});
