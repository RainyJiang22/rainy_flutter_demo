import 'package:flutter/material.dart';

class TextDemo extends StatelessWidget {
  const TextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    //富文本
    const textRich = Text.rich(
        TextSpan(
            text: 'Hello',
            children: <TextSpan>[
              TextSpan(text: 'beautful',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: 'word', style: TextStyle(fontWeight: FontWeight.bold))
            ]
        )
    );

    return Scaffold(
      appBar: AppBar(title: Text('Text Demo')),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(border: Border.all()),
                child: const Text(
                  'Hello, how are you?',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
            textRich
          ],
        ),
      ),
    );
  }
}
