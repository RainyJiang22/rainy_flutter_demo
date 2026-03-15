import 'package:first_flutter_demo/scroll/sliver_widget.dart';
import 'package:flutter/material.dart';

class SnapAppBar2Demo extends StatefulWidget {
  const SnapAppBar2Demo({super.key});

  @override
  State<SnapAppBar2Demo> createState() => _SnapAppBar2DemoState();
}

class _SnapAppBar2DemoState extends State<SnapAppBar2Demo>
    with SingleTickerProviderStateMixin {
  // 将handle 缓存
  late SliverOverlapAbsorberHandle handle;

  late AnimationController _controller;

  void onOverlapChanged() {
    // 打印 overlap length
    print(handle.layoutExtent);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    handle.removeListener(onOverlapChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innserBoxIsScrolled) {
        handle = NestedScrollView.sliverOverlapAbsorberHandleFor(context);
        handle.removeListener(onOverlapChanged);
        handle.addListener(onOverlapChanged);
        return <Widget>[
          SliverOverlapAbsorber(
            handle: handle,
            sliver: SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight:200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "./images/sea.png",
                  fit: BoxFit.cover,
                ),
              ),
              forceElevated: innserBoxIsScrolled
            ),
          )
        ];
      },
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(handle: handle),
              buildSliverList(100),
            ],
          );
        },
      ),
    );
  }
}
