import '../sources/local/database.dart';
import '../sources/local/categories_dao.dart';
import '../models/category.dart';
import 'package:uuid/uuid.dart';

/// 分类仓库
class CategoryRepository {
  final CategoriesDao _dao;
  final Uuid _uuid;

  CategoryRepository(DatabaseHelper dbHelper)
      : _dao = CategoriesDao(dbHelper),
        _uuid = const Uuid();

  /// 创建分类
  Future<Category> create(Category category) async {
    await _dao.insert(category);
    return category;
  }

  /// 更新分类
  Future<void> update(Category category) async {
    await _dao.update(category);
  }

  /// 删除分类
  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  /// 根据 ID 获取分类
  Future<Category?> getById(String id) async {
    return _dao.getById(id);
  }

  /// 获取账本的所有分类（包括默认分类）
  Future<List<Category>> getByBookId(String? bookId) async {
    return _dao.getByBookId(bookId);
  }

  /// 获取指定类型的分类
  Future<List<Category>> getByType(String? bookId, CategoryType type) async {
    return _dao.getByType(bookId, type);
  }

  /// 更新排序
  Future<void> updateSortOrder(String id, int sortOrder) async {
    await _dao.updateSortOrder(id, sortOrder);
  }

  /// 检查分类名称是否存在
  Future<bool> nameExists(String? bookId, String name, CategoryType type) async {
    return _dao.nameExists(bookId, name, type);
  }

  /// 初始化默认分类
  Future<void> initDefaultCategories() async {
    final existing = await _dao.getDefaultCategories();
    if (existing.isNotEmpty) return;

    final defaultCategories = _getDefaultCategories();
    await _dao.insertAll(defaultCategories);
  }

  /// 获取默认分类列表
  List<Category> _getDefaultCategories() {
    final now = DateTime.now();
    return [
      // 支出分类
      Category(
        id: _uuid.v4(),
        name: '餐饮',
        type: CategoryType.expense,
        icon: 'restaurant',
        color: 0xFFFF9800,
        sortOrder: 0,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '交通',
        type: CategoryType.expense,
        icon: 'directions_car',
        color: 0xFF2196F3,
        sortOrder: 1,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '购物',
        type: CategoryType.expense,
        icon: 'shopping_cart',
        color: 0xFFE91E63,
        sortOrder: 2,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '娱乐',
        type: CategoryType.expense,
        icon: 'sports_esports',
        color: 0xFF9C27B0,
        sortOrder: 3,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '居住',
        type: CategoryType.expense,
        icon: 'home',
        color: 0xFF795548,
        sortOrder: 4,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '医疗',
        type: CategoryType.expense,
        icon: 'local_hospital',
        color: 0xFFF44336,
        sortOrder: 5,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '教育',
        type: CategoryType.expense,
        icon: 'school',
        color: 0xFF00BCD4,
        sortOrder: 6,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '其他支出',
        type: CategoryType.expense,
        icon: 'more_horiz',
        color: 0xFF607D8B,
        sortOrder: 7,
        isDefault: true,
      ),
      // 收入分类
      Category(
        id: _uuid.v4(),
        name: '工资',
        type: CategoryType.income,
        icon: 'account_balance_wallet',
        color: 0xFF4CAF50,
        sortOrder: 0,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '奖金',
        type: CategoryType.income,
        icon: 'card_giftcard',
        color: 0xFFFFC107,
        sortOrder: 1,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '投资收益',
        type: CategoryType.income,
        icon: 'trending_up',
        color: 0xFF009688,
        sortOrder: 2,
        isDefault: true,
      ),
      Category(
        id: _uuid.v4(),
        name: '其他收入',
        type: CategoryType.income,
        icon: 'more_horiz',
        color: 0xFF8BC34A,
        sortOrder: 3,
        isDefault: true,
      ),
    ];
  }
}
