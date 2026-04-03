import 'package:flutter/material.dart';

class FutureBuilderDemo extends StatelessWidget {
  const FutureBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FutureBuilderRoute(),
    );
  }
}

class FutureBuilderRoute extends StatefulWidget {
  const FutureBuilderRoute({super.key});

  @override
  State<FutureBuilderRoute> createState() => _FutureBuilderRouteState();
}

class _FutureBuilderRouteState extends State<FutureBuilderRoute> {
  Future<String> _mockNetworkData() async {
    await Future.delayed(const Duration(seconds: 2));
    return '这是来自网络的数据';
  }

  //缓存Future,避免每次build重新创建
  late final Future<String> _future = _mockNetworkData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FutureBuilder示例')),
      body: Center(
        child: FutureBuilder<String>(
          future: _future,
          initialData: '正在加载数据....',
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasError) {
                //请求失败
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red,size: 48),
                    const SizedBox(height: 16),
                    Text('错误：${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          
                        });
                      }, child: const Text('重试'),
                    )
                  ],
                );
              } else{
                //请求成功
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle,color: Colors.green,size: 48),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.data ?? 'default value',
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                );
              }
            } else {
              //请求进行中
              return _loading();
            }
          },
        ),
      ),
    );
  }

  Widget _loading() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text("加载中")
      ],
    );
  }

}
