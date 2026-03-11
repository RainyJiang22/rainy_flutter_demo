import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class InfiniteListView extends StatefulWidget {
  const InfiniteListView({super.key});

  @override
  State<InfiniteListView> createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##";
  final _words = <String>[loadingTag];


  @override
  void initState() {
    super.initState();
    _retrieveData();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        if (_words[index] == loadingTag) {
          //不足100条，继续获取数据
          if (_words.length - 1 < 100) {
            _retrieveData();
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Text("没有更多了", style: TextStyle(color: Colors.grey)),
            );
          }
        }
        return ListTile(title: Text(_words[index]));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 1.0);
      },
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      setState(() {
        _words.insertAll(
          _words.length - 1,
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }
}
