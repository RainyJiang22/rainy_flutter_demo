import 'package:flutter/material.dart';

class JuejinPageDemo extends StatelessWidget {
  const JuejinPageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [SearchBarWidget(), ContentWidget(), BottomBarWidget()]
        ),
      ),
    );
  }
}

//顶部搜索栏
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.0),
              ),

              child: Row(
                children: [
                  //搜索图标
                  Icon(Icons.search, color: Color(0xFF8C8D92)),
                  SizedBox(width: 8.0),
                  Text(
                    "搜索稀土掘金",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF8C8D92), // 设置字体颜色
                      decoration: TextDecoration.none, // 设置不显示下划线
                      fontWeight: FontWeight.normal,
                    ), // 设置字体不要加粗
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Icon(Icons.assistant_photo),
        ],
      ),
    );
  }
}

//中间列表
class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> tabStrList = [
    '关注',
    '推荐',
    '热榜',
    '头条',
    '后端',
    '前端',
    'Android',
    'iOS',
    '人工智能',
    '开发工具',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabStrList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: tabStrList.map((tabText) => Tab(text: tabText)).toList(),
            ),
            //需要和TabBar同时使用
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabStrList
                    .map((tabText) => ContentListWidget())
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//简单内容列表
class ContentListWidget extends StatelessWidget {
  const ContentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '一起学习flutter',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 4),
                  Text(
                    "RainyJiang",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  "testtesttessssssssssssssssssssssssssssssssssssssssssssssss",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline),
                  const Text('999+'),
                  const SizedBox(width: 18),
                  const Icon(Icons.keyboard_voice),
                  const Text('999+'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text(
                      'Flutter',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Icon(Icons.more_vert),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Color(0xFFF3F4F6), thickness: 8.0);
      },
      itemCount: 20,
    );
  }
}

//底部导航栏 BottomNavigationBar+BottomNavigationBarItem来实现
class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    int _position = 0;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (position) {
        setState(() {
          _position = position;
        });
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _position,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
        BottomNavigationBarItem(icon: Icon(Icons.whatshot), label: '沸点'),
        BottomNavigationBarItem(icon: Icon(Icons.zoom_out), label: '发现'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: '课程'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: '我'),
      ],
    );
  }
}
