
import 'package:flutter/material.dart';

class ValueListenableApp extends StatelessWidget {
  const ValueListenableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ValueListenableRoute(),
    );
  }
}


class ValueListenableRoute extends StatefulWidget {
  const ValueListenableRoute({super.key});

  @override
  State<ValueListenableRoute> createState() => _ValueListenableRouteState();
}

class _ValueListenableRouteState extends State<ValueListenableRoute> {

  ///定义一个ValueNotifier
  ///当值发生变化时候会通知ValueListenableBuilder
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    ///释放资源
    _counter.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('ValueListenableBuilder示例'),
       ),
       body: Center(
         child: ValueListenableBuilder<int>(
           valueListenable: _counter,
           builder: (BuildContext context, int value, Widget? child) {
             ///builder只在_counter变化的时候调用
             return Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 child!,
                 Text(
                   '$value 次',
                    style: const TextStyle(
                      fontSize: 24,
                       fontWeight: FontWeight.bold
                    ),
                 )
               ],
             );
           },
           child: const Text(
             '点击了',
             style: TextStyle(fontSize: 20),
           ),
         ),
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: () {
           _counter.value += 1;
         },
         child: const Icon(Icons.add),
       ),
     );
  }
}
