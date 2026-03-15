

import 'package:first_flutter_demo/scroll/sliver_widget.dart';
import 'package:flutter/material.dart';

class SnapAppBarDemo extends StatelessWidget {
  const SnapAppBarDemo({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 200,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "./images/sea.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ];
      }, body:Builder(builder: (BuildContext context) {
        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            buildSliverList(100)
          ],
        );
      }),
      ),
    );
  }
}
