import 'package:flutter/material.dart';

//主要布局

class BoxStateDemo extends StatelessWidget {
  const BoxStateDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "组件自身管理状态",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TabboxA(),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "父组件管理子组件状态",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            ParentWidget(),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "混合状态管理",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            ParentWidgetC(),
          ],
        ),
      ),
    );
  }
}

class TabboxA extends StatefulWidget {
  const TabboxA({super.key});

  @override
  State<TabboxA> createState() => _TabboxAState();
}

class _TabboxAState extends State<TabboxA> {
  bool _active = false;

  void handTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: _active ? Colors.green : Colors.grey,
        ),
        child: Center(
          child: Text(
            _active ? "Active" : "Inactive",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

//父布局管理子布局
class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleParentTop(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabboxB(active: _active, onChanged: _handleParentTop),
    );
  }
}

class TabboxB extends StatelessWidget {
  TabboxB({super.key, required this.active, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  void handTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: active ? Colors.green : Colors.grey,
        ),
        child: Center(
          child: Text(
            active ? "Active" : "Inactive",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

//混合状态管理
class ParentWidgetC extends StatefulWidget {
  const ParentWidgetC({super.key});

  @override
  State<ParentWidgetC> createState() => _ParentWidgetCState();
}

class _ParentWidgetCState extends State<ParentWidgetC> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TapboxC(active: _active, onChanged: _handleTapboxChanged),
    );
  }
}

class TapboxC extends StatefulWidget {
  TapboxC({super.key, required this.active, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  State<TapboxC> createState() => _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.green[600],
          border: _highlight
              ? Border.all(color: Colors.teal, width: 10.0)
              : null,
        ),
        child: Center(
          child: Text(
            widget.active ? 'Active' : 'InActive',
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
