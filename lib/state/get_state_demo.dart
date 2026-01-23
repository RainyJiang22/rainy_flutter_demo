import 'package:flutter/material.dart';

class GetStateObjectRoute extends StatefulWidget {
  const GetStateObjectRoute({super.key});

  @override
  State<GetStateObjectRoute> createState() => _GetStateObjectRouteState();
}

class _GetStateObjectRouteState extends State<GetStateObjectRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('子树中获取state对象')),
      body: Center(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldState _state = context
                        .findAncestorStateOfType<ScaffoldState>()!;
                    _state.openDrawer();
                  },
                  child: Text('打开抽屉菜单1'),
                );
              },
            ),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldState _state = Scaffold.of(context);
                    _state.openDrawer();
                  },
                  child: Text('打开抽屉菜单2'),
                );
              },
            ),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("我爱flutter")));
                  },
                  child: Text("打开snackbar"),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(),
    );
  }
}
