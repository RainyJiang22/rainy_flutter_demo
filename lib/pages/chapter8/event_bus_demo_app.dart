import 'dart:async';

import 'package:flutter/material.dart';

class EventBusDemoApp extends StatelessWidget {
  const EventBusDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Event Bus Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const EventBusDemoPage(),
    );
  }
}

sealed class AppEvent {
  const AppEvent();
}


//登录事件
class LoginEvent extends AppEvent {
  const LoginEvent(this.userName);

  final String userName;
}

//登出事件
class LogoutEvent extends AppEvent {
  const LogoutEvent();
}

class AppEventBus {
  AppEventBus._();

  static final AppEventBus instance = AppEventBus._();


  final StreamController<AppEvent> _controller = StreamController<
      AppEvent>.broadcast();

  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void post(AppEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}

class EventBusDemoPage extends StatefulWidget {
  const EventBusDemoPage({super.key});

  @override
  State<EventBusDemoPage> createState() => _EventBusDemoPageState();
}


class _EventBusDemoPageState extends State<EventBusDemoPage> {
  StreamSubscription<LoginEvent>? _loginSubscription;
  StreamSubscription<LogoutEvent>? _logoutSubscription;
  String _status = "未登录";


  @override
  void initState() {
    super.initState();
    _loginSubscription = AppEventBus.instance.on<LoginEvent>().listen((event) {
      setState(() {
        _status = '欢迎回来，${event.userName}';
      });
    });
    _logoutSubscription =
        AppEventBus.instance.on<LogoutEvent>().listen((event) {
          setState(() {
            _status = '已退出登录';
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EventBus Demo'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _status, style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
              ),
              SizedBox(height: 24),
              FilledButton(onPressed: () {
                AppEventBus.instance.post(LoginEvent("Rainy"));
              }, child: const Text("发送登录事件")
              ),
              SizedBox(height: 24),
              OutlinedButton(onPressed: () {
                AppEventBus.instance.post(LogoutEvent());
              }, child: const Text("发送登出事件"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

