/// 依赖注入配置
/// 集中管理所有 Provider 的导出

// 数据库
export '../data/sources/local/database.dart';

// 数据模型
export '../data/models/book.dart';
export '../data/models/member.dart';
export '../data/models/category.dart';
export '../data/models/record.dart';
export '../data/models/split.dart';

// 仓库
export '../data/repositories/book_repository.dart';
export '../data/repositories/member_repository.dart';
export '../data/repositories/category_repository.dart';
export '../data/repositories/record_repository.dart';
export '../data/repositories/split_repository.dart';

// 状态管理
export '../presentation/providers/database_provider.dart';
export '../presentation/providers/books_provider.dart';
export '../presentation/providers/members_provider.dart';
export '../presentation/providers/categories_provider.dart';
export '../presentation/providers/records_provider.dart';
export '../presentation/providers/splits_provider.dart';
export '../presentation/providers/statistics_provider.dart';
export '../presentation/providers/current_book_provider.dart';
