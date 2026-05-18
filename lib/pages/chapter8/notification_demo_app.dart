import 'package:flutter/material.dart';

class NotificationDemoApp extends StatelessWidget {
  const NotificationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const NotificationDemoPage(),
    );
  }
}

class MessageNotification extends Notification {
  MessageNotification(this.message);

  final String message;
}

class NotificationDemoPage extends StatefulWidget {

  const NotificationDemoPage({super.key});

  @override
  State<NotificationDemoPage> createState() => _NotificationDemoPageState();
}

class _NotificationDemoPageState extends State<NotificationDemoPage> {
  String _message = '还没有收到子组件通知';
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: (notification) {
        if (notification is ScrollNotification &&
            notification.metrics.maxScrollExtent > 0) {
          setState(() {
            _progress = (notification.metrics.pixels /
                notification.metrics.maxScrollExtent).clamp(0.0, 1.0);
          });
        }
        if(notification is MessageNotification) {
          setState(() {
            _message = notification.message;
          });
          return true;
        }
        return false;
      }, child: Scaffold(
         appBar: AppBar(title: const Text('通知机制')),
         body: Column(
           children: [
             LinearProgressIndicator(value: _progress),
             Padding(
               padding: const EdgeInsets.all(16),
               child: Card(
                 child: ListTile(
                   title: const Text('父组件收到的消息'),
                   subtitle: Text(_message),
                 ),
               ),
             ),
             Expanded(
               child: ListView.builder(
                 itemCount: 30,
                 itemBuilder: (context,index) {
                   if (index == 0) {
                     return Builder(
                       builder: (innerContext) {
                         return Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16),
                           child: FilledButton(
                             onPressed: () {
                               MessageNotification('子组件点击了按钮').dispatch(
                                 innerContext,
                               );
                             },
                             child: const Text('发送自定义通知'),
                           ),
                         );
                       },
                     );
                   }
                   return ListTile(
                     leading: const Icon(Icons.swipe_vertical),
                     title: Text('列表项 $index'),
                     subtitle: const Text('滚动列表以观察 ScrollNotification'),
                   );
                 },
               ),
             )
           ],
         ),
    ),
    );
  }
}
