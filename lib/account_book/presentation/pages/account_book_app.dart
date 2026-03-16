import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../providers/current_book_provider.dart';
import '../providers/categories_provider.dart';
import 'dashboard_page.dart';
import 'statistics_page.dart';
import 'profile_page.dart';
import '../widgets/quick_record_sheet.dart';

/// 记账本主页面
class AccountBookHomePage extends ConsumerStatefulWidget {
  const AccountBookHomePage({super.key});

  @override
  ConsumerState<AccountBookHomePage> createState() => _AccountBookHomePageState();
}

class _AccountBookHomePageState extends ConsumerState<AccountBookHomePage> {
  int _currentIndex = 0;
  bool _localeInitialized = false;

  final List<Widget> _pages = const [
    DashboardPage(),
    StatisticsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // 初始化日期格式化 locale 数据
    _initLocale();
  }

  Future<void> _initLocale() async {
    await initializeDateFormatting('zh_CN', null);
    if (mounted) {
      setState(() => _localeInitialized = true);
    }
    // 初始化默认分类
    Future.microtask(() {
      ref.read(categoriesProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentBook = ref.watch(currentBookProvider);

    // 在 locale 初始化完成前显示加载状态
    if (!_localeInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
      floatingActionButton: currentBook != null
          ? FloatingActionButton(
              onPressed: () => QuickRecordSheet.show(context),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
