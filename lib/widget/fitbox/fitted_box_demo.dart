

import 'package:flutter/material.dart';

class FittedBoxDemo extends StatelessWidget {
  const FittedBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Fitted Fix Demo")),
      body: Center(
        child: Column(
          children: [
            wRow(' 90000000000000000 '),
            SingleLineFittedBox(child: wRow(' 90000000000000000 ')),
            wRow(' 800 '),
            SingleLineFittedBox(child: wRow(' 800 ')),
          ].map((e) => Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: e,
          )).toList()
        ),

      ),
    );
  }

  Widget wRow(String text) {
    Widget child = Text(text);
    child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [child,child,child],
    );
    return child;
  }
}

class SingleLineFittedBox extends StatelessWidget {
  const SingleLineFittedBox({super.key,this.child});
  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_,constraints) {
        return FittedBox(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minWidth: constraints.maxWidth,
              maxWidth: double.infinity
            ),
            child: child,
          ),
        );
      },
    );
  }
}

