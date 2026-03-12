import 'package:first_flutter_demo/page/sliver_header_delegate.dart';
import 'package:flutter/material.dart';

class PresistentHeaderRoute extends StatefulWidget {
  const PresistentHeaderRoute({super.key});

  @override
  State<PresistentHeaderRoute> createState() => _PresistentHeaderRouteState();
}

class _PresistentHeaderRouteState extends State<PresistentHeaderRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Presistent Header Demo Route')),
      body: CustomScrollView(slivers: [
        buildSliverList(),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate(//有最大和最小高度
            maxHeight: 80,
            minHeight: 50,
            child: buildHeader(1),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate.fixedHeight(
            height: 50,
            child: buildHeader(2)
          ),
        ),
        buildSliverList(20)
      ]),
    );
  }

  Widget buildSliverList([int count = 5]) {
    return SliverFixedExtentList(
      itemExtent: 50,
      delegate: SliverChildBuilderDelegate((context, index) {
        return ListTile(title: Text('$index'));
      }, childCount: count),
    );
  }

  Widget buildHeader(int i) {
    return Container(
      color: Colors.lightBlue.shade200,
      alignment: Alignment.centerLeft,
      child: Text("PresistentHeader $i"),
    );
  }
}
