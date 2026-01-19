import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ListDemo extends StatelessWidget {
  const ListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const ListDemoPage());
  }
}

class ListDemoPage extends StatefulWidget {
  const ListDemoPage({super.key});

  @override
  State<StatefulWidget> createState() => _ListDemoPageState();
}

class _ListDemoPageState extends State<ListDemoPage> {
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  List<Widget> _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(
        GestureDetector(
          onTap: () {
            developer.log('row tapped $i');
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text('Row $i'),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Demo')),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, position) {
          return getRow(position);
        },
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgets.add(getRow(widgets.length));
          developer.log('row tapped $i');
        });
      },
      child: Padding(padding: const EdgeInsets.all(10), child: Text('Row $i')),
    );
  }
}
