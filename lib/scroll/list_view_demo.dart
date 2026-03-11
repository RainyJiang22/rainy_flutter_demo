import 'package:first_flutter_demo/widget/layout/responsive_column_demo.dart';
import 'package:flutter/material.dart';

class ListViewDemo extends StatelessWidget {
  const ListViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    Widget divider1 = Divider(color: Colors.blue);
    Widget divider2 = Divider(color: Colors.yellow);

    return ListView.separated(
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("$index"));
      },
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
    );
  }
}

class FixedExtentList extends StatelessWidget {
  const FixedExtentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      prototypeItem: ListTile(title: Text("1")),
      itemBuilder: (BuildContext context, int index) {
        return LayoutLogPrint(
          tag: index,
          child: ListTile(title: Text("$index")),
        );
      },
    );
  }
}
