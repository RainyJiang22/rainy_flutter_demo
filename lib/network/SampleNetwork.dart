//简单网络加载

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SampleNetwork extends StatelessWidget {
  const SampleNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Network',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleNetworkPage(),
    );
  }
}

class SampleNetworkPage extends StatefulWidget {
  const SampleNetworkPage({super.key});

  @override
  State<StatefulWidget> createState() => SampleNetworkPageState();
}

class SampleNetworkPageState extends State<SampleNetworkPage> {
  List<Map<String, Object?>> widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Network')),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, position) {
          return getRow(position);
        }
      )
    );
  }

  Widget getRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Row ${widgets[i]["title"]}"),
    );
  }

  Future<void> loadData() async {
    final dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(dataURL);
    setState(() {
      widgets = (jsonDecode(response.body) as List)
          .cast<Map<String, Object?>>();
    });
  }
}
