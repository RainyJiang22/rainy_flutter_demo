import 'package:flutter/material.dart';

class SwitchCheckBoxDemo extends StatefulWidget {
  const SwitchCheckBoxDemo({super.key});

  @override
  State<SwitchCheckBoxDemo> createState() => _SwitchCheckBoxDemoState();
}

class _SwitchCheckBoxDemoState extends State<SwitchCheckBoxDemo> {
  bool _switchSelected = true;
  bool _checkBoxSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Switch Box Demo')),
      body: Column(
        children: [
          Switch(
            value: _switchSelected,
            onChanged: (value) {
              setState(() {
                _switchSelected = value;
              });
            },
          ),
          Checkbox(
            value: _checkBoxSelected,
            activeColor: Colors.red,
            onChanged: (value) {
              setState(() {
                _checkBoxSelected = value!;
              });
            },
          )
        ],
      ),
    );
  }
}
