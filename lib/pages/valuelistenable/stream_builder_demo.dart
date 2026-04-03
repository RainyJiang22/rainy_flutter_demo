import 'package:flutter/material.dart';

class StreamBuilderDemo extends StatelessWidget {
  const StreamBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StreamBuilderRoute(),
    );
  }
}

class StreamBuilderRoute extends StatefulWidget {
  const StreamBuilderRoute({super.key});

  @override
  State<StreamBuilderRoute> createState() => _StreamBuilderRouteState();
}

class _StreamBuilderRouteState extends State<StreamBuilderRoute> {
  ///创建一个每一秒发射一个数字的stream
  Stream<int> _counter() {
    return Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream Builder示例')),
      body: Center(
        child: StreamBuilder<int>(
          stream: _counter(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if(snapshot.hasError) {
              return Text('错误：${snapshot.error}');
            }

            switch(snapshot.connectionState) {
              case ConnectionState.done:
                return const Text('Stream已经关闭');
              case ConnectionState.none:
                return const Text('没有Stream');
              case ConnectionState.waiting:
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('等待数据...')
                  ],
                );
              case ConnectionState.active:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('计时器',style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 16),
                    Text(
                      '${snapshot.data}秒',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
