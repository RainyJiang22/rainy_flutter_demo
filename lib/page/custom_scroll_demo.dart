import 'package:flutter/material.dart';

class CustomScrollDemo extends StatelessWidget {
  const CustomScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CustomScroll Demo')),
      body: buildTwoSliverList(),
    );
  }

  Widget buildTwoListView() {
    var listView = ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text('$index'));
      },
    );
    return Column(
      children: [
        Expanded(child: listView),
        Divider(color: Colors.grey),
        Expanded(child: listView)
      ],
    );
  }

  Widget buildTwoSliverList() {
    // SliverFixedExtentList 是一个 Sliver，它可以生成高度相同的列表项。
    // 再次提醒，如果列表项高度相同，我们应该优先使用SliverFixedExtentList
    // 和 SliverPrototypeExtentList，如果不同，使用 SliverList.
    var listView = SliverFixedExtentList(
      itemExtent: 56, //列表项高度固定
      delegate: SliverChildBuilderDelegate(
            (_, index) => ListTile(title: Text('$index')),
        childCount: 10,
      ),
    );
    // 使用
    return CustomScrollView(
      slivers: [
        listView,
        listView,
      ],
    );
  }
}
